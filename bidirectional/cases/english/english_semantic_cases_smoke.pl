% ============================================================
% English semantic smoke cases for Generation-to-Parsing
% Purpose: controlled cases expected to pass.
% Coverage: units, direct forms, productive forms, and compounds.
% ============================================================

% Units
test_case(1).
test_case(2).
test_case(3).

% Direct lexical forms
test_case(10).
test_case(11).
test_case(20).
test_case(30).
test_case(50).

% Productive teen form known to validate
test_case('1X+10'(4)).

% Compound forms requiring token normalization before parsing
test_case('1X+20'(1)).
test_case('1X+20'(7)).
test_case('1X+30'(4)).
test_case('1X+50'(6)).