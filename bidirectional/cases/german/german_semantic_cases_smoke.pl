% ============================================================
% German semantic smoke cases for Generation-to-Parsing
% Purpose: controlled cases expected to pass.
% Coverage: units, direct forms, compounds, and hundred forms.
% ============================================================

% Units
test_case(1).
test_case(2).
test_case(3).
test_case(4).
test_case(6).
test_case(7).
test_case(8).
test_case(9).

% Direct lexical forms
test_case(10).
test_case(11).
test_case(20).
test_case(60).
test_case(70).

% Compound forms
test_case('1X+20'(2)).
test_case('1X+20'(6)).
test_case('1X+20'(7)).

% Hundred forms
test_case(100).
test_case('100X'(2)).
test_case('1X+100'(20)).
test_case('1X+100'(60)).
test_case('1X+100'(70)).