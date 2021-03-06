use covid_portfolio;

-- Viewing Data
SELECT 
    *
FROM
    `covid-343315.portfolio_project.deaths`
ORDER BY location , date;


-- Selecting important Columns

SELECT 
    location,
    date,
    total_cases,
    new_cases,
    total_deaths,
    population
FROM
    `covid-343315.portfolio_project.deaths`
ORDER BY location , date;

-- finding percentage of deaths after having covid 

SELECT 
    location,
    date,
    (total_deaths / total_cases) * 100 AS percentageDeath,
    total_cases,
    total_deaths
FROM
    `covid-343315.portfolio_project.deaths`
WHERE
    location = 'India'
ORDER BY location , date;

-- Cases vs population

SELECT 
    location,
    date,
    total_cases,
    total_deaths,
    population,
    (total_cases / population) * 100 AS percent_population_infected
FROM
    `covid-343315.portfolio_project.deaths`
WHERE
    location = 'India'
ORDER BY location , date;

-- finding which country has highest infection rate
SELECT 
    location,
    population,
    MAX(total_cases) AS total_cases,
    MAX((total_cases / population) * 100) AS percent_population_infected
FROM
    `covid-343315.portfolio_project.deaths`
GROUP BY location , population
ORDER BY percent_population_infected DESC;

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
from CTE_covid;


-- Creating Views

create view	PopulationVaccinated as 
SELECT
  dea.continent,
  dea.location,
  cast(dea.date as date) as date,
  dea.population,
  cast(vac.new_vaccinations as unsigned) as new_vaccination,
  SUM(cast(vac.new_vaccinations as unsigned)) OVER (PARTITION BY dea.location ORDER BY dea.location,cast(dea.date as date)) as rollingVaccinations
FROM
  covid_portfolio.coviddeaths AS dea
JOIN
  covid_portfolio.covidvaccination AS vac
ON
  dea.location = vac.location
  AND dea.date = vac.date
WHERE
  dea.continent IS NOT NULL
ORDER BY
  dea.location,
  dea.date;