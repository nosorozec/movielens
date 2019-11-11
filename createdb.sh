#!/usr/bin/env bash
set +x

DBNAME=movies.db
SCHEMA=schema.sql
SQLITE3=sqlite3

#DATAFILE="ml-latest-small"
DATAFILE="ml-20m"


[[ -e $DBNAME ]] && rm -f $DBNAME

if [ ! -e $DATAFILE.zip ]
then
  rm -rf ./$DATAFILE
  curl -LO http://files.grouplens.org/datasets/movielens/$DATAFILE.zip
  unzip $DATAFILE.zip
  sed -i xxx 1d $DATAFILE/movies.csv
  sed -i xxx 1d $DATAFILE/ratings.csv
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

time cat <<EOF | sqlite3 movies.db
.headers on
EXPLAIN QUERY PLAN
SELECT
  m.title AS Title,
  round(AVG(r.rating),2) AS AvgRating,
  COUNT(r.rating) AS NumRatings
FROM movies m JOIN ratings r ON m.movieID=r.movieID
GROUP BY Title
HAVING NumRatings > 200
ORDER BY AvgRating DESC
LIMIT 15;
EOF
