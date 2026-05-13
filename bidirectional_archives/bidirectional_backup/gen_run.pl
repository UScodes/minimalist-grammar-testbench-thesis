:- use_module('../SemanticGenerator/MG-Generator/helpers/mg_logger').

:- initialization(main, main).

main :-
    mg_logger:log_event(system, gen_run_start),

    consult('../SemanticGenerator/MG-Generator/main.pl'),
    consult('test_cases.pl'),

    findall(Sem, test_case(Sem), Tests),

    open('gen_out.pl', write, GenS),
    open('forward_tree_report.txt', write, TreeS),

    forall(
        member(Sem, Tests),
        (
            run_gen_case(Sem, GenStatus, Tokens, Sent, TreeTerm),
            format(GenS, "gen_case(~q, ~q, ~q, ~q).~n", [Sem, GenStatus, Tokens, Sent]),
            write_gen_tree_block(TreeS, Sem, GenStatus, Tokens, Sent, TreeTerm),
            mg_logger:log_event(gen_session,
                gen_case(
                    semantic(Sem),
                    status(GenStatus),
                    tokens(Tokens),
                    sentence(Sent)
                ))
        )
    ),

    close(GenS),
    close(TreeS),

    mg_logger:log_event(system, gen_run_end),
    halt.

run_gen_case(Sem, GenStatus, Tokens, Sent, TreeTerm) :-
    catch(
        (
            mg_generate_wrapper:generate_safe(Sem, Sent0, _L, Tree0, Status0),
            extract_words(Tree0, Tokens0),
            normalize_sent(Sent0, Sent),
            normalize_gen_status(Status0, Tokens0, GenStatus),
            Tokens = Tokens0,
            TreeTerm = Tree0
        ),
        E,
        (
            GenStatus = error(E),
            Tokens = [],
            Sent = '',
            TreeTerm = none
        )
    ).

normalize_gen_status(ok, [], gen_empty_yield) :- !.
normalize_gen_status(ok, [_|_], ok) :- !.
normalize_gen_status(Status, _, Status).

normalize_sent(S, S).

extract_words(li(W, _, _), W) :- !.
extract_words(tree(H, _, _), W) :- extract_words(H, W), !.
extract_words(tree([(W, _, _) | _], _, _, _), W) :- !.
extract_words([T | _], W) :- extract_words(T, W), !.
extract_words(_, []).

write_gen_tree_block(S, Sem, GenStatus, Tokens, Sent, TreeTerm) :-
    format(S, "==================================================~n", []),
    format(S, "SEMANTIC: ~q~n", [Sem]),
    format(S, "GEN STATUS: ~q~n", [GenStatus]),
    format(S, "GEN TOKENS: ~q~n", [Tokens]),
    format(S, "GEN SENTENCE: ~q~n", [Sent]),
    format(S, "GEN TREE:~n", []),
    write_term(S, TreeTerm, [quoted(true), portray(true), max_depth(0)]),
    format(S, "~n~n", []).