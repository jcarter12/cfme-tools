#/bin/bash
$1
cd $2
ruby -v ~/documents/thennessy/archive/ruby\ source\ materials/TrackProvision/lib/main.rb *.log 1>TrackProvision_stdout.lst 2>TrackProvision_stderr.lst
