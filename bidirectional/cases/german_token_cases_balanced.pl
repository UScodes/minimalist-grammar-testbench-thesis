:- encoding(utf8).

% ============================================================
% German Token Balanced Test Cases
% Used for Parsing-to-Generation validation
% ============================================================


% ============================================================
% 1. Stable lexical pass cases
% ============================================================

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


% ============================================================
% 2. Stable composed pass cases
% ============================================================

token_case([zwei,undzwanzig]).
token_case([sechs,undzwanzig]).
token_case([sieben,undzwanzig]).


% ============================================================
% 3. Stable hundred pass cases
% ============================================================

token_case([zwei,hundert]).
token_case([sechs,hundert]).
token_case([sieben,hundert]).


% ============================================================
% 4. Representative token roundtrip mismatch cases
% ============================================================

token_case([drei,undzwanzig]).
token_case([vier,zig]).
token_case([drei,hundert]).


% ============================================================
% 5. Representative generation timeout cases
% ============================================================

token_case([sieben,und,vier,zig]).
token_case([drei,hundert,vier]).


% ============================================================
% 6. Representative parser failure cases
% ============================================================

token_case([sieben,und,acht,zig]).
token_case(['Schinken']).
token_case([hundert,hundert]).