% =============================================================================
% Generation-to-Parsing: Parsing-stage Output
% =============================================================================
% Each fact has the form:
%
%   gen_to_parse_parsing_case(CaseId, SemanticInput, GenerationStatus, GeneratedTokens, ParserInputTokens, ParsingStatus, RecoveredSemanticOutput).
%
% Meaning:
%   CaseId                   - numeric identifier shared across all artifacts for the same test case
%   SemanticInput            - original semantic input used in the generation stage
%   GenerationStatus         - result of the generation stage
%   GeneratedTokens          - raw token sequence produced by the generation stage
%   ParserInputTokens        - token sequence after normalization; passed to the parser
%   ParsingStatus            - result of the parsing stage, e.g. ok, parse_fail, parse_timeout
%   RecoveredSemanticOutput  - semantic representation recovered by the parser, or none if parsing failed
% =============================================================================

gen_to_parse_parsing_case(1, 1, ok, [one], [one], ok, 1).
gen_to_parse_parsing_case(2, 2, ok, [two], [two], ok, 2).
gen_to_parse_parsing_case(3, 3, ok, [three], [three], ok, 3).
gen_to_parse_parsing_case(4, 4, ok, [four], [four], ok, 4).
gen_to_parse_parsing_case(5, 5, ok, [five], [five], ok, 5).
gen_to_parse_parsing_case(6, 6, ok, [six], [six], ok, 6).
gen_to_parse_parsing_case(7, 7, ok, [seven], [seven], ok, 7).
gen_to_parse_parsing_case(8, 8, ok, [eight], [eight], ok, 8).
gen_to_parse_parsing_case(9, 9, ok, [nine], [nine], ok, 9).
gen_to_parse_parsing_case(10, 10, ok, [ten], [ten], ok, 10).
gen_to_parse_parsing_case(11, 11, ok, [eleven], [eleven], ok, 11).
gen_to_parse_parsing_case(12, 12, ok, [twelve], [twelve], ok, 12).
gen_to_parse_parsing_case(13, 13, ok, [thirteen], [thirteen], ok, 13).
gen_to_parse_parsing_case(14, 15, ok, [fifteen], [fifteen], ok, 15).
gen_to_parse_parsing_case(15, 20, ok, [twenty], [twenty], ok, 20).
gen_to_parse_parsing_case(16, 30, ok, [thirty], [thirty], ok, 30).
gen_to_parse_parsing_case(17, 50, ok, [fifty], [fifty], ok, 50).
gen_to_parse_parsing_case(18, '1X+10'(4), ok, [four,teen], [four,teen], ok, '1X+10'(4)).
gen_to_parse_parsing_case(19, '1X+10'(6), ok, [six,teen], [six,teen], parse_fail, none).
gen_to_parse_parsing_case(20, '1X+10'(7), ok, [seven,teen], [seven,teen], parse_fail, none).
gen_to_parse_parsing_case(21, '1X+10'(9), ok, [nine,teen], [nine,teen], parse_fail, none).
gen_to_parse_parsing_case(22, '0X+18'(8), ok, [eight,een], [eight,een], ok, '0X+18'(8)).
gen_to_parse_parsing_case(23, '1X+20'(1), ok, [twenty,one], [twenty_,one], ok, '1X+20'(1)).
gen_to_parse_parsing_case(24, '1X+20'(2), ok, [twenty,two], [twenty_,two], ok, '1X+20'(2)).
gen_to_parse_parsing_case(25, '1X+20'(3), ok, [twenty,three], [twenty_,three], ok, '1X+20'(3)).
gen_to_parse_parsing_case(26, '1X+20'(4), ok, [twenty,four], [twenty_,four], ok, '1X+20'(4)).
gen_to_parse_parsing_case(27, '1X+20'(5), ok, [twenty,five], [twenty_,five], ok, '1X+20'(5)).
gen_to_parse_parsing_case(28, '1X+20'(6), ok, [twenty,six], [twenty_,six], ok, '1X+20'(6)).
gen_to_parse_parsing_case(29, '1X+20'(7), ok, [twenty,seven], [twenty_,seven], ok, '1X+20'(7)).
gen_to_parse_parsing_case(30, '1X+20'(8), ok, [twenty,eight], [twenty_,eight], ok, '1X+20'(8)).
gen_to_parse_parsing_case(31, '1X+20'(9), ok, [twenty,nine], [twenty_,nine], ok, '1X+20'(9)).
gen_to_parse_parsing_case(32, '1X+30'(1), ok, [thirty,one], [thirty_,one], ok, '1X+30'(1)).
gen_to_parse_parsing_case(33, '1X+30'(2), ok, [thirty,two], [thirty_,two], ok, '1X+30'(2)).
gen_to_parse_parsing_case(34, '1X+30'(3), ok, [thirty,three], [thirty_,three], ok, '1X+30'(3)).
gen_to_parse_parsing_case(35, '1X+30'(4), ok, [thirty,four], [thirty_,four], ok, '1X+30'(4)).
gen_to_parse_parsing_case(36, '1X+30'(5), ok, [thirty,five], [thirty_,five], ok, '1X+30'(5)).
gen_to_parse_parsing_case(37, '1X+30'(6), ok, [thirty,six], [thirty_,six], ok, '1X+30'(6)).
gen_to_parse_parsing_case(38, '1X+30'(7), ok, [thirty,seven], [thirty_,seven], ok, '1X+30'(7)).
gen_to_parse_parsing_case(39, '1X+30'(8), ok, [thirty,eight], [thirty_,eight], ok, '1X+30'(8)).
gen_to_parse_parsing_case(40, '1X+30'(9), ok, [thirty,nine], [thirty_,nine], ok, '1X+30'(9)).
gen_to_parse_parsing_case(41, '1X+50'(1), ok, [fifty,one], [fifty_,one], ok, '1X+50'(1)).
gen_to_parse_parsing_case(42, '1X+50'(2), ok, [fifty,two], [fifty_,two], ok, '1X+50'(2)).
gen_to_parse_parsing_case(43, '1X+50'(3), ok, [fifty,three], [fifty_,three], ok, '1X+50'(3)).
gen_to_parse_parsing_case(44, '1X+50'(4), ok, [fifty,four], [fifty_,four], ok, '1X+50'(4)).
gen_to_parse_parsing_case(45, '1X+50'(5), ok, [fifty,five], [fifty_,five], ok, '1X+50'(5)).
gen_to_parse_parsing_case(46, '1X+50'(6), ok, [fifty,six], [fifty_,six], ok, '1X+50'(6)).
gen_to_parse_parsing_case(47, '1X+50'(7), ok, [fifty,seven], [fifty_,seven], ok, '1X+50'(7)).
gen_to_parse_parsing_case(48, '1X+50'(8), ok, [fifty,eight], [fifty_,eight], ok, '1X+50'(8)).
gen_to_parse_parsing_case(49, '1X+50'(9), ok, [fifty,nine], [fifty_,nine], ok, '1X+50'(9)).
gen_to_parse_parsing_case(50, '10X'(4), ok, [four,ty], [four,ty], parse_fail, none).
gen_to_parse_parsing_case(51, '10X'(6), ok, [six,ty], [six,ty], ok, '10X'(6)).
gen_to_parse_parsing_case(52, '10X'(7), ok, [seven,ty], [seven,ty], ok, '10X'(7)).
gen_to_parse_parsing_case(53, '10X'(9), ok, [nine,ty], [nine,ty], ok, '10X'(9)).
gen_to_parse_parsing_case(54, '0X+80'(8), ok, [eight,y], [eight,y], ok, '0X+80'(8)).
gen_to_parse_parsing_case(55, '1X+40'(4), gen_empty_yield, [], [], parse_skipped_empty_tokens, none).
gen_to_parse_parsing_case(56, '1X+60'(4), gen_empty_yield, [], [], parse_skipped_empty_tokens, none).
gen_to_parse_parsing_case(57, '1X+70'(4), gen_empty_yield, [], [], parse_skipped_empty_tokens, none).
gen_to_parse_parsing_case(58, '1X+80'(4), gen_empty_yield, [], [], parse_skipped_empty_tokens, none).
gen_to_parse_parsing_case(59, '1X+90'(4), gen_empty_yield, [], [], parse_skipped_empty_tokens, none).
gen_to_parse_parsing_case(60, '1X+100Y'(1,20), ok, [one,hundred_and,twenty], [one,hundred_and,twenty], ok, '1X+100Y'(20,1)).
gen_to_parse_parsing_case(61, '1X+100Y'(2,30), ok, [two,hundred_and,thirty], [two,hundred_and,thirty], ok, '1X+100Y'(30,2)).
gen_to_parse_parsing_case(62, '1X+100Y'(3,'1X+20'(4)), ok, [three,hundred_and,twenty,four], [three,hundred_and,twenty_,four], parse_fail, none).
gen_to_parse_parsing_case(63, '1X+100Y'(5,'1X+30'(6)), ok, [five,hundred_and,thirty,six], [five,hundred_and,thirty_,six], parse_fail, none).
gen_to_parse_parsing_case(64, '1X+20'(15), generation_timeout, [], [], parse_skipped_empty_tokens, none).
gen_to_parse_parsing_case(65, 'UNKNOWN_SEM'(4), gen_empty_yield, [], [], parse_skipped_empty_tokens, none).
