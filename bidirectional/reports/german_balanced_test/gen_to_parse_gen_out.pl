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
gen_to_parse_generation_case(5, 5, ok, [fünf], fünf).
gen_to_parse_generation_case(6, 6, ok, [sechs], sechs).
gen_to_parse_generation_case(7, 7, ok, [sieben], sieben).
gen_to_parse_generation_case(8, 8, ok, [acht], acht).
gen_to_parse_generation_case(9, 9, ok, [neun], neun).
gen_to_parse_generation_case(10, 10, ok, [zehn], zehn).
gen_to_parse_generation_case(11, 11, ok, [elf], elf).
gen_to_parse_generation_case(12, 12, ok, [zwölf], zwölf).
gen_to_parse_generation_case(13, 13, gen_empty_yield, [], '').
gen_to_parse_generation_case(14, 15, gen_empty_yield, [], '').
gen_to_parse_generation_case(15, 20, ok, [zwanzig], zwanzig).
gen_to_parse_generation_case(16, 30, gen_empty_yield, [], '').
gen_to_parse_generation_case(17, 60, ok, [sechzig], sechzig).
gen_to_parse_generation_case(18, 70, ok, [siebzig], siebzig).
gen_to_parse_generation_case(19, '1X+20'(1), ok, [undzwanzig,eins], undzwanzigeins).
gen_to_parse_generation_case(20, '1X+20'(2), ok, [zwei,undzwanzig], zweiundzwanzig).
gen_to_parse_generation_case(21, '1X+20'(3), ok, [undzwanzig,drei], undzwanzigdrei).
gen_to_parse_generation_case(22, '1X+20'(4), ok, [undzwanzig,vier], undzwanzigvier).
gen_to_parse_generation_case(23, '1X+20'(5), ok, [undzwanzig,fünf], undzwanzigfünf).
gen_to_parse_generation_case(24, '1X+20'(6), ok, [sechs,undzwanzig], sechsundzwanzig).
gen_to_parse_generation_case(25, '1X+20'(7), ok, [sieben,undzwanzig], siebenundzwanzig).
gen_to_parse_generation_case(26, '1X+20'(8), ok, [undzwanzig,acht], undzwanzigacht).
gen_to_parse_generation_case(27, '1X+20'(9), ok, [undzwanzig,neun], undzwanzigneun).
gen_to_parse_generation_case(28, '1X+60'(1), ok, [undsechzig,eins], undsechzigeins).
gen_to_parse_generation_case(29, '1X+60'(2), ok, [zwei,undsechzig], zweiundsechzig).
gen_to_parse_generation_case(30, '1X+60'(4), ok, [undsechzig,vier], undsechzigvier).
gen_to_parse_generation_case(31, '1X+60'(6), ok, [sechs,undsechzig], sechsundsechzig).
gen_to_parse_generation_case(32, '1X+60'(7), ok, [sieben,undsechzig], siebenundsechzig).
gen_to_parse_generation_case(33, '1X+60'(8), ok, [undsechzig,acht], undsechzigacht).
gen_to_parse_generation_case(34, '1X+70'(1), ok, [undsiebzig,eins], undsiebzigeins).
gen_to_parse_generation_case(35, '1X+70'(2), ok, [zwei,undsiebzig], zweiundsiebzig).
gen_to_parse_generation_case(36, '1X+70'(4), ok, [undsiebzig,vier], undsiebzigvier).
gen_to_parse_generation_case(37, '1X+70'(6), ok, [sechs,undsiebzig], sechsundsiebzig).
gen_to_parse_generation_case(38, '1X+70'(7), ok, [sieben,undsiebzig], siebenundsiebzig).
gen_to_parse_generation_case(39, '1X+70'(8), ok, [undsiebzig,acht], undsiebzigacht).
gen_to_parse_generation_case(40, 100, ok, [hundert], hundert).
gen_to_parse_generation_case(41, '100X'(2), ok, [zwei,hundert], zweihundert).
gen_to_parse_generation_case(42, '100X'(3), ok, [hundert,drei], hundertdrei).
gen_to_parse_generation_case(43, '100X'(5), ok, [hundert,fünf], hundertfünf).
gen_to_parse_generation_case(44, '1X+100'(20), ok, [hundert,zwanzig], hundertzwanzig).
gen_to_parse_generation_case(45, '1X+100'(30), generation_timeout, [], '').
gen_to_parse_generation_case(46, '1X+100'(60), ok, [hundert,sechzig], hundertsechzig).
gen_to_parse_generation_case(47, '1X+100'(70), ok, [hundert,siebzig], hundertsiebzig).
gen_to_parse_generation_case(48, '1X+40'(4), gen_empty_yield, [], '').
gen_to_parse_generation_case(49, '1X+50'(6), gen_empty_yield, [], '').
gen_to_parse_generation_case(50, '1X+80'(8), gen_empty_yield, [], '').
gen_to_parse_generation_case(51, 'UNKNOWN_SEM'(4), gen_empty_yield, [], '').
