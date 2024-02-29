Select *
from [Portfolio Project 2].dbo.NashvilleHousing

--Standardize Date format
Select SaleDate, convert(date,Saledate)
from [Portfolio Project 2].dbo.NashvilleHousing

Update NashvilleHousing
set SaleDate = Convert(Date,SaleDate)

ALTER TABLE NashvilleHousing ALTER COLUMN SaleDate DATE


--Populate Property Addres data
Select PropertyAddress
from [Portfolio Project 2].dbo.NashvilleHousing
where PropertyAddress is null
order by ParcelID

--Joining table
Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress,
ISNULL(a.PropertyAddress,b.PropertyAddress)
from [Portfolio Project 2].dbo.NashvilleHousing as a
join [Portfolio Project 2].dbo.NashvilleHousing as b
	on a.ParcelID =b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress =ISNULL(a.PropertyAddress,b.PropertyAddress)
from [Portfolio Project 2].dbo.NashvilleHousing as a
join [Portfolio Project 2].dbo.NashvilleHousing as b
	on a.ParcelID =b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

--Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
from [Portfolio Project 2].dbo.NashvilleHousing

Select
substring(PropertyAddress,1,charindex(',', PropertyAddress) -1)
as Address, 
substring(PropertyAddress, charindex(',', PropertyAddress) +1 
, len(PropertyAddress))as Address
from [Portfolio Project 2].dbo.NashvilleHousing

--Create two new columns
Alter table [Portfolio Project 2].dbo.NashvilleHousing
add PropertySplitAddress Nvarchar(255);

update [Portfolio Project 2].dbo.NashvilleHousing
set PropertySplitAddress = substring(PropertyAddress,1,charindex(',', PropertyAddress) -1)
add PropertySplitAddress Nvarchar(255); 

Alter table [Portfolio Project 2].dbo.NashvilleHousing
add PropertySplitCity Nvarchar(255);

Update [Portfolio Project 2].dbo.NashvilleHousing
set PropertySplitCity = substring(PropertyAddress, charindex(',', PropertyAddress) +1, len(PropertyAddress)) 

--Using Parsename
select 
Parsename(Replace(OwnerAddress,',','.'),3) as Address
,Parsename(Replace(OwnerAddress,',','.'),2) as City
,Parsename(Replace(OwnerAddress,',','.'),1) as State
from [Portfolio Project 2].dbo.NashvilleHousing



Alter table [Portfolio Project 2].dbo.NashvilleHousing
add OwnerSplitAddress Nvarchar(255);

update [Portfolio Project 2].dbo.NashvilleHousing
set OwnerSplitAddress = Parsename(Replace(OwnerAddress,',','.'),3) 


Alter table [Portfolio Project 2].dbo.NashvilleHousing
add OwnerSplitCity Nvarchar(255);

Update [Portfolio Project 2].dbo.NashvilleHousing
set OwnerSplitCity = Parsename(Replace(OwnerAddress,',','.'),2) 

Alter table [Portfolio Project 2].dbo.NashvilleHousing
add OwnerSplitState Nvarchar(255);

Update [Portfolio Project 2].dbo.NashvilleHousing
set OwnerSplitState = Parsename(Replace(OwnerAddress,',','.'),1) 

select *
from [Portfolio Project 2].dbo.NashvilleHousing



--Change Y and N to YES and NO in "Sold as Vacant" field
select distinct(SoldAsVacant), count(SoldAsVacant)
from [Portfolio Project 2].dbo.NashvilleHousing
group by SoldAsVacant
order by 2

Select SoldAsVacant
, case when SoldAsVacant ='Y' then 'YES'
		when SoldAsVacant ='N' then 'NO'
		else SoldAsVacant
		end
from [Portfolio Project 2].dbo.NashvilleHousing

update[Portfolio Project 2].dbo.NashvilleHousing
Set SoldAsVacant = case when SoldAsVacant ='Y' then 'YES'
		when SoldAsVacant ='N' then 'NO'
		else SoldAsVacant
		end


--Remove Duplicates
with RowNumCTE as (
select *,
	ROW_NUMBER() over (
	partition by ParcelID,
				PropertyAddress,
				SalePrice,
				LegalReference
				order by 
					UniqueID
					) as row_num

from [Portfolio Project 2].dbo.NashvilleHousing
--order by ParcelID
)
Delete
from RowNumCTE
where row_num>1
--order by PropertyAddress



--Delete Unused Columns

Select *
from [Portfolio Project 2].dbo.NashvilleHousing

alter table [Portfolio Project 2].dbo.NashvilleHousing
drop column ownerAddress, TaxDistrict, PropertyAddress



