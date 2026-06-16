:- module(smoothing_rules, [
    token_class/2,
    marker_style/2,
    normalization_rule/4,
    token_rule/4,
    smoothing_rule/4
]).

/*
-----------------------------------------------------------
MG Testbench – Token Normalization Rules
-----------------------------------------------------------

This file defines the configurable normalization policy used by
token_normalizer.pl.

The normalizer engine is generic. This file describes the token classes,
marker styles, and sequence rules for the current parser-generator pair.

Important distinction
---------------------
The normalizer should only handle interface-level token convention
differences. It should not repair grammar output, infer missing tokens,
or validate semantic correctness.

If another grammar or parser-generator pair uses different conventions,
this file can be changed without rewriting token_normalizer.pl.
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


% Tokens that may require a marked stem form when followed by a unit.
%
% Include a token here only if:
%
%   generator output: [Token, Unit]
%   parser expects:   [MarkedToken, Unit]
%
% For the current experiment, these are the confirmed mismatches.

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

% These styles are selected through testbench_profile:smoothing_style/1.

marker_style(underscore,  suffix('_')).
marker_style(dash,        suffix('-')).
marker_style(bang,        suffix('!')).
marker_style(prefix_hash, prefix('#')).


% =============================================================================
% Sequence-level normalization rules
% =============================================================================

/*
Main rule for current English number experiment.

For underscore style:

    [twenty, four] -> [twenty_, four]

For dash style:

    [twenty, four] -> [twenty-, four]

For bang style:

    [twenty, four] -> [twenty!, four]

For prefix_hash style:

    [twenty, four] -> [#twenty, four]

Standalone tens remain unchanged:

    [twenty] -> [twenty]
*/

normalization_rule(
    gen_to_parse,
    Style,
    [class(compound_tens), class(unit)],
    [mark, same]
) :-
    marker_style(Style, _).


normalization_rule(
    parse_to_gen,
    Style,
    [class(compound_tens), class(unit)],
    [mark, same]
) :-
    marker_style(Style, _).


% =============================================================================
% Example rules for users
%
% Keep these commented. They show how a user can configure different behavior
% without changing token_normalizer.pl.
% =============================================================================

/*
Example 1: mark a single token.

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
Example 4: use one_of/1 instead of a named token class.

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

Do NOT add broad rules such as:

    token_rule(gen_to_parse, underscore, twenty, twenty_).

That would incorrectly change standalone [twenty] to [twenty_].
*/

token_rule(_, _, _, _) :-
    fail.


% =============================================================================
% Compatibility alias for older code
% =============================================================================

smoothing_rule(Direction, Style, From, To) :-
    token_rule(Direction, Style, From, To).