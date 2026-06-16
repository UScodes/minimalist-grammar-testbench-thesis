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
gen_to_parse_generation_case(2, '1X+20'(4), ok, [twenty,four], twentyfour).
gen_to_parse_generation_case(3, '1X+20'(7), ok, [twenty,seven], twentyseven).
gen_to_parse_generation_case(4, '1X+30'(4), ok, [thirty,four], thirtyfour).
gen_to_parse_generation_case(5, '1X+50'(6), ok, [fifty,six], fiftysix).
