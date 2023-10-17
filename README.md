# Домашняя работа №


# Подготовка

В качестве подготовки к домашней работе создано 2 виртуальных машины и один дополнительный виртуальный диск.

![имг 00](IMG/0.png "Подготовка")


На первую машину установлен posgres 15 и примонтирован новый hdd. Пока без файлов

![имг 01](IMG/1.png "Подготовка")

В базе данных созданы таблицы с тестовым наполнением

![имг 02](IMG/2.png "Подготовка")

> остановите postgres например через sudo -u postgres pg_ctlcluster 15 main stop
> сделайте пользователя postgres владельцем /mnt/data - chown -R postgres:postgres /mnt/data/
> перенесите содержимое /var/lib/postgres/15 в /mnt/data - mv /var/lib/postgresql/15 /mnt/data

Проведены необходимые операции.

![имг 03](IMG/3.png "первая часть")

> попытайтесь запустить кластер - sudo -u postgres pg_ctlcluster 15 main start <br>
> напишите получилось или нет и почему<br>
> задание: найти конфигурационный параметр в файлах раположенных в /etc/postgresql/15/main который надо поменять и поменяйте его<br>
> напишите что и почему поменяли <br>

Кластер не стартуется.

![имг 04](IMG/4.png "первая часть")

Причина по каторой не произошел запуск кластера : мы перенесли на внешний HDD файлы тэблспэйсов и данные системных таблиц. 
Серверная часть не смогла их найти и поэтому не стартуется.

В конфигурации сервера **postgres.conf** есть специальный раздел, в котором прописываются пути.
Для решения нашей проблемы надо исправить параметр: **data_directory** 

![имг 05](IMG/5.png "первая часть")

Внеся изменения в нем, на новый путь мы решим проблему мешавшую стартовать серверу. 

![имг 06](IMG/6.png "первая часть")

> попытайтесь запустить кластер - sudo -u postgres pg_ctlcluster 15 main start<br>
> напишите получилось или нет и почему<br>
> зайдите через через psql и проверьте содержимое ранее созданной таблицы<br>

Учитывая внесенные изменения, после перезагрузки серверной части,<br> postgres 
должен обратиться к файлам данных по новому пути и запуститься

![имг 07](IMG/7.png "первая часть")

Проверяем на соответствие данных:

![имг 08](IMG/8.png "первая часть")

> задание со звездочкой *: не удаляя существующий инстанс ВМ сделайте новый, поставьте на его PostgreSQL, удалите файлы с данными из /var/lib/postgres, <br>
> перемонтируйте внешний диск который сделали ранее от первой виртуальной машины ко второй и запустите PostgreSQL на второй машине так чтобы он работал <br>
> с данными на внешнем диске, расскажите как вы это сделали и что в итоге получилось. <br>

На второй виртуальной машине развернут чистый кластер 16 версии. Примонтированных дисков нет. Устанавливаем 15 версию.

![имг 91](IMG/9_1.png "вторая часть")

Добавляем HDD к виртуалке и устанавливаем его в системе. Аналогично предыдущей виртуальной машине. (пропуская форматирование)

![имг 92](IMG/9_2.png "вторая часть")

Прописываем автоматическое монтирование диска при старте системе в конфигах **fstab**

![имг 93](IMG/9_3.png "вторая часть")

После перезагрузки

![имг 94](IMG/9_4.png "вторая часть")

Останавливаем кластер и переписываем пути в конфиге

![имг 95](IMG/9_5.png "вторая часть")

Перезапускаем кластер и смотрим результат

![имг 95](IMG/9_6.png "вторая часть")

Кластер запустился без ошибок. Появились таблицы созданные на другой виртуальной машине вместе с исходными данными.

## Вывод

Учитывая что для хранения всех данных используется ссылка на подмонтированный внешний диск, мы получаем возможность получать доступ к базам данных с различных серверов, изменяя только одну настройку PG. (П.С. в контексте ДЗ пристально не рассматриваются манипуляции с Linux и Хостами ВМ )
