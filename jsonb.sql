DROP TABLE IF EXISTS products;
-- JSON Table
CREATE TABLE products (
	id SERIAL PRIMARY KEY,
	name TEXT NOT NULL,
	specs JSONB NOT NULL
);

-- insert data
INSERT INTO products (name, specs) VALUES
('smartphone', '{
  "brand": "Acme",
  "model": "X200",
  "dimensions": {
	"width": 40,
	"height": 40,
	"depth": 40
  },
  "features": ["4G", "64GB Storage", "12MP Camera"],
  "price": 299.99,
  "available": true
}'),
('laptop', '{
  "brand": "TechCo",
  "model": "L500",
  "dimensions": {
	"width": 40,
	"height": 40,
	"depth": 40
  },
  "specs": {
    "cpu": "Intel i7",
    "ram": "16GB",
    "storage": "512GB SSD"
  },
  "price": 1099.99,
  "available": false
}'),
('tablet', '{
  "brand": "Gizmo",
  "model": "Tab10",
  "screen_size": 10.1,
  "dimensions": {
	"width": 40,
	"height": 40,
	"depth": 40
  },
  "price": 399.99,
  "available": true
}');

-- find datas
SELECT * FROM products;


-- find data from json
SELECT 
	id,
	specs->'brand',
	specs->>'brand' AS brand,
	specs->>'features' AS features,
	specs#>'{dimensions, width}' AS width,
	specs#>>'{dimensions, height}' AS height
FROM products;

-- Filter
-- Is product aviable
SELECT * FROM products
WHERE specs->>'available' = 'true';


-- is acme available
SELECT * FROM products
WHERE specs @> '{
"brand": "Acme"
}'

SELECT * FROM products
WHERE specs ? 'brand';

SELECT * FROM products
WHERE specs ? 'screen_size';

SELECT * FROM products
WHERE specs->'features' ? '4G';


-- Modify JSON data
-- Update dimensions
UPDATE products
SET specs = jsonb_set(
	specs,
	'{dimensions, width}',
	'60',
	false
) WHERE id = 1;

-- add new feature
UPDATE products
SET specs = jsonb_set(
	specs,
	'{features}',
	(specs->'features') || '"500 mA Battery"',
	false
) WHERE id = 1;

SELECT * FROM products;

-- Update Brand
UPDATE products
SET specs = jsonb_set(
	specs,
	'{brand}',
	'"Acme New"',
	false
) WHERE id = 1;

-- add new value to json
UPDATE products
SET specs = specs || '{"price": 1200}'
WHERE id = 1;

SELECT * FROM products
WHERE id = 1;

-- add property to each json
UPDATE products
SET specs = specs || '{"color": "black"}'


-- remove new value to json
UPDATE products
SET specs = specs - 'price'
WHERE id = 1;


-- remove from nested dimemsions
UPDATE products
SET specs = specs #- '{dimensions, depth}'
WHERE id = 1;

SELECT * FROM products;

