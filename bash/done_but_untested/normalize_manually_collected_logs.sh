#!/bin/bash
tar -zxf $1
mkdir log
cp -a var\www\miq\vmdb\log\*.* log\*.*
for $dir in GUID VERSION BUILD; do
	cp -a var/www/miq/vmdb/$dir log/*.*
cp -a var/lib/pgsql/data/*.* log/*.*
rm -fr var
tar -acf $1.zip log\
rm -fr log
