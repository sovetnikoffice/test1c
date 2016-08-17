﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	АдресПубликацииИнформационнойБазыВИнтернете = Взаимодействия.АдресПубликацииИнформационнойБазыВИнтернете();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	СформироватьАдресСсылки();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура АдресПубликацииИнформационнойБазыВИнтернетеПриИзменении(Элемент)
	
	СформироватьАдресСсылки();

КонецПроцедуры

&НаКлиенте
Процедура СсылкаНаОбъектПриИзменении(Элемент)
	
	СформироватьАдресСсылки();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Вставить(Команда)
	
	ОчиститьСообщения();
	
	Отказ = Ложь;
	
	Если ПустаяСтрока(АдресПубликацииИнформационнойБазыВИнтернете) Тогда
		
		ТекстСообщения = НСтр("ru = 'Не указан адрес публикации информационной базы в интернете.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "АдресПубликацииИнформационнойБазыВИнтернете",, Отказ);
		
	КонецЕсли;
	
	Если ПустаяСтрока(СсылкаНаОбъект) Тогда
		
		ТекстСообщения = НСтр("ru = 'Не указана внутренняя ссылка на объект.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "СсылкаНаОбъект",, Отказ);
		
	КонецЕсли;
	
	Если Не Отказ Тогда
		ОповеститьОВыборе(СформированнаяСсылка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СформироватьАдресСсылки()

	СформированнаяСсылка = АдресПубликацииИнформационнойБазыВИнтернете + "#"+ СсылкаНаОбъект;

КонецПроцедуры

#КонецОбласти
