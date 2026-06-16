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
parse_to_gen_generation_case(5, [fünf], ok, 5, ok, [fünf], [fünf], fünf).
parse_to_gen_generation_case(6, [sechs], ok, 6, ok, [sechs], [sechs], sechs).
parse_to_gen_generation_case(7, [sieben], ok, 7, ok, [sieben], [sieben], sieben).
parse_to_gen_generation_case(8, [acht], ok, 8, ok, [acht], [acht], acht).
parse_to_gen_generation_case(9, [neun], ok, 9, ok, [neun], [neun], neun).
parse_to_gen_generation_case(10, [zehn], ok, 10, ok, [zehn], [zehn], zehn).
parse_to_gen_generation_case(11, [elf], ok, 11, ok, [elf], [elf], elf).
parse_to_gen_generation_case(12, [zwölf], ok, 12, ok, [zwölf], [zwölf], zwölf).
parse_to_gen_generation_case(13, [sechzehn], ok, 16, ok, [sechzehn], [sechzehn], sechzehn).
parse_to_gen_generation_case(14, [siebzehn], ok, 17, ok, [siebzehn], [siebzehn], siebzehn).
parse_to_gen_generation_case(15, [zwanzig], ok, 20, ok, [zwanzig], [zwanzig], zwanzig).
parse_to_gen_generation_case(16, [einundzwanzig], ok, 21, ok, [einundzwanzig], [einundzwanzig], einundzwanzig).
parse_to_gen_generation_case(17, [sechzig], ok, 60, ok, [sechzig], [sechzig], sechzig).
parse_to_gen_generation_case(18, [einundsechzig], ok, 61, ok, [einundsechzig], [einundsechzig], einundsechzig).
parse_to_gen_generation_case(19, [siebzig], ok, 70, ok, [siebzig], [siebzig], siebzig).
parse_to_gen_generation_case(20, [einundsiebzig], ok, 71, ok, [einundsiebzig], [einundsiebzig], einundsiebzig).
parse_to_gen_generation_case(21, [hundert], ok, 100, ok, [hundert], [hundert], hundert).
parse_to_gen_generation_case(22, [zwei,undzwanzig], ok, '1X+20'(2), ok, [zwei,undzwanzig], [zwei,undzwanzig], zweiundzwanzig).
parse_to_gen_generation_case(23, [drei,ßig], ok, '0X+30'(3), ok, [ßig,drei], [ßig,drei], ßigdrei).
parse_to_gen_generation_case(24, [zwei,und,drei,ßig], ok, '1X+1Y+3'('9X'(3),2), generation_timeout, [], [], '').
parse_to_gen_generation_case(25, [sieben,und,vier,zig], ok, '1X+1Y'('10X+N'(4),7), generation_timeout, [], [], '').
parse_to_gen_generation_case(26, [drei,hundert], ok, '100X'(3), ok, [hundert,drei], [hundert,drei], hundertdrei).
parse_to_gen_generation_case(27, [drei,hundert,vier], ok, '1X+100Y'(4,3), generation_timeout, [], [], '').
parse_to_gen_generation_case(28, [drei,hundert,vier,zig], ok, '1X+100Y'('10X'(4),3), generation_timeout, [], [], '').
parse_to_gen_generation_case(29, [drei,undzwanzig], ok, '1X+20'(3), ok, [undzwanzig,drei], [undzwanzig,drei], undzwanzigdrei).
parse_to_gen_generation_case(30, [vier,undzwanzig], ok, '1X+20'(4), ok, [undzwanzig,vier], [undzwanzig,vier], undzwanzigvier).
parse_to_gen_generation_case(31, [fünf,undzwanzig], ok, '1X+20'(5), ok, [undzwanzig,fünf], [undzwanzig,fünf], undzwanzigfünf).
parse_to_gen_generation_case(32, [sechs,undzwanzig], ok, '1X+20'(6), ok, [sechs,undzwanzig], [sechs,undzwanzig], sechsundzwanzig).
parse_to_gen_generation_case(33, [sieben,undzwanzig], ok, '1X+20'(7), ok, [sieben,undzwanzig], [sieben,undzwanzig], siebenundzwanzig).
parse_to_gen_generation_case(34, [acht,undzwanzig], ok, '1X+20'(8), ok, [undzwanzig,acht], [undzwanzig,acht], undzwanzigacht).
parse_to_gen_generation_case(35, [neun,undzwanzig], ok, '1X+20'(9), ok, [undzwanzig,neun], [undzwanzig,neun], undzwanzigneun).
parse_to_gen_generation_case(36, [vier,ßig], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(37, [fünf,ßig], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(38, [acht,ßig], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(39, [neun,ßig], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(40, [vier,zig], ok, '10X'(4), ok, [zig,vier], [zig,vier], zigvier).
parse_to_gen_generation_case(41, [sechs,zig], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(42, [sieben,zig], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(43, [acht,zig], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(44, [neun,zig], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(45, [zwei,und,vier,zig], ok, '1X+1Y'('10X+N'(4),2), generation_timeout, [], [], '').
parse_to_gen_generation_case(46, [drei,und,vier,zig], ok, '1X+1Y'('10X+N'(4),3), generation_timeout, [], [], '').
parse_to_gen_generation_case(47, [fünf,und,vier,zig], ok, '1X+1Y'('10X+N'(4),5), generation_timeout, [], [], '').
parse_to_gen_generation_case(48, [neun,und,vier,zig], ok, '1X+1Y'('10X+N'(4),9), generation_timeout, [], [], '').
parse_to_gen_generation_case(49, [zwei,hundert], ok, '100X'(2), ok, [zwei,hundert], [zwei,hundert], zweihundert).
parse_to_gen_generation_case(50, [vier,hundert], ok, '100X'(4), ok, [hundert,vier], [hundert,vier], hundertvier).
parse_to_gen_generation_case(51, [fünf,hundert], ok, '100X'(5), ok, [hundert,fünf], [hundert,fünf], hundertfünf).
parse_to_gen_generation_case(52, [sechs,hundert], ok, '100X'(6), ok, [sechs,hundert], [sechs,hundert], sechshundert).
parse_to_gen_generation_case(53, [sieben,hundert], ok, '100X'(7), ok, [sieben,hundert], [sieben,hundert], siebenhundert).
parse_to_gen_generation_case(54, [acht,hundert], ok, '100X'(8), ok, [hundert,acht], [hundert,acht], hundertacht).
parse_to_gen_generation_case(55, [neun,hundert], ok, '100X'(9), ok, [hundert,neun], [hundert,neun], hundertneun).
parse_to_gen_generation_case(56, [drei,hundert,zehn], ok, '1X+100Y'(10,3), generation_timeout, [], [], '').
parse_to_gen_generation_case(57, [drei,hundert,zwanzig], ok, '1X+100Y'(20,3), generation_timeout, [], [], '').
parse_to_gen_generation_case(58, [drei,hundert,sechzig], ok, '1X+100Y'(60,3), generation_timeout, [], [], '').
parse_to_gen_generation_case(59, [drei,hundert,siebzig], ok, '1X+100Y'(70,3), generation_timeout, [], [], '').
parse_to_gen_generation_case(60, [vier,hundert,drei], ok, '1X+100Y'(3,4), generation_timeout, [], [], '').
parse_to_gen_generation_case(61, [vier,hundert,zwanzig], ok, '1X+100Y'(20,4), generation_timeout, [], [], '').
parse_to_gen_generation_case(62, [vier,hundert,drei,ßig], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(63, [vier,hundert,sieben,und,vier,zig], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(64, [sieben,und,acht,zig], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(65, [drei,hundert,sieben,und,vier,zig], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(66, [acht], ok, 8, ok, [acht], [acht], acht).
parse_to_gen_generation_case(67, [undzwanzig,zwei], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(68, [zig,vier], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(69, [hundert,drei], ok, '1X+100'(3), generation_timeout, [], [], '').
parse_to_gen_generation_case(70, [und], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(71, [zig], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(72, [ßig], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(73, [einund], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(74, [zwei,und], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(75, [drei,hundert,und], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(76, [eins,undzwanzig], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(77, [eins,und,drei,ßig], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(78, [hundert,hundert], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(79, [drei,hundert,hundert], parse_fail, none, generation_not_attempted, [], [], '').
