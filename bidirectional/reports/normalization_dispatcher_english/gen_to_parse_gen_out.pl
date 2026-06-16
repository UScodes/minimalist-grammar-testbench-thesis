% =============================================================================
% Generation-to-Parsing: Generation-stage Output
% =============================================================================
% Each fact has the form:
%
%   gen_to_parse_generation_case(CaseId, SemanticInput, GenerationStatus, GeneratedTokens, GeneratedSentence).
%
% Meaning:
%   CaseId             - numeric identifier shared across all artifacts for the same test case
%   SemanticInput      - original semantic input sent to the generator
%   GenerationStatus   - result of the generation stage, e.g. ok, gen_empty_yield, generation_timeout
%   GeneratedTokens    - token sequence extracted from the generated structure
%   GeneratedSentence  - sentence atom derived from GeneratedTokens for report consistency
% =============================================================================

gen_to_parse_generation_case(1, 1, ok, [one], one).
gen_to_parse_generation_case(2, 2, ok, [two], two).
gen_to_parse_generation_case(3, 3, ok, [three], three).
gen_to_parse_generation_case(4, 4, ok, [four], four).
gen_to_parse_generation_case(5, 5, ok, [five], five).
gen_to_parse_generation_case(6, 6, ok, [six], six).
gen_to_parse_generation_case(7, 7, ok, [seven], seven).
gen_to_parse_generation_case(8, 8, ok, [eight], eight).
gen_to_parse_generation_case(9, 9, ok, [nine], nine).
gen_to_parse_generation_case(10, 10, ok, [ten], ten).
gen_to_parse_generation_case(11, 11, ok, [eleven], eleven).
gen_to_parse_generation_case(12, 12, ok, [twelve], twelve).
gen_to_parse_generation_case(13, 13, ok, [thirteen], thirteen).
gen_to_parse_generation_case(14, 15, ok, [fifteen], fifteen).
gen_to_parse_generation_case(15, 20, ok, [twenty], twenty).
gen_to_parse_generation_case(16, 30, ok, [thirty], thirty).
gen_to_parse_generation_case(17, 50, ok, [fifty], fifty).
gen_to_parse_generation_case(18, '1X+10'(4), ok, [four,teen], fourteen).
gen_to_parse_generation_case(19, '1X+10'(6), ok, [six,teen], sixteen).
gen_to_parse_generation_case(20, '1X+10'(7), ok, [seven,teen], seventeen).
gen_to_parse_generation_case(21, '1X+10'(9), ok, [nine,teen], nineteen).
gen_to_parse_generation_case(22, '0X+18'(8), ok, [eight,een], eighteen).
gen_to_parse_generation_case(23, '1X+20'(1), ok, [twenty,one], twentyone).
gen_to_parse_generation_case(24, '1X+20'(2), ok, [twenty,two], twentytwo).
gen_to_parse_generation_case(25, '1X+20'(3), ok, [twenty,three], twentythree).
gen_to_parse_generation_case(26, '1X+20'(4), ok, [twenty,four], twentyfour).
gen_to_parse_generation_case(27, '1X+20'(5), ok, [twenty,five], twentyfive).
gen_to_parse_generation_case(28, '1X+20'(6), ok, [twenty,six], twentysix).
gen_to_parse_generation_case(29, '1X+20'(7), ok, [twenty,seven], twentyseven).
gen_to_parse_generation_case(30, '1X+20'(8), ok, [twenty,eight], twentyeight).
gen_to_parse_generation_case(31, '1X+20'(9), ok, [twenty,nine], twentynine).
gen_to_parse_generation_case(32, '1X+30'(1), ok, [thirty,one], thirtyone).
gen_to_parse_generation_case(33, '1X+30'(2), ok, [thirty,two], thirtytwo).
gen_to_parse_generation_case(34, '1X+30'(3), ok, [thirty,three], thirtythree).
gen_to_parse_generation_case(35, '1X+30'(4), ok, [thirty,four], thirtyfour).
gen_to_parse_generation_case(36, '1X+30'(5), ok, [thirty,five], thirtyfive).
gen_to_parse_generation_case(37, '1X+30'(6), ok, [thirty,six], thirtysix).
gen_to_parse_generation_case(38, '1X+30'(7), ok, [thirty,seven], thirtyseven).
gen_to_parse_generation_case(39, '1X+30'(8), ok, [thirty,eight], thirtyeight).
gen_to_parse_generation_case(40, '1X+30'(9), ok, [thirty,nine], thirtynine).
gen_to_parse_generation_case(41, '1X+50'(1), ok, [fifty,one], fiftyone).
gen_to_parse_generation_case(42, '1X+50'(2), ok, [fifty,two], fiftytwo).
gen_to_parse_generation_case(43, '1X+50'(3), ok, [fifty,three], fiftythree).
gen_to_parse_generation_case(44, '1X+50'(4), ok, [fifty,four], fiftyfour).
gen_to_parse_generation_case(45, '1X+50'(5), ok, [fifty,five], fiftyfive).
gen_to_parse_generation_case(46, '1X+50'(6), ok, [fifty,six], fiftysix).
gen_to_parse_generation_case(47, '1X+50'(7), ok, [fifty,seven], fiftyseven).
gen_to_parse_generation_case(48, '1X+50'(8), ok, [fifty,eight], fiftyeight).
gen_to_parse_generation_case(49, '1X+50'(9), ok, [fifty,nine], fiftynine).
gen_to_parse_generation_case(50, '10X'(4), ok, [four,ty], fourty).
gen_to_parse_generation_case(51, '10X'(6), ok, [six,ty], sixty).
gen_to_parse_generation_case(52, '10X'(7), ok, [seven,ty], seventy).
gen_to_parse_generation_case(53, '0X+80'(8), ok, [eight,y], eighty).
gen_to_parse_generation_case(54, '1X+40'(4), gen_empty_yield, [], '').
gen_to_parse_generation_case(55, '1X+60'(4), gen_empty_yield, [], '').
gen_to_parse_generation_case(56, '1X+70'(4), gen_empty_yield, [], '').
gen_to_parse_generation_case(57, '1X+80'(4), gen_empty_yield, [], '').
gen_to_parse_generation_case(58, '1X+90'(4), gen_empty_yield, [], '').
gen_to_parse_generation_case(59, '1X+100Y'(1,20), ok, [one,hundred_and,twenty], onehundred_andtwenty).
gen_to_parse_generation_case(60, '1X+100Y'(2,30), ok, [two,hundred_and,thirty], twohundred_andthirty).
gen_to_parse_generation_case(61, '1X+100Y'(3,'1X+20'(4)), ok, [three,hundred_and,twenty,four], threehundred_andtwentyfour).
gen_to_parse_generation_case(62, '1X+100Y'(5,'1X+30'(6)), ok, [five,hundred_and,thirty,six], fivehundred_andthirtysix).
gen_to_parse_generation_case(63, '1X+20'(4), ok, [twenty,four], twentyfour).
gen_to_parse_generation_case(64, '1X+20'(15), generation_timeout, [], '').
gen_to_parse_generation_case(65, 'UNKNOWN_SEM'(4), gen_empty_yield, [], '').
