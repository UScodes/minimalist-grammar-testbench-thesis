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
