﻿&НаКлиенте
Перем ОтветПередЗакрытием;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("Создание", Создание);
	
	Если Параметры.ВидДанных = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Код = Параметры.ВидДанных.Код;
	Наименование = Параметры.ВидДанных.Наименование;
	Задержка = Параметры.ВидДанных.Задержка;
	ЗапретУведомления = Параметры.ВидДанных.ЗапретУведомления;
	Характеристики.Очистить();
	Для Каждого Характеристика Из Параметры.ВидДанных.Характеристики Цикл
		НоваяХарактеристика = Характеристики.Добавить();
		НоваяХарактеристика.Код = Характеристика.Код;
		НоваяХарактеристика.Наименование = Характеристика.Наименование;
		НоваяХарактеристика.Ключевая = Характеристика.Ключевая;
	КонецЦикла;
	
	Если Создание Тогда
		Заголовок = НСтр("ru = 'Вид поставляемых данных (создание)'");
	Иначе
		Заголовок = Наименование + НСтр("ru = '(Вид поставляемых данных)'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если Не Модифицированность Тогда
		Возврат;
	КонецЕсли;
	
	Если ОтветПередЗакрытием <> Истина Тогда
		Отказ = Истина;
		ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, НСтр("ru = 'Данные были изменены. Сохранить изменения?'"), 
			РежимДиалогаВопрос.ДаНетОтмена, , КодВозвратаДиалога.Да);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(Ответ, ДополнительныеПараметры) Экспорт	
	
	Если Ответ = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда
		ОтветПередЗакрытием = Истина;
	    Закрыть();
		Возврат;
	ИначеЕсли Ответ = КодВозвратаДиалога.Да Тогда
		Если СохранитьДанные() Тогда
			ОтветПередЗакрытием = Истина;
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	СохранитьДанные();
	
КонецПроцедуры

&НаКлиенте
Функция СохранитьДанные()
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Модифицированность = Ложь;
	
	ВыбранноеЗначение = Новый Структура("Код, Наименование, Задержка, ЗапретУведомления, Характеристики, Создание");
	ЗаполнитьЗначенияСвойств(ВыбранноеЗначение, ЭтотОбъект);
	ОповеститьОВыборе(ВыбранноеЗначение);
	Возврат Истина;
	
КонецФункции

#КонецОбласти
