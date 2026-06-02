:- use_module('../logging/testbench_logger').
:- use_module('../config/run_metadata').
:- use_module('../config/testbench_profile').

:- initialization(main, main).

main :-
    mg_logger:log_event(system, gen_run_start),
    log_run_configuration,

    testbench_profile:generator_main_file(GeneratorMainFile),
    consult(GeneratorMainFile),

    % Testbench-local generator adapter.
    consult('../adapters/generator_adapter.pl'),

    testbench_profile:semantic_cases_file(TestCasesFile),
    consult(TestCasesFile),

    run_metadata:gen_out_file(GenOutFile),
    run_metadata:forward_gen_tree_report_file(TreeReportFile),

    findall(Sem, test_case(Sem), Tests),

    open(GenOutFile, write, GenS),
    open(TreeReportFile, write, TreeS),

    write_generation_output_header(GenS),

    forall(
        nth1(CaseId, Tests, Sem),
        (
            run_gen_case(Sem, GenStatus, Tokens, Sent, TreeTerm),
            format(
                GenS,
                "gen_to_parse_generation_case(~q, ~q, ~q, ~q, ~q).~n",
                [CaseId, Sem, GenStatus, Tokens, Sent]
            ),
            write_gen_tree_block(TreeS, CaseId, Sem, GenStatus, Tokens, Sent, TreeTerm),
            mg_logger:log_event(
                gen_session,
                gen_to_parse_generation_case(
                    case_id(CaseId),
                    semantic_input(Sem),
                    generation_status(GenStatus),
                    generated_tokens(Tokens),
                    generated_sentence(Sent)
                )
            )
        )
    ),

    close(GenS),
    close(TreeS),

    mg_logger:log_event(system, gen_run_end),
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
    testbench_profile:adapter_timeout_seconds(AdapterTimeoutSeconds),

    testbench_profile:semantic_cases_file(TestCasesFile),
    run_metadata:gen_out_file(GenOutFile),
    run_metadata:forward_gen_tree_report_file(TreeReportFile),

    mg_logger:log_event(
        configuration,
        gen_to_parse_generation_stage(
            profile_name(ProfileName),
            generator_name(GeneratorName),
            generator_main_file(GeneratorMainFile),
            generator_lexicon_name(GeneratorLexiconName),
            generator_lexicon_file(GeneratorLexiconFile),
            semantic_cases_file(TestCasesFile),
            generation_stage_output_file(GenOutFile),
            generation_tree_report_file(TreeReportFile),
            repair_enabled(Repair),
            token_normalization_enabled(Smoothing),
            token_normalization_style(Style),
            adapter_timeout_seconds(AdapterTimeoutSeconds)
        )
    ),

    format(
        "~n[gen_to_parse_generation_stage] profile=~q generator=~q generator_main=~q generator_lexicon=~q semantic_cases=~q generation_output=~q generation_tree_report=~q repair=~q token_normalization=~q style=~q timeout_seconds=~q~n",
        [
            ProfileName,
            GeneratorName,
            GeneratorMainFile,
            GeneratorLexiconName,
            TestCasesFile,
            GenOutFile,
            TreeReportFile,
            Repair,
            Smoothing,
            Style,
            AdapterTimeoutSeconds
        ]
    ).

run_gen_case(Sem, GenStatus, Tokens, Sent, TreeTerm) :-
    catch(
        (
            mg_generate_wrapper:generate_safe(Sem, _AdapterSent, _L, Tree0, Status0),
            extract_words(Tree0, Tokens0),
            tokens_to_sentence(Tokens0, Sent),
            normalize_gen_status(Status0, Tokens0, GenStatus),
            Tokens = Tokens0,
            TreeTerm = Tree0
        ),
        E,
        handle_gen_exception(E, GenStatus, Tokens, Sent, TreeTerm)
    ).

handle_gen_exception(time_limit_exceeded, generation_timeout, [], '', none) :- !.
handle_gen_exception(E, error(E), [], '', none).

normalize_gen_status(timeout, _, generation_timeout) :- !.
normalize_gen_status(no_solution, _, gen_empty_yield) :- !.
normalize_gen_status(ok, [], gen_empty_yield) :- !.
normalize_gen_status(ok, [_|_], ok) :- !.
normalize_gen_status(Status, _, Status).

tokens_to_sentence(Tokens, SentenceAtom) :-
    is_list(Tokens),
    atomic_list_concat(Tokens, '', SentenceAtom),
    !.

tokens_to_sentence(_, '').

/*
extract_words/2
---------------
Extracts the surface token list from a generated MG tree.

Important:
Generated trees may contain more than one chain at the root, for example:

    tree([([twenty],[c2],Sem), ([four],[-tee],4)], ...)

The old extractor only took the first chain and returned [twenty].
That lost mover-chain surface material such as [four]. The new extractor
collects words from all chains in the root annotation list.
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

write_generation_output_header(S) :-
    format(S, "% =============================================================================~n", []),
    format(S, "% Generation-to-Parsing: Generation-stage Output~n", []),
    format(S, "% =============================================================================~n", []),
    format(S, "% Each fact has the form:~n", []),
    format(S, "%~n", []),
    format(S, "%   gen_to_parse_generation_case(CaseId, SemanticInput, GenerationStatus, GeneratedTokens, GeneratedSentence).~n", []),
    format(S, "%~n", []),
    format(S, "% Meaning:~n", []),
    format(S, "%   CaseId             - numeric identifier shared across all artifacts for the same test case~n", []),
    format(S, "%   SemanticInput      - original semantic input sent to the generator~n", []),
    format(S, "%   GenerationStatus   - result of the generation stage, e.g. ok, gen_empty_yield, generation_timeout~n", []),
    format(S, "%   GeneratedTokens    - token sequence extracted from the generated structure~n", []),
    format(S, "%   GeneratedSentence  - sentence atom derived from GeneratedTokens for report consistency~n", []),
    format(S, "% =============================================================================~n~n", []).

write_gen_tree_block(S, CaseId, Sem, GenStatus, Tokens, Sent, TreeTerm) :-
    format(S, "==================================================~n", []),
    format(S, "CASE ID: ~q~n", [CaseId]),
    format(S, "SEMANTIC INPUT: ~q~n", [Sem]),
    format(S, "GENERATION STATUS: ~q~n", [GenStatus]),
    format(S, "GENERATED TOKENS: ~q~n", [Tokens]),
    format(S, "GENERATED SENTENCE: ~q~n", [Sent]),
    format(S, "GENERATION TREE:~n", []),
    write_term(S, TreeTerm, [quoted(true), portray(true), max_depth(0)]),
    format(S, "~n~n", []).