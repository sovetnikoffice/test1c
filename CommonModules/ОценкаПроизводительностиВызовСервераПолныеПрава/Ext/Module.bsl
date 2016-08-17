﻿////////////////////////////////////////////////////////////////////////////////
//  Методы, связанные с записью на сервере результатов замеров времени выполнения 
//  ключевых операций и их дальнейшем экспортом.
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Функция определяет необходимость выполнения замеров.
//
// Возвращаемое значение:
//  Булево - Истина выполнять, Ложь не выполнять.
//
Функция ВыполнятьЗамерыПроизводительности() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Возврат Константы.ВыполнятьЗамерыПроизводительности.Получить();
	
КонецФункции

// Процедура включает/выключает замеры производительности
//
Процедура ВключитьЗамерыПроизводительности(Параметр) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Константы.ВыполнятьЗамерыПроизводительности.Установить(Параметр);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
// Процедура записи массива замеров.
//
// Параметры:
//  Замеры - Массив элементов типа Структура.
//
// Возвращаемое значение:
// 	Число - текущее значение периода записи замеров на сервере в секундах в случае записи замеров.
//	Неопределено - в случае невозможности записи замеров в монопольном режиме.
//
Функция ЗафиксироватьДлительностьКлючевыхОпераций(Замеры) Экспорт
	
	Если МонопольныйРежим() Тогда
		Возврат Неопределено;
	КонецЕсли;
		
	Для Каждого КлючеваяОперацияЗамер Из Замеры Цикл
			КлючеваяОперацияСсылка = КлючеваяОперацияЗамер.Ключ;
			Буфер = КлючеваяОперацияЗамер.Значение;
			Для Каждого ДатаДанные Из Буфер Цикл
				Данные = ДатаДанные.Значение;
				Длительность = Данные.Получить("Длительность");
				Если Длительность = Неопределено Тогда
					// Неоконченный замер, писать его пока рано
					Продолжить;
				КонецЕсли;
				ЗафиксироватьДлительностьКлючевойОперации(
				КлючеваяОперацияСсылка,
				Длительность,
				Данные["ДатаНачала"],
				Данные["ДатаОкончания"],
				Данные["Комментарий"],
				Данные["Технологический"]);
			КонецЦикла;
		КонецЦикла;
		
	Возврат ПериодЗаписи();
		
КонецФункции

// Текущее значение периода записи результатов замеров на сервере
//
// Возвращаемое значение:
// Число - значение в секундах. 
Функция ПериодЗаписи() Экспорт
	ТекущийПериод = Константы.ОценкаПроизводительностиПериодЗаписи.Получить();
	Возврат ?(ТекущийПериод >= 1, ТекущийПериод, 60);
КонецФункции

// Процедура обработки регламентного задания по выгрузке данных
//
// Параметры:
//  КаталогиЭкспорта - Структура со значением типа Массив.
//
Процедура ЭкспортОценкиПроизводительности(КаталогиЭкспорта) Экспорт
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.ЭкспортОценкиПроизводительности);
	
	// Если система отключена, то выгрузку данных делать не будем.
	Если Не ОценкаПроизводительностиВызовСервераПовтИсп.ВыполнятьЗамерыПроизводительности() Тогда
	    Возврат;	
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	МАКСИМУМ(Замеры.ДатаЗаписи) КАК ДатаЗамера
	|ИЗ 
	|	РегистрСведений.ЗамерыВремени КАК Замеры";
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() И Выборка.ДатаЗамера <> Null Тогда
		ВерхняяГраньДатыЗамеров = Выборка.ДатаЗамера;
	Иначе 
		Возврат;	
	КонецЕсли;

	МассивыЗамеров = ЗамерыСРазделениемПоКлючевымОперациям(ВерхняяГраньДатыЗамеров);
	ВыгрузитьРезультаты(КаталогиЭкспорта, МассивыЗамеров);
	
КонецПроцедуры

// Текущая дата на сервере
//
// Возвращаемое значение:
// Дата - Дата и время на сервере в формате UTC.
Функция ДатаИВремяНаСервере() Экспорт
	Возврат Дата(1,1,1) + ТекущаяУниверсальнаяДатаВМиллисекундах()/1000;
КонецФункции

// Функция создает новый элемент справочника "Ключевые операции".
//
// Параметры:
//  ИмяКлючевойОперации - Строка - название ключевой операции
//
// Возвращаемое значение:
//	СправочникСсылка.КлючевыеОперации
//
Функция СоздатьКлючевуюОперацию(ИмяКлючевойОперации, ЦелевоеВремя = 1) Экспорт
	
	НачатьТранзакцию();
	
	Попытка
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("Справочник.КлючевыеОперации");
		ЭлементБлокировки.УстановитьЗначение("Имя", ИмяКлючевойОперации);
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		Блокировка.Заблокировать();
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
		               |	КлючевыеОперации.Ссылка КАК Ссылка
		               |ИЗ
		               |	Справочник.КлючевыеОперации КАК КлючевыеОперации
		               |ГДЕ
		               |	КлючевыеОперации.ИмяХеш = &ИмяХеш
		               |
		               |УПОРЯДОЧИТЬ ПО
		               |	Ссылка";
		
		ХешMD5 = Новый ХешированиеДанных(ХешФункция.MD5);
		ХешMD5.Добавить(ИмяКлючевойОперации);
		ИмяХеш = ХешMD5.ХешСумма;
		ИмяХеш = СтрЗаменить(Строка(ИмяХеш), " ", "");			   
					   
		Запрос.УстановитьПараметр("ИмяХеш", ИмяХеш);
		РезультатЗапроса = Запрос.Выполнить();
		Если РезультатЗапроса.Пустой() Тогда
			Наименование = РазложитьСтрокуПоСловам(ИмяКлючевойОперации);
			
			НовыйЭлемент = Справочники.КлючевыеОперации.СоздатьЭлемент();
			НовыйЭлемент.Имя = ИмяКлючевойОперации;
			НовыйЭлемент.Наименование = Наименование;
			НовыйЭлемент.ЦелевоеВремя = ЦелевоеВремя;
			НовыйЭлемент.Записать();
			КлючеваяОперацияСсылка = НовыйЭлемент.Ссылка;
		Иначе
			Выборка = РезультатЗапроса.Выбрать();
			Выборка.Следующий();
			КлючеваяОперацияСсылка = Выборка.Ссылка;
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Возврат КлючеваяОперацияСсылка;
	
КонецФункции

// Процедура записи единичного замера
//
// Параметры:
//  КлючеваяОперация - СправочникСсылка.КлючевыеОперации - ключевая операция
//						либо Строка - название ключевой операции
//  Длительность - Число
//  ДатаНачалаКлючевойОперации - Дата
Процедура ЗафиксироватьДлительностьКлючевойОперации(
	КлючеваяОперация, 
	Длительность, 
	ДатаНачалаКлючевойОперации,
	ДатаОкончанияКлючевойОперации = Неопределено,
	Комментарий = Неопределено,
	Технологический = Ложь) Экспорт
	
	Если БезопасныйРежим() <> Ложь Тогда
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Работа подсистемы оценка производительности в безопасном режиме не поддерживается'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Информация,,,Строка(КлючеваяОперация));
			
		Возврат;
	КонецЕсли;
		
	Если ТипЗнч(КлючеваяОперация) = Тип("Строка") Тогда
		КлючеваяОперацияСсылка = ОценкаПроизводительностиВызовСервераПовтИсп.ПолучитьКлючевуюОперациюПоИмени(КлючеваяОперация);
	Иначе
		КлючеваяОперацияСсылка = КлючеваяОперация;
	КонецЕсли;
	
	Если Комментарий = Неопределено Тогда
		Комментарий = ПараметрыСеанса.КомментарийЗамераВремени;
	КонецЕсли;
	
	Если НЕ Технологический Тогда
		Запись = РегистрыСведений.ЗамерыВремени.СоздатьМенеджерЗаписи();
	Иначе
		Запись = РегистрыСведений.ЗамерыВремениТехнологические.СоздатьМенеджерЗаписи();
	КонецЕсли;
	
	Запись.КлючеваяОперация = КлючеваяОперацияСсылка;
	
	// Получаем дату в UTC
	Запись.ДатаНачалаЗамера = Дата(1,1,1) + ДатаНачалаКлючевойОперации;
	Запись.НомерСеанса = НомерСеансаИнформационнойБазы();
	
	Запись.ВремяВыполнения = ?(Длительность = 0, 0.001, Длительность); // Длительность меньше разрешения таймера
	
	Запись.ДатаЗаписи = Дата(1,1,1) + ТекущаяУниверсальнаяДатаВМиллисекундах()/1000;
	Если ДатаОкончанияКлючевойОперации <> Неопределено Тогда
		// Получаем дату в UTC
		Запись.ДатаОкончания = Дата(1,1,1) + ДатаОкончанияКлючевойОперации;
	КонецЕсли;
	Запись.Пользователь = ПользователиИнформационнойБазы.ТекущийПользователь();
	Запись.ДатаЗаписиЛокальная = ТекущаяДатаСеанса();
	Запись.Комментарий = Комментарий;
	
	Запись.Записать();
	
КонецПроцедуры

// Функция преобразования ДатыЗамеры
//
// Параметры:
//  ДатаЗамера -	Дата
//					либо Число - результат ТекущаяУниверсальнаяДатаВМиллисекундах()
Функция ДатаПоТипуЗамера(ДатаЗамера)
	Если ТипЗнч(ДатаЗамера) = Тип("Число") Тогда
		ДатаЗамера = Дата("00010101") + ДатаЗамера / 1000;
	КонецЕсли;
	
	Возврат ДатаЗамера;
КонецФункции

// Регламентное задание экспорта
Функция ЗамерыСРазделениемПоКлючевымОперациям(ВерхняяГраньДатыЗамеров)
	Запрос = Новый Запрос;
	
	УровниПроизводительностиЧисло = Новый Соответствие;
	УровниПроизводительностиЧисло.Вставить(Перечисления.УровниПроизводительности.Идеально, 1);
	УровниПроизводительностиЧисло.Вставить(Перечисления.УровниПроизводительности.Отлично, 0.94);
	УровниПроизводительностиЧисло.Вставить(Перечисления.УровниПроизводительности.Хорошо, 0.85);
	УровниПроизводительностиЧисло.Вставить(Перечисления.УровниПроизводительности.Удовлетворительно, 0.70);
	УровниПроизводительностиЧисло.Вставить(Перечисления.УровниПроизводительности.Плохо, 0.50);
	
	ДатаПоследнейВыгрузки = Константы.ДатаПоследнейВыгрузкиЗамеровПроизводительностиUTC.Получить();
	Константы.ДатаПоследнейВыгрузкиЗамеровПроизводительностиUTC.Установить(ВерхняяГраньДатыЗамеров);
	УсловиеВсе = Константы.ОценкаПроизводительностиЭкспортВсехКлючевыхОпераций.Получить();
	
	Запрос.УстановитьПараметр("ДатаПоследнейВыгрузки", ДатаПоследнейВыгрузки);	
	Запрос.УстановитьПараметр("ВерхняяГраньДатыЗамеров", ВерхняяГраньДатыЗамеров);	
	
	ТекстЗапроса = "
	|ВЫБРАТЬ
	|	Замеры.КлючеваяОперация КАК КлючеваяОперация,
	|	Замеры.ДатаНачалаЗамера КАК ДатаНачалаЗамера,
	|	Замеры.ВремяВыполнения КАК ВремяВыполнения,
	|	Замеры.Пользователь КАК Пользователь,
	|	Замеры.ДатаЗаписи КАК ДатаЗаписи,
	|	Замеры.НомерСеанса КАК НомерСеанса,
	|	Замеры.Комментарий КАК Комментарий, 
	|	КлючевыеОперации.Наименование КАК КлючеваяОперацияСтрока,
	|	КлючевыеОперации.Приоритет КАК КлючеваяОперацияПриоритет,
	|	КлючевыеОперации.ЦелевоеВремя КАК КлючеваяОперацияЦелевоеВремя,
	|	КлючевыеОперации.МинимальноДопустимыйУровень КАК МинимальноДопустимыйУровень
	|ИЗ
	|	РегистрСведений.ЗамерыВремени КАК Замеры
	|ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|	Справочник.КлючевыеОперации КАК КлючевыеОперации
	|ПО
	|	КлючевыеОперации.Ссылка = Замеры.КлючеваяОперация
	|	%УсловиеВсе
	|ГДЕ
	|	Замеры.ДатаЗаписи > &ДатаПоследнейВыгрузки
	|	И Замеры.ДатаЗаписи <= &ВерхняяГраньДатыЗамеров
	|УПОРЯДОЧИТЬ ПО
	|	Замеры.КлючеваяОперация
	|";
	
	Если УсловиеВсе Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%УсловиеВсе", "");
	Иначе
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "%УсловиеВсе", "И (КлючевыеОперации.Приоритет <> 0 И КлючевыеОперации.ЦелевоеВремя <> 0)");
	КонецЕсли;
	
	
	Запрос.Текст = ТекстЗапроса;
	Результат = Запрос.Выполнить();
	
	ЗамерыСРазделением = Новый Соответствие;
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		КлючеваяОперация = ЗамерыСРазделением.Получить(Выборка.КлючеваяОперация);
		Если КлючеваяОперация = Неопределено Тогда
			КлючеваяОперация = Новый Соответствие;
			КлючеваяОперация.Вставить("uid", Строка(Выборка.КлючеваяОперация.УникальныйИдентификатор()));
			КлючеваяОперация.Вставить("name", Выборка.КлючеваяОперацияСтрока);
			КлючеваяОперация.Вставить("priority", Выборка.КлючеваяОперацияПриоритет);
			КлючеваяОперация.Вставить("targetValue", Выборка.КлючеваяОперация.ЦелевоеВремя);
			КлючеваяОперация.Вставить("minimalApdexValue", УровниПроизводительностиЧисло[Выборка.КлючеваяОперация.МинимальноДопустимыйУровень]);
			КлючеваяОперация.Вставить("Замеры", Новый Массив);
			
			ЗамерыСРазделением.Вставить(Выборка.КлючеваяОперация, КлючеваяОперация);
		КонецЕсли;
		
		КлючеваяОперацияЗамеры = КлючеваяОперация.Получить("Замеры");
		
		ЗамерСтруктура = Новый Структура;
		ЗамерСтруктура.Вставить("value", Выборка.ВремяВыполнения);
		ЗамерСтруктура.Вставить("tUTC", ДатаПоТипуЗамера(Выборка.ДатаНачалаЗамера));
		ЗамерСтруктура.Вставить("userName", Выборка.Пользователь);
		ЗамерСтруктура.Вставить("tSaveUTC", Выборка.ДатаЗаписи);
		ЗамерСтруктура.Вставить("sessionNumber", Выборка.НомерСеанса);
		ЗамерСтруктура.Вставить("comment", Выборка.Комментарий);
		
		КлючеваяОперацияЗамеры.Добавить(ЗамерСтруктура);
	КонецЦикла;
	
	Возврат ЗамерыСРазделением;
КонецФункции	

// Сохраняет результаты вычисления APDEX в файл
//
// Параметры:
//  КаталогиЭкспорта - Структура со значением типа Массив.
//  ВыборкаАпдекс - Результат запроса
//  МассивыЗамеров - Структура со значением типа Массив.
Процедура ВыгрузитьРезультаты(КаталогиЭкспорта, МассивыЗамеров)
	
	ДатаФормированияФайла = УниверсальноеВремя(ТекущаяДатаСеанса());
	ПространствоИмен = "www.v8.1c.ru/ssl/performace-assessment/apdexExport";
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла(".xml");
	
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.ОткрытьФайл(ИмяВременногоФайла, "UTF-8");
	ЗаписьXML.ЗаписатьОбъявлениеXML();
	ЗаписьXML.ЗаписатьНачалоЭлемента("Performance", ПространствоИмен);
	ЗаписьXML.ЗаписатьСоответствиеПространстваИмен("prf", ПространствоИмен);
	ЗаписьXML.ЗаписатьСоответствиеПространстваИмен("xs", "http://www.w3.org/2001/XMLSchema");
	ЗаписьXML.ЗаписатьСоответствиеПространстваИмен("xsi", "http://www.w3.org/2001/XMLSchema-instance");
	
	ЗаписьXML.ЗаписатьАтрибут("version", ПространствоИмен, "1.0.0.1");
	ЗаписьXML.ЗаписатьАтрибут("period", ПространствоИмен, Строка(ДатаФормированияФайла));
	
	ТипКлючеваяОперация = ФабрикаXDTO.Тип(ПространствоИмен, "KeyOperation");
	ТипИзмерение = ФабрикаXDTO.Тип(ПространствоИмен, "Measurement");
	
	Для Каждого ТекЗамер Из МассивыЗамеров Цикл
		КлючеваяОперацияЗамеры = ТекЗамер.Значение;
		
		КлючеваяОперация = ФабрикаXDTO.Создать(ТипКлючеваяОперация);
		КлючеваяОперация.name = КлючеваяОперацияЗамеры["name"];
		КлючеваяОперация.currentApdexValue = 0;
		
		minimalApdexValue = КлючеваяОперацияЗамеры["minimalApdexValue"];
		Если minimalApdexValue = Неопределено Тогда
			minimalApdexValue = 0;
		КонецЕсли;
		КлючеваяОперация.minimalApdexValue = minimalApdexValue;
		
		КлючеваяОперация.priority = КлючеваяОперацияЗамеры["priority"];
		КлючеваяОперация.targetValue = КлючеваяОперацияЗамеры["targetValue"];
		КлючеваяОперация.uid = КлючеваяОперацияЗамеры["uid"];
		
		Замеры = КлючеваяОперацияЗамеры["Замеры"];
		Для Каждого Замер Из Замеры Цикл
			ЗамерXML = ФабрикаXDTO.Создать(ТипИзмерение);
			ЗамерXML.value = Замер.value;
			ЗамерXML.tUTC = Замер.tUTC;
			ЗамерXML.userName = Замер.userName;
			ЗамерXML.tSaveUTC = Замер.tSaveUTC;
			ЗамерXML.sessionNumber = Замер.sessionNumber;
			ЗамерXML.comment = Замер.comment;
			
			КлючеваяОперация.measurement.Добавить(ЗамерXML);
		КонецЦикла;
		
		ФабрикаXDTO.ЗаписатьXML(ЗаписьXML, КлючеваяОперация);
	КонецЦикла;
	ЗаписьXML.ЗаписатьКонецЭлемента();
	ЗаписьXML.Закрыть();
	
	Для Каждого КлючВыполнятьКаталог Из КаталогиЭкспорта Цикл
		ВыполнятьКаталог = КлючВыполнятьКаталог.Значение;
		Выполнять = ВыполнятьКаталог[0];
		Если НЕ Выполнять Тогда
			Продолжить;
		КонецЕсли;
		
		КаталогЭкспорта = ВыполнятьКаталог[1];
		Ключ = КлючВыполнятьКаталог.Ключ;
		Если Ключ = ОценкаПроизводительностиКлиентСервер.ЛокальныйКаталогЭкспортаКлючЗадания() Тогда
			СоздатьКаталог(КаталогЭкспорта);
		КонецЕсли;
		
		КопироватьФайл(ИмяВременногоФайла, ПолноеИмяФайлаЭкспорта(КаталогЭкспорта, ДатаФормированияФайла, ".xml"));
	КонецЦикла;
	УдалитьФайлы(ИмяВременногоФайла);
КонецПроцедуры

// Генерирует имя файла для экспорта
//
// Параметры:
//  Каталог - Строка, 
//  ДатаФормированияФайла - Дата, дата и время выполнения замера
//  РасширениеСТочкой - Строка, задающая расширение файла, в виде ".xxx". 
// Возвращаемое значение:
//  Строка - полный путь к файлу экспорта
//
Функция ПолноеИмяФайлаЭкспорта(Каталог, ДатаФормированияФайла, РасширениеСТочкой)
	
	Разделитель = ?(ВРег(Лев(Каталог, 3)) = "FTP", "/", ПолучитьРазделительПути());
	Возврат УбратьРазделителиНаКонцеИмениФайла(Каталог, Разделитель) + Разделитель + Формат(ДатаФормированияФайла, "ДФ=""гггг-ММ-дд ЧЧ-мм-сс""") + РасширениеСТочкой;

КонецФункции

// Проверить путь на наличие завершающего слеша и если он есть, удалить его
//
// Параметры:
//  ИмяФайла - Строка
//  Разделитель - Строка
Функция УбратьРазделителиНаКонцеИмениФайла(Знач ИмяФайла, Разделитель)
	
	ДлинаПути = СтрДлина(ИмяФайла);	
	Если ДлинаПути = 0 Тогда
		Возврат ИмяФайла;
	КонецЕсли;
	
	Пока ДлинаПути > 0 И СтрЗаканчиваетсяНа(ИмяФайла, Разделитель) Цикл
		ИмяФайла = Лев(ИмяФайла, ДлинаПути - 1);
		ДлинаПути = СтрДлина(ИмяФайла);
	КонецЦикла;
	
	Возврат ИмяФайла;
	
КонецФункции

// Разбивает строку из нескольких объединенных слов в строку с отдельными словами.
// Признаком начала нового слова считается символ в верхнем регистре.
//
// Параметры:
//  Строка                 - Строка - текст с разделителями;
//
// Возвращаемое значение:
//  Строка - строка, разделенная по словам.
//
// Примеры:
//  РазложитьСтрокуПоСловам("ОдинДваТри") - возвратит строку "Один два три";
//
Функция РазложитьСтрокуПоСловам(Знач Строка)
	
	МассивСлов = Новый Массив;
	
	ПозицииСлов = Новый Массив;
	Для ПозицияСимвола = 1 По СтрДлина(Строка) Цикл
		ТекСимвол = Сред(Строка, ПозицияСимвола, 1);
		Если ТекСимвол = ВРег(ТекСимвол) 
			И (СтроковыеФункцииКлиентСервер.ТолькоКириллицаВСтроке(ТекСимвол) 
				Или СтроковыеФункцииКлиентСервер.ТолькоЛатиницаВСтроке(ТекСимвол)) Тогда
			ПозицииСлов.Добавить(ПозицияСимвола);
		КонецЕсли;
	КонецЦикла;
	
	Если ПозицииСлов.Количество() > 0 Тогда
		ПредыдущаяПозиция = 0;
		Для Каждого Позиция Из ПозицииСлов Цикл
			Если ПредыдущаяПозиция > 0 Тогда
				Подстрока = Сред(Строка, ПредыдущаяПозиция, Позиция - ПредыдущаяПозиция);
				Если Не ПустаяСтрока(Подстрока) Тогда
					МассивСлов.Добавить(СокрЛП(Подстрока));
				КонецЕсли;
			КонецЕсли;
			ПредыдущаяПозиция = Позиция;
		КонецЦикла;
		
		Подстрока = Сред(Строка, Позиция);
		Если Не ПустаяСтрока(Подстрока) Тогда
			МассивСлов.Добавить(СокрЛП(Подстрока));
		КонецЕсли;
	КонецЕсли;
	
	Для Индекс = 1 По МассивСлов.ВГраница() Цикл
		МассивСлов[Индекс] = НРег(МассивСлов[Индекс]);
	КонецЦикла;
	
	Результат = СтрСоединить(МассивСлов, " ");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
