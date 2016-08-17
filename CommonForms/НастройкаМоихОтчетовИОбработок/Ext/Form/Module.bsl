﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры, "ВидОбработок, ЭтоГлобальныеОбработки, ТекущийРаздел");
	
	ЗаполнитьДеревоОбработок(Истина, "МоиКоманды");
	ЗаполнитьДеревоОбработок(Ложь, "КомандыИсточник");
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	ТекстВопроса = НСтр("ru = 'Список выводимых команд был изменен.
	|Сохранить изменения?'");
	Обработчик = Новый ОписаниеОповещения("СохранитьИОповеститьОВыборе", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Обработчик, Отказ, ТекстВопроса);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДобавитьКоманду(Команда)
	
	ТекущиеДанные = Элементы.КомандыИсточник.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено И НЕ ПустаяСтрока(ТекущиеДанные.Идентификатор) Тогда
		ДобавитьКомандуСервер(ТекущиеДанные.Обработка, ТекущиеДанные.Идентификатор);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьКоманду(Команда)
	
	ТекущиеДанные = Элементы.МоиКоманды.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено И НЕ ПустаяСтрока(ТекущиеДанные.Идентификатор) Тогда
		УдалитьКомандуСервер(ТекущиеДанные.Обработка, ТекущиеДанные.Идентификатор);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВсеКоманды(Команда)
	
	Если ЭтоГлобальныеОбработки Тогда
		КомандыИсточникЭлементы = КомандыИсточник.ПолучитьЭлементы();
		
		Для Каждого СтрокаРазделы Из КомандыИсточникЭлементы Цикл
			ЭлементРаздел = НайтиЭлементРаздел(МоиКоманды, СтрокаРазделы.Раздел, СтрокаРазделы.Наименование);
			ЭлементыКоманды = СтрокаРазделы.ПолучитьЭлементы();
			Для Каждого ЭлементКоманда Из ЭлементыКоманды Цикл
				НоваяКоманда = НайтиЭлементКоманду(ЭлементРаздел.ПолучитьЭлементы(), ЭлементКоманда.Идентификатор);
				ЗаполнитьЗначенияСвойств(НоваяКоманда, ЭлементКоманда);
			КонецЦикла;
		КонецЦикла;
	Иначе
		ДобавитьВсеКомандыСервер();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьВсеКоманды(Команда)
	
	МоиКоманды.ПолучитьЭлементы().Очистить();
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	ЗаписатьНаборОбработокПользователя();
	ОповеститьОВыборе("ВыполненаНастройкаМоихОтчетовИОбработок");
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СохранитьИОповеститьОВыборе(Результат, ДополнительныеПараметры) Экспорт
	
	ЗаписатьНаборОбработокПользователя();
	ОповеститьОВыборе("ВыполненаНастройкаМоихОтчетовИОбработок");
	
КонецПроцедуры

&НаСервере
Функция ЗаполнитьДеревоОбработок(КомандыПользователя, ИмяЭлементыРеквизитаДерева)
	
	Запрос = Новый Запрос;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДопОтчетыИОбработки.Ссылка КАК Обработка,
	|	ТаблицаКоманды.Представление КАК Наименование,
	|	ТаблицаРазделы.Раздел КАК Раздел,
	|	ТаблицаКоманды.Идентификатор КАК Идентификатор
	|ИЗ
	|	Справочник.ДополнительныеОтчетыИОбработки КАК ДопОтчетыИОбработки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ДополнительныеОтчетыИОбработки.Команды КАК ТаблицаКоманды
	|		ПО ДопОтчетыИОбработки.Ссылка = ТаблицаКоманды.Ссылка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ДополнительныеОтчетыИОбработки.Разделы КАК ТаблицаРазделы
	|		ПО ДопОтчетыИОбработки.Ссылка = ТаблицаРазделы.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПользовательскиеНастройкиДоступаКОбработкам КАК БыстрыйДоступ
	|		ПО ДопОтчетыИОбработки.Ссылка = БыстрыйДоступ.ДополнительныйОтчетИлиОбработка
	|			И (БыстрыйДоступ.ИдентификаторКоманды = ТаблицаКоманды.Идентификатор)
	|			И (БыстрыйДоступ.Пользователь = &Пользователь)
	|ГДЕ
	|	ДопОтчетыИОбработки.Вид = &ВидОбработок
	|	И НЕ ДопОтчетыИОбработки.ПометкаУдаления
	|	И ДопОтчетыИОбработки.Публикация В(&ВариантыПубликации)
	|	И БыстрыйДоступ.Доступно
	|ИТОГИ ПО
	|	&ИтогиПоРаздел";
	
	Если ЭтоГлобальныеОбработки Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ИтогиПоРаздел", "Раздел");
	Иначе
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ДополнительныеОтчетыИОбработкиРазделы.Раздел КАК Раздел,", "");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ДополнительныеОтчетыИОбработки.Разделы КАК ТаблицаРазделы", "");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ПО ДопОтчетыИОбработки.Ссылка = ТаблицаРазделы.Ссылка", "");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ИТОГИ ПО", "");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ИтогиПоРаздел", "");
	КонецЕсли;
	
	Если НЕ КомандыПользователя Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПользовательскиеНастройкиДоступаКОбработкам КАК БыстрыйДоступ", "");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "ПО ДопОтчетыИОбработки.Ссылка = БыстрыйДоступ.ДополнительныйОтчетИлиОбработка", "");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И (БыстрыйДоступ.ИдентификаторКоманды = ТаблицаКоманды.Идентификатор)", "");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И (БыстрыйДоступ.Пользователь = &Пользователь)", "");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И БыстрыйДоступ.Доступно", "");
	КонецЕсли;
	
	ВариантыПубликации = Новый Массив;
	ВариантыПубликации.Добавить(Перечисления.ВариантыПубликацииДополнительныхОтчетовИОбработок.Используется);
	Если Пользователи.РолиДоступны("ДобавлениеИзменениеДополнительныхОтчетовИОбработок") Тогда
		ВариантыПубликации.Добавить(Перечисления.ВариантыПубликацииДополнительныхОтчетовИОбработок.РежимОтладки);
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Пользователь", ПользователиКлиентСервер.АвторизованныйПользователь());
	Запрос.УстановитьПараметр("ВариантыПубликации", ВариантыПубликации);
	Запрос.УстановитьПараметр("ВидОбработок", ВидОбработок);
	
	Запрос.Текст = ТекстЗапроса;
	
	Если ЭтоГлобальныеОбработки Тогда
		ДеревоКоманд = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкам);
	Иначе
		ТаблицаКоманд = Запрос.Выполнить().Выгрузить();
	КонецЕсли;
	
	КомандыДерево = РеквизитФормыВЗначение(ИмяЭлементыРеквизитаДерева);
	КомандыДерево.Строки.Очистить();
	
	СобственныйИндекс = 0;
	Индекс = 0;
	
	Если ЭтоГлобальныеОбработки Тогда
		Для Каждого СтрокаРазделы Из ДеревоКоманд.Строки Цикл
			ПредставлениеРаздела = ДополнительныеОтчетыИОбработки.ПредставлениеРаздела(СтрокаРазделы.Раздел);
			Если ПредставлениеРаздела = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			СтрокаВерхнегоУровня = КомандыДерево.Строки.Добавить();
			СтрокаВерхнегоУровня.Раздел = СтрокаРазделы.Раздел;
			СтрокаВерхнегоУровня.Наименование = ПредставлениеРаздела;
			Если СтрокаВерхнегоУровня.Раздел = ТекущийРаздел Тогда
				СобственныйИндекс = Индекс;
			КонецЕсли;
			Для Каждого СтрокаКоманды Из СтрокаРазделы.Строки Цикл
				СтрокаОписанияКоманд = СтрокаВерхнегоУровня.Строки.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаОписанияКоманд, СтрокаКоманды);
				Индекс = Индекс + 1;
			КонецЦикла;
			Индекс = Индекс + 1;
		КонецЦикла;
	Иначе
		Для Каждого ЭлементКоманда Из ТаблицаКоманд Цикл
			НоваяСтрока = КомандыДерево.Строки.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ЭлементКоманда);
		КонецЦикла;
	КонецЕсли;
	
	ЗначениеВРеквизитФормы(КомандыДерево, ИмяЭлементыРеквизитаДерева);
	
	Элементы[ИмяЭлементыРеквизитаДерева].ТекущаяСтрока = СобственныйИндекс;
	
КонецФункции

&НаСервере
Процедура ДобавитьКомандуСервер(Обработка, Идентификатор)
	
	МоиКомандыДерево = РеквизитФормыВЗначение("МоиКоманды");
	НайденныеСтроки = МоиКомандыДерево.Строки.НайтиСтроки(Новый Структура("Обработка,Идентификатор", Обработка, Идентификатор), Истина);
	Если НайденныеСтроки.Количество() > 0 Тогда
		Возврат;
	КонецЕсли;
	
	КомандыИсточникДерево = РеквизитФормыВЗначение("КомандыИсточник");
	НайденныеСтроки = КомандыИсточникДерево.Строки.НайтиСтроки(Новый Структура("Обработка,Идентификатор", Обработка, Идентификатор), Истина);
		
	Если ЭтоГлобальныеОбработки Тогда	
		Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			ЭлементРаздел = НайтиЭлементРаздел(МоиКоманды, НайденнаяСтрока.Раздел, НайденнаяСтрока.Родитель.Наименование);
			НоваяКоманда = ЭлементРаздел.ПолучитьЭлементы().Добавить();
			ЗаполнитьЗначенияСвойств(НоваяКоманда, НайденнаяСтрока);
		КонецЦикла;
	Иначе
		НоваяКоманда = МоиКоманды.ПолучитьЭлементы().Добавить();
		ЗаполнитьЗначенияСвойств(НоваяКоманда, НайденныеСтроки[0]);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьВсеКомандыСервер()
	
	ЗначениеВРеквизитФормы(РеквизитФормыВЗначение("КомандыИсточник"), "МоиКоманды");
	
КонецПроцедуры

&НаСервере
Процедура УдалитьКомандуСервер(Обработка, Идентификатор)
	
	МоиКомандыЭлементы = МоиКоманды.ПолучитьЭлементы();
	
	Если ЭтоГлобальныеОбработки Тогда
		
		УдаляемыеРазделы = Новый Массив;
		
		Для Каждого СтрокаРазделы Из МоиКомандыЭлементы Цикл
			ЭлементыКоманды = СтрокаРазделы.ПолучитьЭлементы();
			Для Каждого СтрокаКоманды Из ЭлементыКоманды Цикл
				Если СтрокаКоманды.Обработка = Обработка И СтрокаКоманды.Идентификатор = Идентификатор Тогда
					ЭлементыКоманды.Удалить(ЭлементыКоманды.Индекс(СтрокаКоманды));
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Если ЭлементыКоманды.Количество() = 0 Тогда
				УдаляемыеРазделы.Добавить(МоиКомандыЭлементы.Индекс(СтрокаРазделы));
			КонецЕсли;
		КонецЦикла;
		
		УдаляемыеРазделыТаблица = Новый ТаблицаЗначений;
		УдаляемыеРазделыТаблица.Колонки.Добавить("Раздел", Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(10)));
		Для Каждого УдаляемыйРаздел Из УдаляемыеРазделы Цикл
			Строка = УдаляемыеРазделыТаблица.Добавить();
			Строка.Раздел = УдаляемыйРаздел;
		КонецЦикла;
		УдаляемыеРазделыТаблица.Свернуть("Раздел");
		УдаляемыеРазделыТаблица.Сортировать("Раздел Убыв");
		
		УдаляемыеРазделы = УдаляемыеРазделыТаблица.ВыгрузитьКолонку("Раздел");
		
		Для Каждого УдаляемыйРаздел Из УдаляемыеРазделы Цикл
			МоиКомандыЭлементы.Удалить(УдаляемыйРаздел);
		КонецЦикла;
		
	Иначе
		
		Для Каждого СтрокаКоманды Из МоиКомандыЭлементы Цикл
			Если СтрокаКоманды.Обработка = Обработка И СтрокаКоманды.Идентификатор = Идентификатор Тогда
				МоиКомандыЭлементы.Удалить(МоиКомандыЭлементы.Индекс(СтрокаКоманды));
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция НайтиЭлементРаздел(ДанныеФормыКоманды, Раздел, Наименование)
	
	Результат = Неопределено;
	
	Для Каждого ЭлементДанных Из ДанныеФормыКоманды.ПолучитьЭлементы() Цикл
		Если ЭлементДанных.Раздел = Раздел Тогда
			Результат = ЭлементДанных;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если Результат = Неопределено Тогда
		НовыйРаздел = ДанныеФормыКоманды.ПолучитьЭлементы().Добавить();
		НовыйРаздел.Раздел = Раздел;
		НовыйРаздел.Наименование = Наименование;
		Результат = НовыйРаздел;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция НайтиЭлементКоманду(ДанныеФормыКоллекцияЭлементовДерева, Идентификатор)
	
	Результат = Неопределено;
	
	Для Каждого ЭлементДанных Из ДанныеФормыКоллекцияЭлементовДерева Цикл
		Если ЭлементДанных.Идентификатор = Идентификатор Тогда
			Результат = ЭлементДанных;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если Результат = Неопределено Тогда
		НовыйРаздел = ДанныеФормыКоллекцияЭлементовДерева.Добавить();
		Результат = НовыйРаздел;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Работа с регистром ПользовательскиеНастройкиДоступаКОбработкам.

&НаСервере
Процедура ЗаписатьНаборОбработокПользователя()
	
	ТекстЗапроса = "
			|ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	ДополнительныеОтчетыИОбработкиКоманды.Идентификатор КАК Идентификатор,
			|	ДополнительныеОтчетыИОбработки.Ссылка				КАК Обработка
			|ИЗ
			|	Справочник.ДополнительныеОтчетыИОбработки КАК ДополнительныеОтчетыИОбработки
			|	СОЕДИНЕНИЕ Справочник.ДополнительныеОтчетыИОбработки.Команды КАК ДополнительныеОтчетыИОбработкиКоманды
			|			ПО ДополнительныеОтчетыИОбработкиКоманды.Ссылка = ДополнительныеОтчетыИОбработки.Ссылка
			|ГДЕ
			|	ДополнительныеОтчетыИОбработки.Вид = &ВидОбработок";
	
	Запрос = Новый Запрос;
	Запрос.Параметры.Вставить("ВидОбработок", ВидОбработок);
	Запрос.Текст = ТекстЗапроса;
	
	ТаблицаОбработок = Запрос.Выполнить().Выгрузить();
	
	МоиКомандыДерево = РеквизитФормыВЗначение("МоиКоманды");
	
	ТаблицаМоихКоманд = ПолучитьТаблицу();
	
	Если ЭтоГлобальныеОбработки Тогда
		Для Каждого СтрокаРазделы Из МоиКомандыДерево.Строки Цикл
			Для Каждого СтрокаКоманды Из СтрокаРазделы.Строки Цикл
				НоваяСтрока = ТаблицаМоихКоманд.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаКоманды);
			КонецЦикла;
		КонецЦикла;
	Иначе
		Для Каждого СтрокаКоманды Из МоиКомандыДерево.Строки Цикл
			НоваяСтрока = ТаблицаМоихКоманд.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаКоманды);
		КонецЦикла;
	КонецЕсли;
	
	ТаблицаМоихКоманд.Свернуть("Обработка,Идентификатор");
	
	// ----------------
	
	ТаблицаСравнения = ТаблицаОбработок.Скопировать();
	ТаблицаСравнения.Колонки.Добавить("Признак", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(1)));
	Для Каждого Строка Из ТаблицаСравнения Цикл
		Строка.Признак = -1;
	КонецЦикла;
	
	Для Каждого Строка Из ТаблицаМоихКоманд Цикл
		НоваяСтрока = ТаблицаСравнения.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
		НоваяСтрока.Признак = +1;
	КонецЦикла;
	
	ТаблицаСравнения.Свернуть("Обработка,Идентификатор", "Признак");
	
	СтрокиДляИсключенияИзСпискаСвоих = ТаблицаСравнения.НайтиСтроки(Новый Структура("Признак", -1));
	СтрокиДляДобавленияВСписокСвоих = ТаблицаСравнения.НайтиСтроки(Новый Структура("Признак", 0));
	
	НачатьТранзакцию();
	
	Попытка
		ДополнительныеОтчетыИОбработки.УдалитьКомандыИзСпискаСвоих(СтрокиДляИсключенияИзСпискаСвоих);
		ДополнительныеОтчетыИОбработки.ДобавитьКомандыВСписокСвоих(СтрокиДляДобавленияВСписокСвоих);
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Модифицированность = Ложь;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьТаблицу()
	
	ТаблицаКоманд = Новый ТаблицаЗначений;
	ТаблицаКоманд.Колонки.Добавить("Обработка", Новый ОписаниеТипов("СправочникСсылка.ДополнительныеОтчетыИОбработки"));
	ТаблицаКоманд.Колонки.Добавить("Идентификатор", Новый ОписаниеТипов("Строка"));
	
	Возврат ТаблицаКоманд;
	
КонецФункции

#КонецОбласти
