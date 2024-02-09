-- This query selects specific columns from the CovidDeaths table and orders the results by location and date.

SELECT 
    location,
    date,
    total_cases,
    new_cases,
    total_deaths,
    population 
FROM 
    CovidDeaths
ORDER BY 
    1,  -- Orders the results by the first selected column (location)
    2;  -- Then by the second selected column (date)


-- This SQL query retrieves data from the CovidDeaths table
-- It calculates the death percentage for each location and date
-- The DeathPercentage is calculated as the ratio of total_deaths to total_cases, multiplied by 100

SELECT
    location,
    date,
    total_cases,
    total_deaths,
    CASE
        WHEN total_cases > 0 THEN (CAST(total_deaths AS FLOAT) / total_cases) * 100
        ELSE NULL -- or any default value you want
    END AS DeathPercentage
FROM CovidDeaths
ORDER BY 1, 2;



 --This query selects specific columns from the CovidDeaths table
SELECT
    location,
    date,
    total_cases,
    total_deaths,
    population,
  -- This calculates the percentage of population infected, if total_cases is greater than 0
    CASE
        WHEN total_cases > 0 THEN (CAST(total_cases AS FLOAT) / population) * 100
        ELSE NULL -- or any default value you want
    END AS PercentPopulationInfected
FROM CovidDeaths
-- Selecting data only for locations containing 'Africa'
WHERE location like '%Africa%'
ORDER BY 1, 2;



--checking coutrie wih highest infection rate in percentge
SELECT
    location,
    population,
    MAX(total_cases) AS HighestInfectionCount,
    MAX((CAST(total_cases AS FLOAT) / population)) * 100 AS PercentPopulationInfected
FROM CovidDeaths
GROUP BY location, population
ORDER BY PercentPopulationInfected desc;



--show countries with highest death count per population
SELECT location,
MAX(CAST(total_deaths AS int)) AS TotalDeathCount
FROM CovidDeaths
WHERE continent is not null
GROUP by location
ORDER by TotalDeathCount desc;


--TOTAL DEATHS BY CONTINENT
SELECT
      continent,
      MAX(CAST(total_deaths AS int)) AS TotalDeathCount
FROM CovidDeaths
WHERE continent is not null
GROUP by continent
order by TotalDeathCount desc;


--GLOBAL; NEW NUMBERS 
SELECT
      --date,
      SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, SUM(new_deaths)/ SUM(new_cases)  * 100 AS DeathPercentage
FROM CovidDeaths      
--GROUP BY date
ORDER BY 1,2;


--TABLE 2 & JOIN

SELECT * 
FROM CovidDeaths dea 
JOIN CovidVaccinations vac
on  vac.date = dea.date 
and vac.location = dea.location


--looking for population vs vaccinations

SELECT 
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.date) AS total_new_vaccinations
FROM 
    CovidDeaths dea
JOIN 
    CovidVaccinations vac ON dea.date = vac.date AND dea.location = vac.location
ORDER BY 
    dea.location, dea.date;
    
    


--USING CTE TO CALCULATE % RATE OF PEOPLE VACINATED WITH THE NEW FORMED COLUMN

WITH PopsvsVac (Continent, Location, Date, Population, New_Vaccination, total_new_vaccinations)
as 
(
SELECT 
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.date) AS total_new_vaccinations
FROM 
    CovidDeaths dea
JOIN 
    CovidVaccinations vac ON dea.date = vac.date AND dea.location = vac.location
)
SELECT * , (total_new_vaccinations/population) * 100 AS VaccinationPercentage
FROM
    PopsvsVac



--CREATING A TEMP TABLE

DROP TABLE IF exists PercentPopulationVaccinated
CREATE TABLE PercentPopulationVaccinated
(

Continent nvarchar(255),
Location nvarchar(255),
Date datetime, 
Population numeric,
New_Vaccinations numeric,
Total_New_Vaccinations numeric
)


--INSERT INTO THE TABLE THE DATA WE HAVE JOINED

INSERT INTO PercentPopulationVaccinated
SELECT 
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.date) AS total_new_vaccinations
FROM 
    CovidDeaths dea
JOIN 
    CovidVaccinations vac ON dea.date = vac.date AND dea.location = vac.location


-- VIEW THE TABLE WITH NEW COLUMN OF PEOPLE vaccinated

SELECT *, 
       (CAST(Total_New_Vaccinations AS FLOAT) / CAST(Population AS FLOAT)) * 100 AS PercentVaccinated
FROM 
     PercentPopulationVaccinated
     
     
-- CREATE VIEW TO BE STORED AS ATA FOR FUTURE VISUALIZATIONS
DROP VIEW IF EXISTS PercentPopulationVaccinatedView
CREATE VIEW PercentPopulationVaccinatedView AS 
SELECT 
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.date) AS total_new_vaccinations
FROM 
    CovidDeaths dea
JOIN 
    CovidVaccinations vac ON dea.date = vac.date AND dea.location = vac.location


