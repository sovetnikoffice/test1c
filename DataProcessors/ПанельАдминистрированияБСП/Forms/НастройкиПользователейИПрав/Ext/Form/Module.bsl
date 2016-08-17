﻿&НаКлиенте
Перем ОбновитьИнтерфейс;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.Пользователи
	Если Не Пользователи.ОбщиеНастройкиВходаИспользуются() Тогда
		Элементы.ГруппаНастройкиВхода.Видимость = Ложь;
		Элементы.ГруппыПользователейИНастройкиВхода.Группировка
			= ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
		Элементы.ГоризонтальныйОтступ2.Видимость = Ложь;
		Элементы.ГруппаНастройкиВходаВнешнихПользователей.Видимость = Ложь;
		Элементы.ИспользованиеВнешнихПользователейИНастройкиВхода.Группировка
			= ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
	КонецЕсли;
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено()
	 Или СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации()
	 Или ОбщегоНазначенияПовтИсп.ЭтоАвтономноеРабочееМесто() Тогда
		
		Элементы.НастройкаВнешнихПользователей.Видимость = Ложь;
	КонецЕсли;
	
	Если СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации()
	 Или ОбщегоНазначенияПовтИсп.ЭтоАвтономноеРабочееМесто() Тогда
		
		Элементы.ИспользоватьГруппыПользователей.Доступность = Ложь;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Пользователи
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УпрощенныйИнтерфейс = УправлениеДоступомСлужебный.УпрощенныйИнтерфейсНастройкиПравДоступа();
	Элементы.ГруппыДоступа.Видимость       = НЕ УпрощенныйИнтерфейс;
	Элементы.ГруппыПользователей.Видимость = НЕ УпрощенныйИнтерфейс;
	
	Если ОбщегоНазначенияПовтИсп.ЭтоАвтономноеРабочееМесто() Тогда
		Элементы.ОграничиватьДоступНаУровнеЗаписей.Доступность = Ложь;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// Обновление состояния элементов.
	УстановитьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	ОбновитьИнтерфейсПрограммы();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// СтандартныеПодсистемы.УправлениеДоступом
&НаКлиенте
Процедура ИспользоватьГруппыПользователейПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры
// Конец СтандартныеПодсистемы.УправлениеДоступом

// СтандартныеПодсистемы.УправлениеДоступом
&НаКлиенте
Процедура ОграничиватьДоступНаУровнеЗаписейПриИзменении(Элемент)
	
	Если НаборКонстант.ОграничиватьДоступНаУровнеЗаписей Тогда
		
		ТекстВопроса =
			НСтр("ru = 'Включить ограничение доступа на уровне записей?
			           |
			           |Потребуется заполнение данных, которое будет выполняться частями
			           |регламентным заданием ""Заполнение данных для ограничения доступа""
			           |(ход выполнения в журнале регистрации).
			           |
			           |Выполнение может сильно замедлить работу программы и выполняться
			           |от нескольких секунд до многих часов (в зависимости от объема данных).'");
		
		ПоказатьВопрос(
			Новый ОписаниеОповещения(
				"ОграничиватьДоступНаУровнеЗаписейПриИзмененииЗавершение",
				ЭтотОбъект,
				Элемент),
			ТекстВопроса,
			РежимДиалогаВопрос.ДаНет);
	Иначе
		Подключаемый_ПриИзмененииРеквизита(Элемент);
		// _Демо начало примера
		Если НаборКонстант._ДемоОграничиватьДоступПоПартнерам Тогда
			НаборКонстант._ДемоОграничиватьДоступПоПартнерам = Ложь;
			Подключаемый_ПриИзмененииРеквизита(Элементы._ДемоОграничиватьДоступПоПартнерам);
		КонецЕсли;
		Если НаборКонстант._ДемоОграничиватьДоступПоНоменклатуре Тогда
			НаборКонстант._ДемоОграничиватьДоступПоНоменклатуре = Ложь;
			Подключаемый_ПриИзмененииРеквизита(Элементы._ДемоОграничиватьДоступПоНоменклатуре);
		КонецЕсли;
		Если НаборКонстант._ДемоОграничиватьДоступПоФизическимЛицам Тогда
			НаборКонстант._ДемоОграничиватьДоступПоФизическимЛицам = Ложь;
			Подключаемый_ПриИзмененииРеквизита(Элементы._ДемоОграничиватьДоступПоФизическимЛицам);
		КонецЕсли;
		// _Демо конец примера
	КонецЕсли;
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.УправлениеДоступом

// СтандартныеПодсистемы.Пользователи
&НаКлиенте
Процедура ИспользоватьВнешнихПользователейПриИзменении(Элемент)
	
	Если НаборКонстант.ИспользоватьВнешнихПользователей Тогда
		
		ТекстВопроса =
			НСтр("ru = 'Разрешить доступ внешним пользователям?
			           |
			           |При входе в программу список выбора пользователей станет пустым
			           |(реквизит ""Показывать в списке выбора"" в карточках всех
			           | пользователей будет очищен и скрыт).'");
		
		ПоказатьВопрос(
			Новый ОписаниеОповещения(
				"ИспользоватьВнешнихПользователейПриИзмененииЗавершение",
				ЭтотОбъект,
				Элемент),
			ТекстВопроса,
			РежимДиалогаВопрос.ДаНет);
	Иначе
		ТекстВопроса =
			НСтр("ru = 'Запретить доступ внешним пользователям?
			           |
			           |Реквизит ""Вход в программу разрешен"" будет
			           |очищен в карточках всех внешних пользователей.'");
		
		ПоказатьВопрос(
			Новый ОписаниеОповещения(
				"ИспользоватьВнешнихПользователейПриИзмененииЗавершение",
				ЭтотОбъект,
				Элемент),
			ТекстВопроса,
			РежимДиалогаВопрос.ДаНет);
	КонецЕсли;
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Пользователи

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.Пользователи
&НаКлиенте
Процедура СправочникВнешниеПользователи(Команда)
	ОткрытьФорму("Справочник.ВнешниеПользователи.ФормаСписка", , ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура НастройкиВходаПользователей(Команда)
	
	ОткрытьФорму("ОбщаяФорма.НастройкиВходаПользователей", , ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкиВходаВнешнихПользователей(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПоказатьНастройкиВнешнихПользователей", Истина);
	
	ОткрытьФорму("ОбщаяФорма.НастройкиВходаПользователей", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Пользователи

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

// СтандартныеПодсистемы.УправлениеДоступом
&НаКлиенте
Процедура ОграничиватьДоступНаУровнеЗаписейПриИзмененииЗавершение(Ответ, Элемент) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		НаборКонстант.ОграничиватьДоступНаУровнеЗаписей = Ложь;
	Иначе
		Подключаемый_ПриИзмененииРеквизита(Элемент);
	КонецЕсли;
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.УправлениеДоступом

// СтандартныеПодсистемы.Пользователи
&НаКлиенте
Процедура ИспользоватьВнешнихПользователейПриИзмененииЗавершение(Ответ, Элемент) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		НаборКонстант.ИспользоватьВнешнихПользователей = Ложь;
	Иначе
		Подключаемый_ПриИзмененииРеквизита(Элемент);
	КонецЕсли;
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Пользователи

////////////////////////////////////////////////////////////////////////////////
// Вызов сервера

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	Результат = Новый Структура;
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	НачатьТранзакцию();
	Попытка
		// _Демо начало примера
		// СтандартныеПодсистемы.УправлениеДоступом
		Если НаборКонстант.ОграничиватьДоступНаУровнеЗаписей
		   И НаборКонстант.ИспользоватьВнешнихПользователей
		   И Не НаборКонстант._ДемоОграничиватьДоступПоПартнерам Тогда
			// Установка зависимой настройки.
			НаборКонстант._ДемоОграничиватьДоступПоПартнерам = Истина;
			СохранитьЗначениеРеквизита(Элементы._ДемоОграничиватьДоступПоПартнерам.ПутьКДанным, Результат);
		КонецЕсли;
		// Конец СтандартныеПодсистемы.УправлениеДоступом
		// _Демо конец примера
		СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Результат);
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
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
	
	// СтандартныеПодсистемы.Пользователи
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьВнешнихПользователей" ИЛИ РеквизитПутьКДанным = "" Тогда
		Элементы.ОткрытьВнешниеПользователи.Доступность         = НаборКонстант.ИспользоватьВнешнихПользователей;
		Элементы.НастройкиВходаВнешнихПользователей.Доступность = НаборКонстант.ИспользоватьВнешнихПользователей;
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Пользователи
	
	// _Демо начало примера
	Если РеквизитПутьКДанным = "НаборКонстант.ОграничиватьДоступНаУровнеЗаписей" ИЛИ РеквизитПутьКДанным = "" Тогда
		ЕстьДоступность = НаборКонстант.ОграничиватьДоступНаУровнеЗаписей
			И Не ОбщегоНазначенияПовтИсп.ЭтоАвтономноеРабочееМесто();
		Элементы._ДемоОграничиватьДоступПоНоменклатуре.Доступность    = ЕстьДоступность;
		Элементы._ДемоОграничиватьДоступПоФизическимЛицам.Доступность = ЕстьДоступность;
	КонецЕсли;
	Если РеквизитПутьКДанным = "НаборКонстант._ДемоОграничиватьДоступПоПартнерам" ИЛИ РеквизитПутьКДанным = "" Тогда
		Элементы._ДемоОткрытьГруппыДоступаПартнеров.Доступность = НаборКонстант._ДемоОграничиватьДоступПоПартнерам;
	КонецЕсли;
	Если РеквизитПутьКДанным = "НаборКонстант._ДемоОграничиватьДоступПоНоменклатуре" ИЛИ РеквизитПутьКДанным = "" Тогда
		Элементы._ДемоОткрытьГруппыДоступаНоменклатуры.Доступность = НаборКонстант._ДемоОграничиватьДоступПоНоменклатуре;
	КонецЕсли;
	Если РеквизитПутьКДанным = "НаборКонстант.ОграничиватьДоступНаУровнеЗаписей"
	 Или РеквизитПутьКДанным = "НаборКонстант._ДемоОграничиватьДоступПоПартнерам"
	 Или РеквизитПутьКДанным = "НаборКонстант.ИспользоватьВнешнихПользователей"
	 Или РеквизитПутьКДанным = "" Тогда
		Элементы._ДемоОграничиватьДоступПоПартнерам.Доступность =
			  НаборКонстант.ОграничиватьДоступНаУровнеЗаписей
			И Не НаборКонстант.ИспользоватьВнешнихПользователей
			И Не ОбщегоНазначенияПовтИсп.ЭтоАвтономноеРабочееМесто();
		Элементы._ДемоГруппаДоступПоПартнерамПредупреждение.Видимость =
			НаборКонстант.ОграничиватьДоступНаУровнеЗаписей
			И НаборКонстант.ИспользоватьВнешнихПользователей;
	КонецЕсли;
	// _Демо конец примера
	
КонецПроцедуры

#КонецОбласти
