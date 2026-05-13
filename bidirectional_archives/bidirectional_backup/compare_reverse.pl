:- use_module('../SemanticGenerator/MG-Generator/helpers/mg_logger').

:- initialization(main, main).

main :-
    mg_logger:log_event(system, compare_reverse_start),
    consult('reverse_out.pl'),
    summarize,
    mg_logger:log_event(system, compare_reverse_end),
    halt.

/*
Verdicts:
- reverse_pass
- reverse_pass_repairable
- reverse_parse_fail
- reverse_gen_skipped
- reverse_gen_empty_yield
- reverse_gen_fail
- reverse_gen_error
- reverse_token_mismatch
*/

summarize :-
    findall(
        case(InputTokens, ParseStatus, ParsedSem, GenStatus, RawGenTokens, NormGenTokens, Verdict),
        classified_case(InputTokens, ParseStatus, ParsedSem, GenStatus, RawGenTokens, NormGenTokens, Verdict),
        Cases
    ),
    print_cases(Cases),
    print_totals(Cases),
    write_report_file(Cases).

classified_case(InputTokens, ParseStatus, ParsedSem, GenStatus, RawGenTokens, NormGenTokens, Verdict) :-
    reverse_case(InputTokens, ParseStatus, ParsedSem, GenStatus, RawGenTokens, NormGenTokens),
    classify_case(InputTokens, ParseStatus, ParsedSem, GenStatus, RawGenTokens, NormGenTokens, Verdict).

print_cases([]).
print_cases([case(InputTokens, ParseStatus, ParsedSem, GenStatus, RawGenTokens, NormGenTokens, Verdict)|R]) :-
    format(
        "~w | Input=~q | Parse=~w | ParsedSem=~q | Gen=~w | RawGenTokens=~w | NormGenTokens=~w~n",
        [Verdict, InputTokens, ParseStatus, ParsedSem, GenStatus, RawGenTokens, NormGenTokens]
    ),
    mg_logger:log_event(compare_reverse,
        case_result(
            verdict(Verdict),
            input_tokens(InputTokens),
            parse_status(ParseStatus),
            parsed_sem(ParsedSem),
            gen_status(GenStatus),
            raw_gen_tokens(RawGenTokens),
            normalized_gen_tokens(NormGenTokens)
        )),
    print_cases(R).

/* ---------------------------------
   Verdict classification
--------------------------------- */

classify_case(InputTokens, ok, _ParsedSem, ok, _RawGenTokens, NormGenTokens, reverse_pass) :-
    InputTokens == NormGenTokens,
    !.

classify_case(InputTokens, ok, ParsedSem, ok, RawGenTokens, NormGenTokens, reverse_pass_repairable) :-
    repairable_reverse_case(InputTokens, ParsedSem, RawGenTokens, NormGenTokens),
    !.

classify_case(_, parse_fail, _ParsedSem, gen_skipped, _RawGenTokens, _NormGenTokens, reverse_parse_fail) :- !.
classify_case(_, _, _ParsedSem, gen_skipped, _RawGenTokens, _NormGenTokens, reverse_gen_skipped) :- !.
classify_case(_, _, _ParsedSem, gen_empty_yield, _RawGenTokens, _NormGenTokens, reverse_gen_empty_yield) :- !.
classify_case(_, _, _ParsedSem, gen_fail, _RawGenTokens, _NormGenTokens, reverse_gen_fail) :- !.
classify_case(_, _, _ParsedSem, error(_), _RawGenTokens, _NormGenTokens, reverse_gen_error) :- !.
classify_case(_, ok, _ParsedSem, ok, _RawGenTokens, _NormGenTokens, reverse_token_mismatch).

/* ---------------------------------
   Known repairable reverse cases
--------------------------------- */

repairable_reverse_case([twenty_, Unit], '1X+20'(N), [twenty], [twenty]) :-
    unit_matches(Unit, N).
repairable_reverse_case([thirty_, Unit], '1X+30'(N), [thirty], [thirty]) :-
    unit_matches(Unit, N).
repairable_reverse_case([fifty_, Unit], '1X+50'(N), [fifty], [fifty]) :-
    unit_matches(Unit, N).

unit_matches(one,   1).
unit_matches(two,   2).
unit_matches(three, 3).
unit_matches(four,  4).
unit_matches(five,  5).
unit_matches(six,   6).
unit_matches(seven, 7).
unit_matches(eight, 8).
unit_matches(nine,  9).

/* ---------------------------------
   Totals
--------------------------------- */

print_totals(Cases) :-
    count_verdict(reverse_pass, Cases, Pass),
    count_verdict(reverse_pass_repairable, Cases, PassRepairable),
    count_verdict(reverse_parse_fail, Cases, ParseFail),
    count_verdict(reverse_gen_skipped, Cases, GenSkipped),
    count_verdict(reverse_gen_empty_yield, Cases, GenEmpty),
    count_verdict(reverse_gen_fail, Cases, GenFail),
    count_verdict(reverse_gen_error, Cases, GenError),
    count_verdict(reverse_token_mismatch, Cases, TokenMismatch),

    nl,
    writeln('===== REVERSE TOTALS ====='),
    format("REVERSE PASS: ~d~n", [Pass]),
    format("REVERSE PASS REPAIRABLE: ~d~n", [PassRepairable]),
    format("REVERSE PARSE FAIL: ~d~n", [ParseFail]),
    format("REVERSE GEN SKIPPED: ~d~n", [GenSkipped]),
    format("REVERSE GEN EMPTY YIELD: ~d~n", [GenEmpty]),
    format("REVERSE GEN FAIL: ~d~n", [GenFail]),
    format("REVERSE GEN ERROR: ~d~n", [GenError]),
    format("REVERSE TOKEN MISMATCH: ~d~n", [TokenMismatch]),

    mg_logger:log_event(compare_reverse,
        totals(
            reverse_pass(Pass),
            reverse_pass_repairable(PassRepairable),
            reverse_parse_fail(ParseFail),
            reverse_gen_skipped(GenSkipped),
            reverse_gen_empty_yield(GenEmpty),
            reverse_gen_fail(GenFail),
            reverse_gen_error(GenError),
            reverse_token_mismatch(TokenMismatch)
        )).

count_verdict(Verdict, Cases, Count) :-
    include(has_verdict(Verdict), Cases, Filtered),
    length(Filtered, Count).

has_verdict(Verdict, case(_, _, _, _, _, _, Verdict)).

/* ---------------------------------
   Write reverse report file
--------------------------------- */

write_report_file(Cases) :-
    open('reverse_report.txt', write, S),
    write_report_cases(S, Cases),
    write_report_totals(S, Cases),
    close(S).

write_report_cases(_, []).
write_report_cases(S, [case(InputTokens, ParseStatus, ParsedSem, GenStatus, RawGenTokens, NormGenTokens, Verdict)|R]) :-
    format(
        S,
        "~w | Input=~q | Parse=~w | ParsedSem=~q | Gen=~w | RawGenTokens=~w | NormGenTokens=~w~n",
        [Verdict, InputTokens, ParseStatus, ParsedSem, GenStatus, RawGenTokens, NormGenTokens]
    ),
    write_report_cases(S, R).

write_report_totals(S, Cases) :-
    count_verdict(reverse_pass, Cases, Pass),
    count_verdict(reverse_pass_repairable, Cases, PassRepairable),
    count_verdict(reverse_parse_fail, Cases, ParseFail),
    count_verdict(reverse_gen_skipped, Cases, GenSkipped),
    count_verdict(reverse_gen_empty_yield, Cases, GenEmpty),
    count_verdict(reverse_gen_fail, Cases, GenFail),
    count_verdict(reverse_gen_error, Cases, GenError),
    count_verdict(reverse_token_mismatch, Cases, TokenMismatch),

    nl(S),
    format(S, "===== REVERSE TOTALS =====~n", []),
    format(S, "REVERSE PASS: ~d~n", [Pass]),
    format(S, "REVERSE PASS REPAIRABLE: ~d~n", [PassRepairable]),
    format(S, "REVERSE PARSE FAIL: ~d~n", [ParseFail]),
    format(S, "REVERSE GEN SKIPPED: ~d~n", [GenSkipped]),
    format(S, "REVERSE GEN EMPTY YIELD: ~d~n", [GenEmpty]),
    format(S, "REVERSE GEN FAIL: ~d~n", [GenFail]),
    format(S, "REVERSE GEN ERROR: ~d~n", [GenError]),
    format(S, "REVERSE TOKEN MISMATCH: ~d~n", [TokenMismatch]).