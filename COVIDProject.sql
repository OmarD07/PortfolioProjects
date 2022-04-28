SELECT *
FROM PortfolioProject.dbo.CovidDeaths
ORDER BY 3,4

SELECT *
FROM PortfolioProject.dbo.CovidVaccinations
ORDER BY 3,4

--Select Data

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject.dbo.CovidDeaths
ORDER BY 1,2


-- Total Cases vs Total Deaths
-- This indicates the chances of dying if contracted by covid base on country

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases) *100 AS DeathPercentile
FROM PortfolioProject.dbo.CovidDeaths
WHERE location = 'United States'
ORDER BY 1,2


-- Total Cases vs Population 
-- This indicates what percentile of population contracted Covid

SELECT location, date, total_cases, Population, (total_cases/population) *100 AS Percentile_Population_Infected
FROM PortfolioProject.dbo.CovidDeaths
WHERE location = 'United States' 
AND continent is NOT NULL
ORDER BY 1,2


-- Highest Infection Rate vs Population per Country


SELECT Location, Population, MAX(total_cases) AS Highest_Infection_Count, MAX((total_cases/population)) *100 AS Percentile_Population_Infected
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is NOT NULL
GROUP BY location, population
ORDER BY Percentile_Population_Infected desc


-- Countries with Highest Death Count per Population

SELECT Location, MAX(cast(total_deaths as int)) AS Total_Death_Count
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is NOT NULL
GROUP BY location
ORDER BY Total_Death_Count desc


-- BY CONTINENT

SELECT continent, MAX(cast(total_deaths as int)) AS Total_Death_Count
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is NOT NULL
GROUP BY continent
ORDER BY Total_Death_Count desc


-- Continents with the Highest Death Count per Population

SELECT continent, MAX(cast(total_deaths as int)) AS Total_Death_Count
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent is NOT NULL
GROUP BY continent
ORDER BY Total_Death_Count desc



-- Global #'s (Total Cases, Total Deaths, & Death Percentage per day)

SELECT date, SUM(new_cases) AS Total_Cases, SUM(Cast(new_deaths as int)) AS Total_Deaths, SUM(Cast(new_deaths as int))/SUM(new_cases) * 100 as DeathPercentile
FROM PortfolioProject.dbo.CovidDeaths 
WHERE continent is NOT NULL
GROUP BY date
ORDER BY 1,2



-- Global #'s (Death Percentage across the world)
-- DeathPercentile has gone down by about 1% from 2% in 2021 due to more people vaccinated

SELECT SUM(new_cases) AS Total_Cases, SUM(Cast(new_deaths as int)) AS Total_Deaths, SUM(Cast(new_deaths as int))/SUM(new_cases) * 100 as DeathPercentile
FROM PortfolioProject.dbo.CovidDeaths 
WHERE continent is NOT NULL
ORDER BY 1,2


SELECT *
FROM PortfolioProject.dbo.CovidDeaths dea
JOIN PortfolioProject.dbo.CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date


-- Total Population vs Vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(bigint,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS PeopleVaccinated,
(RollingPeopleVaccinated/population) *100
FROM PortfolioProject.dbo.CovidDeaths dea
JOIN PortfolioProject.dbo.CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is NOT NULL
ORDER BY 2,3



--CTC Use

WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, PeopleVaccinated)
AS 
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(bigint,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS PeopleVaccinated
--(PeopleVaccinated/population) *100
FROM PortfolioProject.dbo.CovidDeaths dea
JOIN PortfolioProject.dbo.CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is NOT NULL
--ORDER BY 2,3
)
SELECT *, (PeopleVaccinated/Population) *100
FROM PopvsVac



-- Temp Table


DROP Table IF Exists #PercentilePopulationVaccinated
CREATE Table #PercentilePopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
PeopleVaccinated numeric
)

INSERT INTO #PercentilePopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(bigint,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS PeopleVaccinated
--(PeopleVaccinated/population) *100
FROM PortfolioProject.dbo.CovidDeaths dea
JOIN PortfolioProject.dbo.CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is NOT NULL
--ORDER BY 2,3

SELECT *, (PeopleVaccinated/Population) *100
FROM #PercentilePopulationVaccinated


--Creating View to store date for later visualization 

CREATE VIEW PercentilePopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(bigint,vac.new_vaccinations)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS PeopleVaccinated
--(PeopleVaccinated/population) *100
FROM PortfolioProject.dbo.CovidDeaths dea
JOIN PortfolioProject.dbo.CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is NOT NULL
--ORDER BY 2,3