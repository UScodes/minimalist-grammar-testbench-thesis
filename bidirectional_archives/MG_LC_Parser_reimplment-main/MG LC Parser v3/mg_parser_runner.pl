:- module(mg_parser_runner, [
    parse_once/1,
    parse_suite/0
]).

:- use_module(lcparser).

parse_once(Tokens) :-
    (   once(lcParse(Tokens, Tree))
    ->  format("PARSE ~w => OK~n", [Tokens])
    ;   format("PARSE ~w => FAIL~n", [Tokens])
    ).

parse_suite :-
    % should succeed
    parse_once([seven]),
    parse_once([twenty]),
    parse_once([twenty_,one]),
    parse_once([six,teen]),
    parse_once([forty_,seven]),
    parse_once([two,hundred_and,four]),
    parse_once([two,hundred_and,eight,y_,six]),

    % should fail
    parse_once([fourty_,seven]),
    parse_once([bacon]),
    parse_once([two,hundred]).
