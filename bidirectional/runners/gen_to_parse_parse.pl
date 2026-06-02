:- use_module('../logging/testbench_logger').
:- use_module('../adapters/token_normalizer').
:- use_module('../adapters/repair_adapter').
:- use_module('../config/run_metadata').
:- use_module('../config/testbench_profile').

:- initialization(main, main).

main :-
    mg_logger:log_event(system, parse_run_start),
    log_run_configuration,

    testbench_profile:parser_load_file(ParserLoadFile),
    consult(ParserLoadFile),

    % Testbench-local parser adapter.
    % It uses the parser's internal semantic pipeline:
    % lcParse/2 -> workSpace/2 -> lappend/2 -> betaRoot/2
    consult('../adapters/parser_adapter.pl'),

    run_metadata:gen_out_file(GenOutFile),
    consult(GenOutFile),

    run_metadata:parse_out_file(ParseOutFile),
    run_metadata:forward_parse_tree_report_file(ParseTreeFile),

    open(ParseOutFile, write, ParseS),
    open(ParseTreeFile, write, TreeS),

    write_parsing_output_header(ParseS),

    forall(
        gen_to_parse_generation_case(CaseId, Sem, GenStatus, GenTokens, _Sent),
        (
            maybe_prepare_tokens(Sem, GenTokens, RepairedTokens, ParserTokens, RepairStatus),
            run_parse_case(ParserTokens, ParseStatus, ParsedSem, ParseTree),

            format(
                ParseS,
                "gen_to_parse_parsing_case(~q, ~q, ~q, ~q, ~q, ~q, ~q, ~q).~n",
                [CaseId, Sem, GenStatus, GenTokens, RepairedTokens, ParserTokens, ParseStatus, ParsedSem]
            ),

            write_parse_tree_block(
                TreeS,
                CaseId,
                Sem,
                GenStatus,
                GenTokens,
                RepairedTokens,
                ParserTokens,
                RepairStatus,
                ParseStatus,
                ParsedSem,
                ParseTree
            ),

            mg_logger:log_event(
                parse_session,
                gen_to_parse_parsing_case(
                    case_id(CaseId),
                    semantic_input(Sem),
                    generation_status(GenStatus),
                    generated_tokens(GenTokens),
                    repaired_tokens(RepairedTokens),
                    parser_input_tokens(ParserTokens),
                    repair_status(RepairStatus),
                    parsing_status(ParseStatus),
                    recovered_semantic_output(ParsedSem)
                )
            )
        )
    ),

    close(ParseS),
    close(TreeS),

    mg_logger:log_event(system, parse_run_end),
    halt.

log_run_configuration :-
    testbench_profile:profile_name(ProfileName),
    testbench_profile:parser_name(ParserName),
    testbench_profile:parser_load_file(ParserLoadFile),
    testbench_profile:parser_semantics_source(ParserSemanticsSource),
    testbench_profile:parser_wrapper_file(ParserWrapperFile),
    testbench_profile:parser_lexicon_name(ParserLexiconName),
    testbench_profile:parser_lexicon_file(ParserLexiconFile),

    testbench_profile:repair_enabled(Repair),
    testbench_profile:smoothing_enabled(Smoothing),
    testbench_profile:smoothing_style(Style),
    testbench_profile:adapter_timeout_seconds(AdapterTimeoutSeconds),

    run_metadata:gen_out_file(GenOutFile),
    run_metadata:parse_out_file(ParseOutFile),
    run_metadata:forward_parse_tree_report_file(ParseTreeFile),

    mg_logger:log_event(
        configuration,
        gen_to_parse_parsing_stage(
            profile_name(ProfileName),
            parser_name(ParserName),
            parser_load_file(ParserLoadFile),
            parser_semantics_source(ParserSemanticsSource),
            parser_wrapper_file(ParserWrapperFile),
            parser_lexicon_name(ParserLexiconName),
            parser_lexicon_file(ParserLexiconFile),
            generation_stage_output_file(GenOutFile),
            parsing_stage_output_file(ParseOutFile),
            parsing_tree_report_file(ParseTreeFile),
            repair_enabled(Repair),
            token_normalization_enabled(Smoothing),
            token_normalization_style(Style),
            adapter_timeout_seconds(AdapterTimeoutSeconds)
        )
    ),

    format(
        "~n[gen_to_parse_parsing_stage] profile=~q parser=~q parser_load=~q parser_semantics=~q parser_wrapper=~q parser_lexicon=~q generation_output=~q parsing_output=~q parsing_tree_report=~q repair=~q token_normalization=~q style=~q timeout_seconds=~q~n",
        [
            ProfileName,
            ParserName,
            ParserLoadFile,
            ParserSemanticsSource,
            ParserWrapperFile,
            ParserLexiconName,
            GenOutFile,
            ParseOutFile,
            ParseTreeFile,
            Repair,
            Smoothing,
            Style,
            AdapterTimeoutSeconds
        ]
    ).

maybe_prepare_tokens(Sem, GenTokens, RepairedTokens, ParserTokens, repaired) :-
    testbench_profile:repair_enabled(true),
    repair_adapter:maybe_repair_tokens(Sem, GenTokens, RepairedTokens),
    RepairedTokens \== GenTokens,
    !,
    token_normalizer:normalize_gen_to_parser(RepairedTokens, ParserTokens).

maybe_prepare_tokens(Sem, GenTokens, RepairedTokens, ParserTokens, not_repaired) :-
    testbench_profile:repair_enabled(true),
    !,
    repair_adapter:maybe_repair_tokens(Sem, GenTokens, RepairedTokens),
    token_normalizer:normalize_gen_to_parser(RepairedTokens, ParserTokens).

maybe_prepare_tokens(_Sem, GenTokens, GenTokens, ParserTokens, repair_disabled) :-
    token_normalizer:normalize_gen_to_parser(GenTokens, ParserTokens).

run_parse_case([], parse_skipped_empty_tokens, none, none) :- !.

run_parse_case(Tokens, ParseStatus, ParsedSem, RawTree) :-
    mg_parse_wrapper:parse_with_semantics_safe(Tokens, RawTree0, SemanticTree, AdapterStatus),
    normalize_parse_status(AdapterStatus, ParseStatus),

    (   ParseStatus == ok
    ->  extract_root_semantics(SemanticTree, ParsedSem),
        RawTree = RawTree0
    ;   ParsedSem = none,
        RawTree = none
    ),
    !.

normalize_parse_status(ok, ok) :- !.
normalize_parse_status(timeout, parse_timeout) :- !.
normalize_parse_status(no_solution, parse_fail) :- !.
normalize_parse_status(error(E), parser_error(E)) :- !.
normalize_parse_status(_, parse_fail).

/*
extract_root_semantics/2
------------------------
The parser's internal semantic pipeline returns a semantic tree such as:

tree([([four, teen], [cfin], '1X+10'(4))], ...)

The root semantic value is the third element of the first tuple in the
root annotation list.
*/

extract_root_semantics(tree([(_, _, Sem) | _], _, _), Sem) :- !.
extract_root_semantics(li(_, _, Sem), Sem) :- !.
extract_root_semantics(Sem, Sem).

write_tree_repair_fields_if_relevant(S, GenTokens, RepairedTokens, RepairStatus) :-
    testbench_profile:repair_enabled(true),
    !,
    format(S, "REPAIRED TOKENS: ~q~n", [RepairedTokens]),
    format(S, "REPAIR STATUS: ~q~n", [RepairStatus]),
    write_tree_repair_note(S, GenTokens, RepairedTokens).

write_tree_repair_fields_if_relevant(_, _, _, _).

write_tree_repair_note(S, GenTokens, RepairedTokens) :-
    (   RepairedTokens \== GenTokens
    ->  format(S, "REPAIR NOTE: repair changed the generated token sequence~n", [])
    ;   format(S, "REPAIR NOTE: repair was enabled but no change was applied~n", [])
    ).

write_parsing_output_header(S) :-
    format(S, "% =============================================================================~n", []),
    format(S, "% Generation-to-Parsing: Parsing-stage Output~n", []),
    format(S, "% =============================================================================~n", []),
    format(S, "% Each fact has the form:~n", []),
    format(S, "%~n", []),
    format(S, "%   gen_to_parse_parsing_case(CaseId, SemanticInput, GenerationStatus, GeneratedTokens, RepairedTokens, ParserInputTokens, ParsingStatus, RecoveredSemanticOutput).~n", []),
    format(S, "%~n", []),
    format(S, "% Meaning:~n", []),
    format(S, "%   CaseId                   - numeric identifier shared across all artifacts for the same test case~n", []),
    format(S, "%   SemanticInput            - original semantic input used in the generation stage~n", []),
    format(S, "%   GenerationStatus         - result of the generation stage~n", []),
    format(S, "%   GeneratedTokens          - raw token sequence produced by the generation stage~n", []),
    format(S, "%   RepairedTokens           - token sequence after optional repair; identical to GeneratedTokens when repair is disabled~n", []),
    format(S, "%   ParserInputTokens        - token sequence after normalization; passed to the parser~n", []),
    format(S, "%   ParsingStatus            - result of the parsing stage, e.g. ok, parse_fail, parse_timeout~n", []),
    format(S, "%   RecoveredSemanticOutput  - semantic representation recovered by the parser, or none if parsing failed~n", []),
    format(S, "% =============================================================================~n~n", []).

write_parse_tree_block(
    S,
    CaseId,
    Sem,
    GenStatus,
    GenTokens,
    RepairedTokens,
    ParserTokens,
    RepairStatus,
    ParseStatus,
    ParsedSem,
    ParseTree
) :-
    format(S, "==================================================~n", []),
    format(S, "CASE ID: ~q~n", [CaseId]),
    format(S, "SEMANTIC INPUT: ~q~n", [Sem]),
    format(S, "GENERATION STATUS: ~q~n", [GenStatus]),
    format(S, "GENERATED TOKENS: ~q~n", [GenTokens]),
    write_tree_repair_fields_if_relevant(S, GenTokens, RepairedTokens, RepairStatus),
    format(S, "PARSER INPUT TOKENS: ~q~n", [ParserTokens]),
    format(S, "PARSING STATUS: ~q~n", [ParseStatus]),
    format(S, "RECOVERED SEMANTIC OUTPUT: ~q~n", [ParsedSem]),
    format(S, "PARSING TREE:~n", []),
    write_term(S, ParseTree, [quoted(true), portray(true), max_depth(0)]),
    format(S, "~n~n", []).