use covid_portfolio;

-- Viewing Data
SELECT *  FROM `covid-343315.portfolio_project.deaths`
order by location, date;

select * from `covid-343315.portfolio_project.Vaccination`;

select location, date, total_cases, new_cases, total_deaths, population
from `covid-343315.portfolio_project.deaths`
order by location, date;

-- finding percentage of deaths after having covid 

select location, date, (total_deaths/total_cases)*100 as percentageDeath,total_cases, total_deaths
from `covid-343315.portfolio_project.deaths`
where location = "India"
order by location, date;

-- Cases vs population

select location, date, total_cases, total_deaths, population, (total_cases/population)*100 as percent_population_infected
from `covid-343315.portfolio_project.deaths`
where location = "India"
order by location, date;

--finding which country has highest infection rate
select location,population, max(total_cases) as total_cases,max((total_cases/population)*100) as percent_population_infected
from `covid-343315.portfolio_project.deaths`
GROUP BY location,population
order by percent_population_infected desc ;

-------------------------
# finding total death rate
select location, max(total_deaths) as totalDeath
from `covid-343315.portfolio_project.deaths`
where continent is null
group by  location
order by totalDeath desc;

-- finding rolling count of new_vaccination
SELECT
  dea.continent,
  dea.location,
  dea.date,
  dea.population,
  vac.new_vaccinations,
  SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date) as rollingVaccinations
FROM
  `covid-343315.portfolio_project.deaths` AS dea
JOIN
  `covid-343315.portfolio_project.Vaccination` AS vac
ON
  dea.location = vac.location
  AND dea.date = vac.date
WHERE
  dea.continent IS NOT NULL
ORDER BY
  dea.location,
  dea.date;

-- Rolling count of percetage of population Vaccinated with atleast one doze or both using CTE
with CTE_covid as
(SELECT
  dea.continent,
  dea.location,
  dea.date,
  dea.population,
  vac.new_vaccinations,
  SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date) as rollingVaccinations
FROM
  `covid-343315.portfolio_project.deaths` AS dea
JOIN
  `covid-343315.portfolio_project.Vaccination` AS vac
ON
  dea.location = vac.location
  AND dea.date = vac.date
WHERE
  dea.continent IS NOT NULL
ORDER BY
  dea.location,
  dea.date)
select *,
(rollingVaccinations/population)*100 as rollingVacciantionPercentage 
from CTE_covid
where location = "India";
