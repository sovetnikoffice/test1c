﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Интеграция с 1С:Бухфон".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Получает из регистра сведений путь к исполняемому файлу.
//
// Параметры:
//		ИдентификаторКлиента	- УникальныйИдентификатор - Идентификатор клиента (программы) 1С.
// 		
// ВозвращаемоеЗначение:
// 		Строка   - Путь к исполняемому файлу на ПК текущего пользователя.
//
Функция РасположениеИсполняемогоФайла(ИдентификаторКлиента) Экспорт
	
	Возврат ХранилищеОбщихНастроек.Загрузить("ПутиИсполняемыхФайлов1СБухфон", ИдентификаторКлиента);
	
КонецФункции

// Получает из регистра сведений параметры для запуска программы 1С-Бухфон.
//
// Параметры:
//		Пользователь  - УникальныйИдентификатор - Текущий пользователь информационной базы.
//
// ВозвращаемоеЗначение:
//		Структура  - Настройки пользователя для запуска программы 1С-Бухфон.
//
Функция НастройкиУчетнойЗаписиПользователя() Экспорт 
	
	НастройкиПользователя = Интеграция1СБухфон.НастройкиПользователя();
	НастройкиПользователяХранилище = ХранилищеОбщихНастроек.Загрузить("УчетныеЗаписиПользователей1СБухфон", "НастройкиУчетныхДанных");
	
	Если НЕ НастройкиПользователяХранилище = Неопределено Тогда
		НастройкиПользователя.Логин 					= НастройкиПользователяХранилище.Логин;
		НастройкиПользователя.Пароль 					= НастройкиПользователяХранилище.Пароль;
		НастройкиПользователя.ИспользоватьЛП 			= НастройкиПользователяХранилище.ИспользоватьЛП;
		НастройкиПользователя.ВидимостьКнопки1СБухфон 	= НастройкиПользователяХранилище.ВидимостьКнопки1СБухфон;	
	КонецЕсли;
	
	Возврат НастройкиПользователя;
	
КонецФункции
	
#КонецОбласти
 


