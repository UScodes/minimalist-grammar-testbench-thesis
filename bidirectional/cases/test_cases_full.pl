% ============================================================
% Semantic test cases for Generation-to-Parsing
% Probe version: uncomment one group/case at a time.
% ============================================================

% ------------------------------------------------------------
% ACTIVE SMOKE TEST
% Keep only one simple case active first.
% If this runs, the pipeline itself is working.
% ------------------------------------------------------------

test_case(1).

% ============================================================
% GROUP A: Units
% Expected: basic successful generation and parsing
% ============================================================

 test_case(2).
 test_case(3).
test_case(4).
 test_case(5).
 test_case(6).
test_case(7).
 test_case(8).
 test_case(9).

% ============================================================
% GROUP B: Direct teens and direct tens
% Expected: basic lexical coverage
% ============================================================

 test_case(10).
 test_case(11).
 test_case(12).
 test_case(13).
 test_case(15).
 test_case(20).
 test_case(30).
 test_case(50).

% ============================================================
% GROUP C: Productive teen/eighteen patterns
% Expected: checks teen/een composition
% ============================================================

 test_case('1X+10'(4)).   % fourteen
 test_case('1X+10'(6)).   % sixteen
 test_case('1X+10'(7)).   % seventeen
 test_case('1X+10'(9)).   % nineteen
 test_case('0X+18'(8)).   % eighteen

% ============================================================
% GROUP D: Compound twenties
% Expected: generator output may require normalization:
% generated twenty -> parser expects twenty_
% ============================================================

 test_case('1X+20'(1)).
 test_case('1X+20'(2)).
 test_case('1X+20'(3)).
 test_case('1X+20'(4)).
 test_case('1X+20'(5)).
 test_case('1X+20'(6)).
 test_case('1X+20'(7)).
 test_case('1X+20'(8)).
 test_case('1X+20'(9)).

% ============================================================
% GROUP E: Compound thirties
% Expected: generator output may require normalization:
% generated thirty -> parser expects thirty_
% ============================================================

 test_case('1X+30'(1)).
 test_case('1X+30'(2)).
 test_case('1X+30'(3)).
 test_case('1X+30'(4)).
 test_case('1X+30'(5)).
 test_case('1X+30'(6)).
 test_case('1X+30'(7)).
 test_case('1X+30'(8)).
 test_case('1X+30'(9)).

% ============================================================
% GROUP F: Compound fifties
% Expected: generator output may require normalization:
% generated fifty -> parser expects fifty_
% ============================================================

 test_case('1X+50'(1)).
 test_case('1X+50'(2)).
 test_case('1X+50'(3)).
 test_case('1X+50'(4)).
 test_case('1X+50'(5)).
 test_case('1X+50'(6)).
 test_case('1X+50'(7)).
 test_case('1X+50'(8)).
 test_case('1X+50'(9)).

% ============================================================
% GROUP G: Productive ty/y tens
% WARNING: these may cause long generator search.
% Uncomment one at a time only.
% ============================================================

 test_case('10X'(4)).      % forty-like pattern
 test_case('10X'(6)).      % sixty-like pattern
 test_case('10X'(7)).      % seventy-like pattern
 test_case('0X+80'(8)).    % eighty-like pattern

 test_case('1X+40'(4)).
 test_case('1X+60'(4)).
 test_case('1X+70'(4)).
 test_case('1X+80'(4)).
 test_case('1X+90'(4)).

% ============================================================
% GROUP H: Hundreds
% WARNING: these are experimental and may cause search issues.
% Uncomment one at a time only.
% ============================================================

 test_case('1X+100Y'(1,20)).
 test_case('1X+100Y'(2,30)).
 test_case('1X+100Y'(3,'1X+20'(4))).
 test_case('1X+100Y'(5,'1X+30'(6))).

% ============================================================
% GROUP I: Intentional semantic failure cases
% WARNING: these are supposed to fail, but should not hang.
% Use only after timeout handling is confirmed.
% ============================================================

 test_case('1X+20'(4)).
test_case('1X+20'(15)).
test_case('UNKNOWN_SEM'(4)).