#!/bin/bash
rm combined_large_interger.csv
rm sorted_combined_large_integer.csv
for analyzd in *_analyzd ; do
    cat $analyzd/diagnostic_data/large_integer_evm.csv >> combined_large_integer.csv
done
sort combined_large_integer.csv > sorted_combined_large_integer.csv
distill_record_ids.awk sorted_combined_large_integer.csv
