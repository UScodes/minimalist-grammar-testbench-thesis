% file: MG-LC-Parser-with-Semantic-main/sem_from_tree.pl
:- module(sem_from_tree, [
    sem_from_parse_result/2,
    sem_from_tree/2
]).

% We read lexicon entries from lex_en namespace
% (loaded by bidirectional/lex_loader.pl)
:- op(500, xfx, ::).

sem_from_parse_result([Tree], Sem) :- !, sem_from_tree(Tree, Sem).
sem_from_parse_result(Tree, Sem) :- sem_from_tree(Tree, Sem).

% Leaves: parser has li([Tok], Fs) (no semantics) OR sometimes li([Tok], Fs, Sem)
sem_from_tree(li([Tok], Fs), Sem) :-
    lex_en:[Tok] :: (Fs, Sem),
    !.
sem_from_tree(li(_Words, _Fs, Sem), Sem) :- !.

% ignore move wrapper
sem_from_tree(empty, empty) :- !.

% passthrough gap cases
sem_from_tree(tree(_, empty, Right), Sem) :- !, sem_from_tree(Right, Sem).
sem_from_tree(tree(_, Left, empty), Sem) :- !, sem_from_tree(Left, Sem).

% merge: compute Sem by functional application if possible
sem_from_tree(tree(_, Left, Right), SemOut) :-
    sem_from_tree(Left, SemL),
    sem_from_tree(Right, SemR),
    apply_sem(SemL, SemR, SemOut),
    !.

% fallback
sem_from_tree(Tree, unknown_sem(Tree)).

apply_sem(abst(X, Body), Arg, Out) :- substitute(Body, X, Arg, Out), !.
apply_sem(Arg, abst(X, Body), Out) :- substitute(Body, X, Arg, Out), !.
apply_sem(A, B, app(A,B)).

substitute(Var, Var, Value, Value) :- !.
substitute(Term, _Var, _Value, Term) :- atomic(Term), !.
substitute(Term, Var, Value, Out) :-
    Term =.. [F|Args],
    maplist(subst_arg(Var, Value), Args, Args2),
    Out =.. [F|Args2].

subst_arg(Var, Value, In, Out) :- substitute(In, Var, Value, Out).