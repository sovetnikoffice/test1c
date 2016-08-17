﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// См. описание в комментарии к одноименной процедуре в модуле УправлениеДоступом.
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	
	// Логика ограничения:
	// Чтения:    Организация И МестоХранения
	// Изменения: Организация И МестоХранения И Ответственный
	
	// Чтение: набор №1.
	Строка = Таблица.Добавить();
	Строка.НомерНабора     = 1;
	Строка.Чтение          = Истина;
	Строка.ЗначениеДоступа = Организация;
	
	Строка = Таблица.Добавить();
	Строка.НомерНабора     = 1;
	Строка.ЗначениеДоступа = МестоХранения;
	
	// Изменение: набор №2.
	Строка = Таблица.Добавить();
	Строка.НомерНабора     = 2;
	Строка.Изменение       = Истина;
	Строка.ЗначениеДоступа = Организация;
	
	Строка = Таблица.Добавить();
	Строка.НомерНабора     = 2;
	Строка.ЗначениеДоступа = МестоХранения;
	
	Строка = Таблица.Добавить();
	Строка.НомерНабора     = 2;
	Строка.ЗначениеДоступа = Ответственный;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	Если ДанныеЗаполнения = Неопределено Тогда // Ввод нового.
		_ДемоСтандартныеПодсистемы.ПриВводеНовогоЗаполнитьОрганизацию(ЭтотОбъект);
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	СформироватьДвиженияПоМестамХранения();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
//

Процедура СформироватьДвиженияПоМестамХранения()
	
	Движения._ДемоОстаткиТоваровВМестахХранения.Записывать = Истина;
	
	Для Каждого СтрокаТовары Из Товары Цикл
		
		Движение = Движения._ДемоОстаткиТоваровВМестахХранения.Добавить();
		
		Движение.Период        = Дата;
		Движение.ВидДвижения   = ВидДвиженияНакопления.Расход;
		
		Движение.Организация   = Организация;
		Движение.МестоХранения = МестоХранения;
		
		Движение.Номенклатура  = СтрокаТовары.Номенклатура;
		Движение.Количество    = СтрокаТовары.Количество;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли