:- module(normalization_german_rules, [
    token_class/2,
    marker_style/2,
    normalization_rule/4,
    token_rule/4
]).

/*
-----------------------------------------------------------
MG Testbench – German Normalization Rules
-----------------------------------------------------------

Purpose
-------
Placeholder module for a future German grammar or German token
normalization experiment.

This file has the same interface as normalization_english_rules.pl, so
the dispatcher can switch rule sets without changing token_normalizer.pl.

To use this rule set, set in testbench_profile.pl:

    smoothing_rule_set(german).

Then add German-specific token classes and normalization rules below.
*/


% =============================================================================
% Marker styles
% =============================================================================

marker_style(underscore,  suffix('_')).
marker_style(dash,        suffix('-')).
marker_style(bang,        suffix('!')).
marker_style(prefix_hash, prefix('#')).


% =============================================================================
% Future German token classes
% =============================================================================

% Example placeholders:
%
% token_class(unit, eins).
% token_class(unit, zwei).
% token_class(unit, drei).
%
% token_class(tens, zwanzig).
% token_class(tens, dreissig).


% =============================================================================
% Future German normalization rules
% =============================================================================

% Example placeholder:
%
% normalization_rule(
%     gen_to_parse,
%     underscore,
%     [class(unit), und, class(tens)],
%     [same, same, mark]
% ).


% =============================================================================
% Safe fallback predicates
% =============================================================================

token_class(_, _) :-
    fail.

normalization_rule(_, _, _, _) :-
    fail.

token_rule(_, _, _, _) :-
    fail.