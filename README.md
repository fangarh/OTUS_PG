# Домашняя работа № 13
# Тема : Сбор и использование статистики 

# Подготовка
Для выполнения работы используется тестовая БД [взятая отсюда](https://edu.postgrespro.ru/bookings.pdf) <br/>
Развернута БД из бэкапа demo_big <br/>
## Структура таблиц <br/>
![имг 00](IMG/0.png "Подготовка")

# Основная работа

## Реализовать прямое соединение двух или более таблиц
 Прямое внутреннее соединение - JOIN, или INNER JOIN, позволяет получить содержимое, имеющееся одновременно в обеих таблицах

Получаем список всех Дмитриев летящих в данный момент, с информацией о борте и типе места

```
select 
	t.passenger_name ФИО, json_extract_path_text(t.contact_data::json, 'phone') || ' now unavaliable' Телефон,
	tf.fare_conditions Класс , f.actual_departure Отправился, f.flight_no, a.model || ' <' ||   a.aircraft_code  || '>'
from flights f 
inner join aircrafts a on f.aircraft_code  = a.aircraft_code 
inner join ticket_flights tf on tf.flight_id = f.flight_id 
inner join tickets t on t.ticket_no = tf.ticket_no 
where t.passenger_name like 'DMI%' and f.status = 'Departed' 
order by f.flight_no, t.passenger_name ;
```

![имг 01](IMG/1.png "")

## Реализовать левостороннее (или правостороннее) соединение двух или более таблиц
 Левостороннее внешнее соединение - LEFT(RIGHT) JOIN, либо LEFT(RIGHT) OUTER JOIN, позволяет получить содержимое присутствующее как одновременно и в левой и в правой таблице,<br/> 
 так и присутствующее в левой(правой) и при этом отсутствующее в правой(левой) соответственно.

Получаем рейсы самолетов средней дальности 5000-6000 км, с указанием места вылета и возврата

```
select a.model, ad."range", f.scheduled_departure,
       f.scheduled_arrival, vap0.city "city from", vap0.airport_name "airpot from", 
       vap1.city "city to", vap1.airport_name "airpot to"
  from aircrafts a
 inner join aircrafts_data ad on ad.aircraft_code = a.aircraft_code
 left join flights f on a.aircraft_code = f.aircraft_code
 left join airports_data ap0 on f.departure_airport  = ap0.airport_code
 left join airports vap0 on ap0.airport_code = vap0.airport_code  
 left join airports_data ap1 on f.arrival_airport = ap1.airport_code
 left join airports vap1 on ap1.airport_code = vap1.airport_code
 where ad."range"  > 5000  and ad."range" < 6000
 order by a.model, f.scheduled_departure
 limit 20
```

![имг 01](IMG/2.png "")

## Реализовать кросс соединение двух или более таблиц

Кросс или декартово соединение CROSS JOIN будет объединять каждую строку первой выборки с каждой строкой второй выборки или таблицы

Получаем все варианты самолетов вместе со всеми аэропортами

```
select ac.model, ac."range", ap.airport_name
from aircrafts ac 
cross join airports ap  
limit 20
```

![имг 01](IMG/3.png "")

## Реализовать полное соединение двух или более таблиц
Полное соединение FULL (OUTER) JOIN возвращает совпадающие записи или NULL - как обозначение отсутсвия совпадения

Получаем самолеты, какие и в какие дни они летали

```
select a.model, a."range", to_char(f.scheduled_departure,'DAY') as Year
from flights f
full join aircrafts a on f.aircraft_code = a.aircraft_code
group by 1, 2, 3 
limit 20
```

![имг 01](IMG/4.png "")


## Реализовать запрос, в котором будут использованы разные типы соединений

Повторим запрос из пункта с левыми соединениями, изменив например параметр поиска

Получаем рейсы самолетов средней дальности 1000-5000 км, с указанием места вылета и возврата

```
select a.model, ad."range", f.scheduled_departure,
       f.scheduled_arrival, vap0.city "city from", vap0.airport_name "airpot from", 
       vap1.city "city to", vap1.airport_name "airpot to"
  from aircrafts a
 inner join aircrafts_data ad on ad.aircraft_code = a.aircraft_code
 left join flights f on a.aircraft_code = f.aircraft_code
 left join airports_data ap0 on f.departure_airport  = ap0.airport_code
 left join airports vap0 on ap0.airport_code = vap0.airport_code  
 left join airports_data ap1 on f.arrival_airport = ap1.airport_code
 left join airports vap1 on ap1.airport_code = vap1.airport_code
 where ad."range"  > 1000  and ad."range" < 5000
 order by a.model, f.scheduled_departure
 limit 20
```

>
>
>