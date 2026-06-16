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
parse_to_gen_parsing_case(4, [ten], ok, 10).
parse_to_gen_parsing_case(5, [eleven], ok, 11).
parse_to_gen_parsing_case(6, [twenty], ok, 20).
parse_to_gen_parsing_case(7, [thirty], ok, 30).
parse_to_gen_parsing_case(8, [fifty], ok, 50).
parse_to_gen_parsing_case(9, [twenty_,one], ok, '1X+20'(1)).
parse_to_gen_parsing_case(10, [twenty_,seven], ok, '1X+20'(7)).
parse_to_gen_parsing_case(11, [thirty_,four], ok, '1X+30'(4)).
parse_to_gen_parsing_case(12, [fifty_,six], ok, '1X+50'(6)).
parse_to_gen_parsing_case(13, [one,hundred_and,twenty], ok, '1X+100Y'(20,1)).
