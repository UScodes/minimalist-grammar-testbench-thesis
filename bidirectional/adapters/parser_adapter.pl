:- module(mg_parse_wrapper, [
    parse_safe/3,
    parse_with_semantics_safe/4
]).

:- use_module(library(time)).

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

      This avoids using the old sem_from_tree.pl reconstruction file.

Status values
-------------
  ok
      Parsing succeeded.

  timeout
      Parsing exceeded the adapter time limit.

  no_solution
      No parse or semantic result could be produced.

  error(E)
      An unexpected exception occurred.
*/

% =============================================================================
% Configuration
% =============================================================================

adapter_time_limit_seconds(5).


% =============================================================================
% parse_safe(+Tokens, -Tree, -Status)
% =============================================================================

parse_safe(Tokens, Tree, Status) :-
    catch(
        parse_safe_(Tokens, Tree, Status),
        E,
        (
            Tree = none,
            Status = error(E)
        )
    ).

parse_safe_(Tokens, Tree, Status) :-
    run_limited_once(
        lcparser:lcParse(Tokens, Tree),
        ParseStatus
    ),
    (
        ParseStatus == ok
    ->  Status = ok
    ;   Tree = none,
        Status = ParseStatus
    ).


% =============================================================================
% parse_with_semantics_safe(+Tokens, -RawTree, -SemanticTree, -Status)
% =============================================================================

parse_with_semantics_safe(Tokens, RawTree, SemanticTree, Status) :-
    catch(
        parse_with_semantics_safe_(Tokens, RawTree, SemanticTree, Status),
        E,
        (
            empty_parse_result(RawTree, SemanticTree),
            Status = error(E)
        )
    ).

parse_with_semantics_safe_(Tokens, RawTree, SemanticTree, Status) :-
    run_limited_once(
        (
            lcparser:lcParse(Tokens, [ParseTree]),
            workSpace(ParseTree, TreeSyn),
            lappend(TreeSyn, TreeSem),
            betaRoot(TreeSem, SemanticTree0),
            RawTree0 = [ParseTree]
        ),
        ParseStatus
    ),
    (
        ParseStatus == ok
    ->  RawTree = RawTree0,
        SemanticTree = SemanticTree0,
        Status = ok
    ;   empty_parse_result(RawTree, SemanticTree),
        Status = ParseStatus
    ).


% =============================================================================
% Shared execution helper
% =============================================================================

:- meta_predicate run_limited_once(0, -).

run_limited_once(Goal, Status) :-
    adapter_time_limit_seconds(Limit),
    catch(
        (
            call_with_time_limit(Limit, once(Goal))
        ->  Status = ok
        ;   Status = no_solution
        ),
        time_limit_exceeded,
        Status = timeout
    ).


% =============================================================================
% Default result values
% =============================================================================

empty_parse_result(none, none).