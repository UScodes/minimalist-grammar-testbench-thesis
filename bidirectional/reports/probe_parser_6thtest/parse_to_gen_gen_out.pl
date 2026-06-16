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

parse_to_gen_generation_case(1, [one,hundred], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(2, [two,hundred], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(3, [three,hundred], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(4, [one,hundred_and,twenty], ok, '1X+100Y'(20,1), ok, [one,hundred_and,twenty], [one,hundred_and,twenty_], onehundred_andtwenty).
parse_to_gen_generation_case(5, [two,hundred_and,thirty], ok, '1X+100Y'(30,2), ok, [two,hundred_and,thirty], [two,hundred_and,thirty_], twohundred_andthirty).
parse_to_gen_generation_case(6, [three,hundred_and,twenty_,four], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(7, [five,hundred_and,thirty_,six], parse_fail, none, generation_not_attempted, [], [], '').
