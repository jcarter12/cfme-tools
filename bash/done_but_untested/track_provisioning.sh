#/bin/bash
$1
cd $2
ruby -v ../ruby/TrackProvision/main.rb *.log 1>TrackProvision_stdout.lst 2>TrackProvision_stderr.lst
