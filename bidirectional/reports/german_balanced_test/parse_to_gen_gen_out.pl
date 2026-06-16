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
parse_to_gen_generation_case(5, [fuenf], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(6, [sechs], ok, 6, ok, [sechs], [sechs], sechs).
parse_to_gen_generation_case(7, [sieben], ok, 7, ok, [sieben], [sieben], sieben).
parse_to_gen_generation_case(8, [acht], ok, 8, ok, [acht], [acht], acht).
parse_to_gen_generation_case(9, [neun], ok, 9, ok, [neun], [neun], neun).
parse_to_gen_generation_case(10, [zehn], ok, 10, ok, [zehn], [zehn], zehn).
parse_to_gen_generation_case(11, [elf], ok, 11, ok, [elf], [elf], elf).
parse_to_gen_generation_case(12, [zwoelf], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(13, [dreizehn], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(14, [fuenfzehn], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(15, [zwanzig], ok, 20, ok, [zwanzig], [zwanzig], zwanzig).
parse_to_gen_generation_case(16, [dreissig], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(17, [sechzig], ok, 60, ok, [sechzig], [sechzig], sechzig).
parse_to_gen_generation_case(18, [siebzig], ok, 70, ok, [siebzig], [siebzig], siebzig).
parse_to_gen_generation_case(19, [eins,undzwanzig], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(20, [zwei,undzwanzig], ok, '1X+20'(2), ok, [zwei,undzwanzig], [zwei,undzwanzig], zweiundzwanzig).
parse_to_gen_generation_case(21, [drei,undzwanzig], ok, '1X+20'(3), ok, [undzwanzig,drei], [undzwanzig,drei], undzwanzigdrei).
parse_to_gen_generation_case(22, [vier,undzwanzig], ok, '1X+20'(4), ok, [undzwanzig,vier], [undzwanzig,vier], undzwanzigvier).
parse_to_gen_generation_case(23, [fuenf,undzwanzig], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(24, [sechs,undzwanzig], ok, '1X+20'(6), ok, [sechs,undzwanzig], [sechs,undzwanzig], sechsundzwanzig).
parse_to_gen_generation_case(25, [sieben,undzwanzig], ok, '1X+20'(7), ok, [sieben,undzwanzig], [sieben,undzwanzig], siebenundzwanzig).
parse_to_gen_generation_case(26, [acht,undzwanzig], ok, '1X+20'(8), ok, [undzwanzig,acht], [undzwanzig,acht], undzwanzigacht).
parse_to_gen_generation_case(27, [neun,undzwanzig], ok, '1X+20'(9), ok, [undzwanzig,neun], [undzwanzig,neun], undzwanzigneun).
parse_to_gen_generation_case(28, [eins,undsechzig], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(29, [zwei,undsechzig], ok, plus60(2), gen_empty_yield, [], [], '').
parse_to_gen_generation_case(30, [vier,undsechzig], ok, plus60(4), gen_empty_yield, [], [], '').
parse_to_gen_generation_case(31, [sechs,undsechzig], ok, plus60(6), gen_empty_yield, [], [], '').
parse_to_gen_generation_case(32, [sieben,undsechzig], ok, plus60(7), gen_empty_yield, [], [], '').
parse_to_gen_generation_case(33, [acht,undsechzig], ok, plus60(8), gen_empty_yield, [], [], '').
parse_to_gen_generation_case(34, [eins,undsiebzig], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(35, [zwei,undsiebzig], ok, plus70(2), gen_empty_yield, [], [], '').
parse_to_gen_generation_case(36, [vier,undsiebzig], ok, plus70(4), gen_empty_yield, [], [], '').
parse_to_gen_generation_case(37, [sechs,undsiebzig], ok, plus70(6), gen_empty_yield, [], [], '').
parse_to_gen_generation_case(38, [sieben,undsiebzig], ok, plus70(7), gen_empty_yield, [], [], '').
parse_to_gen_generation_case(39, [acht,undsiebzig], ok, plus70(8), gen_empty_yield, [], [], '').
parse_to_gen_generation_case(40, [hundert], ok, 100, ok, [hundert], [hundert], hundert).
parse_to_gen_generation_case(41, [zwei,hundert], ok, '100X'(2), ok, [zwei,hundert], [zwei,hundert], zweihundert).
parse_to_gen_generation_case(42, [drei,hundert], ok, '100X'(3), ok, [hundert,drei], [hundert,drei], hundertdrei).
parse_to_gen_generation_case(43, [fuenf,hundert], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(44, [hundert,zwanzig], ok, '1X+100'(20), ok, [hundert,zwanzig], [hundert,zwanzig], hundertzwanzig).
parse_to_gen_generation_case(45, [hundert,dreissig], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(46, [hundert,sechzig], ok, '1X+100'(60), ok, [hundert,sechzig], [hundert,sechzig], hundertsechzig).
parse_to_gen_generation_case(47, [hundert,siebzig], ok, '1X+100'(70), ok, [hundert,siebzig], [hundert,siebzig], hundertsiebzig).
parse_to_gen_generation_case(48, [banana], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(49, [und,zwanzig], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(50, [zwanzig,und,zwei], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(51, [vier,und,vierzig], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(52, [sechs,und,fuenfzig], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(53, [acht,und,achtzig], parse_fail, none, generation_not_attempted, [], [], '').
