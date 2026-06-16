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

gen_to_parse_parsing_case(1, '1X+20'(1), ok, [twenty,one], [twenty_,one], ok, '1X+20'(1)).
gen_to_parse_parsing_case(2, '1X+20'(2), ok, [twenty,two], [twenty_,two], ok, '1X+20'(2)).
gen_to_parse_parsing_case(3, '1X+20'(3), ok, [twenty,three], [twenty_,three], ok, '1X+20'(3)).
gen_to_parse_parsing_case(4, '1X+20'(4), ok, [twenty,four], [twenty_,four], ok, '1X+20'(4)).
gen_to_parse_parsing_case(5, '1X+20'(5), ok, [twenty,five], [twenty_,five], ok, '1X+20'(5)).
gen_to_parse_parsing_case(6, '1X+20'(6), ok, [twenty,six], [twenty_,six], ok, '1X+20'(6)).
gen_to_parse_parsing_case(7, '1X+20'(7), ok, [twenty,seven], [twenty_,seven], ok, '1X+20'(7)).
gen_to_parse_parsing_case(8, '1X+20'(8), ok, [twenty,eight], [twenty_,eight], ok, '1X+20'(8)).
gen_to_parse_parsing_case(9, '1X+20'(9), ok, [twenty,nine], [twenty_,nine], ok, '1X+20'(9)).
