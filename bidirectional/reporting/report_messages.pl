:- module(report_messages, [
    report_language/1,
    report_text/2,
    yes_no_label/2,
    verdict_label/2,
    failure_stage_label/2,
    failure_reason_label/2
]).

:- use_module('../config/testbench_profile').


% =============================================================================
% Active report language
% =============================================================================

report_language(Language) :-
    catch(testbench_profile:report_language(Language), _, fail),
    supported_language(Language),
    !.

report_language(en).

supported_language(en).
supported_language(de).


% =============================================================================
% Generic report text lookup
% =============================================================================

report_text(Key, Text) :-
    report_language(Language),
    message(Language, Key, Text),
    !.

report_text(Key, Text) :-
    message(en, Key, Text),
    !.

report_text(Key, Key).


% =============================================================================
% Boolean labels
% =============================================================================

yes_no_label(true, Label) :-
    report_text(yes, Label).

yes_no_label(false, Label) :-
    report_text(no, Label).


% =============================================================================
% Verdict labels
% =============================================================================

verdict_label(validation_passed, Label) :-
    report_text(validation_passed, Label).

verdict_label(generation_timed_out, Label) :-
    report_text(generation_timed_out, Label).

verdict_label(generation_failed, Label) :-
    report_text(generation_failed, Label).

verdict_label(no_surface_form_generated, Label) :-
    report_text(no_surface_form_generated, Label).

verdict_label(parsing_skipped, Label) :-
    report_text(parsing_skipped, Label).

verdict_label(parsing_timed_out, Label) :-
    report_text(parsing_timed_out, Label).

verdict_label(parsing_failed, Label) :-
    report_text(parsing_failed, Label).

verdict_label(semantic_roundtrip_mismatch, Label) :-
    report_text(semantic_roundtrip_mismatch, Label).

verdict_label(token_roundtrip_mismatch, Label) :-
    report_text(token_roundtrip_mismatch, Label).


% =============================================================================
% Failure-stage labels
% =============================================================================

failure_stage_label(none, Label) :-
    report_text(none, Label).

failure_stage_label(generation, Label) :-
    report_text(generation, Label).

failure_stage_label(parsing, Label) :-
    report_text(parsing, Label).

failure_stage_label(semantic_comparison, Label) :-
    report_text(semantic_comparison, Label).

failure_stage_label(token_comparison, Label) :-
    report_text(token_comparison, Label).


% =============================================================================
% Failure-reason labels
% =============================================================================

failure_reason_label(none, Label) :-
    report_text(none, Label).

failure_reason_label(generation_exceeded_time_limit, Label) :-
    report_text(generation_exceeded_time_limit, Label).

failure_reason_label(generator_returned_empty_token_yield, Label) :-
    report_text(generator_returned_empty_token_yield, Label).

failure_reason_label(no_tokens_available_for_parsing, Label) :-
    report_text(no_tokens_available_for_parsing, Label).

failure_reason_label(parsing_exceeded_time_limit, Label) :-
    report_text(parsing_exceeded_time_limit, Label).

failure_reason_label(parser_could_not_derive_valid_parse, Label) :-
    report_text(parser_could_not_derive_valid_parse, Label).

failure_reason_label(parsed_semantics_differ_from_original_input(Expected, Actual), Label) :-
    report_language(Language),
    parsed_semantics_differ_from_original_input(Language, Expected, Actual, Label),
    !.

failure_reason_label(regenerated_tokens_differ_from_original_input(Expected, Actual), Label) :-
    report_language(Language),
    regenerated_tokens_differ_from_original_input(Language, Expected, Actual, Label),
    !.

failure_reason_label(generator_error(E), Label) :-
    report_language(Language),
    generator_error(Language, E, Label),
    !.

failure_reason_label(parser_error(E), Label) :-
    report_language(Language),
    parser_error(Language, E, Label),
    !.


% =============================================================================
% English messages
% =============================================================================

message(en, yes, 'Yes').
message(en, no, 'No').

message(en, gen_to_parse_report_title, 'Validation Report: Generation-to-Parsing').
message(en, parse_to_gen_report_title, 'Validation Report: Parsing-to-Generation').

message(en, single_generator_diagnostic_report, 'Single Generator Diagnostic Report').
message(en, single_parser_diagnostic_report, 'Single Parser Diagnostic Report').

message(en, profile, 'Profile').
message(en, pipeline, 'Pipeline').
message(en, generator_component, 'Generator Component').
message(en, parser_component, 'Parser Component').

message(en, generator_main_file, 'Generator Main File').
message(en, generator_adapter_file, 'Generator Adapter File').
message(en, parser_load_file, 'Parser Load File').
message(en, parser_adapter_file, 'Parser Adapter File').
message(en, parser_semantic_source, 'Parser Semantic Source').

message(en, generator_lexicon, 'Generator Lexicon').
message(en, parser_lexicon, 'Parser Lexicon').
message(en, generator_lexicon_file, 'Generator Lexicon File').
message(en, parser_lexicon_file, 'Parser Lexicon File').
message(en, semantic_test_case_file, 'Semantic Test Case File').
message(en, token_test_case_file, 'Token Test Case File').

message(en, token_normalization_enabled, 'Token Normalization Enabled').
message(en, token_normalization_style, 'Token Normalization Style').
message(en, token_normalization_rule_set, 'Token Normalization Rule Set').
message(en, token_normalization_dispatcher, 'Token Normalization Dispatcher').
message(en, adapter_timeout, 'Adapter Timeout').
message(en, seconds, 'seconds').

message(en, generation_stage_output_file, 'Generation-stage Output File').
message(en, parsing_stage_output_file, 'Parsing-stage Output File').
message(en, generation_tree_report, 'Generation Tree Report').
message(en, parsing_tree_report, 'Parsing Tree Report').

message(en, case_id, 'Case ID').
message(en, validation_result, 'Validation Result').
message(en, failure_stage, 'Failure Stage').
message(en, diagnostic_reason, 'Diagnostic Reason').

message(en, input, 'Input').
message(en, semantic_input, 'Semantic Input').
message(en, token_input, 'Token Input').

message(en, generation_stage, 'Generation Stage').
message(en, generation_status, 'Generation Status').
message(en, generated_tokens, 'Generated Tokens').
message(en, generation_tree, 'Generation Tree').

message(en, parsing_stage, 'Parsing Stage').
message(en, parsing_status, 'Parsing Status').
message(en, recovered_semantic_output, 'Recovered Semantic Output').
message(en, parse_tree, 'Parse Tree').

message(en, interface_preparation, 'Interface Preparation').
message(en, tokens_after_normalization, 'Tokens after Normalization').

message(en, validation_summary, 'Validation Summary').
message(en, total_cases, 'Total Cases').
message(en, validation_passed_count, 'Validation Passed').
message(en, generation_timed_out_count, 'Generation Timed Out').
message(en, generation_failed_count, 'Generation Failed').
message(en, no_surface_form_generated_count, 'No Surface Form Generated').
message(en, parsing_skipped_count, 'Parsing Skipped').
message(en, parsing_timed_out_count, 'Parsing Timed Out').
message(en, parsing_failed_count, 'Parsing Failed').
message(en, semantic_roundtrip_mismatch_count, 'Semantic Roundtrip Mismatch').
message(en, token_roundtrip_mismatch_count, 'Token Roundtrip Mismatch').

message(en, failure_stage_summary, 'Failure Stage Summary').
message(en, no_failure_stage, 'No Failure Stage').
message(en, generation_count, 'Generation').
message(en, parsing_count, 'Parsing').
message(en, semantic_comparison_count, 'Semantic Comparison').
message(en, token_comparison_count, 'Token Comparison').

message(en, validation_passed, 'Validation Passed').
message(en, generation_timed_out, 'Generation Timed Out').
message(en, generation_failed, 'Generation Failed').
message(en, no_surface_form_generated, 'Generation Produced No Surface Form').
message(en, parsing_skipped, 'Parsing Skipped').
message(en, parsing_timed_out, 'Parsing Timed Out').
message(en, parsing_failed, 'Parsing Failed').
message(en, semantic_roundtrip_mismatch, 'Semantic Roundtrip Mismatch').
message(en, token_roundtrip_mismatch, 'Token Roundtrip Mismatch').

message(en, none, 'None').
message(en, generation, 'Generation').
message(en, parsing, 'Parsing').
message(en, semantic_comparison, 'Semantic Comparison').
message(en, token_comparison, 'Token Comparison').

message(en, generation_exceeded_time_limit, 'Generation exceeded the time limit for this test case').
message(en, generator_returned_empty_token_yield, 'Generator returned an empty token yield').
message(en, no_tokens_available_for_parsing, 'Parsing was skipped because no tokens were available').
message(en, parsing_exceeded_time_limit, 'Parsing exceeded the time limit for this test case').
message(en, parser_could_not_derive_valid_parse, 'Parser could not derive a valid parse for the token sequence').


% =============================================================================
% German messages
% =============================================================================

message(de, yes, 'Ja').
message(de, no, 'Nein').

message(de, gen_to_parse_report_title, 'Validierungsbericht: Generierung-zu-Parsing').
message(de, parse_to_gen_report_title, 'Validierungsbericht: Parsing-zu-Generierung').

message(de, single_generator_diagnostic_report, 'Einzelfall-Diagnosebericht: Generator').
message(de, single_parser_diagnostic_report, 'Einzelfall-Diagnosebericht: Parser').

message(de, profile, 'Profil').
message(de, pipeline, 'Pipeline').
message(de, generator_component, 'Generator-Komponente').
message(de, parser_component, 'Parser-Komponente').

message(de, generator_main_file, 'Generator-Hauptdatei').
message(de, generator_adapter_file, 'Generator-Adapterdatei').
message(de, parser_load_file, 'Parser-Ladedatei').
message(de, parser_adapter_file, 'Parser-Adapterdatei').
message(de, parser_semantic_source, 'Parser-Semantikquelle').

message(de, generator_lexicon, 'Generator-Lexikon').
message(de, parser_lexicon, 'Parser-Lexikon').
message(de, generator_lexicon_file, 'Generator-Lexikondatei').
message(de, parser_lexicon_file, 'Parser-Lexikondatei').
message(de, semantic_test_case_file, 'Datei der semantischen Testfälle').
message(de, token_test_case_file, 'Datei der Token-Testfälle').

message(de, token_normalization_enabled, 'Token-Normalisierung aktiviert').
message(de, token_normalization_style, 'Token-Normalisierungsstil').
message(de, token_normalization_rule_set, 'Token-Normalisierungsregelsatz').
message(de, token_normalization_dispatcher, 'Token-Normalisierungs-Dispatcher').
message(de, adapter_timeout, 'Adapter-Zeitlimit').
message(de, seconds, 'Sekunden').

message(de, generation_stage_output_file, 'Ausgabedatei der Generierungsstufe').
message(de, parsing_stage_output_file, 'Ausgabedatei der Parsing-Stufe').
message(de, generation_tree_report, 'Generierungsbaumbericht').
message(de, parsing_tree_report, 'Parsing-Baumbericht').

message(de, case_id, 'Case ID').
message(de, validation_result, 'Validierungsergebnis').
message(de, failure_stage, 'Fehlerstufe').
message(de, diagnostic_reason, 'Diagnosegrund').

message(de, input, 'Eingabe').
message(de, semantic_input, 'Semantische Eingabe').
message(de, token_input, 'Token-Eingabe').

message(de, generation_stage, 'Generierungsstufe').
message(de, generation_status, 'Generierungsstatus').
message(de, generated_tokens, 'Generierte Tokens').
message(de, generation_tree, 'Generierungsbaum').

message(de, parsing_stage, 'Parsing-Stufe').
message(de, parsing_status, 'Parsing-Status').
message(de, recovered_semantic_output, 'Rekonstruierte semantische Ausgabe').
message(de, parse_tree, 'Parsing-Baum').

message(de, interface_preparation, 'Schnittstellenvorbereitung').
message(de, tokens_after_normalization, 'Tokens nach Normalisierung').

message(de, validation_summary, 'Validierungszusammenfassung').
message(de, total_cases, 'Gesamtzahl der Fälle').
message(de, validation_passed_count, 'Validierung bestanden').
message(de, generation_timed_out_count, 'Generierung mit Zeitüberschreitung').
message(de, generation_failed_count, 'Generierung fehlgeschlagen').
message(de, no_surface_form_generated_count, 'Keine Oberflächenform generiert').
message(de, parsing_skipped_count, 'Parsing übersprungen').
message(de, parsing_timed_out_count, 'Parsing mit Zeitüberschreitung').
message(de, parsing_failed_count, 'Parsing fehlgeschlagen').
message(de, semantic_roundtrip_mismatch_count, 'Semantische Roundtrip-Abweichung').
message(de, token_roundtrip_mismatch_count, 'Token-Roundtrip-Abweichung').

message(de, failure_stage_summary, 'Zusammenfassung der Fehlerstufen').
message(de, no_failure_stage, 'Keine Fehlerstufe').
message(de, generation_count, 'Generierung').
message(de, parsing_count, 'Parsing').
message(de, semantic_comparison_count, 'Semantischer Vergleich').
message(de, token_comparison_count, 'Token-Vergleich').

message(de, validation_passed, 'Validierung bestanden').
message(de, generation_timed_out, 'Generierung mit Zeitüberschreitung').
message(de, generation_failed, 'Generierung fehlgeschlagen').
message(de, no_surface_form_generated, 'Generierung erzeugte keine Oberflächenform').
message(de, parsing_skipped, 'Parsing übersprungen').
message(de, parsing_timed_out, 'Parsing mit Zeitüberschreitung').
message(de, parsing_failed, 'Parsing fehlgeschlagen').
message(de, semantic_roundtrip_mismatch, 'Semantische Roundtrip-Abweichung').
message(de, token_roundtrip_mismatch, 'Token-Roundtrip-Abweichung').

message(de, none, 'Keine').
message(de, generation, 'Generierung').
message(de, parsing, 'Parsing').
message(de, semantic_comparison, 'Semantischer Vergleich').
message(de, token_comparison, 'Token-Vergleich').

message(de, generation_exceeded_time_limit, 'Die Generierung überschritt das Zeitlimit für diesen Testfall').
message(de, generator_returned_empty_token_yield, 'Der Generator gab eine leere Token-Ausgabe zurück').
message(de, no_tokens_available_for_parsing, 'Parsing wurde übersprungen, weil keine Tokens verfügbar waren').
message(de, parsing_exceeded_time_limit, 'Das Parsing überschritt das Zeitlimit für diesen Testfall').
message(de, parser_could_not_derive_valid_parse, 'Der Parser konnte keine gültige Ableitung für die Token-Sequenz finden').


% =============================================================================
% Dynamic reason text
% =============================================================================

parsed_semantics_differ_from_original_input(en, Expected, Actual, Label) :-
    format(atom(Label),
        'Parsed semantics differed from the original semantic input: expected ~q but got ~q',
        [Expected, Actual]).

parsed_semantics_differ_from_original_input(de, Expected, Actual, Label) :-
    format(atom(Label),
        'Die geparste Semantik unterscheidet sich von der ursprünglichen semantischen Eingabe: erwartet ~q, erhalten ~q',
        [Expected, Actual]).

regenerated_tokens_differ_from_original_input(en, Expected, Actual, Label) :-
    format(atom(Label),
        'Regenerated tokens differed from the original token input: expected ~q but got ~q',
        [Expected, Actual]).

regenerated_tokens_differ_from_original_input(de, Expected, Actual, Label) :-
    format(atom(Label),
        'Die regenerierten Tokens unterscheiden sich von der ursprünglichen Token-Eingabe: erwartet ~q, erhalten ~q',
        [Expected, Actual]).

generator_error(en, E, Label) :-
    format(atom(Label), 'Generator raised an error: ~q', [E]).

generator_error(de, E, Label) :-
    format(atom(Label), 'Der Generator meldete einen Fehler: ~q', [E]).

parser_error(en, E, Label) :-
    format(atom(Label), 'Parser raised an error: ~q', [E]).

parser_error(de, E, Label) :-
    format(atom(Label), 'Der Parser meldete einen Fehler: ~q', [E]).