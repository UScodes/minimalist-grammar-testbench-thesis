#!/usr/bin/env python3
from __future__ import annotations

import argparse
import shutil
import subprocess
import sys
from pathlib import Path
from typing import Iterable

BASE_DIR = Path(__file__).resolve().parent
REPORTS_DIR = BASE_DIR / "reports"
LOGS_DIR = BASE_DIR / "logs"

RUNNERS_DIR = BASE_DIR / "runners"
CONFIG_DIR = BASE_DIR / "config"
CASES_DIR = BASE_DIR / "cases"
GENERATED_DIR = BASE_DIR / "generated"

PROFILE_FILE = CONFIG_DIR / "testbench_profile.pl"

GEN_TO_PARSE_FILES = [
    GENERATED_DIR / "gen_to_parse_gen_out.pl",
    GENERATED_DIR / "gen_to_parse_parse_out.pl",
    GENERATED_DIR / "gen_to_parse_generation_trees.txt",
    GENERATED_DIR / "gen_to_parse_parsing_trees.txt",
    GENERATED_DIR / "gen_to_parse_report.txt",
]

PARSE_TO_GEN_FILES = [
    GENERATED_DIR / "parse_to_gen_parse_out.pl",
    GENERATED_DIR / "parse_to_gen_gen_out.pl",
    GENERATED_DIR / "parse_to_gen_parsing_trees.txt",
    GENERATED_DIR / "parse_to_gen_generation_trees.txt",
    GENERATED_DIR / "parse_to_gen_report.txt",
]

ALL_OUTPUTS = GEN_TO_PARSE_FILES + PARSE_TO_GEN_FILES

MODE_ALIASES = {
    "forward": "gen_to_parse",
    "reverse": "parse_to_gen",
}


def ensure_dirs() -> None:
    REPORTS_DIR.mkdir(exist_ok=True)
    LOGS_DIR.mkdir(exist_ok=True)
    CONFIG_DIR.mkdir(exist_ok=True)
    CASES_DIR.mkdir(exist_ok=True)
    GENERATED_DIR.mkdir(exist_ok=True)


def cleanup_outputs() -> None:
    for file in ALL_OUTPUTS:
        if file.exists():
            file.unlink()


def run_prolog(script_name: str, log_name: str) -> None:
    script_path = RUNNERS_DIR / script_name
    log_path = LOGS_DIR / log_name

    cmd = ["swipl", "-q", "-f", script_path.name]
    print(f"\n>>> Running {script_name}")

    with log_path.open("w", encoding="utf-8") as logf:
        proc = subprocess.run(
            cmd,
            cwd=RUNNERS_DIR,
            stdout=logf,
            stderr=subprocess.STDOUT,
            text=True,
        )

    if proc.returncode != 0:
        raise RuntimeError(
            f"{script_name} failed with exit code {proc.returncode}. "
            f"See log: {log_path}"
        )

    print(f"OK: {script_name} (log: {log_path})")


def archive_outputs(label: str | None) -> None:
    existing = [p for p in ALL_OUTPUTS if p.exists()]
    if not existing:
        print("No outputs found to archive.")
        return

    target_dir = REPORTS_DIR / (label or "latest")
    target_dir.mkdir(parents=True, exist_ok=True)

    for src in existing:
        shutil.copy2(src, target_dir / src.name)

    print(f"\nArchived outputs to: {target_dir}")


def extract_profile_value(profile_text: str, predicate: str) -> str | None:
    needle = f"{predicate}("
    for line in profile_text.splitlines():
        stripped = line.strip()
        if not stripped.startswith(needle):
            continue
        value = stripped[len(needle):]
        if value.endswith(")."):
            value = value[:-2]
        return value.strip().strip("'")
    return None


def print_existing_case_info() -> None:
    print("=== Using active testbench profile ===")
    print(f"Profile file: {PROFILE_FILE}")

    if not PROFILE_FILE.exists():
        raise FileNotFoundError(f"Missing profile file: {PROFILE_FILE}")

    profile_text = PROFILE_FILE.read_text(encoding="utf-8")

    profile_name = extract_profile_value(profile_text, "profile_name")
    semantic_cases = extract_profile_value(profile_text, "semantic_cases_file")
    token_cases = extract_profile_value(profile_text, "token_cases_file")
    gen_lexicon = extract_profile_value(profile_text, "generator_lexicon_name")
    parser_lexicon = extract_profile_value(profile_text, "parser_lexicon_name")

    print(f"Active profile:      {profile_name}")
    print(f"Generator lexicon:   {gen_lexicon}")
    print(f"Parser lexicon:      {parser_lexicon}")
    print(f"Semantic cases file: {semantic_cases}")
    print(f"Token cases file:    {token_cases}")

    if semantic_cases is None:
        raise RuntimeError("Could not read semantic_cases_file/1 from testbench_profile.pl")
    if token_cases is None:
        raise RuntimeError("Could not read token_cases_file/1 from testbench_profile.pl")

    semantic_cases_path = (RUNNERS_DIR / semantic_cases).resolve()
    token_cases_path = (RUNNERS_DIR / token_cases).resolve()

    if not semantic_cases_path.exists():
        raise FileNotFoundError(f"Missing semantic case file: {semantic_cases_path}")
    if not token_cases_path.exists():
        raise FileNotFoundError(f"Missing token case file: {token_cases_path}")


def normalize_mode(mode: str) -> str:
    return MODE_ALIASES.get(mode, mode)


def parse_args(argv: Iterable[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Run the MG bidirectional testbench."
    )
    parser.add_argument(
        "--mode",
        choices=["gen_to_parse", "parse_to_gen", "both", "forward", "reverse"],
        default="both",
        help=(
            "Which validation pipeline to execute. "
            "Use gen_to_parse or parse_to_gen. "
            "Legacy aliases forward/reverse are still accepted."
        ),
    )
    parser.add_argument(
        "--label",
        default=None,
        help="Archive label under reports/",
    )
    return parser.parse_args(list(argv))


def main(argv: Iterable[str]) -> int:
    args = parse_args(argv)
    mode = normalize_mode(args.mode)

    ensure_dirs()
    print_existing_case_info()

    print("\n=== Cleaning previous generated outputs ===")
    cleanup_outputs()

    if mode in ("gen_to_parse", "both"):
        run_prolog("gen_to_parse_generate.pl", "gen_to_parse_generate.log")
        run_prolog("gen_to_parse_parse.pl", "gen_to_parse_parse.log")
        run_prolog("gen_to_parse_compare.pl", "gen_to_parse_compare.log")

    if mode in ("parse_to_gen", "both"):
        run_prolog("parse_to_gen_parse.pl", "parse_to_gen_parse.log")
        run_prolog("parse_to_gen_generate.pl", "parse_to_gen_generate.log")
        run_prolog("parse_to_gen_compare.pl", "parse_to_gen_compare.log")

    archive_outputs(args.label)

    print("\n=== Done ===")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main(sys.argv[1:]))
    except Exception as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        raise