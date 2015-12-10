#/bin/bash
ruby  -v  ~/documents/thennessy/archive/ruby\ source\ materials/Analyze_last_startup/lib/Analyze_last_startup.rb  ..\last_startup.txt 1>last_startup_stdout.lst 2>last_startup_stderr.lst
ruby  ~/documents/thennessy/archive/ruby\ source\ materials/Analyze_last_startup/lib/process_top_output.rb ..\top_output.log 1>top_output_sstdout.lst 2>top_output_stderr.lst
