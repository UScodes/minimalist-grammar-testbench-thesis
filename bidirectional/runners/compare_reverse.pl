:- use_module('../config/run_metadata').
:- use_module('../config/testbench_profile').

:- initialization(main, main).

main :-
    run_metadata:reverse_out_file(ReverseOutFile),
    consult(ReverseOutFile),

    run_metadata:reverse_report_file(ReportFile),
    open(ReportFile, write, S),

    write_report_header(S),

    findall(
        result(VerdictKey, FailureStageKey, FailureReasonKey),
        (
            reverse_case(
                InputTokens,
                ParseStatus,
                ParsedSem,
                GenStatus,
                RawGenTokens,
                NormalizedGenTokens,
                Sent
            ),
            classify_case(
                InputTokens,
                ParseStatus,
                ParsedSem,
                GenStatus,
                RawGenTokens,
                NormalizedGenTokens,
                Sent,
                VerdictKey,
                FailureStageKey,
                FailureReasonKey
            ),
            write_case_line(
                S,
                InputTokens,
                ParseStatus,
                ParsedSem,
                GenStatus,
                RawGenTokens,
                NormalizedGenTokens,
                Sent,
                VerdictKey,
                FailureStageKey,
                FailureReasonKey
            )
        ),
        Results
    ),

    summarize_results(S, Results),
    close(S),
    halt.

write_report_header(S) :-
    testbench_profile:profile_name(ProfileName),
    testbench_profile:validation_pipeline_parse_gen(PipelineName),

    testbench_profile:generator_name(GeneratorName),
    testbench_profile:parser_name(ParserName),

    testbench_profile:generator_main_file(GeneratorMainFile),
    testbench_profile:parser_load_file(ParserLoadFile),
    testbench_profile:parser_semantics_file(ParserSemanticsFile),

    testbench_profile:generator_lexicon_name(GeneratorLexiconName),
    testbench_profile:parser_lexicon_name(ParserLexiconName),
    testbench_profile:generator_lexicon_file(GeneratorLexiconFile),
    testbench_profile:parser_lexicon_file(ParserLexiconFile),

    testbench_profile:repair_enabled(RepairEnabled0),
    testbench_profile:smoothing_enabled(SmoothingEnabled0),
    testbench_profile:smoothing_style(SmoothingStyle),

    yes_no(RepairEnabled0, RepairEnabled),
    yes_no(SmoothingEnabled0, SmoothingEnabled),

    testbench_profile:token_cases_file(TokenCasesFile),
    run_metadata:reverse_parse_out_file(ReverseParseOutFile),
    run_metadata:reverse_out_file(ReverseOutFile),
    run_metadata:reverse_parse_tree_report_file(ParseTreeFile),
    run_metadata:reverse_gen_tree_report_file(GenTreeFile),

    format(S, "==================================================~n", []),
    format(S, "Validation Report: ~w~n", [PipelineName]),
    format(S, "==================================================~n", []),
    format(S, "Profile Name: ~w~n", [ProfileName]),
    format(S, "Generator: ~w~n", [GeneratorName]),
    format(S, "Parser: ~w~n", [ParserName]),
    format(S, "Generator Main File: ~w~n", [GeneratorMainFile]),
    format(S, "Parser Load File: ~w~n", [ParserLoadFile]),
    format(S, "Parser Semantics File: ~w~n", [ParserSemanticsFile]),
    format(S, "Generator Lexicon: ~w~n", [GeneratorLexiconName]),
    format(S, "Parser Lexicon: ~w~n", [ParserLexiconName]),
    format(S, "Generator Lexicon File: ~w~n", [GeneratorLexiconFile]),
    format(S, "Parser Lexicon File: ~w~n", [ParserLexiconFile]),
    format(S, "Repair Enabled: ~w~n", [RepairEnabled]),
    format(S, "Smoothing Enabled: ~w~n", [SmoothingEnabled]),
    format(S, "Smoothing Style: ~w~n", [SmoothingStyle]),
    format(S, "Token Case File: ~w~n", [TokenCasesFile]),
    format(S, "Reverse Parsing Output File: ~w~n", [ReverseParseOutFile]),
    format(S, "Reverse Generation Output File: ~w~n", [ReverseOutFile]),
    format(S, "Reverse Parsing Tree Report: ~w~n", [ParseTreeFile]),
    format(S, "Reverse Generation Tree Report: ~w~n", [GenTreeFile]),
    format(S, "==================================================~n~n", []).

yes_no(true, 'Yes').
yes_no(false, 'No').

classify_case(
    InputTokens,
    ParseStatus,
    _ParsedSem,
    GenStatus,
    _RawGenTokens,
    NormalizedGenTokens,
    _Sent,
    VerdictKey,
    FailureStageKey,
    FailureReasonKey
) :-
    (
        ParseStatus = parse_skipped_empty_tokens ->
            VerdictKey = parsing_skipped,
            FailureStageKey = parsing,
            FailureReasonKey = no_tokens_available_for_parsing
    ;   ParseStatus = parse_fail ->
            VerdictKey = parsing_failed,
            FailureStageKey = parsing,
            FailureReasonKey = parser_could_not_derive_valid_parse
    ;   GenStatus = generation_not_attempted ->
            VerdictKey = generation_not_attempted,
            FailureStageKey = generation,
            FailureReasonKey = generation_not_attempted_due_to_parse_failure
    ;   GenStatus = generation_timeout ->
            VerdictKey = generation_timed_out,
            FailureStageKey = generation,
            FailureReasonKey = generation_exceeded_time_limit
    ;   GenStatus = error(time_limit_exceeded) ->
            VerdictKey = generation_timed_out,
            FailureStageKey = generation,
            FailureReasonKey = generation_exceeded_time_limit
    ;   GenStatus = error(E) ->
            VerdictKey = generation_failed,
            FailureStageKey = generation,
            FailureReasonKey = generator_error(E)
    ;   GenStatus = gen_empty_yield ->
            VerdictKey = no_surface_form_generated,
            FailureStageKey = generation,
            FailureReasonKey = generator_returned_empty_token_yield
    ;   NormalizedGenTokens == InputTokens ->
            VerdictKey = validation_passed,
            FailureStageKey = none,
            FailureReasonKey = none
    ;   VerdictKey = token_roundtrip_mismatch,
        FailureStageKey = token_comparison,
        FailureReasonKey = regenerated_tokens_differ_from_original_input(InputTokens, NormalizedGenTokens)
    ).

write_case_line(
    S,
    InputTokens,
    ParseStatus,
    ParsedSem,
    GenStatus,
    RawGenTokens,
    NormalizedGenTokens,
    Sent,
    VerdictKey,
    FailureStageKey,
    FailureReasonKey
) :-
    verdict_label(VerdictKey, VerdictLabel),
    failure_stage_label(FailureStageKey, FailureStageLabel),
    failure_reason_label(FailureReasonKey, FailureReasonLabel),

    format(S, "Case Result: ~w~n", [VerdictLabel]),
    format(S, "Failure Stage: ~w~n", [FailureStageLabel]),
    format(S, "Failure Reason: ~w~n", [FailureReasonLabel]),
    format(S, "Original Token Input: ~q~n", [InputTokens]),
    format(S, "Parsing Status: ~q~n", [ParseStatus]),
    format(S, "Parsed Semantic Output: ~q~n", [ParsedSem]),
    format(S, "Generation Status: ~q~n", [GenStatus]),
    format(S, "Raw Generated Tokens: ~q~n", [RawGenTokens]),
    format(S, "Normalized Generated Tokens: ~q~n", [NormalizedGenTokens]),
    format(S, "Generated Sentence: ~q~n", [Sent]),
    format(S, "--------------------------------------------------~n", []).

summarize_results(S, Results) :-
    length(Results, Total),
    count_verdict(Results, validation_passed, Passed),
    count_verdict(Results, generation_not_attempted, GenerationNotAttempted),
    count_verdict(Results, generation_timed_out, GenerationTimedOut),
    count_verdict(Results, generation_failed, GenerationFailed),
    count_verdict(Results, no_surface_form_generated, NoSurfaceFormGenerated),
    count_verdict(Results, parsing_skipped, ParsingSkipped),
    count_verdict(Results, parsing_failed, ParsingFailed),
    count_verdict(Results, token_roundtrip_mismatch, TokenMismatch),

    nl(S),
    format(S, "================ Validation Summary ================~n", []),
    format(S, "Total Cases: ~d~n", [Total]),
    format(S, "Validation Passed: ~d~n", [Passed]),
    format(S, "Generation Not Attempted: ~d~n", [GenerationNotAttempted]),
    format(S, "Generation Timed Out: ~d~n", [GenerationTimedOut]),
    format(S, "Generation Failed: ~d~n", [GenerationFailed]),
    format(S, "No Surface Form Generated: ~d~n", [NoSurfaceFormGenerated]),
    format(S, "Parsing Skipped: ~d~n", [ParsingSkipped]),
    format(S, "Parsing Failed: ~d~n", [ParsingFailed]),
    format(S, "Token Roundtrip Mismatch: ~d~n", [TokenMismatch]),

    nl(S),
    summarize_failure_stages(S, Results).

summarize_failure_stages(S, Results) :-
    count_stage(Results, none, NoneCount),
    count_stage(Results, generation, GenerationCount),
    count_stage(Results, parsing, ParsingCount),
    count_stage(Results, token_comparison, TokenComparisonCount),

    format(S, "================ Failure Stage Summary ==============~n", []),
    format(S, "No Failure Stage: ~d~n", [NoneCount]),
    format(S, "Generation: ~d~n", [GenerationCount]),
    format(S, "Parsing: ~d~n", [ParsingCount]),
    format(S, "Token Comparison: ~d~n", [TokenComparisonCount]).

count_verdict(Results, Verdict, Count) :-
    include(has_verdict(Verdict), Results, Matches),
    length(Matches, Count).

count_stage(Results, Stage, Count) :-
    include(has_stage(Stage), Results, Matches),
    length(Matches, Count).

has_verdict(Verdict, result(Verdict, _, _)).
has_stage(Stage, result(_, Stage, _)).

verdict_label(validation_passed, 'Validation Passed').
verdict_label(generation_not_attempted, 'Generation Not Attempted').
verdict_label(generation_timed_out, 'Generation Timed Out').
verdict_label(generation_failed, 'Generation Failed').
verdict_label(no_surface_form_generated, 'Generation Produced No Surface Form').
verdict_label(parsing_skipped, 'Parsing Skipped').
verdict_label(parsing_failed, 'Parsing Failed').
verdict_label(token_roundtrip_mismatch, 'Token Roundtrip Mismatch').

failure_stage_label(none, 'None').
failure_stage_label(generation, 'Generation').
failure_stage_label(parsing, 'Parsing').
failure_stage_label(token_comparison, 'Token Comparison').

failure_reason_label(none, 'None').
failure_reason_label(generation_not_attempted_due_to_parse_failure, 'Generation was not attempted because parsing did not succeed').
failure_reason_label(generation_exceeded_time_limit, 'Generation exceeded the time limit for this test case').
failure_reason_label(generator_returned_empty_token_yield, 'Generator returned an empty token yield').
failure_reason_label(no_tokens_available_for_parsing, 'Parsing was skipped because no tokens were available').
failure_reason_label(parser_could_not_derive_valid_parse, 'Parser could not derive a valid parse for the token sequence').
failure_reason_label(regenerated_tokens_differ_from_original_input(Expected, Actual), Label) :-
    format(atom(Label), 'Regenerated tokens differed from the original token input: expected ~q but got ~q', [Expected, Actual]).
failure_reason_label(generator_error(E), Label) :-
    format(atom(Label), 'Generator raised an error: ~q', [E]).