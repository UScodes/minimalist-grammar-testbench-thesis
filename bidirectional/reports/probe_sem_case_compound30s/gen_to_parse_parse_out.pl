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

gen_to_parse_parsing_case(1, '1X+30'(1), ok, [thirty,one], [thirty_,one], ok, '1X+30'(1)).
gen_to_parse_parsing_case(2, '1X+30'(2), ok, [thirty,two], [thirty_,two], ok, '1X+30'(2)).
gen_to_parse_parsing_case(3, '1X+30'(3), ok, [thirty,three], [thirty_,three], ok, '1X+30'(3)).
gen_to_parse_parsing_case(4, '1X+30'(4), ok, [thirty,four], [thirty_,four], ok, '1X+30'(4)).
gen_to_parse_parsing_case(5, '1X+30'(5), ok, [thirty,five], [thirty_,five], ok, '1X+30'(5)).
gen_to_parse_parsing_case(6, '1X+30'(6), ok, [thirty,six], [thirty_,six], ok, '1X+30'(6)).
gen_to_parse_parsing_case(7, '1X+30'(7), ok, [thirty,seven], [thirty_,seven], ok, '1X+30'(7)).
gen_to_parse_parsing_case(8, '1X+30'(8), ok, [thirty,eight], [thirty_,eight], ok, '1X+30'(8)).
gen_to_parse_parsing_case(9, '1X+30'(9), ok, [thirty,nine], [thirty_,nine], ok, '1X+30'(9)).
