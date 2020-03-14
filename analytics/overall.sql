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
confirmed as confirmed,
recovered as recovered,
deaths as deaths
from csse.dailies
where file_date::date=(CURRENT_DATE-1)
--group by province_state,country_region
);

copy
(
select
sum(confirmed) as confirmed,
sum(recovered) as recovered,
sum(deaths) as deaths,
--(sum(deaths)::float/sum(least(2*recovered+deaths,confirmed))::float)::numeric(4,3) as mb0,
(sum(deaths)::float/sum(confirmed)::float)::numeric(4,3) as lb,
(sum(deaths)::float/sum(1.9*confirmed)::float)::numeric(4,3) as mb1,
(sum(deaths)::float/sum(1.9*(recovered+deaths))::float)::numeric(4,3) as mb2,
(sum(deaths)::float/sum(recovered+deaths)::float)::numeric(4,3) as ub
from data
) to '/tmp/overall.csv' csv header;

commit;

