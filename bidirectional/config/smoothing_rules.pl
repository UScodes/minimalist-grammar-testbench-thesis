:- module(smoothing_rules, [
    smoothing_rule/4
]).

/*
-----------------------------------------------------------
MG Testbench – Smoothing Rules
-----------------------------------------------------------

smoothing_rule(Direction, Style, From, To)

Direction:
  gen_to_parser
  parser_to_gen

Style:
  underscore
  plain
  none

This file holds configurable symbol/token normalization rules.
*/

/* ---------------------------------
   underscore style
--------------------------------- */

smoothing_rule(gen_to_parser, underscore, twenty, twenty_).
smoothing_rule(gen_to_parser, underscore, thirty, thirty_).
smoothing_rule(gen_to_parser, underscore, forty,  forty_).
smoothing_rule(gen_to_parser, underscore, fifty,  fifty_).

smoothing_rule(parser_to_gen, underscore, twenty_, twenty).
smoothing_rule(parser_to_gen, underscore, thirty_, thirty).
smoothing_rule(parser_to_gen, underscore, forty_,  forty).
smoothing_rule(parser_to_gen, underscore, fifty_,  fifty).

/* ---------------------------------
   plain style
--------------------------------- */

% In plain style, parser_to_gen and gen_to_parser keep plain tokens.
% No change rules needed here unless you later support other forms.

/* ---------------------------------
   none style
--------------------------------- */

% "none" means no smoothing should be applied.
% token_normalizer.pl already handles that by bypassing normalization.