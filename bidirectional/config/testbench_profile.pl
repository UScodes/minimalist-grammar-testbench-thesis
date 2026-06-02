:- module(testbench_profile, [
    profile_name/1,

    validation_pipeline_gen_parse/1,
    validation_pipeline_parse_gen/1,

    generator_name/1,
    parser_name/1,

    generator_main_file/1,
    generator_wrapper_file/1,
    parser_load_file/1,
    parser_semantics_source/1,
    parser_wrapper_file/1,

    generator_lexicon_name/1,
    parser_lexicon_name/1,
    generator_lexicon_file/1,
    parser_lexicon_file/1,

    repair_enabled/1,
    smoothing_enabled/1,
    smoothing_style/1,
    adapter_timeout_seconds/1,

    semantic_cases_file/1,
    token_cases_file/1
]).

/*
-----------------------------------------------------------
MG Testbench – Experiment Profile
-----------------------------------------------------------

Purpose
-------
This file defines the active experiment profile for the bidirectional
Minimalist Grammar testbench.

The profile separates experiment-specific configuration from the runner
logic. Runners and adapters read this file to determine which parser,
generator, lexicons, test cases, normalization settings, repair setting,
and timeout value should be used in a test run.

This keeps the orchestration code reusable: a different experiment can
be configured by changing this profile instead of modifying the runner
scripts.

Parser semantic source
----------------------
The current testbench obtains parser semantics through the parser's
internal semantic pipeline, exposed by the parser adapter:

    lcParse/2 -> workSpace/2 -> lappend/2 -> betaRoot/2

The active semantic source is recorded by:

    parser_semantics_source(parser_internal_pipeline).
*/


% =============================================================================
% Profile identity and validation directions
% =============================================================================

profile_name('english_numbers_profile').

validation_pipeline_gen_parse('Generation -> Parsing').
validation_pipeline_parse_gen('Parsing -> Generation').


% =============================================================================
% Component names
% =============================================================================

generator_name('MG Generator').
parser_name('MG LC Parser').


% =============================================================================
% Component entry points and adapters
% =============================================================================

generator_main_file('../../SemanticGenerator/MG-Generator/main.pl').
generator_wrapper_file('../adapters/generator_adapter.pl').

parser_load_file('../../MG-LC-Parser-with-Semantic-main/load.pl').
parser_wrapper_file('../adapters/parser_adapter.pl').


% =============================================================================
% Parser semantic source
% =============================================================================

parser_semantics_source(parser_internal_pipeline).


% =============================================================================
% Lexical resources
% =============================================================================

generator_lexicon_name('numbers_Gen').
parser_lexicon_name('English_trans_pruned').

generator_lexicon_file('../../SemanticGenerator/MG-Generator/grammars/numbers_Gen.pl').
parser_lexicon_file('../../MG-LC-Parser-with-Semantic-main/grammars/English_trans_pruned.pl').


% =============================================================================
% Runtime options
% =============================================================================

% Optional repair layer for known compatibility cases.
% Disabled by default so strict evaluation is preserved.
repair_enabled(false).

% Token normalization/smoothing configuration.
% If enabled, the selected style is applied by token_normalizer.pl.
smoothing_enabled(true).
smoothing_style(underscore).

% Execution limit used by the parser and generator adapters.
adapter_timeout_seconds(5).


% =============================================================================
% Test case files
% =============================================================================

% Semantic inputs for the Generation-to-Parsing pipeline.
semantic_cases_file('../cases/test_cases.pl').

% Token inputs for the Parsing-to-Generation pipeline.
token_cases_file('../cases/token_cases.pl').