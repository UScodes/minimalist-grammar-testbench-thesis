% file: bidirectional/load_bidir.pl
:- op(500, xfx, ::).   % make sure operator exists in user immediately

load_bidir :-
    % IMPORTANT: ensure operator also exists in the target modules
    % (these modules may not exist yet; op/3 is safe after consult)
    true,

    % ---- load generator stack ----
    consult('../SemanticGenerator/MG-Generator/lambdaSelect.pl'),
    consult('../SemanticGenerator/MG-Generator/lambdaWorkspace.pl'),
    consult('../SemanticGenerator/MG-Generator/mg_generate_wrapper.pl'),

    % ---- load parser + sem tools ----
    consult('../MG-LC-Parser-with-Semantic-main/lcparser.pl'),
    consult('../MG-LC-Parser-with-Semantic-main/sem_from_tree.pl'),

    % After lcparser is loaded, define operator inside its module too
    lcparser:op(500, xfx, ::),
    sem_from_tree:op(500, xfx, ::),
    lambdaSelect:op(500, xfx, ::),

    % ---- load lexicon loader + runner ----
    consult('lex_loader.pl'),
    consult('mg_bidir_runner.pl'),

    % load lexicons
    lex_loader:load_lexicons,

    true.