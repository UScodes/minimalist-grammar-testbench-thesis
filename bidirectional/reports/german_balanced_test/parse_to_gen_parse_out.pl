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
parse_to_gen_parsing_case(5, [fuenf], parse_fail, none).
parse_to_gen_parsing_case(6, [sechs], ok, 6).
parse_to_gen_parsing_case(7, [sieben], ok, 7).
parse_to_gen_parsing_case(8, [acht], ok, 8).
parse_to_gen_parsing_case(9, [neun], ok, 9).
parse_to_gen_parsing_case(10, [zehn], ok, 10).
parse_to_gen_parsing_case(11, [elf], ok, 11).
parse_to_gen_parsing_case(12, [zwoelf], parse_fail, none).
parse_to_gen_parsing_case(13, [dreizehn], parse_fail, none).
parse_to_gen_parsing_case(14, [fuenfzehn], parse_fail, none).
parse_to_gen_parsing_case(15, [zwanzig], ok, 20).
parse_to_gen_parsing_case(16, [dreissig], parse_fail, none).
parse_to_gen_parsing_case(17, [sechzig], ok, 60).
parse_to_gen_parsing_case(18, [siebzig], ok, 70).
parse_to_gen_parsing_case(19, [eins,undzwanzig], parse_fail, none).
parse_to_gen_parsing_case(20, [zwei,undzwanzig], ok, '1X+20'(2)).
parse_to_gen_parsing_case(21, [drei,undzwanzig], ok, '1X+20'(3)).
parse_to_gen_parsing_case(22, [vier,undzwanzig], ok, '1X+20'(4)).
parse_to_gen_parsing_case(23, [fuenf,undzwanzig], parse_fail, none).
parse_to_gen_parsing_case(24, [sechs,undzwanzig], ok, '1X+20'(6)).
parse_to_gen_parsing_case(25, [sieben,undzwanzig], ok, '1X+20'(7)).
parse_to_gen_parsing_case(26, [acht,undzwanzig], ok, '1X+20'(8)).
parse_to_gen_parsing_case(27, [neun,undzwanzig], ok, '1X+20'(9)).
parse_to_gen_parsing_case(28, [eins,undsechzig], parse_fail, none).
parse_to_gen_parsing_case(29, [zwei,undsechzig], ok, plus60(2)).
parse_to_gen_parsing_case(30, [vier,undsechzig], ok, plus60(4)).
parse_to_gen_parsing_case(31, [sechs,undsechzig], ok, plus60(6)).
parse_to_gen_parsing_case(32, [sieben,undsechzig], ok, plus60(7)).
parse_to_gen_parsing_case(33, [acht,undsechzig], ok, plus60(8)).
parse_to_gen_parsing_case(34, [eins,undsiebzig], parse_fail, none).
parse_to_gen_parsing_case(35, [zwei,undsiebzig], ok, plus70(2)).
parse_to_gen_parsing_case(36, [vier,undsiebzig], ok, plus70(4)).
parse_to_gen_parsing_case(37, [sechs,undsiebzig], ok, plus70(6)).
parse_to_gen_parsing_case(38, [sieben,undsiebzig], ok, plus70(7)).
parse_to_gen_parsing_case(39, [acht,undsiebzig], ok, plus70(8)).
parse_to_gen_parsing_case(40, [hundert], ok, 100).
parse_to_gen_parsing_case(41, [zwei,hundert], ok, '100X'(2)).
parse_to_gen_parsing_case(42, [drei,hundert], ok, '100X'(3)).
parse_to_gen_parsing_case(43, [fuenf,hundert], parse_fail, none).
parse_to_gen_parsing_case(44, [hundert,zwanzig], ok, '1X+100'(20)).
parse_to_gen_parsing_case(45, [hundert,dreissig], parse_fail, none).
parse_to_gen_parsing_case(46, [hundert,sechzig], ok, '1X+100'(60)).
parse_to_gen_parsing_case(47, [hundert,siebzig], ok, '1X+100'(70)).
parse_to_gen_parsing_case(48, [banana], parse_fail, none).
parse_to_gen_parsing_case(49, [und,zwanzig], parse_fail, none).
parse_to_gen_parsing_case(50, [zwanzig,und,zwei], parse_fail, none).
parse_to_gen_parsing_case(51, [vier,und,vierzig], parse_fail, none).
parse_to_gen_parsing_case(52, [sechs,und,fuenfzig], parse_fail, none).
parse_to_gen_parsing_case(53, [acht,und,achtzig], parse_fail, none).
