% =============================================================================
% Parsing-to-Generation: Parsing-stage Output
% =============================================================================
% Each fact has the form:
%
%   parse_to_gen_parsing_case(CaseId, TokenInput, ParsingStatus, RecoveredSemanticOutput).
%
% Meaning:
%   CaseId                   - numeric identifier shared across all artifacts for the same test case
%   TokenInput               - original token sequence sent to the parser
%   ParsingStatus            - result of the parsing stage, e.g. ok, parse_fail, parse_timeout
%   RecoveredSemanticOutput  - semantic representation recovered by the parser, or none if parsing failed
% =============================================================================

parse_to_gen_parsing_case(1, [one], ok, 1).
parse_to_gen_parsing_case(2, [two], ok, 2).
parse_to_gen_parsing_case(3, [three], ok, 3).
parse_to_gen_parsing_case(4, [four], ok, 4).
parse_to_gen_parsing_case(5, [five], ok, 5).
parse_to_gen_parsing_case(6, [six], ok, 6).
parse_to_gen_parsing_case(7, [seven], ok, 7).
parse_to_gen_parsing_case(8, [eight], ok, 8).
parse_to_gen_parsing_case(9, [nine], ok, 9).
parse_to_gen_parsing_case(10, [ten], ok, 10).
parse_to_gen_parsing_case(11, [eleven], ok, 11).
parse_to_gen_parsing_case(12, [twelve], ok, 12).
parse_to_gen_parsing_case(13, [thirteen], ok, 13).
parse_to_gen_parsing_case(14, [fifteen], ok, 15).
parse_to_gen_parsing_case(15, [twenty], ok, 20).
parse_to_gen_parsing_case(16, [thirty], ok, 30).
parse_to_gen_parsing_case(17, [fifty], ok, 50).
parse_to_gen_parsing_case(18, [four,teen], ok, '1X+10'(4)).
parse_to_gen_parsing_case(19, [six,teen], parse_fail, none).
parse_to_gen_parsing_case(20, [seven,teen], parse_fail, none).
parse_to_gen_parsing_case(21, [nine,teen], parse_fail, none).
parse_to_gen_parsing_case(22, [eight,een], ok, '0X+18'(8)).
parse_to_gen_parsing_case(23, [twenty_,one], ok, '1X+20'(1)).
parse_to_gen_parsing_case(24, [twenty_,two], ok, '1X+20'(2)).
parse_to_gen_parsing_case(25, [twenty_,three], ok, '1X+20'(3)).
parse_to_gen_parsing_case(26, [twenty_,four], ok, '1X+20'(4)).
parse_to_gen_parsing_case(27, [twenty_,five], ok, '1X+20'(5)).
parse_to_gen_parsing_case(28, [twenty_,six], ok, '1X+20'(6)).
parse_to_gen_parsing_case(29, [twenty_,seven], ok, '1X+20'(7)).
parse_to_gen_parsing_case(30, [twenty_,eight], ok, '1X+20'(8)).
parse_to_gen_parsing_case(31, [twenty_,nine], ok, '1X+20'(9)).
parse_to_gen_parsing_case(32, [thirty_,one], ok, '1X+30'(1)).
parse_to_gen_parsing_case(33, [thirty_,two], ok, '1X+30'(2)).
parse_to_gen_parsing_case(34, [thirty_,three], ok, '1X+30'(3)).
parse_to_gen_parsing_case(35, [thirty_,four], ok, '1X+30'(4)).
parse_to_gen_parsing_case(36, [thirty_,five], ok, '1X+30'(5)).
parse_to_gen_parsing_case(37, [thirty_,six], ok, '1X+30'(6)).
parse_to_gen_parsing_case(38, [thirty_,seven], ok, '1X+30'(7)).
parse_to_gen_parsing_case(39, [thirty_,eight], ok, '1X+30'(8)).
parse_to_gen_parsing_case(40, [thirty_,nine], ok, '1X+30'(9)).
parse_to_gen_parsing_case(41, [fifty_,one], ok, '1X+50'(1)).
parse_to_gen_parsing_case(42, [fifty_,two], ok, '1X+50'(2)).
parse_to_gen_parsing_case(43, [fifty_,four], ok, '1X+50'(4)).
parse_to_gen_parsing_case(44, [fifty_,five], ok, '1X+50'(5)).
parse_to_gen_parsing_case(45, [fifty_,six], ok, '1X+50'(6)).
parse_to_gen_parsing_case(46, [fifty_,seven], ok, '1X+50'(7)).
parse_to_gen_parsing_case(47, [fifty_,eight], ok, '1X+50'(8)).
parse_to_gen_parsing_case(48, [fifty_,nine], ok, '1X+50'(9)).
parse_to_gen_parsing_case(49, [four,ty], parse_fail, none).
parse_to_gen_parsing_case(50, [six,ty], ok, '10X'(6)).
parse_to_gen_parsing_case(51, [seven,ty], ok, '10X'(7)).
parse_to_gen_parsing_case(52, [nine,ty], ok, '10X'(9)).
parse_to_gen_parsing_case(53, [eight,y], ok, '0X+80'(8)).
parse_to_gen_parsing_case(54, [six,ty_,four], ok, '1X+10Y'(4,6)).
parse_to_gen_parsing_case(55, [seven,ty_,four], ok, '1X+10Y'(4,7)).
parse_to_gen_parsing_case(56, [eight,y_,four], ok, '1X+10Y'(4,8)).
parse_to_gen_parsing_case(57, [nine,ty_,four], ok, '1X+10Y'(4,9)).
parse_to_gen_parsing_case(58, [one,hundred], parse_fail, none).
parse_to_gen_parsing_case(59, [two,hundred], parse_fail, none).
parse_to_gen_parsing_case(60, [three,hundred], parse_fail, none).
parse_to_gen_parsing_case(61, [one,hundred_and,twenty], ok, '1X+100Y'(20,1)).
parse_to_gen_parsing_case(62, [two,hundred_and,thirty], ok, '1X+100Y'(30,2)).
parse_to_gen_parsing_case(63, [three,hundred_and,twenty_,four], parse_fail, none).
parse_to_gen_parsing_case(64, [five,hundred_and,thirty_,six], parse_fail, none).
parse_to_gen_parsing_case(65, [teen], parse_fail, none).
parse_to_gen_parsing_case(66, [banana], parse_fail, none).
parse_to_gen_parsing_case(67, [twenty_,ten], parse_fail, none).
parse_to_gen_parsing_case(68, [seven,twenty_], parse_fail, none).
parse_to_gen_parsing_case(69, [sixty_,four], parse_fail, none).
parse_to_gen_parsing_case(70, [forty_,four], ok, '1X+40'(4)).
