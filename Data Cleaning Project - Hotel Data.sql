 
 -- CLEANING DATA IN SQL


use portfolio2;

-- changing the format of saledate

alter table dbo.hotel2
add saledateconverted date

update dbo.hotel2
set saledateconverted = CAST(SaleDate as date)

-- populating property address field

select * 
from dbo.hotel2
where PropertyAddress is null

select a.[UniqueID ],a.ParcelID,a.PropertyAddress,b.[UniqueID ],b.ParcelID,b.PropertyAddress,ISNULL(a.propertyaddress,b.PropertyAddress)
from dbo.hotel2 as a 
join dbo.hotel2 as b
on a.[UniqueID ] <> b.[UniqueID ] and
a.ParcelID = b.ParcelID
where a.PropertyAddress is null

update a
set propertyaddress = ISNULL(a.propertyaddress,b.PropertyAddress)
from dbo.hotel2 as a 
join dbo.hotel2 as b
on a.[UniqueID ] <> b.[UniqueID ] and
a.ParcelID = b.ParcelID
where a.PropertyAddress is null

--- Splitting property address to 'address' and 'city'

select propertyaddress,
SUBSTRING(propertyaddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(propertyaddress,CHARINDEX(',',propertyaddress)+1,LEN(propertyaddress)) as city
from dbo.hotel2

alter table dbo.hotel2
add propertysplitaddress nvarchar(255);

update dbo.hotel2
set propertysplitaddress  = SUBSTRING(propertyaddress,1,CHARINDEX(',',PropertyAddress)-1)

alter table dbo.hotel2
add propertysplitcity nvarchar(255)

update dbo.hotel2
set propertysplitcity = SUBSTRING(propertyaddress,CHARINDEX(',',propertyaddress)+1,LEN(propertyaddress))

-- Splitting owner address to address, city and state


select OwnerAddress,
parsename(replace(owneraddress,',','.'),3),
parsename(replace(owneraddress,',','.'),2),
parsename(replace(owneraddress,',','.'),1)
from dbo.hotel2
where OwnerAddress is not null


alter table dbo.hotel2
add ownersplitaddress nvarchar(255)

update dbo.hotel2
set ownersplitaddress = parsename(replace(owneraddress,',','.'),3)

alter table dbo.hotel2
add ownersplitcity nvarchar(255)

update dbo.hotel2
set ownersplitcity = parsename(replace(owneraddress,',','.'),2)


alter table dbo.hotel2
add ownersplitstate nvarchar(255)

update dbo.hotel2
set ownersplitstate = parsename(replace(owneraddress,',','.'),1)


-- Changind Y to YES and N to No in 'soldasvacant' column

select
SoldAsVacant,
Case
 when SoldAsVacant = 'N' then 'No'
  when soldasvacant = 'Y' then 'Yes'
  else soldasvacant
  end
from dbo.hotel2


update dbo.hotel2
set soldasvacant = Case
 when SoldAsVacant = 'N' then 'No'
  when soldasvacant = 'Y' then 'Yes'
  else soldasvacant
  end
from dbo.hotel2

--- Removind duplicates using ROW NUMBER

select * 
from dbo.hotel2

with duplicate as(      
select *,
ROW_NUMBER() over (partition by parcelid, propertyaddress,saledate,saleprice,legalreference,ownername order by parcelid) as row_number
from dbo.hotel2)
select * 
from duplicate
where row_number >1               -- finding duplicated rows


with duplicate as(       
select *,
ROW_NUMBER() over (partition by parcelid, propertyaddress,saledate,saleprice,legalreference,ownername order by parcelid) as row_number
from dbo.hotel2)
delete 
from duplicate
where row_number >1                --deleting the duplicated rows

