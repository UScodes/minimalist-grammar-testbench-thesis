% file: bidirectional/mg_bidir_runner.pl
:- module(mg_bidirectional_runner, [
    test_gen_parse_semantics/1,
    test_parse_to_gen_atomic/1,
    run_bidirectional_suite/0,
    bidir_setup/0
]).

/*
  Bidirectional Semantic Testbench (STABLE + TIMED)

  NO CHANGES to lcparser or lambdaSelect.

  We avoid lexicon collision by:
   - Loading English_trans_pruned into module lex_en
   - Loading numbers_Gen into module lex_gen

  Then we "bridge" lexicon lookup into the modules that need them:
   - lcparser + sem_from_tree -> lex_en
   - lambdaSelect            -> lex_gen
*/

% --------------------------------------------------
% Imports (relative)
% --------------------------------------------------
:- use_module('../SemanticGenerator/MG-Generator/helpers/mg_logger').
:- use_module('../SemanticGenerator/MG-Generator/mg_generate_wrapper.pl').
:- use_module('../MG-LC-Parser-with-Semantic-main/lcparser.pl').
:- use_module('../MG-LC-Parser-with-Semantic-main/sem_from_tree.pl').
:- use_module(lex_loader).

% --------------------------------------------------
% Ensure generator stack is loaded (no edits)
% --------------------------------------------------
ensure_generator_stack_loaded :-
    (   current_predicate(lambdaSelect:checkLambda/5)
    ->  true
    ;   consult('../SemanticGenerator/MG-Generator/lambdaSelect.pl'),
        consult('../SemanticGenerator/MG-Generator/lambdaWorkspace.pl')
    ).

% --------------------------------------------------
% Setup: load lexicons + install bridges
% --------------------------------------------------
bidir_setup :-
    ensure_generator_stack_loaded,
    lex_loader:load_lexicons,
    install_lex_bridges.

% --------------------------------------------------
% Lexicon bridges (simple + reliable)
% --------------------------------------------------
:- dynamic lcparser:'::'/2.
:- dynamic sem_from_tree:'::'/2.
:- dynamic lambdaSelect:'::'/2.
:- dynamic lcparser:startCategory/1.
:- dynamic lambdaSelect:startCategory/1.

install_lex_bridges :-
    % Make sure :: operator exists in the modules where grammar is *read*
    lcparser:op(500, xfx, ::),
    sem_from_tree:op(500, xfx, ::),
    lambdaSelect:op(500, xfx, ::),

    % Forward lexicon lookup:
    %   lcparser / sem_from_tree use lex_en
    %   lambdaSelect uses lex_gen
    abolish_if_exists(lcparser:'::'/2),
    abolish_if_exists(sem_from_tree:'::'/2),
    abolish_if_exists(lambdaSelect:'::'/2),
    abolish_if_exists(lcparser:startCategory/1),
    abolish_if_exists(lambdaSelect:startCategory/1),

    assertz( (lcparser:(A :: B) :- lex_en:(A :: B)) ),
    assertz( (sem_from_tree:(A :: B) :- lex_en:(A :: B)) ),
    assertz( (lambdaSelect:(A :: B) :- lex_gen:(A :: B)) ),

    % startCategory/1 forwarding (if required by either side)
    ( current_predicate(lex_en:startCategory/1)
    -> assertz( (lcparser:startCategory(X) :- lex_en:startCategory(X)) )
    ;  true
    ),
    ( current_predicate(lex_gen:startCategory/1)
    -> assertz( (lambdaSelect:startCategory(X) :- lex_gen:startCategory(X)) )
    ;  true
    ).

abolish_if_exists(PI) :-
    ( current_predicate(PI) -> catch(abolish(PI), _, true) ; true ).

% --------------------------------------------------
% SAFETY CHECKS
% --------------------------------------------------
ensure_generator_loaded :-
    ensure_generator_stack_loaded,
    current_predicate(mg_generate_wrapper:generate_safe/5).

ensure_parser_loaded :-
    current_predicate(lcparser:lcParse/2).

% --------------------------------------------------
% GEN OUTPUT WORD EXTRACTION
% --------------------------------------------------
extract_words_from_gen(li(Words, _, _), Words) :- !.
extract_words_from_gen(tree(Head, _, _), Words) :- !, extract_words_from_gen(Head, Words).
extract_words_from_gen(tree([(Words, _, _)|_], _, _, _), Words) :- !.
extract_words_from_gen([Tree|_], Words) :- !, extract_words_from_gen(Tree, Words).
extract_words_from_gen(_, []).

% --------------------------------------------------
% TOKEN MAPPING (GEN -> PARSER)
% --------------------------------------------------
map_tokens(In, Out) :- map_tokens_loop(In, Out).
map_tokens_loop([], []).
map_tokens_loop([twenty, X | R], [twenty_, X | R2]) :- !, map_tokens_loop(R, R2).
map_tokens_loop([thirty, X | R], [thirty_, X | R2]) :- !, map_tokens_loop(R, R2).
map_tokens_loop([forty,  X | R], [forty_,  X | R2]) :- !, map_tokens_loop(R, R2).
map_tokens_loop([fifty,  X | R], [fifty_,  X | R2]) :- !, map_tokens_loop(R, R2).
map_tokens_loop([eight, teen | R], [eight, een | R2]) :- !, map_tokens_loop(R, R2).
map_tokens_loop([H|T], [H|T2]) :- map_tokens_loop(T, T2).

semantic_equal(A,B) :- A == B.

% --------------------------------------------------
% GEN -> PARSE
% --------------------------------------------------
test_gen_parse_semantics(Sem) :-
    ensure_generator_loaded,
    ensure_parser_loaded,

    statistics(cputime, TG0),
    mg_generate_wrapper:generate_safe(Sem, SentenceAtom, _Lambda, GenTree, GenStatus),
    statistics(cputime, TG1),
    GenTime is TG1 - TG0,

    ( GenStatus \== ok ->
        format("BIDIR FAIL (gen): ~q GenStatus=~w~n", [Sem, GenStatus]),
        mg_logger:log_event(bidir,
            bidir_result(direction(gen_to_parse), semantic(Sem),
                         status(gen_fail), gen_status(GenStatus), gen_time(GenTime)))
    ;
        extract_words_from_gen(GenTree, GenTokens),
        map_tokens(GenTokens, Tokens),

        statistics(cputime, TP0),
        ( once(lcparser:lcParse(Tokens, ParseTree)) ->
            statistics(cputime, TP1),
            ParseTime is TP1 - TP0,

            sem_from_tree:sem_from_parse_result(ParseTree, ParsedSem),
            ( semantic_equal(Sem, ParsedSem) -> Status = semantic_ok ; Status = semantic_mismatch ),

            format("G→P ~w: Sem=~q GenTokens=~w Tokens=~w ParsedSem=~q~n",
                   [Status, Sem, GenTokens, Tokens, ParsedSem]),
            mg_logger:log_event(bidir,
                bidir_result(direction(gen_to_parse), semantic(Sem), sentence(SentenceAtom),
                             gen_tokens(GenTokens), tokens(Tokens), parsed_sem(ParsedSem),
                             gen_time(GenTime), parse_time(ParseTime), status(Status)))
        ;
            statistics(cputime, TP1),
            ParseTime is TP1 - TP0,
            format("BIDIR FAIL (parse): Sem=~q Tokens=~w~n", [Sem, Tokens]),
            mg_logger:log_event(bidir,
                bidir_result(direction(gen_to_parse), semantic(Sem), sentence(SentenceAtom),
                             tokens(Tokens), status(parse_fail), gen_time(GenTime), parse_time(ParseTime)))
        )
    ).

% --------------------------------------------------
% PARSE -> GEN
% --------------------------------------------------
test_parse_to_gen_atomic(Tokens) :-
    ensure_parser_loaded,
    ensure_generator_loaded,

    statistics(cputime, TP0),
    ( once(lcparser:lcParse(Tokens, ParseTree)) ->
        statistics(cputime, TP1),
        ParseTime is TP1 - TP0,

        sem_from_tree:sem_from_parse_result(ParseTree, Sem),

        statistics(cputime, TG0),
        mg_generate_wrapper:generate_safe(Sem, GenSentence, _Lambda, _GenTree, GenStatus),
        statistics(cputime, TG1),
        GenTime is TG1 - TG0,

        ( GenStatus == ok ->
            format("P→G OK: Tokens=~w Sem=~q Gen=~q~n", [Tokens, Sem, GenSentence]),
            mg_logger:log_event(bidir,
                bidir_result(direction(parse_to_gen), input_tokens(Tokens), semantic(Sem),
                             generated_sentence(GenSentence), parse_time(ParseTime), gen_time(GenTime), status(ok)))
        ;
            format("P→G FAIL (gen): Tokens=~w Sem=~q GenStatus=~w~n", [Tokens, Sem, GenStatus]),
            mg_logger:log_event(bidir,
                bidir_result(direction(parse_to_gen), input_tokens(Tokens), semantic(Sem),
                             status(gen_fail), gen_status(GenStatus), parse_time(ParseTime), gen_time(GenTime)))
        )
    ;
        statistics(cputime, TP1),
        ParseTime is TP1 - TP0,
        format("P→G FAIL (parse): Tokens=~w~n", [Tokens]),
        mg_logger:log_event(bidir,
            bidir_result(direction(parse_to_gen), input_tokens(Tokens),
                         status(parse_fail), parse_time(ParseTime)))
    ).

% --------------------------------------------------
% SUITE
% --------------------------------------------------
run_bidirectional_suite :-
    mg_logger:log_event(system, start_sem_bidir),

    test_gen_parse_semantics(1),
    test_gen_parse_semantics(2),
    test_gen_parse_semantics(8),
    test_gen_parse_semantics(13),
    test_gen_parse_semantics(20),
    test_gen_parse_semantics('1X+10'(4)),
    test_gen_parse_semantics('0X+18'(8)),
    test_gen_parse_semantics('1X+20'(4)),

    test_parse_to_gen_atomic([seven]),
    test_parse_to_gen_atomic([twenty]),
    test_parse_to_gen_atomic([twenty_, four]),
    test_parse_to_gen_atomic([eight, een]),

    mg_logger:log_event(system, end_sem_bidir),
    true.