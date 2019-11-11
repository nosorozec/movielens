.headers on
PRAGMA threads=4;

SELECT time();

SELECT
  m.title AS Title,
  round(AVG(r.rating),2) AS AvgRating,
  COUNT(r.rating) AS NumRatings
FROM movies m JOIN ratings r ON m.movieID=r.movieID
GROUP BY Title
HAVING NumRatings > 200
ORDER BY AvgRating DESC
LIMIT 15;

SELECT time();
