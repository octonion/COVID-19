#!/bin/bash

cmd="psql template1 --tuples-only --command \"select count(*) from pg_database where datname = 'covid19';\""

db_exists=`eval $cmd`
 
if [ $db_exists -eq 0 ] ; then
   cmd="createdb covid19;"
   eval $cmd
fi

psql covid19 -f schema/create_schema.sql

mkdir /tmp/data

cp csse_covid_19_data/csse_covid_19_daily_reports/03-2[3456789]-*.csv /tmp/data
cp csse_covid_19_data/csse_covid_19_daily_reports/03-3[01]-*.csv /tmp/data
cp csse_covid_19_data/csse_covid_19_daily_reports/0[456789]-*.csv /tmp/data
cp csse_covid_19_data/csse_covid_19_daily_reports/1?-*.csv /tmp/data

dos2unix /tmp/data/*

for file in /tmp/data/*
do
    sed -i -e '$a\' $file
done

#sed -e 's/$/,,,,/' -i /tmp/data/0[12]-*2020.csv
#sed -e 's/$/,,/' -i /tmp/data/0[3]-[01]*2020.csv
#sed -e 's/$/,,/' -i /tmp/data/0[3]-2[012]*2020.csv

perl -p -i -e 's/$/,$ARGV/;' /tmp/data/*.csv

# v3 data

tail -q -n+2 /tmp/data/05-29-2020.csv > /tmp/dailies.csv
tail -q -n+2 /tmp/data/05-3?-2020.csv >> /tmp/dailies.csv
tail -q -n+2 /tmp/data/0[6789]-*.csv >> /tmp/dailies.csv
tail -q -n+2 /tmp/data/1?-*.csv >> /tmp/dailies.csv
psql covid19 -f loaders/load_csse_dailies_v4.sql

# v2 data

tail -q -n+2 /tmp/data/0[34]-*.csv > /tmp/dailies.csv
tail -q -n+2 /tmp/data/05-[01]*.csv >> /tmp/dailies.csv
tail -q -n+2 /tmp/data/05-2[012345678]-*.csv >> /tmp/dailies.csv
psql covid19 -f loaders/load_csse_dailies_v2.sql

rm /tmp/dailies.csv
rm /tmp/data/*
rmdir /tmp/data

cp excess/ft_excess_deaths.csv /tmp/ft_excess_deaths.csv
psql covid19 -f loaders/load_ft_excess_deaths.sql
rm /tmp/ft_excess_deaths.csv
