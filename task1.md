# Подготовка

  Развернута виртуальная среда для лабораторных работ в системе виртуализации Oracle VM VirtualBox\

![Данные о системе SSH](IMG/00.png "Данные о системе SSH")

  Подключение по *ssh* осуществляется по средствам *putty*

1) В двух консолях открыто подключение к серверу PG. Установлен **AUTOCOMMIT** в **OFF**
Установлено подключение к лабораторной БД. Созданы таблицы.

![имг01](IMG/01.png "имг01")

> Посмотреть текущий уровень изоляции: show transaction isolation level

Текущий уровень **read commited**
 
> начать новую транзакцию в обоих сессиях с дефолтным (не меняя) уровнем изоляции<br>
> в первой сессии добавить новую запись insert into persons(first_name, second_name) values('sergey', 'sergeev');<br>
> сделать select * from persons во второй сессии<br>

![Первая проверка](IMG/02.png "Первая проверка")

Во второй сессии результат не содержит новой записи, т.к. при текущем уровне изоляции она будет добавлена только после **commit**

> завершить первую транзакцию - commit; <br>
> видите ли вы новую запись и если да то почему? <br>
> сделать select * from persons во второй сессии <br>

![Результат коммита](IMG/03.png "Результат коммита")

Теперь запись появилась, так-как транзакция приенена и запись теперь доступна для чтения как сохраненная

> начать новые но уже repeatable read транзации - set transaction isolation level repeatable read;<br>
> в первой сессии добавить новую запись insert into persons(first_name, second_name) values('sveta', 'svetova');<br>
> сделать select * from persons во второй сессии<br>
> видите ли вы новую запись и если да то почему?<br>

![repeatable read](IMG/04.png "repeatable read p1")

Новые записи отсутствуют - т.к. транзакция не завершена в сессии добавления данных.

![repeatable read](IMG/05.png "repeatable read p2")

*REPEATABLE READ* удерживает блокировки каждой затронутой строки до окончания транзакций, мы видим данные на момент открытия транзакции. 

![repeatable read](IMG/06.png "repeatable read p2")

Завершение транзакции в сессии чтения, и начало новой транзакции выводит уже обновленные данные


