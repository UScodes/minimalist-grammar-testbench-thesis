:- module(normalization_rule_dispatcher, [
    token_class/2,
    marker_style/2,
    normalization_rule/4,
    token_rule/4,
    active_rule_set/1
]).

:- use_module('../config/testbench_profile').

% Load available rule modules without importing their predicates directly.
:- use_module('./normalization_english_rules', []).
:- use_module('./normalization_german_rules', []).

/*
-----------------------------------------------------------
MG Testbench – Normalization Rule Dispatcher
-----------------------------------------------------------

Purpose
-------
This module acts as a facade between the generic token normalizer and the
active language- or grammar-specific normalization rule module.

The token normalizer always calls this dispatcher:

    normalization_rule_dispatcher:token_class/2
    normalization_rule_dispatcher:marker_style/2
    normalization_rule_dispatcher:normalization_rule/4
    normalization_rule_dispatcher:token_rule/4

The dispatcher forwards these calls to the active rule set selected in
testbench_profile.pl.

Example profile setting:

    smoothing_rule_set(english).

Supported rule sets in this configuration:

    english -> normalization_english_rules
    german  -> normalization_german_rules

If no smoothing_rule_set/1 is defined in the profile, English is used
as the default for backward compatibility.
*/


% =============================================================================
% Active rule set
% =============================================================================

active_rule_set(RuleSet) :-
    catch(testbench_profile:smoothing_rule_set(RuleSet), _, fail),
    !.

active_rule_set(english).


% =============================================================================
% Rule-set to module mapping
% =============================================================================

rule_module(english, normalization_english_rules).
rule_module(german,  normalization_german_rules).


active_rule_module(Module) :-
    active_rule_set(RuleSet),
    rule_module(RuleSet, Module),
    !.

% Safe fallback if an unknown rule set is selected.
active_rule_module(normalization_english_rules).


% =============================================================================
% Dispatcher predicates
% =============================================================================

token_class(ClassName, Token) :-
    active_rule_module(Module),
    call(Module:token_class(ClassName, Token)).


marker_style(Style, MarkerAction) :-
    active_rule_module(Module),
    call(Module:marker_style(Style, MarkerAction)).


normalization_rule(Direction, Style, Pattern, Actions) :-
    active_rule_module(Module),
    call(Module:normalization_rule(Direction, Style, Pattern, Actions)).


token_rule(Direction, Style, From, To) :-
    active_rule_module(Module),
    call(Module:token_rule(Direction, Style, From, To)).