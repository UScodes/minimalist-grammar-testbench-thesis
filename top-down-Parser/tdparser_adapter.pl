% C:\Users\Lenovo\mg_testbench\top-down-Parser\tdparser_adapter.pl
:- module(parser_td, [
    parse_sentence/2,
    parse_tokens/2
]).

:- set_prolog_flag(encoding, utf8).

% Load the actual top-down parser (this file loads ZahlenSprache internally)
:- ['C:/Users/Lenovo/mg_testbench/top-down-Parser/Top-Down-Parser.pl'].

% Direct tokens interface
parse_tokens(Tokens, ParsedTree) :-
    with_output_to(string(_), parse(Tokens, ParsedTree)).

% Adapter: "eins hundert" -> [eins,hundert] -> parse/2
parse_sentence(SentenceString, ParsedTree) :-
    split_string(SentenceString, " ", " \t\r\n", TokenStrings),
    TokenStrings \= [],
    maplist(atom_string, Tokens, TokenStrings),
    parse_tokens(Tokens, ParsedTree).
