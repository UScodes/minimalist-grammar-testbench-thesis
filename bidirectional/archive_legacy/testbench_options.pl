:- module(testbench_options, [
    repair_enabled/1,
    smoothing_enabled/1,
    smoothing_style/1
]).

/*
-----------------------------------------------------------
MG Testbench – Runtime Options
-----------------------------------------------------------

repair_enabled(true/false)
    Controls whether the repair layer is applied.

smoothing_enabled(true/false)
    Controls whether token smoothing/normalization is applied.

smoothing_style(Style)
    Current supported styles:
      none
      underscore
      plain
*/

repair_enabled(true).
smoothing_enabled(true).
smoothing_style(underscore).