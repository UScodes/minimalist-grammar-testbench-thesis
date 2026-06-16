% ============================================================
% German token smoke cases for Parsing-to-Generation
% Purpose: controlled cases expected to pass.
% Coverage: units, direct forms, compounds, and hundred forms.
% ============================================================

% Units
token_case([eins]).
token_case([zwei]).
token_case([drei]).
token_case([vier]).
token_case([sechs]).
token_case([sieben]).
token_case([acht]).
token_case([neun]).

% Direct lexical forms
token_case([zehn]).
token_case([elf]).
token_case([zwanzig]).
token_case([sechzig]).
token_case([siebzig]).

% Compound forms
token_case([zwei,undzwanzig]).
token_case([sechs,undzwanzig]).
token_case([sieben,undzwanzig]).

% Hundred forms
token_case([hundert]).
token_case([zwei,hundert]).
token_case([hundert,zwanzig]).
token_case([hundert,sechzig]).
token_case([hundert,siebzig]).