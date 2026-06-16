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
parse_to_gen_parsing_case(5, [sechs], ok, 6).
parse_to_gen_parsing_case(6, [sieben], ok, 7).
parse_to_gen_parsing_case(7, [acht], ok, 8).
parse_to_gen_parsing_case(8, [neun], ok, 9).
parse_to_gen_parsing_case(9, [zehn], ok, 10).
parse_to_gen_parsing_case(10, [elf], ok, 11).
parse_to_gen_parsing_case(11, [zwanzig], ok, 20).
parse_to_gen_parsing_case(12, [sechzig], ok, 60).
parse_to_gen_parsing_case(13, [siebzig], ok, 70).
parse_to_gen_parsing_case(14, [zwei,und,zwanzig], parse_fail, none).
parse_to_gen_parsing_case(15, [sechs,und,zwanzig], parse_fail, none).
parse_to_gen_parsing_case(16, [sieben,und,zwanzig], parse_fail, none).
parse_to_gen_parsing_case(17, [hundert], ok, 100).
parse_to_gen_parsing_case(18, [zwei,hundert], ok, '100X'(2)).
parse_to_gen_parsing_case(19, [hundert,zwanzig], ok, '1X+100'(20)).
parse_to_gen_parsing_case(20, [hundert,sechzig], ok, '1X+100'(60)).
parse_to_gen_parsing_case(21, [hundert,siebzig], ok, '1X+100'(70)).
