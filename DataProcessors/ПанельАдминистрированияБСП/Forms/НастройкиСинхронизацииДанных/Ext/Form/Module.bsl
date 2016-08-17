﻿&НаКлиенте
Перем ОбновитьИнтерфейс;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Значения реквизитов формы
	РежимРаботы = ОбщегоНазначенияПовтИсп.РежимРаботыПрограммы();
	РежимРаботы = Новый ФиксированнаяСтруктура(РежимРаботы);
	
	// Настройки видимости при запуске.
	Элементы.ГруппаВременныеКаталогиКластераСерверов.Видимость = РежимРаботы.КлиентСерверный И РежимРаботы.ЭтоАдминистраторСистемы;
	
	// _Демо начало примера
	Элементы.ПрефиксУзлаРаспределеннойИнформационнойБазы.ТолькоПросмотр = Истина;
	// _Демо конец примера
	
	Если РежимРаботы.МодельСервиса Тогда
		
		Элементы.ОписаниеРаздела.Заголовок = Нстр("ru = 'Настройка синхронизации данных с моими приложениями.'");
		Элементы.ПояснениеНастройкиСинхронизацииДанных.Заголовок = Нстр("ru = 'Настройка и выполнение синхронизации данных с моими приложениями.'");
		Элементы.ИспользоватьДатыЗапретаЗагрузкиПояснение.Заголовок =
			НСтр("ru = 'Запрет загрузки данных прошлых периодов из других приложений.
			           |Не влияет на загрузку данных из автономных рабочих мест.'");
		
		Элементы.ГруппаИспользоватьСинхронизациюДанных.Видимость = Ложь;
		Элементы.ГруппаПрефиксУзлаРаспределеннойИнформационнойБазы.Видимость = Ложь;
		Элементы.ГруппаВременныеКаталогиКластераСерверов.Видимость = Ложь;
		
	КонецЕсли;
	
	// Обновление состояния элементов.
	УстановитьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ОбработчикОповещений(ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	ОбновитьИнтерфейсПрограммы();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользоватьСинхронизациюДанныхПриИзменении(Элемент)
	
	ОбновитьРазрешенияПрофилейБезопасности(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрефиксУзлаРаспределеннойИнформационнойБазыПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура КаталогСообщенийОбменаДаннымиДляWindowsПриИзменении(Элемент)
	
	ОбновитьРазрешенияПрофилейБезопасности(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогСообщенийОбменаДаннымиДляLinuxПриИзменении(Элемент)
	
	ОбновитьРазрешенияПрофилейБезопасности(Элемент);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Обработка оповещений от других открытых форм.
//
// Параметры:
//   ИмяСобытия - Строка - имя события. Может быть использовано для идентификации сообщений принимающими их формами.
//   Параметр - Произвольный - параметр сообщения. Могут быть переданы любые необходимые данные.
//   Источник - Произвольный - источник события. Например, в качестве источника может быть указана другая форма.
//
// Пример:
//   Если ИмяСобытия = "НаборКонстант.ПрефиксУзлаРаспределеннойИнформационнойБазы" Тогда
//     НаборКонстант.ПрефиксУзлаРаспределеннойИнформационнойБазы = Параметр;
//   КонецЕсли;
//
&НаКлиенте
Процедура ОбработчикОповещений(ИмяСобытия, Параметр, Источник)
	
	// _Демо начало примера
	Если ИмяСобытия = "НаборКонстант.ПрефиксУзлаРаспределеннойИнформационнойБазы" Тогда
		НаборКонстант.ПрефиксУзлаРаспределеннойИнформационнойБазы = Параметр;
	КонецЕсли;
	// _Демо конец примера
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиСинхронизацииДанных(Команда)
	
	Если РежимРаботы.МодельСервиса Тогда
		
		ИмяОткрываемойФормы = "ОбщаяФорма.СинхронизацияДанныхВМоделиСервиса";
		
	Иначе
		ИмяОткрываемойФормы = "ОбщаяФорма.СинхронизацияДанных";
		
	КонецЕсли;
	
	ОткрытьФорму(ИмяОткрываемойФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура РегистрСведенийДатыЗапретаЗагрузкиДанных(Команда)
	ОткрытьФорму(
		"РегистрСведений.ДатыЗапретаИзменения.Форма.ДатыЗапретаИзменения",
		Новый Структура("ДатыЗапретаЗагрузкиДанных", Истина),
		ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура РезультатыСинхронизацииДанных(Команда)
	ОткрытьФорму("РегистрСведений.РезультатыОбменаДанными.Форма.Форма");
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Клиент

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	Результат = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	Если ОбновлятьИнтерфейс Тогда
		ОбновитьИнтерфейс = Истина;
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 2, Истина);
	КонецЕсли;
	
	СтандартныеПодсистемыКлиент.ПоказатьРезультатВыполнения(ЭтотОбъект, Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьРазрешенияПрофилейБезопасности(Элемент)
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ОбновитьРазрешенияПрофилейБезопасностиЗавершение", ЭтотОбъект, Элемент);
	
	МассивЗапросов = СоздатьЗапросНаИспользованиеВнешнихРесурсов(Элемент.Имя);
	
	Если МассивЗапросов = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РаботаВБезопасномРежимеКлиент.ПрименитьЗапросыНаИспользованиеВнешнихРесурсов(
		МассивЗапросов, ЭтотОбъект, ОповещениеОЗакрытии);
	
КонецПроцедуры

&НаСервере
Функция СоздатьЗапросНаИспользованиеВнешнихРесурсов(ИмяКонстанты)
	
	КонстантаМенеджер = Константы[ИмяКонстанты];
	КонстантаЗначение = НаборКонстант[ИмяКонстанты];
	
	Если КонстантаМенеджер.Получить() = КонстантаЗначение Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если ИмяКонстанты = "ИспользоватьСинхронизациюДанных" Тогда
		
		Если КонстантаЗначение Тогда
			
			Запрос = ОбменДаннымиСервер.ЗапросНаИспользованиеВнешнихРесурсовПриВключенииОбмена();
			
		Иначе
			
			Запрос = ОбменДаннымиСервер.ЗапросНаОчисткуРазрешенийИспользованияВнешнихРесурсов();
			
		КонецЕсли;
		
		Возврат Запрос;
		
	Иначе
		
		МенеджерЗначения = КонстантаМенеджер.СоздатьМенеджерЗначения();
		ИдентификаторКонстанты = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(МенеджерЗначения.Метаданные());
		
		Если ПустаяСтрока(КонстантаЗначение) Тогда
			
			Запрос = РаботаВБезопасномРежиме.ЗапросНаОчисткуРазрешенийИспользованияВнешнихРесурсов(ИдентификаторКонстанты);
			
		Иначе
			
			Разрешения = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(
				РаботаВБезопасномРежиме.РазрешениеНаИспользованиеКаталогаФайловойСистемы(КонстантаЗначение, Истина, Истина));
			Запрос = РаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов(Разрешения, ИдентификаторКонстанты);
			
		КонецЕсли;
		
		Возврат ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Запрос);
		
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ОбновитьРазрешенияПрофилейБезопасностиЗавершение(Результат, Элемент) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
	
		Подключаемый_ПриИзмененииРеквизита(Элемент);
		
	Иначе
		
		ЭтотОбъект.Прочитать();
	
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Вызов сервера

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	Результат = Новый Структура;
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Результат);
	
	УстановитьДоступность(РеквизитПутьКДанным);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Сервер

&НаСервере
Процедура СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Результат)
	
	// Сохранение значений реквизитов, не связанных с константами напрямую (в отношении один-к-одному).
	Если РеквизитПутьКДанным = "" Тогда
		Возврат;
	КонецЕсли;
	
	// Определение имени константы.
	КонстантаИмя = "";
	Если НРег(Лев(РеквизитПутьКДанным, 14)) = НРег("НаборКонстант.") Тогда
		// Если путь к данным реквизита указан через "НаборКонстант".
		КонстантаИмя = Сред(РеквизитПутьКДанным, 15);
	Иначе
		// Определение имени и запись значения реквизита в соответствующей константе из "НаборКонстант".
		// Используется для тех реквизитов формы, которые связаны с константами напрямую (в отношении один-к-одному).
	КонецЕсли;
	
	// Сохранения значения константы.
	Если КонстантаИмя <> "" Тогда
		КонстантаМенеджер = Константы[КонстантаИмя];
		КонстантаЗначение = НаборКонстант[КонстантаИмя];
		
		Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
			КонстантаМенеджер.Установить(КонстантаЗначение);
		КонецЕсли;
		
		СтандартныеПодсистемыКлиентСервер.ОповеститьОткрытыеФормы(Результат, "Запись_НаборКонстант", Новый Структура, КонстантаИмя);
		// СтандартныеПодсистемы.ВариантыОтчетов
		ВариантыОтчетов.ДобавитьОповещениеПриИзмененииЗначенияКонстанты(Результат, КонстантаМенеджер);
		// Конец СтандартныеПодсистемы.ВариантыОтчетов
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьДатыЗапретаЗагрузки"
	 Или РеквизитПутьКДанным = "" Тогда
		
		Элементы.ГруппаДатыЗапретаЗагрузкиНастройка.Доступность =
			НаборКонстант.ИспользоватьДатыЗапретаЗагрузки;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьСинхронизациюДанных" ИЛИ РеквизитПутьКДанным = "" Тогда
		
		Элементы.ПрефиксУзлаРаспределеннойИнформационнойБазы.Доступность = НаборКонстант.ИспользоватьСинхронизациюДанных;
		Элементы.НастройкиСинхронизацииДанных.Доступность = НаборКонстант.ИспользоватьСинхронизациюДанных;
		Элементы.ГруппаДатыЗапретаЗагрузки.Доступность    = НаборКонстант.ИспользоватьСинхронизациюДанных;
		Элементы.РезультатыСинхронизацииДанных.Доступность = НаборКонстант.ИспользоватьСинхронизациюДанных;
		Элементы.ГруппаВременныеКаталогиКластераСерверов.Доступность = НаборКонстант.ИспользоватьСинхронизациюДанных;
		
		// _Демо начало примера
		Элементы._ДемоПомощникИзмененияПрефиксаИнформационнойБазы.Доступность = НаборКонстант.ИспользоватьСинхронизациюДанных;
		// _Демо конец примера
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
