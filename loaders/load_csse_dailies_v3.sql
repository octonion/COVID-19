begin;

drop table if exists csse.dailies;

create temporary table cd (
	fips			integer,
	admin2			text,
	province_state		text,
	country_region		text,
	last_update		timestamp,
	latitude		float,
	longitutde		float,
	confirmed		integer,
	deaths			integer,
	recovered		integer,
	active			integer,
	combined_key		text,
	incidence_rate		float,
	case_fatality_rate	float,
	file_name		text
);

copy cd from '/tmp/dailies.csv' with delimiter as ',' csv quote as '"';

create table if not exists csse.dailies (
	fips			integer,
	admin2			text,
	province_state		text,
	country_region		text,
	last_update		timestamp,
	latitude		float,
	longitutde		float,
	confirmed		integer,
	deaths			integer,
	recovered		integer,
	active			integer,
	combined_key		text,
	incidence_rate		float,
	case_fatality_rate	float,
	file_name		text,
	file_date		date
);
insert into csse.dailies
(
select
fips,admin2,
province_state,country_region,
last_update,
latitude,longitutde,
confirmed,deaths,recovered,active,
combined_key,
incidence_rate,
case_fatality_rate,
file_name,
split_part(reverse(split_part(reverse(file_name),'/',1)),'.',1)::date
from cd
);

commit;
