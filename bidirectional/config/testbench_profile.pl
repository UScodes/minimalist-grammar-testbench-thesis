:- module(testbench_profile, [
    profile_name/1,

    validation_pipeline_gen_parse/1,
    validation_pipeline_parse_gen/1,

    generator_name/1,
    parser_name/1,

    generator_main_file/1,
    parser_load_file/1,
    parser_semantics_file/1,
    parser_semantics_source/1,
    parser_wrapper_file/1,

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

  Important:
  ----------
  parser_semantics_file/1 is retained only for backward compatibility with
  older scripts. The active parser semantics are obtained through the parser's
  internal semantic pipeline, exposed by the testbench parser adapter:

      lcParse/2 -> workSpace/2 -> lappend/2 -> betaRoot/2
*/

profile_name('english_numbers_profile').

validation_pipeline_gen_parse('Generation -> Parsing').
validation_pipeline_parse_gen('Parsing -> Generation').

generator_name('MG Generator').
parser_name('MG LC Parser').

generator_main_file('../../SemanticGenerator/MG-Generator/main.pl').

parser_load_file('../../MG-LC-Parser-with-Semantic-main/load.pl').

% Legacy field. Do not use this as the active semantic source.
parser_semantics_file('../../MG-LC-Parser-with-Semantic-main/sem_from_tree.pl').

% Active parser semantic source used by the current testbench.
parser_semantics_source(parser_internal_pipeline).
parser_wrapper_file('../adapters/parser_adapter.pl').

generator_lexicon_name('numbers_Gen').
parser_lexicon_name('English_trans_pruned').

generator_lexicon_file('../../SemanticGenerator/MG-Generator/grammars/numbers_Gen.pl').
parser_lexicon_file('../../MG-LC-Parser-with-Semantic-main/grammars/English_trans_pruned.pl').

repair_enabled(false).
smoothing_enabled(true).
smoothing_style(underscore).

semantic_cases_file('../cases/test_cases.pl').
token_cases_file('../cases/token_cases.pl').