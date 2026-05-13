:- module(testbench_profile, [
    profile_name/1,

    validation_pipeline_gen_parse/1,
    validation_pipeline_parse_gen/1,

    generator_name/1,
    parser_name/1,

    generator_main_file/1,
    parser_load_file/1,
    parser_semantics_file/1,

    generator_lexicon_name/1,
    parser_lexicon_name/1,
    generator_lexicon_file/1,
    parser_lexicon_file/1,

    repair_enabled/1,
    smoothing_enabled/1,
    smoothing_style/1,

    semantic_cases_file/1,
    token_cases_file/1
]).

/*
  Central experiment profile for the bidirectional validation testbench.
*/

profile_name('english_numbers_profile').

validation_pipeline_gen_parse('Generation -> Parsing').
validation_pipeline_parse_gen('Parsing -> Generation').

generator_name('MG Generator').
parser_name('MG LC Parser').

generator_main_file('../../SemanticGenerator/MG-Generator/main.pl').
parser_load_file('../../MG-LC-Parser-with-Semantic-main/load.pl').
parser_semantics_file('../../MG-LC-Parser-with-Semantic-main/sem_from_tree.pl').

generator_lexicon_name('numbers_Gen').
parser_lexicon_name('English_trans_pruned').

generator_lexicon_file('../../SemanticGenerator/MG-Generator/grammars/numbers_Gen.pl').
parser_lexicon_file('../../MG-LC-Parser-with-Semantic-main/grammars/English_trans_pruned.pl').

repair_enabled(false).
smoothing_enabled(false).
smoothing_style(none).

semantic_cases_file('../cases/test_cases.pl').
token_cases_file('../cases/token_cases.pl').