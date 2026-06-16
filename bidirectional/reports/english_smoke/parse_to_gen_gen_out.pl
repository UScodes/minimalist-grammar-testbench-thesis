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
parse_to_gen_generation_case(15, [twenty], ok, 20, ok, [twenty], [twenty], twenty).
parse_to_gen_generation_case(16, [thirty], ok, 30, ok, [thirty], [thirty], thirty).
parse_to_gen_generation_case(17, [fifty], ok, 50, ok, [fifty], [fifty], fifty).
parse_to_gen_generation_case(18, [four,teen], ok, '1X+10'(4), ok, [four,teen], [four,teen], fourteen).
parse_to_gen_generation_case(19, [six,teen], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(20, [seven,teen], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(21, [nine,teen], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(22, [eight,een], ok, '0X+18'(8), ok, [eight,een], [eight,een], eighteen).
parse_to_gen_generation_case(23, [twenty_,one], ok, '1X+20'(1), ok, [twenty,one], [twenty_,one], twentyone).
parse_to_gen_generation_case(24, [twenty_,two], ok, '1X+20'(2), ok, [twenty,two], [twenty_,two], twentytwo).
parse_to_gen_generation_case(25, [twenty_,three], ok, '1X+20'(3), ok, [twenty,three], [twenty_,three], twentythree).
parse_to_gen_generation_case(26, [twenty_,four], ok, '1X+20'(4), ok, [twenty,four], [twenty_,four], twentyfour).
parse_to_gen_generation_case(27, [twenty_,five], ok, '1X+20'(5), ok, [twenty,five], [twenty_,five], twentyfive).
parse_to_gen_generation_case(28, [twenty_,six], ok, '1X+20'(6), ok, [twenty,six], [twenty_,six], twentysix).
parse_to_gen_generation_case(29, [twenty_,seven], ok, '1X+20'(7), ok, [twenty,seven], [twenty_,seven], twentyseven).
parse_to_gen_generation_case(30, [twenty_,eight], ok, '1X+20'(8), ok, [twenty,eight], [twenty_,eight], twentyeight).
parse_to_gen_generation_case(31, [twenty_,nine], ok, '1X+20'(9), ok, [twenty,nine], [twenty_,nine], twentynine).
parse_to_gen_generation_case(32, [thirty_,one], ok, '1X+30'(1), ok, [thirty,one], [thirty_,one], thirtyone).
parse_to_gen_generation_case(33, [thirty_,two], ok, '1X+30'(2), ok, [thirty,two], [thirty_,two], thirtytwo).
parse_to_gen_generation_case(34, [thirty_,three], ok, '1X+30'(3), ok, [thirty,three], [thirty_,three], thirtythree).
parse_to_gen_generation_case(35, [thirty_,four], ok, '1X+30'(4), ok, [thirty,four], [thirty_,four], thirtyfour).
parse_to_gen_generation_case(36, [thirty_,five], ok, '1X+30'(5), ok, [thirty,five], [thirty_,five], thirtyfive).
parse_to_gen_generation_case(37, [thirty_,six], ok, '1X+30'(6), ok, [thirty,six], [thirty_,six], thirtysix).
parse_to_gen_generation_case(38, [thirty_,seven], ok, '1X+30'(7), ok, [thirty,seven], [thirty_,seven], thirtyseven).
parse_to_gen_generation_case(39, [thirty_,eight], ok, '1X+30'(8), ok, [thirty,eight], [thirty_,eight], thirtyeight).
parse_to_gen_generation_case(40, [thirty_,nine], ok, '1X+30'(9), ok, [thirty,nine], [thirty_,nine], thirtynine).
parse_to_gen_generation_case(41, [fifty_,one], ok, '1X+50'(1), ok, [fifty,one], [fifty_,one], fiftyone).
parse_to_gen_generation_case(42, [fifty_,two], ok, '1X+50'(2), ok, [fifty,two], [fifty_,two], fiftytwo).
parse_to_gen_generation_case(43, [fifty_,four], ok, '1X+50'(4), ok, [fifty,four], [fifty_,four], fiftyfour).
parse_to_gen_generation_case(44, [fifty_,five], ok, '1X+50'(5), ok, [fifty,five], [fifty_,five], fiftyfive).
parse_to_gen_generation_case(45, [fifty_,six], ok, '1X+50'(6), ok, [fifty,six], [fifty_,six], fiftysix).
parse_to_gen_generation_case(46, [fifty_,seven], ok, '1X+50'(7), ok, [fifty,seven], [fifty_,seven], fiftyseven).
parse_to_gen_generation_case(47, [fifty_,eight], ok, '1X+50'(8), ok, [fifty,eight], [fifty_,eight], fiftyeight).
parse_to_gen_generation_case(48, [fifty_,nine], ok, '1X+50'(9), ok, [fifty,nine], [fifty_,nine], fiftynine).
parse_to_gen_generation_case(49, [four,ty], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(50, [six,ty], ok, '10X'(6), ok, [six,ty], [six,ty], sixty).
parse_to_gen_generation_case(51, [seven,ty], ok, '10X'(7), ok, [seven,ty], [seven,ty], seventy).
parse_to_gen_generation_case(52, [nine,ty], ok, '10X'(9), ok, [nine,ty], [nine,ty], ninety).
parse_to_gen_generation_case(53, [eight,y], ok, '0X+80'(8), ok, [eight,y], [eight,y], eighty).
parse_to_gen_generation_case(54, [six,ty_,four], ok, '1X+10Y'(4,6), generation_timeout, [], [], '').
parse_to_gen_generation_case(55, [seven,ty_,four], ok, '1X+10Y'(4,7), generation_timeout, [], [], '').
parse_to_gen_generation_case(56, [eight,y_,four], ok, '1X+10Y'(4,8), generation_timeout, [], [], '').
parse_to_gen_generation_case(57, [nine,ty_,four], ok, '1X+10Y'(4,9), generation_timeout, [], [], '').
parse_to_gen_generation_case(58, [one,hundred], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(59, [two,hundred], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(60, [three,hundred], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(61, [one,hundred_and,twenty], ok, '1X+100Y'(20,1), ok, [one,hundred_and,twenty], [one,hundred_and,twenty], onehundred_andtwenty).
parse_to_gen_generation_case(62, [two,hundred_and,thirty], ok, '1X+100Y'(30,2), ok, [two,hundred_and,thirty], [two,hundred_and,thirty], twohundred_andthirty).
parse_to_gen_generation_case(63, [three,hundred_and,twenty_,four], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(64, [five,hundred_and,thirty_,six], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(65, [teen], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(66, [banana], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(67, [twenty_,ten], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(68, [seven,twenty_], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(69, [sixty_,four], parse_fail, none, generation_not_attempted, [], [], '').
parse_to_gen_generation_case(70, [forty_,four], ok, '1X+40'(4), gen_empty_yield, [], [], '').
