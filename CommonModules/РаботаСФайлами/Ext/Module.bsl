﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Работа с файлами".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Создает карточку Файла в БД вместе с версией.
// 
// Параметры:
//  Владелец - Ссылка - владелец файла, который будет установлен в реквизит ВладелецФайла у созданного файла.
//
//  ПутьКФайлуНаДиске  - Строка - полный путь к файлу на диске, включающий имя и расширение файла.
//                       Файл должен находиться на сервере.
//
// Возвращаемое значение:
//  СправочникСсылка.Файлы - созданный файл.
//
Функция СоздатьФайлНаОсновеФайлаНаДиске(Владелец, ПутьКФайлуНаДиске) Экспорт
	
	Файл = Новый Файл(ПутьКФайлуНаДиске);
	
	ДвоичныеДанные = Новый ДвоичныеДанные(ПутьКФайлуНаДиске);
	АдресВременногоХранилищаФайла = ПоместитьВоВременноеХранилище(ДвоичныеДанные);
	
	АдресВременногоХранилищаТекста = "";
	
	Если ФайловыеФункцииСлужебный.ИзвлекатьТекстыФайловНаСервере() Тогда
		// Текст извлечет регламентное задание.
		АдресВременногоХранилищаТекста = ""; 
	Иначе
		// Попытка извлечения текста, если сервер под Windows.
		Если ФайловыеФункцииСлужебный.ЭтоПлатформаWindows() Тогда
			Текст = ФайловыеФункцииСлужебныйКлиентСервер.ИзвлечьТекст(ПутьКФайлуНаДиске);
			АдресВременногоХранилищаТекста = Новый ХранилищеЗначения(Текст);
		КонецЕсли;
	КонецЕсли;
	
	СведенияОФайле = РаботаСФайламиКлиентСервер.СведенияОФайле("ФайлСВерсией", Файл);
	СведенияОФайле.АдресВременногоХранилищаФайла = АдресВременногоХранилищаФайла;
	СведенияОФайле.АдресВременногоХранилищаТекста = АдресВременногоХранилищаТекста;
	Возврат РаботаСФайламиСлужебныйВызовСервера.СоздатьФайлСВерсией(Владелец, СведенияОФайле);
	
КонецФункции

// Обработчик события ПередЗаписью объектов-владельцев файлов.
// Определен только для объектов Документ.
//
// Параметры:
//  Источник        - ДокументОбъект           - стандартный параметр события ПередЗаписью.
//  Отказ           - Булево                   - стандартный параметр события ПередЗаписью.
//  РежимЗаписи     - РежимЗаписиДокумента     - стандартный параметр события ПередЗаписью.
//  РежимПроведения - РежимПроведенияДокумента - стандартный параметр события ПередЗаписью.
//
Процедура УстановитьПометкуУдаленияФайловДокументовПередЗаписью(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Источник.ПометкаУдаления <> ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Источник.Ссылка, "ПометкаУдаления") Тогда
		ПометитьНаУдалениеПриложенныеФайлы(Источник.Ссылка, Источник.ПометкаУдаления);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Обработчик события ПередЗаписью объектов-владельцев файлов.
// Определен для объектов, кроме Документ.
//
// Параметры:
//  Источник - Объект - стандартный параметр события ПередЗаписью, например, СправочникОбъект.
//                      Исключение - ДокументОбъект.
//  Отказ    - Булево - стандартный параметр события ПередЗаписью.
//
Процедура УстановитьПометкуУдаленияФайловПередЗаписью(Источник, Отказ) Экспорт
	
	Если Источник.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если СтандартныеПодсистемыСервер.ЭтоИдентификаторОбъектаМетаданных(Источник) Тогда
		Возврат;
	КонецЕсли;
	
	Если Источник.ПометкаУдаления <> ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Источник.Ссылка, "ПометкаУдаления") Тогда
		ПометитьНаУдалениеПриложенныеФайлы(Источник.Ссылка, Источник.ПометкаУдаления);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры и функции.

// Помечает/снимает пометку удаления у приложенных файлов.
Процедура ПометитьНаУдалениеПриложенныеФайлы(ВладелецФайла, ПометкаУдаления)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Файлы.Ссылка КАК Ссылка,
	|	Файлы.Редактирует КАК Редактирует
	|ИЗ
	|	Справочник.Файлы КАК Файлы
	|ГДЕ
	|	Файлы.ВладелецФайла = &ВладелецФайла";
	
	Запрос.УстановитьПараметр("ВладелецФайла", ВладелецФайла);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	Пока Выборка.Следующий() Цикл
		Если ПометкаУдаления И Не Выборка.Редактирует.Пустая() Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '""%1"" не может быть удален,
				           |т.к. содержит файл ""%2"",
				           |занятый для редактирования.'"),
				Строка(ВладелецФайла),
				Строка(Выборка.Ссылка));
		КонецЕсли;
		ФайлОбъект = Выборка.Ссылка.ПолучитьОбъект();
		ФайлОбъект.Заблокировать();
		ФайлОбъект.УстановитьПометкуУдаления(ПометкаУдаления);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
