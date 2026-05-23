:- module(token_normalizer, [
    normalize_gen_to_parser/2,
    normalize_parser_to_gen/2
]).

:- use_module('../config/testbench_options').
:- use_module('../config/smoothing_rules').

/*
-----------------------------------------------------------
MG Testbench – Token Normalizer
-----------------------------------------------------------

Purpose
-------
Optional token smoothing/normalization layer.

Behavior
--------
If smoothing_enabled(false), tokens are left unchanged.

If smoothing_enabled(true), the chosen smoothing_style/1 is used.
Currently supported:
  - none
  - underscore
  - plain
*/

normalize_gen_to_parser(In, Out) :-
    testbench_options:smoothing_enabled(false),
    !,
    Out = In.

normalize_gen_to_parser(In, Out) :-
    testbench_options:smoothing_enabled(true),
    testbench_options:smoothing_style(Style),
    normalize_list(gen_to_parser, Style, In, Out).

normalize_parser_to_gen(In, Out) :-
    testbench_options:smoothing_enabled(false),
    !,
    Out = In.

normalize_parser_to_gen(In, Out) :-
    testbench_options:smoothing_enabled(true),
    testbench_options:smoothing_style(Style),
    normalize_list(parser_to_gen, Style, In, Out).

normalize_list(_, _, [], []).

normalize_list(Direction, Style, [A, B | Rest], [A2, B | OutRest]) :-
    smoothing_rules:smoothing_rule(Direction, Style, A, A2),
    !,
    normalize_list(Direction, Style, Rest, OutRest).

normalize_list(Direction, Style, [H | T], [H | T2]) :-
    normalize_list(Direction, Style, T, T2).