SELECT *
FROM doda_data_job_list;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Delete 'NEW' at the end of company_name

SELECT company_name, REPLACE(company_name,'NEW','')
FROM doda_data_job_list
WHERE RIGHT(company_name,3) = 'NEW';

ALTER TABLE doda_data_job_list
ADD company_name_delete_new VARCHAR(255);

UPDATE doda_data_job_list
SET company_name_delete_new = company_name;

UPDATE doda_data_job_list
SET company_name_delete_new = REPLACE(company_name,'NEW','')
WHERE RIGHT(company_name_delete_new, 3) = 'NEW';

SELECT company_name, company_name_delete_new
FROM doda_data_job_list;

SELECT company_name, company_name_delete_new
FROM doda_data_job_list
WHERE company_name <> company_name_delete_new;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Picking up only prefecture and cities
-- I should have start filtering using 東京都 not %都%. This is the part that can be improved later.

SELECT location
FROM doda_data_job_list
WHERE location LIKE '%：%';

-- A. 67 items -> make 2 items maually and make 64 items as only '東京都' and keep 1 item as Null
SELECT location, location_new
FROM doda_data_job_list
WHERE location LIKE '%：%'
	AND	location LIKE '%都%'
	AND location NOT LIKE '%区%'
	AND location NOT LIKE '%市%';

-- B. 1777 items -> make 4 items manually and make lest of them as either '東京都○○区' or '東京都○○市' and make 2 items as Null
SELECT location, location_new
FROM doda_data_job_list
WHERE location LIKE '%：%'
	AND	location LIKE '%都%'
	AND (location LIKE '%区%' OR location LIKE '%市%');

-- C. 9 items -> make 3 items maually and keep 6 items as Null
SELECT location, location_new
FROM doda_data_job_list
WHERE location LIKE '%：%'
	AND	location NOT LIKE '%都%'
	AND location NOT LIKE '%区%'
	AND location NOT LIKE '%市%';

-- D. 46 items -> make 4 items manually as either '東京都○○区' or '東京都○○市' and keep 42 items as NULL
SELECT location, location_new
FROM doda_data_job_list
WHERE location LIKE '%：%'
	AND	location NOT LIKE '%都%'
	AND (location LIKE '%区%' OR location LIKE '%市%');
	
SELECT location
FROM doda_data_job_list
WHERE location NOT LIKE '%：%';

-- E. 4 items -> make 1 items maually and keep 3 items as Null
SELECT location, location_new
FROM doda_data_job_list
WHERE location NOT LIKE '%：%'
	AND (
		location NOT LIKE '%都%'
		OR location NOT LIKE '%区%'
	);

-- F. 7 items -> make 2 items manually and make 5 items manually as either '東京都○○区' or '東京都○○市'
SELECT location, location_new
FROM doda_data_job_list
WHERE location NOT LIKE '%：%'
	AND location LIKE '%都%'
	AND location LIKE '%区%';
----------------------------------------------------------
ALTER TABLE doda_data_job_list
ADD location_new VARCHAR(255);

-- A_64 items
UPDATE doda_data_job_list
SET location_new = '東京都'
WHERE location LIKE '%：%'
	AND	location LIKE '%都%'
	AND location NOT LIKE '%区%'
	AND location NOT LIKE '%市%';

-- A_1 items
SELECT location, location_new
FROM doda_data_job_list
WHERE location LIKE '%全国住所：都道府県から%';

-- A_1 items
UPDATE doda_data_job_list
SET location_new = Null
WHERE location LIKE '%全国住所：都道府県から%';

-- A_2 items
SELECT location, location_new
FROM doda_data_job_list
WHERE location LIKE '%東京都千代田丸の内1-1-3%';

-- A_2 items
UPDATE doda_data_job_list
SET location_new = '東京都千代田区'
WHERE location LIKE '%東京都千代田丸の内1-1-3%';
-- A finished

-- C_3 items
SELECT location, location_new
FROM doda_data_job_list
WHERE location LIKE '%品川住所%';

-- C_3 items
UPDATE doda_data_job_list
SET location_new = '品川区'
WHERE location LIKE '%品川住所%';

-- C_3 items
SELECT location, location_new
FROM doda_data_job_list
WHERE location LIKE '%自宅/フルリモート%';

-- C_3 items
UPDATE doda_data_job_list
SET location_new = '自宅'
WHERE location LIKE '%自宅/フルリモート%';
-- C finished

-- D_4 items
SELECT location, location_new
FROM doda_data_job_list
WHERE location LIKE '%本社住所：渋谷区道玄坂1-16-3%';

-- D_4 items
UPDATE doda_data_job_list
SET location_new = '東京都渋谷区'
WHERE location LIKE '%本社住所：渋谷区道玄坂1-16-3%';

-- D_4 items
SELECT location, location_new
FROM doda_data_job_list
WHERE location LIKE '%お客様先常駐住所：港区%'

-- D_4 items
UPDATE doda_data_job_list
SET location_new = '東京都港区'
WHERE location LIKE '%お客様先常駐住所：港区%';

-- D_4 items
SELECT location, location_new
FROM doda_data_job_list
WHERE location LIKE '%本社住所：品川区東品川四丁目12番2号品%'

-- D_4 items
UPDATE doda_data_job_list
SET location_new = '東京都品川区'
WHERE location LIKE '%本社住所：品川区東品川四丁目12番2号品%';
-- D finished

-- E_1 items
SELECT location, location_new
FROM doda_data_job_list
WHERE location LIKE '%東京本社（港区）%';

-- E_1 items
UPDATE doda_data_job_list
SET location_new = '東京都港区'
WHERE location LIKE '%東京本社（港区）%';
-- E finished

-- F_5 items
SELECT location, SUBSTRING(location, POSITION('都' IN location)-2, ABS((POSITION('区' IN location) + 1) - (POSITION('都' IN LOCATION) - 2)))
FROM doda_data_job_list
WHERE location NOT LIKE '%：%'
	AND	location LIKE '%都%'
	AND location LIKE '%区%';

-- F_5 items
UPDATE doda_data_job_list
SET location_new = SUBSTRING(location, POSITION('都' IN location)-2, ABS((POSITION('区' IN location) + 1) - (POSITION('都' IN LOCATION) - 2)))
WHERE location NOT LIKE '%：%'
	AND	location LIKE '%都%'
	AND location LIKE '%区%';

-- F_2 items
SELECT location, location_new
FROM doda_data_job_list
WHERE location LIKE '%本社（秋葉原駅徒歩1分）%';

-- F_2 items
UPDATE doda_data_job_list
SET location_new = '東京都千代田区'
WHERE location LIKE '%本社（秋葉原駅徒歩1分）%';

-- F_2 items
SELECT location, location_new
FROM doda_data_job_list
WHERE location LIKE '%【本社】東京都中央区…'

-- F_2 items
UPDATE doda_data_job_list
SET location_new = '東京都中央区'
WHERE location LIKE '%%【本社】東京都中央区…';
-- F finished

-- B
WITH cte AS (
	SELECT company_name, role_summary, role, location, SUBSTRING(location, POSITION('：' IN location) + 1, LENGTH(location)) AS cte_location 
	FROM doda_data_job_list
	WHERE location LIKE '%：%'
		AND	location LIKE '%都%'
		AND (location LIKE '%区%' OR location LIKE '%市%')
)

UPDATE doda_data_job_list
SET location_new = CASE WHEN SUBSTRING(cte_location, 1, 10) LIKE '%区%' OR SUBSTRING(cte_location, 1, 10) NOT LIKE '%市%'
							THEN SUBSTRING(cte_location, POSITION('都' IN cte_location)-2, ABS((POSITION('区' IN cte_location) + 1) - (POSITION('都' IN cte_location) - 2)))
						WHEN SUBSTRING(cte_location, 1, 10) NOT LIKE '%区%' AND SUBSTRING(cte_location, 1, 10) LIKE '%市%'
							THEN SUBSTRING(cte_location, POSITION('都' IN cte_location)-2, ABS((POSITION('市' IN cte_location) + 1) - (POSITION('都' IN cte_location) - 2)))
						END
FROM cte
WHERE doda_data_job_list.company_name = cte.company_name
	AND doda_data_job_list.role_summary = cte.role_summary
	AND doda_data_job_list.role = cte.role
	AND doda_data_job_list.location = cte.location;

-- B_4 items
SELECT location, location_new
FROM doda_data_job_list
WHERE location LIKE '%東京都受動喫煙対策：敷地内全面禁煙%';

-- B_4 items
UPDATE doda_data_job_list
SET location_new = '東京都千代田区'
WHERE location LIKE '%東京都受動喫煙対策：敷地内全面禁煙%';

-- B_4 items
SELECT location, location_new
FROM doda_data_job_list
WHERE location LIKE '%東京都東京都渋谷区%';

-- B_4 items
UPDATE doda_data_job_list
SET location_new = '東京都渋谷区'
WHERE location LIKE '%東京都東京都渋谷区%';

-- B_4 items
SELECT location, location_new
FROM doda_data_job_list
WHERE location LIKE '%東京都東京都新宿区%';

-- B_4 items
UPDATE doda_data_job_list
SET location_new = '東京都新宿区'
WHERE location LIKE '%東京都東京都新宿区%';

UPDATE doda_data_job_list
SET location_new = Null
WHERE location LIKE '%：%'
	AND	location LIKE '%都%'
	AND (location LIKE '%区%' OR location LIKE '%市%')
	AND LEFT(location_new, 3) != '東京都';
-- B finished

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Devide location_new into prefecture and city

SELECT location_new
FROM doda_data_job_list
WHERE location_new NOT LIKE '%東京都%';

UPDATE doda_data_job_list
SET location_new = '東京都品川区'
WHERE location_new = '品川区';

ALTER TABLE doda_data_job_list
ADD prefecture VARCHAR(255),
ADD city VARCHAR(255)

SELECT location_new, SUBSTRING(location_new, 1, POSITION('都' IN location_new)), 
	SUBSTRING(location_new, POSITION('都' IN location_new) + 1, LENGTH(location_new))
FROM doda_data_job_list
WHERE location_new LIKE '%区%'
	OR location_new LIKE '%市%';

UPDATE doda_data_job_list
SET prefecture = SUBSTRING(location_new, 1, POSITION('都' IN location_new)), 
	city = SUBSTRING(location_new, POSITION('都' IN location_new) + 1, LENGTH(location_new))
WHERE location_new LIKE '%区%'
	OR location_new LIKE '%市%';

SELECT location_new
FROM doda_data_job_list
WHERE location_new NOT LIKE '%区%'
	AND location_new NOT LIKE '%市%';

UPDATE doda_data_job_list
SET prefecture = location_new 
WHERE location_new NOT LIKE '%区%'
	AND location_new NOT LIKE '%市%';

SELECT location_new
FROM doda_data_job_list
WHERE city IS NOT NULL;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Split close_subway_station

SELECT close_subway_station
FROM doda_data_job_list
WHERE close_subway_station IS NOT NULL;

SELECT close_subway_station, closest_station, second_closest_station, third_closest_station
FROM doda_data_job_list
WHERE close_subway_station NOT LIKE '%、%';

SELECT close_subway_station, closest_station, second_closest_station, third_closest_station
FROM doda_data_job_list
WHERE close_subway_station LIKE '%、%';

ALTER TABLE doda_data_job_list
ADD closest_station VARCHAR(255),
ADD second_closest_station VARCHAR(255),
ADD third_closest_station VARCHAR(255)

UPDATE doda_data_job_list
SET closest_station = close_subway_station
WHERE close_subway_station NOT LIKE '%、%';

UPDATE doda_data_job_list
SET closest_station = SPLIT_PART(close_subway_station, '、', 1),
	second_closest_station = SPLIT_PART(close_subway_station, '、', 2),
	third_closest_station = SPLIT_PART(close_subway_station, '、', 3)
WHERE close_subway_station LIKE '%、%';
	
SELECT close_subway_station, closest_station, second_closest_station, third_closest_station
FROM doda_data_job_list
WHERE third_closest_station='';

UPDATE doda_data_job_list
SET third_closest_station = Null
WHERE third_closest_station='';

SELECT close_subway_station, closest_station, second_closest_station, third_closest_station
FROM doda_data_job_list
WHERE third_closest_station IS Null;

-- Delete（）in station name

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Clean target_candidate

SELECT target_candidate, COUNT(*)
FROM doda_data_job_list
GROUP BY target_candidate
ORDER BY COUNT(*) DESC;

SELECT target_candidate
FROM doda_data_job_list
WHERE target_candidate LIKE '%学歴不問%';

UPDATE doda_data_job_list
SET target_candidate = '学歴不問'
WHERE target_candidate LIKE '%学歴不問%';

SELECT target_candidate
FROM doda_data_job_list
WHERE target_candidate LIKE '%学歴・経歴不問%';

UPDATE doda_data_job_list
SET target_candidate = '学歴不問'
WHERE target_candidate LIKE '%学歴・経歴不問%';

SELECT target_candidate
FROM doda_data_job_list
WHERE target_candidate LIKE '%経験%';

UPDATE doda_data_job_list
SET target_candidate = Null
WHERE target_candidate LIKE '%経験%';

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Clean salary

SELECT salary
FROM doda_data_job_list
ORDER BY salary DESC;

ALTER TABLE doda_data_job_list
ADD min_salary NUMERIC(20,0),
ADD max_salary NUMERIC(20,0),
ADD avg_salary NUMERIC(20,0)

-- Make them as Null, because their condition is ambigous. only monthly salary, different salary for different position
-- 12 items
SELECT salary
FROM doda_data_job_list
WHERE LEFT(salary, 1) <> '＜';

SELECT salary, avg_salary
FROM doda_data_job_list
WHERE salary LIKE '%想定年収350万円%';

UPDATE doda_data_job_list
SET avg_salary = 350
WHERE salary LIKE '%想定年収350万円%';
---------------------------------------------------------
WITH cte AS (
	SELECT salary, SUBSTRING(salary, POSITION('＞' IN salary) + 1, POSITION('＜賃' IN salary) - POSITION('＞' IN salary) - 1) AS salary_cleaned_cte
	FROM doda_data_job_list
	WHERE LEFT(salary, 1) = '＜'
)

SELECT salary_cleaned_cte, COUNT(*)
FROM cte
GROUP BY salary_cleaned_cte
ORDER BY COUNT(*) DESC;
-- Still too many category, so I decided to use average vale of each range
-- 1892 items
WITH cte AS (
	SELECT salary, SUBSTRING(salary, POSITION('＞' IN salary) + 1, POSITION('＜賃' IN salary) - POSITION('＞' IN salary) - 1) AS salary_cleaned_cte
	FROM doda_data_job_list
	WHERE LEFT(salary, 1) = '＜'
)

SELECT salary_cleaned_cte, SPLIT_PART(salary_cleaned_cte, '～', 1), SPLIT_PART(salary_cleaned_cte, '～', 2)
	, SUBSTRING(SPLIT_PART(salary_cleaned_cte, '～', 1), 1, POSITION('万' IN SPLIT_PART(salary_cleaned_cte, '～', 1)) - 1)
	, SUBSTRING(SPLIT_PART(salary_cleaned_cte, '～', 2), 1, POSITION('万' IN SPLIT_PART(salary_cleaned_cte, '～', 2)) - 1)
	, CAST(REPLACE(SUBSTRING(SPLIT_PART(salary_cleaned_cte, '～', 1), 1, POSITION('万' IN SPLIT_PART(salary_cleaned_cte, '～', 1)) - 1), ',', '') AS DECIMAL) AS min_salary
	, CAST(REPLACE(SUBSTRING(SPLIT_PART(salary_cleaned_cte, '～', 2), 1, POSITION('万' IN SPLIT_PART(salary_cleaned_cte, '～', 2)) - 1), ',', '') AS DECIMAL) AS max_salary
	, (CAST(REPLACE(SUBSTRING(SPLIT_PART(salary_cleaned_cte, '～', 1), 1, POSITION('万' IN SPLIT_PART(salary_cleaned_cte, '～', 1)) - 1), ',', '') AS DECIMAL) 
	+ CAST(REPLACE(SUBSTRING(SPLIT_PART(salary_cleaned_cte, '～', 2), 1, POSITION('万' IN SPLIT_PART(salary_cleaned_cte, '～', 2)) - 1), ',', '') AS DECIMAL)) / 2 AS avg_salary
FROM cte
WHERE SPLIT_PART(salary_cleaned_cte, '～', 2) <> '';

WITH cte AS (
	SELECT company_name, role_summary, role, location, 
		salary, SUBSTRING(salary, POSITION('＞' IN salary) + 1, POSITION('＜賃' IN salary) - POSITION('＞' IN salary) - 1) AS salary_cleaned_cte
	FROM doda_data_job_list
	WHERE LEFT(salary, 1) = '＜'
)

UPDATE doda_data_job_list
SET min_salary = CAST(REPLACE(SUBSTRING(SPLIT_PART(salary_cleaned_cte, '～', 1), 1, POSITION('万' IN SPLIT_PART(salary_cleaned_cte, '～', 1)) - 1), ',', '') AS DECIMAL),
	max_salary = CAST(REPLACE(SUBSTRING(SPLIT_PART(salary_cleaned_cte, '～', 2), 1, POSITION('万' IN SPLIT_PART(salary_cleaned_cte, '～', 2)) - 1), ',', '') AS DECIMAL),
	avg_salary = (CAST(REPLACE(SUBSTRING(SPLIT_PART(salary_cleaned_cte, '～', 1), 1, POSITION('万' IN SPLIT_PART(salary_cleaned_cte, '～', 1)) - 1), ',', '') AS DECIMAL) 
				+ CAST(REPLACE(SUBSTRING(SPLIT_PART(salary_cleaned_cte, '～', 2), 1, POSITION('万' IN SPLIT_PART(salary_cleaned_cte, '～', 2)) - 1), ',', '') AS DECIMAL)) / 2
FROM cte
WHERE SPLIT_PART(salary_cleaned_cte, '～', 2) <> ''
	AND doda_data_job_list.company_name = cte.company_name
	AND doda_data_job_list.role_summary = cte.role_summary
	AND doda_data_job_list.role = cte.role
	AND doda_data_job_list.location = cte.location;
---------------------------------------------------------
-- 6 items
WITH cte AS (
	SELECT salary, SUBSTRING(salary, POSITION('＞' IN salary) + 1, POSITION('＜賃' IN salary) - POSITION('＞' IN salary) - 1) AS salary_cleaned_cte
	FROM doda_data_job_list
	WHERE LEFT(salary, 1) = '＜'
)

SELECT salary, salary_cleaned_cte, SUBSTRING(salary_cleaned_cte, 1, POSITION('万' IN salary_cleaned_cte) - 1),
	CAST(REPLACE(SUBSTRING(salary_cleaned_cte, 1, POSITION('万' IN salary_cleaned_cte) - 1), ',', '') AS DECIMAL) AS avg_salary
FROM cte
WHERE SPLIT_PART(salary_cleaned_cte, '～', 2) = '';

WITH cte AS (
	SELECT company_name, role_summary, role, location, 
		salary, SUBSTRING(salary, POSITION('＞' IN salary) + 1, POSITION('＜賃' IN salary) - POSITION('＞' IN salary) - 1) AS salary_cleaned_cte
	FROM doda_data_job_list
	WHERE LEFT(salary, 1) = '＜'
)

UPDATE doda_data_job_list
SET avg_salary = CAST(REPLACE(SUBSTRING(salary_cleaned_cte, 1, POSITION('万' IN salary_cleaned_cte) - 1), ',', '') AS DECIMAL)
FROM cte
WHERE SPLIT_PART(salary_cleaned_cte, '～', 2) = ''
	AND doda_data_job_list.company_name = cte.company_name
	AND doda_data_job_list.role_summary = cte.role_summary
	AND doda_data_job_list.role = cte.role
	AND doda_data_job_list.location = cte.location;

SELECT salary, min_salary, max_salary, avg_salary
FROM doda_data_job_list
ORDER BY salary DESC;

SELECT avg_salary, COUNT(*)
FROM doda_data_job_list
GROUP BY avg_salary
ORDER BY COUNT(*) DESC;

SELECT *
FROM doda_data_job_list;

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 
SELECT closest_station, COUNT(*)
FROM doda_data_job_list
GROUP BY closest_station
ORDER BY closest_station;

SELECT second_closest_station, COUNT(*)
FROM doda_data_job_list
GROUP BY second_closest_station
ORDER BY second_closest_station;

SELECT third_closest_station, COUNT(*)
FROM doda_data_job_list
GROUP BY third_closest_station
ORDER BY third_closest_station;

SELECT *
FROM doda_data_job_list
WHERE closest_station = '京都河原町駅'

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Fixing wrong value that I found out doing Tableau
SELECT city, COUNT(*)
FROM doda_data_job_list
GROUP BY city
ORDER BY COUNT(*) DESC;

SELECT *
FROM doda_data_job_list
WHERE city = '都千代田区';

UPDATE doda_data_job_list
SET city = '千代田区' -- There was a typo in original post. "東京都都千代田区"
WHERE city = '都千代田区';

SELECT *
FROM doda_data_job_list
WHERE city = '東京都品川区';

UPDATE doda_data_job_list
SET city = '品川区' -- There was a typo in original post. "東京都東京都品川区"
WHERE city = '東京都品川区';

SELECT *
FROM doda_data_job_list
WHERE city LIKE '%港区港南%';

UPDATE doda_data_job_list
SET city = '港区'
WHERE city LIKE '%港区港南%';