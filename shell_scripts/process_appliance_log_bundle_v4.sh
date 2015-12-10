#!/bin/bash
ruby -v ~/documents/thennessy/archive/ruby\ source\ materials/Process_appliance_log_bundle/lib/Process_appliance_log_bundle.rb 1>stdout.lst 2>stderr.lst

for analyzd in *_analyzd ; do
  if [ -d "$analyzd" ]; then
    cd $analyzd
    EVM_V4_Hourly_HealthCheck_v39.awk evm.log > hourly_healthcheck.csv &
    launch_analysis.sh
    cd ..
  fi
done
