% Auflistung der verwendeten Lexika
% Hierbei sollte stets nur ein Lexikon aktiv sein, der Rest sollte auskommentiert bleiben.
:- op(500, xfy, ::). % infix predicate for lexical items
:- op(500, fx, =). % for selection features
:- set_prolog_flag(encoding,utf8).
%:- [maus].
%:- ['Zahlen_avec_epsilon'].
%:-['Lexikon_test_full_sans'].
%:- ['German'].
%:- ['English'].
%:- ['de 10k'].
%:- ['de 1mio'].
:- ['German_trans'].


/*
* Nutzeraufruf.
*    Parsiert die eingegebene Tokelfolge X und gibt, wenn möglich, den 
*    erhaltenen Ableitungsbaum zurück. Mehrere Ableitungsbäume sind möglich.   
*
* @param X: Tokenfolge, der zu parsende Satz, in seine lexikalen Terme zerlegt
* @param T: Ableitungsbaum, das Ergebnis der Funktion.
*/
parse(X,T):- startCategory(D),init([(X,[D])],T),write("T= "),write(T).

/*
* Hilfsfunktionen zum Zerlegen von Listen.
*   Sie zerlegen die Liste X in zwei Teillisten L & R.
*       zerlegen1 gibt alle Zerlegungen von X aus, bei denen L & R nicht leer sind.
*       zerlegen2 gibt alle Zerlegungen von X aus, L & R dürfen leer sein.
*       zerlegenLeer gibt die Zerlegungen von X aus, bei denen mindestens eine Teilliste leer ist.
*   die 2. zerlegenLeer-Funktion spezifiziert als Eingabe [X|XS], um Redundanz zu vermeiden, wenn X leer ist.
*
* @param X: Eingabeliste
* @param L: linke Teilliste
* @param R: rechte Teilliste
*/
zerlegen1(X,L,R):-append(L,R,X),L\=[],R\=[].
zerlegen2(X,L,R):-append(L,R,X).
zerlegenLeer(X,L,R):- L=[],R=X.
zerlegenLeer([X|XS],L,R):- L=[X|XS],R=[].

/*
* Hilfsfunktion zum Auswählen möglicher Features.
*   D ist hierbei mit eine Variable als Head initialisiert.
*   Die Funktion bestimmt für alle Wörter aus S, ob eine Featureliste existiert, die auf D endet.
*   Ist dies der Fall, so werden alle verschiedenen Belegungen vom Head von D zurückgegeben.
*   Ist keine Belegung möglich, so wird false zurückgegeben.
*   featurelisteLeer erlaubt neben S auch leere Wörter aus dem Lexikon
*
* @param S: Liste mit Wörtern
* @param D: gewünschte Teil-Featureliste
* @param W: einzelnes Wort aus S
* @param F: Featureliste des Wortes W
*/
featureliste_sub(S,D):- member(W,S),::([W],F),zerlegen2(F,_,D).
featureliste(S,D):- distinct(D,featureliste_sub(S,D)).

featureliste_subLeer(S,D):- member(W,S),::([W],F),zerlegen2(F,_,D).
featureliste_subLeer(_,D):- ::([],F),zerlegen2(F,_,D).
featurelisteLeer(S,D):- distinct(D,featureliste_subLeer(S,D)).

/*
* Hilfsfunktion zur Umsetzung des Shortest-Movement-Constraints.
*   Erhält ein Feature D und die Liste der Sub-Terme als Eingabe und gibt True zurück,
*   wenn D in keiner Featureliste der Sub-Terme dem Head endspricht.
*
* @param D: zu überprüfendes Feature
* @param [(_,[-F|_])|YS]: Liste der Sub-Terme. Nur der Head der Featureliste ist relevant.
*/
smc(_,[]).
smc(D,[(_,[-F|_])|YS]):- D\=F, smc(D,YS).

/*
* Zentraler rekursiver Aufruf.
*   Erhält einen Term als Eingabe und überprüft, ob dieser als Ableitungsbaum erzeugt werden kann.
*   Dafür wird zunächst überpruft, ob der Term bereits ein lexikaler Term ist.
*   Danach werden die merge- und move-Funktionen rückwärts angewendet und die init-Funktion rekursiv auf
*   den entstehenden Teilbäumen ausgeführt.
*   Die Varianten mit leeren Wörtern wurden aus Performance-Gründen ausgelagert und werden erst am Ende überprüft.
*
* @param [(S,F)|Y]: Eingabe-Term mit
*   @param S: Tokenfolge
*   @param F: Featureliste
*   @param Y: Sub-Terme
* @param T: Ableitungsbaum
*/
init([([],F)],T):- ::([],F),T=li([],F).
init([([X],F)],T):- ::([X],F),T=li([X],F).
init([(S,F)|Y],T):- merge1([(S,F)|Y],T).
init([(S,F)|Y],T):- merge2([(S,F)|Y],T).
init([(S,F)|Y],T):- merge3([(S,F)|Y],T).
init([(S,F)|Y],T):- move1([(S,F)|Y],T).
init([(S,F)|Y],T):- move2([(S,F)|Y],T).
init([(S,F)|Y],T):- merge1Leer([(S,F)|Y],T).
init([(S,F)|Y],T):- merge2Leer([(S,F)|Y],T).
init([(S,F)|Y],T):- merge3Leer([(S,F)|Y],T).
init([(S,F)|Y],T):- move1Leer([(S,F)|Y],T).
init([(S,F)|Y],T):- move2Leer([(S,F)|Y],T).

/*
* Umsetzung der merge- und move- Funktionen. 
* Essentiell auch Teil des rekursiven init-Aufrufs, aber aus Übersichtlichskeitsgrünen ausgelagert.
* Jede Funktion setzt eine der Grundfunktionen invertiert um, die Versionen mit -Leer im Namen
* bilden die Funktionen speziell für leere Wörter ab.
*
* Die Parameter werden im Allgemeinen so  wie in den anderen Funktionen verwendet
*/
merge1([([X|XS],F)|Y],T):- XS\=[],
    ::([X],[=D|F]),
    init([(XS,[D])|Y],TR),T=tree([([X|XS],F)|Y],li([X],[=D|F]),TR).

merge1Leer([(S,F)|Y],T):- zerlegenLeer(S,L,R),
    ::(L,[=D|F]),
    init([(R,[D])|Y],TR),T=tree([(S,F)|Y],li(L,[=D|F]),TR).

merge2([(S,F)|Y],T):- zerlegen1(S,R,L),featureliste(L,[=D|F]),\+(::(L,[=D|F])),zerlegen2(Y,Y1,Y2),
    init([(L,[=D|F])|Y1],TL),
    init([(R,[D])|Y2],TR),T=tree([(S,F)|Y],TL,TR).

merge2Leer([(S,F)|Y],T):- zerlegenLeer(S,R,L),featurelisteLeer(L,[=D|F]),\+(::(L,[=D|F])),zerlegen2(Y,Y1,Y2),
    init([(L,[=D|F])|Y1],TL),
    init([(R,[D])|Y2],TR),T=tree([(S,F)|Y],TL,TR).

merge3([(S,F)|Y],T):- featureliste(S,[=D|F]),zerlegen2(Y,Y1,[(S2,F2)|Y2]),featureliste(S2,[D|F2]),
    init([(S,[=D|F])|Y1],TL),
    init([(S2,[D|F2])|Y2],TR),T=tree([(S,F)|Y],TL,TR).

merge3Leer([(S,F)|Y],T):- featurelisteLeer(S,[=D|F]),zerlegen2(Y,Y1,[(S2,F2)|Y2]),featurelisteLeer(S2,[D|F2]),
    init([(S,[=D|F])|Y1],TL),
    init([(S2,[D|F2])|Y2],TR),T=tree([(S,F)|Y],TL,TR).

move1([(S,F)|Y],T):- zerlegen1(S,L,R),featureliste(R,[+D|F]),smc(D,Y),zerlegen2(Y,Y1,Y2),
    append([[(R,[+D|F])],Y1,[(L,[-D])],Y2],X),init(X,TL),T=tree([(S,F)|Y],TL,epsilon).

move1Leer([(S,F)|Y],T):- zerlegenLeer(S,L,R),L\=[],featurelisteLeer(R,[+D|F]),smc(D,Y),zerlegen2(Y,Y1,Y2),
    append([[(R,[+D|F])],Y1,[(L,[-D])],Y2],X),init(X,TL),T=tree([(S,F)|Y],TL,epsilon).

move2([(S,F)|Y],T):- zerlegen2(Y,Y1,[(S2,F2)|Y2]),featureliste(S,[+D|F]),featureliste(S2,[-D|F2]),smc(D,Y1),smc(D,Y2),
    append([[(S,[+D|F])],Y1,[(S2,[-D|F2])],Y2],X),init(X,TL),T=tree([(S,F)|Y],TL,epsilon).

move2Leer([(S,F)|Y],T):- zerlegen2(Y,Y1,[(S2,F2)|Y2]),featurelisteLeer(S,[+D|F]),featurelisteLeer(S2,[-D|F2]),smc(D,Y1),smc(D,Y2),
    append([[(S,[+D|F])],Y1,[(S2,[-D|F2])],Y2],X),init(X,TL),T=tree([(S,F)|Y],TL,epsilon).



%+ smc testen
%+ move2 testen
%+ fehlerhafe Eingaben testen
%- leere Woerter
%- neue Lexika verwenden
%- eigene Lexika erstellen