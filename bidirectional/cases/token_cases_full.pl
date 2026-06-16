% ============================================================
% Token test cases for Parsing-to-Generation
% Probe version: uncomment one group/case at a time.
% ============================================================

% ------------------------------------------------------------
% ACTIVE SMOKE TEST
% Keep only one simple case active first.
% ------------------------------------------------------------

token_case([one]).

% ============================================================
% GROUP A: Units
% Expected: basic parsing and regeneration
% ============================================================

 token_case([two]).
 token_case([three]).
 token_case([four]).
 token_case([five]).
 token_case([six]).
 token_case([seven]).
 token_case([eight]).
 token_case([nine]).

% ============================================================
% GROUP B: Direct teens and direct tens
% Expected: basic lexical coverage
% ============================================================

 token_case([ten]).
token_case([eleven]).
 token_case([twelve]).
 token_case([thirteen]).
 token_case([fifteen]).
 token_case([twenty]).
 token_case([thirty]).
 token_case([fifty]).

% ============================================================
% GROUP C: Productive teen/eighteen forms
% Expected: parser should recover corresponding semantic terms.
% Some may later fail in generation if generator cannot reproduce them.
% ============================================================

 token_case([four,teen]).
 token_case([six,teen]).
token_case([seven,teen]).
 token_case([nine,teen]).
 token_case([eight,een]).

% ============================================================
% GROUP D: Compound twenties
% Expected: parser uses underscore form.
% Generator may output plain twenty, then normalization should align.
% ============================================================

 token_case([twenty_,one]).
 token_case([twenty_,two]).
 token_case([twenty_,three]).
 token_case([twenty_,four]).
 token_case([twenty_,five]).
 token_case([twenty_,six]).
 token_case([twenty_,seven]).
 token_case([twenty_,eight]).
 token_case([twenty_,nine]).

% ============================================================
% GROUP E: Compound thirties
% ============================================================

 token_case([thirty_,one]).
 token_case([thirty_,two]).
 token_case([thirty_,three]).
 token_case([thirty_,four]).
token_case([thirty_,five]).
 token_case([thirty_,six]).
 token_case([thirty_,seven]).
 token_case([thirty_,eight]).
 token_case([thirty_,nine]).

% ============================================================
% GROUP F: Compound fifties
% ============================================================

 token_case([fifty_,one]).
 token_case([fifty_,two]).
 %token_case([fifty_,three]).
 token_case([fifty_,four]).
 token_case([fifty_,five]).
 token_case([fifty_,six]).
 token_case([fifty_,seven]).
 token_case([fifty_,eight]).
 token_case([fifty_,nine]).

% ============================================================
% GROUP G: Productive ty/y forms
% WARNING: these may expose parser/generator mismatch.
% Uncomment one at a time.
% ============================================================

 token_case([four,ty]).
 token_case([six,ty]).
 token_case([seven,ty]).
 token_case([nine,ty]).
 token_case([eight,y]).

 token_case([six,ty_,four]).
 token_case([seven,ty_,four]).
 token_case([eight,y_,four]).
 token_case([nine,ty_,four]).

% ============================================================
% GROUP H: Hundreds
% WARNING: experimental. Uncomment one at a time.
% ============================================================

 token_case([one,hundred]).
 token_case([two,hundred]).
 token_case([three,hundred]).

 token_case([one,hundred_and,twenty]).
 token_case([two,hundred_and,thirty]).
 token_case([three,hundred_and,twenty_,four]).
 token_case([five,hundred_and,thirty_,six]).

% ============================================================
% GROUP I: Intentional parse-failure / diagnostic cases
% Expected: these should fail cleanly, not hang.
% Use after basic timeout/error handling is confirmed.
% ============================================================

 token_case([teen]).
 token_case([banana]).
 token_case([twenty_,ten]).
 token_case([seven,twenty_]).
 token_case([sixty_,four]).
 token_case([forty_,four]).