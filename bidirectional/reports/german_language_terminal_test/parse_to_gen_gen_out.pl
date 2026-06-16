% =============================================================================
% Parsing-to-Generation: Generation-stage Output
% =============================================================================
% Each fact has the form:
%
%   parse_to_gen_generation_case(CaseId, TokenInput, ParsingStatus, RecoveredSemanticOutput, GenerationStatus, GeneratedTokens, ComparisonTokens, GeneratedSentence).
%
% Meaning:
%   CaseId                   - numeric identifier shared across all artifacts for the same test case
%   TokenInput               - original token sequence used in the parsing stage
%   ParsingStatus            - result of the parsing stage
%   RecoveredSemanticOutput  - semantic representation recovered by the parser, or none if parsing failed
%   GenerationStatus         - result of the generation stage, e.g. ok, gen_empty_yield, generation_timeout
%   GeneratedTokens          - raw token sequence produced by the generator stage
%   ComparisonTokens         - generated tokens after normalization; used for comparison with the original token input
%   GeneratedSentence        - sentence atom derived from GeneratedTokens for report consistency
% =============================================================================

parse_to_gen_generation_case(1, [eins], ok, 1, ok, [eins], [eins], eins).
parse_to_gen_generation_case(2, [zwei], ok, 2, ok, [zwei], [zwei], zwei).
parse_to_gen_generation_case(3, [drei], ok, 3, ok, [drei], [drei], drei).
parse_to_gen_generation_case(4, [vier], ok, 4, ok, [vier], [vier], vier).
parse_to_gen_generation_case(5, [sechs], ok, 6, ok, [sechs], [sechs], sechs).
parse_to_gen_generation_case(6, [sieben], ok, 7, ok, [sieben], [sieben], sieben).
parse_to_gen_generation_case(7, [acht], ok, 8, ok, [acht], [acht], acht).
parse_to_gen_generation_case(8, [neun], ok, 9, ok, [neun], [neun], neun).
parse_to_gen_generation_case(9, [zehn], ok, 10, ok, [zehn], [zehn], zehn).
parse_to_gen_generation_case(10, [elf], ok, 11, ok, [elf], [elf], elf).
parse_to_gen_generation_case(11, [sechzehn], ok, 16, ok, [sechzehn], [sechzehn], sechzehn).
parse_to_gen_generation_case(12, [siebzehn], ok, 17, ok, [siebzehn], [siebzehn], siebzehn).
parse_to_gen_generation_case(13, [zwanzig], ok, 20, ok, [zwanzig], [zwanzig], zwanzig).
parse_to_gen_generation_case(14, [einundzwanzig], ok, 21, ok, [einundzwanzig], [einundzwanzig], einundzwanzig).
parse_to_gen_generation_case(15, [sechzig], ok, 60, ok, [sechzig], [sechzig], sechzig).
parse_to_gen_generation_case(16, [einundsechzig], ok, 61, ok, [einundsechzig], [einundsechzig], einundsechzig).
parse_to_gen_generation_case(17, [siebzig], ok, 70, ok, [siebzig], [siebzig], siebzig).
parse_to_gen_generation_case(18, [einundsiebzig], ok, 71, ok, [einundsiebzig], [einundsiebzig], einundsiebzig).
parse_to_gen_generation_case(19, [hundert], ok, 100, ok, [hundert], [hundert], hundert).
parse_to_gen_generation_case(20, [zwei,undzwanzig], ok, '1X+20'(2), ok, [zwei,undzwanzig], [zwei,undzwanzig], zweiundzwanzig).
parse_to_gen_generation_case(21, [sechs,undzwanzig], ok, '1X+20'(6), ok, [sechs,undzwanzig], [sechs,undzwanzig], sechsundzwanzig).
parse_to_gen_generation_case(22, [sieben,undzwanzig], ok, '1X+20'(7), ok, [sieben,undzwanzig], [sieben,undzwanzig], siebenundzwanzig).
parse_to_gen_generation_case(23, [zwei,hundert], ok, '100X'(2), ok, [zwei,hundert], [zwei,hundert], zweihundert).
parse_to_gen_generation_case(24, [sechs,hundert], ok, '100X'(6), ok, [sechs,hundert], [sechs,hundert], sechshundert).
parse_to_gen_generation_case(25, [sieben,hundert], ok, '100X'(7), ok, [sieben,hundert], [sieben,hundert], siebenhundert).
parse_to_gen_generation_case(26, [drei,undzwanzig], ok, '1X+20'(3), ok, [undzwanzig,drei], [undzwanzig,drei], undzwanzigdrei).
parse_to_gen_generation_case(27, [vier,zig], ok, '10X'(4), ok, [zig,vier], [zig,vier], zigvier).
parse_to_gen_generation_case(28, [drei,hundert], ok, '100X'(3), ok, [hundert,drei], [hundert,drei], hundertdrei).
parse_to_gen_generation_case(29, [sieben,und,vier,zig], ok, '1X+1Y'('10X+N'(4),7), generation_timeout, [], [], '').
parse_to_gen_generation_case(30, [drei,hundert,vier], ok, '1X+100Y'(4,3), generation_timeout, [], [], '').
parse_to_gen_generation_case(31, [sieben,und,acht,zig], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(32, ['Schinken'], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(33, [hundert,hundert], parse_fail, none, generation_not_attempted, [], [], '').
