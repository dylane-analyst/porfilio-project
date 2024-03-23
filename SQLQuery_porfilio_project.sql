SELECT *
FROM CovidDeaths
where continent is not null
order by 3,4

--ALTER TABLE CovidDeaths$
--RENAME TO CovidDeaths;



--SELECT *
--FROM CovidVaccinations
--order by 3,4

-- the data we are going to use

select location, date ,total_cases, new_cases,total_deaths, population
from CovidDeaths
order by 1,2

-- total cases vs total death 
-- shows the likellihood of dying if you contract covid in your country
select location,population ,date,total_cases,total_deaths, ( total_deaths/total_cases*100) as deaths_percentage
from CovidDeaths
where 
location like '%cameroon%' and continent is not null

order by 1,2

-- look at the total cases vs population in united states
select location,date,total_cases,population, ( total_cases/population)*100 as percentage_p_c
from CovidDeaths
--where location like '%states%'
order by 1,2

-- what countries have the highest  rate ofinfection compare to the population
select location,population,max(total_cases)as max_cases, max(( total_cases/population))*100 as higheat_infection
from CovidDeaths
group by location,population
--where location like '%states%'
order by higheat_infection desc

-- countries with highest deaths count per population
select location,max(cast(total_deaths as int)) as totaldeaths
from CovidDeaths
where continent is not null
group by location
order by totaldeaths desc

-- highest deaths by continent
select continent ,max(cast(total_deaths as int)) as totaldeaths
from CovidDeaths
where continent is not null
group by continent
order by totaldeaths desc

-- globlal number across the world per date
select date  , sum (new_cases)as total_cases,sum (cast(new_deaths as int)) as total_deaths,
(sum (cast(new_deaths as int))/ sum (new_cases))*100 as deathspercentage
from CovidDeaths
where continent is not null
group by date
order  by 1,2

-- global statist across the world
select sum (new_cases)as total_cases,sum (cast(new_deaths as int)) as total_deaths,
(sum (cast(new_deaths as int))/ sum (new_cases))*100 as deathspercentage
from CovidDeaths
where continent is not null

--alter table CovidVaccinations alter column new_vaccinations int
--looking for population vs vaccinations
select cde.date,cde.continent,cde.location,population,new_vaccinations , sum(new_vaccinations) over( partition by cde.location 
order by cde.date ,cde.location )as total_vaccinated
from CovidDeaths cde

join
CovidVaccinations cvac
on
cde.date=cvac.date and cde.location=cvac.location
where cde.continent is not null

--we will use cte so we can be able to use total_vaccinated
with population_vs_vaccination(date,continant,location,population,new_vaccination,total_vaccination) as
(

select cde.date,cde.continent,cde.location,population,new_vaccinations , sum(new_vaccinations) over( partition by cde.location 
order by cde.date ,cde.location )as total_vaccinated
from CovidDeaths cde

join
CovidVaccinations cvac
on
cde.date=cvac.date and cde.location=cvac.location
where cde.continent is not null
)
select *,(total_vaccination/population)*100 as po_vs_vacc
from population_vs_vaccination
-- creating view for visulize data 
drop view if exists population_vs_vaccination
 create view population_vs_vaccinated
 as 
select cde.date,cde.continent,cde.location,population,new_vaccinations , sum(new_vaccinations) over( partition by cde.location 
order by cde.date ,cde.location )as total_vaccinated
from CovidDeaths cde

join
CovidVaccinations cvac
on
cde.date=cvac.date and cde.location=cvac.location

select * from population_vs_vaccinated