# Домашняя работа №11
# Репликация

# Подготовка
Разворачиваем 3 ВМ на yandex cloud.
Устанавливаем Postgres

![имг 00](IMG/0.png "Подготовка")

Сразу прописываем настройки для репликаций и доступа из под сети yandex и пользователя repluser

![имг 00](IMG/0_1.png "Подготовка")

Проверяем доступность серверов PG

![имг 00](IMG/0_2.png "Подготовка")

На всех ВМ создаем пользователя для репликаций, создаем БД для работы.

```
create role repluser WITH PASSWORD 'r4e3w2q1' LOGIN REPLICATION;
create database reptest;
```

# Основная работа

## На *vm2otus* создаем таблицы test для записи, test2 для запросов на чтение.

![имг 00](IMG/1.png "Подготовка")

![имг 00](IMG/1_1.png "Подготовка")

## Создаем публикацию таблицы test и подписываемся на публикацию таблицы test2 с *vm3otus*

```

-- переключаемся на логическую репликацию () необходим перезапуск кластера

alter system set wal_level = logical;
```
![имг 00](IMG/2.png "Подготовка")

Создаем публикацию для таблици test на *vm2otus*
```
CREATE PUBLICATION testpubvm2otus FOR TABLE test;
```

![имг 00](IMG/2_1.png "Подготовка")

![имг 00](IMG/2_2.png "Подготовка")

Создаем подписку на *vm3otus*
```

CREATE SUBSCRIPTION testpubvm3otus CONNECTION 'host=10.128.0.18 port=5432 user=repluser password=r4e3w2q1 dbname=reptest' PUBLICATION testpubvm3otus WITH (copy_data = true);
```

![имг 00](IMG/2_3.png "Подготовка")

При создании первой репликации была сделана опечатка, по этому в списке реплик 2.

## На vm3otus создаем таблицы test2 для записи, test для запросов на чтение.

![имг 00](IMG/3.png "Подготовка")

## Создаем публикацию таблицы test2 и подписываемся на публикацию таблицы test1 с vm2otus.

```
CREATE PUBLICATION testpub3_vm3 FOR TABLE test2;
```

![имг 00](IMG/4.png "Подготовка")

```
CREATE SUBSCRIPTION test_pubvm1 CONNECTION 'host=10.128.0.19 port=5432 user=repluser password=r4e3w2q1 dbname=reptest' PUBLICATION test_pubvm1 WITH (copy_data = true);
```
![имг 00](IMG/5.png "Подготовка")

## vm4 использовать как реплику для чтения и бэкапов (подписаться на таблицы из ВМ vm2otus и vm3otus ).

Создаем таблицы на vm4 и даем права нашему пользователю

![имг 00](IMG/6.png "Подготовка")

![имг 00](IMG/6_1.png "Подготовка")

Подписываемся на публикацию таблицы test с ВМ vm2otus и на на публикацию таблицы test2 с ВМ vm3otus

```
CREATE SUBSCRIPTION testpubvm3otus1 CONNECTION 'host=10.128.0.18 port=5432 user=repluser password=r4e3w2q1 dbname=reptest' PUBLICATION test_pubvm2otus WITH (copy_data = true);
CREATE SUBSCRIPTION test_pubvm111 CONNECTION 'host=10.128.0.19 port=5432 user=repluser password=r4e3w2q1 dbname=reptest' PUBLICATION testpub3_vm3 WITH (copy_data = true);
```

![имг 00](IMG/7.png "Подготовка")

# ДЗ сдается в виде миниотчета на гитхабе с описанием шагов и с какими проблемами столкнулись.

Основной проблемой стало неудобство работы с 3 ВМ в соседних окнах и постоянно возникающая путанница в связи с этим. 