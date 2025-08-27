SELECT * FROM products;

-- get array elements

SELECT 
	id,
	jsonb_array_elements(specs->'features') AS features
FROM products;

-- get json of the features
SELECT jsonb_agg(features) AS all_features
FROM (
	SELECT 
		id,
		jsonb_array_elements(specs->'features') AS features
	FROM products
) AS sub;

-- Build Json Object
SELECT jsonb_build_object(
	'id', p.id,
	'name', p.name,
	'brand', p.specs->'brand'
) AS summary
FROM products p;

-- make rows json object
SELECT to_jsonb(p) AS full_record
FROM products p;











