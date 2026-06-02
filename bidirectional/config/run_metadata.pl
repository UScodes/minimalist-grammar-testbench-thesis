:- module(run_metadata, [
    project_root/1,
    generated_dir/1,
    logs_dir/1,
    reports_dir/1,

    gen_out_file/1,
    parse_out_file/1,
    reverse_out_file/1,
    reverse_parse_out_file/1,

    bidir_report_file/1,
    reverse_report_file/1,

    forward_gen_tree_report_file/1,
    forward_parse_tree_report_file/1,
    reverse_gen_tree_report_file/1,
    reverse_parse_tree_report_file/1,

    single_generate_report_file/1,
    single_parse_report_file/1
]).

/*
-----------------------------------------------------------
MG Testbench – Run Metadata
-----------------------------------------------------------

Purpose
-------
This file centralizes path metadata for generated artifacts, logs,
and validation reports.

It does not define the active experiment setup. Information such as
the selected parser, generator, lexicons, test cases, normalization
settings, and timeout values belongs in:

    config/testbench_profile.pl

Naming note
-----------
Some predicate names are retained for compatibility with existing
runner scripts:

    gen_out_file/1
    parse_out_file/1
    reverse_out_file/1
    reverse_parse_out_file/1
    bidir_report_file/1
    reverse_report_file/1

Although these predicate names are stable internal identifiers, the
actual file names use the clearer pipeline labels:

    gen_to_parse = Generation-to-Parsing
    parse_to_gen = Parsing-to-Generation

This allows the implementation to remain backward-compatible while the
generated artifacts remain readable and aligned with the terminology
used in the thesis.
*/


% =============================================================================
% Base directories
% =============================================================================

project_root('..').

generated_dir('../generated').
logs_dir('../logs').
reports_dir('../reports').


% =============================================================================
% Generation-to-Parsing artifacts
% =============================================================================

% Generation-stage output:
%   gen_to_parse_generation_case(...)
gen_out_file('../generated/gen_to_parse_gen_out.pl').

% Parsing-stage output:
%   gen_to_parse_parsing_case(...)
parse_out_file('../generated/gen_to_parse_parse_out.pl').

% Final validation report for the Generation-to-Parsing pipeline.
bidir_report_file('../generated/gen_to_parse_report.txt').

% Tree/debug reports for the Generation-to-Parsing pipeline.
forward_gen_tree_report_file('../generated/gen_to_parse_generation_trees.txt').
forward_parse_tree_report_file('../generated/gen_to_parse_parsing_trees.txt').


% =============================================================================
% Parsing-to-Generation artifacts
% =============================================================================

% Parsing-stage output:
%   parse_to_gen_parsing_case(...)
reverse_parse_out_file('../generated/parse_to_gen_parse_out.pl').

% Generation-stage output:
%   parse_to_gen_generation_case(...)
reverse_out_file('../generated/parse_to_gen_gen_out.pl').

% Final validation report for the Parsing-to-Generation pipeline.
reverse_report_file('../generated/parse_to_gen_report.txt').

% Tree/debug reports for the Parsing-to-Generation pipeline.
reverse_parse_tree_report_file('../generated/parse_to_gen_parsing_trees.txt').
reverse_gen_tree_report_file('../generated/parse_to_gen_generation_trees.txt').


% =============================================================================
% Single-case diagnostic artifacts
% =============================================================================

% Diagnostic report for one generator-only test case.
% Produced by runners/single_generate.pl.
single_generate_report_file('../generated/single_generate_report.txt').

% Diagnostic report for one parser-only test case.
% Produced by runners/single_parse.pl.
single_parse_report_file('../generated/single_parse_report.txt').