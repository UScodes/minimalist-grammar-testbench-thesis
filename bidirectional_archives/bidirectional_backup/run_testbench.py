from __future__ import annotations

import argparse
import shutil
import subprocess
from datetime import datetime
from pathlib import Path


BASE_DIR = Path(__file__).resolve().parent
REPORTS_DIR = BASE_DIR / "reports"
LOGS_DIR = BASE_DIR / "logs"

GEN_RUN = BASE_DIR / "gen_run.pl"
PARSE_RUN = BASE_DIR / "parse_run.pl"
COMPARE_RUN = BASE_DIR / "compare.pl"

REVERSE_PARSE_RUN = BASE_DIR / "reverse_parse_run.pl"
REVERSE_GEN_RUN = BASE_DIR / "reverse_gen_run.pl"
COMPARE_REVERSE_RUN = BASE_DIR / "compare_reverse.pl"

TEST_CASES = BASE_DIR / "test_cases.pl"
TOKEN_CASES = BASE_DIR / "token_cases.pl"

GEN_OUT = BASE_DIR / "gen_out.pl"
PARSE_OUT = BASE_DIR / "parse_out.pl"
FORWARD_REPORT = BASE_DIR / "bidir_report.txt"
FORWARD_TREE_REPORT = BASE_DIR / "forward_tree_report.txt"

REVERSE_OUT = BASE_DIR / "reverse_out.pl"
REVERSE_REPORT = BASE_DIR / "reverse_report.txt"

PROTOCOL_LOG = LOGS_DIR / "protocol.log"


def run_command(cmd: list[str], cwd: Path) -> None:
    print(f"\n>>> Running: {' '.join(cmd)}")
    result = subprocess.run(cmd, cwd=str(cwd), check=False)
    if result.returncode != 0:
        raise RuntimeError(f"Command failed with exit code {result.returncode}: {' '.join(cmd)}")


def ensure_dirs() -> None:
    REPORTS_DIR.mkdir(exist_ok=True)
    LOGS_DIR.mkdir(exist_ok=True)


def write_manual_test_cases(path: Path) -> None:
    content = """test_case(1).
test_case(2).
test_case(3).
test_case(4).
test_case(5).
test_case(6).
test_case(7).
test_case(8).
test_case(9).

test_case(10).
test_case(11).
test_case(12).
test_case(13).
test_case(15).
test_case(18).
test_case(20).
test_case(30).
test_case(50).

test_case('1X+10'(4)).
test_case('1X+10'(6)).
test_case('1X+10'(7)).
test_case('0X+18'(8)).
test_case('1X+10'(9)).

test_case('1X+20'(1)).
test_case('1X+20'(2)).
test_case('1X+20'(3)).
test_case('1X+20'(4)).
test_case('1X+20'(5)).
test_case('1X+20'(6)).
test_case('1X+20'(7)).
test_case('1X+20'(8)).
test_case('1X+20'(9)).

test_case('1X+30'(1)).
test_case('1X+30'(2)).
test_case('1X+30'(3)).
test_case('1X+30'(4)).
test_case('1X+30'(5)).
test_case('1X+30'(6)).
test_case('1X+30'(7)).
test_case('1X+30'(8)).
test_case('1X+30'(9)).

test_case('1X+50'(1)).
test_case('1X+50'(2)).
test_case('1X+50'(3)).
test_case('1X+50'(4)).
test_case('1X+50'(5)).
test_case('1X+50'(6)).
test_case('1X+50'(7)).
test_case('1X+50'(8)).
test_case('1X+50'(9)).

test_case('1X+40'(4)).
test_case('1X+60'(4)).
test_case('1X+70'(4)).
test_case('1X+80'(4)).
test_case('1X+90'(4)).
"""
    path.write_text(content, encoding="utf-8")


def write_manual_token_cases(path: Path) -> None:
    content = """token_case([one]).
token_case([two]).
token_case([three]).
token_case([four]).
token_case([five]).
token_case([six]).
token_case([seven]).
token_case([eight]).
token_case([nine]).

token_case([ten]).
token_case([eleven]).
token_case([twelve]).
token_case([thirteen]).
token_case([fifteen]).

token_case([four,teen]).
token_case([eight,een]).

token_case([twenty]).
token_case([thirty]).
token_case([fifty]).

token_case([twenty_,one]).
token_case([twenty_,two]).
token_case([twenty_,three]).
token_case([twenty_,four]).
token_case([twenty_,five]).
token_case([twenty_,six]).
token_case([twenty_,seven]).
token_case([twenty_,eight]).
token_case([twenty_,nine]).

token_case([thirty_,one]).
token_case([thirty_,two]).
token_case([thirty_,three]).
token_case([thirty_,four]).
token_case([thirty_,five]).
token_case([thirty_,six]).
token_case([thirty_,seven]).
token_case([thirty_,eight]).
token_case([thirty_,nine]).

token_case([fifty_,one]).
token_case([fifty_,two]).
token_case([fifty_,three]).
token_case([fifty_,four]).
token_case([fifty_,five]).
token_case([fifty_,six]).
token_case([fifty_,seven]).
token_case([fifty_,eight]).
token_case([fifty_,nine]).
"""
    path.write_text(content, encoding="utf-8")


def sem_term_for_number(n: int) -> str | None:
    if 1 <= n <= 13:
        return str(n)
    if n == 15:
        return "15"
    if n == 18:
        return "18"
    if n in (20, 30, 50):
        return str(n)

    if n == 14:
        return "'1X+10'(4)"
    if n == 16:
        return "'1X+10'(6)"
    if n == 17:
        return "'1X+10'(7)"
    if n == 19:
        return "'1X+10'(9)"

    if 21 <= n <= 29:
        return f"'1X+20'({n - 20})"
    if 31 <= n <= 39:
        return f"'1X+30'({n - 30})"
    if 51 <= n <= 59:
        return f"'1X+50'({n - 50})"

    if n == 44:
        return "'1X+40'(4)"
    if n == 64:
        return "'1X+60'(4)"
    if n == 74:
        return "'1X+70'(4)"
    if n == 84:
        return "'1X+80'(4)"
    if n == 94:
        return "'1X+90'(4)"

    return None


def write_range_test_cases(path: Path, max_n: int) -> None:
    lines: list[str] = []
    for n in range(1, max_n + 1):
        term = sem_term_for_number(n)
        if term is not None:
            lines.append(f"test_case({term}).")
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def snapshot_outputs(label: str, mode: str) -> None:
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    snapshot_dir = REPORTS_DIR / f"{timestamp}_{label}_{mode}"
    snapshot_dir.mkdir(parents=True, exist_ok=True)

    files_to_copy = [
        TEST_CASES,
        TOKEN_CASES,
        GEN_OUT,
        PARSE_OUT,
        FORWARD_REPORT,
        FORWARD_TREE_REPORT,
        REVERSE_OUT,
        REVERSE_REPORT,
        PROTOCOL_LOG,
    ]

    for file_path in files_to_copy:
        if file_path.exists():
            shutil.copy2(file_path, snapshot_dir / file_path.name)

    print(f"\nSaved snapshot to: {snapshot_dir}")


def run_forward() -> None:
    print("\n=== Running forward pipeline ===")
    run_command(["swipl", "-q", "-s", GEN_RUN.name], BASE_DIR)
    run_command(["swipl", "-q", "-s", PARSE_RUN.name], BASE_DIR)
    run_command(["swipl", "-q", "-s", COMPARE_RUN.name], BASE_DIR)


def run_reverse() -> None:
    print("\n=== Running reverse pipeline ===")
    run_command(["swipl", "-q", "-s", REVERSE_PARSE_RUN.name], BASE_DIR)
    run_command(["swipl", "-q", "-s", REVERSE_GEN_RUN.name], BASE_DIR)
    run_command(["swipl", "-q", "-s", COMPARE_REVERSE_RUN.name], BASE_DIR)


def main() -> None:
    parser = argparse.ArgumentParser(description="Run MG bidirectional testbench")
    parser.add_argument(
        "--mode",
        choices=["forward", "reverse", "both"],
        default="forward",
        help="Which pipeline direction to run"
    )
    parser.add_argument(
        "--source",
        choices=["manual", "range"],
        default="manual",
        help="How to build test_cases.pl"
    )
    parser.add_argument(
        "--max",
        type=int,
        default=99,
        help="Maximum number for range mode"
    )
    parser.add_argument(
        "--label",
        type=str,
        default="run",
        help="Label for saved report snapshot"
    )
    args = parser.parse_args()

    ensure_dirs()

    print("=== Preparing test cases ===")
    if args.source == "manual":
        write_manual_test_cases(TEST_CASES)
        write_manual_token_cases(TOKEN_CASES)
    elif args.source == "range":
        write_range_test_cases(TEST_CASES, args.max)
        write_manual_token_cases(TOKEN_CASES)

    print(f"Semantic cases written to: {TEST_CASES}")
    print(f"Token cases written to:    {TOKEN_CASES}")

    if args.mode == "forward":
        run_forward()
    elif args.mode == "reverse":
        run_reverse()
    elif args.mode == "both":
        run_forward()
        run_reverse()

    snapshot_outputs(args.label, args.mode)

    print("\n=== Done ===")
    if args.mode in ("forward", "both") and FORWARD_REPORT.exists():
        print(f"Forward report:      {FORWARD_REPORT}")
    if args.mode in ("forward", "both") and FORWARD_TREE_REPORT.exists():
        print(f"Forward tree report: {FORWARD_TREE_REPORT}")
    if args.mode in ("reverse", "both") and REVERSE_REPORT.exists():
        print(f"Reverse report:      {REVERSE_REPORT}")
    if PROTOCOL_LOG.exists():
        print(f"Protocol log:        {PROTOCOL_LOG}")


if __name__ == "__main__":
    main()