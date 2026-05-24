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

  The predicate names are kept stable for compatibility with existing
  runners, but the actual file names now use clearer pipeline labels:

      gen_to_parse = Generation -> Parsing
      parse_to_gen = Parsing -> Generation

  Experiment setup such as active cases, grammars, lexicons, and options
  belongs in testbench_profile.pl.
*/

project_root('..').

generated_dir('../generated').
logs_dir('../logs').
reports_dir('../reports').

/*
  Generation -> Parsing output files
*/
gen_out_file('../generated/gen_to_parse_gen_out.pl').
parse_out_file('../generated/gen_to_parse_parse_out.pl').

bidir_report_file('../generated/gen_to_parse_report.txt').

forward_gen_tree_report_file('../generated/gen_to_parse_generation_trees.txt').
forward_parse_tree_report_file('../generated/gen_to_parse_parsing_trees.txt').

/*
  Parsing -> Generation output files
*/
reverse_parse_out_file('../generated/parse_to_gen_parse_out.pl').
reverse_out_file('../generated/parse_to_gen_gen_out.pl').

reverse_report_file('../generated/parse_to_gen_report.txt').

reverse_parse_tree_report_file('../generated/parse_to_gen_parsing_trees.txt').
reverse_gen_tree_report_file('../generated/parse_to_gen_generation_trees.txt').