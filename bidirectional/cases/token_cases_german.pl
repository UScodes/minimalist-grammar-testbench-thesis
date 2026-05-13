% German token test cases

% simple lexical items
token_case([eins]).
token_case([drei]).
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

% parser examples noted in grammar comments
token_case([zwei,undzwanzig]).
token_case([drei,ßig]).
token_case([zwei,und,drei,ßig]).
token_case([sieben,und,vier,zig]).
token_case([drei,hundert]).
token_case([drei,hundert,vier]).
token_case([drei,hundert,vier,zig]).