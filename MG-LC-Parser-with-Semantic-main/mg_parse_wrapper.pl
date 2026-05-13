:- module(mg_parse_wrapper, [parse_safe/3]).

:- use_module(lcparser).
:- use_module(library(time)).

% parse_safe(+Tokens, -Tree, -Status)
parse_safe(Tokens, Tree, ok) :-
    call_with_time_limit(
        5,
        once(lcParse(Tokens, Tree))
    ),
    !.

parse_safe(_, _, fail).
