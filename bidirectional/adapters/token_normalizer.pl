:- module(token_normalizer, [
    normalize_gen_to_parser/2,
    normalize_parser_to_gen/2
]).

:- use_module('../config/testbench_profile').
:- use_module('../config/smoothing_rules').

/*
-----------------------------------------------------------
MG Testbench – Token Normalizer
-----------------------------------------------------------

Purpose
-------
Optional token normalization layer.

In this testbench, smoothing settings define the normalization policy,
while this adapter applies the selected normalization operation.

Behavior
--------
If smoothing_enabled(false), tokens are left unchanged.

If smoothing_enabled(true), the chosen smoothing_style/1 is used.
Currently supported:
  - none
  - underscore
  - plain

The options smoothing_enabled/1 and smoothing_style/1 are read
from testbench_profile.pl, so the active profile is the single
source of truth.
*/

normalize_gen_to_parser(In, Out) :-
    normalize_tokens(gen_to_parse, In, Out).

normalize_parser_to_gen(In, Out) :-
    normalize_tokens(parse_to_gen, In, Out).

normalize_tokens(_Direction, In, In) :-
    testbench_profile:smoothing_enabled(false),
    !.

normalize_tokens(_Direction, In, In) :-
    testbench_profile:smoothing_enabled(true),
    testbench_profile:smoothing_style(none),
    !.

normalize_tokens(Direction, In, Out) :-
    testbench_profile:smoothing_enabled(true),
    testbench_profile:smoothing_style(Style),
    normalize_list(Direction, Style, In, Out).

normalize_list(_, _, [], []).

normalize_list(Direction, Style, [H | T], [H2 | T2]) :-
    normalize_token(Direction, Style, H, H2),
    normalize_list(Direction, Style, T, T2).

normalize_token(Direction, Style, Token, Normalized) :-
    smoothing_rules:smoothing_rule(Direction, Style, Token, Normalized),
    !.

normalize_token(_, _, Token, Token).