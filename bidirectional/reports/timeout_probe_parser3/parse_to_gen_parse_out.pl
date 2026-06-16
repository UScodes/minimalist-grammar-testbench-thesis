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

parse_to_gen_parsing_case(1, [four,ty], parse_fail, none).
parse_to_gen_parsing_case(2, [six,ty], ok, '10X'(6)).
parse_to_gen_parsing_case(3, [seven,ty], ok, '10X'(7)).
parse_to_gen_parsing_case(4, [nine,ty], ok, '10X'(9)).
parse_to_gen_parsing_case(5, [eight,y], ok, '0X+80'(8)).
parse_to_gen_parsing_case(6, [six,ty_,four], ok, '1X+10Y'(4,6)).
parse_to_gen_parsing_case(7, [seven,ty_,four], ok, '1X+10Y'(4,7)).
parse_to_gen_parsing_case(8, [eight,y_,four], ok, '1X+10Y'(4,8)).
parse_to_gen_parsing_case(9, [nine,ty_,four], ok, '1X+10Y'(4,9)).
