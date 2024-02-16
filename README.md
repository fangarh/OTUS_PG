# Итоговая работа 
# БД для системы согласования и передачи проектно-сметной документации.

## Описание
Разработать и спроектировать БД для системы согласования и передачи проектно-сметной документации. 
Система предназначена для хранения и передачи полной или частичной проектной документации между исполнитель и субподрядчиком,
так-же передачу проектной документации в Регулирующие органы и заказчику.

В рамках курсовой работы будет выполнены следующие части данной задачи:
* Выполнение настройки Postgres 15 с учетом предоставленного стэнда
* Проектирование архетектуры высоконагруженных таблиц (втч индексации, секционирование и построени table space)
* Построение репликаций (базовыми методами)
* Разработка хранимых функций для работы с данными таблицами
* Анализ результатов

# Подготовка
Развернут стенд для выполнения работы ( виртуальная машина развернута внутри инфраструктуры ):

ОС: Ubuntu 22.04
CPU: 8 Core
Ram: 16Gb
Storage 1: 256 Gb SSD
Storage 2: 128 Gb SSD

Установлен PG SQL 15.

# Основная работа
## Настройка postgres

Для настройки серверной части будет использован специализированный сервис, предоставляющий рекомендации по конфигурации *postgre*: https://pgconfigurator.cybertec.at/ <br/>
**Учитываем в настройках, что данные о передачи документации и саму документацию необходимо сохранять любой ценой.**

![имг 00](IMG/0.png "Подготовка")

Для анализа производительности проведем с помощью утиллиты *sysbench*: https://github.com/Percona-Lab/sysbench-tpcc
<br/>
Снимаем показания до настроек:<br/>
./tpcc.lua --pgsql-port=5432 --pgsql-user=postgres --pgsql-password=**** --pgsql-db=speedtest --time=60 --scale=10 --threads=2 --report-interval=1 --tables=1 --db-driver=pgsql prepare<br/>
./tpcc.lua --pgsql-port=5432 --pgsql-user=postgres --pgsql-password=ghbt[fkb --pgsql-db=speedtest --time=60 --scale=10 --threads=2 --report-interval=5 --tables=1 --db-driver=pgsql run<br/>

![имг 00](IMG/0_1_1.png "Подготовка")

В связи с необходимостью установки серверной части на стороне субподрядчиков и подрядчиков конфигурация *postgres* выполняется по средствам SQL скрипта.
```
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

SELECT pg_reload_conf();
```

Перезагружаем серверную часть и проверяем что ядро запустилось

![имг 00](IMG/0_1_2.png "Подготовка")

К сожалению имеем небольшие потери в производительности, за счет гарантии отсутствия потерь данных. 

## Проектирование БД.
	
	За основу проекта БД берутся текущие разработки внутри компании, так-же разработки компний смежников. <br/>
	В рамках данной итоговой работы будет представлена реализация таблиц и скриптов работы с ними отвечающих за историю передачи состава проекта,<br/>
таблицы для хранения состава проекта, минимальный необходимый набор справочников. <br/>
