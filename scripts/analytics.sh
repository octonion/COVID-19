#!/bin/bash

psql covid19 -f analytics/mortality.sql > analytics/mortality.txt
cp /tmp/mortality.csv analytics/mortality.csv

psql covid19 -f analytics/overall.sql > analytics/overall.txt
cp /tmp/overall.csv analytics/overall.csv
