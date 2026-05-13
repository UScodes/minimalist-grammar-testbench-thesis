:- module(lex_bridge, [install/0, status/0]).

install :-
    % lcparser expects (::)/2 and startCategory/1 in module lcparser
    install_forwarder(lcparser, '::', 2, lex_en:'::'),
    install_forwarder(lcparser, startCategory, 1, lex_en:startCategory),

    % sem_from_tree also uses (::)/2 (reconstruct semantics)
    install_forwarder(sem_from_tree, '::', 2, lex_en:'::'),
    install_forwarder(sem_from_tree, startCategory, 1, lex_en:startCategory),

    % generator selection expects (::)/2 and startCategory/1 in lambdaSelect
    install_forwarder(lambdaSelect, '::', 2, lex_gen:'::'),
    install_forwarder(lambdaSelect, startCategory, 1, lex_gen:startCategory).

install_forwarder(Mod, Name, Arity, Target) :-
    functor(Head, Name, Arity),
    (   current_predicate(Mod:Name/Arity)
    ->  true
    ;   Head =.. [Name|Args],
        Call =.. [Name|Args],
        assertz(Mod:(Head :- call(Target, Call)))
    ).

status :-
    writeln('--- BRIDGE STATUS ---'),
    ( current_predicate(lcparser:'::'/2)      -> writeln('lcparser ::/2 OK')      ; writeln('lcparser ::/2 MISSING') ),
    ( current_predicate(lambdaSelect:'::'/2)  -> writeln('lambdaSelect ::/2 OK')  ; writeln('lambdaSelect ::/2 MISSING') ),
    ( current_predicate(sem_from_tree:'::'/2) -> writeln('sem_from_tree ::/2 OK') ; writeln('sem_from_tree ::/2 MISSING') ).