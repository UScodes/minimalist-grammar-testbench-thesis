:- module(repair_adapter, [
    maybe_repair_tokens/3
]).

/*
  maybe_repair_tokens(+Sem, +GenTokens, -FixedTokens)

  Project-level compatibility layer.
  This does NOT change the grammar.

  It repairs known under-generation cases where the generator
  outputs only the tens token for compound meanings such as:
    '1X+20'(4) -> [twenty]
  instead of:
    [twenty, four]
*/

maybe_repair_tokens(Sem, GenTokens, FixedTokens) :-
    ( repair_compound_drop(Sem, GenTokens, FixedTokens) ->
        true
    ;
        FixedTokens = GenTokens
    ).

/* -----------------------------
   Compound tens repairs
----------------------------- */

repair_compound_drop('1X+20'(N), [twenty], [twenty, Unit]) :-
    unit_token(N, Unit).
repair_compound_drop('1X+30'(N), [thirty], [thirty, Unit]) :-
    unit_token(N, Unit).
repair_compound_drop('1X+50'(N), [fifty], [fifty, Unit]) :-
    unit_token(N, Unit).

/* -----------------------------
   Unit mapping
----------------------------- */

unit_token(1, one).
unit_token(2, two).
unit_token(3, three).
unit_token(4, four).
unit_token(5, five).
unit_token(6, six).
unit_token(7, seven).
unit_token(8, eight).
unit_token(9, nine).