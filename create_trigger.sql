create or replace function insert_titul_trf()
returns trigger 
language plpgsql
as $$
declare
	query text;    
begin
	
	query := format($que$
		CREATE TABLE "project_partitions_%s"
        PARTITION OF project_partitions
        FOR VALUES IN ('%s');
        $que$, new.id, new.id);
	execute query;                          

	return new; 
end;

$$;

drop trigger if exists t_insert_titul on public.titul;

create trigger t_insert_titul after insert on public.titul 
for each row 
execute procedure insert_titul_trf();

------------------------ LOG 
create or replace function insert_log_trf()
returns trigger 
language plpgsql
as $$
declare
	query text;   
	sec_count integer;
    low_range varchar(16);
    high_range varchar(16);
begin
	select  count(*)
	into strict sec_count
	from pg_inherits
	inner join pg_class parent            on pg_inherits.inhparent = parent.oid
	inner join pg_class child             on pg_inherits.inhrelid   = child.oid
	inner join pg_namespace nmsp_parent   on nmsp_parent.oid  = parent.relnamespace
	where child.relname='sending_log_' || to_char(new.log_date, 'YYYY') and nmsp_parent.nspname = 'public';

raise notice '%', sec_count;

	if sec_count = 0 then	
		low_range := to_char(date_trunc('year', new.log_date), 'YYYY-MM-DD') ;
  	    high_range := to_char(date_trunc('year', new.log_date) + interval '1 year', 'YYYY-MM-DD');
	
		query := format($que$
			CREATE TABLE "sending_log_%s"
	        PARTITION OF sending_log
	        FOR VALUES from ('%s') to ('%s');
	        $que$, to_char(new.log_date, 'YYYY'), low_range, high_range);
	       raise notice '%',query;
		execute query;                          
	end if;
	
	return new; 
end;

$$;

drop trigger if exists t_insert_log on public.sending_log;

create trigger t_insert_log before insert on public.sending_log 
for each row 
 WHEN (pg_trigger_depth() < 1)
   EXECUTE FUNCTION insert_log_trf();