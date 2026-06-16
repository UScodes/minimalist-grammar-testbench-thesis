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
gen_to_parse_parsing_case(5, 6, ok, [sechs], [sechs], ok, 6).
gen_to_parse_parsing_case(6, 7, ok, [sieben], [sieben], ok, 7).
gen_to_parse_parsing_case(7, 8, ok, [acht], [acht], ok, 8).
gen_to_parse_parsing_case(8, 9, ok, [neun], [neun], ok, 9).
gen_to_parse_parsing_case(9, 10, ok, [zehn], [zehn], ok, 10).
gen_to_parse_parsing_case(10, 11, ok, [elf], [elf], ok, 11).
gen_to_parse_parsing_case(11, 20, ok, [zwanzig], [zwanzig], ok, 20).
gen_to_parse_parsing_case(12, 60, ok, [sechzig], [sechzig], ok, 60).
gen_to_parse_parsing_case(13, 70, ok, [siebzig], [siebzig], ok, 70).
gen_to_parse_parsing_case(14, '1X+20'(2), ok, [zwei,undzwanzig], [zwei,undzwanzig], ok, '1X+20'(2)).
gen_to_parse_parsing_case(15, '1X+20'(6), ok, [sechs,undzwanzig], [sechs,undzwanzig], ok, '1X+20'(6)).
gen_to_parse_parsing_case(16, '1X+20'(7), ok, [sieben,undzwanzig], [sieben,undzwanzig], ok, '1X+20'(7)).
gen_to_parse_parsing_case(17, 100, ok, [hundert], [hundert], ok, 100).
gen_to_parse_parsing_case(18, '100X'(2), ok, [zwei,hundert], [zwei,hundert], ok, '100X'(2)).
gen_to_parse_parsing_case(19, '1X+100'(20), ok, [hundert,zwanzig], [hundert,zwanzig], ok, '1X+100'(20)).
gen_to_parse_parsing_case(20, '1X+100'(60), ok, [hundert,sechzig], [hundert,sechzig], ok, '1X+100'(60)).
gen_to_parse_parsing_case(21, '1X+100'(70), ok, [hundert,siebzig], [hundert,siebzig], ok, '1X+100'(70)).
