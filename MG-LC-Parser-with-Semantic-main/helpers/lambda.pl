:- module(lambda,[beta/2,lappend/2,betaRoot/2]).
% file: lambda.pl
% origin author : J. Kuhn
% origin date: November 2024
% purpose: handles lambda calculus

:- op(500, xfy, ::). % infix predicate for lexical items
:- op(500, fx, =). % for selection features

%debugMode.	% comment this line, if debugMode should be off
debugMode:- false.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Variable/constant   -> currently no difference, except variable appear in Abstractions as a binding
%	i.e. f
% Application  -> consists of a function name F and an argument E, 
%	i.e. F(E);
%		F is a Variable or constant and E can be any lambda-expresiopmn
% Abstraction ->  consists an Abstraction X and an argument E,
%	i.e. abst(X,E)
%		X is a Variable and E can be any lambda-Expression.
% Reduction -> a construct for this modul, where a lambda-Expresion is in a position to be applied to an abstraction
%	i.e. red(abst(X,E),L)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% beta(+lambda-Exp,-lambda-Exp)
%
% Top most function of the beta-reduction as in normal order reduction
%	red(abst(),B) results in a beta-reduction
%	red(red(E,L),B) results in going deeper into the expresion red(E,L) first
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
beta(red(abst(X,E),L),B2):- 
	(debugMode->write("beta: found red/abst for "),
		write("X = "),write(X),
		write(", E = "),write(E),
		write(", L = "),writeln(L);true),
	beta_reduce(0,X,[E],L,[B1]),
	(debugMode->write("beta: returning "),writeln(B1);true),
	beta(B1,B2). % glory round to see if there is more to reduce
beta(red(red(E,L1),L2),B3) :- 
	(debugMode->writeln("beta: found red/red"),
		write("E = "),write(E),
		write(", L1 = "),write(L1),
		write(", L2 = "),writeln(L2);true),
	beta(red(E,L1),B1),
	(debugMode->write("beta: got "),writeln(B1);true),
	beta(red(B1,L2),B2),
	(debugMode->write("beta: returning "),writeln(B2);true),
	beta(B2,B3). % glory round to see if there is more to reduce
beta(E,B):- % catch if abstraction is deeper inside
	E =.. [F|Arg],not(Arg == []),!,
	(debugMode->write("beta: found something to potentially reduce inside "),
	write("E = "),writeln(E);true),
	betaLoop(Arg,NewArg),
	B =..[F|NewArg];
	E = B,
	(debugMode->write("beta: found nothing to reduce in "),
	write("E = "),writeln(E);true). 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% betaLoop(+[lambda-Exp],-[lambda-Exp])
%
% loop to get reduction deeper inside the expression
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
betaLoop([],[]).
betaLoop([L1|Ls],[B1|Bs]):-
	beta(L1,B1),
	betaLoop(Ls,Bs).
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% beta_reduce(+ID,+Variable,+[lambda-Exp],+lambda-Exp,-[Lamba-Exp])
%
%	abst(X,E) L
%	does the actual replacement of bound variable X with expression L in expression E
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
beta_reduce(Id,_,[],_,[]):- (debugMode->write(Id),write(": beta_reduce:"),writeln(" nothing to replace");true).
beta_reduce(Id,X,[X],L,[L]):-(debugMode->write(Id),write(": beta_reduce:"),writeln(" only one to replace");true).
beta_reduce(Id,X,[X|Args],L,[L|B2]):-
	(debugMode->write(Id),write(": beta_reduce:"),write(" something to replace and more to come in "),
		write("Args = "),writeln(Args);true),
	Id2 is Id + 1,
	beta_reduce(Id2,X,Args,L,B2),
	(debugMode->write(Id),write(": beta_reduce:"),write(" replace_true: returning: "),writeln([L|B2]);true).
beta_reduce(Id,X,[E|Es],L,[BE|BEs]):- 
	E =.. [_|Arg],not(Arg == []),!,				% E is an Application
	(debugMode->write(Id),write(": beta_reduce:"),write(" function found!"),write(" E = "),writeln(E),
		write(Id),write(": beta_reduce: going into Arg = "),writeln(Arg);true),
	Id2 is Id + 1,
	beta_reduce(Id2,X,Arg,L,BArg),
	(debugMode->write(Id),write(": beta_reduce:"),write("got BArg = "),writeln(BArg),
		write(Id),write(": beta_reduce:"),write(" Now making function with: "),writeln(F);true),
	functor(E,F,_),
	BE =.. [F|BArg],!,
	(debugMode->write(Id),write(": beta_reduce:"),write(" got reduced Function BE = "),writeln(BE);true),
	(debugMode->write(Id),write(": beta_reduce:"),write(" going into rest of list Es = "),writeln(Es);true),
	beta_reduce(Id2,X,Es,L,BEs),
	(debugMode->write(Id),write(": beta_reduce: function_true:"),write(" returning "),writeln([BE|BEs]);true); 
	(debugMode->write(Id),write(": beta_reduce:"),writeln(" not a function found!"),
		write(Id),write(": beta_reduce: going into rest of list Es = "),writeln(Es);true),
	Id2 is Id + 1,
	beta_reduce(Id2,X,Es,L,BEs), %E is not an Application
	BE = E,
	(debugMode->write(Id),write(": beta_reduce: function_false:"),write(" returning "),writeln([BE|BEs]);true).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	lappend(-Tree,+Tree).
%
%	takes a tree without lambda expressions and adds fitting 
%	lambda expressions from the lexicon
% NB: Die Kettenglieder müssen auch beachtet werden 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lappend(empty,empty).
lappend(li(W,F),li(W,F,S)):- W :: (F,S).
lappend(tree([(WT,FT)|_],empty,BR),tree([(WT,FT,ST)|Chain],empty,BRS)):-
	(debugMode->write("lappend:"),writeln("found unitary tree");true),
	lappend(BR,BRS),
	semMgMov(BRS,ST,Chain).
lappend(tree([(WT,FT)|_],BL,BR),tree([(WT,FT,ST)|Chain],BLS,BRS)):-
	(debugMode->write("lappend:"),writeln("found binary tree");true),
	lappend(BL,BLS),
	lappend(BR,BRS),
	semMgMer(BLS,BRS,ST,Chain).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% semMgMov(+Tree,-lambda-Exp,-[(W,Fs,lambda-Exp)])
%
% applies Move-Rule to lambda expression
% 	Move 1 -> Fuse lambda todether
% 	Move 2 -> keep lambda as is
% NB: ggf. Abbruchfälle schärfen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
semMgMov(tree([(_,[_|_],L1)],_,_),L1,[]):- writeln("Error in semMgMov!").
semMgMov(tree([(_,[+F|_],L1),(_,[-F],L2)|Chain],_,_),red(L1,L2),Chain).	%Move 1
semMgMov(tree([(_,[+F|_],L1),(WC,[-F|Fs],L2)|Chain],_,_),L1,[(WC,Fs,L2)|Chain]). %Move 2
semMgMov(tree([(WB,FB,L1),(WC,FC,L2)|ChainB],TL,TR),ST,Chain):- 
	semMgMov(tree([(WB,FB,L1)|ChainB],TL,TR),ST,ChainDeep),
	Chain = [(WC,FC,L2)|ChainDeep].
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% semMgMer(+Tree,+Tree,-lambda-Exp,-[(W,Fs,lambda-Exp)])
%
% applies Merge-Rule to lambda expression 
% 	Merge 1 and 2 -> Fuse lambda todether
% 	Merge 3 -> keep lambda as is
% NB: Die Kettenglieder müssen auch beachtet werden 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
semMgMer(li(_,[=F|_],L1),li(_,[F],L2),red(L1,L2),[]).	%Merge 1
semMgMer(li(_,[=F|_],L1),tree([(_,[F],L2)|Chain],_,_),red(L1,L2),Chain).	%Merge 1
semMgMer(tree([(_,[=F|_],L1)|Chain],_,_),li(_,[F],L2),red(L1,L2),Chain).	%Merge 2
semMgMer(tree([(_,[=F|_],L1)|ChainB],_,_),tree([(_,[F],L2)|ChainC],_,_),red(L1,L2),Chain):- %Merge 2
	append(ChainB,ChainC,Chain).	
semMgMer(li(_,[=F|_],L1),li(W,[F|Fs],L2),L1,[(W,Fs,L2)]). %Merge 3	
semMgMer(li(_,[=F|_],L1),tree([(W,[F|Fs],L2)|ChainC],_,_),L1,[(W,Fs,L2)|ChainC]). %Merge3
semMgMer(tree([(_,[=F|_],L1)|ChainB],_,_),tree([(W,[F|Fs],L2)|ChainC],_,_),L1,[(W,Fs,L2)|Chain]):-	%Merge 3
	append(ChainB,ChainC,Chain).
semMgMer(tree([(_,[=F|_],L1)|ChainB],_,_),li(W,[F|Fs],L2),L1,[(W,Fs,L2)|ChainB]). %Merge 3

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% betaRoot(+tree, -tree)
%
% beta-reduces the root of tree
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
betaRoot(tree([(W,F,S)],TL,TR),tree([(W,F,SR)],TL,TR)):-
	beta(S,SR).
betaRoot(li(W,F,S),li(W,F,SR)):-
	beta(S,SR). % in the case of reducable lambda expressions in the lexicon
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% working Tests for beta-function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% beta(red(abst(x,x),3),B).
% beta(red(abst(x,mal10(x)),3),B).
% beta(red(red(abst(x,abst(y,mal10plus(x,y))),3),7),B).
% beta(red(abst(x,3),4),B).
