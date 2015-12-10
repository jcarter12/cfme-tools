#!/bin/bash
rm combined_evm_msg_info.csv
rm filtered_combined_evm_msg_info.csv
for analyzd in *_analyzd ; do
    cat $analyzd/diagnostic_data/evm_msg_info.csv >> combined_evm_msg_info.csv
done

filter_combined_evm_msg_info.awk combined_evm_msg_info.csv
rm combined_evm_msg_info.csv
ruby -v ~/documents/thennessy/archive/ruby\ source\ materials/Test_csv_file_manipulation/lib/main.rb *.log 1>csv_manipulate_stdout.lst 2>csv_manipulate_stderr.lst
sort sorted_evm_msg_info.csv > sorted__evm_msg_info.csv
ruby -v ~/documents/thennessy/archive/ruby\ source\ materials/Test_csv_file_merge/lib/main.rb *.log 1>csv_merge_stdout.lst 2>csv_merge_stderr.lst
exit


