:- use_module('../SemanticGenerator/MG-Generator/helpers/mg_logger').

:- initialization(main, main).

/*
-----------------------------------------------------------
MG Testbench – Reverse Parse Session
-----------------------------------------------------------

Input tokens
   -> parser
   -> semantic reconstruction
   -> reverse_parse_out.pl
*/

main :-
    mg_logger:log_event(system, reverse_parse_run_start),

    consult('../MG-LC-Parser-with-Semantic-main/load.pl'),
    consult('../MG-LC-Parser-with-Semantic-main/sem_from_tree.pl'),
    consult('token_cases.pl'),

    open('reverse_parse_out.pl', write, S),
    forall(
        token_case(InputTokens),
        (
            run_reverse_parse_case(InputTokens, ParseStatus, ParsedSem),
            format(
                S,
                "reverse_parse_case(~q, ~q, ~q).~n",
                [InputTokens, ParseStatus, ParsedSem]
            ),
            mg_logger:log_event(reverse_parse_session,
                reverse_parse_case(
                    input_tokens(InputTokens),
                    parse_status(ParseStatus),
                    parsed_sem(ParsedSem)
                ))
        )
    ),
    close(S),

    mg_logger:log_event(system, reverse_parse_run_end),
    halt.

run_reverse_parse_case(InputTokens, ok, ParsedSem) :-
    once(lcparser:lcParse(InputTokens, ParseTree)),
    sem_from_tree:sem_from_parse_result(ParseTree, ParsedSem),
    !.
run_reverse_parse_case(_, parse_fail, none).