:- module(mg_generate_wrapper, [
    generate/4,
    generate_safe/5
]).

:- use_module(lambdaSelect).
:- use_module(lambdaWorkspace).
:- use_module(library(time)).
:- use_module('../config/testbench_profile').

/*
-----------------------------------------------------------
MG Testbench – Generator Adapter
-----------------------------------------------------------

Purpose
-------
This adapter belongs to the bidirectional testbench, not to the
external MG generator implementation.

It wraps the existing MG generator and exposes two predicates:

  generate/4
      Direct generation call, preserved for compatibility.

  generate_safe/5
      Safe generation call used by the testbench.
      It returns structured status information instead of allowing
      timeouts, missing solutions, or exceptions to stop the pipeline.

Status values
-------------
  ok
      Generation succeeded.

  timeout
      Generation exceeded the configured adapter time limit.

  no_solution
      No generation result could be produced.

  error(E)
      An unexpected exception occurred.
*/


% =============================================================================
% Configuration
% =============================================================================

adapter_time_limit_seconds(Seconds) :-
    testbench_profile:adapter_timeout_seconds(Seconds),
    !.

adapter_time_limit_seconds(5).


% =============================================================================
% generate(+LogicExp, -SentenceAtom, -Lambda, -Tree)
% Compatibility predicate for direct generation.
% =============================================================================

generate(LogicExp, SentenceAtom, Lambda, Tree) :-
    once(lambdaSelect:lambdaSelectFkt(LogicExp, LambdaLIs)),
    lambdaLis_to_lis(LambdaLIs, LIs),
    adapter_time_limit_seconds(Limit),
    call_with_time_limit(Limit, lambdaWorkspace:generateExp(LIs, RawOut)),
    extract_top(RawOut, SentenceAtom, Lambda, Tree).


% =============================================================================
% generate_safe(+LogicExp, -SentenceAtom, -Lambda, -Tree, -Status)
% Safe predicate used by the testbench.
% =============================================================================

generate_safe(LogicExp, SentenceAtom, Lambda, Tree, Status) :-
    catch(
        generate_safe_(LogicExp, SentenceAtom, Lambda, Tree, Status),
        E,
        (
            empty_generation_result(SentenceAtom, Lambda, Tree),
            Status = error(E)
        )
    ).


generate_safe_(LogicExp, SentenceAtom, Lambda, Tree, Status) :-
    run_limited_once(
        lambdaSelect:lambdaSelectFkt(LogicExp, LambdaLIs),
        SelectStatus
    ),

    (   SelectStatus \== ok
    ->  empty_generation_result(SentenceAtom, Lambda, Tree),
        Status = SelectStatus
    ;   lambdaLis_to_lis(LambdaLIs, LIs),
        run_limited_once(
            lambdaWorkspace:generateExp(LIs, RawOut),
            GenerateStatus
        ),

        (   GenerateStatus \== ok
        ->  empty_generation_result(SentenceAtom, Lambda, Tree),
            Status = GenerateStatus
        ;   (   extract_top(RawOut, SentenceAtom, Lambda, Tree)
            ->  Status = ok
            ;   empty_generation_result(SentenceAtom, Lambda, Tree),
                Status = no_solution
            )
        )
    ).


% =============================================================================
% Shared execution helper
% =============================================================================

:- meta_predicate run_limited_once(0, -).

run_limited_once(Goal, Status) :-
    adapter_time_limit_seconds(Limit),
    catch(
        (   call_with_time_limit(Limit, once(Goal))
        ->  Status = ok
        ;   Status = no_solution
        ),
        time_limit_exceeded,
        Status = timeout
    ).


% =============================================================================
% Default result values
% =============================================================================

empty_generation_result('', none, none).


% =============================================================================
% Conversion: lambdaLi/5 -> li/3
% =============================================================================

lambdaLis_to_lis([], []).

lambdaLis_to_lis(
    [lambdaLi(Words, Fs, Sem, _Weight, _Path) | Rest],
    [li(Words, Fs, Sem) | Rest2]
) :-
    lambdaLis_to_lis(Rest, Rest2).


% =============================================================================
% Extraction
% =============================================================================

extract_top(li(Words, Fs, Lambda), SentenceAtom, Lambda, li(Words, Fs, Lambda)) :-
    words_to_atom(Words, SentenceAtom).

extract_top(
    tree([(Words, Fs, Lambda)|Chains], MG, L, R),
    SentenceAtom,
    Lambda,
    tree([(Words, Fs, Lambda)|Chains], MG, L, R)
) :-
    words_to_atom(Words, SentenceAtom).

extract_top([Tree|_], SentenceAtom, Lambda, TreeOut) :-
    extract_top(Tree, SentenceAtom, Lambda, TreeOut).


% =============================================================================
% Word conversion
% =============================================================================

words_to_atom(Words, Atom) :-
    is_list(Words),
    atomic_list_concat(Words, '', Atom).

words_to_atom(Atom, Atom) :-
    atom(Atom).