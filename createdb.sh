#!/usr/bin/env bash


DBNAME=ludw.db
SCHEMA=schema.sql
SQLITE3=sqlite3

DATAFILE="ml-latest-small"
#DATAFILE="ml-20m"

[[ -e $DATAFILE.zip ]] && rm -f $DATAFILE.zip
[[ -e $DBNAME ]] && rm -f $DBNAME

wget http://files.grouplens.org/datasets/movielens/$DATAFILE.zip
unzip $DATAFILE.zip

set -i '1d' $DATAFILE/movies.csv
set -i '1d' $DATAFILE/ratings.csv

cat $SCHEMA | $SQLITE3 $DBNAME

cat <<EOF | $SQLITE3 $DBNAME
.mode csv
.import $DATAFILE/movies.csv movies
.import $DATAFILE/ratings.csv movies
.exit
EOF

echo "count (*) from table ratings;" | $SQLITE3 $DBNAME
