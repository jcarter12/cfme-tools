#/bin/bash
tar -xzf  $1 --exclude=lastlog
mv config/ log
mv var/ log
mv BUILD log
mv VERSION log
mv GUID  log
mv opt/rh/postgresql92/root/var/lib/pgsql/data/pg_log/* log 
rm -r opt/rh/postgresql92/root/var/lib/pgsql/data/pg_log
mv opt/rh/postgresql92/root/var/lib/pgsql/data/* log 
rm -rf opt
zip -r temp_normalized log   
mv temp_normalized.zip $(echo ${1%.*} | cut -d '_' -f 3,4,5).zip
rm -rf log opt                                                                                                                                              
