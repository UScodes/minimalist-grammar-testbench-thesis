:- module(mg_generate_wrapper, [
    generate/4,
    generate_safe/5
]).

:- use_module(lambdaSelect).
:- use_module(lambdaWorkspace).
:- use_module(library(time)).   % call_with_time_limit/2

% =============================================================================
% generate(+LogicExp, -SentenceAtom, -Lambda, -Tree)
% (your working version, unchanged)
% =============================================================================
generate(LogicExp, SentenceAtom, Lambda, Tree) :-
    once(lambdaSelect:lambdaSelectFkt(LogicExp, LambdaLIs)),
    lambdaLis_to_lis(LambdaLIs, LIs),
    call_with_time_limit(5, lambdaWorkspace:generateExp(LIs, RawOut)),
    extract_top(RawOut, SentenceAtom, Lambda, Tree).

% =============================================================================
% generate_safe(+LogicExp, -SentenceAtom, -Lambda, -Tree, -Status)
% Status: ok | timeout | error(E) | no_solution
% =============================================================================
generate_safe(LogicExp, SentenceAtom, Lambda, Tree, Status) :-
    catch(
        (
            % 1) lexicon selection must succeed once
            (   once(lambdaSelect:lambdaSelectFkt(LogicExp, LambdaLIs))
            ->  true
            ;   Status = no_solution,
                SentenceAtom = '',
                Lambda = none,
                Tree = none,
                !
            ),

            % 2) convert lambdaLi/5 -> li/3
            lambdaLis_to_lis(LambdaLIs, LIs),

            % 3) generation under timeout
            (   catch(
                    call_with_time_limit(5, lambdaWorkspace:generateExp(LIs, RawOut)),
                    time_limit_exceeded,
                    ( Status = timeout )
                )
            ->  true
            ;   % generation failed normally
                Status = no_solution,
                SentenceAtom = '',
                Lambda = none,
                Tree = none,
                !
            ),

            % if timeout happened, return immediately with defaults
            (   Status == timeout
            ->  SentenceAtom = '',
                Lambda = none,
                Tree = none,
                !
            ;   true
            ),

            % 4) extract output
            (   extract_top(RawOut, SentenceAtom, Lambda, Tree)
            ->  Status = ok
            ;   Status = no_solution,
                SentenceAtom = '',
                Lambda = none,
                Tree = none
            )
        ),
        E,
        (
            Status = error(E),
            SentenceAtom = '',
            Lambda = none,
            Tree = none
        )
    ).

% ---------------- Conversion ----------------
lambdaLis_to_lis([], []).
lambdaLis_to_lis(
    [lambdaLi(Words, Fs, Sem, _Weight, _Path) | Rest],
    [li(Words, Fs, Sem) | Rest2]
) :-
    lambdaLis_to_lis(Rest, Rest2).

% ---------------- Extraction ----------------
extract_top(li(Words, Fs, Lambda), SentenceAtom, Lambda, li(Words, Fs, Lambda)) :-
    words_to_atom(Words, SentenceAtom).

extract_top(tree([(Words, Fs, Lambda)|Chains], MG, L, R),
            SentenceAtom, Lambda,
            tree([(Words, Fs, Lambda)|Chains], MG, L, R)) :-
    words_to_atom(Words, SentenceAtom).

extract_top([Tree|_], SentenceAtom, Lambda, TreeOut) :-
    extract_top(Tree, SentenceAtom, Lambda, TreeOut).

% ---------------- Words ----------------
words_to_atom(Words, Atom) :-
    is_list(Words),
    atomic_list_concat(Words, '', Atom).
