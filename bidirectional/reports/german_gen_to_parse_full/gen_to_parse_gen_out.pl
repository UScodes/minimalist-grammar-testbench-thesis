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
gen_to_parse_generation_case(13, 16, ok, [sechzehn], sechzehn).
gen_to_parse_generation_case(14, 17, ok, [siebzehn], siebzehn).
gen_to_parse_generation_case(15, 20, ok, [zwanzig], zwanzig).
gen_to_parse_generation_case(16, 21, ok, [einundzwanzig], einundzwanzig).
gen_to_parse_generation_case(17, 60, ok, [sechzig], sechzig).
gen_to_parse_generation_case(18, 61, ok, [einundsechzig], einundsechzig).
gen_to_parse_generation_case(19, 70, ok, [siebzig], siebzig).
gen_to_parse_generation_case(20, 71, ok, [einundsiebzig], einundsiebzig).
gen_to_parse_generation_case(21, 100, ok, [hundert], hundert).
gen_to_parse_generation_case(22, '1X+10'(3), ok, [zehn,drei], zehndrei).
gen_to_parse_generation_case(23, '1X+10'(4), ok, [zehn,vier], zehnvier).
gen_to_parse_generation_case(24, '1X+10'(5), ok, [zehn,fünf], zehnfünf).
gen_to_parse_generation_case(25, '1X+10'(8), ok, [zehn,acht], zehnacht).
gen_to_parse_generation_case(26, '1X+10'(9), ok, [zehn,neun], zehnneun).
gen_to_parse_generation_case(27, '1X+20'(2), ok, [zwei,undzwanzig], zweiundzwanzig).
gen_to_parse_generation_case(28, '1X+20'(3), ok, [undzwanzig,drei], undzwanzigdrei).
gen_to_parse_generation_case(29, '1X+20'(4), ok, [undzwanzig,vier], undzwanzigvier).
gen_to_parse_generation_case(30, '1X+20'(5), ok, [undzwanzig,fünf], undzwanzigfünf).
gen_to_parse_generation_case(31, '1X+20'(6), ok, [sechs,undzwanzig], sechsundzwanzig).
gen_to_parse_generation_case(32, '1X+20'(7), ok, [sieben,undzwanzig], siebenundzwanzig).
gen_to_parse_generation_case(33, '1X+20'(8), ok, [undzwanzig,acht], undzwanzigacht).
gen_to_parse_generation_case(34, '1X+20'(9), ok, [undzwanzig,neun], undzwanzigneun).
gen_to_parse_generation_case(35, '0X+30'(3), ok, [ßig,drei], ßigdrei).
gen_to_parse_generation_case(36, '0X+30'(4), ok, [ßig,vier], ßigvier).
gen_to_parse_generation_case(37, '0X+30'(5), ok, [ßig,fünf], ßigfünf).
gen_to_parse_generation_case(38, '0X+30'(8), ok, [ßig,acht], ßigacht).
gen_to_parse_generation_case(39, '0X+30'(9), ok, [ßig,neun], ßigneun).
gen_to_parse_generation_case(40, '10X'(4), ok, [zig,vier], zigvier).
gen_to_parse_generation_case(41, '10X'(6), ok, [zig,sechs], zigsechs).
gen_to_parse_generation_case(42, '10X'(7), ok, [zig,sieben], zigsieben).
gen_to_parse_generation_case(43, '10X'(8), ok, [zig,acht], zigacht).
gen_to_parse_generation_case(44, '10X'(9), ok, [zig,neun], zigneun).
gen_to_parse_generation_case(45, '1X+1'(4), generation_timeout, [], '').
gen_to_parse_generation_case(46, '1X+31'(1), generation_timeout, [], '').
gen_to_parse_generation_case(47, '1X+31'(3), generation_timeout, [], '').
gen_to_parse_generation_case(48, '1X+1Y+3'(2,3), generation_timeout, [], '').
gen_to_parse_generation_case(49, '1X+1Y+3'(7,4), generation_timeout, [], '').
gen_to_parse_generation_case(50, '1X+1Y'(2,4), generation_timeout, [], '').
gen_to_parse_generation_case(51, '1X+1Y'(9,4), generation_timeout, [], '').
gen_to_parse_generation_case(52, '10X+1'(4), gen_empty_yield, [], '').
gen_to_parse_generation_case(53, '10X+N'(4), gen_empty_yield, [], '').
gen_to_parse_generation_case(54, '100X'(2), ok, [zwei,hundert], zweihundert).
gen_to_parse_generation_case(55, '100X'(3), ok, [hundert,drei], hundertdrei).
gen_to_parse_generation_case(56, '100X'(4), ok, [hundert,vier], hundertvier).
gen_to_parse_generation_case(57, '100X'(5), ok, [hundert,fünf], hundertfünf).
gen_to_parse_generation_case(58, '100X'(8), ok, [hundert,acht], hundertacht).
gen_to_parse_generation_case(59, '100X'(9), ok, [hundert,neun], hundertneun).
gen_to_parse_generation_case(60, '1X+100'(3), generation_timeout, [], '').
gen_to_parse_generation_case(61, '1X+100'(4), generation_timeout, [], '').
gen_to_parse_generation_case(62, '1X+100'(20), ok, [hundert,zwanzig], hundertzwanzig).
gen_to_parse_generation_case(63, '1X+100'(60), ok, [hundert,sechzig], hundertsechzig).
gen_to_parse_generation_case(64, '1X+100'(70), ok, [hundert,siebzig], hundertsiebzig).
gen_to_parse_generation_case(65, '1X+100Y'(3,4), generation_timeout, [], '').
gen_to_parse_generation_case(66, '1X+100Y'(3,20), generation_timeout, [], '').
gen_to_parse_generation_case(67, '1X+100Y'(3,'10X'(4)), generation_timeout, [], '').
gen_to_parse_generation_case(68, '1X+100Y'(4,'0X+30'(3)), generation_timeout, [], '').
gen_to_parse_generation_case(69, '1X+100Y'(4,'1X+1Y'(7,4)), generation_timeout, [], '').
gen_to_parse_generation_case(70, '1X+60'(2), ok, [zwei,undsechzig], zweiundsechzig).
gen_to_parse_generation_case(71, '1X+60'(4), ok, [undsechzig,vier], undsechzigvier).
gen_to_parse_generation_case(72, '1X+70'(2), ok, [zwei,undsiebzig], zweiundsiebzig).
gen_to_parse_generation_case(73, '1X+70'(4), ok, [undsiebzig,vier], undsiebzigvier).
gen_to_parse_generation_case(74, plus60(2), gen_empty_yield, [], '').
gen_to_parse_generation_case(75, plus60(4), gen_empty_yield, [], '').
gen_to_parse_generation_case(76, plus70(2), gen_empty_yield, [], '').
gen_to_parse_generation_case(77, plus70(4), gen_empty_yield, [], '').
gen_to_parse_generation_case(78, 'UNKNOWN_GERMAN_SEM'(4), gen_empty_yield, [], '').
gen_to_parse_generation_case(79, 'BAD_GERMAN_FORM', gen_empty_yield, [], '').
gen_to_parse_generation_case(80, '1X+999'(3), gen_empty_yield, [], '').
gen_to_parse_generation_case(81, '1000X'(2), gen_empty_yield, [], '').
