:- encoding(utf8).

% ============================================================
% German Token Smoke Test Cases
% Used for Parsing-to-Generation validation
% ============================================================
%
% These are stable German cases that passed cleanly in the previous
% German parse-to-generation report.
%
% Purpose:
%   - check that German parser grammar loads
%   - check that German generator grammar loads
%   - check that German rule set is selected
%   - check that the pipeline works without English normalization
% ============================================================


% Simple lexical items

token_case([eins]).
token_case([zwei]).
token_case([drei]).
token_case([vier]).
token_case([sechs]).
token_case([sieben]).
token_case([acht]).
token_case([neun]).

token_case([zehn]).
token_case([elf]).
token_case([sechzehn]).
token_case([siebzehn]).

token_case([zwanzig]).
token_case([einundzwanzig]).

token_case([sechzig]).
token_case([einundsechzig]).

token_case([siebzig]).
token_case([einundsiebzig]).

token_case([hundert]).


% Stable composed forms

token_case([zwei,undzwanzig]).
token_case([sechs,undzwanzig]).
token_case([sieben,undzwanzig]).


% Stable hundred forms

token_case([zwei,hundert]).
token_case([sechs,hundert]).
token_case([sieben,hundert]).