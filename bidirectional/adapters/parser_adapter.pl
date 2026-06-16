:- module(mg_parse_wrapper, [
    parse_safe/3,
    parse_with_semantics_safe/4
]).

:- use_module(library(time)).
:- use_module('../config/testbench_profile').

/*
-----------------------------------------------------------
MG Testbench – Parser Adapter
-----------------------------------------------------------

Purpose
-------
This adapter belongs to the bidirectional testbench, not to the
external parser implementation.

It wraps the existing MG left-corner parser and exposes two safe
predicates:

  parse_safe/3
      Runs lcParse/2 and returns the raw parser tree.

  parse_with_semantics_safe/4
      Runs the parser's internal semantic pipeline:

          lcParse/2
          -> workSpace/2
          -> lappend/2
          -> betaRoot/2

      This exposes the parser's semantic output through a stable
      testbench-facing interface.

Important design point
----------------------
The timeout is grammar-independent. The adapter does not check whether
a token sequence is valid for a particular grammar. Instead, every
parsing attempt is given the configured amount of time. If the parser
does not finish within that limit, the adapter returns timeout.

Status values
-------------
  ok
      Parsing succeeded.

  timeout
      Parsing exceeded the configured adapter time limit.

  no_solution
      No parse or semantic result could be produced.

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
% parse_safe(+Tokens, -Tree, -Status)
%
% Safe parser call that returns the raw parser output.
% The timeout wraps the complete parse attempt.
% =============================================================================

parse_safe(Tokens, Tree, Status) :-
    adapter_time_limit_seconds(Limit),
    catch(
        (
            call_with_time_limit(
                Limit,
                once(parse_attempt(Tokens, Tree))
            )
        ->  Status = ok
        ;   Tree = none,
            Status = no_solution
        ),
        Error,
        handle_parse_exception(Error, Tree, Status)
    ).


% =============================================================================
% parse_with_semantics_safe(+Tokens, -RawTree, -SemanticTree, -Status)
%
% Safe parser call used by the main testbench.
% The timeout wraps the complete parser-side semantic pipeline:
%
%   1. lcParse/2
%   2. workSpace/2
%   3. lappend/2
%   4. betaRoot/2
%
% This is intentionally grammar-independent. Token inputs that lead to long
% parser search are classified by timeout, not by hard-coded validation.
% =============================================================================

parse_with_semantics_safe(Tokens, RawTree, SemanticTree, Status) :-
    adapter_time_limit_seconds(Limit),
    catch(
        (
            call_with_time_limit(
                Limit,
                once(parse_with_semantics_attempt(Tokens, RawTree, SemanticTree))
            )
        ->  Status = ok
        ;   empty_parse_result(RawTree, SemanticTree),
            Status = no_solution
        ),
        Error,
        handle_parse_with_semantics_exception(Error, RawTree, SemanticTree, Status)
    ).


% =============================================================================
% Full parse attempts
% =============================================================================

parse_attempt(Tokens, Tree) :-
    lcparser:lcParse(Tokens, Tree).


parse_with_semantics_attempt(Tokens, RawTree, SemanticTree) :-
    lcparser:lcParse(Tokens, [ParseTree]),
    workSpace(ParseTree, TreeSyn),
    lappend(TreeSyn, TreeSem),
    betaRoot(TreeSem, SemanticTree),
    RawTree = [ParseTree].


% =============================================================================
% Exception handling
% =============================================================================

handle_parse_exception(time_limit_exceeded, Tree, timeout) :-
    !,
    Tree = none.

handle_parse_exception(Error, Tree, error(Error)) :-
    Tree = none.


handle_parse_with_semantics_exception(time_limit_exceeded, RawTree, SemanticTree, timeout) :-
    !,
    empty_parse_result(RawTree, SemanticTree).

handle_parse_with_semantics_exception(Error, RawTree, SemanticTree, error(Error)) :-
    empty_parse_result(RawTree, SemanticTree).


% =============================================================================
% Default result values
% =============================================================================

empty_parse_result(none, none).