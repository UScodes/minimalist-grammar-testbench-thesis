:- use_module('../logging/testbench_logger').
:- use_module('../config/run_metadata').
:- use_module('../config/testbench_profile').

:- initialization(main, main).

main :-
    mg_logger:log_event(system, parse_to_gen_parse_run_start),
    log_run_configuration,

    testbench_profile:parser_load_file(ParserLoadFile),
    consult(ParserLoadFile),

    % Testbench-local parser adapter.
    % It uses the parser's internal semantic pipeline:
    % lcParse/2 -> workSpace/2 -> lappend/2 -> betaRoot/2
    consult('../adapters/parser_adapter.pl'),

    testbench_profile:token_cases_file(TokenCasesFile),
    consult(TokenCasesFile),

    run_metadata:reverse_parse_out_file(ParseOutFile),
    open(ParseOutFile, write, S),

    run_metadata:reverse_parse_tree_report_file(ParseTreeReportFile),
    open(ParseTreeReportFile, write, TreeS),

    write_parsing_output_header(S),

    findall(Tokens, token_case(Tokens), TokenCases),

    forall(
        nth1(CaseId, TokenCases, Tokens),
        (
            run_parse_to_gen_parse_case(Tokens, ParseStatus, ParsedSem, ParseTree),

            format(
                S,
                "parse_to_gen_parsing_case(~q, ~q, ~q, ~q).~n",
                [CaseId, Tokens, ParseStatus, ParsedSem]
            ),

            write_parse_tree_block(
                TreeS,
                CaseId,
                Tokens,
                ParseStatus,
                ParsedSem,
                ParseTree
            ),

            mg_logger:log_event(
                parse_to_gen_parse_session,
                parse_to_gen_parsing_case(
                    case_id(CaseId),
                    token_input(Tokens),
                    parsing_status(ParseStatus),
                    recovered_semantic_output(ParsedSem),
                    parse_tree(ParseTree)
                )
            )
        )
    ),

    close(TreeS),
    close(S),
    mg_logger:log_event(system, parse_to_gen_parse_run_end),
    halt.

log_run_configuration :-
    testbench_profile:profile_name(ProfileName),
    testbench_profile:parser_name(ParserName),
    testbench_profile:parser_load_file(ParserLoadFile),
    testbench_profile:parser_semantics_source(ParserSemanticsSource),
    testbench_profile:parser_wrapper_file(ParserWrapperFile),
    testbench_profile:parser_lexicon_name(ParserLexiconName),
    testbench_profile:parser_lexicon_file(ParserLexiconFile),

    
    testbench_profile:smoothing_enabled(Smoothing),
    testbench_profile:smoothing_style(Style),
    testbench_profile:adapter_timeout_seconds(AdapterTimeoutSeconds),

    testbench_profile:token_cases_file(TokenCasesFile),
    run_metadata:reverse_parse_out_file(ParseOutFile),
    run_metadata:reverse_parse_tree_report_file(ParseTreeReportFile),

    mg_logger:log_event(
        configuration,
        parse_to_gen_parsing_stage(
            profile_name(ProfileName),
            parser_name(ParserName),
            parser_load_file(ParserLoadFile),
            parser_semantics_source(ParserSemanticsSource),
            parser_wrapper_file(ParserWrapperFile),
            parser_lexicon_name(ParserLexiconName),
            parser_lexicon_file(ParserLexiconFile),
            token_cases_file(TokenCasesFile),
            parsing_stage_output_file(ParseOutFile),
            parsing_tree_report_file(ParseTreeReportFile),
            
            token_normalization_enabled(Smoothing),
            token_normalization_style(Style),
            adapter_timeout_seconds(AdapterTimeoutSeconds)
        )
    ),

    format(
        "~n[parse_to_gen_parsing_stage] profile=~q parser=~q parser_load=~q parser_semantics=~q parser_wrapper=~q parser_lexicon=~q token_cases=~q parsing_output=~q parsing_tree_report=~q token_normalization=~q style=~q timeout_seconds=~q~n",
        [
            ProfileName,
            ParserName,
            ParserLoadFile,
            ParserSemanticsSource,
            ParserWrapperFile,
            ParserLexiconName,
            TokenCasesFile,
            ParseOutFile,
            ParseTreeReportFile,
            
            Smoothing,
            Style,
            AdapterTimeoutSeconds
        ]
    ).

run_parse_to_gen_parse_case([], parse_skipped_empty_tokens, none, none) :- !.

run_parse_to_gen_parse_case(Tokens, ParseStatus, ParsedSem, RawTree) :-
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

write_parsing_output_header(S) :-
    format(S, "% =============================================================================~n", []),
    format(S, "% Parsing-to-Generation: Parsing-stage Output~n", []),
    format(S, "% =============================================================================~n", []),
    format(S, "% Each fact has the form:~n", []),
    format(S, "%~n", []),
    format(S, "%   parse_to_gen_parsing_case(CaseId, TokenInput, ParsingStatus, RecoveredSemanticOutput).~n", []),
    format(S, "%~n", []),
    format(S, "% Meaning:~n", []),
    format(S, "%   CaseId                   - numeric identifier shared across all artifacts for the same test case~n", []),
    format(S, "%   TokenInput               - original token sequence sent to the parser~n", []),
    format(S, "%   ParsingStatus            - result of the parsing stage, e.g. ok, parse_fail, parse_timeout~n", []),
    format(S, "%   RecoveredSemanticOutput  - semantic representation recovered by the parser, or none if parsing failed~n", []),
    format(S, "% =============================================================================~n~n", []).

write_parse_tree_block(S, CaseId, Tokens, ParseStatus, ParsedSem, ParseTree) :-
    format(S, "==================================================~n", []),
    format(S, "CASE ID: ~q~n", [CaseId]),
    format(S, "TOKEN INPUT: ~q~n", [Tokens]),
    format(S, "PARSING STATUS: ~q~n", [ParseStatus]),
    format(S, "RECOVERED SEMANTIC OUTPUT: ~q~n", [ParsedSem]),
    format(S, "PARSING TREE:~n", []),
    write_term(S, ParseTree, [quoted(true), portray(true), max_depth(0)]),
    format(S, "~n~n", []).