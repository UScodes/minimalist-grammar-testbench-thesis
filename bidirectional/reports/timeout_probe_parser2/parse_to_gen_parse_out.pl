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

parse_to_gen_parsing_case(1, [teen], parse_fail, none).
parse_to_gen_parsing_case(2, [banana], parse_fail, none).
parse_to_gen_parsing_case(3, [twenty_,ten], parse_fail, none).
parse_to_gen_parsing_case(4, [seven,twenty_], parse_fail, none).
parse_to_gen_parsing_case(5, [sixty_,four], parse_fail, none).
parse_to_gen_parsing_case(6, [forty_,four], ok, '1X+40'(4)).
