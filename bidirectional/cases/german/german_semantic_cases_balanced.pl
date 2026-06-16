% ============================================================
% German semantic balanced cases for Generation-to-Parsing
% Purpose:
%   - cover the main semantic patterns used by the German grammar,
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
% Expected: direct lexical coverage where available.
% ------------------------------------------------------------

test_case(10).
test_case(11).
test_case(12).
test_case(13).
test_case(15).
test_case(20).
test_case(30).
test_case(60).
test_case(70).

% ------------------------------------------------------------
% Group C: German compound twenties
% Purpose: test unit-und-ten constructions.
% Expected token pattern: [unit,undzwanzig].
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
% Group D: German compound sixties and seventies
% Purpose: test productive compound tens beyond twenties.
% Expected token patterns: [unit,undsechzig] and [unit,undsiebzig].
% ------------------------------------------------------------

test_case('1X+60'(1)).
test_case('1X+60'(2)).
test_case('1X+60'(4)).
test_case('1X+60'(6)).
test_case('1X+60'(7)).
test_case('1X+60'(8)).

test_case('1X+70'(1)).
test_case('1X+70'(2)).
test_case('1X+70'(4)).
test_case('1X+70'(6)).
test_case('1X+70'(7)).
test_case('1X+70'(8)).

% ------------------------------------------------------------
% Group E: Hundred constructions
% Purpose: test extension beyond two-digit numerals.
% ------------------------------------------------------------

test_case(100).

test_case('100X'(2)).
test_case('100X'(3)).
test_case('100X'(5)).

test_case('1X+100'(20)).
test_case('1X+100'(30)).
test_case('1X+100'(60)).
test_case('1X+100'(70)).

% ------------------------------------------------------------
% Group F: Controlled diagnostic cases
% Purpose: expose generation, parsing, or comparison failures cleanly
% when the configured resources do not support the requested form.
% ------------------------------------------------------------

test_case('1X+40'(4)).
test_case('1X+50'(6)).
test_case('1X+80'(8)).
test_case('UNKNOWN_SEM'(4)).