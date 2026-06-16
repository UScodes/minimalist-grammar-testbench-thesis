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

gen_to_parse_generation_case(1, '1X+50'(1), ok, [fifty,one], fiftyone).
gen_to_parse_generation_case(2, '1X+50'(2), ok, [fifty,two], fiftytwo).
gen_to_parse_generation_case(3, '1X+50'(3), ok, [fifty,three], fiftythree).
gen_to_parse_generation_case(4, '1X+50'(4), ok, [fifty,four], fiftyfour).
gen_to_parse_generation_case(5, '1X+50'(5), ok, [fifty,five], fiftyfive).
gen_to_parse_generation_case(6, '1X+50'(6), ok, [fifty,six], fiftysix).
gen_to_parse_generation_case(7, '1X+50'(7), ok, [fifty,seven], fiftyseven).
gen_to_parse_generation_case(8, '1X+50'(8), ok, [fifty,eight], fiftyeight).
gen_to_parse_generation_case(9, '1X+50'(9), ok, [fifty,nine], fiftynine).
