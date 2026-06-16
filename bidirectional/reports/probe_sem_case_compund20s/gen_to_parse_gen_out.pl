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

gen_to_parse_generation_case(1, '1X+20'(1), ok, [twenty,one], twentyone).
gen_to_parse_generation_case(2, '1X+20'(2), ok, [twenty,two], twentytwo).
gen_to_parse_generation_case(3, '1X+20'(3), ok, [twenty,three], twentythree).
gen_to_parse_generation_case(4, '1X+20'(4), ok, [twenty,four], twentyfour).
gen_to_parse_generation_case(5, '1X+20'(5), ok, [twenty,five], twentyfive).
gen_to_parse_generation_case(6, '1X+20'(6), ok, [twenty,six], twentysix).
gen_to_parse_generation_case(7, '1X+20'(7), ok, [twenty,seven], twentyseven).
gen_to_parse_generation_case(8, '1X+20'(8), ok, [twenty,eight], twentyeight).
gen_to_parse_generation_case(9, '1X+20'(9), ok, [twenty,nine], twentynine).
