--Streaming Data Analysis using SQL

-- Count the number of Movies vs TV Shows

SELECT type, COUNT(*)
FROM amazonprime
GROUP by type;



-- 2. Find the most common rating for movies and TV shows. Note query other streaming services change FROM table to either hulu, amazonprime, or disneyplus

WITH RatingCounts AS (
    SELECT 
        type,
        rating,
        COUNT(*) AS rating_count
    FROM netflix
    GROUP BY type, rating
),
RankedRatings AS (
    SELECT 
        type,
        rating,
        rating_count,
        RANK() OVER (PARTITION BY type ORDER BY rating_count DESC) AS rank
    FROM RatingCounts
)
SELECT 
    type,
    rating AS most_frequent_rating
FROM RankedRatings
WHERE rank = 1;


-- 3. List all movies and tv shows released in a specific year (e.g., before the year 2000)

SELECT * 
FROM disneyplus
WHERE release_year <= 2000

-- 4. List all TV shows with more than 5 seasons

SELECT *
FROM hulu
WHERE 
  type = 'TV Show'
  AND TRY_CAST(LEFT(duration, CHARINDEX(' ', duration + ' ') - 1) AS INT) > 5;

  -- 5. Identify the longest movie
  SELECT *
FROM disneyplus
WHERE type = 'Movie'
ORDER BY TRY_CAST(LEFT(duration, CHARINDEX(' ', duration + ' ') - 1) AS INT) DESC;

-- 6. List all movies that are documentaries
SELECT * FROM netflix
WHERE listed_in LIKE '%Documentaries'