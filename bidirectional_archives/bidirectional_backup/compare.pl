:- use_module('../SemanticGenerator/MG-Generator/helpers/mg_logger').

:- initialization(main, main).

main :-
    mg_logger:log_event(system, compare_start),
    consult('parse_out.pl'),
    summarize,
    mg_logger:log_event(system, compare_end),
    halt.

summarize :-
    findall(
        case(Sem, GenStatus, GenTokens, RepairedTokens, ParserTokens, ParseStatus, ParsedSem, Verdict),
        classified_case(Sem, GenStatus, GenTokens, RepairedTokens, ParserTokens, ParseStatus, ParsedSem, Verdict),
        Cases
    ),
    print_cases(Cases),
    print_totals(Cases),
    write_report_file(Cases).

classified_case(Sem, GenStatus, GenTokens, RepairedTokens, ParserTokens, ParseStatus, ParsedSem, Verdict) :-
    bidir_case(Sem, GenStatus, GenTokens, RepairedTokens, ParserTokens, ParseStatus, ParsedSem),
    classify_case(GenStatus, GenTokens, RepairedTokens, ParseStatus, Sem, ParsedSem, Verdict).

print_cases([]).
print_cases([case(Sem, GenStatus, GenTokens, RepairedTokens, ParserTokens, ParseStatus, ParsedSem, Verdict)|R]) :-
    format(
        "~w | Sem=~q | Gen=~w | GenTokens=~w | Repaired=~w | ParserTokens=~w | Parse=~w | ParsedSem=~q~n",
        [Verdict, Sem, GenStatus, GenTokens, RepairedTokens, ParserTokens, ParseStatus, ParsedSem]
    ),
    mg_logger:log_event(compare,
        case_result(
            verdict(Verdict),
            semantic(Sem),
            gen_status(GenStatus),
            gen_tokens(GenTokens),
            repaired_tokens(RepairedTokens),
            parser_tokens(ParserTokens),
            parse_status(ParseStatus),
            parsed_sem(ParsedSem)
        )),
    print_cases(R).

classify_case(ok, GenTokens, RepairedTokens, ok, Sem, ParsedSem, pass_repaired) :-
    ParsedSem == Sem,
    GenTokens \== RepairedTokens,
    !.

classify_case(ok, GenTokens, RepairedTokens, ok, Sem, ParsedSem, pass) :-
    ParsedSem == Sem,
    GenTokens == RepairedTokens,
    !.

classify_case(gen_empty_yield, _, _, _, _, _, gen_empty_yield) :- !.
classify_case(gen_fail, _, _, _, _, _, gen_fail) :- !.
classify_case(error(_), _, _, _, _, _, gen_error) :- !.
classify_case(_, _, _, parse_skipped_empty_tokens, _, _, parse_skipped_empty_tokens) :- !.
classify_case(_, _, _, parse_fail, _, _, parse_fail) :- !.
classify_case(_, _, _, ok, _, _, semantic_mismatch).

print_totals(Cases) :-
    count_verdict(pass, Cases, Pass),
    count_verdict(pass_repaired, Cases, PassRepaired),
    count_verdict(gen_empty_yield, Cases, GenEmpty),
    count_verdict(gen_fail, Cases, GenFail),
    count_verdict(gen_error, Cases, GenError),
    count_verdict(parse_skipped_empty_tokens, Cases, ParseSkipped),
    count_verdict(parse_fail, Cases, ParseFail),
    count_verdict(semantic_mismatch, Cases, SemMismatch),

    nl,
    writeln('===== TOTALS ====='),
    format("PASS: ~d~n", [Pass]),
    format("PASS REPAIRED: ~d~n", [PassRepaired]),
    format("GEN EMPTY YIELD: ~d~n", [GenEmpty]),
    format("GEN FAIL: ~d~n", [GenFail]),
    format("GEN ERROR: ~d~n", [GenError]),
    format("PARSE SKIPPED EMPTY TOKENS: ~d~n", [ParseSkipped]),
    format("PARSE FAIL: ~d~n", [ParseFail]),
    format("SEMANTIC MISMATCH: ~d~n", [SemMismatch]),

    mg_logger:log_event(compare,
        totals(
            pass(Pass),
            pass_repaired(PassRepaired),
            gen_empty_yield(GenEmpty),
            gen_fail(GenFail),
            gen_error(GenError),
            parse_skipped_empty_tokens(ParseSkipped),
            parse_fail(ParseFail),
            semantic_mismatch(SemMismatch)
        )).

count_verdict(Verdict, Cases, Count) :-
    include(has_verdict(Verdict), Cases, Filtered),
    length(Filtered, Count).

has_verdict(Verdict, case(_, _, _, _, _, _, _, Verdict)).

/* ---------------------------------
   Write human-readable report file
--------------------------------- */

write_report_file(Cases) :-
    open('bidir_report.txt', write, S),
    write_report_cases(S, Cases),
    write_report_totals(S, Cases),
    close(S).

write_report_cases(_, []).
write_report_cases(S, [case(Sem, GenStatus, GenTokens, RepairedTokens, ParserTokens, ParseStatus, ParsedSem, Verdict)|R]) :-
    format(
        S,
        "~w | Sem=~q | Gen=~w | GenTokens=~w | Repaired=~w | ParserTokens=~w | Parse=~w | ParsedSem=~q~n",
        [Verdict, Sem, GenStatus, GenTokens, RepairedTokens, ParserTokens, ParseStatus, ParsedSem]
    ),
    write_report_cases(S, R).

write_report_totals(S, Cases) :-
    count_verdict(pass, Cases, Pass),
    count_verdict(pass_repaired, Cases, PassRepaired),
    count_verdict(gen_empty_yield, Cases, GenEmpty),
    count_verdict(gen_fail, Cases, GenFail),
    count_verdict(gen_error, Cases, GenError),
    count_verdict(parse_skipped_empty_tokens, Cases, ParseSkipped),
    count_verdict(parse_fail, Cases, ParseFail),
    count_verdict(semantic_mismatch, Cases, SemMismatch),

    nl(S),
    format(S, "===== TOTALS =====~n", []),
    format(S, "PASS: ~d~n", [Pass]),
    format(S, "PASS REPAIRED: ~d~n", [PassRepaired]),
    format(S, "GEN EMPTY YIELD: ~d~n", [GenEmpty]),
    format(S, "GEN FAIL: ~d~n", [GenFail]),
    format(S, "GEN ERROR: ~d~n", [GenError]),
    format(S, "PARSE SKIPPED EMPTY TOKENS: ~d~n", [ParseSkipped]),
    format(S, "PARSE FAIL: ~d~n", [ParseFail]),
    format(S, "SEMANTIC MISMATCH: ~d~n", [SemMismatch]).