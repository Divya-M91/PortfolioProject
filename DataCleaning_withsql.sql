SELECT TOP (1000) [UniqueID ]
      ,[ParcelID]
      ,[LandUse]
      ,[PropertyAddress]
      ,[SaleDate]
      ,[SalePrice]
      ,[LegalReference]
      ,[SoldAsVacant]
      ,[OwnerName]
      ,[OwnerAddress]
      ,[Acreage]
      ,[TaxDistrict]
      ,[LandValue]
      ,[BuildingValue]
      ,[TotalValue]
      ,[YearBuilt]
      ,[Bedrooms]
      ,[FullBath]
      ,[HalfBath]
  FROM [project1].[dbo].[NashvilleHousing]

  --Cleaning data in sql queries
  select * 
  from [project1].[dbo].[NashvilleHousing]

  --Standardise date format
  select SaleDate, CONVERT(date, SaleDate)
  from [project1].[dbo].[NashvilleHousing]
  update [project1].[dbo].[NashvilleHousing]
  set SaleDate=CONVERT(date, SaleDate)

  alter table [project1].[dbo].[NashvilleHousing] add saledateconverted date;
  update [project1].[dbo].[NashvilleHousing]
  set saledateconverted=CONVERT(date, SaleDate)
  select saledateconverted, CONVERT(date, SaleDate)
  from [project1].[dbo].[NashvilleHousing]

  --populate property address data
  select *
  from [project1].[dbo].[NashvilleHousing]
  order by parcelid

  select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
  from [project1].[dbo].[NashvilleHousing] a
  join [project1].[dbo].[NashvilleHousing] b
  on a.ParcelID = b.ParcelID
  and a.UniqueID <> b.UniqueID
  where a.PropertyAddress is null

  update a
  set a.PropertyAddress=ISNULL(a.PropertyAddress, b.PropertyAddress)
  from [project1].[dbo].[NashvilleHousing] a
  join [project1].[dbo].[NashvilleHousing] b
  on a.ParcelID = b.ParcelID
  and a.UniqueID <> b.UniqueID
  where a.PropertyAddress is null

  --breaking address into address, city, state
  select PropertyAddress
  from [project1].[dbo].[NashvilleHousing]

  select substring(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as address,
substring(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as city
  from [project1].[dbo].[NashvilleHousing]

  alter table [project1].[dbo].[NashvilleHousing] add PropertysplitAddress nvarchar(255);
   alter table [project1].[dbo].[NashvilleHousing] add Propertysplitcity nvarchar(255);

 update [project1].[dbo].[NashvilleHousing]
  set PropertysplitAddress=substring(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1),
  Propertysplitcity=substring(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) 

   select * 
  from [project1].[dbo].[NashvilleHousing]

   select OwnerAddress, 
   parsename(replace(OwnerAddress, ',', '.'), 3),
   parsename(replace(OwnerAddress, ',', '.'), 2),
   parsename(replace(OwnerAddress, ',', '.'), 1)
   from [project1].[dbo].[NashvilleHousing]

   alter table [project1].[dbo].[NashvilleHousing] add ownersplitAddress nvarchar(255);
   alter table [project1].[dbo].[NashvilleHousing] add ownersplitcity nvarchar(255);
   alter table [project1].[dbo].[NashvilleHousing] add ownersplitstate nvarchar(255);

  update [project1].[dbo].[NashvilleHousing]
  set ownersplitAddress= parsename(replace(OwnerAddress, ',', '.'), 3),
  ownersplitcity=parsename(replace(OwnerAddress, ',', '.'), 2),
  ownersplitstate=parsename(replace(OwnerAddress, ',', '.'), 1)
   from [project1].[dbo].[NashvilleHousing]

   select * 
  from [project1].[dbo].[NashvilleHousing]

  --change y and n to yes/no in SoldAsVacant field
  select distinct(SoldAsVacant) 
  from [project1].[dbo].[NashvilleHousing]

   select SoldAsVacant,
   case  when SoldAsVacant = "Y" then "Yes"
	 when SoldAsVacant = "N" then "No"
	 else SoldAsVacant
   End
   from [project1].[dbo].[NashvilleHousing]

   Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From [project1].[dbo].[NashvilleHousing]

Update [project1].[dbo].[NashvilleHousing]
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From [project1].[dbo].[NashvilleHousing]
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

-- Delete Unused Columns



Select *
From [project1].[dbo].[NashvilleHousing]

ALTER TABLE[project1].[dbo].[NashvilleHousing]DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate


