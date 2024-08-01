SELECT *
FROM nashvillehousing2
ORDER BY uniqueid;

-- 콜러레스 : 합치다
SELECT a.parcelid, a.propertyaddress, b.parcelid, b.propertyaddress, COALESCE(a.propertyaddress, b.propertyaddress) -- return first NOT NULL value
FROM nashvillehousing2 AS a
INNER JOIN nashvillehousing2 AS b
ON a.parcelid = b.parcelid AND a.uniqueid <> b.uniqueid
WHERE a.propertyaddress IS NULL;

-- to update a table with data from another table in PostgreSQL, use the  UPDATE  statement with a  FROM  clause for the join operation
UPDATE nashvillehousing2
SET propertyaddress = COALESCE(nashvillehousing2.propertyaddress, nashvillehousing_sub.propertyaddress)
FROM nashvillehousing2 AS nashvillehousing_sub
WHERE nashvillehousing2.parcelid = nashvillehousing_sub.parcelid 
	AND nashvillehousing2.uniqueid <> nashvillehousing_sub.uniqueid
	AND nashvillehousing2.propertyaddress IS NULL;

--------------------------------------------------------------------------------------------------------------------------------------------------

-- <Breaking out Address into Individual Columns (Address, City, State)>
SELECT SUBSTRING(propertyaddress, 1, POSITION(',' IN propertyaddress)-1) AS address -- starting at the first value and then goes until the comma
	, SUBSTRING(propertyaddress, POSITION(',' IN propertyaddress)+1, LENGTH(propertyaddress))
-- POSITION(=CHARINDEX) : index number of specific value
FROM nashvillehousing2;

ALTER TABLE nashvillehousing2
ADD COLUMN propertysplitaddress VARCHAR(255);

UPDATE nashvillehousing2
SET propertysplitaddress = SUBSTRING(propertyaddress, 1, POSITION(',' IN propertyaddress)-1);

ALTER TABLE nashvillehousing2
ADD COLUMN propertysplitcity VARCHAR(255);

UPDATE nashvillehousing2
SET propertysplitcity = SUBSTRING(propertyaddress, POSITION(',' IN propertyaddress)+1, LENGTH(propertyaddress));

SELECT owneraddress, 
	SPLIT_PART(owneraddress, ',', 1), -- unlike PARSENAME() which can only devide with dot(.), SPLIT_PART can devide with comma
	SPLIT_PART(owneraddress, ',', 2),
	SPLIT_PART(owneraddress, ',', 3)
FROM nashvillehousing2;

ALTER TABLE nashvillehousing2
ADD COLUMN ownersplitaddress VARCHAR(255);

UPDATE nashvillehousing2
SET ownersplitaddress = SPLIT_PART(owneraddress, ',', 1);

ALTER TABLE nashvillehousing2
ADD COLUMN ownersplitcity VARCHAR(255);

UPDATE nashvillehousing2
SET ownersplitcity = SPLIT_PART(owneraddress, ',', 2);

ALTER TABLE nashvillehousing2
ADD COLUMN ownersplitstate VARCHAR(255);

UPDATE nashvillehousing2
SET ownersplitstate = SPLIT_PART(owneraddress, ',', 3);

--------------------------------------------------------------------------------------------------------------------------------------------------

-- <Change Y and N to Yes and No in 'Sold as Vacant' field>
SELECT soldasvacant, COUNT(soldasvacant)
FROM nashvillehousing2
GROUP BY soldasvacant
ORDER BY 2;

SELECT soldasvacant,
	CASE WHEN soldasvacant = 'Y' THEN 'Yes'
		 WHEN soldasvacant = 'N' THEN 'No'
		 ELSE soldasvacant
		 END
FROM nashvillehousing2;

UPDATE nashvillehousing2
SET soldasvacant = 
	CASE WHEN soldasvacant = 'Y' THEN 'Yes'
		 WHEN soldasvacant = 'N' THEN 'No'
		 ELSE soldasvacant
		 END;

--------------------------------------------------------------------------------------------------------------------------------------------------

-- <Remove Duplicates>
-- create temp table and put removed duplicates there is standard practice

WITH RowNumberCTE AS (
	SELECT *, ROW_NUMBER () OVER(PARTITION BY parcelid, propertyaddress, saledate, saleprice, legalreference ORDER BY uniqueid) AS rownumber
	FROM nashvillehousing2
)

-- the row number for each partition starts with one and increments by one
-- 다른 partition이기에 row number가 다시 1부터 시작한다
/*
SELECT *
FROM RowNumberCTE
WHERE rownumber > 1;
*/
	
DELETE
FROM nashvillehousing2 -- PostgreSQL does not allow direct deletion from a CTE
WHERE uniqueid IN (    -- We can use ctid instead. ctid is a special column in PostgreSQL that uniquely identifies a row within its table
	SELECT uniqueid
	FROM RowNumberCTE
	WHERE rownumber > 1
);

--------------------------------------------------------------------------------------------------------------------------------------------------

-- <Delete Unused Columns>
-- This is normally done in Views. Deleting row data is not practice
SELECT *
FROM nashvillehousing2;

ALTER TABLE nashvillehousing2
DROP COLUMN owneraddress,
DROP COLUMN taxdistrict,
DROP COLUMN propertyaddress,
DROP COLUMN saledate;