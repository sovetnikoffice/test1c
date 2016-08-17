﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Процедура добавляет запись в регистр по переданным значениям структуры.
Процедура ДобавитьЗапись(СтруктураЗаписи) Экспорт
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено()
		И ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		
		ОбменДаннымиСервер.ДобавитьЗаписьВРегистрСведений(СтруктураЗаписи, "СостоянияУспешныхОбменовДаннымиОбластейДанных");
	Иначе
		ОбменДаннымиСервер.ДобавитьЗаписьВРегистрСведений(СтруктураЗаписи, "СостоянияУспешныхОбменовДанными");
	КонецЕсли;
	
КонецПроцедуры

Процедура УдалитьЗапись(СтруктураЗаписи) Экспорт
	
	ОбменДаннымиСервер.УдалитьНаборЗаписейВРегистреСведений(СтруктураЗаписи, "СостоянияУспешныхОбменовДанными");
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли