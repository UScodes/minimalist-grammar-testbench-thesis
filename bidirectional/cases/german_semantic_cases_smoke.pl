:- encoding(utf8).

% ============================================================
% German Semantic Smoke Test Cases
% Used for Generation-to-Parsing validation
% ============================================================
%
% These are stable German cases that passed cleanly in the previous
% German generation-to-parsing report.
%
% Purpose:
%   - check that German generation works
%   - check that German parsing works after generation
%   - check that German semantic roundtrip comparison works
%   - check that German normalization rule set is selected
% ============================================================


% Simple lexical semantics

test_case(1).
test_case(2).
test_case(3).
test_case(4).
test_case(6).
test_case(7).
test_case(8).
test_case(9).

test_case(10).
test_case(11).

test_case(16).
test_case(17).

test_case(20).
test_case(21).

test_case(60).
test_case(61).

test_case(70).
test_case(71).

test_case(100).


% Stable composed forms

test_case('1X+20'(2)).
test_case('1X+20'(6)).
test_case('1X+20'(7)).


% Stable hundred-related forms

test_case('100X'(2)).
test_case('1X+100'(20)).
test_case('1X+100'(60)).
test_case('1X+100'(70)).