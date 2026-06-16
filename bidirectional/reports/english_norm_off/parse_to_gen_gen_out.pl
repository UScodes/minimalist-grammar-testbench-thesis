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

parse_to_gen_generation_case(1, [twenty_,one], ok, '1X+20'(1), ok, [twenty,one], [twenty,one], twentyone).
parse_to_gen_generation_case(2, [twenty_,four], ok, '1X+20'(4), ok, [twenty,four], [twenty,four], twentyfour).
parse_to_gen_generation_case(3, [twenty_,seven], ok, '1X+20'(7), ok, [twenty,seven], [twenty,seven], twentyseven).
parse_to_gen_generation_case(4, [thirty_,four], ok, '1X+30'(4), ok, [thirty,four], [thirty,four], thirtyfour).
parse_to_gen_generation_case(5, [fifty_,six], ok, '1X+50'(6), ok, [fifty,six], [fifty,six], fiftysix).
