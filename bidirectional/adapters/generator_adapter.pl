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

Important design point
----------------------
The timeout is grammar-independent. The adapter does not check whether
a semantic input is valid for a particular grammar. Instead, every
generation attempt is given the configured amount of time. If the
generator does not finish within that limit, the adapter returns the
status timeout.

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
%
% This predicate is preserved for compatibility with older calls, but it now
% delegates to generate_safe/5. This means old calls also benefit from the same
% timeout boundary. If generation does not succeed with status ok, this predicate
% simply fails.
% =============================================================================

generate(LogicExp, SentenceAtom, Lambda, Tree) :-
    generate_safe(LogicExp, SentenceAtom, Lambda, Tree, ok).


% =============================================================================
% generate_safe(+LogicExp, -SentenceAtom, -Lambda, -Tree, -Status)
% Safe predicate used by the testbench.
%
% The timeout wraps the complete generation attempt:
%
%   1. lambda selection
%   2. conversion from lambdaLi/5 to li/3
%   3. workspace generation
%   4. output extraction
%
% This is intentionally grammar-independent. Inputs that lead to long or
% non-terminating generator search are classified by timeout, not by hard-coded
% semantic validation.
% =============================================================================

generate_safe(LogicExp, SentenceAtom, Lambda, Tree, Status) :-
    adapter_time_limit_seconds(Limit),
    catch(
        (
            call_with_time_limit(
                Limit,
                once(generate_attempt(LogicExp, SentenceAtom, Lambda, Tree))
            )
        ->  Status = ok
        ;   empty_generation_result(SentenceAtom, Lambda, Tree),
            Status = no_solution
        ),
        Error,
        handle_generation_exception(Error, SentenceAtom, Lambda, Tree, Status)
    ).


% =============================================================================
% Full generation attempt
% =============================================================================

generate_attempt(LogicExp, SentenceAtom, Lambda, Tree) :-
    lambdaSelect:lambdaSelectFkt(LogicExp, LambdaLIs),
    lambdaLis_to_lis(LambdaLIs, LIs),
    lambdaWorkspace:generateExp(LIs, RawOut),
    extract_top(RawOut, SentenceAtom, Lambda, Tree).


% =============================================================================
% Exception handling
% =============================================================================

handle_generation_exception(time_limit_exceeded, SentenceAtom, Lambda, Tree, timeout) :-
    !,
    empty_generation_result(SentenceAtom, Lambda, Tree).

handle_generation_exception(Error, SentenceAtom, Lambda, Tree, error(Error)) :-
    empty_generation_result(SentenceAtom, Lambda, Tree).


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