tar -xzf %1
mv config/ log
mv var/ log
mv BUILD log
mv VERSION log
mv GUID  log
mv opt/rh/postgresql92/root/var/lib/pgsql/data/pg_log/* log 

pushd  opt\rh\postgresql92\root\var\lib\pgsql\data\
rmdir pg_log
popd
mv opt/rh/postgresql92/root/var/lib/pgsql/data/* log 
rm -fr opt var config

rem zip temp_zipfile log
"c:\program files\7-zip\7z" a temp_normalized.zip log   
for /F "delims=_ tokens=4-6 " %%i in (' dir %1 ') do call rename temp_normalized.zip %%i_%%j_%%~nk.zip
rm -fr log                                                                                                                                               
                                                                                                                                                    