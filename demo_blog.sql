DROP TABLE IF EXISTS users CASCADE;
DROP TYPE IF EXISTS role CASCADE;

CREATE TYPE role AS ENUM ('admin', 'user');

-- Create a Table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,    
    password VARCHAR(255) NOT NULL,
    bio TEXT,
    role ROLE NOT NULL DEFAULT 'user',
    avatar TEXT,
    dob DATE
);

-- Insert Dummy Data
INSERT INTO users (name, email, password, bio, role, avatar, dob)
VALUES 
    ('Masud Karim', 'masud@example.com', '12345', 'Tech enthusiast and backend developer.', 'user', 'https://i.pravatar.cc/150?img=1', '1995-03-15'),
    ('Sajib Ahmed', 'sajib@example.com', '12345', 'Loves building scalable systems.', 'admin', 'https://i.pravatar.cc/150?img=2', '1990-08-21'),
    ('Akash Rahman', 'akash@example.com', '12345', 'UI/UX designer and frontend wizard.', 'user', 'https://i.pravatar.cc/150?img=3', '1998-12-05'),
    ('Nusrat Jahan', 'nusrat@example.com', '12345', 'Data scientist with a passion for AI.', 'user', 'https://i.pravatar.cc/150?img=4', '1994-06-30'),
    ('Tanvir Hasan', 'tanvir@example.com', '12345', 'DevOps engineer, cloud native believer.', 'admin', 'https://i.pravatar.cc/150?img=5', '1989-01-12');
    
-- Query the table
SELECT * FROM users;

SELECT COUNT(*) FROM users;

--- CREATE POST TABLE
CREATE TABLE posts (
	id SERIAL PRIMARY KEY,
	title VARCHAR(100) NOT NULL,
	content TEXT,
	author_id INT NOT NULL REFERENCES users(id), --- Foreign key to user table
	created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	published_at TIMESTAMPTZ
);


-- Insert dummy data
INSERT INTO posts (title, content, author_id, published_at)
VALUES
    ('PostgreSQL Basics', 
     'This post covers the basics of PostgreSQL including tables, indexes, and queries.', 
     1, 
     '2025-01-15 10:00:00+06'),

    ('Scaling with Node.js', 
     'Learn how to scale your Node.js applications horizontally and vertically.', 
     2, 
     '2025-02-10 14:30:00+06'),

    ('Mastering React Hooks', 
     'Hooks let you use state and other React features without writing a class.', 
     3, 
     '2025-03-05 09:15:00+06'),

    ('Data Science in Python', 
     'We explore NumPy, Pandas, and Matplotlib for data analysis and visualization.', 
     4, 
     NULL), -- not yet published

    ('CI/CD with GitHub Actions', 
     'Automate your deployment pipelines with GitHub Actions and Docker.', 
     5, 
     '2025-04-20 16:45:00+06');
     
-- View data
SELECT * FROM posts;


-- post_views
CREATE TABLE post_views (
	id INT PRIMARY KEY REFERENCES posts(id),
	count INT NOT NULL DEFAULT 0
);

-- Insert dummy view counts (matching existing post IDs)
INSERT INTO post_views (id, count)
VALUES
    (1, 150),  -- PostgreSQL Basics
    (2, 320),  -- Scaling with Node.js
    (3, 210),  -- Mastering React Hooks
    (4, 0),    -- Data Science in Python (draft)
    (5, 540);  -- CI/CD with GitHub Actions

-- View table
SELECT * FROM post_views;

-- Create table for post view logs
CREATE TABLE post_view_logs (
    id SERIAL PRIMARY KEY,
    post_id INT NOT NULL REFERENCES posts(id),
    user_id INT NOT NULL REFERENCES users(id),
    timestamp TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Insert dummy data
INSERT INTO post_view_logs (post_id, user_id, timestamp)
VALUES
    (1, 1, '2025-08-10 09:15:00+06'),
    (1, 2, '2025-08-10 09:17:00+06'),
    (2, 3, '2025-08-10 10:05:00+06'),
    (3, 4, '2025-08-10 11:20:00+06'),
    (5, 5, '2025-08-10 12:45:00+06'),
    (1, 3, '2025-08-11 08:10:00+06'),
    (2, 1, '2025-08-11 09:30:00+06'),
    (4, 2, '2025-08-11 10:50:00+06'),
    (5, 4, '2025-08-11 11:15:00+06'),
    (3, 5, '2025-08-11 12:05:00+06');

-- View logs
SELECT * FROM post_view_logs;

-- Create table
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT
);

-- Insert dummy categories
INSERT INTO categories (name, description)
VALUES
    ('Technology', 'Articles and tutorials about software, hardware, and emerging tech trends.'),
    ('Programming', 'Posts related to coding, algorithms, and development practices.'),
    ('Data Science', 'Content about data analysis, machine learning, and AI.'),
    ('DevOps', 'Guides and discussions on CI/CD, automation, and infrastructure.'),
    ('UI/UX Design', 'Resources on user interface and user experience design.');

-- View data
SELECT * FROM categories;

-- CREATE post_categories table - join table
CREATE TABLE post_categories (
	post_id INT NOT NULL REFERENCES posts(id),
	category_id INT NOT NULL REFERENCES categories(id),
	PRIMARY KEY (post_id, category_id) -- Composite primary key
);


INSERT INTO post_categories (post_id, category_id)
VALUES
    (1, 1), -- PostgreSQL Basics -> Technology
    (1, 2), -- PostgreSQL Basics -> Programming
    (2, 1), -- Scaling with Node.js -> Technology
    (2, 2), -- Scaling with Node.js -> Programming
    (3, 5), -- Mastering React Hooks -> UI/UX Design
    (4, 3), -- Data Science in Python -> Data Science
    (5, 4); -- CI/CD with GitHub Actions -> DevOps

-- COMMENT
CREATE TYPE COMMENT_STATUS AS ENUM ('pending', 'approved', 'rejected');

CREATE TABLE comments (
	id SERIAL PRIMARY KEY,
	post_id INT NOT NULL REFERENCES posts(id),
	user_id INT NOT NULL REFERENCES users(id),
	content TEXT NOT NULL,
	status COMMENT_STATUS NOT NULL DEFAULT 'pending',
	created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-- Dummy comments
INSERT INTO comments (post_id, user_id, content, status, created_at)
VALUES
    (1, 2, 'Great explanation of PostgreSQL basics!', 'approved', '2025-08-10 09:30:00+06'),
    (1, 3, 'This helped me a lot, thanks!', 'approved', '2025-08-10 10:00:00+06'),
    (2, 4, 'Can you also cover scaling databases?', 'pending', '2025-08-11 14:15:00+06'),
    (3, 1, 'Hooks are amazing, good write-up.', 'approved', '2025-08-12 11:45:00+06'),
    (4, 5, 'Please add more examples in the data science post.', 'rejected', '2025-08-12 12:10:00+06'),
    (5, 3, 'CI/CD setup worked perfectly for me.', 'approved', '2025-08-12 13:25:00+06');

-- View inserted comments
SELECT * FROM comments;

--- SELECT
SELECT * FROM users; --- avoid using this

SELECT name, email, dob FROM users; -- specify

--- String Functions
SELECT 
	UPPER(name) AS upper_cased, 
	LENGTH(name) AS name_length,
	email
FROM users;

-- Concate
SELECT name,
	'user: ' || name AS display_name
FROM users;

-- Arithmetic Operation
SELECT id, count, count * 10 AS estimated_reach FROM post_views;

-- Aggregate Functions
SELECT COUNT(*) FROM users;

SELECT AVG(count) AS avg_views FROM post_views;

SELECT id, name, email, EXTRACT(YEAR FROM dob) AS birthyear FROM users;


SELECT 
	title, 
	COALESCE(published_at, CURRENT_DATE) 
FROM posts;

-- FILTER
SELECT * FROM users WHERE role = 'user';

-- AGGREGATE + FILTER
SELECT 
	COUNT(*) FILTER (WHERE role = 'user') AS user_count
FROM users;

-- Users who are 'admin' or 'user'
SELECT *
FROM users
WHERE role = 'admin' OR role = 'user';


-- Users whose name starts with 'A'
SELECT *
FROM users
WHERE name LIKE 'A%';

-- Users whose email contains 'gmail'
SELECT *
FROM users
WHERE email ILIKE '%example%'; -- Case insensitive

-- Users in roles
SELECT *
FROM users
WHERE role IN ('admin', 'user');


-- Users with no phone number
SELECT *
FROM users
WHERE phone IS NULL;

-- Users with phone number
SELECT *
FROM users
WHERE bio IS NOT NULL;

-- PAGINATION
SELECT * FROM users LIMIT 3;
SELECT * FROM users LIMIT 3 OFFSET 3;

-- SORTING
SELECT title, published_at FROM posts
ORDER BY published_at DESC;

--- GROUPING
SELECT author_id, COUNT(*) AS total_posts
FROM posts
GROUP BY author_id;


SELECT role, COUNT(*) AS total_users
FROM users
GROUP BY role;

-- Cartesian product between table 
-- users 5 post 5 = 25 rows
SELECT *
FROM posts, users

SELECT *
FROM posts
CROSS JOIN users;

-- Join  
-- INNER, OUTER (LEFT, RIGHT, FULL)
-- INNER
SELECT *
FROM posts p
JOIN users u
ON p.author_id = u.id;

SELECT *
FROM posts p
INNER JOIN users u
ON p.author_id = u.id;

SELECT p.title, c.content
FROM posts p
INNER JOIN comments c
ON p.id = c.post_id

SELECT * FROM post_views;


SELECT 
	u.name AS author, 
	p.title AS post_title
FROM posts p
INNER JOIN users u
ON p.author_id = u.id;


SELECT 
	pv.id,
	p.title,
	pv.count
FROM posts p
INNER JOIN post_views pv
ON p.id = pv.id;

SELECT 
	pv.id,
	p.title,
	pv.count
FROM posts p
LEFT JOIN post_views pv
ON p.id = pv.id;

SELECT 
	pv.id,
	p.title,
	pv.count
FROM posts p
RIGHT JOIN post_views pv
ON p.id = pv.id;

-- JOIN + GROUP BY = Analytical Data 
-- Find users posts by id
SELECT u.id, u.name,  COUNT(p.id) AS posts
FROM posts p
INNER JOIN users u
ON p.author_id = u.id
GROUP BY u.id;

SELECT u.id, u.name,  COUNT(p.id) AS posts
FROM posts p
LEFT JOIN users u
ON p.author_id = u.id
GROUP BY u.id;

SELECT u.id, u.name,  COUNT(p.id) AS posts
FROM posts p
RIGHT JOIN users u
ON p.author_id = u.id
GROUP BY u.id;

SELECT u.id, u.name,  COUNT(p.id) AS posts
FROM posts p
FULL JOIN users u
ON p.author_id = u.id
GROUP BY u.id;


-- 
SELECT 
	p.title AS post_title, 
	u.name AS commentor,
	c.content,
	c.status AS comment_status
FROM comments c
INNER JOIN posts p
	ON c.post_id = p.id
INNER JOIN users u
	ON u.id = c.user_id
WHERE c.status = 'approved';

-- Sub Query
SELECT *
FROM post_views pv
WHERE pv.count > (
	SELECT AVG(count)
	FROM post_views
)

-- CTE - Common table Expression
WITH avg_count AS (
    SELECT AVG(count) AS avg_count
    FROM post_views
)
SELECT pv.*
FROM post_views pv
JOIN avg_count ac ON pv.count > ac.avg_count;

-- Views
DROP VIEW IF EXISTS active_users;

CREATE VIEW active_users AS (
	SELECT id, name, email
	FROM users
	WHERE role = 'user'
);

-- query the view
SELECT * FROM active_users;


-- Views
DROP VIEW IF EXISTS admins;

CREATE VIEW admins AS (
	SELECT id, name, email
	FROM users
	WHERE role = 'admin'
);

SELECT * FROM admins;



-- Materialized view
DROP MATERIALIZED VIEW IF EXISTS posts_popularity;
--- Cached
CREATE MATERIALIZED VIEW 
	posts_popularity AS (
		SELECT 
			p.id AS post_id, 
			p.title, 
			u.name AS author_name,
			p.published_at
		FROM post_views pv
		JOIN posts p
 			ON pv.id = p.id
		JOIN users u
			ON u.id = p.author_id
		 ORDER BY pv.count DESC
		 LIMIT 5		
	);

SELECT * FROM posts_popularity;

-- Refresh
REFRESH MATERIALIZED VIEW posts_popularity;



-- Indexing
-- B-Tree Indexing
CREATE INDEX idx_usr_role ON users(role);


SELECT * FROM pg_indexes WHERE tablename = 'users';

-- GIN index - fts - full_text_search - more costly 
CREATE INDEX idx_post_title_fts ON posts 
	USING GIN (to_tsvector('english', title));

SELECT * FROM pg_indexes WHERE tablename = 'posts';

SELECT * FROM posts;
-- searching using vector
SELECT * FROM posts WHERE to_tsvector('english', title) @@ plainto_tsquery('github');

-- ANALYZE performance
EXPLAIN ANALYZE SELECT * FROM users;
EXPLAIN ANALYZE SELECT name FROM users;



















