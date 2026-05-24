:- module(mg_parser_runner, [
    parse_once/1,
    parse_suite/0
]).

:- use_module(lcparser).
:- use_module('C:/Users/Lenovo/mg_testbench/SemanticGenerator/MG-Generator/helpers/mg_logger').

parse_once(Tokens) :-
    (   once(lcParse(Tokens, Tree))
    ->  Status = ok
    ;   Status = fail,
        Tree = none
    ),
    format("PARSE ~w => ~w~n", [Tokens, Status]),
    mg_logger:log_event(parser,
        parse_result(
            input(Tokens),
            status(Status),
            tree(Tree)
        )
    ).

parse_suite :-
    mg_logger:log_event(system, start_suite(parser)),

    parse_once([seven]),
    parse_once([twenty]),
    parse_once([twenty_,one]),
    parse_once([forty_,seven]),

    parse_once([six,teen]),      % expected fail (format)
    parse_once([fourty_,seven]),
    parse_once([bacon]),
    parse_once([two,hundred]),

    mg_logger:log_event(system, end_suite(parser)).
