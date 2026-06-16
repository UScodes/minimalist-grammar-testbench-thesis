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
parse_to_gen_parsing_case(11, [sechzehn], ok, 16).
parse_to_gen_parsing_case(12, [siebzehn], ok, 17).
parse_to_gen_parsing_case(13, [zwanzig], ok, 20).
parse_to_gen_parsing_case(14, [einundzwanzig], ok, 21).
parse_to_gen_parsing_case(15, [sechzig], ok, 60).
parse_to_gen_parsing_case(16, [einundsechzig], ok, 61).
parse_to_gen_parsing_case(17, [siebzig], ok, 70).
parse_to_gen_parsing_case(18, [einundsiebzig], ok, 71).
parse_to_gen_parsing_case(19, [hundert], ok, 100).
parse_to_gen_parsing_case(20, [zwei,undzwanzig], ok, '1X+20'(2)).
parse_to_gen_parsing_case(21, [sechs,undzwanzig], ok, '1X+20'(6)).
parse_to_gen_parsing_case(22, [sieben,undzwanzig], ok, '1X+20'(7)).
parse_to_gen_parsing_case(23, [zwei,hundert], ok, '100X'(2)).
parse_to_gen_parsing_case(24, [sechs,hundert], ok, '100X'(6)).
parse_to_gen_parsing_case(25, [sieben,hundert], ok, '100X'(7)).
