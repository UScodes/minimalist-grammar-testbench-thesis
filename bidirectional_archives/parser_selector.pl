:- module(parser_selector, [
    set_parser/1,
    parse_sentence/2
]).

:- dynamic current_parser/1.
current_parser(lc).

set_parser(lc) :-
    retractall(current_parser(_)),
    assertz(current_parser(lc)).

set_parser(topdown) :-
    retractall(current_parser(_)),
    assertz(current_parser(topdown)).

parse_sentence(Input, Parsed) :-
    current_parser(lc),
    parser_lc:parse_sentence(Input, Parsed).

parse_sentence(Input, Parsed) :-
    current_parser(topdown),
    parser_td:parse_sentence(Input, Parsed).
