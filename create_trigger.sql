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