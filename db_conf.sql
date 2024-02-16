--- connection ---
ALTER SYSTEM SET max_connections = 400;
ALTER SYSTEM SET superuser_reserved_connections = 6;
--- memory ---
ALTER SYSTEM SET shared_buffers = '4096 MB';
ALTER SYSTEM SET work_mem = '32 MB';
ALTER SYSTEM SET maintenance_work_mem = '320 MB';
ALTER SYSTEM SET huge_pages = off;
ALTER SYSTEM SET effective_cache_size = '11 GB';
ALTER SYSTEM SET effective_io_concurrency = 100;
ALTER SYSTEM SET random_page_cost = 1.25;

--- monitoring ---
ALTER SYSTEM SET shared_preload_libraries = 'pg_stat_statements';
ALTER SYSTEM SET track_io_timing=on;

--- replications ---
ALTER SYSTEM SET wal_level = replica;
ALTER SYSTEM SET max_wal_senders = 10;
ALTER SYSTEM SET synchronous_commit = on;

--- checkpoint ---
ALTER SYSTEM SET checkpoint_timeout  = '15 min';
ALTER SYSTEM SET checkpoint_completion_target = 0.9;
ALTER SYSTEM SET max_wal_size = '10240 MB';
ALTER SYSTEM SET min_wal_size = '5120 MB';

--- WAL writing
ALTER SYSTEM SET wal_compression = on;
ALTER SYSTEM SET wal_buffers = -1;
ALTER SYSTEM SET wal_writer_delay = '200ms';
ALTER SYSTEM SET wal_writer_flush_after = '1MB';
ALTER SYSTEM SET wal_keep_size = '22080 MB';

--- Background writer ---
ALTER SYSTEM SET bgwriter_delay = '200ms';
ALTER SYSTEM SET bgwriter_lru_maxpages = 100;
ALTER SYSTEM SET bgwriter_lru_multiplier = 2.0;
ALTER SYSTEM SET bgwriter_flush_after = 0;

--- parallel queries ---
ALTER SYSTEM SET max_worker_processes = 8;
ALTER SYSTEM SET max_parallel_workers_per_gather = 4;
ALTER SYSTEM SET max_parallel_maintenance_workers = 4;
ALTER SYSTEM SET max_parallel_workers = 8;
ALTER SYSTEM SET parallel_leader_participation = on;

--- additional features ---
ALTER SYSTEM SET enable_partitionwise_join = on;
ALTER SYSTEM SET enable_partitionwise_aggregate = on;
ALTER SYSTEM SET jit = on;
ALTER SYSTEM SET max_slot_wal_keep_size = '1000 MB';
ALTER SYSTEM SET track_wal_io_timing = on;
ALTER SYSTEM SET maintenance_io_concurrency = 100;
ALTER SYSTEM SET wal_recycle = on; 
ALTER SYSTEM SET synchronous_commit = off;