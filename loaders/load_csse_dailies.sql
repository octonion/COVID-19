begin;

drop table if exists csse.dailies;

create temporary table cd (
	province_state		text,
	country_region		text,
	last_update		timestamp,
	confirmed		integer,
	deaths			integer,
	recovered		integer,
	latitude		float,
	longitutde		float,
	file_name		text
);

copy cd from '/tmp/dailies.csv' with delimiter as ',' csv quote as '"';

create table if not exists csse.dailies (
	province_state		text,
	country_region		text,
	last_update		timestamp,
	confirmed		integer,
	deaths			integer,
	recovered		integer,
	latitude		float,
	longitutde		float,
	file_date		date
);
insert into csse.dailies
(
select
province_state,country_region,
last_update,
confirmed,deaths,recovered,
latitude,longitutde,
split_part(reverse(split_part(reverse(file_name),'/',1)),'.',1)::date
from cd
);


commit;
