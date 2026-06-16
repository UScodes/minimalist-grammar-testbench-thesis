% ============================================================
% English token balanced cases for Parsing-to-Generation
% Purpose:
%   - cover the main numeral patterns used by the grammar,
%   - include successful round-trip cases,
%   - include controlled diagnostic cases.
% ============================================================

% ------------------------------------------------------------
% Group A: Units
% Expected: basic parsing and regeneration.
% ------------------------------------------------------------

token_case([one]).
token_case([two]).
token_case([three]).
token_case([four]).
token_case([five]).
token_case([six]).
token_case([seven]).
token_case([eight]).
token_case([nine]).

% ------------------------------------------------------------
% Group B: Direct teens and direct tens
% Expected: direct lexical coverage.
% ------------------------------------------------------------

token_case([ten]).
token_case([eleven]).
token_case([twelve]).
token_case([thirteen]).
token_case([fifteen]).
token_case([twenty]).
token_case([thirty]).
token_case([fifty]).

% ------------------------------------------------------------
% Group C: Productive teen/eighteen forms
% Purpose: test productive morphology and parser coverage.
% Some cases are expected to expose parsing limitations.
% ------------------------------------------------------------

token_case([four,teen]).
token_case([six,teen]).
token_case([seven,teen]).
token_case([nine,teen]).
token_case([eight,een]).

% ------------------------------------------------------------
% Group D: Compound twenties
% Purpose: test parser-side underscore convention and normalization.
% ------------------------------------------------------------

token_case([twenty_,one]).
token_case([twenty_,two]).
token_case([twenty_,three]).
token_case([twenty_,four]).
token_case([twenty_,five]).
token_case([twenty_,six]).
token_case([twenty_,seven]).
token_case([twenty_,eight]).
token_case([twenty_,nine]).

% ------------------------------------------------------------
% Group E: Compound thirties
% ------------------------------------------------------------

token_case([thirty_,one]).
token_case([thirty_,two]).
token_case([thirty_,three]).
token_case([thirty_,four]).
token_case([thirty_,five]).
token_case([thirty_,six]).
token_case([thirty_,seven]).
token_case([thirty_,eight]).
token_case([thirty_,nine]).

% ------------------------------------------------------------
% Group F: Compound fifties
% ------------------------------------------------------------

token_case([fifty_,one]).
token_case([fifty_,two]).
token_case([fifty_,four]).
token_case([fifty_,five]).
token_case([fifty_,six]).
token_case([fifty_,seven]).
token_case([fifty_,eight]).
token_case([fifty_,nine]).

% ------------------------------------------------------------
% Group G: Productive ty/y forms
% Purpose: test productive tens and compound tens.
% Some cases are expected to expose generation timeouts or parser limits.
% ------------------------------------------------------------

token_case([four,ty]).
token_case([six,ty]).
token_case([seven,ty]).
token_case([nine,ty]).
token_case([eight,y]).

token_case([six,ty_,four]).
token_case([seven,ty_,four]).
token_case([eight,y_,four]).
token_case([nine,ty_,four]).

% ------------------------------------------------------------
% Group H: Hundred constructions
% Purpose: test extension beyond two-digit numerals.
% Includes both successful and diagnostic hundred cases.
% ------------------------------------------------------------

token_case([one,hundred]).
token_case([two,hundred]).
token_case([three,hundred]).

token_case([one,hundred_and,twenty]).
token_case([two,hundred_and,thirty]).
token_case([three,hundred_and,twenty_,four]).
token_case([five,hundred_and,thirty_,six]).

% ------------------------------------------------------------
% Group I: Controlled negative / diagnostic cases
% Purpose: confirm that invalid or unsupported forms fail cleanly.
% ------------------------------------------------------------

token_case([teen]).
token_case([banana]).
token_case([twenty_,ten]).
token_case([seven,twenty_]).
token_case([sixty_,four]).
token_case([forty_,four]).