:- use_module('../config/run_metadata').
:- use_module('../config/testbench_profile').

:- initialization(main, main).

main :-
    run_metadata:parse_out_file(ParseOutFile),
    consult(ParseOutFile),

    run_metadata:bidir_report_file(ReportFile),
    open(ReportFile, write, S),

    write_report_header(S),

    findall(
        result(VerdictKey, FailureStageKey, FailureReasonKey),
        (
            bidir_case(Sem, GenStatus, GenTokens, RepairedTokens, ParserTokens, ParseStatus, ParsedSem),
            classify_case(
                Sem,
                GenStatus,
                GenTokens,
                RepairedTokens,
                ParserTokens,
                ParseStatus,
                ParsedSem,
                VerdictKey,
                FailureStageKey,
                FailureReasonKey
            ),
            write_case_line(
                S,
                Sem,
                GenStatus,
                GenTokens,
                RepairedTokens,
                ParserTokens,
                ParseStatus,
                ParsedSem,
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
    testbench_profile:validation_pipeline_gen_parse(PipelineName),

    testbench_profile:generator_name(GeneratorName),
    testbench_profile:parser_name(ParserName),

    testbench_profile:generator_main_file(GeneratorMainFile),
    testbench_profile:generator_wrapper_file(GeneratorWrapperFile),

    testbench_profile:parser_load_file(ParserLoadFile),
    testbench_profile:parser_semantics_source(ParserSemanticsSource),
    testbench_profile:parser_wrapper_file(ParserWrapperFile),

    testbench_profile:generator_lexicon_name(GeneratorLexiconName),
    testbench_profile:parser_lexicon_name(ParserLexiconName),
    testbench_profile:generator_lexicon_file(GeneratorLexiconFile),
    testbench_profile:parser_lexicon_file(ParserLexiconFile),

    testbench_profile:repair_enabled(RepairEnabled0),
    testbench_profile:smoothing_enabled(SmoothingEnabled0),
    testbench_profile:smoothing_style(SmoothingStyle),

    yes_no(RepairEnabled0, RepairEnabled),
    yes_no(SmoothingEnabled0, SmoothingEnabled),

    testbench_profile:semantic_cases_file(SemanticCasesFile),
    run_metadata:gen_out_file(GenOutFile),
    run_metadata:parse_out_file(ParseOutFile),
    run_metadata:forward_gen_tree_report_file(GenTreeFile),
    run_metadata:forward_parse_tree_report_file(ParseTreeFile),

    format(S, "==================================================~n", []),
    format(S, "Validation Report: ~w~n", [PipelineName]),
    format(S, "==================================================~n", []),
    format(S, "Profile Name: ~w~n", [ProfileName]),
    format(S, "Generator: ~w~n", [GeneratorName]),
    format(S, "Parser: ~w~n", [ParserName]),
    format(S, "Generator Main File: ~w~n", [GeneratorMainFile]),
    format(S, "Generator Wrapper File: ~w~n", [GeneratorWrapperFile]),
    format(S, "Parser Load File: ~w~n", [ParserLoadFile]),
    format(S, "Parser Semantics Source: ~w~n", [ParserSemanticsSource]),
    format(S, "Parser Wrapper File: ~w~n", [ParserWrapperFile]),
    format(S, "Generator Lexicon: ~w~n", [GeneratorLexiconName]),
    format(S, "Parser Lexicon: ~w~n", [ParserLexiconName]),
    format(S, "Generator Lexicon File: ~w~n", [GeneratorLexiconFile]),
    format(S, "Parser Lexicon File: ~w~n", [ParserLexiconFile]),
    format(S, "Repair Enabled: ~w~n", [RepairEnabled]),
    format(S, "Smoothing Enabled: ~w~n", [SmoothingEnabled]),
    format(S, "Smoothing Style: ~w~n", [SmoothingStyle]),
    format(S, "Semantic Case File: ~w~n", [SemanticCasesFile]),
    format(S, "Generation Output File: ~w~n", [GenOutFile]),
    format(S, "Parsing Output File: ~w~n", [ParseOutFile]),
    format(S, "Generation Tree Report: ~w~n", [GenTreeFile]),
    format(S, "Parsing Tree Report: ~w~n", [ParseTreeFile]),
    format(S, "==================================================~n~n", []).

yes_no(true, 'Yes').
yes_no(false, 'No').

classify_case(
    Sem,
    GenStatus,
    _GenTokens,
    _RepairedTokens,
    _ParserTokens,
    ParseStatus,
    ParsedSem,
    VerdictKey,
    FailureStageKey,
    FailureReasonKey
) :-
    (
        GenStatus = generation_timeout ->
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
    ;   ParseStatus = parse_skipped_empty_tokens ->
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
    ;   ParsedSem == Sem ->
            VerdictKey = validation_passed,
            FailureStageKey = none,
            FailureReasonKey = none
    ;   VerdictKey = semantic_roundtrip_mismatch,
        FailureStageKey = semantic_comparison,
        FailureReasonKey = parsed_semantics_differ_from_original_input(Sem, ParsedSem)
    ).

write_case_line(
    S,
    Sem,
    GenStatus,
    GenTokens,
    RepairedTokens,
    ParserTokens,
    ParseStatus,
    ParsedSem,
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
    format(S, "Original Semantic Input: ~q~n", [Sem]),
    format(S, "Generation Status: ~q~n", [GenStatus]),
    format(S, "Generated Tokens: ~q~n", [GenTokens]),
    write_repair_fields_if_relevant(S, GenTokens, RepairedTokens),
    format(S, "Parser Tokens: ~q~n", [ParserTokens]),
    format(S, "Parsing Status: ~q~n", [ParseStatus]),
    format(S, "Parsed Semantic Output: ~q~n", [ParsedSem]),
    format(S, "--------------------------------------------------~n", []).

write_repair_fields_if_relevant(S, GenTokens, RepairedTokens) :-
    testbench_profile:repair_enabled(true),
    !,
    format(S, "Repaired Tokens: ~q~n", [RepairedTokens]),
    write_repair_status(S, GenTokens, RepairedTokens).

write_repair_fields_if_relevant(_, _, _).

write_repair_status(S, GenTokens, RepairedTokens) :-
    (   RepairedTokens \== GenTokens
    ->  format(S, "Repair Status: applied~n", [])
    ;   format(S, "Repair Status: not applied~n", [])
    ).

summarize_results(S, Results) :-
    length(Results, Total),
    count_verdict(Results, validation_passed, Passed),
    count_verdict(Results, generation_timed_out, GenerationTimedOut),
    count_verdict(Results, generation_failed, GenerationFailed),
    count_verdict(Results, no_surface_form_generated, NoSurfaceFormGenerated),
    count_verdict(Results, parsing_skipped, ParsingSkipped),
    count_verdict(Results, parsing_timed_out, ParsingTimedOut),
    count_verdict(Results, parsing_failed, ParsingFailed),
    count_verdict(Results, semantic_roundtrip_mismatch, SemanticMismatch),

    nl(S),
    format(S, "================ Validation Summary ================~n", []),
    format(S, "Total Cases: ~d~n", [Total]),
    format(S, "Validation Passed: ~d~n", [Passed]),
    format(S, "Generation Timed Out: ~d~n", [GenerationTimedOut]),
    format(S, "Generation Failed: ~d~n", [GenerationFailed]),
    format(S, "No Surface Form Generated: ~d~n", [NoSurfaceFormGenerated]),
    format(S, "Parsing Skipped: ~d~n", [ParsingSkipped]),
    format(S, "Parsing Timed Out: ~d~n", [ParsingTimedOut]),
    format(S, "Parsing Failed: ~d~n", [ParsingFailed]),
    format(S, "Semantic Roundtrip Mismatch: ~d~n", [SemanticMismatch]),

    nl(S),
    summarize_failure_stages(S, Results).

summarize_failure_stages(S, Results) :-
    count_stage(Results, none, NoneCount),
    count_stage(Results, generation, GenerationCount),
    count_stage(Results, parsing, ParsingCount),
    count_stage(Results, semantic_comparison, SemanticComparisonCount),

    format(S, "================ Failure Stage Summary ==============~n", []),
    format(S, "No Failure Stage: ~d~n", [NoneCount]),
    format(S, "Generation: ~d~n", [GenerationCount]),
    format(S, "Parsing: ~d~n", [ParsingCount]),
    format(S, "Semantic Comparison: ~d~n", [SemanticComparisonCount]).

count_verdict(Results, Verdict, Count) :-
    include(has_verdict(Verdict), Results, Matches),
    length(Matches, Count).

count_stage(Results, Stage, Count) :-
    include(has_stage(Stage), Results, Matches),
    length(Matches, Count).

has_verdict(Verdict, result(Verdict, _, _)).
has_stage(Stage, result(_, Stage, _)).

verdict_label(validation_passed, 'Validation Passed').
verdict_label(generation_timed_out, 'Generation Timed Out').
verdict_label(generation_failed, 'Generation Failed').
verdict_label(no_surface_form_generated, 'Generation Produced No Surface Form').
verdict_label(parsing_skipped, 'Parsing Skipped').
verdict_label(parsing_timed_out, 'Parsing Timed Out').
verdict_label(parsing_failed, 'Parsing Failed').
verdict_label(semantic_roundtrip_mismatch, 'Semantic Roundtrip Mismatch').

failure_stage_label(none, 'None').
failure_stage_label(generation, 'Generation').
failure_stage_label(parsing, 'Parsing').
failure_stage_label(semantic_comparison, 'Semantic Comparison').

failure_reason_label(none, 'None').
failure_reason_label(generation_exceeded_time_limit, 'Generation exceeded the time limit for this test case').
failure_reason_label(generator_returned_empty_token_yield, 'Generator returned an empty token yield').
failure_reason_label(no_tokens_available_for_parsing, 'Parsing was skipped because no tokens were available').
failure_reason_label(parsing_exceeded_time_limit, 'Parsing exceeded the time limit for this test case').
failure_reason_label(parser_could_not_derive_valid_parse, 'Parser could not derive a valid parse for the token sequence').

failure_reason_label(parsed_semantics_differ_from_original_input(Expected, Actual), Label) :-
    format(atom(Label), 'Parsed semantics differed from the original semantic input: expected ~q but got ~q', [Expected, Actual]).

failure_reason_label(generator_error(E), Label) :-
    format(atom(Label), 'Generator raised an error: ~q', [E]).

failure_reason_label(parser_error(E), Label) :-
    format(atom(Label), 'Parser raised an error: ~q', [E]).