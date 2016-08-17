﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - УправляемаяФорма, Неопределено - Форма отчета или форма настроек отчета.
//       Неопределено когда вызов без контекста.
//   КлючВарианта - Строка, Неопределено - Имя предопределенного
//       или уникальный идентификатор пользовательского варианта отчета.
//       Неопределено когда вызов без контекста.
//   Настройки - Структура - см. возвращаемое значение
//       ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию().
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	Настройки.События.ПриСозданииНаСервере = Истина;
	Настройки.События.ПриОпределенииПараметровВыбора = Истина;
	Настройки.ПараметрыПечатиПоУмолчанию.ПолеСверху = 5;
	Настройки.ПараметрыПечатиПоУмолчанию.ПолеСлева = 5;
	Настройки.ПараметрыПечатиПоУмолчанию.ПолеСнизу = 5;
	Настройки.ПараметрыПечатиПоУмолчанию.ПолеСправа = 5;
	Настройки.ФормироватьСразу = Истина;
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   Отказ - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Передается из параметров обработчика "как есть".
//
// См. также:
//   "УправляемаяФорма.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	Форма.Элементы.ГруппаОтправить.Подсказка = НСтр("ru = '<Демо: Тест>'");
КонецПроцедуры

// Вызывается в форме отчета перед выводом настройки.
//   Подробнее - см. ФормаОтчетаПереопределяемый.ПриОпределенииПараметровВыбора().
//
Процедура ПриОпределенииПараметровВыбора(Форма, СвойстваНастройки) Экспорт
	ИмяПоля = Строка(СвойстваНастройки.ПолеКД);
	Если ИмяПоля = "Автор" И СвойстваНастройки.ОписаниеТипов.СодержитТип(Тип("СправочникСсылка.Пользователи")) Тогда
		СвойстваНастройки.ОграничиватьВыборУказаннымиЗначениями = Истина;
		СвойстваНастройки.ЗначенияДляВыбора.Очистить();
		СвойстваНастройки.ЗапросЗначенийВыбора.Текст =
		"ВЫБРАТЬ Ссылка ИЗ Справочник.Пользователи ГДЕ НЕ ПометкаУдаления И НЕ Недействителен И НЕ Служебный";
	ИначеЕсли ИмяПоля = "ТестоваяГруппа.ТестовоеПолеВГруппе" Тогда
		СвойстваНастройки.ПользовательскаяНастройка.ТипЭлементов = "СвязьСКомпоновщиком";
	ИначеЕсли ИмяПоля = "Тест" Тогда
		Элемент = СвойстваНастройки.ЗначенияДляВыбора.НайтиПоЗначению(-1);
		Если Элемент <> Неопределено Тогда
			СвойстваНастройки.ЗначенияДляВыбора.Удалить(Элемент);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#КонецЕсли