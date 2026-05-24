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
*/

parse_safe(Tokens, Tree, ok) :-
    catch(
        call_with_time_limit(
            5,
            once(lcparser:lcParse(Tokens, Tree))
        ),
        _,
        fail
    ),
    !.

parse_safe(_, none, fail).


parse_with_semantics_safe(Tokens, RawTree, SemanticTree, ok) :-
    catch(
        call_with_time_limit(
            5,
            (
                once(lcparser:lcParse(Tokens, [ParseTree])),
                workSpace(ParseTree, TreeSyn),
                lappend(TreeSyn, TreeSem),
                betaRoot(TreeSem, SemanticTree),
                RawTree = [ParseTree]
            )
        ),
        _,
        fail
    ),
    !.

parse_with_semantics_safe(_, none, none, fail).