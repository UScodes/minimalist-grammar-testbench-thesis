% =============================================================================
% Generation-to-Parsing: Parsing-stage Output
% =============================================================================
% Each fact has the form:
%
%   gen_to_parse_parsing_case(CaseId, SemanticInput, GenerationStatus, GeneratedTokens, ParserInputTokens, ParsingStatus, RecoveredSemanticOutput).
%
% Meaning:
%   CaseId                   - numeric identifier shared across all artifacts for the same test case
%   SemanticInput            - original semantic input used in the generation stage
%   GenerationStatus         - result of the generation stage
%   GeneratedTokens          - raw token sequence produced by the generation stage
%   ParserInputTokens        - token sequence after normalization; passed to the parser
%   ParsingStatus            - result of the parsing stage, e.g. ok, parse_fail, parse_timeout
%   RecoveredSemanticOutput  - semantic representation recovered by the parser, or none if parsing failed
% =============================================================================

gen_to_parse_parsing_case(1, 1, ok, [eins], [eins], ok, 1).
gen_to_parse_parsing_case(2, 2, ok, [zwei], [zwei], ok, 2).
gen_to_parse_parsing_case(3, 3, ok, [drei], [drei], ok, 3).
gen_to_parse_parsing_case(4, 4, ok, [vier], [vier], ok, 4).
gen_to_parse_parsing_case(5, 5, ok, [fünf], [fünf], ok, 5).
gen_to_parse_parsing_case(6, 6, ok, [sechs], [sechs], ok, 6).
gen_to_parse_parsing_case(7, 7, ok, [sieben], [sieben], ok, 7).
gen_to_parse_parsing_case(8, 8, ok, [acht], [acht], ok, 8).
gen_to_parse_parsing_case(9, 9, ok, [neun], [neun], ok, 9).
gen_to_parse_parsing_case(10, 10, ok, [zehn], [zehn], ok, 10).
gen_to_parse_parsing_case(11, 11, ok, [elf], [elf], ok, 11).
gen_to_parse_parsing_case(12, 12, ok, [zwölf], [zwölf], ok, 12).
gen_to_parse_parsing_case(13, 16, ok, [sechzehn], [sechzehn], ok, 16).
gen_to_parse_parsing_case(14, 17, ok, [siebzehn], [siebzehn], ok, 17).
gen_to_parse_parsing_case(15, 20, ok, [zwanzig], [zwanzig], ok, 20).
gen_to_parse_parsing_case(16, 21, ok, [einundzwanzig], [einundzwanzig], ok, 21).
gen_to_parse_parsing_case(17, 60, ok, [sechzig], [sechzig], ok, 60).
gen_to_parse_parsing_case(18, 61, ok, [einundsechzig], [einundsechzig], ok, 61).
gen_to_parse_parsing_case(19, 70, ok, [siebzig], [siebzig], ok, 70).
gen_to_parse_parsing_case(20, 71, ok, [einundsiebzig], [einundsiebzig], ok, 71).
gen_to_parse_parsing_case(21, 100, ok, [hundert], [hundert], ok, 100).
gen_to_parse_parsing_case(22, '1X+10'(3), ok, [zehn,drei], [zehn,drei], parse_fail, none).
gen_to_parse_parsing_case(23, '1X+10'(4), ok, [zehn,vier], [zehn,vier], parse_fail, none).
gen_to_parse_parsing_case(24, '1X+10'(5), ok, [zehn,fünf], [zehn,fünf], parse_fail, none).
gen_to_parse_parsing_case(25, '1X+10'(8), ok, [zehn,acht], [zehn,acht], parse_fail, none).
gen_to_parse_parsing_case(26, '1X+10'(9), ok, [zehn,neun], [zehn,neun], parse_fail, none).
gen_to_parse_parsing_case(27, '1X+20'(2), ok, [zwei,undzwanzig], [zwei,undzwanzig], ok, '1X+20'(2)).
gen_to_parse_parsing_case(28, '1X+20'(3), ok, [undzwanzig,drei], [undzwanzig,drei], parse_fail, none).
gen_to_parse_parsing_case(29, '1X+20'(4), ok, [undzwanzig,vier], [undzwanzig,vier], parse_fail, none).
gen_to_parse_parsing_case(30, '1X+20'(5), ok, [undzwanzig,fünf], [undzwanzig,fünf], parse_fail, none).
gen_to_parse_parsing_case(31, '1X+20'(6), ok, [sechs,undzwanzig], [sechs,undzwanzig], ok, '1X+20'(6)).
gen_to_parse_parsing_case(32, '1X+20'(7), ok, [sieben,undzwanzig], [sieben,undzwanzig], ok, '1X+20'(7)).
gen_to_parse_parsing_case(33, '1X+20'(8), ok, [undzwanzig,acht], [undzwanzig,acht], parse_fail, none).
gen_to_parse_parsing_case(34, '1X+20'(9), ok, [undzwanzig,neun], [undzwanzig,neun], parse_fail, none).
gen_to_parse_parsing_case(35, '0X+30'(3), ok, [ßig,drei], [ßig,drei], parse_fail, none).
gen_to_parse_parsing_case(36, '0X+30'(4), ok, [ßig,vier], [ßig,vier], parse_fail, none).
gen_to_parse_parsing_case(37, '0X+30'(5), ok, [ßig,fünf], [ßig,fünf], parse_fail, none).
gen_to_parse_parsing_case(38, '0X+30'(8), ok, [ßig,acht], [ßig,acht], parse_fail, none).
gen_to_parse_parsing_case(39, '0X+30'(9), ok, [ßig,neun], [ßig,neun], parse_fail, none).
gen_to_parse_parsing_case(40, '10X'(4), ok, [zig,vier], [zig,vier], parse_fail, none).
gen_to_parse_parsing_case(41, '10X'(6), ok, [zig,sechs], [zig,sechs], parse_fail, none).
gen_to_parse_parsing_case(42, '10X'(7), ok, [zig,sieben], [zig,sieben], parse_fail, none).
gen_to_parse_parsing_case(43, '10X'(8), ok, [zig,acht], [zig,acht], parse_fail, none).
gen_to_parse_parsing_case(44, '10X'(9), ok, [zig,neun], [zig,neun], parse_fail, none).
gen_to_parse_parsing_case(45, '1X+1'(4), generation_timeout, [], [], parse_skipped_empty_tokens, none).
gen_to_parse_parsing_case(46, '1X+31'(1), generation_timeout, [], [], parse_skipped_empty_tokens, none).
gen_to_parse_parsing_case(47, '1X+31'(3), generation_timeout, [], [], parse_skipped_empty_tokens, none).
gen_to_parse_parsing_case(48, '1X+1Y+3'(2,3), generation_timeout, [], [], parse_skipped_empty_tokens, none).
gen_to_parse_parsing_case(49, '1X+1Y+3'(7,4), generation_timeout, [], [], parse_skipped_empty_tokens, none).
gen_to_parse_parsing_case(50, '1X+1Y'(2,4), generation_timeout, [], [], parse_skipped_empty_tokens, none).
gen_to_parse_parsing_case(51, '1X+1Y'(9,4), generation_timeout, [], [], parse_skipped_empty_tokens, none).
gen_to_parse_parsing_case(52, '10X+1'(4), gen_empty_yield, [], [], parse_skipped_empty_tokens, none).
gen_to_parse_parsing_case(53, '10X+N'(4), gen_empty_yield, [], [], parse_skipped_empty_tokens, none).
gen_to_parse_parsing_case(54, '100X'(2), ok, [zwei,hundert], [zwei,hundert], ok, '100X'(2)).
gen_to_parse_parsing_case(55, '100X'(3), ok, [hundert,drei], [hundert,drei], ok, '1X+100'(3)).
gen_to_parse_parsing_case(56, '100X'(4), ok, [hundert,vier], [hundert,vier], ok, '1X+100'(4)).
gen_to_parse_parsing_case(57, '100X'(5), ok, [hundert,fünf], [hundert,fünf], ok, '1X+100'(5)).
gen_to_parse_parsing_case(58, '100X'(8), ok, [hundert,acht], [hundert,acht], ok, '1X+100'(8)).
gen_to_parse_parsing_case(59, '100X'(9), ok, [hundert,neun], [hundert,neun], ok, '1X+100'(9)).
gen_to_parse_parsing_case(60, '1X+100'(3), generation_timeout, [], [], parse_skipped_empty_tokens, none).
gen_to_parse_parsing_case(61, '1X+100'(4), generation_timeout, [], [], parse_skipped_empty_tokens, none).
gen_to_parse_parsing_case(62, '1X+100'(20), ok, [hundert,zwanzig], [hundert,zwanzig], ok, '1X+100'(20)).
gen_to_parse_parsing_case(63, '1X+100'(60), ok, [hundert,sechzig], [hundert,sechzig], ok, '1X+100'(60)).
gen_to_parse_parsing_case(64, '1X+100'(70), ok, [hundert,siebzig], [hundert,siebzig], ok, '1X+100'(70)).
gen_to_parse_parsing_case(65, '1X+100Y'(3,4), generation_timeout, [], [], parse_skipped_empty_tokens, none).
gen_to_parse_parsing_case(66, '1X+100Y'(3,20), generation_timeout, [], [], parse_skipped_empty_tokens, none).
gen_to_parse_parsing_case(67, '1X+100Y'(3,'10X'(4)), generation_timeout, [], [], parse_skipped_empty_tokens, none).
gen_to_parse_parsing_case(68, '1X+100Y'(4,'0X+30'(3)), generation_timeout, [], [], parse_skipped_empty_tokens, none).
gen_to_parse_parsing_case(69, '1X+100Y'(4,'1X+1Y'(7,4)), generation_timeout, [], [], parse_skipped_empty_tokens, none).
gen_to_parse_parsing_case(70, '1X+60'(2), ok, [zwei,undsechzig], [zwei,undsechzig], ok, plus60(2)).
gen_to_parse_parsing_case(71, '1X+60'(4), ok, [undsechzig,vier], [undsechzig,vier], parse_fail, none).
gen_to_parse_parsing_case(72, '1X+70'(2), ok, [zwei,undsiebzig], [zwei,undsiebzig], ok, plus70(2)).
gen_to_parse_parsing_case(73, '1X+70'(4), ok, [undsiebzig,vier], [undsiebzig,vier], parse_fail, none).
gen_to_parse_parsing_case(74, plus60(2), gen_empty_yield, [], [], parse_skipped_empty_tokens, none).
gen_to_parse_parsing_case(75, plus60(4), gen_empty_yield, [], [], parse_skipped_empty_tokens, none).
gen_to_parse_parsing_case(76, plus70(2), gen_empty_yield, [], [], parse_skipped_empty_tokens, none).
gen_to_parse_parsing_case(77, plus70(4), gen_empty_yield, [], [], parse_skipped_empty_tokens, none).
gen_to_parse_parsing_case(78, 'UNKNOWN_GERMAN_SEM'(4), gen_empty_yield, [], [], parse_skipped_empty_tokens, none).
gen_to_parse_parsing_case(79, 'BAD_GERMAN_FORM', gen_empty_yield, [], [], parse_skipped_empty_tokens, none).
gen_to_parse_parsing_case(80, '1X+999'(3), gen_empty_yield, [], [], parse_skipped_empty_tokens, none).
gen_to_parse_parsing_case(81, '1000X'(2), gen_empty_yield, [], [], parse_skipped_empty_tokens, none).
