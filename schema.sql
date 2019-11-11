-- movieId,title,genres
DROP TABLE IF EXISTS movies;
create table movies(
  movieID INTEGER,
  title TEXT,
  genres TEXT);

--userId,movieId,rating,timestamp
DROP TABLE IF EXISTS ratings;
create table ratings(
  userID INTEGER,
  movieID INTEGER,
  rating FLOAT,
  rating_date TEXT
);
