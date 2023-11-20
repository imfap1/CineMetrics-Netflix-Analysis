-- 1) OLDEST MOVIES IN NETFLIX

SELECT 
    type, title, release_year, date_added
FROM
    movies
WHERE
    type = 'Movie' AND release_year < 1990
ORDER BY release_year ASC;

-- 2) TOP 5 DIRECTORS

with most_common_director as (select director, count(*) num_movies from movies
where director is not null
group by director)

select director, num_movies
from most_common_director
ORDER BY num_movies DESC
LIMIT 5;

-- 3) "Total Count of Films by Countries"

SELECT 
    TRIM(country_split) AS COUNTRY, COUNT(country_split) AS COUNT
FROM (
    SELECT
        SUBSTRING_INDEX(SUBSTRING_INDEX(COUNTRY, ',', n), ',', -1) AS country_split
    FROM (
        SELECT		
            COUNTRY,
            1 + (LENGTH(COUNTRY) - LENGTH(REPLACE(COUNTRY, ',', ''))) AS n
        FROM
            MOVIES
        WHERE
            COUNTRY IS NOT NULL
    ) AS country_subquery
) AS country_split_subquery
GROUP BY COUNTRY
ORDER BY COUNT DESC;


-- 4 TOP 5 countries with more movies;

SELECT 
    TYPE, TRIM(country_split) AS COUNTRY, COUNT(country_split) AS COUNT
FROM (
    SELECT
        TYPE,
        SUBSTRING_INDEX(SUBSTRING_INDEX(COUNTRY, ',', n), ',', -1) AS country_split
    FROM (
        SELECT
            TYPE,
            COUNTRY,
            1 + (LENGTH(COUNTRY) - LENGTH(REPLACE(COUNTRY, ',', ''))) AS n
        FROM
            MOVIES
        WHERE
            COUNTRY IS NOT NULL AND type = 'Movie'
    ) AS country_subquery
) AS country_split_subquery
GROUP BY TYPE, COUNTRY
ORDER BY COUNT DESC
limit 5;


-- 5) TOP 5 countries with more TV Shows;

SELECT 
    TYPE,
    TRIM(country_split) AS COUNTRY,
    COUNT(country_split) AS COUNT
FROM
    (SELECT 
        TYPE,
            SUBSTRING_INDEX(SUBSTRING_INDEX(COUNTRY, ',', n), ',', - 1) AS country_split
    FROM
        (SELECT 
        TYPE,
            COUNTRY,
            1 + (LENGTH(COUNTRY) - LENGTH(REPLACE(COUNTRY, ',', ''))) AS n
    FROM
        MOVIES
    WHERE
        COUNTRY IS NOT NULL AND type = 'TV show') AS country_subquery) AS country_split_subquery
GROUP BY TYPE , COUNTRY
ORDER BY COUNT DESC
LIMIT 5;



-- 6) Count of Movies and TV Shows by Type

SELECT 
    type, COUNT(*) AS count
FROM
    movies
GROUP BY type;

-- 7) Count of Movies by Rating

SELECT 
    rating, COUNT(rating) count
FROM
    movies
WHERE
    rating IS NOT NULL
GROUP BY rating
ORDER BY count DESC;

-- 8) Content added over years

SELECT type,
    DATE(Date_Added) AS Year_Added,
    COUNT(*) AS Content_Count
FROM 
    movies
WHERE 
    Date_Added IS NOT NULL
GROUP BY type,
    Year_Added
ORDER BY 
    Year_Added;

-- 9) Content added per month    
    
SELECT 
    YEAR(Date_Added) AS Year_Added,
    MONTH(Date_Added) AS Month_Added,
    COUNT(*) AS Content_Count
FROM 
    movies
WHERE 
    Date_Added IS NOT NULL
GROUP BY 
    Year_Added, Month_Added
ORDER BY 
    Year_Added, Month_Added;
    
-- 10) Count of genre of movies and tv show     
SELECT 
    TRIM(Genre) AS Clean_Genre,
    COUNT(*) AS Count
FROM (
    SELECT 
        SUBSTRING_INDEX(SUBSTRING_INDEX(m.listed_in, ',', numbers.n), ',', -1) AS Genre
    FROM 
        (SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 /* ... hasta el número máximo de géneros ... */) numbers
    INNER JOIN 
        MOVIES m
    ON 
        CHAR_LENGTH(m.listed_in) - CHAR_LENGTH(REPLACE(m.listed_in, ',', '')) >= numbers.n - 1
    WHERE 
        m.listed_in IS NOT NULL
    ) AS Genres_Subquery
GROUP BY 
    Clean_Genre
ORDER BY 
    Count DESC;
