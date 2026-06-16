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
gen_to_parse_parsing_case(2, 2, ok, [two], [two], ok, 2).
gen_to_parse_parsing_case(3, 3, ok, [three], [three], ok, 3).
gen_to_parse_parsing_case(4, 10, ok, [ten], [ten], ok, 10).
gen_to_parse_parsing_case(5, 11, ok, [eleven], [eleven], ok, 11).
gen_to_parse_parsing_case(6, 20, ok, [twenty], [twenty], ok, 20).
gen_to_parse_parsing_case(7, 30, ok, [thirty], [thirty], ok, 30).
gen_to_parse_parsing_case(8, 50, ok, [fifty], [fifty], ok, 50).
gen_to_parse_parsing_case(9, '1X+10'(4), ok, [four,teen], [four,teen], ok, '1X+10'(4)).
gen_to_parse_parsing_case(10, '1X+20'(1), ok, [twenty,one], [twenty_,one], ok, '1X+20'(1)).
gen_to_parse_parsing_case(11, '1X+20'(7), ok, [twenty,seven], [twenty_,seven], ok, '1X+20'(7)).
gen_to_parse_parsing_case(12, '1X+30'(4), ok, [thirty,four], [thirty_,four], ok, '1X+30'(4)).
gen_to_parse_parsing_case(13, '1X+50'(6), ok, [fifty,six], [fifty_,six], ok, '1X+50'(6)).
