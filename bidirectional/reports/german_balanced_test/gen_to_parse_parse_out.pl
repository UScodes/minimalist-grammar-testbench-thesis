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
gen_to_parse_parsing_case(13, 13, gen_empty_yield, [], [], parse_skipped_empty_tokens, none).
gen_to_parse_parsing_case(14, 15, gen_empty_yield, [], [], parse_skipped_empty_tokens, none).
gen_to_parse_parsing_case(15, 20, ok, [zwanzig], [zwanzig], ok, 20).
gen_to_parse_parsing_case(16, 30, gen_empty_yield, [], [], parse_skipped_empty_tokens, none).
gen_to_parse_parsing_case(17, 60, ok, [sechzig], [sechzig], ok, 60).
gen_to_parse_parsing_case(18, 70, ok, [siebzig], [siebzig], ok, 70).
gen_to_parse_parsing_case(19, '1X+20'(1), ok, [undzwanzig,eins], [undzwanzig,eins], parse_fail, none).
gen_to_parse_parsing_case(20, '1X+20'(2), ok, [zwei,undzwanzig], [zwei,undzwanzig], ok, '1X+20'(2)).
gen_to_parse_parsing_case(21, '1X+20'(3), ok, [undzwanzig,drei], [undzwanzig,drei], parse_fail, none).
gen_to_parse_parsing_case(22, '1X+20'(4), ok, [undzwanzig,vier], [undzwanzig,vier], parse_fail, none).
gen_to_parse_parsing_case(23, '1X+20'(5), ok, [undzwanzig,fünf], [undzwanzig,fünf], parse_fail, none).
gen_to_parse_parsing_case(24, '1X+20'(6), ok, [sechs,undzwanzig], [sechs,undzwanzig], ok, '1X+20'(6)).
gen_to_parse_parsing_case(25, '1X+20'(7), ok, [sieben,undzwanzig], [sieben,undzwanzig], ok, '1X+20'(7)).
gen_to_parse_parsing_case(26, '1X+20'(8), ok, [undzwanzig,acht], [undzwanzig,acht], parse_fail, none).
gen_to_parse_parsing_case(27, '1X+20'(9), ok, [undzwanzig,neun], [undzwanzig,neun], parse_fail, none).
gen_to_parse_parsing_case(28, '1X+60'(1), ok, [undsechzig,eins], [undsechzig,eins], parse_fail, none).
gen_to_parse_parsing_case(29, '1X+60'(2), ok, [zwei,undsechzig], [zwei,undsechzig], ok, plus60(2)).
gen_to_parse_parsing_case(30, '1X+60'(4), ok, [undsechzig,vier], [undsechzig,vier], parse_fail, none).
gen_to_parse_parsing_case(31, '1X+60'(6), ok, [sechs,undsechzig], [sechs,undsechzig], ok, plus60(6)).
gen_to_parse_parsing_case(32, '1X+60'(7), ok, [sieben,undsechzig], [sieben,undsechzig], ok, plus60(7)).
gen_to_parse_parsing_case(33, '1X+60'(8), ok, [undsechzig,acht], [undsechzig,acht], parse_fail, none).
gen_to_parse_parsing_case(34, '1X+70'(1), ok, [undsiebzig,eins], [undsiebzig,eins], parse_fail, none).
gen_to_parse_parsing_case(35, '1X+70'(2), ok, [zwei,undsiebzig], [zwei,undsiebzig], ok, plus70(2)).
gen_to_parse_parsing_case(36, '1X+70'(4), ok, [undsiebzig,vier], [undsiebzig,vier], parse_fail, none).
gen_to_parse_parsing_case(37, '1X+70'(6), ok, [sechs,undsiebzig], [sechs,undsiebzig], ok, plus70(6)).
gen_to_parse_parsing_case(38, '1X+70'(7), ok, [sieben,undsiebzig], [sieben,undsiebzig], ok, plus70(7)).
gen_to_parse_parsing_case(39, '1X+70'(8), ok, [undsiebzig,acht], [undsiebzig,acht], parse_fail, none).
gen_to_parse_parsing_case(40, 100, ok, [hundert], [hundert], ok, 100).
gen_to_parse_parsing_case(41, '100X'(2), ok, [zwei,hundert], [zwei,hundert], ok, '100X'(2)).
gen_to_parse_parsing_case(42, '100X'(3), ok, [hundert,drei], [hundert,drei], ok, '1X+100'(3)).
gen_to_parse_parsing_case(43, '100X'(5), ok, [hundert,fünf], [hundert,fünf], ok, '1X+100'(5)).
gen_to_parse_parsing_case(44, '1X+100'(20), ok, [hundert,zwanzig], [hundert,zwanzig], ok, '1X+100'(20)).
gen_to_parse_parsing_case(45, '1X+100'(30), generation_timeout, [], [], parse_skipped_empty_tokens, none).
gen_to_parse_parsing_case(46, '1X+100'(60), ok, [hundert,sechzig], [hundert,sechzig], ok, '1X+100'(60)).
gen_to_parse_parsing_case(47, '1X+100'(70), ok, [hundert,siebzig], [hundert,siebzig], ok, '1X+100'(70)).
gen_to_parse_parsing_case(48, '1X+40'(4), gen_empty_yield, [], [], parse_skipped_empty_tokens, none).
gen_to_parse_parsing_case(49, '1X+50'(6), gen_empty_yield, [], [], parse_skipped_empty_tokens, none).
gen_to_parse_parsing_case(50, '1X+80'(8), gen_empty_yield, [], [], parse_skipped_empty_tokens, none).
gen_to_parse_parsing_case(51, 'UNKNOWN_SEM'(4), gen_empty_yield, [], [], parse_skipped_empty_tokens, none).
