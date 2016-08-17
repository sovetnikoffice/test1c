﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает список реквизитов, которые разрешается редактировать
// с помощью обработки группового изменения объектов.
//
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт
	
	РедактируемыеРеквизиты = Новый Массив;
	РедактируемыеРеквизиты.Добавить("Описание");
	РедактируемыеРеквизиты.Добавить("Ответственный");
	РедактируемыеРеквизиты.Добавить("ДатаСоздания");
	
	Возврат РедактируемыеРеквизиты;
	
КонецФункции

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	Если ВидФормы = "ФормаСписка" Тогда
		ТекущаяСтрока = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметры, "ТекущаяСтрока");
		Если ТипЗнч(ТекущаяСтрока) = Тип("СправочникСсылка.ПапкиФайлов") И Не ТекущаяСтрока.Пустая() Тогда
			СтандартнаяОбработка = Ложь;
			Параметры.Удалить("ТекущаяСтрока");
			Параметры.Вставить("Папка", ТекущаяСтрока);
			ВыбраннаяФорма = "Справочник.Файлы.Форма.Файлы";
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
