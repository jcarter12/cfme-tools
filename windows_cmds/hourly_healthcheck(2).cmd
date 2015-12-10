time /T
rem gawk -f c:\awk\gawk.txt evm.log >hourly_healthcheck.csv
gawk -f c:\awk\EVM_V3_Hourly_HealthCheck.awk evm.log > hourly_healthcheck.csv
time /T
exit