create or replace function function_name(p_titul_id int) 
returns table(id uuid, parent_id uuid, lvl integer) 
language 'plpgsql' 
as $BODY$ 
begin
return query 
with recursive ReqSet(id, parent_id, lvl)  as(  
	select p.row_id as id, p.parent_row_id as parent_id, 0 as lvl
	from public.project_partitions p
	where p.titul_id = p_titul_id and p.parent_row_id is null
	union all
	select p.row_id, p.parent_row_id, r.Lvl + 1 
	from public.project_partitions p
	inner join ReqSet r on r.id = p.parent_row_id 
	where p.titul_id = p_titul_id 
)

select * from ReqSet r;
END
$BODY$;

explain analyze
select * from function_name('830f8d59-1e63-4196-b73b-5c8bc9367747' );

explain analyze
with recursive ReqSet(id, parent_id, lvl)  as(  
	select p.row_id as id, p.parent_row_id as parent_id, 0 as lvl
	from public.project_partitions p
	where p.contract_id = '830f8d59-1e63-4196-b73b-5c8bc9367747'  and p.parent_row_id is null
	union all
	select p.row_id, p.parent_row_id, r.Lvl + 1 
	from public.project_partitions p
	inner join ReqSet r on r.id = p.parent_row_id 
)

select * from ReqSet r;


create or replace function insert_log_trf(laction integer, lstatus integer, luser varchar(512), lpc varchar(512), lmessage text, llinked_partition uuid)
returns uuid
language plpgsql
as $$
declare
	query text;   
	id uuid;
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
	where child.relname='sending_log_' || to_char(now(), 'YYYY') and nmsp_parent.nspname = 'public';
    id := gen_random_uuid ();
	raise notice '%', sec_count;

	if sec_count = 0 then	
		low_range := to_char(date_trunc('year', now()), 'YYYY-MM-DD') ;
  	    high_range := to_char(date_trunc('year', now()) + interval '1 year', 'YYYY-MM-DD');
	
		query := format($que$
			CREATE TABLE "sending_log_%s"
	        PARTITION OF sending_log
	        FOR VALUES from ('%s') to ('%s');
	        $que$, to_char(now(), 'YYYY'), low_range, high_range);
	       raise notice '%',query;
		execute query;                          
	end if;
	
	insert into public.sending_log (id, "action", status, "user", pc,log_date,message, linked_partition) 
	values (id, laction, lstatus, luser, lpc, now(), lmessage, llinked_partition);
return id;
end;$$