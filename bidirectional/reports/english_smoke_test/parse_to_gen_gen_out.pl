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

parse_to_gen_generation_case(1, [one], ok, 1, ok, [one], [one], one).
parse_to_gen_generation_case(2, [two], ok, 2, ok, [two], [two], two).
parse_to_gen_generation_case(3, [three], ok, 3, ok, [three], [three], three).
parse_to_gen_generation_case(4, [ten], ok, 10, ok, [ten], [ten], ten).
parse_to_gen_generation_case(5, [eleven], ok, 11, ok, [eleven], [eleven], eleven).
parse_to_gen_generation_case(6, [twenty], ok, 20, ok, [twenty], [twenty], twenty).
parse_to_gen_generation_case(7, [thirty], ok, 30, ok, [thirty], [thirty], thirty).
parse_to_gen_generation_case(8, [fifty], ok, 50, ok, [fifty], [fifty], fifty).
parse_to_gen_generation_case(9, [twenty_,one], ok, '1X+20'(1), ok, [twenty,one], [twenty_,one], twentyone).
parse_to_gen_generation_case(10, [twenty_,seven], ok, '1X+20'(7), ok, [twenty,seven], [twenty_,seven], twentyseven).
parse_to_gen_generation_case(11, [thirty_,four], ok, '1X+30'(4), ok, [thirty,four], [thirty_,four], thirtyfour).
parse_to_gen_generation_case(12, [fifty_,six], ok, '1X+50'(6), ok, [fifty,six], [fifty_,six], fiftysix).
parse_to_gen_generation_case(13, [one,hundred_and,twenty], ok, '1X+100Y'(20,1), ok, [one,hundred_and,twenty], [one,hundred_and,twenty], onehundred_andtwenty).
