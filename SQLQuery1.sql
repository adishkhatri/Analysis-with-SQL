select * from pra_project..CovidDeaths
Where continent is not null
order by 3,4

--select * from pra_project..CovidVaccinations
--order by 3,4

--selecting the data that we are going to use

Select location,date,total_cases,new_cases,total_deaths,population
from pra_project..CovidDeaths
Where continent is not null
Order by 1,2

-- total case vs total death,% of people death per cases or chances of death according to case
Select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From pra_project..CovidDeaths
Where location like'%dorra%' and continent is not null
--you can use where location = 'Nepal'

Order by 1,2


--Total Case vs Population of Nepal
--It's shows what percentage of population got covid in Nepal
Select location,date,total_cases,population,(total_cases/population)*100 as InfectedPercentge
From pra_project..CovidDeaths
--Where location ='Nepal'
Order by 1,2


--Country with the higest Infecred Percentage
Select location,population,max(total_cases)as HighestInfectionCount,max((total_cases/population))*100 as
HigestInfectedPercentge
From pra_project..CovidDeaths
Where continent is not null
Group by location,population
Order by HigestInfectedPercentge desc


-- Higest deat count by Country

Select location, Max(cast(total_deaths as int)) as TotalDearthCount
From pra_project..CovidDeaths
Where continent is not null
Group by location 
Order by TotalDearthCount desc


--Highest Death Count by continet--

Select continent, Max(cast(total_deaths as int)) as TotalDearthCount
From pra_project..CovidDeaths
Where continent is not null
Group by continent
Order by TotalDearthCount desc


--By Golobal Numbers new Death


Select sum(new_cases) as TotalNewCase,sum(cast(new_deaths as bigint)) as TotalNewDeaths,
sum(cast(new_deaths as bigint))/sum(new_cases)*100 as NewDeathPercent
from pra_project..CovidDeaths


--Golobal Number total
Select sum(total_cases) as TotalCase,sum(cast(total_deaths as bigint)) as TotalDeaths,
sum(cast(total_deaths as bigint))/sum(total_cases)*100 as TotalDeathPercent
from pra_project..CovidDeaths


Select CovidDeaths.continent,CovidVaccinations.location,CovidDeaths.date,CovidDeaths.population
,CovidVaccinations.new_vaccinations,
sum(convert(int,CovidVaccinations.new_vaccinations)) Over (Partition By CovidDeaths.location Order by CovidDeaths.location,CovidDeaths.date) as RpllingPeopleVaccinated
From pra_project..CovidDeaths
join pra_project..CovidVaccinations
   On CovidDeaths.location=CovidVaccinations.location
   AND CovidDeaths.date=CovidVaccinations.date
where CovidDeaths.continent is not null
order by 2,3


--CTE
with PopvsVac(continent,location,date,population,new_vaccinations,RollingPeopleVaccinated)
as
(
Select CovidDeaths.continent,CovidVaccinations.location,CovidDeaths.date,CovidDeaths.population
,CovidVaccinations.new_vaccinations,
sum(convert(int,CovidVaccinations.new_vaccinations)) Over (Partition By CovidDeaths.location Order by CovidDeaths.location,CovidDeaths.date) as RollingPeopleVaccinated
From pra_project..CovidDeaths
join pra_project..CovidVaccinations
   On CovidDeaths.location=CovidVaccinations.location
   AND CovidDeaths.date=CovidVaccinations.date
where CovidDeaths.continent is not null
--order by 2,3
)
Select*,(RollingPeopleVaccinated/population)*100 as RollingPeopleVaccinatedPercent
From PopvsVac
