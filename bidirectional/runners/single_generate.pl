:- use_module('../logging/testbench_logger').
:- use_module('../config/run_metadata').
:- use_module('../config/testbench_profile').
:- use_module('../reporting/report_messages').

:- initialization(main, main).

/*
-----------------------------------------------------------
MG Testbench – Single Generator Diagnostic Runner
-----------------------------------------------------------

Purpose
-------
This runner executes one generator-only diagnostic case.

It is not a full validation pipeline. It does not compare parser and
generator outputs. Its purpose is to inspect whether the configured
generator can produce an output for one semantic input.

The runner uses the same generator adapter as the batch pipelines, so
timeout handling, error handling, no-solution handling, and output
extraction remain consistent with the full testbench.

Usage
-----
From the bidirectional/ directory:

    swipl -q -f runners/single_generate.pl -- "'1X+20'(7)"

or through the Python runner later:

    python run_testbench.py --mode single_gen --semantic "'1X+20'(7)"
*/


main :-
    mg_logger:log_event(system, single_generate_run_start),
    log_run_configuration,

    current_prolog_flag(argv, Args),
    read_semantic_argument(Args, SemanticInput),

    testbench_profile:generator_main_file(GeneratorMainFile),
    consult(GeneratorMainFile),

    % Testbench-local generator adapter.
    consult('../adapters/generator_adapter.pl'),

    run_single_generate_case(SemanticInput, GenStatus, Tokens, Sent, Tree),

    run_metadata:single_generate_report_file(ReportFile),
    open(ReportFile, write, S),
    write_single_generate_report(
        S,
        SemanticInput,
        GenStatus,
        Tokens,
        Sent,
        Tree
    ),
    close(S),

    write_single_generate_report(
        user_output,
        SemanticInput,
        GenStatus,
        Tokens,
        Sent,
        Tree
    ),

    mg_logger:log_event(
        single_generate_session,
        single_generate_case(
            semantic_input(SemanticInput),
            generation_status(GenStatus),
            generated_tokens(Tokens)
        )
    ),

    mg_logger:log_event(system, single_generate_run_end),
    halt.


% =============================================================================
% Configuration logging
% =============================================================================

log_run_configuration :-
    testbench_profile:profile_name(ProfileName),
    testbench_profile:generator_name(GeneratorName),
    testbench_profile:generator_main_file(GeneratorMainFile),
    testbench_profile:generator_wrapper_file(GeneratorWrapperFile),
    testbench_profile:generator_lexicon_name(GeneratorLexiconName),
    testbench_profile:generator_lexicon_file(GeneratorLexiconFile),

    testbench_profile:smoothing_enabled(Smoothing),
    testbench_profile:smoothing_style(Style),
    testbench_profile:adapter_timeout_seconds(AdapterTimeoutSeconds),

    run_metadata:single_generate_report_file(ReportFile),

    mg_logger:log_event(
        configuration,
        single_generate_run(
            profile_name(ProfileName),
            generator_name(GeneratorName),
            generator_main_file(GeneratorMainFile),
            generator_wrapper_file(GeneratorWrapperFile),
            generator_lexicon_name(GeneratorLexiconName),
            generator_lexicon_file(GeneratorLexiconFile),
            report_file(ReportFile),
            token_normalization_enabled(Smoothing),
            token_normalization_style(Style),
            adapter_timeout_seconds(AdapterTimeoutSeconds)
        )
    ),

    format(
        "~n[single_generate] profile=~q generator=~q generator_main=~q generator_wrapper=~q generator_lexicon=~q report=~q token_normalization=~q style=~q timeout_seconds=~q~n",
        [
            ProfileName,
            GeneratorName,
            GeneratorMainFile,
            GeneratorWrapperFile,
            GeneratorLexiconName,
            ReportFile,
            Smoothing,
            Style,
            AdapterTimeoutSeconds
        ]
    ).


% =============================================================================
% Command-line argument handling
% =============================================================================

read_semantic_argument([SemanticString | _], SemanticInput) :-
    !,
    term_string(SemanticInput, SemanticString).

read_semantic_argument([], _) :-
    format(user_error, "ERROR: Missing semantic input argument.~n", []),
    format(user_error, "Example: swipl -q -f runners/single_generate.pl -- \"'1X+20'(7)\"~n", []),
    halt(2).


% =============================================================================
% Single generator execution
% =============================================================================

run_single_generate_case(SemanticInput, GenStatus, Tokens, Sent, Tree) :-
    catch(
        (
            mg_generate_wrapper:generate_safe(SemanticInput, _AdapterSent, _Lambda, Tree0, Status0),
            extract_words(Tree0, Tokens0),
            tokens_to_sentence(Tokens0, Sent),
            normalize_gen_status(Status0, Tokens0, GenStatus),
            Tokens = Tokens0,
            Tree = Tree0
        ),
        E,
        handle_generation_exception(E, GenStatus, Tokens, Sent, Tree)
    ).

handle_generation_exception(time_limit_exceeded, generation_timeout, [], '', none) :- !.
handle_generation_exception(E, error(E), [], '', none).

normalize_gen_status(timeout, _, generation_timeout) :- !.
normalize_gen_status(no_solution, _, gen_empty_yield) :- !.
normalize_gen_status(ok, [], gen_empty_yield) :- !.
normalize_gen_status(ok, [_ | _], ok) :- !.
normalize_gen_status(Status, _, Status).

tokens_to_sentence(Tokens, SentenceAtom) :-
    is_list(Tokens),
    atomic_list_concat(Tokens, '', SentenceAtom),
    !.

tokens_to_sentence(_, '').


% =============================================================================
% Token extraction from generated structure
% =============================================================================

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


% =============================================================================
% Report output
% =============================================================================

write_single_generate_report(S, SemanticInput, GenStatus, Tokens, _Sent, Tree) :-
    report_messages:report_text(single_generator_diagnostic_report, ReportTitle),
    report_messages:report_text(semantic_input, SemanticInputLabel),
    report_messages:report_text(generation_status, GenerationStatusLabel),
    report_messages:report_text(generated_tokens, GeneratedTokensLabel),
    report_messages:report_text(generation_tree, GenerationTreeLabel),

    format(S, "==================================================~n", []),
    format(S, "~w~n", [ReportTitle]),
    format(S, "==================================================~n", []),
    format(S, "~w: ~q~n", [SemanticInputLabel, SemanticInput]),
    format(S, "~w: ~q~n", [GenerationStatusLabel, GenStatus]),
    format(S, "~w: ~q~n", [GeneratedTokensLabel, Tokens]),
    format(S, "~w:~n", [GenerationTreeLabel]),
    write_term(S, Tree, [quoted(true), portray(true), max_depth(0)]),
    format(S, "~n==================================================~n~n", []).