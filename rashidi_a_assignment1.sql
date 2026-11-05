-- Aria Rashidi, Assignment 1
-- Schema: Movie(mID, title, year, director)
--         Reviewer(rID, name)
--         Rating(rID, mID, stars, ratingDate)

-- Question 1.
SELECT title
FROM Movie
WHERE director = 'Steven Spielberg';

-- Question 2.
SELECT DISTINCT m.year
FROM Movie m
JOIN Rating r ON m.mID = r.mID
WHERE r.stars IN (4, 5)
ORDER BY m.year;

-- Question 3.
SELECT title
FROM Movie
WHERE mID NOT IN (SELECT mID FROM Rating);

-- Question 4.
SELECT DISTINCT rv.name
FROM Reviewer rv
JOIN Rating r ON rv.rID = r.rID
WHERE r.ratingDate IS NULL;

-- Question 5.
SELECT rv.name, m.title, r.stars, r.ratingDate
FROM Rating r
JOIN Reviewer rv ON r.rID = rv.rID
JOIN Movie m     ON r.mID = m.mID
ORDER BY rv.name, m.title, r.stars;

-- Question 6.
SELECT rv.name, m.title
FROM Rating r1
JOIN Rating r2   ON r1.rID = r2.rID
                AND r1.mID = r2.mID
                AND r2.ratingDate > r1.ratingDate
                AND r2.stars > r1.stars
JOIN Reviewer rv ON r1.rID = rv.rID
JOIN Movie m     ON r1.mID = m.mID
WHERE r1.rID IN (
    SELECT rID FROM Rating
    GROUP BY rID, mID
    HAVING COUNT(*) = 2
);

-- Question 7.
SELECT m.title, MAX(r.stars) AS max_stars
FROM Movie m
JOIN Rating r ON m.mID = r.mID
GROUP BY m.mID, m.title
ORDER BY m.title;

-- Question 8.
SELECT m.title, MAX(r.stars) - MIN(r.stars) AS rating_spread
FROM Movie m
JOIN Rating r ON m.mID = r.mID
GROUP BY m.mID, m.title
ORDER BY rating_spread DESC, m.title;

-- Question 9. 
SELECT
    (SELECT AVG(avg_stars) FROM (
        SELECT AVG(r.stars) AS avg_stars
        FROM Movie m JOIN Rating r ON m.mID = r.mID
        WHERE m.year < 1980
        GROUP BY m.mID
    ) AS before_1980)
  -
    (SELECT AVG(avg_stars) FROM (
        SELECT AVG(r.stars) AS avg_stars
        FROM Movie m JOIN Rating r ON m.mID = r.mID
        WHERE m.year >= 1980
        GROUP BY m.mID
    ) AS after_1980)
  AS avg_difference;
