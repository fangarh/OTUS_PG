drop table if exists public.volume_files;
drop table if exists public.partition_volume;
drop table if exists public.project_partitions;
drop table if exists public.sending_log;
drop table if exists public.project_partitions_tree;
drop table if exists public.partition_element_type;
drop table if exists public.contracts;
drop table if exists public.titul;
drop table if exists public.sending_log;
drop table if exists public.log_status;
drop table if exists public.log_action;
drop sequence titul_seq ;
------- system ------------

create table public.partition_element_type(
	id integer primary key,
	name text
);

create table public.project_partitions_tree(
	id uuid default gen_random_uuid() primary key,
	parent_row_id uuid,
	name text,
	type_id integer,
	element_number varchar(16),
	element_code varchar(16),
	deleted boolean default(false)
); 

create sequence titul_seq as integer;

create table public.titul (
	id integer NOT NULL DEFAULT nextval('titul_seq') primary key,
	name text,
	storage_path text
);

create table public.contracts (
	id uuid default gen_random_uuid() primary key,
	titul_id int not null,
	number varchar(64),
	legal_number varchar(64),
	name text	
);

create table public.project_partitions(
	row_id uuid default gen_random_uuid(),
	parent_row_id uuid ,
	template_partition_id uuid not null,
	name text,
	partition_number varchar(16),	
	deleted boolean default(false),
	updated timestamptz default(CURRENT_TIMESTAMP),
	stage varchar(64),
	contract_id uuid,
	titul_id integer not null,
	primary key(row_id,  titul_id)
) partition by list(titul_id);


create table public.partition_volume(
	id uuid default gen_random_uuid() primary key,
	partition_id uuid,
	name text,
	deleted boolean default(false),
	number varchar(64)
	
);



create table public.volume_files(
	id uuid default gen_random_uuid() primary key,
	volume_id uuid,
	file_name varchar(512),
	deleted boolean default(false),
	storage_location varchar(1024)
);
--- log  ---


create table public.log_status (
	id integer primary key,
	name varchar(512) 
);

create table public.log_action (
	id integer primary key,
	name varchar(512)
);

create table public.sending_log (
	row_id uuid default gen_random_uuid() ,
	action integer,
	status integer,
	"user" varchar(512),
	pc varchar(512),
	message text,
	log_date timestamptz default (CURRENT_TIMESTAMP),
	linked_partition uuid ,
	primary key(row_id,  log_date)
)partition by range (log_date);

------ FK --------

/*
alter table public.partition_volume 
add constraint partition_volume_fk
foreign key(partition_id)
references public.project_partitions(row_id);
*/
alter table public.volume_files 
add constraint volume_files_fk
foreign key(volume_id)
references public.partition_volume(id);

alter table public.sending_log 
add constraint sending_log_status_fk
foreign key(status)
references public.log_status(id);

alter table public.sending_log 
add constraint sending_log_action_fk
foreign key(action)
references public.log_action(id);

alter table public.project_partitions_tree 
add constraint project_partitions_element_type_fk
foreign key (type_id) 
references public.partition_element_type(id);

alter table public.contracts 
drop constraint if exists contract_titul_fk;

alter table public.contracts 
add constraint contract_titul_fk
foreign key (titul_id) 
references public.titul(id);

alter table public.project_partitions 
drop constraint if exists pp_partition_tree_fk;

alter table public.project_partitions 
add constraint pp_partition_tree_fk
foreign key (template_partition_id) 
references public.project_partitions_tree(id);

alter table public.project_partitions 
drop constraint if exists pp_contract_fk;

alter table public.project_partitions 
add constraint pp_contract_fk
foreign key (contract_id) 
references public.contracts (id);

