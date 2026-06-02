:- use_module('../logging/testbench_logger').
:- use_module('../adapters/token_normalizer').
:- use_module('../config/run_metadata').
:- use_module('../config/testbench_profile').

:- initialization(main, main).

main :-
    mg_logger:log_event(system, parse_to_gen_generate_run_start),
    log_run_configuration,

    testbench_profile:generator_main_file(GeneratorMainFile),
    consult(GeneratorMainFile),

    % Testbench-local generator adapter.
    consult('../adapters/generator_adapter.pl'),

    run_metadata:reverse_parse_out_file(ParseOutFile),
    consult(ParseOutFile),

    run_metadata:reverse_out_file(GenerationOutFile),
    open(GenerationOutFile, write, S),

    run_metadata:reverse_gen_tree_report_file(GenerationTreeReportFile),
    open(GenerationTreeReportFile, write, TreeS),

    write_generation_output_header(S),

    forall(
        parse_to_gen_parsing_case(CaseId, InputTokens, ParseStatus, ParsedSem),
        (
            run_parse_to_gen_generation_case(
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
                "parse_to_gen_generation_case(~q, ~q, ~q, ~q, ~q, ~q, ~q, ~q).~n",
                [CaseId, InputTokens, ParseStatus, ParsedSem, GenStatus, RawGenTokens, NormalizedGenTokens, Sent]
            ),

            write_generation_tree_block(
                TreeS,
                CaseId,
                InputTokens,
                ParseStatus,
                ParsedSem,
                GenStatus,
                RawGenTokens,
                NormalizedGenTokens,
                Sent,
                Tree
            ),

            mg_logger:log_event(
                parse_to_gen_generation_session,
                parse_to_gen_generation_case(
                    case_id(CaseId),
                    token_input(InputTokens),
                    parsing_status(ParseStatus),
                    recovered_semantic_output(ParsedSem),
                    generation_status(GenStatus),
                    generated_tokens_before_normalization(RawGenTokens),
                    comparison_tokens(NormalizedGenTokens),
                    generated_sentence(Sent)
                )
            )
        )
    ),

    close(TreeS),
    close(S),
    mg_logger:log_event(system, parse_to_gen_generate_run_end),
    halt.

log_run_configuration :-
    testbench_profile:profile_name(ProfileName),
    testbench_profile:generator_name(GeneratorName),
    testbench_profile:generator_main_file(GeneratorMainFile),
    testbench_profile:generator_lexicon_name(GeneratorLexiconName),
    testbench_profile:generator_lexicon_file(GeneratorLexiconFile),

   
    testbench_profile:smoothing_enabled(Smoothing),
    testbench_profile:smoothing_style(Style),
    testbench_profile:adapter_timeout_seconds(AdapterTimeoutSeconds),

    run_metadata:reverse_parse_out_file(ParseOutFile),
    run_metadata:reverse_out_file(GenerationOutFile),
    run_metadata:reverse_gen_tree_report_file(GenerationTreeReportFile),

    mg_logger:log_event(
        configuration,
        parse_to_gen_generation_stage(
            profile_name(ProfileName),
            generator_name(GeneratorName),
            generator_main_file(GeneratorMainFile),
            generator_lexicon_name(GeneratorLexiconName),
            generator_lexicon_file(GeneratorLexiconFile),
            parsing_stage_output_file(ParseOutFile),
            generation_stage_output_file(GenerationOutFile),
            generation_tree_report_file(GenerationTreeReportFile),
           
            token_normalization_enabled(Smoothing),
            token_normalization_style(Style),
            adapter_timeout_seconds(AdapterTimeoutSeconds)
        )
    ),

    format(
        "~n[parse_to_gen_generation_stage] profile=~q generator=~q generator_main=~q generator_lexicon=~q parsing_output=~q generation_output=~q generation_tree_report=~q token_normalization=~q style=~q timeout_seconds=~q~n",
        [
            ProfileName,
            GeneratorName,
            GeneratorMainFile,
            GeneratorLexiconName,
            ParseOutFile,
            GenerationOutFile,
            GenerationTreeReportFile,
           
            Smoothing,
            Style,
            AdapterTimeoutSeconds
        ]
    ).

run_parse_to_gen_generation_case(_InputTokens, parse_fail, none, generation_not_attempted, [], [], '', none) :- !.
run_parse_to_gen_generation_case(_InputTokens, parse_timeout, none, generation_not_attempted, [], [], '', none) :- !.
run_parse_to_gen_generation_case(_InputTokens, parser_error(_), none, generation_not_attempted, [], [], '', none) :- !.
run_parse_to_gen_generation_case(_InputTokens, parse_skipped_empty_tokens, none, generation_not_attempted, [], [], '', none) :- !.

run_parse_to_gen_generation_case(_InputTokens, ok, ParsedSem, GenStatus, RawGenTokens, NormalizedGenTokens, Sent, Tree) :-
    catch(
        (
            mg_generate_wrapper:generate_safe(ParsedSem, _AdapterSent, _L, Tree0, Status0),
            extract_words(Tree0, RawGenTokens0),
            tokens_to_sentence(RawGenTokens0, Sent),
            normalize_gen_status(Status0, RawGenTokens0, GenStatus),
            RawGenTokens = RawGenTokens0,
            token_normalizer:normalize_gen_to_parser(RawGenTokens, NormalizedGenTokens),
            Tree = Tree0
        ),
        E,
        handle_generation_exception(E, GenStatus, RawGenTokens, NormalizedGenTokens, Sent, Tree)
    ).

handle_generation_exception(time_limit_exceeded, generation_timeout, [], [], '', none) :- !.
handle_generation_exception(E, error(E), [], [], '', none).

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

write_generation_output_header(S) :-
    format(S, "% =============================================================================~n", []),
    format(S, "% Parsing-to-Generation: Generation-stage Output~n", []),
    format(S, "% =============================================================================~n", []),
    format(S, "% Each fact has the form:~n", []),
    format(S, "%~n", []),
    format(S, "%   parse_to_gen_generation_case(CaseId, TokenInput, ParsingStatus, RecoveredSemanticOutput, GenerationStatus, GeneratedTokens, ComparisonTokens, GeneratedSentence).~n", []),
    format(S, "%~n", []),
    format(S, "% Meaning:~n", []),
    format(S, "%   CaseId                   - numeric identifier shared across all artifacts for the same test case~n", []),
    format(S, "%   TokenInput               - original token sequence used in the parsing stage~n", []),
    format(S, "%   ParsingStatus            - result of the parsing stage~n", []),
    format(S, "%   RecoveredSemanticOutput  - semantic representation recovered by the parser, or none if parsing failed~n", []),
    format(S, "%   GenerationStatus         - result of the generation stage, e.g. ok, gen_empty_yield, generation_timeout~n", []),
    format(S, "%   GeneratedTokens          - raw token sequence produced by the generator stage~n", []),
    format(S, "%   ComparisonTokens         - generated tokens after normalization; used for comparison with the original token input~n", []),
    format(S, "%   GeneratedSentence        - sentence atom derived from GeneratedTokens for report consistency~n", []),
    format(S, "% =============================================================================~n~n", []).

write_generation_tree_block(
    S,
    CaseId,
    InputTokens,
    ParseStatus,
    ParsedSem,
    GenStatus,
    RawGenTokens,
    NormalizedGenTokens,
    Sent,
    Tree
) :-
    format(S, "==================================================~n", []),
    format(S, "CASE ID: ~q~n", [CaseId]),
    format(S, "TOKEN INPUT: ~q~n", [InputTokens]),
    format(S, "PARSING STATUS: ~q~n", [ParseStatus]),
    format(S, "RECOVERED SEMANTIC OUTPUT: ~q~n", [ParsedSem]),
    format(S, "GENERATION STATUS: ~q~n", [GenStatus]),
    format(S, "GENERATED TOKENS: ~q~n", [RawGenTokens]),
    format(S, "COMPARISON TOKENS: ~q~n", [NormalizedGenTokens]),
    format(S, "GENERATED SENTENCE: ~q~n", [Sent]),
    format(S, "GENERATION TREE:~n", []),
    write_term(S, Tree, [quoted(true), portray(true), max_depth(0)]),
    format(S, "~n~n", []).