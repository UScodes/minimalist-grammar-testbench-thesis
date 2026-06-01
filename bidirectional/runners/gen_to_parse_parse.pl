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
    testbench_profile:parser_semantics_source(ParserSemanticsSource),
    testbench_profile:parser_wrapper_file(ParserWrapperFile),
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
            parser_semantics_source(ParserSemanticsSource),
            parser_wrapper_file(ParserWrapperFile),
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
        "~n[parse_run] profile=~q parser=~q parser_load=~q parser_semantics=~q parser_wrapper=~q parser_lexicon=~q gen_out=~q parse_out=~q parse_tree_report=~q repair=~q smoothing=~q style=~q~n",
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
    write_tree_repair_fields_if_relevant(S, GenTokens, RepairedTokens, RepairStatus),
    format(S, "PARSER TOKENS: ~q~n", [ParserTokens]),
    format(S, "PARSE STATUS: ~q~n", [ParseStatus]),
    format(S, "PARSED SEMANTICS: ~q~n", [ParsedSem]),
    format(S, "PARSE TREE:~n", []),
    write_term(S, ParseTree, [quoted(true), portray(true), max_depth(0)]),
    format(S, "~n~n", []).