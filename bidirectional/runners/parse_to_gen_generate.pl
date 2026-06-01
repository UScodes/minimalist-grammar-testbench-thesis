:- use_module('../logging/testbench_logger').
:- use_module('../adapters/token_normalizer').
:- use_module('../config/run_metadata').
:- use_module('../config/testbench_profile').

:- initialization(main, main).

main :-
    mg_logger:log_event(system, reverse_gen_run_start),
    log_run_configuration,

    testbench_profile:generator_main_file(GeneratorMainFile),
    consult(GeneratorMainFile),

    % Testbench-local generator adapter.
    consult('../adapters/generator_adapter.pl'),

    run_metadata:reverse_parse_out_file(ReverseParseOutFile),
    consult(ReverseParseOutFile),

    run_metadata:reverse_out_file(ReverseOutFile),
    open(ReverseOutFile, write, S),

    run_metadata:reverse_gen_tree_report_file(ReverseGenTreeReportFile),
    open(ReverseGenTreeReportFile, write, TreeS),

    forall(
        reverse_parse_case(InputTokens, ParseStatus, ParsedSem),
        (
            run_reverse_gen_case(
                InputTokens,
                ParseStatus,
                ParsedSem,
                GenStatus,
                RawGenTokens,
                NormalizedGenTokens,
                Sent,
                Tree
            ),
            format(
                S,
                "reverse_case(~q, ~q, ~q, ~q, ~q, ~q, ~q).~n",
                [InputTokens, ParseStatus, ParsedSem, GenStatus, RawGenTokens, NormalizedGenTokens, Sent]
            ),
            format(TreeS, "Input Tokens: ~q~n", [InputTokens]),
            format(TreeS, "Parse Status: ~q~n", [ParseStatus]),
            format(TreeS, "Parsed Semantic Input: ~q~n", [ParsedSem]),
            format(TreeS, "Generation Status: ~q~n", [GenStatus]),
            format(TreeS, "Raw Generated Tokens: ~q~n", [RawGenTokens]),
            format(TreeS, "Normalized Generated Tokens: ~q~n", [NormalizedGenTokens]),
            format(TreeS, "Generated Sentence: ~q~n", [Sent]),
            format(TreeS, "Generation Tree: ~q~n", [Tree]),
            format(TreeS, "--------------------------------------------------~n", []),
            mg_logger:log_event(
                reverse_gen_session,
                reverse_case(
                    input_tokens(InputTokens),
                    parse_status(ParseStatus),
                    parsed_sem(ParsedSem),
                    gen_status(GenStatus),
                    raw_gen_tokens(RawGenTokens),
                    normalized_gen_tokens(NormalizedGenTokens),
                    sentence(Sent)
                )
            )
        )
    ),

    close(TreeS),
    close(S),
    mg_logger:log_event(system, reverse_gen_run_end),
    halt.

log_run_configuration :-
    testbench_profile:profile_name(ProfileName),
    testbench_profile:generator_name(GeneratorName),
    testbench_profile:generator_main_file(GeneratorMainFile),
    testbench_profile:generator_lexicon_name(GeneratorLexiconName),
    testbench_profile:generator_lexicon_file(GeneratorLexiconFile),

    testbench_profile:repair_enabled(Repair),
    testbench_profile:smoothing_enabled(Smoothing),
    testbench_profile:smoothing_style(Style),

    run_metadata:reverse_parse_out_file(ReverseParseOutFile),
    run_metadata:reverse_out_file(ReverseOutFile),

    mg_logger:log_event(
        configuration,
        reverse_gen_run(
            profile_name(ProfileName),
            generator_name(GeneratorName),
            generator_main_file(GeneratorMainFile),
            generator_lexicon_name(GeneratorLexiconName),
            generator_lexicon_file(GeneratorLexiconFile),
            reverse_parse_out_file(ReverseParseOutFile),
            reverse_out_file(ReverseOutFile),
            repair_enabled(Repair),
            smoothing_enabled(Smoothing),
            smoothing_style(Style)
        )
    ),

    format(
        "~n[reverse_gen_run] profile=~q generator=~q generator_main=~q generator_lexicon=~q reverse_parse_out=~q reverse_out=~q repair=~q smoothing=~q style=~q~n",
        [
            ProfileName,
            GeneratorName,
            GeneratorMainFile,
            GeneratorLexiconName,
            ReverseParseOutFile,
            ReverseOutFile,
            Repair,
            Smoothing,
            Style
        ]
    ).

run_reverse_gen_case(_InputTokens, parse_fail, none, generation_not_attempted, [], [], '', none) :- !.

run_reverse_gen_case(_InputTokens, parse_skipped_empty_tokens, none, generation_not_attempted, [], [], '', none) :- !.

run_reverse_gen_case(_InputTokens, ok, ParsedSem, GenStatus, RawGenTokens, NormalizedGenTokens, Sent, Tree) :-
    catch(
        call_with_time_limit(
            5,
            (
                mg_generate_wrapper:generate_safe(ParsedSem, Sent0, _L, Tree0, Status0),
                extract_words(Tree0, RawGenTokens0),
                normalize_sent(Sent0, Sent),
                normalize_gen_status(Status0, RawGenTokens0, GenStatus),
                RawGenTokens = RawGenTokens0,
                token_normalizer:normalize_gen_to_parser(RawGenTokens, NormalizedGenTokens),
                Tree = Tree0
            )
        ),
        E,
        handle_reverse_gen_exception(E, GenStatus, RawGenTokens, NormalizedGenTokens, Sent, Tree)
    ).

handle_reverse_gen_exception(time_limit_exceeded, generation_timeout, [], [], '', none) :- !.
handle_reverse_gen_exception(E, error(E), [], [], '', none).

normalize_gen_status(timeout, _, generation_timeout) :- !.
normalize_gen_status(no_solution, _, gen_empty_yield) :- !.
normalize_gen_status(ok, [], gen_empty_yield) :- !.
normalize_gen_status(ok, [_|_], ok) :- !.
normalize_gen_status(Status, _, Status).

normalize_sent(S, S).

/*
extract_words/2
---------------
Extracts the surface token list from a generated MG tree.

Generated trees may contain multiple chains at the root. The extractor
therefore collects the word lists from all chains instead of taking only
the first one.
*/

extract_words(li(Words, _, _), Words) :- !.

extract_words(tree(Chains, _, _, _), Words) :-
    is_chain_list(Chains),
    words_from_chains(Chains, Words),
    !.

extract_words(tree(Chains, _, _), Words) :-
    is_chain_list(Chains),
    words_from_chains(Chains, Words),
    !.

extract_words(tree(Head, _, _), Words) :-
    extract_words(Head, Words),
    !.

extract_words([T | _], Words) :-
    extract_words(T, Words),
    !.

extract_words(_, []).

is_chain_list([(Words, _Features, _Sem) | _]) :-
    is_list(Words),
    !.

words_from_chains([], []).

words_from_chains([(Words, _Features, _Sem) | Rest], Out) :-
    words_from_chains(Rest, RestOut),
    append(Words, RestOut, Out).