#/bin/bash
tar -xzf $1
mv config/ log
mv var/ log
mv BUILD log
mv VERSION log
mv GUID  log
mv opt/rh/postgresql92/root/var/lib/pgsql/data/pg_log/* log 
rm -r opt/rh/postgresql92/root/var/lib/pgsql/data/pg_log
mv opt/rh/postgresql92/root/var/lib/pgsql/data/* log 
rm -fr opt
zip -r temp_normalized log   
#for /F "delims=_ tokens=4-6 " %%i in (' dir $1 ') do call mv temp_normalized.zip %%i_%%j_%%~nk.zip
mv temp_normalized.zip $(echo ${1%.*} | cut -d '_' -f 4,5,6).zip
rm -rf log                                                                                                                                               
