:- use_module('../logging/testbench_logger').
:- use_module('../config/run_metadata').
:- use_module('../config/testbench_profile').

:- initialization(main, main).

main :-
    mg_logger:log_event(system, reverse_parse_run_start),
    log_run_configuration,

    testbench_profile:parser_load_file(ParserLoadFile),
    consult(ParserLoadFile),

    % Testbench-local parser adapter.
    % It uses the parser's internal semantic pipeline:
    % lcParse/2 -> workSpace/2 -> lappend/2 -> betaRoot/2
    consult('../adapters/parser_adapter.pl'),

    testbench_profile:token_cases_file(TokenCasesFile),
    consult(TokenCasesFile),

    run_metadata:reverse_parse_out_file(ReverseParseOutFile),
    open(ReverseParseOutFile, write, S),

    run_metadata:reverse_parse_tree_report_file(ReverseParseTreeReportFile),
    open(ReverseParseTreeReportFile, write, TreeS),

    forall(
        token_case(Tokens),
        (
            run_reverse_parse_case(Tokens, ParseStatus, ParsedSem, ParseTree),
            format(S, "reverse_parse_case(~q, ~q, ~q).~n", [Tokens, ParseStatus, ParsedSem]),

            format(TreeS, "Tokens: ~q~n", [Tokens]),
            format(TreeS, "Parse Status: ~q~n", [ParseStatus]),
            format(TreeS, "Parsed Semantic Output: ~q~n", [ParsedSem]),
            format(TreeS, "Parse Tree: ~q~n", [ParseTree]),
            format(TreeS, "--------------------------------------------------~n", []),

            mg_logger:log_event(
                reverse_parse_session,
                reverse_parse_case(
                    tokens(Tokens),
                    parse_status(ParseStatus),
                    parsed_sem(ParsedSem),
                    parse_tree(ParseTree)
                )
            )
        )
    ),

    close(TreeS),
    close(S),
    mg_logger:log_event(system, reverse_parse_run_end),
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

    testbench_profile:token_cases_file(TokenCasesFile),
    run_metadata:reverse_parse_out_file(ReverseParseOutFile),

    mg_logger:log_event(
        configuration,
        reverse_parse_run(
            profile_name(ProfileName),
            parser_name(ParserName),
            parser_load_file(ParserLoadFile),
            parser_semantics_source(ParserSemanticsSource),
            parser_wrapper_file(ParserWrapperFile),
            parser_lexicon_name(ParserLexiconName),
            parser_lexicon_file(ParserLexiconFile),
            token_cases_file(TokenCasesFile),
            reverse_parse_out_file(ReverseParseOutFile),
            repair_enabled(Repair),
            smoothing_enabled(Smoothing),
            smoothing_style(Style)
        )
    ),

    format(
        "~n[reverse_parse_run] profile=~q parser=~q parser_load=~q parser_semantics=~q parser_wrapper=~q parser_lexicon=~q token_cases=~q reverse_parse_out=~q repair=~q smoothing=~q style=~q~n",
        [
            ProfileName,
            ParserName,
            ParserLoadFile,
            ParserSemanticsSource,
            ParserWrapperFile,
            ParserLexiconName,
            TokenCasesFile,
            ReverseParseOutFile,
            Repair,
            Smoothing,
            Style
        ]
    ).

run_reverse_parse_case([], parse_skipped_empty_tokens, none, none) :- !.

run_reverse_parse_case(Tokens, ParseStatus, ParsedSem, RawTree) :-
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