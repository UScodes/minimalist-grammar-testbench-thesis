:- encoding(utf8).

% ============================================================
% German Semantic Balanced Test Cases
% Used for Generation-to-Parsing validation
% ============================================================
%
% This file is a balanced German semantic test set.
%
% It contains:
%   1. stable passing cases
%   2. a few representative parsing failures after generation
%   3. a few representative semantic mismatches
%   4. a few representative generation timeout / empty-yield cases
%
% It is smaller and cleaner than the full diagnostic file.
%
% Important:
% Save this file as UTF-8.
% ============================================================


% ============================================================
% 1. Stable lexical pass cases
% ============================================================

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


% ============================================================
% 2. Stable composed pass cases
% ============================================================

test_case('1X+20'(2)).
test_case('1X+20'(6)).
test_case('1X+20'(7)).


% ============================================================
% 3. Stable hundred-related pass cases
% ============================================================

test_case('100X'(2)).
test_case('1X+100'(20)).
test_case('1X+100'(60)).
test_case('1X+100'(70)).


% ============================================================
% 4. Representative parsing-failure-after-generation cases
% ============================================================
%
% These generate a token sequence, but the parser cannot derive it.
%
% Examples observed:
%   '1X+20'(3) -> [undzwanzig,drei] -> parse_fail
%   '10X'(4)  -> [zig,vier]        -> parse_fail
%   '1X+10'(3)-> [zehn,drei]       -> parse_fail

test_case('1X+20'(3)).
test_case('10X'(4)).
test_case('1X+10'(3)).


% ============================================================
% 5. Representative semantic mismatch cases
% ============================================================
%
% These generate and parse, but the parser recovers a different semantic
% representation.
%
% Examples observed:
%   '100X'(3)   -> [hundert,drei]      -> '1X+100'(3)
%   '1X+60'(2) -> [zwei,undsechzig]   -> plus60(2)
%   '1X+70'(2) -> [zwei,undsiebzig]   -> plus70(2)

test_case('100X'(3)).
test_case('1X+60'(2)).
test_case('1X+70'(2)).


% ============================================================
% 6. Representative generation timeout cases
% ============================================================

test_case('1X+100Y'(3,4)).
test_case('1X+1Y'(2,4)).


% ============================================================
% 7. Representative empty-yield / unsupported semantic cases
% ============================================================

test_case('UNKNOWN_GERMAN_SEM'(4)).
test_case('1X+999'(3)).