:- encoding(utf8).

% ============================================================
% German Token Test Cases
% Used for Parsing-to-Generation validation
% ============================================================
%
% Purpose
% -------
% These cases test the German parser first. If parsing succeeds, the
% recovered semantic representation is sent to the generator and the
% regenerated token sequence is compared with the original input.
%
% The file intentionally contains:
%
%   1. expected successful lexical items
%   2. expected successful composed forms
%   3. hundred constructions
%   4. malformed / unsupported token sequences
%   5. unknown lexical tokens
%
% This allows the testbench to check normal success behavior, parser
% failure handling, generation failure handling, and token comparison
% behavior for the German grammar pair.
%
% Important:
% Save this file as UTF-8 because it contains German tokens such as:
%
%   zwölf
%   ßig
%
% ============================================================


% ============================================================
% 1. Simple lexical items
% ============================================================

token_case([eins]).
token_case([zwei]).
token_case([drei]).
token_case([vier]).
token_case([fünf]).
token_case([sechs]).
token_case([sieben]).
token_case([acht]).
token_case([neun]).

token_case([zehn]).
token_case([elf]).
token_case([zwölf]).

token_case([sechzehn]).
token_case([siebzehn]).

token_case([zwanzig]).
token_case([einundzwanzig]).

token_case([sechzig]).
token_case([einundsechzig]).

token_case([siebzig]).
token_case([einundsiebzig]).

token_case([hundert]).


% ============================================================
% 2. Parser examples noted in the German grammar comments
% ============================================================

% From grammar comments:
% parse("zwei,undzwanzig",T).
% parse("drei,ßig",T).
% parse("zwei,und,drei,ßig",T).
% parse("sieben,und,vier,zig",T).
% parse("drei,hundert",T).
% parse("drei,hundert,vier",T).
% parse("drei,hundert,vier,zig",T).

token_case([zwei,undzwanzig]).
token_case([drei,ßig]).
token_case([zwei,und,drei,ßig]).
token_case([sieben,und,vier,zig]).

token_case([drei,hundert]).
token_case([drei,hundert,vier]).
token_case([drei,hundert,vier,zig]).


% ============================================================
% 3. Additional composed forms
% ============================================================

% Twenty-like forms
token_case([drei,undzwanzig]).
token_case([vier,undzwanzig]).
token_case([fünf,undzwanzig]).
token_case([sechs,undzwanzig]).
token_case([sieben,undzwanzig]).
token_case([acht,undzwanzig]).
token_case([neun,undzwanzig]).

% Thirty-like forms
token_case([vier,ßig]).
token_case([fünf,ßig]).
token_case([acht,ßig]).
token_case([neun,ßig]).

% Zig-like tens
token_case([vier,zig]).
token_case([sechs,zig]).
token_case([sieben,zig]).
token_case([acht,zig]).
token_case([neun,zig]).

% Compound zig forms
token_case([zwei,und,vier,zig]).
token_case([drei,und,vier,zig]).
token_case([fünf,und,vier,zig]).
token_case([neun,und,vier,zig]).


% ============================================================
% 4. Hundred forms
% ============================================================

token_case([zwei,hundert]).
token_case([vier,hundert]).
token_case([fünf,hundert]).
token_case([sechs,hundert]).
token_case([sieben,hundert]).
token_case([acht,hundert]).
token_case([neun,hundert]).

token_case([drei,hundert,zehn]).
token_case([drei,hundert,zwanzig]).
token_case([drei,hundert,sechzig]).
token_case([drei,hundert,siebzig]).

token_case([vier,hundert,drei]).
token_case([vier,hundert,zwanzig]).
token_case([vier,hundert,drei,ßig]).
token_case([vier,hundert,sieben,und,vier,zig]).


% ============================================================
% 5. Deliberate malformed / unsupported cases
% ============================================================
%
% These are not expected to pass. They test whether the parser stage
% reports parse_fail cleanly.

% From grammar comments: should fail
token_case([sieben,und,acht,zig]).
token_case([drei,hundert,sieben,und,vier,zig]).

% Unknown token
token_case([Schinken]).

% Wrong ordering
token_case([undzwanzig,zwei]).
token_case([zig,vier]).
token_case([hundert,drei]).

% Incomplete forms
token_case([und]).
token_case([zig]).
token_case([ßig]).
token_case([einund]).
token_case([zwei,und]).
token_case([drei,hundert,und]).

% Over-composed or suspicious forms
token_case([eins,undzwanzig]).
token_case([eins,und,drei,ßig]).
token_case([hundert,hundert]).
token_case([drei,hundert,hundert]).