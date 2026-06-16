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

gen_to_parse_parsing_case(1, '10X'(4), ok, [four,ty], [four,ty], parse_fail, none).
gen_to_parse_parsing_case(2, '10X'(6), ok, [six,ty], [six,ty], ok, '10X'(6)).
gen_to_parse_parsing_case(3, '10X'(7), ok, [seven,ty], [seven,ty], ok, '10X'(7)).
gen_to_parse_parsing_case(4, '0X+80'(8), ok, [eight,y], [eight,y], ok, '0X+80'(8)).
gen_to_parse_parsing_case(5, '1X+40'(4), gen_empty_yield, [], [], parse_skipped_empty_tokens, none).
gen_to_parse_parsing_case(6, '1X+60'(4), gen_empty_yield, [], [], parse_skipped_empty_tokens, none).
gen_to_parse_parsing_case(7, '1X+70'(4), gen_empty_yield, [], [], parse_skipped_empty_tokens, none).
gen_to_parse_parsing_case(8, '1X+80'(4), gen_empty_yield, [], [], parse_skipped_empty_tokens, none).
gen_to_parse_parsing_case(9, '1X+90'(4), gen_empty_yield, [], [], parse_skipped_empty_tokens, none).
