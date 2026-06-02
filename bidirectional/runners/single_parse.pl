:- use_module('../logging/testbench_logger').
:- use_module('../config/run_metadata').
:- use_module('../config/testbench_profile').

:- initialization(main, main).

/*
-----------------------------------------------------------
MG Testbench – Single Parser Diagnostic Runner
-----------------------------------------------------------

Purpose
-------
This runner executes one parser-only diagnostic case.

It is not a full validation pipeline. It does not compare parser and
generator outputs. Its purpose is to inspect whether the configured
parser can parse one token input and recover a semantic representation.

The runner uses the same parser adapter as the batch pipelines, so
timeout handling, error handling, no-solution handling, parse-tree
capture, and semantic extraction remain consistent with the full
testbench.

Usage
-----
From the bidirectional/runners directory:

    swipl -q -f single_parse.pl -- "[twenty_,seven]"

Later, through the Python runner:

    python run_testbench.py --mode single_parse --tokens "[twenty_,seven]"
*/


main :-
    mg_logger:log_event(system, single_parse_run_start),
    log_run_configuration,

    current_prolog_flag(argv, Args),
    read_token_argument(Args, Tokens),

    testbench_profile:parser_load_file(ParserLoadFile),
    consult(ParserLoadFile),

    % Testbench-local parser adapter.
    % It uses the parser's internal semantic pipeline:
    % lcParse/2 -> workSpace/2 -> lappend/2 -> betaRoot/2
    consult('../adapters/parser_adapter.pl'),

    run_single_parse_case(Tokens, ParseStatus, ParsedSem, ParseTree),

    run_metadata:single_parse_report_file(ReportFile),
    open(ReportFile, write, S),
    write_single_parse_report(
        S,
        Tokens,
        ParseStatus,
        ParsedSem,
        ParseTree
    ),
    close(S),

    write_single_parse_report(
        user_output,
        Tokens,
        ParseStatus,
        ParsedSem,
        ParseTree
    ),

    mg_logger:log_event(
        single_parse_session,
        single_parse_case(
            token_input(Tokens),
            parsing_status(ParseStatus),
            recovered_semantic_output(ParsedSem),
            parse_tree(ParseTree)
        )
    ),

    mg_logger:log_event(system, single_parse_run_end),
    halt.


% =============================================================================
% Configuration logging
% =============================================================================

log_run_configuration :-
    testbench_profile:profile_name(ProfileName),
    testbench_profile:parser_name(ParserName),
    testbench_profile:parser_load_file(ParserLoadFile),
    testbench_profile:parser_wrapper_file(ParserWrapperFile),
    testbench_profile:parser_semantics_source(ParserSemanticsSource),
    testbench_profile:parser_lexicon_name(ParserLexiconName),
    testbench_profile:parser_lexicon_file(ParserLexiconFile),

    testbench_profile:smoothing_enabled(Smoothing),
    testbench_profile:smoothing_style(Style),
    testbench_profile:adapter_timeout_seconds(AdapterTimeoutSeconds),

    run_metadata:single_parse_report_file(ReportFile),

    mg_logger:log_event(
        configuration,
        single_parse_run(
            profile_name(ProfileName),
            parser_name(ParserName),
            parser_load_file(ParserLoadFile),
            parser_wrapper_file(ParserWrapperFile),
            parser_semantics_source(ParserSemanticsSource),
            parser_lexicon_name(ParserLexiconName),
            parser_lexicon_file(ParserLexiconFile),
            report_file(ReportFile),
            token_normalization_enabled(Smoothing),
            token_normalization_style(Style),
            adapter_timeout_seconds(AdapterTimeoutSeconds)
        )
    ),

    format(
        "~n[single_parse] profile=~q parser=~q parser_load=~q parser_wrapper=~q parser_semantics=~q parser_lexicon=~q report=~q token_normalization=~q style=~q timeout_seconds=~q~n",
        [
            ProfileName,
            ParserName,
            ParserLoadFile,
            ParserWrapperFile,
            ParserSemanticsSource,
            ParserLexiconName,
            ReportFile,
            Smoothing,
            Style,
            AdapterTimeoutSeconds
        ]
    ).


% =============================================================================
% Command-line argument handling
% =============================================================================

read_token_argument([TokenString | _], Tokens) :-
    !,
    term_string(Tokens, TokenString),
    validate_token_list(Tokens).

read_token_argument([], _) :-
    format(user_error, "ERROR: Missing token input argument.~n", []),
    format(user_error, "Example: swipl -q -f single_parse.pl -- \"[twenty_,seven]\"~n", []),
    halt(2).

validate_token_list(Tokens) :-
    is_list(Tokens),
    !.

validate_token_list(Tokens) :-
    format(user_error, "ERROR: Token input must be a Prolog list, got: ~q~n", [Tokens]),
    halt(2).


% =============================================================================
% Single parser execution
% =============================================================================

run_single_parse_case([], parse_skipped_empty_tokens, none, none) :- !.

run_single_parse_case(Tokens, ParseStatus, ParsedSem, RawTree) :-
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


% =============================================================================
% Semantic extraction
% =============================================================================

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


% =============================================================================
% Report output
% =============================================================================

write_single_parse_report(S, Tokens, ParseStatus, ParsedSem, ParseTree) :-
    format(S, "==================================================~n", []),
    format(S, "Single Parser Diagnostic Report~n", []),
    format(S, "==================================================~n", []),
    format(S, "Token Input: ~q~n", [Tokens]),
    format(S, "Parsing Status: ~q~n", [ParseStatus]),
    format(S, "Recovered Semantic Output: ~q~n", [ParsedSem]),
    format(S, "Parse Tree:~n", []),
    write_term(S, ParseTree, [quoted(true), portray(true), max_depth(0)]),
    format(S, "~n==================================================~n~n", []).