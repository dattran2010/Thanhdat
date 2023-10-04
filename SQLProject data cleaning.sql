/*

Cleaning Data in SQL Queries

*/
SELECT *
FROM DBO.NashvilleHousing



--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

ALTER TABLE [dbo].[NashvilleHousing]
ADD SaleDateConverted date

Update dbo.NashvilleHousing
set SaleDateConverted=CONVERT (DATE,SaleDate)

SELECT SaleDateConverted
FROM DBO.NashvilleHousing



-- If it doesn't Update properly



 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
from dbo.NashvilleHousing
order by PropertyAddress desc

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.propertyaddress,b.propertyaddress)
from dbo.NashvilleHousing as a
join dbo.NashvilleHousing as b
on a.ParcelID=b.ParcelID
where a.[UniqueID ]<>b.[UniqueID ] and a.PropertyAddress is null

update a
set a.propertyaddress = isnull(a.propertyaddress,b.propertyaddress)
from dbo.NashvilleHousing as a
join dbo.NashvilleHousing as b
on a.ParcelID=b.ParcelID
where a.[UniqueID ]<>b.[UniqueID ] and a.PropertyAddress is null

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
from dbo.NashvilleHousing as a
join dbo.NashvilleHousing as b
on a.ParcelID=b.ParcelID
where a.[UniqueID ]<>b.[UniqueID ] and a.PropertyAddress is null


--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address, Owner Address into Individual Columns (Address, City, State)
SELECT PropertyAddress
FROM DBO.NashvilleHousing

SELECT
SUBSTRING (PropertyAddress, 1, CHARINDEX (',',(PropertyAddress))-1) AS Address
,SUBSTRING (PropertyAddress, CHARINDEX (',',(PropertyAddress))+1,len(PropertyAddress)) AS Address
FROM DBO.NashvilleHousing

ALTER TABLE [dbo].[NashvilleHousing]
ADD PropertyAddressDetail nvarchar (50)

Update dbo.NashvilleHousing
set PropertyAddressDetail = SUBSTRING (PropertyAddress, 1, CHARINDEX (',',(PropertyAddress))-1)

ALTER TABLE [dbo].[NashvilleHousing]
ADD PropertyAddressCity nvarchar (50)

Update dbo.NashvilleHousing
set PropertyAddressCity= SUBSTRING (PropertyAddress, CHARINDEX (',',(PropertyAddress))+1,len(PropertyAddress))

Select *
from dbo.NashvilleHousing

Select OwnerAddress
from dbo.NashvilleHousing

Select PARSENAME (replace( OwnerAddress,',','.'),3), 
PARSENAME (replace( OwnerAddress,',','.'),2),
PARSENAME (replace( OwnerAddress,',','.'),1)
from dbo.NashvilleHousing

ALTER TABLE [dbo].[NashvilleHousing]
ADD OwnerAddressDetail nvarchar (50)

Update dbo.NashvilleHousing
set OwnerAddressDetail = PARSENAME (replace( OwnerAddress,',','.'),3)

ALTER TABLE [dbo].[NashvilleHousing]
ADD OwnerAddressCity nvarchar (50)

Update dbo.NashvilleHousing
set OwnerAddressCity = PARSENAME (replace( OwnerAddress,',','.'),2)

ALTER TABLE [dbo].[NashvilleHousing]
ADD OwnerAddressState nvarchar (50)

Update dbo.NashvilleHousing
set OwnerAddressState = PARSENAME (replace( OwnerAddress,',','.'),1)

Select *
from dbo.NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

Select SoldAsVacant
from dbo.NashvilleHousing

Select SoldAsVacant,
Case
when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
Else SoldAsVacant
end as SoldAsVacantFixed
from dbo.NashvilleHousing

Update dbo.NashvilleHousing
Set SoldAsVacant = 
Case
when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
Else SoldAsVacant
end 

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

Select *
from dbo.NashvilleHousing


With RownumCTE
As (
Select *,
Row_number () over (
Partition by [ParcelID],[PropertyAddress],[SaleDate],[LegalReference]
order by UniqueID) as Row_num
from dbo.NashvilleHousing)

Select *
from RownumCTE
where Row_num >1
---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

Select *
from dbo.NashvilleHousing

Alter table dbo.NashvilleHousing
drop column [PropertyAddress],[SaleDate],[OwnerAddress],[TaxDistrict]

