:- module(sem_utils, [
    extract_semantics/2
]).

% Public entry
extract_semantics(Term, Sem) :-
    extract_semantics_(Term, [], Sem).

% -------------------------
% Cycle guard
% -------------------------
extract_semantics_(Term, Seen, unknown) :-
    memberchk(Term, Seen), !.

% If lcParse returns a list of analyses, take the first.
extract_semantics_([X|_], Seen, Sem) :- !,
    extract_semantics_(X, [ [X|_] | Seen], Sem).

% Generator-style leaf with semantics
extract_semantics_(li(_, _, Sem), _Seen, Sem) :- !.

% Parser leaf without semantics
extract_semantics_(li(_, _), _Seen, unknown) :- !.

% If you ever see the "head triple list" form
extract_semantics_([( _W, _Fs, Sem )|_], _Seen, Sem) :- !.

% Common non-structures
extract_semantics_(empty, _Seen, unknown) :- !.
extract_semantics_(gapTree, _Seen, unknown) :- !.

% Parser tree: tree(Head, Left, Right)
extract_semantics_(tree(Head, Left, Right), Seen, Sem) :- !,
    % add current node to Seen to avoid loops
    Seen1 = [tree(Head, Left, Right) | Seen],
    % try head first
    (   extract_semantics_(Head, Seen1, Sem),
        Sem \== unknown
    ->  true
    ;   extract_semantics_(Left, Seen1, Sem),
        Sem \== unknown
    ->  true
    ;   extract_semantics_(Right, Seen1, Sem),
        Sem \== unknown
    ->  true
    ;   Sem = unknown
    ).

% Fallback
extract_semantics_(_, _Seen, unknown).