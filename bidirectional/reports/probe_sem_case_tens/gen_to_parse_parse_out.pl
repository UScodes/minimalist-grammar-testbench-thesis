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
gen_to_parse_parsing_case(4, 4, ok, [four], [four], ok, 4).
gen_to_parse_parsing_case(5, 5, ok, [five], [five], ok, 5).
gen_to_parse_parsing_case(6, 6, ok, [six], [six], ok, 6).
gen_to_parse_parsing_case(7, 7, ok, [seven], [seven], ok, 7).
gen_to_parse_parsing_case(8, 8, ok, [eight], [eight], ok, 8).
gen_to_parse_parsing_case(9, 9, ok, [nine], [nine], ok, 9).
gen_to_parse_parsing_case(10, 10, ok, [ten], [ten], ok, 10).
gen_to_parse_parsing_case(11, 11, ok, [eleven], [eleven], ok, 11).
gen_to_parse_parsing_case(12, 12, ok, [twelve], [twelve], ok, 12).
gen_to_parse_parsing_case(13, 13, ok, [thirteen], [thirteen], ok, 13).
gen_to_parse_parsing_case(14, 15, ok, [fifteen], [fifteen], ok, 15).
gen_to_parse_parsing_case(15, 20, ok, [twenty], [twenty_], parse_fail, none).
gen_to_parse_parsing_case(16, 30, ok, [thirty], [thirty_], parse_fail, none).
gen_to_parse_parsing_case(17, 50, ok, [fifty], [fifty_], parse_fail, none).
