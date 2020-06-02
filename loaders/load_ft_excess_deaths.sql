begin;

drop table if exists ft.excess_deaths;

create table if not exists ft.excess_deaths (
	country			text,
	region			text,
	period			text,
	year			integer,
	month			integer,
	week			integer,
	date			date,
	deaths			float,
	expected_deaths		float,
	excess_deaths		float,
	excess_deaths_pct	float
);

copy ft.excess_deaths from '/tmp/ft_excess_deaths.csv' with delimiter as ',' csv header quote as '"' NULL as 'NA';

commit;
