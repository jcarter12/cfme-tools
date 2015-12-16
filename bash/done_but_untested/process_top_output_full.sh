#/bin/bash
ruby  -v  ../ruby/Analyze_last_startup/Analyze_last_startup.rb  ..\last_startup.txt 1>last_startup_stdout.lst 2>last_startup_stderr.lst
ruby  ../ruby/Analyze_last_startup/process_top_output.rb ..\top_output.log 1>top_output_sstdout.lst 2>top_output_stderr.lst
