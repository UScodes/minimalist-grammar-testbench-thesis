% ============================================================
% English semantic balanced cases for Generation-to-Parsing
% Purpose:
%   - cover the main semantic patterns used by the grammar,
%   - include successful round-trip cases,
%   - include controlled diagnostic cases.
% ============================================================

% ------------------------------------------------------------
% Group A: Units
% Expected: direct generation and parsing.
% ------------------------------------------------------------

test_case(1).
test_case(2).
test_case(3).
test_case(4).
test_case(5).
test_case(6).
test_case(7).
test_case(8).
test_case(9).

% ------------------------------------------------------------
% Group B: Direct teens and direct tens
% Expected: direct lexical coverage.
% ------------------------------------------------------------

test_case(10).
test_case(11).
test_case(12).
test_case(13).
test_case(15).
test_case(20).
test_case(30).
test_case(50).

% ------------------------------------------------------------
% Group C: Productive teen/eighteen forms
% Purpose: test productive semantic-to-token generation.
% Some generated token sequences may expose parser limitations.
% ------------------------------------------------------------

test_case('1X+10'(4)).
test_case('1X+10'(6)).
test_case('1X+10'(7)).
test_case('1X+10'(9)).
test_case('0X+18'(8)).

% ------------------------------------------------------------
% Group D: Compound twenties
% Purpose: test token normalization from generator output to parser input.
% ------------------------------------------------------------

test_case('1X+20'(1)).
test_case('1X+20'(2)).
test_case('1X+20'(3)).
test_case('1X+20'(4)).
test_case('1X+20'(5)).
test_case('1X+20'(6)).
test_case('1X+20'(7)).
test_case('1X+20'(8)).
test_case('1X+20'(9)).

% ------------------------------------------------------------
% Group E: Compound thirties
% Purpose: test productive compound forms in the thirties.
% ------------------------------------------------------------

test_case('1X+30'(1)).
test_case('1X+30'(2)).
test_case('1X+30'(3)).
test_case('1X+30'(4)).
test_case('1X+30'(5)).
test_case('1X+30'(6)).
test_case('1X+30'(7)).
test_case('1X+30'(8)).
test_case('1X+30'(9)).

% ------------------------------------------------------------
% Group F: Compound fifties
% Purpose: test productive compound forms in the fifties.
% ------------------------------------------------------------

test_case('1X+50'(1)).
test_case('1X+50'(2)).
test_case('1X+50'(3)).
test_case('1X+50'(4)).
test_case('1X+50'(5)).
test_case('1X+50'(6)).
test_case('1X+50'(7)).
test_case('1X+50'(8)).
test_case('1X+50'(9)).

% ------------------------------------------------------------
% Group G: Productive ty/y tens
% Purpose: test generated tens beyond direct lexical entries.
% Some cases intentionally expose missing generator/parser coverage.
% ------------------------------------------------------------

test_case('10X'(4)).
test_case('10X'(6)).
test_case('10X'(7)).
test_case('10X'(9)).
test_case('0X+80'(8)).

test_case('1X+40'(4)).
test_case('1X+60'(4)).
test_case('1X+70'(4)).
test_case('1X+80'(4)).
test_case('1X+90'(4)).

% ------------------------------------------------------------
% Group H: Hundred constructions
% Purpose: test extension beyond two-digit numerals.
% These cases are useful for detecting semantic-order mismatches
% and parser limitations in more complex numeral structures.
% ------------------------------------------------------------

test_case('1X+100Y'(1,20)).
test_case('1X+100Y'(2,30)).
test_case('1X+100Y'(3,'1X+20'(4))).
test_case('1X+100Y'(5,'1X+30'(6))).

% ------------------------------------------------------------
% Group I: Controlled diagnostic cases
% Purpose: confirm timeout and empty-output classification.
% ------------------------------------------------------------

test_case('1X+20'(15)).
test_case('UNKNOWN_SEM'(4)).