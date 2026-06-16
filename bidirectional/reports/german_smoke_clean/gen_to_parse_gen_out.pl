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

gen_to_parse_generation_case(1, 1, ok, [eins], eins).
gen_to_parse_generation_case(2, 2, ok, [zwei], zwei).
gen_to_parse_generation_case(3, 3, ok, [drei], drei).
gen_to_parse_generation_case(4, 4, ok, [vier], vier).
gen_to_parse_generation_case(5, 6, ok, [sechs], sechs).
gen_to_parse_generation_case(6, 7, ok, [sieben], sieben).
gen_to_parse_generation_case(7, 8, ok, [acht], acht).
gen_to_parse_generation_case(8, 9, ok, [neun], neun).
gen_to_parse_generation_case(9, 10, ok, [zehn], zehn).
gen_to_parse_generation_case(10, 11, ok, [elf], elf).
gen_to_parse_generation_case(11, 16, ok, [sechzehn], sechzehn).
gen_to_parse_generation_case(12, 17, ok, [siebzehn], siebzehn).
gen_to_parse_generation_case(13, 20, ok, [zwanzig], zwanzig).
gen_to_parse_generation_case(14, 21, ok, [einundzwanzig], einundzwanzig).
gen_to_parse_generation_case(15, 60, ok, [sechzig], sechzig).
gen_to_parse_generation_case(16, 61, ok, [einundsechzig], einundsechzig).
gen_to_parse_generation_case(17, 70, ok, [siebzig], siebzig).
gen_to_parse_generation_case(18, 71, ok, [einundsiebzig], einundsiebzig).
gen_to_parse_generation_case(19, 100, ok, [hundert], hundert).
gen_to_parse_generation_case(20, '1X+20'(2), ok, [zwei,undzwanzig], zweiundzwanzig).
gen_to_parse_generation_case(21, '1X+20'(6), ok, [sechs,undzwanzig], sechsundzwanzig).
gen_to_parse_generation_case(22, '1X+20'(7), ok, [sieben,undzwanzig], siebenundzwanzig).
gen_to_parse_generation_case(23, '100X'(2), ok, [zwei,hundert], zweihundert).
gen_to_parse_generation_case(24, '1X+100'(20), ok, [hundert,zwanzig], hundertzwanzig).
gen_to_parse_generation_case(25, '1X+100'(60), ok, [hundert,sechzig], hundertsechzig).
gen_to_parse_generation_case(26, '1X+100'(70), ok, [hundert,siebzig], hundertsiebzig).
