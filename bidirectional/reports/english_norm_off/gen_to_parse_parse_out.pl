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

gen_to_parse_parsing_case(1, '1X+20'(1), ok, [twenty,one], [twenty,one], parse_fail, none).
gen_to_parse_parsing_case(2, '1X+20'(4), ok, [twenty,four], [twenty,four], parse_fail, none).
gen_to_parse_parsing_case(3, '1X+20'(7), ok, [twenty,seven], [twenty,seven], parse_fail, none).
gen_to_parse_parsing_case(4, '1X+30'(4), ok, [thirty,four], [thirty,four], parse_fail, none).
gen_to_parse_parsing_case(5, '1X+50'(6), ok, [fifty,six], [fifty,six], parse_fail, none).
