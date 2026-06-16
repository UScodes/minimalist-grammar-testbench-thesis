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
gen_to_parse_generation_case(4, 4, ok, [four], four).
gen_to_parse_generation_case(5, 5, ok, [five], five).
gen_to_parse_generation_case(6, 6, ok, [six], six).
gen_to_parse_generation_case(7, 7, ok, [seven], seven).
gen_to_parse_generation_case(8, 8, ok, [eight], eight).
gen_to_parse_generation_case(9, 9, ok, [nine], nine).
gen_to_parse_generation_case(10, 10, ok, [ten], ten).
gen_to_parse_generation_case(11, 11, ok, [eleven], eleven).
gen_to_parse_generation_case(12, 12, ok, [twelve], twelve).
gen_to_parse_generation_case(13, 13, ok, [thirteen], thirteen).
gen_to_parse_generation_case(14, 15, ok, [fifteen], fifteen).
gen_to_parse_generation_case(15, 20, ok, [twenty], twenty).
gen_to_parse_generation_case(16, 30, ok, [thirty], thirty).
gen_to_parse_generation_case(17, 50, ok, [fifty], fifty).
