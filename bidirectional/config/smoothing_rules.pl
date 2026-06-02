:- module(smoothing_rules, [
    smoothing_rule/4
]).

/*
-----------------------------------------------------------
MG Testbench – Token Normalization Rules
-----------------------------------------------------------

smoothing_rule(Direction, Style, From, To)

Purpose
-------
This file stores configurable token-normalization rules used by
token_normalizer.pl.

The rules are separated from the normalizer so that new normalization
styles can be added without changing the normalization algorithm.

Direction:
  gen_to_parse
      Normalization applied in the Generation-to-Parsing pipeline before
      generated tokens are passed to the parser.

  parse_to_gen
      Normalization applied in the Parsing-to-Generation pipeline before
      regenerated tokens are compared with the original token input.

Style:
  underscore
      Converts between plain decade tokens and underscore-marked forms.

  plain
      Keeps plain tokens unchanged.

  none
      Disables normalization. This is handled directly by
      token_normalizer.pl.
*/


% =============================================================================
% underscore style
% =============================================================================

smoothing_rule(gen_to_parse, underscore, twenty, twenty_).
smoothing_rule(gen_to_parse, underscore, thirty, thirty_).
smoothing_rule(gen_to_parse, underscore, forty,  forty_).
smoothing_rule(gen_to_parse, underscore, fifty,  fifty_).

smoothing_rule(parse_to_gen, underscore, twenty_, twenty).
smoothing_rule(parse_to_gen, underscore, thirty_, thirty).
smoothing_rule(parse_to_gen, underscore, forty_,  forty).
smoothing_rule(parse_to_gen, underscore, fifty_,  fifty).


% =============================================================================
% plain style
% =============================================================================

% In plain style, gen_to_parse and parse_to_gen keep plain tokens.
% No explicit rules are needed unless additional plain-style mappings are
% introduced later.


% =============================================================================
% none style
% =============================================================================

% The "none" style means no normalization should be applied.
% token_normalizer.pl handles this case by bypassing normalization.