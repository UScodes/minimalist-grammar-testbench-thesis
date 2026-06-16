:- module(token_normalizer, [
    normalize_gen_to_parser/2,
    normalize_parser_to_gen/2
]).

:- use_module('../config/testbench_profile').
:- use_module('../config/normalization_rule_dispatcher').

/*
-----------------------------------------------------------
MG Testbench – Token Normalizer
-----------------------------------------------------------

Purpose
-------
This adapter applies optional token normalization between pipeline
stages.

The normalizer is implemented as a generic configurable rule engine.
It does not contain grammar-specific or language-specific assumptions.
The active normalization rule set and normalization style are selected
through the testbench profile and resolved by
normalization_rule_dispatcher.pl.

Architecture
------------
token_normalizer.pl
    Generic normalization engine.

normalization_rule_dispatcher.pl
    Dispatcher/facade that selects the active rule module.

normalization_english_rules.pl, normalization_german_rules.pl, ...
    Language- or grammar-specific normalization rule modules.

Profile options
---------------
The profile still uses the earlier option names for compatibility:

    smoothing_enabled/1
    smoothing_style/1
    smoothing_rule_set/1

Internally, this file treats them as token-normalization settings.

Supported pattern elements
--------------------------
  class(ClassName)
      Matches any token declared by token_class(ClassName, Token).

  token(Token)
      Matches exactly Token.

  one_of([A, B, C])
      Matches any token in the given list.

  any
      Matches any token.

  Token
      Also matches exactly Token.

Supported actions
-----------------
  same
      Keep the token unchanged.

  mark
      Apply the selected marker style to this token.

  replace(NewToken)
      Replace the token with NewToken.

  token(NewToken)
      Same as replace(NewToken).

  suffix(SuffixAtom)
      Add SuffixAtom at the end of the token.

  prefix(PrefixAtom)
      Add PrefixAtom at the beginning of the token.
*/


% =============================================================================
% Public predicates
% =============================================================================

normalize_gen_to_parser(In, Out) :-
    normalize_tokens(gen_to_parse, In, Out).

normalize_parser_to_gen(In, Out) :-
    normalize_tokens(parse_to_gen, In, Out).


% =============================================================================
% Main dispatcher
% =============================================================================

normalize_tokens(_Direction, In, In) :-
    testbench_profile:smoothing_enabled(false),
    !.

normalize_tokens(_Direction, In, In) :-
    testbench_profile:smoothing_enabled(true),
    testbench_profile:smoothing_style(none),
    !.

normalize_tokens(Direction, In, Out) :-
    testbench_profile:smoothing_enabled(true),
    testbench_profile:smoothing_style(Style),
    normalize_list(Direction, Style, In, Out).


% =============================================================================
% Generic list normalization
%
% Sequence rules are tried before token-level rules.
%
% This allows context-sensitive normalization such as:
%
%   [twenty]       -> [twenty]
%   [twenty, four] -> [twenty_, four]
%
% The engine itself does not know these tokens. It only applies the active
% rule set selected through normalization_rule_dispatcher.pl.
% =============================================================================

normalize_list(_, _, [], []).

normalize_list(Direction, Style, In, Out) :-
    apply_sequence_rule(Direction, Style, In, MatchedOut, Rest),
    !,
    normalize_list(Direction, Style, Rest, RestOut),
    append(MatchedOut, RestOut, Out).

normalize_list(Direction, Style, [H | T], [H2 | T2]) :-
    normalize_single_token(Direction, Style, H, H2),
    normalize_list(Direction, Style, T, T2).


% =============================================================================
% Sequence rule application
% =============================================================================

apply_sequence_rule(Direction, Style, In, OutPrefix, Rest) :-
    normalization_rule_dispatcher:normalization_rule(Direction, Style, Pattern, Actions),
    Pattern = [_ | _],
    same_length(Pattern, Actions),
    match_pattern(Pattern, In, MatchedTokens, Rest),
    apply_actions(Style, Actions, MatchedTokens, OutPrefix).


% =============================================================================
% Pattern matching
% =============================================================================

match_pattern([], Rest, [], Rest).

match_pattern(
    [PatternItem | PatternRest],
    [Token | TokenRest],
    [Token | MatchedRest],
    Rest
) :-
    pattern_item_matches(PatternItem, Token),
    match_pattern(PatternRest, TokenRest, MatchedRest, Rest).


pattern_item_matches(any, _Token) :-
    !.

pattern_item_matches(class(ClassName), Token) :-
    normalization_rule_dispatcher:token_class(ClassName, Token),
    !.

pattern_item_matches(token(Expected), Token) :-
    Expected == Token,
    !.

pattern_item_matches(one_of(Options), Token) :-
    is_list(Options),
    memberchk(Token, Options),
    !.

pattern_item_matches(Expected, Token) :-
    Expected == Token.


% =============================================================================
% Action application
% =============================================================================

apply_actions(_, [], [], []).

apply_actions(
    Style,
    [Action | ActionRest],
    [Token | TokenRest],
    [OutToken | OutRest]
) :-
    apply_action(Style, Action, Token, OutToken),
    apply_actions(Style, ActionRest, TokenRest, OutRest).


apply_action(_, same, Token, Token).

apply_action(Style, mark, Token, OutToken) :-
    normalization_rule_dispatcher:marker_style(Style, MarkerAction),
    apply_marker_action(MarkerAction, Token, OutToken).

apply_action(_, replace(NewToken), _Token, NewToken).

apply_action(_, token(NewToken), _Token, NewToken).

apply_action(_, suffix(Suffix), Token, OutToken) :-
    atom(Token),
    atom(Suffix),
    atom_concat(Token, Suffix, OutToken).

apply_action(_, prefix(Prefix), Token, OutToken) :-
    atom(Token),
    atom(Prefix),
    atom_concat(Prefix, Token, OutToken).


% =============================================================================
% Marker style application
% =============================================================================

apply_marker_action(suffix(Suffix), Token, OutToken) :-
    atom(Token),
    atom(Suffix),
    atom_concat(Token, Suffix, OutToken).

apply_marker_action(prefix(Prefix), Token, OutToken) :-
    atom(Token),
    atom(Prefix),
    atom_concat(Prefix, Token, OutToken).

apply_marker_action(replace(NewToken), _Token, NewToken).


% =============================================================================
% Single-token fallback
%
% These rules are only used if no sequence rule matches at the current position.
% =============================================================================

normalize_single_token(Direction, Style, Token, Normalized) :-
    normalization_rule_dispatcher:token_rule(Direction, Style, Token, Normalized),
    !.

normalize_single_token(_, _, Token, Token).