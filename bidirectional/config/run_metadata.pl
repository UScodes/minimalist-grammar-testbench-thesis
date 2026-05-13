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
    reverse_parse_tree_report_file/1
]).

/*
  Central path metadata for generated artifacts, logs, and reports.

  This module should only contain output/runtime artifact paths.

  Experiment setup such as active cases, grammars, lexicons, and options
  belongs in testbench_profile.pl
*/

project_root('..').

generated_dir('../generated').
logs_dir('../logs').
reports_dir('../reports').

gen_out_file('../generated/gen_out.pl').
parse_out_file('../generated/parse_out.pl').
reverse_out_file('../generated/reverse_out.pl').
reverse_parse_out_file('../generated/reverse_parse_out.pl').

bidir_report_file('../generated/bidir_report.txt').
reverse_report_file('../generated/reverse_report.txt').

forward_gen_tree_report_file('../generated/forward_gen_tree_report.txt').
forward_parse_tree_report_file('../generated/forward_parse_tree_report.txt').

reverse_gen_tree_report_file('../generated/reverse_gen_tree_report.txt').
reverse_parse_tree_report_file('../generated/reverse_parse_tree_report.txt').