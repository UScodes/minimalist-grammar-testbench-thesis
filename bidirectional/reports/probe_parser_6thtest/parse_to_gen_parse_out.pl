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

parse_to_gen_parsing_case(1, [one,hundred], parse_fail, none).
parse_to_gen_parsing_case(2, [two,hundred], parse_fail, none).
parse_to_gen_parsing_case(3, [three,hundred], parse_fail, none).
parse_to_gen_parsing_case(4, [one,hundred_and,twenty], ok, '1X+100Y'(20,1)).
parse_to_gen_parsing_case(5, [two,hundred_and,thirty], ok, '1X+100Y'(30,2)).
parse_to_gen_parsing_case(6, [three,hundred_and,twenty_,four], parse_fail, none).
parse_to_gen_parsing_case(7, [five,hundred_and,thirty_,six], parse_fail, none).
