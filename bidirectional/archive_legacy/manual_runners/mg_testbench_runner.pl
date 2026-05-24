% file: mg_testbench_runner.pl

:- module(mg_testbench_runner, [
    run_gen_once/1,
    run_gen_suite/0,
    run_gen_trace_once/1,
    run_numbers_gen_suite/0
]).

:- use_module(mg_generate_wrapper).
:- use_module(lambdaSelect).
:- use_module(lambdaWorkspace).
:- use_module(library(time)).         % call_with_time_limit/2
:- use_module('helpers/mg_logger').

% =============================================================================
% CONFIG
% =============================================================================
gen_timeout_sec(5).

% =============================================================================
% LOCAL HELPERS
% =============================================================================

% Local copy (so runner does not depend on wrapper internals)
lambdaLis_to_lis([], []).
lambdaLis_to_lis(
    [lambdaLi(Words, Fs, Sem, _Weight, _Path) | Rest],
    [li(Words, Fs, Sem) | Rest2]
) :-
    lambdaLis_to_lis(Rest, Rest2).

% Console/protocol helper (optional, for trace)
protocol_line(Line) :-
    (   stream_property(_, alias(protocol))
    ->  format(protocol, "~w~n", [Line])
    ;   format("~w~n", [Line])
    ).

protocol_term(Label, Term) :-
    format(atom(A), "~w = ~q", [Label, Term]),
    protocol_line(A).

log_stage_error(Stage, Input, Error) :-
    format(atom(A),
           "ERROR Stage=~w Input=~q Error=~q",
           [Stage, Input, Error]),
    protocol_line(A).

% =============================================================================
% BASIC GENERATOR RUN (SAFE + NEVER HANGS)
% =============================================================================

run_gen_once(Input) :-
    gen_timeout_sec(Sec),
    % Defaults
    S0 = '',
    L0 = none,
    T0 = none,
    Status0 = no_solution,

    % Overall timeout: protects against hangs in lambdaSelect OR generation
    (   catch(
            catch(
                call_with_time_limit(Sec,
                    mg_generate_wrapper:generate_safe(Input, S, L, T, Status)
                ),
                time_limit_exceeded,
                (S = S0, L = L0, T = T0, Status = timeout_overall)
            ),
            E,
            (   E == time_limit_exceeded
            ->  S = S0, L = L0, T = T0, Status = timeout_overall
            ;   S = S0, L = L0, T = T0, Status = error(E)
            )
        )
    ->  true
    ;   (S = S0, L = L0, T = T0, Status = Status0)
    ),

    % Re-label: ok but empty sentence = relevant error case
    (   Status == ok,
        (S == '' ; S == "")
    ->  StatusOut = ok_empty_sentence
    ;   StatusOut = Status
    ),

    format("GEN ~w => Status=~w, S=~w, L=~w, T=~w~n",
           [Input, StatusOut, S, L, T]),

    % Always log one line per test
    mg_logger:log_event(gen,
        gen_result(input(Input), status(StatusOut), sentence(S), lambda(L), tree(T))
    ),
    true.

run_gen_suite :-
    mg_logger:log_event(system, start_suite(numbers)),
    % ---- expected successes (your older suite) ----
    run_gen_once(8),
    run_gen_once(13),
    run_gen_once(2),
    run_gen_once(plus30(5)),
    run_gen_once(plus20(6)),
    run_gen_once(mal10plus(4,7)),
    run_gen_once(mal100plus(4,7)),
    % ---- expected failures (your older suite) ----
    run_gen_once(bacon),
    run_gen_once(mal10plus80(4,7)),
    mg_logger:log_event(system, end_suite(numbers)),
    true.

run_numbers_gen_suite :-
    mg_logger:log_event(system, start_suite(numbers_gen)),

    % ---- should work (numbers_Gen lexicon semantics) ----
    run_gen_once(1),
    run_gen_once(20),
    run_gen_once('0X+100Y'(3,0)),
    run_gen_once('1X+20'(4)),
    run_gen_once('0X+18'(8)),
    run_gen_once('1X+10Y'(6,6)),   % expected timeout for now; should not freeze
    run_gen_once('1X+10'(4)),

    % ---- should not work / relevant error cases ----
    run_gen_once('1X+100Y'('1X+10Y'(6,4),5)),  % may timeout or empty sentence
    run_gen_once(bacon),

    mg_logger:log_event(system, end_suite(numbers_gen)),
    true.

% =============================================================================
% TRACE MODE (STEP-BY-STEP PIPELINE)
% NOTE: this is for debugging only; run_gen_once/1 is the official testbench run
% =============================================================================

run_gen_trace_once(Input) :-
    mg_logger:log_event(gen, trace_start(input(Input))),

    protocol_line(""),
    format(atom(H), "TRACE GEN INPUT = ~w", [Input]),
    protocol_line(H),

    % -------------------------------------------------
    % Stage 1: lambdaSelect (also protected by timeout)
    % -------------------------------------------------
    gen_timeout_sec(Sec),
    (   catch(
            call_with_time_limit(Sec,
                once(lambdaSelect:lambdaSelectFkt(Input, LambdaLIs))
            ),
            time_limit_exceeded,
            ( protocol_line("STAGE select RESULT = timeout"),
              mg_logger:log_event(gen, trace_stop(input(Input), stage(select), status(timeout))),
              !, fail
            )
        )
    ->  protocol_term("STAGE select LambdaLIs", LambdaLIs)
    ;   protocol_line("TRACE STOP: select failed"),
        mg_logger:log_event(gen, trace_stop(input(Input), stage(select), status(failed))),
        !
    ),

    % -------------------------------------------------
    % Stage 2: convert
    % -------------------------------------------------
    (   catch(
            lambdaLis_to_lis(LambdaLIs, LIs),
            E2,
            ( log_stage_error(convert, Input, E2),
              mg_logger:log_event(gen, trace_stop(input(Input), stage(convert), status(error(E2)))),
              fail
            )
        )
    ->  protocol_term("STAGE convert LIs", LIs)
    ;   protocol_line("TRACE STOP: convert failed"),
        !
    ),

    % -------------------------------------------------
    % Stage 3: generateExp with timeout
    % -------------------------------------------------
    catch(
        call_with_time_limit(Sec,
            lambdaWorkspace:generateExp(LIs, RawOut)
        ),
        time_limit_exceeded,
        RawOut = timeout
    ),

    (   RawOut == timeout
    ->  protocol_line("STAGE generateExp RESULT = timeout"),
        protocol_line("TRACE FINAL => Status=timeout"),
        mg_logger:log_event(gen, trace_end(input(Input), status(timeout))),
        format("TRACE GEN ~w => timeout~n", [Input]),
        !
    ;   protocol_term("STAGE generateExp RawOut", RawOut),

        % -------------------------------------------------
        % Stage 4: extract (we re-use wrapper logic)
        % -------------------------------------------------
        (   catch(
                mg_generate_wrapper:extract_top(RawOut, S, L, T),
                E3,
                ( log_stage_error(extract, Input, E3),
                  mg_logger:log_event(gen, trace_end(input(Input), status(error(E3)))),
                  fail
                )
            )
        ->  format(atom(Final),
                  "TRACE FINAL => Status=ok, S=~w, L=~w, T=~w",
                  [S, L, T]),
            protocol_line(Final),
            mg_logger:log_event(gen, trace_end(input(Input), status(ok), sentence(S), lambda(L), tree(T))),
            format("TRACE GEN ~w => ok~n", [Input])
        ;   protocol_line("TRACE FINAL => Status=no_solution"),
            mg_logger:log_event(gen, trace_end(input(Input), status(no_solution))),
            format("TRACE GEN ~w => no_solution~n", [Input])
        )
    ),
    true.
