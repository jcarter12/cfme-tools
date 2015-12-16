echo on
del combined_large_interger.csv /q
del sorted_combined_large_integer.csv /q
for /d %%i in (*_analyzd) do cat %%i/diagnostic_data/large_integer_evm.csv >> combined_large_integer.csv
sort combined_large_integer.csv > sorted_combined_large_integer.csv
gawk -f c:/awk/distill_record_ids.awk sorted_combined_large_integer.csv
exit