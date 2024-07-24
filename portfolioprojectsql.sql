select *
from project1..CovidDeaths$
order by 3,4
--select *
--from project1..CovidVaccinations$
--order by 3,4
select Location, date, total_cases, new_cases, total_deaths, Population
from project1..CovidDeaths$
order by 1,2

--Death percentage
select Location, date, total_cases, (total_deaths/total_cases)*100 as DeathPercentage
from project1..CovidDeaths$
where location like '%India%'
order by 1,2

--what percentage of population has covid
select Location, date, total_cases,Population, (total_cases/Population)*100 as PercentageAffected
from project1..CovidDeaths$
where location like '%India%'
order by 1,2

--Countries with highest Infection rate
select Location, Population, max(total_cases) as HighestInfectionCount, max(total_cases/Population)*100 as PercentagePopulationInfected
from project1..CovidDeaths$
group by location, Population
order by PercentagePopulationInfected desc

--continent wise deaths
select continent, max(cast(Total_deaths as int)) as TotalDeathCount
from project1..CovidDeaths$
where continent is not null
group by continent
order by TotalDeathCount desc

--location wise death count
select location, max(cast(Total_deaths as int)) as TotalDeathCount
from project1..CovidDeaths$
where continent is null
group by location
order by TotalDeathCount desc

--global numbers
select date, sum(new_cases) as Total_cases, sum(cast(new_deaths as int)) as Total_deaths, (sum(cast(new_deaths as int))/sum(new_cases))*100 as DeathPercentage
from project1..CovidDeaths$
where continent is  not null
group by date
order by 1, 2

--total count across the world
select sum(new_cases) as Total_cases, sum(cast(new_deaths as int)) as Total_deaths, (sum(cast(new_deaths as int))/sum(new_cases))*100 as DeathPercentage
from project1..CovidDeaths$
where continent is  not null
--group by date
order by 1, 2

select *
from project1..CovidDeaths$ dea
join project1..CovidVaccinations$ vac
on dea.location=vac.location
and dea.date=vac.date

--total population vs vaccination
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from project1..CovidDeaths$ dea
join project1..CovidVaccinations$ vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 2,3

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(cast(vac.new_vaccinations as int)) over (partition by dea.Location order by dea.location, dea.date) as RollingPeopleVaccinated
from project1..CovidDeaths$ dea
join project1..CovidVaccinations$ vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
order by 2,3

--using CTE
with popvac as
(select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(cast(vac.new_vaccinations as int)) over (partition by dea.Location order by dea.location, dea.date) as RollingPeopleVaccinated
from project1..CovidDeaths$ dea
join project1..CovidVaccinations$ vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)
select *, (RollingPeopleVaccinated/population)*100 from popvac

--temp table
Drop table if exists #percentPopulationVaccinated
create table #percentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)
insert into #percentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(cast(vac.new_vaccinations as int)) over (partition by dea.Location order by dea.location, dea.date) as RollingPeopleVaccinated
from project1..CovidDeaths$ dea
join project1..CovidVaccinations$ vac
on dea.location=vac.location
and dea.date=vac.date
--where dea.continent is not null
--order by 2,3
select *, (RollingPeopleVaccinated/population)*100 from  #percentPopulationVaccinated

--creating view for later visualization
create view percentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,sum(cast(vac.new_vaccinations as int)) over (partition by dea.Location order by dea.location, dea.date) as RollingPeopleVaccinated
from project1..CovidDeaths$ dea
join project1..CovidVaccinations$ vac
on dea.location=vac.location
and dea.date=vac.date
where dea.continent is not null

select *, (RollingPeopleVaccinated/population)*100 from  #percentPopulationVaccinated
