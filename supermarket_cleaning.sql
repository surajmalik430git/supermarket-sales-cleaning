--Task 1: Remove the blank rows
DELETE  FROM supermarket_clean 
WHERE order_id IS NULL

SELECT COUNT(order_id)from supermarket_clean

-- Task 2: finding  duplicates
SELECT order_id,COUNT('*') AS duplicate
FROM supermarket_clean
WHERE order_id IS NOT NULL
GROUP BY order_id
HAVING COUNT('*')>1
ORDER BY (duplicate) DESC;

-- Task 3: Removing Duplicates
CREATE TABLE supermarket_clean AS
SELECT DISTINCT ON (order_id) *
FROM supermarket
WHERE order_id IS NOT NULL
ORDER BY order_id;

--Task 4: Fix region Question: Look at  region FROM supermarket_clean;. Turn all the spellings into 4 clean values: North, South, East, West, Central (some are short like N. or misspelled).
UPDATE supermarket_clean
SET region = INITCAP(TRIM(region));
update supermarket_clean 
SET region ='North'
WHERE region = 'N.';
UPDATE supermarket_clean 
SET region = 'South'
WHERE region = 'S.';
UPDATE supermarket_clean
SET region = ' Central'
WHERE region = 'Centeral';
SELECT region FROM supermarket_clean

-- Turn all the spellings (Furnature, Applicances, OfficeSupplies, and the rest) into 4 clean values: Furniture, Electronics, Appliances, Office Supplies.
-- Task 4: fix category spellings
UPDATE supermarket_clean
SET category = INITCAP(category);

UPDATE supermarket_clean
SET category = 'Furniture'
WHERE LOWER(category) = 'furnature';

UPDATE supermarket_clean
SET category = 'Appliances'
WHERE LOWER(category) = 'applicances';

UPDATE supermarket_clean
SET category = 'Office Supplies'
WHERE LOWER(category) = 'officesupplies';

UPDATE supermarket_clean
SET category = 'Office Supplies'
WHERE category = 'Office  Supplies'

UPDATE supermarket_clean
SET category = 'Electronics'
WHERE LOWER(category) = 'electronic';

SELECT DISTINCT(category) FROM supermarket_clean

-- Task 5:Remove extra spaces and make the capitalization consistent, so CHAIR and Chair become the same value.
 UPDATE supermarket_clean
 SET product =INITCAP(TRIM(product));
 
 select DISTINCT(product) from supermarket_clean;

 --Task 6: Sales rep E. Wilson, emma wilson and Emma Wilson are the same person. Make each rep have one clean full name across all 10 reps.

 UPDATE supermarket_clean
 set sales_rep = 'Emma Wilson'
 WHERE sales_rep LIKE '%Wilson%';


UPDATE supermarket_clean SET sales_rep ='Carla Diaz'
WHERE sales_rep LIKE '%Diaz%';
UPDATE supermarket_clean SET sales_rep = 'Henry Patel'
WHERE sales_rep LIKE '%Patel%';
UPDATE supermarket_clean SET sales_rep = 'Isabel Rossi'
WHERE sales_rep LIKE '%Rossi%';
UPDATE supermarket_clean SET sales_rep = 'Grace Kim'
WHERE sales_rep LIKE '%Kim%';
UPDATE  supermarket_clean SET sales_rep = 'Frank Tores'
WHERE sales_rep LIKE '%Torres%';
UPDATE  supermarket_clean SET sales_rep = 'Bob Smith'
WHERE sales_rep LIKE '%Smith%';
UPDATE  supermarket_clean SET sales_rep = 'Alice Johnson'
WHERE sales_rep LIKE '%Johnson%';
UPDATE  supermarket_clean SET sales_rep = 'Dave Chen'
WHERE sales_rep LIKE '%Chen%';
UPDATE  supermarket_clean SET sales_rep = 'Jack Nguyen'
WHERE sales_rep LIKE '%Nguyen%';

select  DISTINCT(sales_rep) from supermarket_clean;
 --Task 7: Quantity and unit_priceValues like 2 units, $54.95 and 354.85 USD are text. Keep only the number and change the column to a numeric type. Also check whether any quantities look like data entry mistakes.
-- Task 7: fix quantity and unit_price
UPDATE supermarket_clean
SET quantity = REGEXP_REPLACE(quantity, '[^0-9-]', '', 'g');

UPDATE supermarket_clean
SET unit_price = REGEXP_REPLACE(unit_price, '[^0-9.]', '', 'g');

ALTER TABLE supermarket_clean
ALTER COLUMN quantity TYPE INT
USING NULLIF(quantity, '')::INT;

ALTER TABLE supermarket_clean
ALTER COLUMN unit_price TYPE NUMERIC(10,2)
USING NULLIF(unit_price, '')::NUMERIC(10,2);

UPDATE supermarket_clean
SET quantity = NULL
WHERE quantity < 0;

-- Task8: Your order_date column has dates written in 5 different formats in the same column, for example:
--2025-09-10
--09/30/2025
--15-09-2025
--09.24.25
--April 15, 2025

UPDATE supermarket_clean sc
SET order_date = s.order_date
FROM supermarket s
WHERE sc.order_id = s.order_id;
ALTER TABLE supermarket_clean
ALTER COLUMN order_date TYPE DATE
USING CASE
    WHEN order_date ~ '^\d{4}-\d{2}-\d{2}$'      THEN TO_DATE(order_date, 'YYYY-MM-DD')
    WHEN order_date ~ '^\d{2}/\d{2}/\d{4}$'      THEN TO_DATE(order_date, 'MM/DD/YYYY')
    WHEN order_date ~ '^\d{2}-\d{2}-\d{4}$'      THEN TO_DATE(order_date, 'DD-MM-YYYY')
    WHEN order_date ~ '^\d{2}\.\d{2}\.\d{2}$'    THEN TO_DATE(order_date, 'MM.DD.YY')
    WHEN order_date ~ '^[A-Za-z]+ \d{2}, \d{4}$' THEN TO_DATE(order_date, 'Month DD, YYYY')
    ELSE NULL
END;

-- Task 9: The question: replace N/A and blank/space-only text with a proper NULL, so the column only holds real notes or true empty values, nothing fake pretending to be a note.

UPDATE supermarket_clean
SET notes = NULL
WHERE notes = 'N/A' OR TRIM (notes)='';

SELECT  notes FROM supermarket_clean;

--Task 10: Some rows have no channel value at all (it's NULL). Since a missing channel could just mean "we don't know," rather than leaving it blank, replace those with the text 'Unknown' so it's clear and reportable, instead of silently disappearing from any grouping or chart.

SELECT channel , COUNT(*) FROM supermarket_clean GROUP BY channel;
UPDATE supermarket_clean 
SET  channel = 'unknown'
WHERE channel IS NULL;

--Task 11: Add the bonus revenue column
ALTER TABLE supermarket_clean 
 ADD COLUMN revenue NUMERIC(10,2);

UPDATE supermarket_clean
SET revenue = quantity * unit_price;

SELECT  revenue FROM supermarket_clean;

 

 