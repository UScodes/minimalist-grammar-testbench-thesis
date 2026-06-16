% =============================================================================
% Parsing-to-Generation: Parsing-stage Output
% =============================================================================
% Each fact has the form:
%
%   parse_to_gen_parsing_case(CaseId, TokenInput, ParsingStatus, RecoveredSemanticOutput).
%
% Meaning:
%   CaseId                   - numeric identifier shared across all artifacts for the same test case
%   TokenInput               - original token sequence sent to the parser
%   ParsingStatus            - result of the parsing stage, e.g. ok, parse_fail, parse_timeout
%   RecoveredSemanticOutput  - semantic representation recovered by the parser, or none if parsing failed
% =============================================================================

parse_to_gen_parsing_case(1, [eins], ok, 1).
parse_to_gen_parsing_case(2, [zwei], ok, 2).
parse_to_gen_parsing_case(3, [drei], ok, 3).
parse_to_gen_parsing_case(4, [vier], ok, 4).
parse_to_gen_parsing_case(5, [fünf], ok, 5).
parse_to_gen_parsing_case(6, [sechs], ok, 6).
parse_to_gen_parsing_case(7, [sieben], ok, 7).
parse_to_gen_parsing_case(8, [acht], ok, 8).
parse_to_gen_parsing_case(9, [neun], ok, 9).
parse_to_gen_parsing_case(10, [zehn], ok, 10).
parse_to_gen_parsing_case(11, [elf], ok, 11).
parse_to_gen_parsing_case(12, [zwölf], ok, 12).
parse_to_gen_parsing_case(13, [sechzehn], ok, 16).
parse_to_gen_parsing_case(14, [siebzehn], ok, 17).
parse_to_gen_parsing_case(15, [zwanzig], ok, 20).
parse_to_gen_parsing_case(16, [einundzwanzig], ok, 21).
parse_to_gen_parsing_case(17, [sechzig], ok, 60).
parse_to_gen_parsing_case(18, [einundsechzig], ok, 61).
parse_to_gen_parsing_case(19, [siebzig], ok, 70).
parse_to_gen_parsing_case(20, [einundsiebzig], ok, 71).
parse_to_gen_parsing_case(21, [hundert], ok, 100).
parse_to_gen_parsing_case(22, [zwei,undzwanzig], ok, '1X+20'(2)).
parse_to_gen_parsing_case(23, [drei,ßig], ok, '0X+30'(3)).
parse_to_gen_parsing_case(24, [zwei,und,drei,ßig], ok, '1X+1Y+3'('9X'(3),2)).
parse_to_gen_parsing_case(25, [sieben,und,vier,zig], ok, '1X+1Y'('10X+N'(4),7)).
parse_to_gen_parsing_case(26, [drei,hundert], ok, '100X'(3)).
parse_to_gen_parsing_case(27, [drei,hundert,vier], ok, '1X+100Y'(4,3)).
parse_to_gen_parsing_case(28, [drei,hundert,vier,zig], ok, '1X+100Y'('10X'(4),3)).
parse_to_gen_parsing_case(29, [drei,undzwanzig], ok, '1X+20'(3)).
parse_to_gen_parsing_case(30, [vier,undzwanzig], ok, '1X+20'(4)).
parse_to_gen_parsing_case(31, [fünf,undzwanzig], ok, '1X+20'(5)).
parse_to_gen_parsing_case(32, [sechs,undzwanzig], ok, '1X+20'(6)).
parse_to_gen_parsing_case(33, [sieben,undzwanzig], ok, '1X+20'(7)).
parse_to_gen_parsing_case(34, [acht,undzwanzig], ok, '1X+20'(8)).
parse_to_gen_parsing_case(35, [neun,undzwanzig], ok, '1X+20'(9)).
parse_to_gen_parsing_case(36, [vier,ßig], parse_fail, none).
parse_to_gen_parsing_case(37, [fünf,ßig], parse_fail, none).
parse_to_gen_parsing_case(38, [acht,ßig], parse_fail, none).
parse_to_gen_parsing_case(39, [neun,ßig], parse_fail, none).
parse_to_gen_parsing_case(40, [vier,zig], ok, '10X'(4)).
parse_to_gen_parsing_case(41, [sechs,zig], parse_fail, none).
parse_to_gen_parsing_case(42, [sieben,zig], parse_fail, none).
parse_to_gen_parsing_case(43, [acht,zig], parse_fail, none).
parse_to_gen_parsing_case(44, [neun,zig], parse_fail, none).
parse_to_gen_parsing_case(45, [zwei,und,vier,zig], ok, '1X+1Y'('10X+N'(4),2)).
parse_to_gen_parsing_case(46, [drei,und,vier,zig], ok, '1X+1Y'('10X+N'(4),3)).
parse_to_gen_parsing_case(47, [fünf,und,vier,zig], ok, '1X+1Y'('10X+N'(4),5)).
parse_to_gen_parsing_case(48, [neun,und,vier,zig], ok, '1X+1Y'('10X+N'(4),9)).
parse_to_gen_parsing_case(49, [zwei,hundert], ok, '100X'(2)).
parse_to_gen_parsing_case(50, [vier,hundert], ok, '100X'(4)).
parse_to_gen_parsing_case(51, [fünf,hundert], ok, '100X'(5)).
parse_to_gen_parsing_case(52, [sechs,hundert], ok, '100X'(6)).
parse_to_gen_parsing_case(53, [sieben,hundert], ok, '100X'(7)).
parse_to_gen_parsing_case(54, [acht,hundert], ok, '100X'(8)).
parse_to_gen_parsing_case(55, [neun,hundert], ok, '100X'(9)).
parse_to_gen_parsing_case(56, [drei,hundert,zehn], ok, '1X+100Y'(10,3)).
parse_to_gen_parsing_case(57, [drei,hundert,zwanzig], ok, '1X+100Y'(20,3)).
parse_to_gen_parsing_case(58, [drei,hundert,sechzig], ok, '1X+100Y'(60,3)).
parse_to_gen_parsing_case(59, [drei,hundert,siebzig], ok, '1X+100Y'(70,3)).
parse_to_gen_parsing_case(60, [vier,hundert,drei], ok, '1X+100Y'(3,4)).
parse_to_gen_parsing_case(61, [vier,hundert,zwanzig], ok, '1X+100Y'(20,4)).
parse_to_gen_parsing_case(62, [vier,hundert,drei,ßig], parse_fail, none).
parse_to_gen_parsing_case(63, [vier,hundert,sieben,und,vier,zig], parse_fail, none).
parse_to_gen_parsing_case(64, [sieben,und,acht,zig], parse_fail, none).
parse_to_gen_parsing_case(65, [drei,hundert,sieben,und,vier,zig], parse_fail, none).
parse_to_gen_parsing_case(66, [acht], ok, 8).
parse_to_gen_parsing_case(67, [undzwanzig,zwei], parse_fail, none).
parse_to_gen_parsing_case(68, [zig,vier], parse_fail, none).
parse_to_gen_parsing_case(69, [hundert,drei], ok, '1X+100'(3)).
parse_to_gen_parsing_case(70, [und], parse_fail, none).
parse_to_gen_parsing_case(71, [zig], parse_fail, none).
parse_to_gen_parsing_case(72, [ßig], parse_fail, none).
parse_to_gen_parsing_case(73, [einund], parse_fail, none).
parse_to_gen_parsing_case(74, [zwei,und], parse_fail, none).
parse_to_gen_parsing_case(75, [drei,hundert,und], parse_fail, none).
parse_to_gen_parsing_case(76, [eins,undzwanzig], parse_fail, none).
parse_to_gen_parsing_case(77, [eins,und,drei,ßig], parse_fail, none).
parse_to_gen_parsing_case(78, [hundert,hundert], parse_fail, none).
parse_to_gen_parsing_case(79, [drei,hundert,hundert], parse_fail, none).
