# Bidirectional Minimalist Grammar Testbench

This folder contains the bidirectional validation testbench used to connect an existing Minimalist Grammar generator with an existing Minimalist Grammar parser.

The purpose of the testbench is not to reimplement the parser or generator. Instead, it provides an orchestration and evaluation layer that runs both tools in controlled validation pipelines, records intermediate outputs, and classifies failures by stage.

## Project role

The repository contains three main tool areas:

```text
bidirectional/                         Thesis testbench implementation
SemanticGenerator/                     External MG generator
MG-LC-Parser-with-Semantic-main/       External MG left-corner parser
top-down-Parser/                       Additional parser material, not active in the main pipeline

##########################################################################################################


The active thesis contribution is located in bidirectional/.

Validation modes

The testbench supports two main validation directions.

1. Generation-to-Parsing validation

Command:

python run_testbench.py --mode gen_to_parse --label clean_gen_to_parse

Pipeline:

semantic input
    -> MG generator
    -> generated tokens
    -> token normalization
    -> MG parser
    -> parser semantic output
    -> semantic comparison

Relevant runner files:

runners/gen_to_parse_generate.pl
runners/gen_to_parse_parse.pl
runners/gen_to_parse_compare.pl

This mode checks whether a semantic input generated into a surface form can be parsed back into the same semantic representation.

2. Parsing-to-Generation validation

Command:

python run_testbench.py --mode parse_to_gen --label clean_parse_to_gen

Pipeline:

token input
    -> MG parser
    -> parsed semantic representation
    -> MG generator
    -> regenerated tokens
    -> token comparison

Relevant runner files:

runners/parse_to_gen_parse.pl
runners/parse_to_gen_generate.pl
runners/parse_to_gen_compare.pl

This mode checks whether a token input parsed into semantics can be generated back into the same token sequence.

Legacy aliases are still accepted by run_testbench.py:

forward -> gen_to_parse
reverse -> parse_to_gen
Folder structure
bidirectional/
├── adapters/
├── archive_legacy/
├── cases/
├── config/
├── generated/
├── logging/
├── logs/
├── reports/
├── runners/
└── run_testbench.py
adapters/

Contains testbench-specific interface layers around the external parser and generator.

generator_adapter.pl
parser_adapter.pl
repair_adapter.pl
token_normalizer.pl

generator_adapter.pl wraps the external MG generator.

parser_adapter.pl wraps the external MG parser and uses the parser's internal semantic pipeline:

lcParse/2 -> workSpace/2 -> lappend/2 -> betaRoot/2

This avoids relying on the old sem_from_tree.pl semantic reconstruction file.

token_normalizer.pl maps token conventions between the generator and parser. For example, the generator may output twenty, while the parser expects twenty_ in compound forms.

repair_adapter.pl is an optional compatibility layer. It is disabled in the active profile.

cases/

Contains input cases for the two validation directions.

test_cases.pl           Semantic cases for generation-to-parsing
token_cases.pl          Token cases for parsing-to-generation
test_cases_german.pl    German semantic cases
token_cases_german.pl   German token cases
config/

Contains active configuration and runtime path metadata.

testbench_profile.pl    Active experiment profile
run_metadata.pl         Generated output paths
smoothing_rules.pl      Token normalization rules
runners/

Contains the Prolog runner scripts for each validation stage.

gen_to_parse_generate.pl
gen_to_parse_parse.pl
gen_to_parse_compare.pl
parse_to_gen_parse.pl
parse_to_gen_generate.pl
parse_to_gen_compare.pl

The split-runner design is intentional. It keeps generation, parsing, and comparison as separate stages, allowing failures to be localized and intermediate artifacts to be inspected.

generated/

Contains the latest runtime outputs produced by the testbench.

Generation-to-parsing outputs:

gen_to_parse_gen_out.pl
gen_to_parse_parse_out.pl
gen_to_parse_report.txt
gen_to_parse_generation_trees.txt
gen_to_parse_parsing_trees.txt

Parsing-to-generation outputs:

parse_to_gen_parse_out.pl
parse_to_gen_gen_out.pl
parse_to_gen_report.txt
parse_to_gen_parsing_trees.txt
parse_to_gen_generation_trees.txt
reports/

Contains archived outputs from labeled runs.

Example:

python run_testbench.py --mode gen_to_parse --label clean_baseline

creates:

reports/clean_baseline/
logging/

Contains the testbench logger.

testbench_logger.pl
archive_legacy/

Contains older development files that are not part of the active testbench pipeline. This includes previous semantic reconstruction code, old configuration files, and manual/debug runners.

Current baseline results

With the English number profile, the current cleaned pipeline produces:

Generation-to-Parsing:

Total Cases: 55
Validation Passed: 46
No Surface Form Generated: 6
Parsing Failed: 3
Semantic Roundtrip Mismatch: 0

Parsing-to-Generation:

Total Cases: 52
Validation Passed: 46
No Surface Form Generated: 1
Parsing Failed: 5
Token Roundtrip Mismatch: 0

The remaining failures are not caused by the old semantic reconstruction module. They are localized to generation coverage or parser coverage for specific token patterns.

Important implementation notes

The active parser semantics are obtained through the parser's own semantic pipeline, not through sem_from_tree.pl.

The file sem_from_tree_legacy.pl is kept only in archive_legacy/ for development history.

The token normalization layer is necessary because the parser and generator use slightly different token conventions for compound number stems. For example:

generator token: twenty
parser token:    twenty_

This normalization is a representation bridge, not a grammatical repair.

Typical commands

Run Generation-to-Parsing:

python run_testbench.py --mode gen_to_parse --label gen_to_parse_run

Run Parsing-to-Generation:

python run_testbench.py --mode parse_to_gen --label parse_to_gen_run

Run both:

python run_testbench.py --mode both --label full_run