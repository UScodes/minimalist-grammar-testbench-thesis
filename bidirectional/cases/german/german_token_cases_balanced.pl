% ============================================================
% German token balanced cases for Parsing-to-Generation
% Purpose:
%   - cover the main token patterns used by the German grammar,
%   - include successful round-trip cases,
%   - include controlled diagnostic cases.
% ============================================================

% ------------------------------------------------------------
% Group A: Units
% Expected: basic parsing and regeneration.
% ------------------------------------------------------------

token_case([eins]).
token_case([zwei]).
token_case([drei]).
token_case([vier]).
token_case([fuenf]).
token_case([sechs]).
token_case([sieben]).
token_case([acht]).
token_case([neun]).

% ------------------------------------------------------------
% Group B: Direct teens and direct tens
% Expected: direct lexical coverage where available.
% ------------------------------------------------------------

token_case([zehn]).
token_case([elf]).
token_case([zwoelf]).
token_case([dreizehn]).
token_case([fuenfzehn]).
token_case([zwanzig]).
token_case([dreissig]).
token_case([sechzig]).
token_case([siebzig]).

% ------------------------------------------------------------
% Group C: German compound twenties
% Purpose: test unit-und-ten constructions.
% The grammar represents the tens part as one token, e.g. undzwanzig.
% ------------------------------------------------------------

token_case([eins,undzwanzig]).
token_case([zwei,undzwanzig]).
token_case([drei,undzwanzig]).
token_case([vier,undzwanzig]).
token_case([fuenf,undzwanzig]).
token_case([sechs,undzwanzig]).
token_case([sieben,undzwanzig]).
token_case([acht,undzwanzig]).
token_case([neun,undzwanzig]).

% ------------------------------------------------------------
% Group D: German compound sixties and seventies
% Purpose: test productive compound tens beyond twenties.
% ------------------------------------------------------------

token_case([eins,undsechzig]).
token_case([zwei,undsechzig]).
token_case([vier,undsechzig]).
token_case([sechs,undsechzig]).
token_case([sieben,undsechzig]).
token_case([acht,undsechzig]).

token_case([eins,undsiebzig]).
token_case([zwei,undsiebzig]).
token_case([vier,undsiebzig]).
token_case([sechs,undsiebzig]).
token_case([sieben,undsiebzig]).
token_case([acht,undsiebzig]).

% ------------------------------------------------------------
% Group E: Hundred constructions
% Purpose: test extension beyond two-digit numerals.
% ------------------------------------------------------------

token_case([hundert]).
token_case([zwei,hundert]).
token_case([drei,hundert]).
token_case([fuenf,hundert]).

token_case([hundert,zwanzig]).
token_case([hundert,dreissig]).
token_case([hundert,sechzig]).
token_case([hundert,siebzig]).

% ------------------------------------------------------------
% Group F: Controlled negative / diagnostic cases
% Purpose: confirm that invalid or unsupported forms fail cleanly.
% ------------------------------------------------------------

token_case([banana]).
token_case([und,zwanzig]).
token_case([zwanzig,und,zwei]).
token_case([vier,und,vierzig]).
token_case([sechs,und,fuenfzig]).
token_case([acht,und,achtzig]).