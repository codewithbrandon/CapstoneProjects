SELECT*
FROM CapStoneProject..CovidDeaths
WHERE continent is not null 
order by 3, 4 


--SELECT*
--FROM CapStoneProject..CovidVaccinations
--order by 3, 4 

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM CapStoneProject..CovidDeaths
order by 1, 2


-- Looking at Total Cases vs Total Deaths
--Shows likelihood of dying if you contract covid in your country

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM CapStoneProject..CovidDeaths
WHERE location like '%states%' and continent is not null
order by 1, 2


-- Looking at total Cases vs Population
-- SHows what percentage of population contracted Covid-19

SELECT Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
FROM CapStoneProject..CovidDeaths
WHERE location like '%states%'
order by 1, 2

-- Looking at Countries with highest Infection Rate compared to Population

SELECT Location, Population, MAX(total_cases) as HighestInfectionCount,  MAX((total_cases/population))*100 as PercentPopulationInfected
FROM CapStoneProject..CovidDeaths
--WHERE location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc


-- Showing Countries with Highest Death Count per Population

SELECT Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM CapStoneProject..CovidDeaths
--WHERE location like '%states%'
Where continent is not null
Group by Location
order by TotalDeathCount desc

-- LET'S BREAK THINGS DOWN BY CONTINENT

SELECT continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM CapStoneProject..CovidDeaths
--WHERE location like '%states%'
Where continent is not null
Group by continent
order by TotalDeathCount desc


--Showing continents with the highest death count per population
SELECT continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
FROM CapStoneProject..CovidDeaths
--WHERE location like '%states%'
Where continent is not null
Group by continent
order by TotalDeathCount desc


-- GLOBAL NUMBERS
SELECT   SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/ SUM (New_Cases)*100 as DeathPercentage
FROM CapStoneProject..CovidDeaths
--WHERE location like '%states%'
where continent is not null
--GROUP BY date
order by 1, 2

-- Looking at Total Population vs Vaccinations


SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100 
FROM CapStoneProject..CovidDeaths dea
Join CapStoneProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by  2,3






-- Creating View to store data for later visualizations

--Create View PercentPopulationVaccinated 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100 
FROM CapStoneProject..CovidDeaths dea
Join CapStoneProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by  2,3