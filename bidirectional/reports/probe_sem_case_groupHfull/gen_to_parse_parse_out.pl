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

gen_to_parse_parsing_case(1, '1X+100Y'(1,20), ok, [one,hundred_and,twenty], [one,hundred_and,twenty_], parse_fail, none).
gen_to_parse_parsing_case(2, '1X+100Y'(2,30), ok, [two,hundred_and,thirty], [two,hundred_and,thirty_], parse_fail, none).
gen_to_parse_parsing_case(3, '1X+100Y'(3,'1X+20'(4)), ok, [three,hundred_and,twenty,four], [three,hundred_and,twenty_,four], parse_fail, none).
gen_to_parse_parsing_case(4, '1X+100Y'(5,'1X+30'(6)), ok, [five,hundred_and,thirty,six], [five,hundred_and,thirty_,six], parse_fail, none).
