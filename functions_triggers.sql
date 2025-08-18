-- Function Shape
CREATE OR REPLACE FUNCTION function_name(parameters) 
RETURNS return_type AS $$
DECLARE
	-- variable declaration
BEGIN
	-- SQL Statements or logic
	RETURN some_value
END;
$$ LANGUAGE plpgsql;

-- Post count for a given user
CREATE OR REPLACE FUNCTION get_post_count(user_id INT) 
RETURNS INT AS $$
DECLARE
	-- variable declaration
	total_posts INT;
BEGIN
	-- SQL Statements or logic
	SELECT COUNT(*) INTO total_posts
	FROM posts 
	WHERE author_id = user_id;
	
	RETURN total_posts;
END;
$$ LANGUAGE plpgsql;


SELECT get_post_count(2) AS total_posts;

SELECT id, name, get_post_count(2) AS total_posts
FROM users;

-- Post Log Function
CREATE OR REPLACE FUNCTION log_post_view(p_post_id INT, p_user_id INT)
RETURNS void AS $$
BEGIN
	-- INSERT a new row to post_view_log_table
	INSERT INTO post_view_logs (post_id, user_id)
	VALUES (p_post_id, p_user_id)
	ON CONFLICT DO NOTHING;
	
	-- UPDATE post_view_table
	UPDATE post_views 
	SET count = count + 1
	WHERE id = p_post_id;
END;
$$ LANGUAGE plpgsql;

SELECT log_post_view(3,1);

SELECT * FROM post_view_logs;
SELECT * FROM post_views;



-- IsAdmin Function
CREATE OR REPLACE FUNCTION isAdmin(p_user_id INT) 
RETURNS BOOLEAN AS $$
DECLARE
    user_role TEXT;
BEGIN
    SELECT role INTO user_role
    FROM users
    WHERE id = p_user_id;

    IF user_role = 'admin' THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$ LANGUAGE plpgsql;



--- TRIGGER Function
CREATE OR REPLACE FUNCTION function_name(parameters) 
RETURNS TRIGGER AS $$
DECLARE
	-- variable declaration
BEGIN
	-- SQL Statements or logic
	RETURN some_value
END;
$$ LANGUAGE plpgsql;

-- Post_view TRIGGER FUNCTION
CREATE OR REPLACE FUNCTION create_post_view() 
RETURNS TRIGGER AS $$
BEGIN
	INSERT INTO post_views(id, count)
	VALUES (NEW.id, 0);

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;


-- Create the Trigger for post_view trigger function
CREATE TRIGGER trigger_create_post_view
AFTER INSERT ON posts
FOR EACH ROW
EXECUTE FUNCTION create_post_view();


-- Testing trigger

INSERT INTO posts (title, content, author_id)
VALUES
    ('Testing Trigger','Testing.', 1);

SELECT * FROM posts;
SELECT * FROM post_views;





