% file: bidirectional/lex_loader.pl
:- module(lex_loader, [
    load_lexicons/0
]).

/*
  Loads BOTH lexicons into separate modules (namespaces):

  - Parser lexicon    -> module lex_en
  - Generator lexicon -> module lex_gen

  This prevents ::/2 and startCategory/1 collisions.
*/

english_lexicon_path('../MG-LC-Parser-with-Semantic-main/grammars/English_trans_pruned.pl').
numbers_gen_lexicon_path('../SemanticGenerator/MG-Generator/grammars/numbers_Gen.pl').

load_lexicons :-
    english_lexicon_path(EN),
    numbers_gen_lexicon_path(GEN),

    % IMPORTANT: define operator inside target modules BEFORE loading
    lex_en:op(500, xfx, ::),
    lex_gen:op(500, xfx, ::),

    % Load each grammar into its own module namespace
    load_files(EN,  [module(lex_en),  if(true)]),
    load_files(GEN, [module(lex_gen), if(true)]).