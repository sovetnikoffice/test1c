﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗаполнитьТипыОбъектовВДеревеЗначений();
	
	ЗаполнитьСпискиВыбора();
	
	Элементы.Расписание.Заголовок = ТекущееРасписание();
	АвтоматическиОчищатьНенужныеФайлы = АвтоматическаяОчисткаВключена();
	Элементы.Расписание.Доступность = АвтоматическиОчищатьНенужныеФайлы;
	Элементы.НастроитьРасписание.Доступность = АвтоматическиОчищатьНенужныеФайлы;
	
КонецПроцедуры

&НаКлиенте
Процедура АвтоматическиОчищатьНенужныеФайлыПриИзменении(Элемент)
	ВключитьОтключитьРегламентноеЗадание(АвтоматическиОчищатьНенужныеФайлы);
	Элементы.Расписание.Доступность = АвтоматическиОчищатьНенужныеФайлы;
	Элементы.НастроитьРасписание.Доступность = АвтоматическиОчищатьНенужныеФайлы;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоОбъектовМетаданных

&НаКлиенте
Процедура ДеревоОбъектовМетаданныхПередНачаломИзменения(Элемент, Отказ)
	
	Если Элемент.ТекущиеДанные.ПолучитьРодителя() = Неопределено Тогда
		Отказ = Истина;
	КонецЕсли;
	
	Если Элемент.ТекущийЭлемент = Элементы.ДеревоОбъектовМетаданныхДействие Тогда
		ЗаполнитьСписокВыбора(Элементы.ДеревоОбъектовМетаданных.ТекущийЭлемент);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДеревоОбъектовМетаданныхВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "ДеревоОбъектовМетаданныхПравилоОтбора" Тогда
		СтандартнаяОбработка = Ложь;
		ОткрытьФормуНастроек();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОбъектовМетаданныхПравилоОтбораНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФормуНастроек();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОбъектовМетаданныхДействиеПриИзменении(Элемент)
	
	ЗаписатьТекущиеНастройки();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОбъектовМетаданныхПериодОчисткиПриИзменении(Элемент)
	
	ЗаписатьТекущиеНастройки();
		
КонецПроцедуры

&НаКлиенте
Процедура ДеревоОбъектовМетаданныхОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДобавитьНастройкиПоВладельцу(ВыбранноеЗначение);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбъемНенужныхФайлов(Команда)
	
	ПараметрыОтчета = Новый Структура();
	ПараметрыОтчета.Вставить("СформироватьПриОткрытии", Истина);
	
	ОткрытьФорму("Отчет.ОбъемНенужныхФайлов.ФормаОбъекта", ПараметрыОтчета);
	
КонецПроцедуры

&НаКлиенте
Процедура НастроитьРасписание(Команда)
	ДиалогРасписания = Новый ДиалогРасписанияРегламентногоЗадания(ТекущееРасписание());
	ОписаниеОповещения = Новый ОписаниеОповещения("НастроитьРасписаниеЗавершение", ЭтотОбъект);
	ДиалогРасписания.Показать(ОписаниеОповещения);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДействиеНеОчищать(Команда)
	
	УстановитьДействиеДляВыбранныхОбъектов(
		ПредопределенноеЗначение("Перечисление.ВариантыОчисткиФайлов.НеОчищать"));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДействиеОчиститьВерсии(Команда)
	
	УстановитьДействиеДляВыбранныхОбъектов(
		ПредопределенноеЗначение("Перечисление.ВариантыОчисткиФайлов.ОчиститьВерсии"));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДействиеОчиститьФайлы(Команда)
	
	УстановитьДействиеДляВыбранныхОбъектов(
		ПредопределенноеЗначение("Перечисление.ВариантыОчисткиФайлов.ОчиститьФайлы"));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДействиеОчиститьФайлыИВерсии(Команда)
	
	УстановитьДействиеДляВыбранныхОбъектов(
		ПредопределенноеЗначение("Перечисление.ВариантыОчисткиФайлов.ОчиститьФайлыИВерсии"));
	
КонецПроцедуры

&НаКлиенте
Процедура СтаршеМесяца(Команда)
	УстановитьПериодОчисткиДляВыбранныхОбъектов(
		ПредопределенноеЗначение("Перечисление.ПериодОчисткиФайлов.СтаршеМесяца"));
КонецПроцедуры

&НаКлиенте
Процедура СтаршеШестиМесяцев(Команда)
	УстановитьПериодОчисткиДляВыбранныхОбъектов(
		ПредопределенноеЗначение("Перечисление.ПериодОчисткиФайлов.СтаршеШестиМесяцев"));
КонецПроцедуры

&НаКлиенте
Процедура СтаршеГода(Команда)
	УстановитьПериодОчисткиДляВыбранныхОбъектов(
		ПредопределенноеЗначение("Перечисление.ПериодОчисткиФайлов.СтаршеГода"));
КонецПроцедуры

&НаКлиенте
Процедура Очистить(Команда)
	ПрерватьФоновоеЗадание();
	ЗапуститьРегламентноеЗадание();
	УстановитьВидимостьКомандыОчистить();
	ПодключитьОбработчикОжидания("ПроверитьВыполнениеФоновогоЗадания", 2, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьНастройку(Команда)
	
	СтрокаДерева = Элементы.ДеревоОбъектовМетаданных.ТекущиеДанные;
	Если Не СтрокаДерева.ВозможностьДетализации Тогда
		ТекстСообщения = НСтр("ru = 'Добавление настройки возможно только для иерархических справочников'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	ПараметрыФормыВыбора = Новый Структура;
	
	ПараметрыФормыВыбора.Вставить("ВыборГруппИЭлементов", ИспользованиеГруппИЭлементов.ГруппыИЭлементы);
	ПараметрыФормыВыбора.Вставить("ЗакрыватьПриВыборе", Истина);
	ПараметрыФормыВыбора.Вставить("ЗакрыватьПриЗакрытииВладельца", Истина);
	ПараметрыФормыВыбора.Вставить("МножественныйВыбор", Истина);
	ПараметрыФормыВыбора.Вставить("РежимВыбора", Истина);
	
	ПараметрыФормыВыбора.Вставить("РежимОткрытияОкна", РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ПараметрыФормыВыбора.Вставить("ВыборГрупп", Истина);
	ПараметрыФормыВыбора.Вставить("ВыборГруппПользователей", Истина);
	
	ПараметрыФормыВыбора.Вставить("РасширенныйПодбор", Истина);
	ПараметрыФормыВыбора.Вставить("ЗаголовокФормыПодбора", НСтр("ru = 'Подбор элементов настроек'"));
	
	// Исключим из списка выбора уже существующие настройки
	СуществующиеНастройки = СтрокаДерева.ПолучитьЭлементы();
	ФиксированныеНастройки = Новый НастройкиКомпоновкиДанных;
	ЭлементНастройки = ФиксированныеНастройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементНастройки.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Ссылка");
	ЭлементНастройки.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСписке;
	СписокСуществующих = Новый Массив;
	Для Каждого Настройка Из СуществующиеНастройки Цикл
		СписокСуществующих.Добавить(Настройка.ВладелецФайла);
	КонецЦикла;
	ЭлементНастройки.ПравоеЗначение = СписокСуществующих;
	ЭлементНастройки.Использование = Истина;
	ЭлементНастройки.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	ПараметрыФормыВыбора.Вставить("ФиксированныеНастройки", ФиксированныеНастройки);
	
	ОткрытьФорму(ПутьФормыВыбора(СтрокаДерева.ВладелецФайла), ПараметрыФормыВыбора, Элементы.ДеревоОбъектовМетаданных);
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьНастройку(Команда)
	
	ОчиститьДанныеНастройки();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПутьФормыВыбора(ВладелецФайла)
	
	ОбъектМетаданных = ОбщегоНазначения.ОбъектМетаданныхПоИдентификатору(ВладелецФайла);
	Возврат ОбъектМетаданных.ПолноеИмя() + ".ФормаВыбора";
	
КонецФункции

&НаКлиенте
Процедура УстановитьВидимостьКомандыОчистить()
	
	ПодчиненныеСтраницы = Элементы.ОчисткаФайлов.ПодчиненныеЭлементы;
	Если ПустаяСтрока(ТекущееФоновоеЗадание) Тогда
		Элементы.ОчисткаФайлов.ТекущаяСтраница = ПодчиненныеСтраницы.Очистка;
	Иначе
		Элементы.ОчисткаФайлов.ТекущаяСтраница = ПодчиненныеСтраницы.СтатусФоновогоЗадания;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСпискиВыбора()
	
	СписокВыбораСВерсиями = Новый СписокЗначений;
	СписокВыбораСВерсиями.Добавить(Перечисления.ВариантыОчисткиФайлов.ОчиститьФайлыИВерсии);
	СписокВыбораСВерсиями.Добавить(Перечисления.ВариантыОчисткиФайлов.ОчиститьВерсии);
	СписокВыбораСВерсиями.Добавить(Перечисления.ВариантыОчисткиФайлов.НеОчищать);
	
	СписокВыбораБезВерсий = Новый СписокЗначений;
	СписокВыбораБезВерсий.Добавить(Перечисления.ВариантыОчисткиФайлов.ОчиститьФайлы);
	СписокВыбораБезВерсий.Добавить(Перечисления.ВариантыОчисткиФайлов.НеОчищать);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСписокВыбора(Элемент)
	
	СтрокаДерева = Элементы.ДеревоОбъектовМетаданных.ТекущиеДанные;
	
	Элемент.СписокВыбора.Очистить();
	
	Если СтрокаДерева.ЭтоФайл Тогда
		СписокВыбора = СписокВыбораСВерсиями;
	Иначе
		СписокВыбора = СписокВыбораБезВерсий;
	КонецЕсли;
	
	Для Каждого ЭлементСписка Из СписокВыбора Цикл
		Элемент.СписокВыбора.Добавить(ЭлементСписка.Значение);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТипыОбъектовВДеревеЗначений()
	
	НастройкиОчистки = РегистрыСведений.НастройкиОчисткиФайлов.ТекущиеНастройкиОчистки();
	
	ДеревоОМ = РеквизитФормыВЗначение("ДеревоОбъектовМетаданных");
	ДеревоОМ.Строки.Очистить();
	
	МетаданныеСправочники = Метаданные.Справочники;
	
	ТаблицаТипов = Новый ТаблицаЗначений;
	ТаблицаТипов.Колонки.Добавить("ВладелецФайла");
	ТаблицаТипов.Колонки.Добавить("ТипВладельцаФайла");
	ТаблицаТипов.Колонки.Добавить("ЭтоФайл", Новый ОписаниеТипов("Булево"));
	ТаблицаТипов.Колонки.Добавить("ВозможностьДетализации"  , Новый ОписаниеТипов("Булево"));
	
	ВидИерархииГруппИЭлементов = Метаданные.СвойстваОбъектов.ВидИерархии.ИерархияГруппИЭлементов;
	МассивИсключений = ФайловыеФункцииСлужебный.ОбъектыИсключенияПриОчисткеФайлов();
	
	Для Каждого Справочник Из МетаданныеСправочники Цикл
		Если Справочник.Реквизиты.Найти("ВладелецФайла") <> Неопределено Тогда
			ТипыВладельцевФайлов = Справочник.Реквизиты.ВладелецФайла.Тип.Типы();
			Для Каждого ТипВладельца Из ТипыВладельцевФайлов Цикл
				
				Если МассивИсключений.Найти(Справочник) <> Неопределено Тогда
					Продолжить;
				КонецЕсли;
				
				НоваяСтрока = ТаблицаТипов.Добавить();
				НоваяСтрока.ВладелецФайла = ТипВладельца;
				НоваяСтрока.ТипВладельцаФайла = Справочник;
				МетаданныеВладельца = Метаданные.НайтиПоТипу(ТипВладельца);
				Если МетаданныеСправочники.Найти(МетаданныеВладельца.Имя) <> Неопределено И МетаданныеВладельца.Иерархический Тогда
					НоваяСтрока.ВозможностьДетализации = Истина;
				КонецЕсли;
				Если Не СтрЗаканчиваетсяНа(Справочник.Имя, "ПрисоединенныеФайлы") Тогда
					НоваяСтрока.ЭтоФайл = Истина;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	ВсеСправочники = Справочники.ТипВсеСсылки();
	
	ВсеДокументы = Документы.ТипВсеСсылки();
	УзелСправочники = Неопределено;
	УзелДокументы = Неопределено;
	УзелБизнесПроцессы = Неопределено;
	
	Для Каждого Тип Из ТаблицаТипов Цикл
		Если ВсеСправочники.СодержитТип(Тип.ВладелецФайла) Тогда
			Если УзелСправочники = Неопределено Тогда
				УзелСправочники = ДеревоОМ.Строки.Добавить();
				УзелСправочники.СинонимНаименованияОбъекта = НСтр("ru = 'Справочники'");
			КонецЕсли;
			НоваяСтрокаТаблицы = УзелСправочники.Строки.Добавить();
			ИдентификаторОбъекта = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Тип.ВладелецФайла);
			ДетализированныеНастройки = НастройкиОчистки.НайтиСтроки(Новый Структура(
				"ИдентификаторВладельца",
				ИдентификаторОбъекта));
			Если ДетализированныеНастройки.Количество() > 0 Тогда
				Для Каждого Настройка Из ДетализированныеНастройки Цикл
					ДетализированнаяНастройка = НоваяСтрокаТаблицы.Строки.Добавить();
					ДетализированнаяНастройка.ВладелецФайла = Настройка.ВладелецФайла;
					ДетализированнаяНастройка.ТипВладельцаФайла = Настройка.ТипВладельцаФайла;
					ДетализированнаяНастройка.СинонимНаименованияОбъекта = Настройка.ВладелецФайла;
					ДетализированнаяНастройка.Действие = Настройка.Действие;
					ПредставлениеОтбора = "";
					ПравилоОтбора = Настройка.ПравилоОтбора.Получить();
					ДетализированнаяНастройка.ПравилоОтбора = "Изменить";
					ДетализированнаяНастройка.ПериодОчистки = Настройка.ПериодОчистки;
					ДетализированнаяНастройка.ЭтоФайл = Настройка.ЭтоФайл;
				КонецЦикла;
			КонецЕсли;
		ИначеЕсли ВсеДокументы.СодержитТип(Тип.ВладелецФайла) Тогда
			Если УзелДокументы = НеОпределено Тогда
				УзелДокументы = ДеревоОМ.Строки.Добавить();
				УзелДокументы.СинонимНаименованияОбъекта = НСтр("ru = 'Документы'");
			КонецЕсли;
			НоваяСтрокаТаблицы = УзелДокументы.Строки.Добавить();
		ИначеЕсли БизнесПроцессы.ТипВсеСсылки().СодержитТип(Тип.ВладелецФайла) Тогда
			Если УзелБизнесПроцессы = Неопределено Тогда
				УзелБизнесПроцессы = ДеревоОМ.Строки.Добавить();
				УзелБизнесПроцессы.СинонимНаименованияОбъекта = НСтр("ru = 'Бизнес-процессы'");
			КонецЕсли;
			НоваяСтрокаТаблицы = УзелБизнесПроцессы.Строки.Добавить();
		КонецЕсли;
		МетаданныеОбъекта = Метаданные.НайтиПоТипу(Тип.ВладелецФайла);
		НоваяСтрокаТаблицы.ВладелецФайла = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Тип.ВладелецФайла);
		НоваяСтрокаТаблицы.ТипВладельцаФайла = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Тип.ТипВладельцаФайла);
		НоваяСтрокаТаблицы.СинонимНаименованияОбъекта = МетаданныеОбъекта.Синоним;
		НоваяСтрокаТаблицы.ПравилоОтбора = "Изменить";
		НоваяСтрокаТаблицы.ЭтоФайл = Тип.ЭтоФайл;
		НоваяСтрокаТаблицы.ВозможностьДетализации = Тип.ВозможностьДетализации;
		
		НайденныеНастройки = НастройкиОчистки.НайтиСтроки(Новый Структура("ВладелецФайла", НоваяСтрокаТаблицы.ВладелецФайла));
		Если НайденныеНастройки.Количество() > 0 Тогда
			НоваяСтрокаТаблицы.Действие = НайденныеНастройки[0].Действие;
			НоваяСтрокаТаблицы.ПериодОчистки = НайденныеНастройки[0].ПериодОчистки;
		Иначе
			НоваяСтрокаТаблицы.Действие = Перечисления.ВариантыОчисткиФайлов.НеОчищать;
			НоваяСтрокаТаблицы.ПериодОчистки = Перечисления.ПериодОчисткиФайлов.СтаршеГода;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого УзелВерхнегоУровня Из ДеревоОМ.Строки Цикл
		УзелВерхнегоУровня.Строки.Сортировать("СинонимНаименованияОбъекта");
	КонецЦикла;
	ЗначениеВРеквизитФормы(ДеревоОМ, "ДеревоОбъектовМетаданных");
	
КонецПроцедуры

&НаСервере
Функция ТекущееРасписание()
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		ОбластьДанных = ОбщегоНазначения.ЗначениеРазделителяСеанса();
		ИмяМетода = Метаданные.РегламентныеЗадания.ОчисткаНенужныхФайлов.ИмяМетода;
		
		ПараметрыЗадания = Новый Структура;
		ПараметрыЗадания.Вставить("ИмяМетода", ИмяМетода);
		ПараметрыЗадания.Вставить("ОбластьДанных", ОбластьДанных);
		
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.ОчередьЗаданий") Тогда
			МодульОчередьЗаданий = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданий");
			
			УстановитьПривилегированныйРежим(Истина);
			
			СписокЗаданий = МодульОчередьЗаданий.ПолучитьЗадания(ПараметрыЗадания);
			Для Каждого Задание Из СписокЗаданий Цикл
				Возврат Задание.Расписание;
			КонецЦикла;
		
			Возврат Новый РасписаниеРегламентногоЗадания;
		КонецЕсли;
	Иначе
		Возврат РегламентныеЗадания.НайтиПредопределенное(Метаданные.РегламентныеЗадания.ОчисткаНенужныхФайлов).Расписание;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура НастроитьРасписаниеЗавершение(Расписание, ДополнительныеПараметры) Экспорт
	Если Расписание = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьРасписаниеРегламентногоЗадания(Расписание);
	Элементы.Расписание.Заголовок = Расписание;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьРасписаниеРегламентногоЗадания(Расписание);
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		ОбластьДанных = ОбщегоНазначения.ЗначениеРазделителяСеанса();
		ИмяМетода = Метаданные.РегламентныеЗадания.ОчисткаНенужныхФайлов.ИмяМетода;
		
		ПараметрыЗадания = Новый Структура;
		ПараметрыЗадания.Вставить("ИмяМетода", ИмяМетода);
		ПараметрыЗадания.Вставить("ОбластьДанных", ОбластьДанных);
		
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.ОчередьЗаданий") Тогда
			МодульОчередьЗаданий = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданий");
			
			УстановитьПривилегированныйРежим(Истина);
			
			СписокЗаданий = МодульОчередьЗаданий.ПолучитьЗадания(ПараметрыЗадания);
			Если СписокЗаданий.Количество() = 0 Тогда
				ПараметрыЗадания.Вставить("Расписание", Расписание);
				МодульОчередьЗаданий.ДобавитьЗадание(ПараметрыЗадания);
			Иначе
				ПараметрыЗадания = Новый Структура("Расписание", Расписание);
				Для Каждого Задание Из СписокЗаданий Цикл
					МодульОчередьЗаданий.ИзменитьЗадание(Задание.Идентификатор, ПараметрыЗадания);
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
	Иначе
		РегламентноеЗадание = РегламентныеЗадания.НайтиПредопределенное(Метаданные.РегламентныеЗадания.ОчисткаНенужныхФайлов);
		РегламентноеЗадание.Расписание = Расписание;
		РегламентноеЗадание.Записать();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВключитьОтключитьРегламентноеЗадание(Использование)
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		ОбластьДанных = ОбщегоНазначения.ЗначениеРазделителяСеанса();
		ИмяМетода = Метаданные.РегламентныеЗадания.ОчисткаНенужныхФайлов.ИмяМетода;
		
		ПараметрыЗадания = Новый Структура;
		ПараметрыЗадания.Вставить("ИмяМетода", ИмяМетода);
		ПараметрыЗадания.Вставить("ОбластьДанных", ОбластьДанных);
		
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.ОчередьЗаданий") Тогда
			МодульОчередьЗаданий = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданий");
			
			УстановитьПривилегированныйРежим(Истина);
			
			СписокЗаданий = МодульОчередьЗаданий.ПолучитьЗадания(ПараметрыЗадания);
			Если СписокЗаданий.Количество() = 0 Тогда
				ПараметрыЗадания.Вставить("Использование", Использование);
				МодульОчередьЗаданий.ДобавитьЗадание(ПараметрыЗадания);
			Иначе
				ПараметрыЗадания = Новый Структура("Использование", Использование);
				Для Каждого Задание Из СписокЗаданий Цикл
					МодульОчередьЗаданий.ИзменитьЗадание(Задание.Идентификатор, ПараметрыЗадания);
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
	Иначе
		РегламентноеЗадание = РегламентныеЗадания.НайтиПредопределенное(Метаданные.РегламентныеЗадания.ОчисткаНенужныхФайлов);
		РегламентноеЗадание.Использование = Не РегламентноеЗадание.Использование;
		РегламентноеЗадание.Записать();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПериодОчисткиДляВыбранныхОбъектов(ПериодОчистки)
	
	Для Каждого ИдентификаторСтроки Из Элементы.ДеревоОбъектовМетаданных.ВыделенныеСтроки Цикл
		ЭлементДерева = ДеревоОбъектовМетаданных.НайтиПоИдентификатору(ИдентификаторСтроки);
		Если ЭлементДерева.ПолучитьРодителя() = Неопределено Тогда
			Для Каждого ПодчиненныйЭлементДерева Из ЭлементДерева.ПолучитьЭлементы() Цикл
				УстановитьПериодОчисткиДляВыбранногоОбъекта(ПодчиненныйЭлементДерева, ПериодОчистки);
			КонецЦикла;
		Иначе
			УстановитьПериодОчисткиДляВыбранногоОбъекта(ЭлементДерева, ПериодОчистки);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПериодОчисткиДляВыбранногоОбъекта(ВыбранныйОбъект, ПериодОчистки)
	
	ВыбранныйОбъект.ПериодОчистки = ПериодОчистки;
	ЗаписатьТекущиеНастройкиПоОбъекту(
		ВыбранныйОбъект.ВладелецФайла,
		ВыбранныйОбъект.ТипВладельцаФайла,
		ВыбранныйОбъект.Действие,
		ПериодОчистки,
		ВыбранныйОбъект.ЭтоФайл);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДействиеДляВыбранныхОбъектов(Знач Действие)
	
	Для Каждого ИдентификаторСтроки Из Элементы.ДеревоОбъектовМетаданных.ВыделенныеСтроки Цикл
		ЭлементДерева = ДеревоОбъектовМетаданных.НайтиПоИдентификатору(ИдентификаторСтроки);
		Если ЭлементДерева.ПолучитьРодителя() = Неопределено Тогда 
			Для Каждого ПодчиненныйЭлементДерева Из ЭлементДерева.ПолучитьЭлементы() Цикл
				УстановитьДействиеВыбранногоОбъекта(ПодчиненныйЭлементДерева, Действие);
			КонецЦикла;
		Иначе
			УстановитьДействиеВыбранногоОбъекта(ЭлементДерева, Действие);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДействиеВыбранногоОбъекта(ВыбранныйОбъект, Действие)
	
	ВыбранныйОбъект.Действие = Действие;
	ЗаписатьТекущиеНастройкиПоОбъекту(
		ВыбранныйОбъект.ВладелецФайла,
		ВыбранныйОбъект.ТипВладельцаФайла,
		Действие,
		ВыбранныйОбъект.ПериодОчистки,
		ВыбранныйОбъект.ЭтоФайл);
	
	КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьТекущиеНастройки()
	
	ТекущиеДанные = Элементы.ДеревоОбъектовМетаданных.ТекущиеДанные;
	ЗаписатьТекущиеНастройкиПоОбъекту(
		ТекущиеДанные.ВладелецФайла,
		ТекущиеДанные.ТипВладельцаФайла,
		ТекущиеДанные.Действие,
		ТекущиеДанные.ПериодОчистки,
		ТекущиеДанные.ЭтоФайл);
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьТекущиеНастройкиПоОбъекту(ВладелецФайла, ТипВладельцаФайла, Действие, ПериодОчистки, ЭтоФайл)
	Настройка = РегистрыСведений.НастройкиОчисткиФайлов.СоздатьМенеджерЗаписи();
	Настройка.ВладелецФайла = ВладелецФайла;
	Настройка.ТипВладельцаФайла = ТипВладельцаФайла;
	Настройка.Действие = Действие;
	Настройка.ПериодОчистки = ПериодОчистки;
	Настройка.ЭтоФайл = ЭтоФайл;
	Настройка.Записать();
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуНастроек();
	
	ТекущиеДанные = Элементы.ДеревоОбъектовМетаданных.ТекущиеДанные;
	
	Если ТекущиеДанные.ПериодОчистки <> ПредопределенноеЗначение("Перечисление.ПериодОчисткиФайлов.ПоПравилу") Тогда
		Возврат;
	КонецЕсли;
	
	Отбор = Новый Структура(
		"ВладелецФайла, ТипВладельцаФайла",
		ТекущиеДанные.ВладелецФайла,
		ТекущиеДанные.ТипВладельцаФайла);
	
	ТипЗначения = Тип("РегистрСведенийКлючЗаписи.НастройкиОчисткиФайлов");
	ПараметрыЗаписи = Новый Массив(1);
	ПараметрыЗаписи[0] = Отбор;
	
	КлючЗаписи = Новый(ТипЗначения, ПараметрыЗаписи);
	
	ПараметрыЗаписи = Новый Структура;
	ПараметрыЗаписи.Вставить("Ключ", КлючЗаписи);
	
	ОткрытьФорму("РегистрСведений.НастройкиОчисткиФайлов.ФормаЗаписи", ПараметрыЗаписи, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрерватьФоновоеЗадание()
	ОтменитьВыполнениеЗадания(ИдентификаторФоновогоЗадания);
	ОтключитьОбработчикОжидания("ПроверитьВыполнениеФоновогоЗадания");
	ТекущееФоновоеЗадание = "";
	ИдентификаторФоновогоЗадания = "";
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОтменитьВыполнениеЗадания(ИдентификаторФоновогоЗадания)
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторФоновогоЗадания);
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВыполнениеФоновогоЗадания()
	Если Не ЗаданиеВыполнено(ИдентификаторФоновогоЗадания) Тогда
		ПодключитьОбработчикОжидания("ПроверитьВыполнениеФоновогоЗадания", 5, Истина);
	Иначе
		ИдентификаторФоновогоЗадания = "";
		ТекущееФоновоеЗадание = "";
		УстановитьВидимостьКомандыОчистить();
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторФоновогоЗадания)
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторФоновогоЗадания);
КонецФункции

&НаСервере
Процедура ЗапуститьРегламентноеЗадание()
	
	РегламентноеЗадание = РегламентныеЗадания.НайтиПредопределенное(Метаданные.РегламентныеЗадания.ОчисткаНенужныхФайлов);
	
	Отбор = Новый Структура;
	Отбор.Вставить("РегламентноеЗадание", РегламентноеЗадание);
	Отбор.Вставить("Состояние", СостояниеФоновогоЗадания.Активно);
	ФоновыеЗаданияОчистки = ФоновыеЗадания.ПолучитьФоновыеЗадания(Отбор);
	Если ФоновыеЗаданияОчистки.Количество() > 0 Тогда
		ИдентификаторФоновогоЗадания = ФоновыеЗаданияОчистки[0].УникальныйИдентификатор;
	Иначе
		НаименованиеФоновогоЗадания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Запуск вручную: %1'"), РегламентноеЗадание.Метаданные.Синоним);
		
		ФоновоеЗадание = ФоновыеЗадания.Выполнить(
			РегламентноеЗадание.Метаданные.ИмяМетода,
			РегламентноеЗадание.Параметры,
			Строка(РегламентноеЗадание.УникальныйИдентификатор),
			НаименованиеФоновогоЗадания);
			
		ИдентификаторФоновогоЗадания = ФоновоеЗадание.УникальныйИдентификатор;
	КонецЕсли;
	
	ТекущееФоновоеЗадание = "Очистка";
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьНастройкиПоВладельцу(ВыбранноеЗначение)
	
	СтрокаВладелец = ДеревоОбъектовМетаданных.НайтиПоИдентификатору(Элементы.ДеревоОбъектовМетаданных.ТекущаяСтрока);
	
	ЗаписьВладельца = РегистрыСведений.НастройкиОчисткиФайлов.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(ЗаписьВладельца, СтрокаВладелец);
	ЗаписьВладельца.Записать();
	
	ЭлементВладелец = СтрокаВладелец.ПолучитьЭлементы();
	Для Каждого Настройка Из ВыбранноеЗначение Цикл
		НоваяЗапись = РегистрыСведений.НастройкиОчисткиФайлов.СоздатьМенеджерЗаписи();
		НоваяЗапись.ВладелецФайла = Настройка;
		НоваяЗапись.ТипВладельцаФайла = СтрокаВладелец.ТипВладельцаФайла;
		НоваяЗапись.Действие = Перечисления.ВариантыОчисткиФайлов.НеОчищать;
		НоваяЗапись.ПериодОчистки = Перечисления.ПериодОчисткиФайлов.СтаршеГода;
		НоваяЗапись.ЭтоФайл = СтрокаВладелец.ЭтоФайл;
		НоваяЗапись.Записать(Истина);

		ДетализированнаяНастройка = ЭлементВладелец.Добавить();
		ЗаполнитьЗначенияСвойств(ДетализированнаяНастройка, НоваяЗапись);
		ДетализированнаяНастройка.СинонимНаименованияОбъекта = Настройка;
		ДетализированнаяНастройка.ПравилоОтбора = НСтр("ru = 'Изменить правило'");
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьДанныеНастройки()
	
	НастройкаДляУдаления = ДеревоОбъектовМетаданных.НайтиПоИдентификатору(Элементы.ДеревоОбъектовМетаданных.ТекущаяСтрока);
	
	МенеджерЗаписи = РегистрыСведений.НастройкиОчисткиФайлов.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.ВладелецФайла = НастройкаДляУдаления.ВладелецФайла;
	МенеджерЗаписи.ТипВладельцаФайла = НастройкаДляУдаления.ТипВладельцаФайла;
	МенеджерЗаписи.Прочитать();
	МенеджерЗаписи.Удалить();
	
	РодительЭлементаНастроек = НастройкаДляУдаления.ПолучитьРодителя();
	Если РодительЭлементаНастроек <> Неопределено Тогда
		РодительЭлементаНастроек.ПолучитьЭлементы().Удалить(НастройкаДляУдаления);
	Иначе
		ДеревоОбъектовМетаданных.ПолучитьЭлементы().Удалить(НастройкаДляУдаления);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция АвтоматическаяОчисткаВключена()
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		ОбластьДанных = ОбщегоНазначения.ЗначениеРазделителяСеанса();
		ИмяМетода = Метаданные.РегламентныеЗадания.ОчисткаНенужныхФайлов.ИмяМетода;
		
		ПараметрыЗадания = Новый Структура;
		ПараметрыЗадания.Вставить("ИмяМетода", ИмяМетода);
		ПараметрыЗадания.Вставить("ОбластьДанных", ОбластьДанных);
		
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.ОчередьЗаданий") Тогда
			МодульОчередьЗаданий = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданий");
			
			УстановитьПривилегированныйРежим(Истина);
			
			СписокЗаданий = МодульОчередьЗаданий.ПолучитьЗадания(ПараметрыЗадания);
			Для Каждого Задание Из СписокЗаданий Цикл
				Возврат Задание.Использование;
			КонецЦикла;
		КонецЕсли;
	Иначе
		Возврат РегламентныеЗадания.НайтиПредопределенное(Метаданные.РегламентныеЗадания.ОчисткаНенужныхФайлов).Использование;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти
