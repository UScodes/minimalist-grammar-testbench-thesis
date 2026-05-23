:- module(repair_adapter, [
    maybe_repair_tokens/3
]).

:- use_module('../config/testbench_options').

/*
-----------------------------------------------------------
MG Testbench – Repair Adapter
-----------------------------------------------------------

Purpose
-------
Optional compatibility layer for known generator under-generation.

Behavior
--------
If repair_enabled(false), tokens are left unchanged.
If repair_enabled(true), known repair rules may be applied.
*/

maybe_repair_tokens(_Sem, GenTokens, GenTokens) :-
    testbench_options:repair_enabled(false),
    !.

maybe_repair_tokens(Sem, GenTokens, FixedTokens) :-
    testbench_options:repair_enabled(true),
    ( repair_compound_drop(Sem, GenTokens, FixedTokens) ->
        true
    ;
        FixedTokens = GenTokens
    ).

repair_compound_drop('1X+20'(N), [twenty], [twenty, Unit]) :-
    unit_token(N, Unit).
repair_compound_drop('1X+30'(N), [thirty], [thirty, Unit]) :-
    unit_token(N, Unit).
repair_compound_drop('1X+50'(N), [fifty], [fifty, Unit]) :-
    unit_token(N, Unit).

unit_token(1, one).
unit_token(2, two).
unit_token(3, three).
unit_token(4, four).
unit_token(5, five).
unit_token(6, six).
unit_token(7, seven).
unit_token(8, eight).
unit_token(9, nine).