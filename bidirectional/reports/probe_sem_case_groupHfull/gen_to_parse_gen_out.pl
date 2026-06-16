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

gen_to_parse_generation_case(1, '1X+100Y'(1,20), ok, [one,hundred_and,twenty], onehundred_andtwenty).
gen_to_parse_generation_case(2, '1X+100Y'(2,30), ok, [two,hundred_and,thirty], twohundred_andthirty).
gen_to_parse_generation_case(3, '1X+100Y'(3,'1X+20'(4)), ok, [three,hundred_and,twenty,four], threehundred_andtwentyfour).
gen_to_parse_generation_case(4, '1X+100Y'(5,'1X+30'(6)), ok, [five,hundred_and,thirty,six], fivehundred_andthirtysix).
