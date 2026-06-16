% =============================================================================
% Generation-to-Parsing: Generation-stage Output
% =============================================================================
% Each fact has the form:
%
%   gen_to_parse_generation_case(CaseId, SemanticInput, GenerationStatus, GeneratedTokens, GeneratedSentence).
%
% Meaning:
%   CaseId             - numeric identifier shared across all artifacts for the same test case
%   SemanticInput      - original semantic input sent to the generator
%   GenerationStatus   - result of the generation stage, e.g. ok, gen_empty_yield, generation_timeout
%   GeneratedTokens    - token sequence extracted from the generated structure
%   GeneratedSentence  - sentence atom derived from GeneratedTokens for report consistency
% =============================================================================

gen_to_parse_generation_case(1, 1, ok, [one], one).
gen_to_parse_generation_case(2, 2, ok, [two], two).
gen_to_parse_generation_case(3, 3, ok, [three], three).
gen_to_parse_generation_case(4, 10, ok, [ten], ten).
gen_to_parse_generation_case(5, 11, ok, [eleven], eleven).
gen_to_parse_generation_case(6, 20, ok, [twenty], twenty).
gen_to_parse_generation_case(7, 30, ok, [thirty], thirty).
gen_to_parse_generation_case(8, 50, ok, [fifty], fifty).
gen_to_parse_generation_case(9, '1X+10'(4), ok, [four,teen], fourteen).
gen_to_parse_generation_case(10, '1X+20'(1), ok, [twenty,one], twentyone).
gen_to_parse_generation_case(11, '1X+20'(7), ok, [twenty,seven], twentyseven).
gen_to_parse_generation_case(12, '1X+30'(4), ok, [thirty,four], thirtyfour).
gen_to_parse_generation_case(13, '1X+50'(6), ok, [fifty,six], fiftysix).
