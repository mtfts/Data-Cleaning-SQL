

USE Portfolio_Cleaning;


SELECT *
FROM NashvilleHousing;


--------------------------------------------------------------------------------------------------------------

-- Change Date Format from datetime to just date

ALTER TABLE NashvilleHousing
ADD SaleDateConverted DATE;

UPDATE NashvilleHousing
SET SaleDateConverted =  CONVERT(DATE,SaleDate)

ALTER TABLE NashvilleHousing
DROP COLUMN SaleDate;


--------------------------------------------------------------------------------------------------------------

-- Populate Property Address

SELECT *
FROM NashvilleHousing
WHERE PropertyAddress IS NULL

SELECT *
FROM NashvilleHousing
WHERE ParcelID = '114 15 0A 030.00'

SELECT pop.ParcelID, pop.PropertyAddress, notp.ParcelID, notp.PropertyAddress, ISNULL(notp.PropertyAddress, pop.PropertyAddress)
FROM NashvilleHousing  pop
JOIN NashvilleHousing notp
	ON pop.ParcelID = notp.ParcelID
	AND pop.[UniqueID ] <> notp.[UniqueID ]
WHERE notp.PropertyAddress IS NULL

UPDATE notp
SET PropertyAddress = ISNULL(notp.PropertyAddress, pop.PropertyAddress)
FROM NashvilleHousing  pop
JOIN NashvilleHousing notp
	ON pop.ParcelID = notp.ParcelID
	AND pop.[UniqueID ] <> notp.[UniqueID ]
WHERE notp.PropertyAddress IS NULL



--------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

SELECT PropertyAddress
FROM NashvilleHousing;

SELECT 
SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) AS Address,
SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) AS City
FROM NashvilleHousing;


ALTER TABLE NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 );

ALTER TABLE NashvilleHousing
ADD PropertySplitCity NVARCHAR(255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING (PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress));


SELECT OwnerAddress
FROM NashvilleHousing;

SELECT 
PARSENAME(REPLACE(OwnerAddress,',','.'), 3) AS Address,
PARSENAME(REPLACE(OwnerAddress,',','.'), 2)AS City,
PARSENAME(REPLACE(OwnerAddress,',','.'), 1) AS State
FROM NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'), 3);

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'), 2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'), 1)


--------------------------------------------------------------------------------------------------------------

-- Change the cell containing 'Y' and 'N' to 'Yes' or 'No'

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2 DESC

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
FROM NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
						WHEN SoldAsVacant = 'N' THEN 'No'
						ELSE SoldAsVacant
						END


--------------------------------------------------------------------------------------------------------------

-- Remove duplicates

WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDateConverted,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

FROM NashvilleHousing
)
DELETE
FROM RowNumCTE
WHERE row_num > 1

