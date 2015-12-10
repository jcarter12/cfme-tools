del combined_evm_msg_info.csv
del filtered_combined_evm_msg_info.csv
for /d %%i in (*_analyzd) do cat %%i/diagnostic_data/evm_msg_info.csv >> combined_evm_msg_info.csv
gawk -f c:/awk/filter_combined_evm_msg_info.awk combined_evm_msg_info.csv
del combined_evm_msg_info.csv
ruby  -v  "C:\documents and settings\administrator\my documents\NetBeansProjects\Test_csv_file_manipulation\lib\main.rb" *.log 1>csv_manipulate_stdout.lst 2>csv_manipulate_stderr.lst
sort /+1 sorted_evm_msg_info.csv > sorted__evm_msg_info.csv
ruby  -v  "C:\documents and settings\administrator\my documents\NetBeansProjects\Test_csv_file_merge\lib\main.rb" *.log 1>csv_merge_stdout.lst 2>csv_merge_stderr.lst
exit


