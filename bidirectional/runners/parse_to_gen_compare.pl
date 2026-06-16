:- use_module('../config/run_metadata').
:- use_module('../config/testbench_profile').
:- use_module('../reporting/report_messages').

:- initialization(main, main).

main :-
    run_metadata:reverse_out_file(GenerationOutFile),
    consult(GenerationOutFile),

    run_metadata:reverse_report_file(ReportFile),
    open(ReportFile, write, S),

    write_report_header(S),

    findall(
        result(CaseId, VerdictKey, FailureStageKey, FailureReasonKey),
        (
            parse_to_gen_generation_case(
                CaseId,
                InputTokens,
                ParseStatus,
                ParsedSem,
                GenStatus,
                RawGenTokens,
                NormalizedGenTokens,
                _Sent
            ),
            classify_case(
                InputTokens,
                ParseStatus,
                ParsedSem,
                GenStatus,
                RawGenTokens,
                NormalizedGenTokens,
                VerdictKey,
                FailureStageKey,
                FailureReasonKey
            ),
            write_case_line(
                S,
                CaseId,
                InputTokens,
                ParseStatus,
                ParsedSem,
                GenStatus,
                RawGenTokens,
                NormalizedGenTokens,
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
    testbench_profile:generator_wrapper_file(GeneratorWrapperFile),

    testbench_profile:parser_load_file(ParserLoadFile),
    testbench_profile:parser_wrapper_file(ParserWrapperFile),

    testbench_profile:generator_lexicon_name(GeneratorLexiconName),
    testbench_profile:parser_lexicon_name(ParserLexiconName),
    testbench_profile:generator_lexicon_file(GeneratorLexiconFile),
    testbench_profile:parser_lexicon_file(ParserLexiconFile),

    testbench_profile:smoothing_enabled(SmoothingEnabled0),
    testbench_profile:smoothing_style(SmoothingStyle),
    active_smoothing_rule_set(SmoothingRuleSet),
    testbench_profile:adapter_timeout_seconds(AdapterTimeoutSeconds),

    report_messages:yes_no_label(SmoothingEnabled0, TokenNormalizationEnabled),

    testbench_profile:token_cases_file(TokenCasesFile),
    run_metadata:reverse_parse_out_file(ParseOutFile),
    run_metadata:reverse_out_file(GenerationOutFile),
    run_metadata:reverse_parse_tree_report_file(ParseTreeFile),
    run_metadata:reverse_gen_tree_report_file(GenTreeFile),

    report_messages:report_text(parse_to_gen_report_title, ReportTitle),
    report_messages:report_text(profile, ProfileLabel),
    report_messages:report_text(pipeline, PipelineLabel),
    report_messages:report_text(parser_component, ParserComponentLabel),
    report_messages:report_text(generator_component, GeneratorComponentLabel),

    report_messages:report_text(parser_load_file, ParserLoadFileLabel),
    report_messages:report_text(parser_adapter_file, ParserAdapterFileLabel),
    report_messages:report_text(generator_main_file, GeneratorMainFileLabel),
    report_messages:report_text(generator_adapter_file, GeneratorAdapterFileLabel),

    report_messages:report_text(parser_lexicon, ParserLexiconLabel),
    report_messages:report_text(generator_lexicon, GeneratorLexiconLabel),
    report_messages:report_text(parser_lexicon_file, ParserLexiconFileLabel),
    report_messages:report_text(generator_lexicon_file, GeneratorLexiconFileLabel),
    report_messages:report_text(token_test_case_file, TokenTestCaseFileLabel),

    report_messages:report_text(token_normalization_enabled, TokenNormalizationEnabledLabel),
    report_messages:report_text(token_normalization_style, TokenNormalizationStyleLabel),
    report_messages:report_text(token_normalization_rule_set, TokenNormalizationRuleSetLabel),
    report_messages:report_text(token_normalization_dispatcher, TokenNormalizationDispatcherLabel),
    report_messages:report_text(adapter_timeout, AdapterTimeoutLabel),
    report_messages:report_text(seconds, SecondsLabel),

    report_messages:report_text(parsing_stage_output_file, ParsingStageOutputFileLabel),
    report_messages:report_text(generation_stage_output_file, GenerationStageOutputFileLabel),
    report_messages:report_text(parsing_tree_report, ParsingTreeReportLabel),
    report_messages:report_text(generation_tree_report, GenerationTreeReportLabel),

    format(S, "==================================================~n", []),
    format(S, "~w~n", [ReportTitle]),
    format(S, "==================================================~n", []),
    format(S, "~w: ~w~n", [ProfileLabel, ProfileName]),
    format(S, "~w: ~w~n", [PipelineLabel, PipelineName]),
    format(S, "~w: ~w~n", [ParserComponentLabel, ParserName]),
    format(S, "~w: ~w~n", [GeneratorComponentLabel, GeneratorName]),
    format(S, "~n", []),

    format(S, "~w: ~w~n", [ParserLoadFileLabel, ParserLoadFile]),
    format(S, "~w: ~w~n", [ParserAdapterFileLabel, ParserWrapperFile]),
    format(S, "~w: ~w~n", [GeneratorMainFileLabel, GeneratorMainFile]),
    format(S, "~w: ~w~n", [GeneratorAdapterFileLabel, GeneratorWrapperFile]),
    format(S, "~n", []),

    format(S, "~w: ~w~n", [ParserLexiconLabel, ParserLexiconName]),
    format(S, "~w: ~w~n", [GeneratorLexiconLabel, GeneratorLexiconName]),
    format(S, "~w: ~w~n", [ParserLexiconFileLabel, ParserLexiconFile]),
    format(S, "~w: ~w~n", [GeneratorLexiconFileLabel, GeneratorLexiconFile]),
    format(S, "~w: ~w~n", [TokenTestCaseFileLabel, TokenCasesFile]),
    format(S, "~n", []),

    format(S, "~w: ~w~n", [TokenNormalizationEnabledLabel, TokenNormalizationEnabled]),
    format(S, "~w: ~w~n", [TokenNormalizationStyleLabel, SmoothingStyle]),
    format(S, "~w: ~w~n", [TokenNormalizationRuleSetLabel, SmoothingRuleSet]),
    format(S, "~w: normalization_rule_dispatcher~n", [TokenNormalizationDispatcherLabel]),
    format(S, "~w: ~w ~w~n", [AdapterTimeoutLabel, AdapterTimeoutSeconds, SecondsLabel]),
    format(S, "~n", []),

    format(S, "~w: ~w~n", [ParsingStageOutputFileLabel, ParseOutFile]),
    format(S, "~w: ~w~n", [GenerationStageOutputFileLabel, GenerationOutFile]),
    format(S, "~w: ~w~n", [ParsingTreeReportLabel, ParseTreeFile]),
    format(S, "~w: ~w~n", [GenerationTreeReportLabel, GenTreeFile]),
    format(S, "==================================================~n~n", []).


active_smoothing_rule_set(RuleSet) :-
    catch(testbench_profile:smoothing_rule_set(RuleSet), _, fail),
    !.

active_smoothing_rule_set(english).


classify_case(
    InputTokens,
    ParseStatus,
    _ParsedSem,
    GenStatus,
    _RawGenTokens,
    NormalizedGenTokens,
    VerdictKey,
    FailureStageKey,
    FailureReasonKey
) :-
    (
        ParseStatus = parse_skipped_empty_tokens ->
            VerdictKey = parsing_skipped,
            FailureStageKey = parsing,
            FailureReasonKey = no_tokens_available_for_parsing
    ;   ParseStatus = parse_timeout ->
            VerdictKey = parsing_timed_out,
            FailureStageKey = parsing,
            FailureReasonKey = parsing_exceeded_time_limit
    ;   ParseStatus = parser_error(E) ->
            VerdictKey = parsing_failed,
            FailureStageKey = parsing,
            FailureReasonKey = parser_error(E)
    ;   ParseStatus = parse_fail ->
            VerdictKey = parsing_failed,
            FailureStageKey = parsing,
            FailureReasonKey = parser_could_not_derive_valid_parse
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
    CaseId,
    InputTokens,
    ParseStatus,
    ParsedSem,
    GenStatus,
    RawGenTokens,
    NormalizedGenTokens,
    VerdictKey,
    FailureStageKey,
    FailureReasonKey
) :-
    report_messages:verdict_label(VerdictKey, VerdictLabel),
    report_messages:failure_stage_label(FailureStageKey, FailureStageLabel),
    report_messages:failure_reason_label(FailureReasonKey, FailureReasonLabel),

    report_messages:report_text(case_id, CaseIdLabel),
    report_messages:report_text(validation_result, ValidationResultLabel),
    report_messages:report_text(failure_stage, FailureStageTextLabel),
    report_messages:report_text(diagnostic_reason, DiagnosticReasonLabel),

    report_messages:report_text(input, InputLabel),
    report_messages:report_text(token_input, TokenInputLabel),

    report_messages:report_text(parsing_stage, ParsingStageLabel),
    report_messages:report_text(parsing_status, ParsingStatusLabel),
    report_messages:report_text(recovered_semantic_output, RecoveredSemanticOutputLabel),

    report_messages:report_text(generation_stage, GenerationStageLabel),
    report_messages:report_text(generation_status, GenerationStatusLabel),
    report_messages:report_text(generated_tokens, GeneratedTokensLabel),

    report_messages:report_text(interface_preparation, InterfacePreparationLabel),
    report_messages:report_text(tokens_after_normalization, TokensAfterNormalizationLabel),

    format(S, "~w: ~q~n", [CaseIdLabel, CaseId]),
    format(S, "~w: ~w~n", [ValidationResultLabel, VerdictLabel]),
    format(S, "~w: ~w~n", [FailureStageTextLabel, FailureStageLabel]),
    format(S, "~w: ~w~n", [DiagnosticReasonLabel, FailureReasonLabel]),
    format(S, "~n", []),

    format(S, "~w~n", [InputLabel]),
    format(S, "  ~w: ~q~n", [TokenInputLabel, InputTokens]),
    format(S, "~n", []),

    format(S, "~w~n", [ParsingStageLabel]),
    format(S, "  ~w: ~q~n", [ParsingStatusLabel, ParseStatus]),
    format(S, "  ~w: ~q~n", [RecoveredSemanticOutputLabel, ParsedSem]),
    format(S, "~n", []),

    format(S, "~w~n", [GenerationStageLabel]),
    format(S, "  ~w: ~q~n", [GenerationStatusLabel, GenStatus]),
    format(S, "  ~w: ~q~n", [GeneratedTokensLabel, RawGenTokens]),
    format(S, "~n", []),

    format(S, "~w~n", [InterfacePreparationLabel]),
    format(S, "  ~w: ~q~n", [TokensAfterNormalizationLabel, NormalizedGenTokens]),
    format(S, "--------------------------------------------------~n", []).


summarize_results(S, Results) :-
    length(Results, Total),
    count_verdict(Results, validation_passed, Passed),
    count_verdict(Results, generation_timed_out, GenerationTimedOut),
    count_verdict(Results, generation_failed, GenerationFailed),
    count_verdict(Results, no_surface_form_generated, NoSurfaceFormGenerated),
    count_verdict(Results, parsing_skipped, ParsingSkipped),
    count_verdict(Results, parsing_timed_out, ParsingTimedOut),
    count_verdict(Results, parsing_failed, ParsingFailed),
    count_verdict(Results, token_roundtrip_mismatch, TokenMismatch),

    report_messages:report_text(validation_summary, ValidationSummaryLabel),
    report_messages:report_text(total_cases, TotalCasesLabel),
    report_messages:report_text(validation_passed_count, ValidationPassedLabel),
    report_messages:report_text(generation_timed_out_count, GenerationTimedOutLabel),
    report_messages:report_text(generation_failed_count, GenerationFailedLabel),
    report_messages:report_text(no_surface_form_generated_count, NoSurfaceFormGeneratedLabel),
    report_messages:report_text(parsing_skipped_count, ParsingSkippedLabel),
    report_messages:report_text(parsing_timed_out_count, ParsingTimedOutLabel),
    report_messages:report_text(parsing_failed_count, ParsingFailedLabel),
    report_messages:report_text(token_roundtrip_mismatch_count, TokenMismatchLabel),

    nl(S),
    format(S, "================ ~w ================~n", [ValidationSummaryLabel]),
    format(S, "~w: ~d~n", [TotalCasesLabel, Total]),
    format(S, "~w: ~d~n", [ValidationPassedLabel, Passed]),
    format(S, "~w: ~d~n", [GenerationTimedOutLabel, GenerationTimedOut]),
    format(S, "~w: ~d~n", [GenerationFailedLabel, GenerationFailed]),
    format(S, "~w: ~d~n", [NoSurfaceFormGeneratedLabel, NoSurfaceFormGenerated]),
    format(S, "~w: ~d~n", [ParsingSkippedLabel, ParsingSkipped]),
    format(S, "~w: ~d~n", [ParsingTimedOutLabel, ParsingTimedOut]),
    format(S, "~w: ~d~n", [ParsingFailedLabel, ParsingFailed]),
    format(S, "~w: ~d~n", [TokenMismatchLabel, TokenMismatch]),

    nl(S),
    summarize_failure_stages(S, Results).


summarize_failure_stages(S, Results) :-
    count_stage(Results, none, NoneCount),
    count_stage(Results, generation, GenerationCount),
    count_stage(Results, parsing, ParsingCount),
    count_stage(Results, token_comparison, TokenComparisonCount),

    report_messages:report_text(failure_stage_summary, FailureStageSummaryLabel),
    report_messages:report_text(no_failure_stage, NoFailureStageLabel),
    report_messages:report_text(generation_count, GenerationCountLabel),
    report_messages:report_text(parsing_count, ParsingCountLabel),
    report_messages:report_text(token_comparison_count, TokenComparisonCountLabel),

    format(S, "================ ~w ==============~n", [FailureStageSummaryLabel]),
    format(S, "~w: ~d~n", [NoFailureStageLabel, NoneCount]),
    format(S, "~w: ~d~n", [GenerationCountLabel, GenerationCount]),
    format(S, "~w: ~d~n", [ParsingCountLabel, ParsingCount]),
    format(S, "~w: ~d~n", [TokenComparisonCountLabel, TokenComparisonCount]).


count_verdict(Results, Verdict, Count) :-
    include(has_verdict(Verdict), Results, Matches),
    length(Matches, Count).

count_stage(Results, Stage, Count) :-
    include(has_stage(Stage), Results, Matches),
    length(Matches, Count).

has_verdict(Verdict, result(_, Verdict, _, _)).
has_stage(Stage, result(_, _, Stage, _)).