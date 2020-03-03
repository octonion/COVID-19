begin;

create temporary table data (
       province_state		text,
       country_region		text,
       confirmed		integer,
       recovered		integer,
       deaths			integer
);

insert into data
(province_state,country_region,confirmed,recovered,deaths)
(
select
province_state,
country_region,
max(confirmed) as confirmed,
max(recovered) as recovered,
max(deaths) as deaths
from csse.dailies
group by province_state,country_region
);

select
country_region,
sum(confirmed) as confirmed,
sum(recovered) as recovered,
sum(deaths) as deaths,
(sum(deaths)::float/sum(confirmed)::float)::numeric(4,3) as lb,
(sum(deaths)::float/sum(least(2*recovered+deaths,confirmed))::float)::numeric(4,3) as mb,
(sum(deaths)::float/(sum(recovered)::float+sum(deaths)::float))::numeric(4,3) as ub
from data
group by country_region
having sum(deaths)+sum(recovered)>0
order by sum(confirmed) desc;

commit;

