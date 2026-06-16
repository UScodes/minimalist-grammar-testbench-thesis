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
PROTOCOL_LOG = LOGS_DIR / "protocol.log"

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
# Terminal localization
# =============================================================================
#
# The terminal language is selected through:
#
#     report_language(en).
#     report_language(de).
#
# in config/testbench_profile.pl.
#
# This only affects human-facing terminal messages. Internal identifiers,
# runner script names, file paths, labels, and generated Prolog data remain
# unchanged.

SUPPORTED_LANGUAGES = {"en", "de"}

MESSAGES = {
    "en": {
        "active_profile_header": "=== Using active testbench profile ===",
        "profile_file": "Profile file",
        "active_profile": "Active profile",
        "generator_lexicon": "Generator lexicon",
        "parser_lexicon": "Parser lexicon",
        "semantic_cases_file": "Semantic cases file",
        "token_cases_file": "Token cases file",
        "token_normalization": "Token normalization",
        "normalization_style": "Normalization style",
        "normalization_rule_set": "Normalization rule set",
        "report_language": "Report language",
        "adapter_timeout": "Adapter timeout",
        "seconds": "seconds",
        "cleaning": "=== Cleaning previous generated outputs and protocol log ===",
        "running": "Running",
        "ok": "OK",
        "log": "log",
        "no_outputs": "No outputs found to archive.",
        "archived_outputs": "Archived outputs to",
        "diagnostic_preview": "=== Diagnostic Report Preview ===",
        "report_missing": "Report file was not created",
        "done": "=== Done ===",
        "error": "ERROR",
        "missing_profile": "Missing profile file",
        "missing_semantic_cases": "Missing semantic case file",
        "missing_token_cases": "Missing token case file",
        "missing_semantic_fact": "Could not read semantic_cases_file/1 from testbench_profile.pl",
        "missing_token_fact": "Could not read token_cases_file/1 from testbench_profile.pl",
        "single_gen_requires_semantic": "--mode single_gen requires --semantic",
        "single_parse_requires_tokens": "--mode single_parse requires --tokens",
        "prolog_failed": "failed with exit code",
        "see_log": "See log",
    },
    "de": {
        "active_profile_header": "=== Aktives Testbench-Profil ===",
        "profile_file": "Profildatei",
        "active_profile": "Aktives Profil",
        "generator_lexicon": "Generator-Lexikon",
        "parser_lexicon": "Parser-Lexikon",
        "semantic_cases_file": "Semantische Testfälle",
        "token_cases_file": "Token-Testfälle",
        "token_normalization": "Token-Normalisierung",
        "normalization_style": "Normalisierungsstil",
        "normalization_rule_set": "Normalisierungsregelsatz",
        "report_language": "Berichtssprache",
        "adapter_timeout": "Adapter-Zeitlimit",
        "seconds": "Sekunden",
        "cleaning": "=== Vorherige Ausgaben und Protokolllog werden bereinigt ===",
        "running": "Starte",
        "ok": "OK",
        "log": "Log",
        "no_outputs": "Keine Ausgaben zum Archivieren gefunden.",
        "archived_outputs": "Ausgaben archiviert unter",
        "diagnostic_preview": "=== Vorschau des Diagnoseberichts ===",
        "report_missing": "Berichtsdatei wurde nicht erstellt",
        "done": "=== Fertig ===",
        "error": "FEHLER",
        "missing_profile": "Profildatei fehlt",
        "missing_semantic_cases": "Datei mit semantischen Testfällen fehlt",
        "missing_token_cases": "Datei mit Token-Testfällen fehlt",
        "missing_semantic_fact": "semantic_cases_file/1 konnte nicht aus testbench_profile.pl gelesen werden",
        "missing_token_fact": "token_cases_file/1 konnte nicht aus testbench_profile.pl gelesen werden",
        "single_gen_requires_semantic": "--mode single_gen benötigt --semantic",
        "single_parse_requires_tokens": "--mode single_parse benötigt --tokens",
        "prolog_failed": "ist mit Exit-Code fehlgeschlagen",
        "see_log": "Siehe Log",
    },
}


def normalize_language(language: str | None) -> str:
    """Return a supported report language, falling back to English."""
    if language is None:
        return "en"

    language = language.strip().lower()

    if language in SUPPORTED_LANGUAGES:
        return language

    return "en"


def msg(language: str, key: str) -> str:
    """Return a localized terminal message."""
    return MESSAGES.get(language, MESSAGES["en"]).get(
        key,
        MESSAGES["en"].get(key, key),
    )


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


def cleanup_protocol_log() -> None:
    """
    Remove the structured Prolog protocol log before a new run.

    Stage logs are already overwritten by run_prolog(...), because each stage
    opens its own log file in write mode. The protocol log is different: the
    Prolog logger appends to it, so the Python runner clears it once at the
    start of every run to avoid mixing old and new testbench versions.
    """
    if PROTOCOL_LOG.exists():
        PROTOCOL_LOG.unlink()


# =============================================================================
# Prolog execution
# =============================================================================

def run_prolog(
    script_name: str,
    log_name: str,
    language: str,
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

    print(f"\n>>> {msg(language, 'running')} {script_name}")

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
            f"{script_name} {msg(language, 'prolog_failed')} {proc.returncode}. "
            f"{msg(language, 'see_log')}: {log_path}"
        )

    print(f"{msg(language, 'ok')}: {script_name} ({msg(language, 'log')}: {log_path})")


# =============================================================================
# Archiving and report preview
# =============================================================================

def archive_outputs(label: str | None, language: str) -> None:
    """
    Copy generated outputs into reports/<label>/.

    If the same label already exists, it is removed first. This avoids stale
    files from older runs remaining in the archive directory.
    """
    existing = [p for p in ALL_OUTPUTS if p.exists()]
    if not existing:
        print(msg(language, "no_outputs"))
        return

    target_dir = REPORTS_DIR / (label or "latest")

    if target_dir.exists():
        shutil.rmtree(target_dir)

    target_dir.mkdir(parents=True, exist_ok=True)

    for src in existing:
        shutil.copy2(src, target_dir / src.name)

    print(f"\n{msg(language, 'archived_outputs')}: {target_dir}")


def print_report_file(report_path: Path, language: str) -> None:
    """
    Print a short generated report to the terminal.

    This is intended for single-case diagnostic modes, where the report is
    small enough to be useful directly in the console.
    """
    if not report_path.exists():
        print(f"\n{msg(language, 'report_missing')}: {report_path}")
        return

    print(f"\n{msg(language, 'diagnostic_preview')}")
    print(report_path.read_text(encoding="utf-8"))


# =============================================================================
# Profile reading
# =============================================================================

def extract_profile_value(profile_text: str, predicate: str) -> str | None:
    """
    Extract a simple one-argument Prolog fact from testbench_profile.pl.

    This skips:
      - single-line comments starting with %
      - block comments between /* and */

    Example:
        profile_name('english_numbers_profile').
    """
    needle = f"{predicate}("
    in_block_comment = False

    for line in profile_text.splitlines():
        stripped = line.strip()

        if not stripped:
            continue

        # Handle block comments.
        if "/*" in stripped:
            in_block_comment = True

            # If comment starts and ends on the same line, ignore that line only.
            if "*/" in stripped and stripped.index("*/") > stripped.index("/*"):
                in_block_comment = False

            continue

        if in_block_comment:
            if "*/" in stripped:
                in_block_comment = False
            continue

        # Skip single-line comments.
        if stripped.startswith("%"):
            continue

        if not stripped.startswith(needle):
            continue

        value = stripped[len(needle):]

        if value.endswith(")."):
            value = value[:-2]

        return value.strip().strip("'")

    return None

def read_profile_text() -> str:
    """Read the active profile file."""
    if not PROFILE_FILE.exists():
        raise FileNotFoundError(f"{msg('en', 'missing_profile')}: {PROFILE_FILE}")

    return PROFILE_FILE.read_text(encoding="utf-8")


def read_report_language(profile_text: str) -> str:
    """Read report_language/1 from the active profile, defaulting to English."""
    return normalize_language(extract_profile_value(profile_text, "report_language"))


def print_existing_case_info(profile_text: str, language: str) -> None:
    """
    Print the active experiment profile summary before running the testbench.

    This makes each command-line run easier to verify because the user can see
    which profile, lexicons, test case files, normalization settings, report
    language, and timeout value are active.
    """
    print(msg(language, "active_profile_header"))
    print(f"{msg(language, 'profile_file')}: {PROFILE_FILE}")

    profile_name = extract_profile_value(profile_text, "profile_name")
    semantic_cases = extract_profile_value(profile_text, "semantic_cases_file")
    token_cases = extract_profile_value(profile_text, "token_cases_file")
    gen_lexicon = extract_profile_value(profile_text, "generator_lexicon_name")
    parser_lexicon = extract_profile_value(profile_text, "parser_lexicon_name")

    normalization_enabled = extract_profile_value(profile_text, "smoothing_enabled")
    normalization_style = extract_profile_value(profile_text, "smoothing_style")
    normalization_rule_set = extract_profile_value(profile_text, "smoothing_rule_set")
    adapter_timeout = extract_profile_value(profile_text, "adapter_timeout_seconds")

    print(f"{msg(language, 'active_profile')}:          {profile_name}")
    print(f"{msg(language, 'generator_lexicon')}:       {gen_lexicon}")
    print(f"{msg(language, 'parser_lexicon')}:          {parser_lexicon}")
    print(f"{msg(language, 'semantic_cases_file')}:     {semantic_cases}")
    print(f"{msg(language, 'token_cases_file')}:        {token_cases}")
    print(f"{msg(language, 'token_normalization')}:     {normalization_enabled}")
    print(f"{msg(language, 'normalization_style')}:     {normalization_style}")
    print(f"{msg(language, 'normalization_rule_set')}: {normalization_rule_set}")
    print(f"{msg(language, 'report_language')}:         {language}")
    print(f"{msg(language, 'adapter_timeout')}:        {adapter_timeout} {msg(language, 'seconds')}")

    if semantic_cases is None:
        raise RuntimeError(msg(language, "missing_semantic_fact"))

    if token_cases is None:
        raise RuntimeError(msg(language, "missing_token_fact"))

    semantic_cases_path = (RUNNERS_DIR / semantic_cases).resolve()
    token_cases_path = (RUNNERS_DIR / token_cases).resolve()

    if not semantic_cases_path.exists():
        raise FileNotFoundError(f"{msg(language, 'missing_semantic_cases')}: {semantic_cases_path}")

    if not token_cases_path.exists():
        raise FileNotFoundError(f"{msg(language, 'missing_token_cases')}: {token_cases_path}")


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

    profile_text = read_profile_text()
    language = read_report_language(profile_text)
   

    print_existing_case_info(profile_text, language)

    print(f"\n{msg(language, 'cleaning')}")
    cleanup_outputs()
    cleanup_protocol_log()

    if mode == "single_gen":
        if args.semantic is None:
            raise RuntimeError(msg(language, "single_gen_requires_semantic"))

        run_prolog(
            "single_generate.pl",
            "single_generate.log",
            language,
            [args.semantic],
        )

        print_report_file(GENERATED_DIR / "single_generate_report.txt", language)

        archive_outputs(args.label, language)
        print(f"\n{msg(language, 'done')}")
        return 0

    if mode == "single_parse":
        if args.tokens is None:
            raise RuntimeError(msg(language, "single_parse_requires_tokens"))

        run_prolog(
            "single_parse.pl",
            "single_parse.log",
            language,
            [args.tokens],
        )

        print_report_file(GENERATED_DIR / "single_parse_report.txt", language)

        archive_outputs(args.label, language)
        print(f"\n{msg(language, 'done')}")
        return 0

    if mode in ("gen_to_parse", "both"):
        run_prolog("gen_to_parse_generate.pl", "gen_to_parse_generate.log", language)
        run_prolog("gen_to_parse_parse.pl", "gen_to_parse_parse.log", language)
        run_prolog("gen_to_parse_compare.pl", "gen_to_parse_compare.log", language)

    if mode in ("parse_to_gen", "both"):
        run_prolog("parse_to_gen_parse.pl", "parse_to_gen_parse.log", language)
        run_prolog("parse_to_gen_generate.pl", "parse_to_gen_generate.log", language)
        run_prolog("parse_to_gen_compare.pl", "parse_to_gen_compare.log", language)

    archive_outputs(args.label, language)

    print(f"\n{msg(language, 'done')}")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main(sys.argv[1:]))
    except Exception as exc:
        profile_language = "en"

        try:
            if PROFILE_FILE.exists():
                profile_language = read_report_language(PROFILE_FILE.read_text(encoding="utf-8"))
        except Exception:
            profile_language = "en"

        print(f"{msg(profile_language, 'error')}: {exc}", file=sys.stderr)
        raise