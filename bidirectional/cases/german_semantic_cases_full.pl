:- encoding(utf8).

% ============================================================
% German Semantic Test Cases
% Used for Generation-to-Parsing validation
% ============================================================
%
% Purpose
% -------
% These cases test the German generator first. If generation succeeds,
% the generated token sequence is sent to the parser and the recovered
% semantic representation is compared with the original semantic input.
%
% The file intentionally contains:
%
%   1. expected lexical semantic inputs
%   2. productive German number constructions
%   3. hundred constructions
%   4. semantic forms that may expose parser/generator mismatch
%   5. unsupported / unknown semantic inputs
%
% This allows the testbench to verify normal success behavior, empty
% generation handling, timeout handling if any case loops, parse failure
% handling, and semantic mismatch handling.
%
% ============================================================


% ============================================================
% 1. Simple lexical semantics
% ============================================================

test_case(1).
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
% 2. Productive teen forms
% ============================================================
%
% German parser grammar contains:
%
% [zehn] :: ([=c1, +a, c2, -s1], ...)
%
% Generator grammar contains:
%
% [zehn] :: ([=c1,+a,cfin], abst(x,'1X+10'(x))).
%
% Some of these may pass depending on feature compatibility.

test_case('1X+10'(3)).
test_case('1X+10'(4)).
test_case('1X+10'(5)).
test_case('1X+10'(8)).
test_case('1X+10'(9)).


% ============================================================
% 3. Twenty-like forms
% ============================================================

test_case('1X+20'(2)).
test_case('1X+20'(3)).
test_case('1X+20'(4)).
test_case('1X+20'(5)).
test_case('1X+20'(6)).
test_case('1X+20'(7)).
test_case('1X+20'(8)).
test_case('1X+20'(9)).


% ============================================================
% 4. Thirty-like forms
% ============================================================
%
% German grammar uses ßig for some thirty-like constructions.

test_case('0X+30'(3)).
test_case('0X+30'(4)).
test_case('0X+30'(5)).
test_case('0X+30'(8)).
test_case('0X+30'(9)).


% ============================================================
% 5. Zig-like tens
% ============================================================

test_case('10X'(4)).
test_case('10X'(6)).
test_case('10X'(7)).
test_case('10X'(8)).
test_case('10X'(9)).


% ============================================================
% 6. Special semantic constructors visible in generator grammar
% ============================================================
%
% These appear in german_Generation:
%
% [einund] with '1X+1'(x)
% [einund] with '1X+31'(x)
% [und] with '1X+1Y+3'(x,y)
% [und] with '1X+1Y'(x,y)
% [zig] with '10X+1'(x)
% [zig] with '10X+N'(x)
%
% These are useful to expose whether the parser and generator agree on
% semantic naming conventions.

test_case('1X+1'(4)).
test_case('1X+31'(1)).
test_case('1X+31'(3)).
test_case('1X+1Y+3'(2,3)).
test_case('1X+1Y+3'(7,4)).
test_case('1X+1Y'(2,4)).
test_case('1X+1Y'(9,4)).
test_case('10X+1'(4)).
test_case('10X+N'(4)).


% ============================================================
% 7. Hundred constructions
% ============================================================
%
% Parser grammar contains:
%
% '100X'(X)
% '1X+100'(X)
% '1X+100Y'(X,Y)
%
% Generator grammar contains corresponding hundred rules.
%
% These are important because English already exposed argument-order
% mismatch in hundred constructions. German should be checked similarly.

test_case('100X'(2)).
test_case('100X'(3)).
test_case('100X'(4)).
test_case('100X'(5)).
test_case('100X'(8)).
test_case('100X'(9)).

test_case('1X+100'(3)).
test_case('1X+100'(4)).
test_case('1X+100'(20)).
test_case('1X+100'(60)).
test_case('1X+100'(70)).

test_case('1X+100Y'(3,4)).
test_case('1X+100Y'(3,20)).
test_case('1X+100Y'(3,'10X'(4))).
test_case('1X+100Y'(4,'0X+30'(3))).
test_case('1X+100Y'(4,'1X+1Y'(7,4))).


% ============================================================
% 8. Known possible generator/parser convention mismatch cases
% ============================================================
%
% These are intentionally included because the German generator grammar
% contains plus60/plus70 for some generated forms, while the parser grammar
% appears to use '1X+60'(X) and '1X+70'(X).
%
% We include both styles to see which side accepts which representation.

test_case('1X+60'(2)).
test_case('1X+60'(4)).
test_case('1X+70'(2)).
test_case('1X+70'(4)).

test_case(plus60(2)).
test_case(plus60(4)).
test_case(plus70(2)).
test_case(plus70(4)).


% ============================================================
% 9. Deliberate unsupported / unknown semantics
% ============================================================
%
% These should not crash the testbench. They should produce controlled
% generation failure, empty yield, timeout, or skipped parse behavior.

test_case('UNKNOWN_GERMAN_SEM'(4)).
test_case('BAD_GERMAN_FORM').
test_case('1X+999'(3)).
test_case('1000X'(2)).