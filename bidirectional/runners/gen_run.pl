:- use_module('../../SemanticGenerator/MG-Generator/helpers/mg_logger').
:- use_module('../config/run_metadata').
:- use_module('../config/testbench_profile').

:- initialization(main, main).

main :-
    mg_logger:log_event(system, gen_run_start),
    log_run_configuration,

    testbench_profile:generator_main_file(GeneratorMainFile),
    consult(GeneratorMainFile),

    testbench_profile:semantic_cases_file(TestCasesFile),
    consult(TestCasesFile),

    run_metadata:gen_out_file(GenOutFile),
    run_metadata:forward_gen_tree_report_file(TreeReportFile),

    findall(Sem, test_case(Sem), Tests),

    open(GenOutFile, write, GenS),
    open(TreeReportFile, write, TreeS),

    forall(
        member(Sem, Tests),
        (
            run_gen_case(Sem, GenStatus, Tokens, Sent, TreeTerm),
            format(GenS, "gen_case(~q, ~q, ~q, ~q).~n", [Sem, GenStatus, Tokens, Sent]),
            write_gen_tree_block(TreeS, Sem, GenStatus, Tokens, Sent, TreeTerm),
            mg_logger:log_event(
                gen_session,
                gen_case(
                    semantic(Sem),
                    status(GenStatus),
                    tokens(Tokens),
                    sentence(Sent)
                )
            )
        )
    ),

    close(GenS),
    close(TreeS),

    mg_logger:log_event(system, gen_run_end),
    halt.

log_run_configuration :-
    testbench_profile:profile_name(ProfileName),
    testbench_profile:generator_name(GeneratorName),
    testbench_profile:generator_main_file(GeneratorMainFile),
    testbench_profile:generator_lexicon_name(GeneratorLexiconName),
    testbench_profile:generator_lexicon_file(GeneratorLexiconFile),

    testbench_profile:repair_enabled(Repair),
    testbench_profile:smoothing_enabled(Smoothing),
    testbench_profile:smoothing_style(Style),

    testbench_profile:semantic_cases_file(TestCasesFile),
    run_metadata:gen_out_file(GenOutFile),
    run_metadata:forward_gen_tree_report_file(TreeReportFile),

    mg_logger:log_event(
        configuration,
        gen_run(
            profile_name(ProfileName),
            generator_name(GeneratorName),
            generator_main_file(GeneratorMainFile),
            generator_lexicon_name(GeneratorLexiconName),
            generator_lexicon_file(GeneratorLexiconFile),
            semantic_cases_file(TestCasesFile),
            gen_out_file(GenOutFile),
            forward_gen_tree_report_file(TreeReportFile),
            repair_enabled(Repair),
            smoothing_enabled(Smoothing),
            smoothing_style(Style)
        )
    ),

    format(
        "~n[gen_run] profile=~q generator=~q generator_main=~q generator_lexicon=~q semantic_cases=~q gen_out=~q gen_tree_report=~q repair=~q smoothing=~q style=~q~n",
        [
            ProfileName,
            GeneratorName,
            GeneratorMainFile,
            GeneratorLexiconName,
            TestCasesFile,
            GenOutFile,
            TreeReportFile,
            Repair,
            Smoothing,
            Style
        ]
    ).

run_gen_case(Sem, GenStatus, Tokens, Sent, TreeTerm) :-
    catch(
        call_with_time_limit(
            5,
            (
                mg_generate_wrapper:generate_safe(Sem, Sent0, _L, Tree0, Status0),
                extract_words(Tree0, Tokens0),
                normalize_sent(Sent0, Sent),
                normalize_gen_status(Status0, Tokens0, GenStatus),
                Tokens = Tokens0,
                TreeTerm = Tree0
            )
        ),
        E,
        handle_gen_exception(E, GenStatus, Tokens, Sent, TreeTerm)
    ).

handle_gen_exception(time_limit_exceeded, generation_timeout, [], '', none) :- !.
handle_gen_exception(E, error(E), [], '', none).

normalize_gen_status(ok, [], gen_empty_yield) :- !.
normalize_gen_status(ok, [_|_], ok) :- !.
normalize_gen_status(Status, _, Status).

normalize_sent(S, S).

extract_words(li(W, _, _), W) :- !.
extract_words(tree(H, _, _), W) :- extract_words(H, W), !.
extract_words(tree([(W, _, _) | _], _, _, _), W) :- !.
extract_words([T | _], W) :- extract_words(T, W), !.
extract_words(_, []).

write_gen_tree_block(S, Sem, GenStatus, Tokens, Sent, TreeTerm) :-
    format(S, "==================================================~n", []),
    format(S, "SEMANTIC: ~q~n", [Sem]),
    format(S, "GEN STATUS: ~q~n", [GenStatus]),
    format(S, "GEN TOKENS: ~q~n", [Tokens]),
    format(S, "GEN SENTENCE: ~q~n", [Sent]),
    format(S, "GEN TREE:~n", []),
    write_term(S, TreeTerm, [quoted(true), portray(true), max_depth(0)]),
    format(S, "~n~n", []).