:- module(token_normalizer, [
    normalize_gen_to_parser/2,
    normalize_parser_to_gen/2
]).

/*
-----------------------------------------------------------
MG Testbench – Token Normalizer
-----------------------------------------------------------

Purpose
-------
Provides shared token normalization rules between the
generator and parser representations.

Current use
-----------
1. Forward direction:
   Generator tokens -> Parser-compatible tokens

2. Reverse direction:
   Parser tokens -> Generator-compatible tokens

Design note
-----------
This module only handles token-shape normalization.
It does NOT repair dropped generator units.
That remains the responsibility of repair_adapter.pl.
*/

normalize_gen_to_parser(In, Out) :-
    normalize_gen_to_parser_list(In, Out).

normalize_parser_to_gen(In, Out) :-
    normalize_parser_to_gen_list(In, Out).

/* ---------------------------------
   Generator -> Parser normalization
--------------------------------- */

normalize_gen_to_parser_list([], []).

normalize_gen_to_parser_list([twenty, X | R], [twenty_, X | R2]) :- !,
    normalize_gen_to_parser_list(R, R2).
normalize_gen_to_parser_list([thirty, X | R], [thirty_, X | R2]) :- !,
    normalize_gen_to_parser_list(R, R2).
normalize_gen_to_parser_list([forty, X | R], [forty_, X | R2]) :- !,
    normalize_gen_to_parser_list(R, R2).
normalize_gen_to_parser_list([fifty, X | R], [fifty_, X | R2]) :- !,
    normalize_gen_to_parser_list(R, R2).

normalize_gen_to_parser_list([H | T], [H | T2]) :-
    normalize_gen_to_parser_list(T, T2).

/* ---------------------------------
   Parser -> Generator normalization
--------------------------------- */

normalize_parser_to_gen_list([], []).

normalize_parser_to_gen_list([twenty_, X | R], [twenty, X | R2]) :- !,
    normalize_parser_to_gen_list(R, R2).
normalize_parser_to_gen_list([thirty_, X | R], [thirty, X | R2]) :- !,
    normalize_parser_to_gen_list(R, R2).
normalize_parser_to_gen_list([forty_, X | R], [forty, X | R2]) :- !,
    normalize_parser_to_gen_list(R, R2).
normalize_parser_to_gen_list([fifty_, X | R], [fifty, X | R2]) :- !,
    normalize_parser_to_gen_list(R, R2).

normalize_parser_to_gen_list([H | T], [H | T2]) :-
    normalize_parser_to_gen_list(T, T2).