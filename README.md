The Nashville Housing data was recently analyzed using a set of SQL functions. The goal of the analysis was to clean and transform the data into a more meaningful format for future analysis. The functions used in the process are described below.

Step 1: Change Date Format from datetime to date
The first step involved changing the date format from DATETIME to DATE. This was done by adding a new column called "SaleDateConverted" in the NashvilleHousing table. The "SaleDateConverted" column was then updated with the converted date using the CONVERT function. Finally, the original "SaleDate" column was dropped.

Step 2: Populate Property Address
In this step, the analyst checked for NULL values in the "PropertyAddress" column. The data was then checked for any duplicates by joining the table with itself and comparing the values of the "ParcelID" and "PropertyAddress" columns. The missing "PropertyAddress" values were then updated using the ISNULL function.

Step 3: Breaking out Address into Individual Columns (Address, City, State)
The "PropertyAddress" column was then split into two separate columns, "PropertySplitAddress" and "PropertySplitCity". This was done using the SUBSTRING function. Similarly, the "OwnerAddress" column was split into three separate columns, "OwnerSplitAddress", "OwnerSplitCity", and "OwnerSplitState" using the PARSENAME function.

Step 4: Change the cell containing 'Y' and 'N' to 'Yes' or 'No'
The "SoldAsVacant" column contained values of 'Y' and 'N'. The analyst used a SELECT statement to count the number of occurrences of each value. The "SoldAsVacant" values were then updated using a CASE statement to change the values to 'Yes' or 'No'.

Step 5: Remove duplicates
Finally, duplicates were removed from the data using a Common Table Expression (CTE) and the ROW_NUMBER function. The duplicates were identified based on the values in the "ParcelID", "PropertyAddress", "SalePrice", "SaleDateConverted", and "LegalReference" columns. The duplicates were then deleted using a DELETE statement.
