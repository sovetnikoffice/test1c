﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Ошибка,
		, , Параметры.ПодробноеСообщениеОбОшибке);
	
	ТекстСообщенияОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'При обновлении версии программы возникла ошибка:
		|
		|%1'"),
		Параметры.КраткоеСообщениеОбОшибке);
	
	Элементы.ТекстСообщенияОбОшибке.Заголовок = ТекстСообщенияОбОшибке;
	
	ВремяНачалаОбновления = Параметры.ВремяНачалаОбновления;
	ВремяОкончанияОбновления = ТекущаяДатаСеанса();
	
	Если Не Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
		Элементы.ФормаОткрытьВнешнююОбработку.Видимость = Ложь;
	КонецЕсли;
	
	ИспользуютсяПрофилиБезопасности = ПолучитьФункциональнуюОпцию("ИспользуютсяПрофилиБезопасности");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПоказатьСведенияОРезультатахОбновленияНажатие(Элемент)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ДатаНачала", ВремяНачалаОбновления);
	ПараметрыФормы.Вставить("ДатаОкончания", ВремяОкончанияОбновления);
	ПараметрыФормы.Вставить("ЗапускатьНеВФоне", Истина);
	
	ОткрытьФорму("Обработка.ЖурналРегистрации.Форма.ЖурналРегистрации", ПараметрыФормы,,,,,, РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗавершитьРаботу(Команда)
	Закрыть(Истина);
КонецПроцедуры

&НаКлиенте
Процедура ПерезагрузитьПрограмму(Команда)
	Закрыть(Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВнешнююОбработку(Команда)
	
	Если ИспользуютсяПрофилиБезопасности Тогда
		
		ОткрытьФорму(
			"Обработка.НастройкаРазрешенийНаИспользованиеВнешнихРесурсов.Форма.ОткрытиеВнешнейОбработкиИлиОтчетаСВыборомБезопасногоРежима",
			,
			ЭтотОбъект,
			,
			,
			,
			,
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
		Возврат;
		
	КонецЕсли;
	
#Если ВебКлиент Тогда
	Оповещение = Новый ОписаниеОповещения("ОткрытьВнешнююОбработкуБезРасширения", ЭтотОбъект);
	НачатьПомещениеФайла(Оповещение,,, Истина, УникальныйИдентификатор);
	Возврат;
#КонецЕсли
	
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогОткрытияФайла.Фильтр = НСтр("ru = 'Внешняя обработка'") + "(*.epf)|*.epf";
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выберите внешнюю обработку'");
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьВнешнююОбработкуЗавершение", ЭтотОбъект);
	ДиалогОткрытияФайла.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВнешнююОбработкуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено
		И Результат.Количество() = 1 Тогда
		ПолноеИмяФайла = Результат[0];
		ВыбраннаяОбработка = Новый ДвоичныеДанные(ПолноеИмяФайла);
		АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(ВыбраннаяОбработка, УникальныйИдентификатор);
		ИмяВнешнейОбработки = ПодключитьВнешнююОбработку(АдресВоВременномХранилище);
		ОткрытьФорму(ИмяВнешнейОбработки + ".Форма");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВнешнююОбработкуБезРасширения(Результат, Адрес, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт
	
	Если Результат Тогда
		ИмяВнешнейОбработки = ПодключитьВнешнююОбработку(Адрес);
		ОткрытьФорму(ИмяВнешнейОбработки + ".Форма",, ЭтотОбъект,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПодключитьВнешнююОбработку(АдресВоВременномХранилище)
	Если Не Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
		ВызватьИсключение НСтр("ru = 'Недостаточно прав доступа.'");
	КонецЕсли;
	ВыбраннаяОбработка = ПолучитьИзВременногоХранилища(АдресВоВременномХранилище);
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла("epf");
	ВыбраннаяОбработка.Записать(ИмяВременногоФайла);
	Возврат ВнешниеОбработки.Создать(ИмяВременногоФайла, Ложь).Метаданные().ПолноеИмя();
КонецФункции

#КонецОбласти
