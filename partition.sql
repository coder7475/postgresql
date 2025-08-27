--- Table with Partition: Base Table
CREATE TABLE events (
	id SERIAL,
	title VARCHAR(255) NOT NULL,
	event_date DATE NOT NULL,
	PRIMARY KEY (id, event_date)
) PARTITION BY RANGE(event_date);

-- Partitioned Tables
-- Jan 2024
CREATE TABLE events_2024_01
PARTITION OF events
FOR VALUES FROM ('2024-01-01') TO ('2024-02-01');

-- Feb 2024
CREATE TABLE events_2024_02
PARTITION OF events
FOR VALUES FROM ('2024-02-01') TO ('2024-03-01');

-- March 2024
CREATE TABLE events_2024_03
PARTITION OF events
FOR VALUES FROM ('2024-03-01') TO ('2024-04-01');

-- April 2024
CREATE TABLE events_2024_04
PARTITION OF events
FOR VALUES FROM ('2024-04-01') TO ('2024-05-01');

INSERT INTO events (title, event_date) VALUES
('Team Meeting', '2024-01-01'),
('Project Kickoff', '2024-01-02'),
('Client Presentation', '2024-01-03'),
('Product Launch', '2024-01-04'),
('Sales Review', '2024-01-05'),
('Budget Planning', '2024-01-06'),
('Training Session', '2024-01-07'),
('Team Building', '2024-01-08'),
('Marketing Strategy', '2024-01-09'),
('Board Meeting', '2024-01-10'),
('Performance Review', '2024-01-11'),
('Quarterly Planning', '2024-01-12'),
('Customer Feedback', '2024-01-13'),
('Technical Workshop', '2024-01-14'),
('HR Meeting', '2024-01-15'),
('Audit Session', '2024-01-16'),
('Product Demo', '2024-01-17'),
('Strategy Review', '2024-01-18'),
('Networking Event', '2024-01-19'),
('Company Townhall', '2024-01-20'),
('Sales Training', '2024-01-21'),
('Tech Conference', '2024-01-22'),
('Annual Review', '2024-01-23'),
('Development Sprint', '2024-01-24'),
('Client Onboarding', '2024-01-25'),
('Leadership Meeting', '2024-01-26'),
('Compliance Training', '2024-01-27'),
('PR Campaign', '2024-01-28'),
('Innovation Workshop', '2024-01-29'),
('Product Testing', '2024-01-30'),
('Financial Review', '2024-01-31'),
('Customer Support', '2024-02-01'),
('Design Meeting', '2024-02-02'),
('Marketing Review', '2024-02-03'),
('Vendor Meeting', '2024-02-04'),
('Website Update', '2024-02-05'),
('Content Planning', '2024-02-06'),
('Sales Forecast', '2024-02-07'),
('Risk Assessment', '2024-02-08'),
('Budget Review', '2024-02-09'),
('Product Roadmap', '2024-02-10'),
('Team Lunch', '2024-02-11'),
('IT Maintenance', '2024-02-12'),
('Social Media Planning', '2024-02-13'),
('Customer Meeting', '2024-02-14'),
('Recruitment Drive', '2024-02-15'),
('Performance Metrics', '2024-02-16'),
('Sales Strategy', '2024-02-17'),
('Product Update', '2024-02-18'),
('Customer Training', '2024-02-19'),
('Executive Meeting', '2024-02-20'),
('Product Research', '2024-02-21'),
('Content Review', '2024-02-22'),
('Internal Audit', '2024-02-23'),
('Quality Testing', '2024-02-24'),
('Design Review', '2024-02-25'),
('Career Development', '2024-02-26'),
('Team Workshop', '2024-02-27'),
('Product Feedback', '2024-02-28'),
('Financial Planning', '2024-02-29'),
('Marketing Analytics', '2024-03-01'),
('Project Update', '2024-03-02'),
('Customer Interview', '2024-03-03'),
('New Hire Orientation', '2024-03-04'),
('Strategy Session', '2024-03-05'),
('Tech Support', '2024-03-06'),
('Competitive Analysis', '2024-03-07'),
('Board Presentation', '2024-03-08'),
('Recruitment Interview', '2024-03-09'),
('Product Brainstorming', '2024-03-10'),
('Vendor Evaluation', '2024-03-11'),
('Customer Survey', '2024-03-12'),
('Budget Approval', '2024-03-13'),
('Sales Meeting', '2024-03-14'),
('Team Sync', '2024-03-15'),
('Product Workshop', '2024-03-16'),
('Tech Demo', '2024-03-17'),
('Client Feedback', '2024-03-18'),
('Project Planning', '2024-03-19'),
('Employee Training', '2024-03-20'),
('Marketing Launch', '2024-03-21'),
('Product Deployment', '2024-03-22'),
('Support Session', '2024-03-23'),
('Leadership Training', '2024-03-24'),
('Financial Forecast', '2024-03-25'),
('Customer Appreciation', '2024-03-26'),
('Annual Budget', '2024-03-27'),
('Website Launch', '2024-03-28'),
('Team Offsite', '2024-03-29'),
('Product Strategy', '2024-03-30'),
('Sales Promotion', '2024-03-31'),
('Customer Success', '2024-04-01'),
('Compliance Check', '2024-04-02'),
('Tech Upgrades', '2024-04-03'),
('HR Workshop', '2024-04-04'),
('Project Demo', '2024-04-05'),
('Content Launch', '2024-04-06'),
('Team Retrospective', '2024-04-07'),
('Product Planning', '2024-04-08'),
('Customer Strategy', '2024-04-09'),
('Sales Kickoff', '2024-04-10');


-- Query
SELECT 
	DATE_TRUNC('month', event_date) as month,
	COUNT(*) as event_count
FROM events
GROUP BY month
ORDER BY month;


-- Function to month TO TEXT
CREATE OR REPLACE FUNCTION month_name_from_int(m integer)
	RETURNS text
	LANGUAGE sql
AS $$
	SELECT to_char(make_date(2000, m, 1), 'FMMonth')
$$



-- Query
-- Count events by month
SELECT 
	EXTRACT(Month FROM event_date) as month_no,
	month_name_from_int(EXTRACT(Month FROM event_date)::INT) AS month,
	COUNT(*) as event_count
FROM events
GROUP BY month_no
ORDER BY month_no;


-- Count Events By week days (0-6)
SELECT 
	EXTRACT(DOW FROM event_date) AS day_of_week,
	COUNT(*) AS event_week
FROM events
GROUP BY day_of_week
ORDER BY day_of_week;


EXPLAIN ANALYZE SELECT * FROM events;


EXPLAIN ANALYZE SELECT * FROM events
WHERE id = 2;


EXPLAIN ANALYZE SELECT * FROM events
WHERE id IN (3, 44, 55);

EXPLAIN ANALYZE SELECT * FROM events
WHERE event_date >= '2024-01-01' AND event_date <= '2024-01-30'








