:- module(mg_parse_wrapper, [parse_safe/3]).

:- use_module(library(time)).
:- use_module(lcparser).

% parse_safe(+Tokens, -Tree, -Status)
% Status = ok | fail | timeout | error(E)

parse_safe(Tokens, Tree, Status) :-
    catch(
        catch(
            call_with_time_limit(5, lcParse(Tokens, Tree)),
            time_limit_exceeded,
            throw(timeout)
        ),
        timeout,
        ( Status = timeout, Tree = none )
    ),
    (   var(Status)
    ->  ( Tree \= [] -> Status = ok ; Status = fail )
    ;   true
    ).
