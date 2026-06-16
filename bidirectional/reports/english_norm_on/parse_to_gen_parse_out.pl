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

parse_to_gen_parsing_case(1, [twenty_,one], ok, '1X+20'(1)).
parse_to_gen_parsing_case(2, [twenty_,four], ok, '1X+20'(4)).
parse_to_gen_parsing_case(3, [twenty_,seven], ok, '1X+20'(7)).
parse_to_gen_parsing_case(4, [thirty_,four], ok, '1X+30'(4)).
parse_to_gen_parsing_case(5, [fifty_,six], ok, '1X+50'(6)).
