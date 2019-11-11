#!/usr/bin/env bash
set +x

DBNAME=ludw.db
SCHEMA=schema.sql
SQLITE3=sqlite3

DATAFILE="ml-latest-small"
#DATAFILE="ml-20m"

[[ -e $DATAFILE.zip ]] && rm -rf $DATAFILE.zip ./$DATAFILE
[[ -e $DBNAME ]] && rm -f $DBNAME

wget http://files.grouplens.org/datasets/movielens/$DATAFILE.zip
unzip $DATAFILE.zip

sed -i '1d' $DATAFILE/movies.csv
sed -i '1d' $DATAFILE/ratings.csv

cat $SCHEMA | $SQLITE3 $DBNAME

cat <<EOF | $SQLITE3 $DBNAME
.mode csv
.import $DATAFILE/movies.csv movies
.import $DATAFILE/ratings.csv ratings
.exit
EOF

RAT=`echo "select count(*) from ratings;" | $SQLITE3 $DBNAME`
echo "Imported: $RAT ratings."
