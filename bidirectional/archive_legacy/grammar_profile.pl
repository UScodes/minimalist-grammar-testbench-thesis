:- module(grammar_profile, [
    validation_pipeline_gen_parse/1,
    validation_pipeline_parse_gen/1,

    generator_grammar_name/1,
    parser_grammar_name/1,

    generator_main_file/1,
    parser_load_file/1,
    parser_semantics_file/1
]).

/*
  Grammar profile for the bidirectional validation testbench.

  This file is the single place where the active generator/parser grammar
  identity is declared for reporting and loading.

  When a new grammar is provided, update this file instead of changing
  runner logic.
*/

validation_pipeline_gen_parse('Generation -> Parsing').
validation_pipeline_parse_gen('Parsing -> Generation').

generator_grammar_name('numbers_Gen').
parser_grammar_name('English_trans_pruned').

generator_main_file('../../SemanticGenerator/MG-Generator/main.pl').
parser_load_file('../../MG-LC-Parser-with-Semantic-main/load.pl').
parser_semantics_file('../../MG-LC-Parser-with-Semantic-main/sem_from_tree.pl').