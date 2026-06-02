#!/usr/bin/env python3
from __future__ import annotations

import argparse
import shutil
import subprocess
import sys
from pathlib import Path
from typing import Iterable

# =============================================================================
# Path setup
# =============================================================================
#
# BASE_DIR is the bidirectional/ directory.
# All other paths are resolved relative to this script location, so the runner
# can be executed from the bidirectional directory without hard-coding absolute
# paths.

BASE_DIR = Path(__file__).resolve().parent

REPORTS_DIR = BASE_DIR / "reports"
LOGS_DIR = BASE_DIR / "logs"

RUNNERS_DIR = BASE_DIR / "runners"
CONFIG_DIR = BASE_DIR / "config"
CASES_DIR = BASE_DIR / "cases"
GENERATED_DIR = BASE_DIR / "generated"

PROFILE_FILE = CONFIG_DIR / "testbench_profile.pl"


# =============================================================================
# Expected generated artifacts
# =============================================================================
#
# These are the files produced by the Prolog runners.
# They are cleaned before each run and archived after each run.
#
# The generated/ directory is the active working output area.
# The reports/<label>/ directory stores a copy of the generated outputs for a
# named experiment run.

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

SINGLE_MODE_FILES = [
    GENERATED_DIR / "single_generate_report.txt",
    GENERATED_DIR / "single_parse_report.txt",
]

ALL_OUTPUTS = GEN_TO_PARSE_FILES + PARSE_TO_GEN_FILES + SINGLE_MODE_FILES


# =============================================================================
# Mode aliases
# =============================================================================
#
# The current terminology is:
#   gen_to_parse = Generation-to-Parsing
#   parse_to_gen = Parsing-to-Generation
#
# The aliases forward/reverse are kept only for convenience/backward
# compatibility when running from the command line.

MODE_ALIASES = {
    "forward": "gen_to_parse",
    "reverse": "parse_to_gen",
}


# =============================================================================
# Directory and cleanup helpers
# =============================================================================

def ensure_dirs() -> None:
    """Create required working directories if they do not already exist."""
    REPORTS_DIR.mkdir(exist_ok=True)
    LOGS_DIR.mkdir(exist_ok=True)
    CONFIG_DIR.mkdir(exist_ok=True)
    CASES_DIR.mkdir(exist_ok=True)
    GENERATED_DIR.mkdir(exist_ok=True)


def cleanup_outputs() -> None:
    """Remove previously generated active output files before a new run."""
    for file in ALL_OUTPUTS:
        if file.exists():
            file.unlink()


# =============================================================================
# Prolog execution
# =============================================================================

def run_prolog(
    script_name: str,
    log_name: str,
    prolog_args: list[str] | None = None,
) -> None:
    """
    Run one Prolog runner script and write stdout/stderr to a log file.

    The script is executed with cwd=RUNNERS_DIR because the Prolog files use
    relative paths such as ../config/... and ../generated/....

    Optional prolog_args are passed after "--", which makes them available to
    the Prolog runner through current_prolog_flag(argv, Args). This is used by
    single-case diagnostic modes.

    If SWI-Prolog returns a non-zero exit code, the Python runner stops and
    points the user to the corresponding log file.
    """
    script_path = RUNNERS_DIR / script_name
    log_path = LOGS_DIR / log_name

    cmd = ["swipl", "-q", "-f", script_path.name]

    if prolog_args:
        cmd.extend(["--", *prolog_args])

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


# =============================================================================
# Archiving and report preview
# =============================================================================

def archive_outputs(label: str | None) -> None:
    """
    Copy generated outputs into reports/<label>/.

    If the same label already exists, it is removed first. This avoids stale
    files from older runs remaining in the archive directory.
    """
    existing = [p for p in ALL_OUTPUTS if p.exists()]
    if not existing:
        print("No outputs found to archive.")
        return

    target_dir = REPORTS_DIR / (label or "latest")

    if target_dir.exists():
        shutil.rmtree(target_dir)

    target_dir.mkdir(parents=True, exist_ok=True)

    for src in existing:
        shutil.copy2(src, target_dir / src.name)

    print(f"\nArchived outputs to: {target_dir}")


def print_report_file(report_path: Path) -> None:
    """
    Print a short generated report to the terminal.

    This is intended for single-case diagnostic modes, where the report is
    small enough to be useful directly in the console.
    """
    if not report_path.exists():
        print(f"\nReport file was not created: {report_path}")
        return

    print("\n=== Diagnostic Report Preview ===")
    print(report_path.read_text(encoding="utf-8"))


# =============================================================================
# Profile reading
# =============================================================================

def extract_profile_value(profile_text: str, predicate: str) -> str | None:
    """
    Extract a simple one-argument Prolog fact from testbench_profile.pl.

    Example:
        profile_name('english_numbers_profile').

    This helper is intentionally simple. It is only used to print a readable
    run summary and to check that required case files exist.
    """
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
    """
    Print the active experiment profile summary before running the testbench.

    This makes each command-line run easier to verify because the user can see
    which profile, lexicons, test case files, normalization settings, and timeout
    value are active.
    """
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

    normalization_enabled = extract_profile_value(profile_text, "smoothing_enabled")
    normalization_style = extract_profile_value(profile_text, "smoothing_style")
    adapter_timeout = extract_profile_value(profile_text, "adapter_timeout_seconds")

    print(f"Active profile:      {profile_name}")
    print(f"Generator lexicon:   {gen_lexicon}")
    print(f"Parser lexicon:      {parser_lexicon}")
    print(f"Semantic cases file: {semantic_cases}")
    print(f"Token cases file:    {token_cases}")
    print(f"Token normalization: {normalization_enabled}")
    print(f"Normalization style: {normalization_style}")
    print(f"Adapter timeout:     {adapter_timeout} seconds")

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


# =============================================================================
# CLI parsing
# =============================================================================

def normalize_mode(mode: str) -> str:
    """Map legacy mode aliases to current mode names."""
    return MODE_ALIASES.get(mode, mode)


def parse_args(argv: Iterable[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Run the MG bidirectional testbench."
    )

    parser.add_argument(
        "--mode",
        choices=[
            "gen_to_parse",
            "parse_to_gen",
            "both",
            "single_gen",
            "single_parse",
            "forward",
            "reverse",
        ],
        default="both",
        help=(
            "Which validation pipeline to execute. "
            "Use gen_to_parse or parse_to_gen for batch validation. "
            "Use single_gen or single_parse for single-case diagnostics. "
            "Legacy aliases forward/reverse are still accepted."
        ),
    )

    parser.add_argument(
        "--label",
        default=None,
        help=(
            "Archive label under reports/. "
            "If omitted, outputs are archived under reports/latest/."
        ),
    )

    parser.add_argument(
        "--semantic",
        default=None,
        help="Semantic input for --mode single_gen, for example: \"'1X+20'(7)\".",
    )

    parser.add_argument(
        "--tokens",
        default=None,
        help="Token input for --mode single_parse, for example: \"[twenty_,seven]\".",
    )

    return parser.parse_args(list(argv))


# =============================================================================
# Main orchestration
# =============================================================================

def main(argv: Iterable[str]) -> int:
    args = parse_args(argv)
    mode = normalize_mode(args.mode)

    ensure_dirs()
    print_existing_case_info()

    print("\n=== Cleaning previous generated outputs ===")
    cleanup_outputs()

    if mode == "single_gen":
        if args.semantic is None:
            raise RuntimeError("--mode single_gen requires --semantic")

        run_prolog(
            "single_generate.pl",
            "single_generate.log",
            [args.semantic],
        )

        print_report_file(GENERATED_DIR / "single_generate_report.txt")

        archive_outputs(args.label)
        print("\n=== Done ===")
        return 0

    if mode == "single_parse":
        if args.tokens is None:
            raise RuntimeError("--mode single_parse requires --tokens")

        run_prolog(
            "single_parse.pl",
            "single_parse.log",
            [args.tokens],
        )

        print_report_file(GENERATED_DIR / "single_parse_report.txt")

        archive_outputs(args.label)
        print("\n=== Done ===")
        return 0

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