:- module(parser_init, [init_parser/0]).

:- use_module(helpers/linker).

init_parser :-
    % build dynamic link/3 relations needed by lcparser
    linking(_),
    !.
