# Домашняя работа №9
# Нагрузочное тестирование и тюнинг PostgreSQL
# Подготовка

> развернуть виртуальную машину любым удобным способом <br>
> поставить на неё PostgreSQL 15 любым способом<br>
> настроить кластер PostgreSQL 15 на максимальную производительность не обращая внимание на возможные проблемы с надежностью в случае аварийной перезагрузки виртуальной машины<br>

* Развернута виртуальная машина VirtualBox
* Параметры: HDD(50ГБ), 8GB Ram, 1 core, 100% usage
* Установлен PG 15

![имг 00](IMG/0.png "Подготовка")<br>
![имг 00](IMG/0_1.png "Подготовка")<br>

# Основная работа
> нагрузить кластер через утилиту через утилиту pgbench (https://postgrespro.ru/docs/postgrespro/14/pgbench)<br>

* Изначальная конфигурация:<br>
* pgbench -c30 -P 6 -T 60  -h localhost -U postgres speedtest<br><br>

![имг 00](IMG/0_2.png "Подготовка")<br>

> написать какого значения tps удалось достичь, показать какие параметры в какие значения устанавливали и почему<br>

* Изменены параметры памяти:<br>
shared_buffers = 2GB<br>
work_mem = 32MB<br>
maintenance_work_mem = 410MB<br>
effective_cache_size = 6GB<br>
<br>

* Изменены параметры репликаций<br>
max_wal_senders = 0<br>
<br>

* Контрольные точки<br>
checkpoint_completion_target = 0.9<br>
random_page_cost = 4<br>
max_wal_size = 2GB<br>
min_wal_size = 1GB<br>

![имг 00](IMG/1_1.png "Подготовка")<br>
Внесенные изменения глобальных улучшений не дали. Тесты показали что улучшение производительности 1% дали параметры контрольной точки.<br>
<br>

* Параметры использования ядер процессора<br>
max_worker_processes = 8<br>
max_parallel_workers_per_gather = 2<br>
max_parallel_workers = 8<br>

![имг 00](IMG/1_2.png "Подготовка")<br>

<br>
Судя по итогам тестов - все упирается в HDD. Для ускорение сделаем запись WAL в асинхронном режиме.<br>
synchronous_commit = off<br>
Как видно результат прирост производительности в 2 раза. <br>
<br>

![имг 00](IMG/2_1.png "Подготовка")
<br>
<br>
Так же имеет смысл попробовать отключить принудительную запись изменений на диск fsync, что грозит потерей данных в случае сбоя.<br>
fsync = off;<br>
<br>



![имг 21](IMG/2_2.png "Подготовка") <br>

<br>
Но в итоге параметр возвращен, так-как прирост менее 1%<br>
<br>

# Задача со звёздочкой<br>
<br>
> Задание со *: аналогично протестировать через утилиту https://github.com/Percona-Lab/sysbench-tpcc <br>
>  (требует установки https://github.com/akopytov/sysbench)<br>
<br>
Устанавливает sysbench:<br>
<br>

* curl -s https://packagecloud.io/install/repositories/akopytov/sysbench/script.deb.sh | sudo bash<br>
* sudo apt -y install sysbench<br>
* git clone https://github.com/Percona-Lab/sysbench-tpcc && cd sysbench-tpcc<br>
<br>

![имг 00](IMG/3_1.png "Подготовка")<br>
<br>

* Подготавливаем БД и запуск теста<br>
./tpcc.lua --pgsql-port=5433 --pgsql-user=postgres --pgsql-password=**** --pgsql-db=speedtest --time=60 --scale=10 --threads=2 --report-interval=1  --tables=1 --db-driver=pgsql prepare<br>
./tpcc.lua --pgsql-port=5433 --pgsql-user=postgres --pgsql-password=**** --pgsql-db=speedtest --time=60 --scale=10 --threads=2 --report-interval=5  --tables=1 --db-driver=pgsql run<br>
<br>

![имг 00](IMG/3_2.png "Подготовка")<br>
![имг 00](IMG/3_3.png "Подготовка")<br>


* Запускаем тест на новом кластере<br>
./tpcc.lua --pgsql-port=5433 --pgsql-user=postgres --pgsql-password=**** --pgsql-db=speedtest --time=60 --scale=10 --threads=2 --report-interval=1  --tables=1 --db-driver=pgsql prepare<br>
./tpcc.lua --pgsql-port=5433 --pgsql-user=postgres --pgsql-password=**** --pgsql-db=speedtest --time=60 --scale=10 --threads=2 --report-interval=5  --tables=1 --db-driver=pgsql run<br>

![имг 00](IMG/4_1.png "Подготовка")<br>
![имг 00](IMG/4_2.png "Подготовка")<br>