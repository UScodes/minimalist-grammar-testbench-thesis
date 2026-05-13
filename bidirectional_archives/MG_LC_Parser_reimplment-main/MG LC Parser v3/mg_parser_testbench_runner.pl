:- use_module(parser_init).
:- use_module('helpers/mg_logger').
:- module(mg_parser_runner, [
    parse_once/1,
    parse_suite/0
]).

:- use_module(mg_parse_wrapper).
:- use_module(parser_init).
:- use_module('helpers/mg_logger').

parse_once(Tokens) :-
    parse_safe(Tokens, Tree, Status),
    format("PARSE ~w => ~w~n", [Tokens, Status]),
    mg_logger:log_event(parser,
        parse_result(
            input(Tokens),
            status(Status),
            tree(Tree)
        )
    ),
    true.

parse_suite :-
    parser_init:init_parser,
    mg_logger:log_event(system, start_suite(parser)),

    % ---- should succeed ----
    parse_once([seven]),
    parse_once([twenty]),
    parse_once([twenty_,one]),
    parse_once([six,teen]),
    parse_once([forty_,seven]),
    parse_once([two,hundred_and,four]),
    parse_once([two,hundred_and,eight,y_,six]),

    % ---- should fail ----
    parse_once([fourty_,seven]),
    parse_once([bacon]),
    parse_once([two,hundred]),

    mg_logger:log_event(system, end_suite(parser)),
    true.
