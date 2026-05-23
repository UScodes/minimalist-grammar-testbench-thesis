:- use_module('../../SemanticGenerator/MG-Generator/helpers/mg_logger').
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

    testbench_profile:parser_semantics_file(ParserSemanticsFile),
    consult(ParserSemanticsFile),

    run_metadata:gen_out_file(GenOutFile),
    consult(GenOutFile),

    run_metadata:parse_out_file(ParseOutFile),
    run_metadata:forward_parse_tree_report_file(ParseTreeFile),

    open(ParseOutFile, write, ParseS),
    open(ParseTreeFile, write, TreeS),

    forall(
        gen_case(Sem, GenStatus, GenTokens, _Sent),
        (
            maybe_prepare_tokens(Sem, GenTokens, RepairedTokens, ParserTokens, RepairStatus),
            run_parse_case(ParserTokens, ParseStatus, ParsedSem, ParseTree),

            format(
                ParseS,
                "bidir_case(~q, ~q, ~q, ~q, ~q, ~q, ~q).~n",
                [Sem, GenStatus, GenTokens, RepairedTokens, ParserTokens, ParseStatus, ParsedSem]
            ),

            write_parse_tree_block(
                TreeS,
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
                parse_case(
                    semantic(Sem),
                    gen_status(GenStatus),
                    gen_tokens(GenTokens),
                    repaired_tokens(RepairedTokens),
                    parser_tokens(ParserTokens),
                    repair_status(RepairStatus),
                    parse_status(ParseStatus),
                    parsed_sem(ParsedSem)
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
    testbench_profile:parser_semantics_file(ParserSemanticsFile),
    testbench_profile:parser_lexicon_name(ParserLexiconName),
    testbench_profile:parser_lexicon_file(ParserLexiconFile),

    testbench_profile:repair_enabled(Repair),
    testbench_profile:smoothing_enabled(Smoothing),
    testbench_profile:smoothing_style(Style),

    run_metadata:gen_out_file(GenOutFile),
    run_metadata:parse_out_file(ParseOutFile),
    run_metadata:forward_parse_tree_report_file(ParseTreeFile),

    mg_logger:log_event(
        configuration,
        parse_run(
            profile_name(ProfileName),
            parser_name(ParserName),
            parser_load_file(ParserLoadFile),
            parser_semantics_file(ParserSemanticsFile),
            parser_lexicon_name(ParserLexiconName),
            parser_lexicon_file(ParserLexiconFile),
            gen_out_file(GenOutFile),
            parse_out_file(ParseOutFile),
            forward_parse_tree_report_file(ParseTreeFile),
            repair_enabled(Repair),
            smoothing_enabled(Smoothing),
            smoothing_style(Style)
        )
    ),

    format(
        "~n[parse_run] profile=~q parser=~q parser_load=~q parser_semantics=~q parser_lexicon=~q gen_out=~q parse_out=~q parse_tree_report=~q repair=~q smoothing=~q style=~q~n",
        [
            ProfileName,
            ParserName,
            ParserLoadFile,
            ParserSemanticsFile,
            ParserLexiconName,
            GenOutFile,
            ParseOutFile,
            ParseTreeFile,
            Repair,
            Smoothing,
            Style
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
run_parse_case(Tokens, ok, ParsedSem, Tree) :-
    once(lcparser:lcParse(Tokens, Tree)),
    sem_from_tree:sem_from_parse_result(Tree, ParsedSem),
    !.
run_parse_case(_, parse_fail, none, none).

write_parse_tree_block(
    S,
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
    format(S, "SEMANTIC: ~q~n", [Sem]),
    format(S, "GEN STATUS: ~q~n", [GenStatus]),
    format(S, "GEN TOKENS: ~q~n", [GenTokens]),
    format(S, "REPAIRED TOKENS: ~q~n", [RepairedTokens]),
    format(S, "PARSER TOKENS: ~q~n", [ParserTokens]),
    format(S, "REPAIR STATUS: ~q~n", [RepairStatus]),
    format(S, "PARSE STATUS: ~q~n", [ParseStatus]),
    format(S, "PARSED SEMANTICS: ~q~n", [ParsedSem]),
    format(S, "PARSE TREE:~n", []),
    write_term(S, ParseTree, [quoted(true), portray(true), max_depth(0)]),
    format(S, "~n~n", []).