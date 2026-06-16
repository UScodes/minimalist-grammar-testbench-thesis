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

gen_to_parse_generation_case(1, '1X+30'(1), ok, [thirty,one], thirtyone).
gen_to_parse_generation_case(2, '1X+30'(2), ok, [thirty,two], thirtytwo).
gen_to_parse_generation_case(3, '1X+30'(3), ok, [thirty,three], thirtythree).
gen_to_parse_generation_case(4, '1X+30'(4), ok, [thirty,four], thirtyfour).
gen_to_parse_generation_case(5, '1X+30'(5), ok, [thirty,five], thirtyfive).
gen_to_parse_generation_case(6, '1X+30'(6), ok, [thirty,six], thirtysix).
gen_to_parse_generation_case(7, '1X+30'(7), ok, [thirty,seven], thirtyseven).
gen_to_parse_generation_case(8, '1X+30'(8), ok, [thirty,eight], thirtyeight).
gen_to_parse_generation_case(9, '1X+30'(9), ok, [thirty,nine], thirtynine).
