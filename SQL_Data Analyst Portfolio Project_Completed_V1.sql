SELECT *
FROM PortfolioProjectAD..Covid_Deaths
ORDER BY 3,4


--SELECT *
--FROM PortfolioProjectAD..Covid_Vaccinations
--ORDER BY 3,4

-- Select data which are to be used

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProjectAD..Covid_Deaths
ORDER BY 1,2

-- Total Cases Vs Total Deaths

SELECT location, date, total_cases, total_deaths, new_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProjectAD..Covid_Deaths
WHERE location like '%india%'
ORDER BY 1,2


-- Total Cases Vs Population

SELECT location, date, total_cases, total_deaths, new_deaths, population, (total_cases/population)*100 as PercentPopulationInfected
FROM PortfolioProjectAD..Covid_Deaths
WHERE location like '%india%'
ORDER BY 1,2

-- Highest Infection Rate Compared to Population

SELECT location, population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
FROM PortfolioProjectAD..Covid_Deaths
--WHERE location like '%states%'
Group by location, population
ORDER BY PercentPopulationInfected desc

-- Highest Death count Compared to Population

SELECT location, MAX(cast(Total_deaths as int)) as TotaldeathCount
FROM PortfolioProjectAD..Covid_Deaths
--WHERE location like '%states%'
WHERE continent is NOT NULL
Group by location
ORDER BY TotaldeathCount desc


-- Continents with highest death count based on population

SELECT continent, MAX(cast(Total_deaths as int)) as TotaldeathCount
FROM PortfolioProjectAD..Covid_Deaths
--WHERE location like '%states%'
WHERE continent is NOT NULL
GROUP by continent
ORDER BY TotaldeathCount DESC

-- GLOBAL NUMBERS V.1

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProjectAD..Covid_Deaths
WHERE location like '%all%'
and continent is not null
ORDER BY 1,2

-- GLOBAL NUMBERS V.1.1

SELECT date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProjectAD..Covid_Deaths
--WHERE location like '%all%'
WHERE continent is not null
ORDER BY 1,2
--- Check the video link for errors and reasong behind the error "https://youtu.be/qfyynHBFOsM?list=PLTn0uOUd_5yRq85TjVqFpBKeicB_Nfo6H&t=2691"

-- GLOBAL NUMBERS V.1.2

SELECT date, SUM(new_cases)--,total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProjectAD..Covid_Deaths
--WHERE location like '%all%'
WHERE continent is not null
GROUP BY date
ORDER BY 1,2

-- GLOBAL NUMBERS V.1.3

SELECT date, SUM(new_cases), SUM(cast(new_deaths as int))--,total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProjectAD..Covid_Deaths
--WHERE location like '%all%'
WHERE continent is not null
GROUP BY date
ORDER BY 1,2

-- GLOBAL NUMBERS V.1.4

SELECT date, SUM(new_cases), SUM(cast(new_deaths as int)), SUM(cast(new_deaths as INT))/SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProjectAD..Covid_Deaths
--WHERE location like '%all%'
WHERE continent is not null
GROUP BY date
ORDER BY 1,2

-- GLOBAL NUMBERS V.1.5

SELECT date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as INT))/SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProjectAD..Covid_Deaths
--WHERE location like '%all%'
WHERE continent is not null
GROUP BY date
ORDER BY 1,2

--- Covid Vaccination Table View

SELECT *
FROM PortfolioProjectAD..Covid_Vaccinations

SELECT *
FROM PortfolioProjectAD..Covid_Deaths

--- TABLE JOINS

select * 
From PortfolioProjectAD..Covid_Deaths dea
Join PortfolioProjectAD..Covid_Vaccinations vac
    On dea.location = vac.location
	and dea.date = vac.date


--- Looking at Total Population Vs Total Vaccination

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From PortfolioProjectAD..Covid_Deaths dea
Join PortfolioProjectAD..Covid_Vaccinations vac
    On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3



--- Looking at Total Population Vs Total Vaccination (Rolling Total by country Method 1)

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location) 
From PortfolioProjectAD..Covid_Deaths dea
Join PortfolioProjectAD..Covid_Vaccinations vac
    On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--WHERE dea.location like '%india%'
ORDER BY 2,3

--- Looking at Total Population Vs Total Vaccination (Rolling Total by country Method 2)

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location) 
From PortfolioProjectAD..Covid_Deaths dea
Join PortfolioProjectAD..Covid_Vaccinations vac
    On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--WHERE dea.location like '%india%'
ORDER BY 2,3

--- Looking at Total Population Vs Total Vaccination (Rolling Total by country Method 3)

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location,dea.date) 
From PortfolioProjectAD..Covid_Deaths dea
Join PortfolioProjectAD..Covid_Vaccinations vac
    On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--WHERE dea.location like '%india%'
ORDER BY 2,3


--- Looking at Total Population Vs Total Vaccination (Rolling Total by country Method 3)

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location,dea.date)
From PortfolioProjectAD..Covid_Deaths dea
Join PortfolioProjectAD..Covid_Vaccinations vac
    On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--WHERE dea.location like '%india%'
ORDER BY 2,3


--- Looking at Total Population Vs Total Vaccination (Rolling Total by country Method 4) Use CTE

With PopVsVac (Continent,Location,Date,Population,new_vaccinations,Cumulative_Vaccinations)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location,dea.date) as Cumulative_Vaccinations
From PortfolioProjectAD..Covid_Deaths dea
Join PortfolioProjectAD..Covid_Vaccinations vac
    On dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
--WHERE dea.location like '%india%'
--ORDER BY 2,3
)
Select *
From PopVsVac



--CTE with percentage

With PopVsVac (Continent,Location,Date,Population,new_vaccinations,Cumulative_Vaccinations)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location,dea.date) as Cumulative_Vaccinations
From PortfolioProjectAD..Covid_Deaths dea
Join PortfolioProjectAD..Covid_Vaccinations vac
    On dea.location = vac.location
	and dea.date = vac.date
  WHERE dea.continent is not null
--WHERE dea.location like '%india%'
--ORDER BY 2,3
)
Select *, (Cumulative_Vaccinations/Population)*100 as Cumulative_Vaccinations_Percent
From PopVsVac


--- TEMP TABLE

Create Table #Percent_Vaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
new_vaccinations numeric,
Cumulative_Vaccinations numeric
)

Insert into #Percent_Vaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location,dea.date) as Cumulative_Vaccinations
From PortfolioProjectAD..Covid_Deaths dea
Join PortfolioProjectAD..Covid_Vaccinations vac
    On dea.location = vac.location
	and dea.date = vac.date
  WHERE dea.continent is not null
--WHERE dea.location like '%india%'
--ORDER BY 2,3

Select *, (Cumulative_Vaccinations/Population)*100 as Cumulative_Vaccinations_Percent
From #Percent_Vaccinated


--- TEMP TABLE Version 2
DROP Table if exists #Percent_Vaccinated
Create Table #Percent_Vaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
new_vaccinations numeric,
Cumulative_Vaccinations numeric
)

Insert into #Percent_Vaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location,dea.date) as Cumulative_Vaccinations
From PortfolioProjectAD..Covid_Deaths dea
Join PortfolioProjectAD..Covid_Vaccinations vac
    On dea.location = vac.location
	and dea.date = vac.date
--WHERE dea.continent is not null
--WHERE dea.location like '%india%'
--ORDER BY 2,3

Select *, (Cumulative_Vaccinations/Population)*100 as Cumulative_Vaccinations_Percent
From #Percent_Vaccinated



--- Creating View to store data for later visualizations

--DROP VIEW if exists #Percent_Vaccinated
CREATE VIEW Percent_Vaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location,dea.date) as Cumulative_Vaccinations
From PortfolioProjectAD..Covid_Deaths dea
Join PortfolioProjectAD..Covid_Vaccinations vac
    On dea.location = vac.location
	and dea.date = vac.date
  WHERE dea.continent is not null
--WHERE dea.location like '%india%'
--ORDER BY 2,3

---- The above view is not visible, needs to be looked at later on

Select *
From Percent_Vaccinated
































--52:10 Minutes

-- url:- https://www.youtube.com/watch?v=qfyynHBFOsM&list=PLTn0uOUd_5yRq85TjVqFpBKeicB_Nfo6H&index=22&t=213s


















