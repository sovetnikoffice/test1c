﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Для внутреннего использования.
//
Процедура ВыполнитьАвтоматическоеСопоставлениеДанных(Параметры, АдресВременногоХранилища) Экспорт
	
	ПоместитьВоВременноеХранилище(
		РезультатАвтоматическогоСопоставленияДанных(Параметры.УзелИнформационнойБазы, Параметры.ИмяФайлаСообщенияОбмена, Параметры.ИмяВременногоКаталогаСообщенийОбмена,
		Параметры.ПроверятьРасхождениеВерсий), АдресВременногоХранилища);
		
КонецПроцедуры

// Для внутреннего использования.
//
Функция РезультатАвтоматическогоСопоставленияДанных(Знач Корреспондент, Знач ИмяФайлаСообщенияОбмена, Знач ИмяВременногоКаталогаСообщенийОбмена, ПроверятьРасхождениеВерсий) Экспорт
	
	// Выполняем автоматическое сопоставление данных, полученных от корреспондента.
	// Получаем статистику сопоставления.
	
	УстановитьПривилегированныйРежим(Истина);
	
	ОбменДаннымиСервер.ИнициализироватьПараметрыПроверкиРасхожденияВерсий(ПроверятьРасхождениеВерсий);
	
	ПомощникИнтерактивногоОбменаДанными = Обработки.ПомощникИнтерактивногоОбменаДанными.Создать();
	ПомощникИнтерактивногоОбменаДанными.УзелИнформационнойБазы = Корреспондент;
	ПомощникИнтерактивногоОбменаДанными.ИмяФайлаСообщенияОбмена = ИмяФайлаСообщенияОбмена;
	ПомощникИнтерактивногоОбменаДанными.ИмяВременногоКаталогаСообщенийОбмена = ИмяВременногоКаталогаСообщенийОбмена;
	ПомощникИнтерактивногоОбменаДанными.ИмяПланаОбмена = ОбменДаннымиПовтИсп.ПолучитьИмяПланаОбмена(Корреспондент);
	ПомощникИнтерактивногоОбменаДанными.ВидТранспортаСообщенийОбмена = Неопределено;
	
	// Выполняем анализ сообщения обмена.
	Отказ = Ложь;
	ПомощникИнтерактивногоОбменаДанными.ВыполнитьАнализСообщенияОбмена(Отказ);
	Если Отказ Тогда
		Если ПараметрыСеанса.ОшибкаРасхожденияВерсийПриПолученииДанных.ЕстьОшибка Тогда
			Возврат ПараметрыСеанса.ОшибкаРасхожденияВерсийПриПолученииДанных;
		Иначе
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось загрузить данные из ""%1"" (этап анализа данных).'"),
				Строка(Корреспондент));
		КонецЕсли;
	КонецЕсли;
	
	// Выполняем автоматическое сопоставление и получаем статистику сопоставления.
	Отказ = Ложь;
	ПомощникИнтерактивногоОбменаДанными.ВыполнитьАвтоматическоеСопоставлениеПоУмолчаниюИПолучитьСтатистикуСопоставления(Отказ);
	Если Отказ Тогда
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось загрузить данные из ""%1"" (этап автоматического сопоставления данных).'"),
			Строка(Корреспондент));
	КонецЕсли;
	
	ТаблицаИнформацииСтатистики = ПомощникИнтерактивногоОбменаДанными.ТаблицаИнформацииСтатистики();
	
	Результат = Новый Структура;
	Результат.Вставить("ИнформацияСтатистики", ТаблицаИнформацииСтатистики);
	Результат.Вставить("ВсеДанныеСопоставлены", ВсеДанныеСопоставлены(ТаблицаИнформацииСтатистики));
	Результат.Вставить("СтатистикаПустая", ТаблицаИнформацииСтатистики.Количество() = 0);
	
	Возврат Результат;
КонецФункции

// Для внутреннего использования.
//
Процедура ВыполнитьЗагрузкуДанных(Параметры, АдресВременногоХранилища) Экспорт
	
	ПараметрыОбменаДанными = ОбменДаннымиСервер.ПараметрыОбменаДаннымиЧерезФайлИлиСтроку();
	
	ПараметрыОбменаДанными.УзелИнформационнойБазы        = Параметры.УзелИнформационнойБазы;
	ПараметрыОбменаДанными.ПолноеИмяФайлаСообщенияОбмена = Параметры.ИмяФайлаСообщенияОбмена;
	ПараметрыОбменаДанными.ДействиеПриОбмене             = Перечисления.ДействияПриОбмене.ЗагрузкаДанных;
	
	ОбменДаннымиСервер.ВыполнитьОбменДаннымиДляУзлаИнформационнойБазыЧерезФайлИлиСтроку(ПараметрыОбменаДанными);
КонецПроцедуры

// Для внутреннего использования.
// Выполняет выгрузку данных, вызывается фоновым заданием
// Параметры - структура с параметрами для передачи
Процедура ВыполнитьВыгрузкуДанных(Параметры, АдресВременногоХранилища) Экспорт

	Отказ = Ложь;
	
	ПараметрыОбмена = ОбменДаннымиСервер.ПараметрыОбмена();
	ПараметрыОбмена.ВидТранспортаСообщенийОбмена = Параметры.ВидТранспортаСообщенийОбмена;
	ПараметрыОбмена.ВыполнятьЗагрузку = Ложь;
	ПараметрыОбмена.ВыполнятьВыгрузку = Истина;
	
	ПараметрыОбмена.ДлительнаяОперацияРазрешена = Истина;
	ПараметрыОбмена.ДлительнаяОперация          = Истина;
	ПараметрыОбмена.ИдентификаторОперации       = Параметры.ИдентификаторОперации;
	ПараметрыОбмена.ИдентификаторФайла          = Параметры.ИдентификаторФайла;
	ПараметрыОбмена.ПараметрыАутентификации     = Параметры.WSПароль;
	
	ОбменДаннымиСервер.ВыполнитьОбменДаннымиДляУзлаИнформационнойБазы(Параметры.УзелИнформационнойБазы, ПараметрыОбмена, Отказ);
	
	Параметры.ИдентификаторОперации   = ПараметрыОбмена.ИдентификаторОперации;
	Параметры.ИдентификаторФайла      = ПараметрыОбмена.ИдентификаторФайла;
	Параметры.WSПароль                = ПараметрыОбмена.ПараметрыАутентификации;
	
КонецПроцедуры

// Для внутреннего использования.
//
Функция ВсеДанныеСопоставлены(ИнформацияСтатистики) Экспорт
	
	Возврат (ИнформацияСтатистики.НайтиСтроки(Новый Структура("ИндексКартинки", 1)).Количество() = 0);
	
КонецФункции

#КонецОбласти

#КонецЕсли
