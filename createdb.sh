#!/usr/bin/env bash
set -x

#DATAFILE="ml-latest-small"
DATAFILE="ml-20m"

DBNAME=movies.db
SCHEMA=schema.sql
QUERY=query.sql
SQLITE3=sqlite3

OS=`uname`

#If on mac we already have the tools
if [ $OS == "Linux" ]
then
  apt-get install -y curl unzip sqlite3
fi

[[ -e $DBNAME ]] && rm -f $DBNAME

if [ ! -e $DATAFILE.zip ]
then
  curl -LO http://files.grouplens.org/datasets/movielens/$DATAFILE.zip
  rm -rf ./$DATAFILE
  unzip $DATAFILE.zip
  sed -iXXX 1d $DATAFILE/movies.csv
  sed -iXXX 1d $DATAFILE/ratings.csv
else
  echo "Files already downloaded"
fi

cat $SCHEMA | $SQLITE3 $DBNAME

echo "Starting importing into DB."
time cat <<EOF | $SQLITE3 $DBNAME
.mode csv
.import $DATAFILE/movies.csv movies
.import $DATAFILE/ratings.csv ratings
.exit
EOF

RAT=`echo "select count(*) from ratings;" | $SQLITE3 $DBNAME`
echo "Imported: $RAT ratings."
echo


echo "Selecting Top 15 movies with more than 200 ratings."
time cat $QUERY | $SQLITE3 $DBNAME
