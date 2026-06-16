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

gen_to_parse_generation_case(1, '10X'(4), ok, [four,ty], fourty).
gen_to_parse_generation_case(2, '10X'(6), ok, [six,ty], sixty).
gen_to_parse_generation_case(3, '10X'(7), ok, [seven,ty], seventy).
gen_to_parse_generation_case(4, '0X+80'(8), ok, [eight,y], eighty).
gen_to_parse_generation_case(5, '1X+40'(4), gen_empty_yield, [], '').
gen_to_parse_generation_case(6, '1X+60'(4), gen_empty_yield, [], '').
gen_to_parse_generation_case(7, '1X+70'(4), gen_empty_yield, [], '').
gen_to_parse_generation_case(8, '1X+80'(4), gen_empty_yield, [], '').
gen_to_parse_generation_case(9, '1X+90'(4), gen_empty_yield, [], '').
