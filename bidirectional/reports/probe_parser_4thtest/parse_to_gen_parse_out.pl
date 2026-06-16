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
parse_to_gen_parsing_case(2, [thirty_,one], ok, '1X+30'(1)).
parse_to_gen_parsing_case(3, [thirty_,two], ok, '1X+30'(2)).
parse_to_gen_parsing_case(4, [thirty_,three], ok, '1X+30'(3)).
parse_to_gen_parsing_case(5, [thirty_,four], ok, '1X+30'(4)).
parse_to_gen_parsing_case(6, [thirty_,five], ok, '1X+30'(5)).
parse_to_gen_parsing_case(7, [thirty_,six], ok, '1X+30'(6)).
parse_to_gen_parsing_case(8, [thirty_,seven], ok, '1X+30'(7)).
parse_to_gen_parsing_case(9, [thirty_,eight], ok, '1X+30'(8)).
parse_to_gen_parsing_case(10, [thirty_,nine], ok, '1X+30'(9)).
parse_to_gen_parsing_case(11, [fifty_,one], ok, '1X+50'(1)).
parse_to_gen_parsing_case(12, [fifty_,two], ok, '1X+50'(2)).
parse_to_gen_parsing_case(13, [fifty_,three], ok, '1X+50'(3)).
parse_to_gen_parsing_case(14, [fifty_,four], ok, '1X+50'(4)).
parse_to_gen_parsing_case(15, [fifty_,five], ok, '1X+50'(5)).
parse_to_gen_parsing_case(16, [fifty_,six], ok, '1X+50'(6)).
parse_to_gen_parsing_case(17, [fifty_,seven], ok, '1X+50'(7)).
parse_to_gen_parsing_case(18, [fifty_,eight], ok, '1X+50'(8)).
parse_to_gen_parsing_case(19, [fifty_,nine], ok, '1X+50'(9)).
parse_to_gen_parsing_case(20, [four,ty], parse_fail, none).
parse_to_gen_parsing_case(21, [six,ty], ok, '10X'(6)).
parse_to_gen_parsing_case(22, [seven,ty], ok, '10X'(7)).
parse_to_gen_parsing_case(23, [nine,ty], ok, '10X'(9)).
parse_to_gen_parsing_case(24, [eight,y], ok, '0X+80'(8)).
