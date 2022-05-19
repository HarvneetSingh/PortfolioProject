use portfolio2;

select * from [dbo].['Suicides in India 2001-2012$'];

-- removing duplicates using Row Number
with temp_table as (
select *,
ROW_NUMBER() over (partition by state,year,type_code,type,gender,age_group order by state) as duplicate
from dbo.['Suicides in India 2001-2012$'])
--order by state, year
 select *  from temp_table;
--where duplicate >1

select * from dbo.['Suicides in India 2001-2012$'];

-- Perecentage of Suicides over states using subquery
select distinct(state)
from dbo.['Suicides in India 2001-2012$']
order by state
 
select state, round(sum(total)/(select sum(total) from dbo.['Suicides in India 2001-2012$'] where state not in  ('Total (All India)','Total (States)','Total (Uts)'))*100,2 ) as percentage
from dbo.['Suicides in India 2001-2012$']
where state not in  ('Total (All India)','Total (States)','Total (Uts)') 
group by State
order by  percentage desc;


--- Male / Female Ratio of suicides 
select gender, round(sum(total)/(select sum(total) from dbo.['Suicides in India 2001-2012$'] where state not in  ('Total (All India)','Total (States)','Total (Uts)'))*100,2) as percentage
from dbo.['Suicides in India 2001-2012$']
where state not in  ('Total (All India)','Total (States)','Total (Uts)')
group by gender

------------------------------
select * from dbo.['Suicides in India 2001-2012$']
---Causes for the suicides 
select type_code,type, sum(total) as total
from dbo.['Suicides in India 2001-2012$']
where type_code = 'causes'
group by type_code,type
order by total desc
-- family problem followed by prolonged illness are the most common causes for suicides.

-- Means used for Suicides
select type_code,type, sum(total) as total
from dbo.['Suicides in India 2001-2012$']
where type_code = 'Means_adopted'
group by type_code,type
order by total desc;
-- The most common mean adopted for suicides is Hanging.

-- age group with most suicides
select age_group, SUM(total) as total
from dbo.['Suicides in India 2001-2012$']
where age_group != '0-100+'
group by Age_group
order by total
-- Most suicides are committed by age group 15-29