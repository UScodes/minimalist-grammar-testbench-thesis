:- use_module('../SemanticGenerator/MG-Generator/helpers/mg_logger').
:- use_module(token_normalizer).

:- initialization(main, main).

/*
-----------------------------------------------------------
MG Testbench – Reverse Generation Session
-----------------------------------------------------------

reverse_parse_out.pl
   -> generator
   -> normalized regenerated tokens
   -> reverse_out.pl
*/

main :-
    mg_logger:log_event(system, reverse_gen_run_start),

    consult('../SemanticGenerator/MG-Generator/main.pl'),
    consult('reverse_parse_out.pl'),

    open('reverse_out.pl', write, S),
    forall(
        reverse_parse_case(InputTokens, ParseStatus, ParsedSem),
        (
            run_reverse_gen_case(ParseStatus, ParsedSem, GenStatus, RawGenTokens, NormGenTokens),
            format(
                S,
                "reverse_case(~q, ~q, ~q, ~q, ~q, ~q).~n",
                [InputTokens, ParseStatus, ParsedSem, GenStatus, RawGenTokens, NormGenTokens]
            ),
            mg_logger:log_event(reverse_gen_session,
                reverse_case(
                    input_tokens(InputTokens),
                    parse_status(ParseStatus),
                    parsed_sem(ParsedSem),
                    gen_status(GenStatus),
                    raw_gen_tokens(RawGenTokens),
                    normalized_gen_tokens(NormGenTokens)
                ))
        )
    ),
    close(S),

    mg_logger:log_event(system, reverse_gen_run_end),
    halt.

run_reverse_gen_case(parse_fail, none, gen_skipped, [], []) :- !.

run_reverse_gen_case(ok, ParsedSem, GenStatus, RawGenTokens, NormGenTokens) :-
    catch(
        (
            mg_generate_wrapper:generate_safe(ParsedSem, _Sent, _L, Tree, Status0),
            extract_words(Tree, Tokens0),
            normalize_gen_status(Status0, Tokens0, GenStatus),
            RawGenTokens = Tokens0,
            token_normalizer:normalize_gen_to_parser(Tokens0, NormGenTokens)
        ),
        E,
        (
            GenStatus = error(E),
            RawGenTokens = [],
            NormGenTokens = []
        )
    ).

normalize_gen_status(ok, [], gen_empty_yield) :- !.
normalize_gen_status(ok, [_|_], ok) :- !.
normalize_gen_status(Status, _, Status).

extract_words(li(W, _, _), W) :- !.
extract_words(tree(H, _, _), W) :- extract_words(H, W), !.
extract_words(tree([(W, _, _) | _], _, _, _), W) :- !.
extract_words([T | _], W) :- extract_words(T, W), !.
extract_words(_, []).