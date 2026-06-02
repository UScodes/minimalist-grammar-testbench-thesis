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
This adapter applies optional token normalization between pipeline
stages.

Token normalization is used when the parser and generator use slightly
different surface conventions for the same lexical material. For example,
one component may use a stem-like token such as twenty_, while another
component may use twenty.

The normalizer does not decide the policy itself. The active experiment
profile controls whether normalization is enabled and which normalization
style is used.

Behavior
--------
If smoothing_enabled(false), tokens are left unchanged.

If smoothing_enabled(true), the selected smoothing_style/1 is applied.
The name smoothing_style/1 is kept as the profile option name, while this
file treats it as the selected token-normalization style.

Currently supported styles:
  - none
  - underscore
  - plain

The options smoothing_enabled/1 and smoothing_style/1 are read from
testbench_profile.pl, so the active profile remains the single source of
truth for normalization behavior.
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