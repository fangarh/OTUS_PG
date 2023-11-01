# Домашняя работа № 5


# Подготовка
Созданна виртуальная машина:
![имг 00](IMG/0.png "Подготовка")

*Виртуальный жесткий диск и все что качается виртуальной машины расположено на внешнем SSD - что может отражаться на скорости*

# Основная работа

> Создать инстанс ВМ с 2 ядрами и 4 Гб ОЗУ и SSD 10GB<br>
> Установить на него PostgreSQL 15 с дефолтными настройками<br>
> Создать БД для тестов<br>

![имг 00](IMG/1.png "Подготовка")

> выполнить pgbench -i postgres

![имг 00](IMG/2_1.png "Подготовка")

> Запустить pgbench -c8 -P 6 -T 60 -U postgres postgres

![имг 00](IMG/2_2.png "Подготовка")

> Применить параметры настройки PostgreSQL из прикрепленного к материалам занятия файла

![имг 00](IMG/3.png "Подготовка")

Параметры применены. Кластер перезапущен.

> Протестировать заново<br>
> Что изменилось и почему?<br>

    Были изменены параметры работы сервера и его оптимизации. Учитывая что на сервер нет нагрузки и в нем только тестовая 
БД некоторые параметры, например ***_wal_size заставляют производить работы в холостую с большими WAL.
*см. ветка config*


>  Создать таблицу с текстовым полем и заполнить случайными или сгенерированными данным в размере 1млн строк <br>
>  Посмотреть размер файла с таблицей<br>
>  5 раз обновить все строчки и добавить к каждой строчке любой символ<br>
>  Посмотреть количество мертвых строчек в таблице и когда последний раз приходил автовакуум<br>

Операции выполнены

![имг 00](IMG/4.png "Подготовка")

![имг 00](IMG/4_1.png "Подготовка")

![имг 00](IMG/4_2.png "Подготовка")

На последнем изображении процесс был повторен т.к. автовакуум успел пройти раньше формирования запроса.

>  Подождать некоторое время, проверяя, пришел ли автовакуум<br>
>  5 раз обновить все строчки и добавить к каждой строчке любой символ<br>
>  Посмотреть размер файла с таблицей<br>

![имг 00](IMG/5_1.png "Подготовка")

> Отключить Автовакуум на конкретной таблице<br>
> 10 раз обновить все строчки и добавить к каждой строчке любой символ<br>
> Посмотреть размер файла с таблицей<br>
> Объясните полученный результат<br>
> Не забудьте включить автовакуум)<br>

![имг 00](IMG/5_2.png "Подготовка")

Размер увеличился. В отличае от *vacuum full a;* автовакуум не производит дефрагментацию файла с хронящимися данными. <br>
Это необходимо делать в ручную т.к. операция очень трудозатратна и блокирует базу на долгий период.

# Задача со звёздочкой

> Задание со *:<br>
> Написать анонимную процедуру, в которой в цикле 10 раз обновятся все строчки в искомой таблице.<br>
> Не забыть вывести номер шага цикла.<br>

![имг 00](IMG/6_1.png "Подготовка")

Для удобства была создана хранимая процедура, в отличае от анонимной в заголовке прописывается имя и параметры вместо *DO$$ ... DO*

![имг 00](IMG/6_2.png "Подготовка")

Эксперемент повторен, правда вывести до отрабатывания авто-вакуума не успел.