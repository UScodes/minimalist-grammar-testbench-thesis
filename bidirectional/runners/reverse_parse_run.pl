:- use_module('../../SemanticGenerator/MG-Generator/helpers/mg_logger').
:- use_module('../config/run_metadata').
:- use_module('../config/testbench_profile').

:- initialization(main, main).

main :-
    mg_logger:log_event(system, reverse_parse_run_start),
    log_run_configuration,

    testbench_profile:parser_load_file(ParserLoadFile),
    consult(ParserLoadFile),

    testbench_profile:parser_semantics_file(ParserSemanticsFile),
    consult(ParserSemanticsFile),

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
    testbench_profile:parser_semantics_file(ParserSemanticsFile),
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
            parser_semantics_file(ParserSemanticsFile),
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
        "~n[reverse_parse_run] profile=~q parser=~q parser_load=~q parser_semantics=~q parser_lexicon=~q token_cases=~q reverse_parse_out=~q repair=~q smoothing=~q style=~q~n",
        [
            ProfileName,
            ParserName,
            ParserLoadFile,
            ParserSemanticsFile,
            ParserLexiconName,
            TokenCasesFile,
            ReverseParseOutFile,
            Repair,
            Smoothing,
            Style
        ]
    ).

run_reverse_parse_case([], parse_skipped_empty_tokens, none, none) :- !.
run_reverse_parse_case(Tokens, ok, ParsedSem, Tree) :-
    once(lcparser:lcParse(Tokens, Tree)),
    sem_from_tree:sem_from_parse_result(Tree, ParsedSem),
    !.
run_reverse_parse_case(_, parse_fail, none, none).