:- module(normalization_english_rules, [
    token_class/2,
    marker_style/2,
    normalization_rule/4,
    token_rule/4
]).

/*
-----------------------------------------------------------
MG Testbench – English Normalization Rules
-----------------------------------------------------------

Purpose
-------
This file defines the token-normalization rules for the current English
number grammar experiment.

The generic token normalizer does not know English or numbers. It only
applies the rules selected through normalization_rule_dispatcher.pl.

This module defines:

    token classes
    marker styles
    sequence-level normalization rules
    token-level normalization rules

The rules here are specific to the current English parser-generator
token conventions.
*/


% =============================================================================
% Token classes
% =============================================================================

token_class(unit, one).
token_class(unit, two).
token_class(unit, three).
token_class(unit, four).
token_class(unit, five).
token_class(unit, six).
token_class(unit, seven).
token_class(unit, eight).
token_class(unit, nine).


% Compound tens that require a marked stem form when followed by a unit.
%
% Include a token here only if:
%
%   generator output: [Token, Unit]
%   parser expects:   [MarkedToken, Unit]
%
% For the current English number experiment, these are confirmed mismatches.

token_class(compound_tens, twenty).
token_class(compound_tens, thirty).
token_class(compound_tens, fifty).

% Optional candidates. Uncomment only if they reflect the active grammar pair.
% token_class(compound_tens, forty).
% token_class(compound_tens, sixty).
% token_class(compound_tens, seventy).
% token_class(compound_tens, eighty).
% token_class(compound_tens, ninety).


% =============================================================================
% Marker styles
% =============================================================================

marker_style(underscore,  suffix('_')).
marker_style(dash,        suffix('-')).
marker_style(bang,        suffix('!')).
marker_style(prefix_hash, prefix('#')).


% =============================================================================
% Sequence-level normalization rules
% =============================================================================

/*
Generation-to-Parsing
---------------------

For underscore style:

    [twenty, four] -> [twenty_, four]

Standalone tens remain unchanged:

    [twenty] -> [twenty]

Longer sequences are handled by scanning the list:

    [three, hundred_and, twenty, four]
        -> [three, hundred_and, twenty_, four]
*/

normalization_rule(
    gen_to_parse,
    Style,
    [class(compound_tens), class(unit)],
    [mark, same]
) :-
    marker_style(Style, _).


/*
Parsing-to-Generation comparison
--------------------------------

The generator may regenerate plain tokens:

    [twenty, four]

Before comparison, they are normalized to the parser-side convention:

    [twenty_, four]
*/

normalization_rule(
    parse_to_gen,
    Style,
    [class(compound_tens), class(unit)],
    [mark, same]
) :-
    marker_style(Style, _).


% =============================================================================
% Example configurable rules
%
% Keep these commented. They show how users can configure different behavior
% without changing token_normalizer.pl.
% =============================================================================

/*
Example 1: mark a single unit token.

normalization_rule(
    gen_to_parse,
    underscore,
    [class(unit)],
    [mark]
).

Example:

    [one] -> [one_]
*/


/*
Example 2: mark the second token in a two-token sequence.

normalization_rule(
    gen_to_parse,
    underscore,
    [class(unit), class(unit)],
    [same, mark]
).

Example:

    [one, two] -> [one, two_]
*/


/*
Example 3: mark the third token in a three-token sequence.

normalization_rule(
    gen_to_parse,
    underscore,
    [any, hundred_and, class(compound_tens)],
    [same, same, mark]
).

Example:

    [three, hundred_and, twenty] -> [three, hundred_and, twenty_]
*/


/*
Example 4: use one_of/1 instead of a named class.

normalization_rule(
    gen_to_parse,
    underscore,
    [one_of([twenty, thirty, fifty]), class(unit)],
    [mark, same]
).

Example:

    [twenty, four] -> [twenty_, four]
*/


/*
Example 5: exact replacement.

normalization_rule(
    gen_to_parse,
    custom_parser_style,
    [twenty, class(unit)],
    [replace(twenty_compound), same]
).

Example:

    [twenty, four] -> [twenty_compound, four]
*/


% =============================================================================
% Token-level rules
% =============================================================================

/*
Use token_rule/4 only for replacements that are always safe regardless of
surrounding context.

Do not add broad rules such as:

    token_rule(gen_to_parse, underscore, twenty, twenty_).

That would incorrectly change standalone [twenty] to [twenty_].
*/

token_rule(_, _, _, _) :-
    fail.