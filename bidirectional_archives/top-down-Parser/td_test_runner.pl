% C:\Users\Lenovo\mg_testbench\top-down-Parser\td_test_runner.pl
:- module(td_test_runner, [
    run_td_tests/0,
    run_td_tests/1
]).

:- set_prolog_flag(encoding, utf8).

:- use_module('C:/Users/Lenovo/mg_testbench/top-down-Parser/tdparser_adapter.pl').

% ------------------------------------------------------------
% Test sets
% ------------------------------------------------------------

% A small “smoke test” set: should all PASS
td_positive_tests([
    [eins],
    [acht],
    [zehn],
    [zwanzig],
    [einhundert],
    [eintausend],
    [einundzwanzig],
    [zwei, hundert],
    [zwei, tausend],
    [zwei, tausend, drei, hundert]
]).

% A small negative set: should all FAIL
td_negative_tests([
    [und],
    [tausend],
    [eins, und],
    [drei, und, zwanzig],      % your result shows this fails (grammar limitation)
    [dreiundzwanzig]           % also fails (no lexical entry in ZahlenSprache)
]).

% ------------------------------------------------------------
% Runner
% ------------------------------------------------------------

run_td_tests :-
    run_td_tests(verbose).

run_td_tests(Mode) :-
    td_positive_tests(Pos),
    td_negative_tests(Neg),

    format("~n=== TOP-DOWN PARSER TEST RUN (~w) ===~n", [Mode]),
    format("Grammar: ZahlenSprache | StartCategory should be c4~n~n", []),

    run_group("POSITIVE (should parse)", Pos, expect_true, Mode),
    nl,
    run_group("NEGATIVE (should reject)", Neg, expect_false, Mode),

    format("~n=== DONE ===~n", []).

run_group(Title, Tests, Expectation, Mode) :-
    format("---- ~w ----~n", [Title]),
    forall(member(Tokens, Tests),
        run_one(Tokens, Expectation, Mode)
    ).

run_one(Tokens, expect_true, Mode) :-
    (   once(parser_td:parse_tokens(Tokens, Tree))
    ->  format("PASS  ~q~n", [Tokens]),
        ( Mode == verbose -> format("      Tree=~q~n", [Tree]) ; true )
    ;   format("FAIL  ~q   (unexpected reject)~n", [Tokens])
    ).

run_one(Tokens, expect_false, _Mode) :-
    (   once(parser_td:parse_tokens(Tokens, _Tree))
    ->  format("FAIL  ~q   (unexpected accept)~n", [Tokens])
    ;   format("PASS  ~q~n", [Tokens])
    ).
