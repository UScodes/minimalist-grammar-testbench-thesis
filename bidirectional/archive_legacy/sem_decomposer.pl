:- module(sem_decomposer, [
    semantic_input/2
]).

/*
  semantic_input(+Sem, -GenInput)

  Converts numeric semantics into generator-friendly input
  WITHOUT changing the grammar.
*/

% -------------------------
% Atomic values (directly generatable)
% -------------------------
semantic_input(Sem, Sem) :-
    integer(Sem),
    Sem < 20,
    !.

semantic_input(20, twenty).
semantic_input(30, thirty).
semantic_input(40, forty).
semantic_input(50, fifty).
semantic_input(60, sixty).
semantic_input(70, seventy).
semantic_input(80, eighty).
semantic_input(90, ninety).

% -------------------------
% 21–99 : tens + ones
% -------------------------
semantic_input(N, Term) :-
    integer(N),
    N >= 21,
    N < 100,
    Tens is (N // 10) * 10,
    Ones is N mod 10,
    Ones > 0,
    tens_functor(Tens, Fun),
    Term =.. [Fun, Ones].

% -------------------------
% Grammar-aligned functors
% -------------------------
tens_functor(20, twenty_).
tens_functor(30, thirty_).
tens_functor(40, forty_).
tens_functor(50, fifty_).
tens_functor(60, sixty_).
tens_functor(70, seventy_).
tens_functor(80, y_).
tens_functor(90, ninety_).
