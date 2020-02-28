select
country_region,
max(confirmed) as confirmed,
max(recovered) as recovered,
max(deaths) as deaths,
(max(deaths)::float/max(confirmed)::float)::numeric(4,3) as lb,
(max(deaths)::float/(max(2*recovered)::float+max(deaths)::float))::numeric(4,3) as mb,
(max(deaths)::float/(max(recovered)::float+max(deaths)::float))::numeric(4,3) as ub
from csse.dailies
group by country_region
having max(deaths)+max(recovered)>0
order by max(confirmed) desc;
