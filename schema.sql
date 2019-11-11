-- movieId,title,genres
DROP TABLE IF EXISTS movies;
create table movies(
  movieId INTEGER,
  title TEXT,
  genres TEXT);

--userId,movieId,rating,timestamp
--1,2,3.5,1112486027

DROP TABLE IF EXISTS ratings;
create table ratings(
  userId INTEGER,
  movieId INTEGER,
  rating INTEGER,
  rating_date TEXT
);
