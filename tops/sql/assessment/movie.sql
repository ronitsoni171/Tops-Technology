create database movies;
use movies;

CREATE TABLE users (
    user_id INT PRIMARY KEY,
    name VARCHAR(50),
    country VARCHAR(50)
);

CREATE TABLE movies (
    movie_id INT PRIMARY KEY,
    title VARCHAR(100),
    genre VARCHAR(50),
    release_year INT
);

CREATE TABLE ratings (
    user_id INT,
    movie_id INT,
    rating INT,
    rating_date DATE,
    PRIMARY KEY (user_id, movie_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id)
);

CREATE TABLE watch_history (
    user_id INT,
    movie_id INT,
    watch_date DATE,
    PRIMARY KEY (user_id, movie_id, watch_date),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (movie_id) REFERENCES movies(movie_id)
);

INSERT INTO users VALUES
(1, 'Alice', 'USA'),
(2, 'Bob', 'UK'),
(3, 'Carol', 'India'),
(4, 'Dave', 'USA'),
(5, 'Eve', 'Canada'),
(6, 'Frank', 'Germany');

INSERT INTO movies  VALUES
(101, 'Space Odyssey', 'Sci-Fi', 2021),
(102, 'Love in Paris', 'Romance', 2019),
(103, 'Action Heroes', 'Action', 2022),
(104, 'Mystery Manor', 'Mystery', 2020),
(105, 'Comedy Nights', 'Comedy', 2023),
(106, 'Thriller Heights', 'Thriller', 2021);

INSERT INTO ratings VALUES
(1, 101, 5, '2023-01-10'),
(1, 102, 4, '2023-01-15'),
(2, 101, 3, '2023-02-20'),
(2, 103, 5, '2023-02-22'),
(3, 104, 5, '2023-03-05'),
(4, 101, 5, '2023-03-10'),
(5, 105, 4, '2023-03-12'),
(6, 106, 5, '2023-03-15');

INSERT INTO watch_history VALUES
(1, 101, '2023-01-05'),
(1, 102, '2023-01-12'),
(2, 101, '2023-02-18'),
(2, 103, '2023-02-21'),
(3, 104, '2023-03-02'),
(4, 101, '2023-03-08'),
(5, 105, '2023-03-10'),
(6, 106, '2023-03-12'),
(1, 101, '2023-03-20');

-- Top 3 most-watched genres per country
SELECT country, genre, COUNT(*) AS watch_count
FROM watch_history w
JOIN users u ON w.user_id = u.user_id
JOIN movies m ON w.movie_id = m.movie_id
GROUP BY country, genre
ORDER BY country, watch_count DESC;

-- Identify users who rated more than 20 movies
SELECT u.user_id, u.name, COUNT(r.movie_id) AS rated_count
FROM ratings r
JOIN users u ON r.user_id = u.user_id
GROUP BY u.user_id, u.name
HAVING COUNT(r.movie_id) > 20;

-- Find movies released after 2020 that have never been watched
SELECT m.movie_id, m.title
FROM movies m
LEFT JOIN watch_history w ON m.movie_id = w.movie_id
WHERE m.release_year > 2020 AND w.movie_id IS NULL;

-- Compute the average rating per genre
SELECT m.genre, AVG(r.rating) AS avg_rating
FROM movies m
JOIN ratings r ON m.movie_id = r.movie_id
GROUP BY m.genre;

-- List users who gave 5-star ratings to all movies in a genre
SELECT u.user_id, u.name, m.genre
FROM users u
JOIN ratings r ON u.user_id = r.user_id
JOIN movies m ON r.movie_id = m.movie_id
GROUP BY u.user_id, u.name, m.genre
HAVING COUNT(CASE WHEN r.rating = 5 THEN 1 END) = COUNT(m.movie_id);

-- Identify movies watched by users from at least 5 different countries
SELECT m.movie_id, m.title
FROM watch_history w
JOIN users u ON w.user_id = u.user_id
JOIN movies m ON w.movie_id = m.movie_id
GROUP BY m.movie_id, m.title
HAVING COUNT(DISTINCT u.country) >= 5;

-- Find the average number of movies watched per user per month
SELECT AVG(monthly_count) AS avg_movies_per_user_per_month
FROM (
    SELECT user_id, YEAR(watch_date) AS yr, MONTH(watch_date) AS mn, COUNT(*) AS monthly_count
    FROM watch_history
    GROUP BY user_id, YEAR(watch_date), MONTH(watch_date)
) AS monthly_data;

-- List users who watched the same movie more than once
SELECT user_id, movie_id, COUNT(*) AS watch_count
FROM watch_history
GROUP BY user_id, movie_id
HAVING COUNT(*) > 1;

-- Count how many movies have ratings but were never watched
SELECT COUNT(DISTINCT r.movie_id) AS unwatched_but_rated
FROM ratings r
LEFT JOIN watch_history w ON r.movie_id = w.movie_id
WHERE w.movie_id IS NULL;

-- Identify the genre with the highest average 5-star rating count
SELECT genre
FROM (
    SELECT m.genre, AVG(CASE WHEN r.rating = 5 THEN 1 ELSE 0 END) AS avg_5star_count
    FROM movies m
    JOIN ratings r ON m.movie_id = r.movie_id
    GROUP BY m.genre
) AS genre_avg
ORDER BY avg_5star_count DESC
LIMIT 1;