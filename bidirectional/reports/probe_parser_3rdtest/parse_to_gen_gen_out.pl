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
parse_to_gen_generation_case(4, [four], ok, 4, ok, [four], [four], four).
parse_to_gen_generation_case(5, [five], ok, 5, ok, [five], [five], five).
parse_to_gen_generation_case(6, [six], ok, 6, ok, [six], [six], six).
parse_to_gen_generation_case(7, [seven], ok, 7, ok, [seven], [seven], seven).
parse_to_gen_generation_case(8, [eight], ok, 8, ok, [eight], [eight], eight).
parse_to_gen_generation_case(9, [nine], ok, 9, ok, [nine], [nine], nine).
parse_to_gen_generation_case(10, [ten], ok, 10, ok, [ten], [ten], ten).
parse_to_gen_generation_case(11, [eleven], ok, 11, ok, [eleven], [eleven], eleven).
parse_to_gen_generation_case(12, [twelve], ok, 12, ok, [twelve], [twelve], twelve).
parse_to_gen_generation_case(13, [thirteen], ok, 13, ok, [thirteen], [thirteen], thirteen).
parse_to_gen_generation_case(14, [fifteen], ok, 15, ok, [fifteen], [fifteen], fifteen).
parse_to_gen_generation_case(15, [twenty], ok, 20, ok, [twenty], [twenty_], twenty).
parse_to_gen_generation_case(16, [thirty], ok, 30, ok, [thirty], [thirty_], thirty).
parse_to_gen_generation_case(17, [fifty], ok, 50, ok, [fifty], [fifty_], fifty).
parse_to_gen_generation_case(18, [four,teen], ok, '1X+10'(4), ok, [four,teen], [four,teen], fourteen).
parse_to_gen_generation_case(19, [six,teen], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(20, [seven,teen], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(21, [nine,teen], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(22, [eight,een], ok, '0X+18'(8), ok, [eight,een], [eight,een], eighteen).
parse_to_gen_generation_case(23, [thirty_,one], ok, '1X+30'(1), ok, [thirty,one], [thirty_,one], thirtyone).
parse_to_gen_generation_case(24, [thirty_,two], ok, '1X+30'(2), ok, [thirty,two], [thirty_,two], thirtytwo).
parse_to_gen_generation_case(25, [thirty_,three], ok, '1X+30'(3), ok, [thirty,three], [thirty_,three], thirtythree).
parse_to_gen_generation_case(26, [thirty_,four], ok, '1X+30'(4), ok, [thirty,four], [thirty_,four], thirtyfour).
parse_to_gen_generation_case(27, [thirty_,five], ok, '1X+30'(5), ok, [thirty,five], [thirty_,five], thirtyfive).
parse_to_gen_generation_case(28, [thirty_,six], ok, '1X+30'(6), ok, [thirty,six], [thirty_,six], thirtysix).
parse_to_gen_generation_case(29, [thirty_,seven], ok, '1X+30'(7), ok, [thirty,seven], [thirty_,seven], thirtyseven).
parse_to_gen_generation_case(30, [thirty_,eight], ok, '1X+30'(8), ok, [thirty,eight], [thirty_,eight], thirtyeight).
parse_to_gen_generation_case(31, [thirty_,nine], ok, '1X+30'(9), ok, [thirty,nine], [thirty_,nine], thirtynine).
parse_to_gen_generation_case(32, [fifty_,one], ok, '1X+50'(1), ok, [fifty,one], [fifty_,one], fiftyone).
parse_to_gen_generation_case(33, [fifty_,two], ok, '1X+50'(2), ok, [fifty,two], [fifty_,two], fiftytwo).
parse_to_gen_generation_case(34, [fifty_,three], ok, '1X+50'(3), ok, [fifty,three], [fifty_,three], fiftythree).
parse_to_gen_generation_case(35, [fifty_,four], ok, '1X+50'(4), ok, [fifty,four], [fifty_,four], fiftyfour).
parse_to_gen_generation_case(36, [fifty_,five], ok, '1X+50'(5), ok, [fifty,five], [fifty_,five], fiftyfive).
parse_to_gen_generation_case(37, [fifty_,six], ok, '1X+50'(6), ok, [fifty,six], [fifty_,six], fiftysix).
parse_to_gen_generation_case(38, [fifty_,seven], ok, '1X+50'(7), ok, [fifty,seven], [fifty_,seven], fiftyseven).
parse_to_gen_generation_case(39, [fifty_,eight], ok, '1X+50'(8), ok, [fifty,eight], [fifty_,eight], fiftyeight).
parse_to_gen_generation_case(40, [fifty_,nine], ok, '1X+50'(9), ok, [fifty,nine], [fifty_,nine], fiftynine).
