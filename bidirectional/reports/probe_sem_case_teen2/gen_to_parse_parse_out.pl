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
gen_to_parse_parsing_case(2, '1X+10'(4), ok, [four,teen], [four,teen], ok, '1X+10'(4)).
gen_to_parse_parsing_case(3, '1X+10'(6), ok, [six,teen], [six,teen], parse_fail, none).
gen_to_parse_parsing_case(4, '1X+10'(7), ok, [seven,teen], [seven,teen], parse_fail, none).
gen_to_parse_parsing_case(5, '1X+10'(9), ok, [nine,teen], [nine,teen], parse_fail, none).
gen_to_parse_parsing_case(6, '0X+18'(8), ok, [eight,een], [eight,een], ok, '0X+18'(8)).
