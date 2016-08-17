﻿////////////////////////////////////////////////////////////////////////////////
// Проверка одного или нескольких контрагентов при помощи веб-сервиса ФНС.
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Функция - Определение по состоянию, является ли контрагент действующим.
//
// Параметры:
//  Состояние					 - Перечисления.СостоянияСуществованияКонтрагента - Состояние контрагента.
//  ДополнятьСостояниемСОшибкой	 - Булево - Если Истина, то контрагент с ошибкой считается действующим.
//  ДополнятьПустымСостоянием	 - Булево - Если Истина, то контрагент с пустым состоянием считается действующим.
// Возвращаемое значение:
//  Булево - Является ли контрагент действующим.
//
Функция ЭтоСостояниеДействующегоКонтрагента(Состояние, ДополнятьСостояниемСОшибкой = Истина, ДополнятьПустымСостоянием = Истина) Экспорт
	
	СостоянияДействующегоКонтрагента = ПроверкаКонтрагентовКлиентСерверПовтИсп.СостоянияДействующегоКонтрагента(
		ДополнятьСостояниемСОшибкой, ДополнятьПустымСостоянием);
	Возврат СостоянияДействующегоКонтрагента.Найти(Состояние) <> Неопределено;
			
КонецФункции

// Функция - Перечень состояний действующего контрагента.
//
// Параметры:
//  ДополнятьСостояниемСОшибкой	 - Булево - Если Истина, то контрагент с ошибкой считается действующим.
//  ДополнятьПустымСостоянием	 - Булево - Если Истина, то контрагент с пустым состоянием считается действующим.
// Возвращаемое значение:
// Массив - Состояния контрагента, при которых он является действующим.
//
Функция СостоянияДействующегоКонтрагента(ДополнятьСостояниемСОшибкой = Истина, ДополнятьПустымСостоянием = Истина) Экспорт
	
	МассивСостояний = Новый Массив;
	МассивСостояний.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияСуществованияКонтрагента.КонтрагентЕстьВБазеФНС"));
	МассивСостояний.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияСуществованияКонтрагента.КонтрагентНеПодлежитПроверке"));
	ДобавитьДополнительныеСостояния(МассивСостояний, ДополнятьСостояниемСОшибкой, ДополнятьПустымСостоянием);
	
	Возврат МассивСостояний;
			
КонецФункции

// Функция - Определение по состоянию, является ли контрагент недействующим.
//
// Параметры:
//  Состояние					 - Перечисления.СостоянияСуществованияКонтрагента - Состояние контрагента.
//  ДополнятьСостояниемСОшибкой	 - Булево - Если Истина, то контрагент с ошибкой считается недействующим.
//  ДополнятьПустымСостоянием	 - Булево - Если Истина, то контрагент с пустым состоянием считается недействующим.
// Возвращаемое значение:
//  Булево - Является ли контрагент недействующим.
//
Функция ЭтоСостояниеНедействующегоКонтрагента(Состояние, ДополнятьСостояниемСОшибкой = Ложь, ДополнятьПустымСостоянием = Ложь) Экспорт
	
	СостоянияНедействующегоКонтрагента = ПроверкаКонтрагентовКлиентСерверПовтИсп.СостоянияНедействующегоКонтрагента(
		ДополнятьСостояниемСОшибкой, ДополнятьПустымСостоянием);
	Возврат СостоянияНедействующегоКонтрагента.Найти(Состояние) <> Неопределено;
			
КонецФункции

// Функция - Перечень состояний недействующего контрагента.
//
// Параметры:
//  ДополнятьСостояниемСОшибкой	 - Булево - Если Истина, то контрагент с ошибкой считается действующим.
//  ДополнятьПустымСостоянием	 - Булево - Если Истина, то контрагент с пустым состоянием считается действующим.
// Возвращаемое значение:
// Массив - Состояния контрагента, при которых он является действующим.
//
Функция СостоянияНедействующегоКонтрагента(ДополнятьСостояниемСОшибкой = Ложь, ДополнятьПустымСостоянием = Ложь) Экспорт
	
	МассивСостояний = Новый Массив;
	МассивСостояний.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияСуществованияКонтрагента.КППНеСоответствуетДаннымБазыФНС"));
	МассивСостояний.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияСуществованияКонтрагента.КонтрагентОтсутствуетВБазеФНС"));
	МассивСостояний.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияСуществованияКонтрагента.НеДействуетИлиИзмененКПП"));
	ДобавитьДополнительныеСостояния(МассивСостояний, ДополнятьСостояниемСОшибкой, ДополнятьПустымСостоянием);
	
	Возврат МассивСостояний;
			
КонецФункции

// Функция - Ссылка на инструкцию по проверке контрагентов.
// Возвращаемое значение:
//  ФорматированнаяСтрока - Ссылка на инструкцию.
//
Функция СсылкаНаИнструкцию() Экспорт
	Возврат Новый ФорматированнаяСтрока(НСтр("ru = 'Подробнее о проверке'"),,,, ПутьКИнструкции());
КонецФункции

// Функция - Путь к инструкции по проверке контрагентов.
// Возвращаемое значение:
//  Строка - Путь к инструкции по проверке контрагентов.
//
Функция ПутьКИнструкции() Экспорт
	Возврат "e1cib/app/Обработка.ИнструкцияПоИспользованиюПроверкиКонтрагента";
КонецФункции

#КонецОбласти

#Область ВспомогательныеПроцедурыИФункции

Процедура ДобавитьДополнительныеСостояния(МассивСостояний, ДополнятьСостояниемСОшибкой, ДополнятьПустымСостоянием)
	
	Если ДополнятьСостояниемСОшибкой Тогда
		МассивСостояний.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияСуществованияКонтрагента.КонтрагентСодержитОшибкиВДанных"));
	КонецЕсли;
	Если ДополнятьПустымСостоянием Тогда
		МассивСостояний.Добавить(ПредопределенноеЗначение("Перечисление.СостоянияСуществованияКонтрагента.ПустаяСсылка"));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти