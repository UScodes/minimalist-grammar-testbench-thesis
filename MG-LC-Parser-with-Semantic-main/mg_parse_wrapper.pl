:- module(mg_parse_wrapper, [
    parse_safe/3,
    parse_with_semantics_safe/4
]).

:- use_module(lcparser).
:- use_module(library(time)).

/*
-----------------------------------------------------------
MG LC Parser Wrapper
-----------------------------------------------------------

parse_safe/3
------------
Runs the raw left-corner parser and returns the raw derivation tree.

parse_with_semantics_safe/4
---------------------------
Runs the parser's intended semantic pipeline:

    lcParse/2
    -> workSpace/2
    -> lappend/2
    -> betaRoot/2

This avoids reconstructing semantics manually in sem_from_tree.pl.
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