SELECT *
FROM amazon

--lets check for duplicates
SELECT 
    product_id,
    COUNT(*) AS duplicate_count
FROM 
    amazon
GROUP BY 
    product_id
HAVING 
    COUNT(*) > 1;
    

--Found some duplicacy
--Removing all Duplicates
DELETE FROM 
    amazon
WHERE 
    product_id IN (
        SELECT 
            product_id
        FROM 
            amazon
        GROUP BY 
            product_id
        HAVING 
            COUNT(*) > 1
    )
AND 
    ROWID NOT IN (
        SELECT 
            MIN(ROWID)
        FROM 
            amazon
        GROUP BY 
            product_id
        HAVING 
            COUNT(*) > 1
    );

-- Update actual_price column to remove "₹" symbol
UPDATE amazon SET actual_price = REPLACE(actual_price, '₹', '');

-- Update discount_percentage column to remove "%" symbol
UPDATE amazon SET discount_percentage = REPLACE(discount_percentage, '%', '');

-- Update discounted_price column to remove "%" symbol
UPDATE amazon SET discounted_price = REPLACE(discounted_price, '₹', '');



-- SEE RATINGS WITH HIGHEST COUNT
SELECT 
      rating,
      COUNT(*) AS countratings
FROM amazon
GROUP BY
     rating
ORDER BY 
     countratings DESC --JUST NOTICED THERE IS A "|" PROBABBLY MISTAKEN AS 1
     
-- CHANGE THE "|" TO 4(FOUND IOUT IN AMAZON WEB THE PRODUCT HAS A RATING OF 4 )
UPDATE 
    amazon
SET 
    rating = '4'
WHERE 
    rating LIKE '%|%';


--Which product categories are the most popular (based on sales or reviews)?
SELECT 
    category,
    COUNT(*) AS total_products,
    SUM(rating_count) AS total_reviews
FROM 
    amazon
GROUP BY 
    category
ORDER BY 
    total_products DESC, total_reviews DESC;
    
--username with higest reviews
SELECT 
    user_name,
    COUNT(*) AS review_count
FROM 
    amazon
GROUP BY 
    user_name
ORDER BY 
    review_count DESC
LIMIT 5;


--Categories with Higest rationg count 
SELECT 
    category,
    SUM(rating_count) AS total_rating_count
FROM 
    amazon
GROUP BY 
    category
ORDER BY 
    total_rating_count DESC
LIMIT 10;

--add another column for rating the rating column with words
ALTER TABLE amazon
ADD COLUMN Rating_Category VARCHAR(20);


--update the rating column with our defined values
UPDATE amazon
SET Rating_Category = 
    CASE
        WHEN rating < 2.0 THEN 'Poor'
        WHEN rating < 3.0 THEN 'Below Average'
        WHEN rating <= 3.9 THEN 'Average'
        WHEN rating >= 4.0 THEN 'Good'
        WHEN rating >= 4 THEN 'Good'
        WHEN rating = 5.0 THEN 'Excellent'
        ELSE 'Unknown' -- You may want to handle other cases if any
    END;
    
-- Lets view the rating columns
SELECT
  category, rating, Rating_Category
FROM
    amazon
    
--Rating_Categories with Higest rating count 
SELECT 
    Rating_Category,
    COUNT(Rating_Category) AS total_rating_category_count
FROM 
    amazon
GROUP BY 
    Rating_Category
ORDER BY 
    total_rating_category_count DESC
LIMIT 10;



