select to_char(now(), 'YYYY');
select date_trunc('year', now()) ;
insert into public.partition_element_type (id, name) values (0, 'ЛО');
insert into public.partition_element_type (id, name) values (1, 'ПС');

insert into public.log_action (id, name) values (1, 'sending');
insert into public.log_status (id, name) values (1, 'compleated');

insert into public.sending_log (action, status,log_date,message) values (1,1,'2022-10-31','asdasdas');

create table sending_log_2024 PARTITION OF sending_log
	        FOR VALUES from ('2024-01-01') to ('2024-12-31');
	        
CREATE EXTENSION pg_partman;
CREATE EXTENSION pg_partman_bgw;