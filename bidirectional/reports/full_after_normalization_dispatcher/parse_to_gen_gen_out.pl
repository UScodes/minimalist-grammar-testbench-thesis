% =============================================================================
% Parsing-to-Generation: Generation-stage Output
% =============================================================================
% Each fact has the form:
%
%   parse_to_gen_generation_case(CaseId, TokenInput, ParsingStatus, RecoveredSemanticOutput, GenerationStatus, GeneratedTokens, ComparisonTokens, GeneratedSentence).
%
% Meaning:
%   CaseId                   - numeric identifier shared across all artifacts for the same test case
%   TokenInput               - original token sequence used in the parsing stage
%   ParsingStatus            - result of the parsing stage
%   RecoveredSemanticOutput  - semantic representation recovered by the parser, or none if parsing failed
%   GenerationStatus         - result of the generation stage, e.g. ok, gen_empty_yield, generation_timeout
%   GeneratedTokens          - raw token sequence produced by the generator stage
%   ComparisonTokens         - generated tokens after normalization; used for comparison with the original token input
%   GeneratedSentence        - sentence atom derived from GeneratedTokens for report consistency
% =============================================================================

parse_to_gen_generation_case(1, [four,ty], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(2, [six,ty], ok, '10X'(6), ok, [six,ty], [six,ty], sixty).
parse_to_gen_generation_case(3, [seven,ty], ok, '10X'(7), ok, [seven,ty], [seven,ty], seventy).
parse_to_gen_generation_case(4, [nine,ty], ok, '10X'(9), ok, [nine,ty], [nine,ty], ninety).
parse_to_gen_generation_case(5, [eight,y], ok, '0X+80'(8), ok, [eight,y], [eight,y], eighty).
parse_to_gen_generation_case(6, [six,ty_,four], ok, '1X+10Y'(4,6), generation_timeout, [], [], '').
parse_to_gen_generation_case(7, [seven,ty_,four], ok, '1X+10Y'(4,7), generation_timeout, [], [], '').
parse_to_gen_generation_case(8, [eight,y_,four], ok, '1X+10Y'(4,8), generation_timeout, [], [], '').
parse_to_gen_generation_case(9, [nine,ty_,four], ok, '1X+10Y'(4,9), generation_timeout, [], [], '').
