﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Групповое изменение объектов.

// Возвращает список реквизитов, которые не разрешается редактировать
// с помощью обработки группового изменения объектов.
//
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("Код");
	Результат.Добавить("Наименование");
	Результат.Добавить("ПредопределеннаяПапка");
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли