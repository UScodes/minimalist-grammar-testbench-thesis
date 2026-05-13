:- module(parser_init, [init_parser/0]).

:- use_module(linker).

init_parser :-
    (   current_predicate(link/3),
        linker:link(_,_,_)
    ->  true                 % links already exist
    ;   writeln('Initializing linker...'),
        linker:linking(_),
        writeln('Linker initialized.')
    ).
