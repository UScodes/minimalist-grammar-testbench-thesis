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

parse_to_gen_generation_case(1, [teen], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(2, [banana], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(3, [twenty_,ten], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(4, [seven,twenty_], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(5, [sixty_,four], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(6, [forty_,four], ok, '1X+40'(4), gen_empty_yield, [], [], '').
