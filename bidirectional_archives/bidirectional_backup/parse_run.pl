:- use_module('../SemanticGenerator/MG-Generator/helpers/mg_logger').
:- use_module(token_normalizer).

:- initialization(main, main).

main :-
    mg_logger:log_event(system, parse_run_start),

    consult('../MG-LC-Parser-with-Semantic-main/load.pl'),
    consult('../MG-LC-Parser-with-Semantic-main/sem_from_tree.pl'),
    consult('repair_adapter.pl'),
    consult('gen_out.pl'),

    open('parse_out.pl', write, ParseS),
    open('forward_tree_report.txt', append, TreeS),

    forall(
        gen_case(Sem, GenStatus, GenTokens, _Sent),
        (
            repair_adapter:maybe_repair_tokens(Sem, GenTokens, RepairedTokens),
            token_normalizer:normalize_gen_to_parser(RepairedTokens, ParserTokens),
            run_parse_case(ParserTokens, ParseStatus, ParsedSem, ParseTree),
            format(
                ParseS,
                "bidir_case(~q, ~q, ~q, ~q, ~q, ~q, ~q).~n",
                [Sem, GenStatus, GenTokens, RepairedTokens, ParserTokens, ParseStatus, ParsedSem]
            ),
            write_parse_tree_block(TreeS, Sem, ParserTokens, ParseStatus, ParsedSem, ParseTree),
            mg_logger:log_event(parse_session,
                parse_case(
                    semantic(Sem),
                    gen_status(GenStatus),
                    gen_tokens(GenTokens),
                    repaired_tokens(RepairedTokens),
                    parser_tokens(ParserTokens),
                    parse_status(ParseStatus),
                    parsed_sem(ParsedSem)
                ))
        )
    ),

    close(ParseS),
    close(TreeS),

    mg_logger:log_event(system, parse_run_end),
    halt.

run_parse_case([], parse_skipped_empty_tokens, none, none) :- !.
run_parse_case(Tokens, ok, ParsedSem, Tree) :-
    once(lcparser:lcParse(Tokens, Tree)),
    sem_from_tree:sem_from_parse_result(Tree, ParsedSem),
    !.
run_parse_case(_, parse_fail, none, none).

write_parse_tree_block(S, Sem, ParserTokens, ParseStatus, ParsedSem, ParseTree) :-
    format(S, "PARSE TOKENS: ~q~n", [ParserTokens]),
    format(S, "PARSE STATUS: ~q~n", [ParseStatus]),
    format(S, "PARSED SEMANTICS: ~q~n", [ParsedSem]),
    format(S, "PARSE TREE:~n", []),
    write_term(S, ParseTree, [quoted(true), portray(true), max_depth(0)]),
    format(S, "~n~n", []).