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

gen_to_parse_parsing_case(1, '1X+50'(1), ok, [fifty,one], [fifty_,one], ok, '1X+50'(1)).
gen_to_parse_parsing_case(2, '1X+50'(2), ok, [fifty,two], [fifty_,two], ok, '1X+50'(2)).
gen_to_parse_parsing_case(3, '1X+50'(3), ok, [fifty,three], [fifty_,three], ok, '1X+50'(3)).
gen_to_parse_parsing_case(4, '1X+50'(4), ok, [fifty,four], [fifty_,four], ok, '1X+50'(4)).
gen_to_parse_parsing_case(5, '1X+50'(5), ok, [fifty,five], [fifty_,five], ok, '1X+50'(5)).
gen_to_parse_parsing_case(6, '1X+50'(6), ok, [fifty,six], [fifty_,six], ok, '1X+50'(6)).
gen_to_parse_parsing_case(7, '1X+50'(7), ok, [fifty,seven], [fifty_,seven], ok, '1X+50'(7)).
gen_to_parse_parsing_case(8, '1X+50'(8), ok, [fifty,eight], [fifty_,eight], ok, '1X+50'(8)).
gen_to_parse_parsing_case(9, '1X+50'(9), ok, [fifty,nine], [fifty_,nine], ok, '1X+50'(9)).
