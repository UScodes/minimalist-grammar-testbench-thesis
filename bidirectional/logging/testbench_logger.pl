:- module(mg_logger, [
    log_event/2,          % log_event(+Tag, +DataTerm)
    protocol_path/1       % protocol_path(-Path)
]).

:- use_module(library(filesex)).  % make_directory_path/1

/*
-----------------------------------------------------------
MG Testbench Logger
-----------------------------------------------------------

This logger belongs to the testbench infrastructure, not to the
external MG generator or parser.

The module name remains mg_logger for compatibility with existing
runner calls such as:

    mg_logger:log_event(...)

The file itself should be stored at:

    bidirectional/logging/testbench_logger.pl
*/

protocol_path('../logs/protocol.log').

ensure_logs_dir :-
    make_directory_path('../logs').

timestamp_atom(TS) :-
    get_time(T),
    format_time(atom(TS), '%FT%T', T).

write_line(Line) :-
    ensure_logs_dir,
    protocol_path(File),
    setup_call_cleanup(
        open(File, append, S, [encoding(utf8)]),
        (
            writeln(S, Line),
            flush_output(S)
        ),
        close(S)
    ).

log_event(Tag, DataTerm) :-
    timestamp_atom(TS),
    format(atom(Line), '~w | ~w | ~q', [TS, Tag, DataTerm]),
    write_line(Line).