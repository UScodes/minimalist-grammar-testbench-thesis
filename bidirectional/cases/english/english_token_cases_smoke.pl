% ============================================================
% English token smoke cases for Parsing-to-Generation
% Purpose: controlled cases expected to pass.
% Coverage: units, direct forms, compounds, and one hundred-form.
% ============================================================

% Units
token_case([one]).
token_case([two]).
token_case([three]).

% Direct lexical forms
token_case([ten]).
token_case([eleven]).
token_case([twenty]).
token_case([thirty]).
token_case([fifty]).

% Compound forms requiring parser-side underscore convention
token_case([twenty_,one]).
token_case([twenty_,seven]).
token_case([thirty_,four]).
token_case([fifty_,six]).

% Hundred construction known to parse and regenerate
token_case([one,hundred_and,twenty]).