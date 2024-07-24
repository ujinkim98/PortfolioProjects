SELECT *
FROM coviddeath
WHERE continent IS NOT NULL
ORDER BY 3, 4;

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM coviddeath
ORDER BY 1, 2;

-- Total Case VS Total Death
-- Ujin's code
SELECT main.location, main.total_cases, main.total_deaths
FROM coviddeath AS main, (SELECT location, MAX(Date) AS max_date
FROM coviddeath
GROUP BY location) AS sub
WHERE main.date = sub.max_date AND main.location = sub.location;

-- Likelihood of dying if I get covid in Japan
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM coviddeath
WHERE location = 'Japan'
ORDER BY 1, 2;

-- Total Cases vs population
-- how many people got covid in total population
SELECT location, date, population, total_cases, (total_cases/population)*100 AS PercentPopulationInfected
FROM coviddeath
WHERE location = 'Japan'
ORDER BY 1, 2;

-- Countries with Highest Infection Rate compared to Population
-- Ujin's code
SELECT location, population, total_cases, (total_cases/population)*100 AS PercentPopulationInfected
FROM coviddeath
WHERE (total_cases/population)*100 = (SELECT MAX((total_cases/population)*100) AS max_population_percentage
FROM coviddeath)
ORDER BY 1, 2;

SELECT location, population, MAX(total_cases), MAX((total_cases/population)*100) AS PercentPopulationInfected
FROM coviddeath
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC;

-- Showing Countries with Highest Death Count per Population
SELECT location, MAX(total_deaths) AS TotalDeathCount
FROM coviddeath
WHERE continent IS NOT NULL -- There is some records that have NULL in continent and name of continet in location(ex. Asia in location)
GROUP BY location
ORDER BY TotalDeathCount DESC;

-- Break Things Down By Continent
-- Showing continents with the highest death count per population 
SELECT continent, MAX(total_deaths) AS TotalDeathCount
FROM coviddeath
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC;

-- Global numbers
SELECT SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, (SUM(new_deaths)/NULLIF(SUM(new_cases),0))*100 as DeathPercentage
FROM coviddeath
WHERE continent IS NOT NULL
--GROUP BY date
ORDER BY 1, 2;

-- Looking at Total Population vs Vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM coviddeath AS dea
JOIN covidvaccinations AS vac
	ON dea.location = vac.location 
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2, 3;

SELECT dea.continent, dea.location, dea.population, SUM(vac.new_vaccinations)
FROM coviddeath AS dea
JOIN covidvaccinations AS vac
	ON dea.location = vac.location 
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
GROUP BY dea.continent, dea.location, dea.population
ORDER BY 2;

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	SUM(vac.new_vaccinations) OVER (Partition by dea.location)
FROM coviddeath AS dea
JOIN covidvaccinations AS vac
	ON dea.location = vac.location 
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2;

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	SUM(vac.new_vaccinations) OVER (Partition by dea.location ORDER BY dea.location, dea.date)
	AS RollingPeopleVaccinated -- ORDER BY 뒤에 왜 dea.location이 필요하지?
FROM coviddeath AS dea
JOIN covidvaccinations AS vac
	ON dea.location = vac.location 
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2;

-- Ujin's code
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	SUM(vac.new_vaccinations) OVER (Partition by dea.location ORDER BY dea.location, dea.date)
	AS RollingPeopleVaccinated,
	SUM(vac.new_vaccinations) OVER (Partition by dea.location ORDER BY dea.location, dea.date)/
	dea.population*100
FROM coviddeath AS dea
JOIN covidvaccinations AS vac
	ON dea.location = vac.location 
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2;

-- USE CTE
WITH cte AS (
	SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	SUM(vac.new_vaccinations) OVER (Partition by dea.location ORDER BY dea.location, dea.date)
	AS RollingPeopleVaccinated
	FROM coviddeath AS dea
	JOIN covidvaccinations AS vac
		ON dea.location = vac.location 
		AND dea.date = vac.date
	WHERE dea.continent IS NOT NULL
)

SELECT *, (RollingPeopleVaccinated/population)*100
FROM cte;

-- max people vaccinated만 사용해서 해보기!!!

-- USE Temp Table, 아래 코드 안 먹힘 1:08:00 참조
DROP Table if exists PercentPopulationVaccinated
Create Table PercentPopulationVaccinated
(
	Continent varchar(255),
	Location varchar(255),
	Date date,
	Population numeric,
	New_vaccinations numeric,
	RollingPeopleVaccinated numeric
)

INSERT INTO PercentPopulationVaccinated (Continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
VALUES (
	SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	SUM(vac.new_vaccinations) OVER (Partition by dea.location ORDER BY dea.location, dea.date)
	AS RollingPeopleVaccinated
	FROM coviddeath AS dea
	JOIN covidvaccinations AS vac
		ON dea.location = vac.location 
		AND dea.date = vac.date
	WHERE dea.continent IS NOT NULL
)

SELECT *, (RollingPeopleVaccinated/population)*100
FROM PercentPopulationVaccinated;

-- Creating View to store data for later visualizations
Create View PercentPopulationVaccinated AS
(
	SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	SUM(vac.new_vaccinations) OVER (Partition by dea.location ORDER BY dea.location, dea.date)
	AS RollingPeopleVaccinated
	FROM coviddeath AS dea
	JOIN covidvaccinations AS vac
		ON dea.location = vac.location 
		AND dea.date = vac.date
	WHERE dea.continent IS NOT NULL
);	

SELECT *
FROM PercentPopulationVaccinated;