begin;

drop table if exists csse.dailies;

create table csse.dailies (
	province_state		text,
	country_regiion		text,
	last_update		timestamp,
	confirmed		integer,
	deaths			integer,
	recovered		integer
);

copy csse.dailies from '/tmp/dailies.csv' with delimiter as ',' csv quote as '"';

commit;
