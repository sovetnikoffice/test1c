﻿// СтандартныеПодсистемы.РаботаСКонтрагентами
&НаКлиенте
Перем ОтключитьАвтоЗаполнениеРеквизитов;
// Конец СтандартныеПодсистемы.РаботаСКонтрагентами

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.Свойства
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "СтраницаДополнительныеРеквизиты");
	ДополнительныеПараметры.Вставить("ОтложеннаяИнициализация", Истина);
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтотОбъект, ДополнительныеПараметры);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	ИсключаемыеВиды = Новый Массив;
	ИсключаемыеВиды.Добавить(Справочники.ВидыКонтактнойИнформации._ДемоАдресКонтрагента);
	ИсключаемыеВиды.Добавить(Справочники.ВидыКонтактнойИнформации._ДемоEmailКонтрагента);
	УправлениеКонтактнойИнформацией.ПриСозданииНаСервере(ЭтотОбъект, Объект, "ГруппаКонтактнаяИнформация",, ИсключаемыеВиды, Истина);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Печать
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	Если Параметры.Ключ.Пустая() Тогда
		ЗаполнитьРеквизитыПоТекстуЗаполнения(Параметры.ТекстЗаполнения);
	КонецЕсли;
	Элементы.ГруппаЗаполнениеПоДаннымЕдиныхГосРеестров.Видимость = Параметры.Ключ.Пустая();
	Элементы.ЗаполнитьПоИНН.Видимость = НЕ Параметры.Ключ.Пустая();
	ПроверкаКонтрагентов.ПриСозданииНаСервереКонтрагент(ЭтотОбъект, Параметры);
	РеквизитыПроверкиКонтрагентов.НеИспользоватьКэш = Истина;
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// СтандартныеПодсистемы.Свойства
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ПередЗаписьюНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентов.ПередЗаписьюНаСервереКонтрагент(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись__ДемоКонтрагенты", Новый Структура, Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	УправлениеКонтактнойИнформацией.ОбработкаПроверкиЗаполненияНаСервере(ЭтотОбъект, Объект, Отказ);
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ПриОткрытииКонтрагент(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	ОповеститьОбИзменении(Объект.Ссылка);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// СтандартныеПодсистемы.РаботаСКонтрагентами

&НаКлиенте
Процедура ПолеПоискаИНННаименованиеПриИзменении(Элемент)
	
	ЗаполнитьПоДаннымЕдиныхГосРеестровНаКлиенте(ПолеПоискаИНННаименование);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.РаботаСКонтрагентами

&НаКлиенте
Процедура ИННПриИзменении(Элемент)
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ЗаполнитьПоДаннымЕдиныхГосРеестровНаКлиенте(Объект.ИНН, Истина);
	ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентаВСправочнике(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура КПППриИзменении(Элемент)
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентаВСправочнике(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура ЮридическоеФизическоеЛицоПриИзменении(Элемент)
	
	// СтандартныеПодсистемы.РаботаСКонтрагентами
	ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентаВСправочнике(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.РаботаСКонтрагентами
	
КонецПроцедуры

&НаКлиенте
Процедура СтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	// СтандартныеПодсистемы.Свойства
	Если ТекущаяСтраница.Имя = "СтраницаДополнительныеРеквизиты"
		И Не ЭтотОбъект.ПараметрыСвойств.ВыполненаОтложеннаяИнициализация Тогда
		
		СвойстваВыполнитьОтложеннуюИнициализацию();
		УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.Свойства
	
	// СтандартныеПодсистемы.КонтактнаяИнформация
	Если ТекущаяСтраница.Имя = ЭтотОбъект.ПараметрыКонтактнойИнформации.ГруппаДляРазмещения
		И Не ЭтотОбъект.ПараметрыКонтактнойИнформации.ВыполненаОтложеннаяИнициализация Тогда
		
		КонтактнаяИнформацияПриСменеСтраницы();
		
	КонецЕсли;
	// Конец СтандартныеПодсистемы.КонтактнаяИнформация
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура Подключаемый_РедактироватьСоставСвойств()
	
	УправлениеСвойствамиКлиент.РедактироватьСоставСвойств(ЭтотОбъект, Объект.Ссылка);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	
	Если НЕ ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтотОбъект, Команда.Имя) Тогда
		РезультатВыполнения = Неопределено;
		ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
		ДополнительныеОтчетыИОбработкиКлиент.ПоказатьРезультатВыполненияКоманды(ЭтотОбъект, РезультатВыполнения);
	КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

// СтандартныеПодсистемы.РаботаСКонтрагентами

&НаКлиенте
Процедура ЗаполнитьПоДаннымЕдиныхГосРеестров(Команда)
	
	Если НЕ ЗначениеЗаполнено(ПолеПоискаИНННаименование) Тогда
		ПоказатьПредупреждение(, НСтр("ru='Поле ""ИНН или наименование"" не заполнено'"));
		ТекущийЭлемент = Элементы.ПолеПоискаИНННаименование;
		Возврат;
	КонецЕсли;
	
	ЗаполнитьПоДаннымЕдиныхГосРеестровНаКлиенте(ПолеПоискаИНННаименование);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоИНН(Команда)
	
	Если НЕ ЗначениеЗаполнено(Объект.ИНН) Тогда
		ПоказатьПредупреждение(, НСтр("ru='Поле ""ИНН"" не заполнено'"));
		ТекущийЭлемент = Элементы.ИНН;
		Возврат;
	КонецЕсли;
	
	ЗаполнитьПоДаннымЕдиныхГосРеестровНаКлиенте(Объект.ИНН, Истина);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.РаботаСКонтрагентами

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства

&НаСервере
Процедура СвойстваВыполнитьОтложеннуюИнициализацию()
	УправлениеСвойствами.ЗаполнитьДополнительныеРеквизитыВФорме(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтотОбъект);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

// СтандартныеПодсистемы.КонтактнаяИнформация

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияПриИзменении(Элемент)
	
	УправлениеКонтактнойИнформациейКлиент.ПредставлениеПриИзменении(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Результат = УправлениеКонтактнойИнформациейКлиент.ПредставлениеНачалоВыбора(ЭтотОбъект, Элемент, , СтандартнаяОбработка);
	ОбновитьКонтактнуюИнформацию(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияОчистка(Элемент, СтандартнаяОбработка)
	
	Результат = УправлениеКонтактнойИнформациейКлиент.ПредставлениеОчистка(ЭтотОбъект, Элемент.Имя);
	ОбновитьКонтактнуюИнформацию(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_КонтактнаяИнформацияВыполнитьКоманду(Команда)
	
	Результат = УправлениеКонтактнойИнформациейКлиент.ПодключаемаяКоманда(ЭтотОбъект, Команда.Имя);
	ОбновитьКонтактнуюИнформацию(Результат);
	УправлениеКонтактнойИнформациейКлиент.ОткрытьФормуВводаАдреса(ЭтотОбъект, Результат);
	
КонецПроцедуры

&НаСервере
Функция ОбновитьКонтактнуюИнформацию(Результат = Неопределено)
	
	Возврат УправлениеКонтактнойИнформацией.ОбновитьКонтактнуюИнформацию(ЭтотОбъект, Объект, Результат);
	
КонецФункции

&НаСервере
Процедура КонтактнаяИнформацияПриСменеСтраницы()
	
	УправлениеКонтактнойИнформацией.ВыполнитьОтложеннуюИнициализацию(ЭтотОбъект, Объект);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.КонтактнаяИнформация

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтотОбъект, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

// СтандартныеПодсистемы.Печать

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать

// СтандартныеПодсистемы.РаботаСКонтрагентами

&НаКлиенте
Процедура Подключаемый_ПоказатьПредложениеИспользоватьПроверкуКонтрагентов()
	ПроверкаКонтрагентовКлиент.ПредложитьВключитьПроверкуКонтрагентов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработатьРезультатПроверкиКонтрагентов()
	ПроверкаКонтрагентовКлиент.ОбработатьРезультатПроверкиКонтрагентовВСправочнике(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыПоТекстуЗаполнения(ТекстЗаполнения)

	Если ЭтоИНН(ТекстЗаполнения) Тогда 
	
		Объект.Наименование = "";
		Объект.ИНН = ТекстЗаполнения;
		Объект.ЮридическоеФизическоеЛицо = ?(СтрДлина(ТекстЗаполнения) = 10,
			Перечисления._ДемоЮридическоеФизическоеЛицо.ЮридическоеЛицо,
			Перечисления._ДемоЮридическоеФизическоеЛицо.ФизическоеЛицо);
			
		ЗаполнитьРеквизитыПоИНННаСервере(ТекстЗаполнения);
		ТекстЗаполнения = Неопределено;
		
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоДаннымЕдиныхГосРеестровНаКлиенте(СтрокаПоиска, Знач ЗаполнениеПоИНН = Неопределено)

	Если ПустаяСтрока(СтрокаПоиска) Тогда
		Возврат;
	КонецЕсли;
	
	Если ОтключитьАвтоЗаполнениеРеквизитов <> Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОтключитьАвтоЗаполнениеРеквизитов = Истина;
	ПодключитьОбработчикОжидания("Подключаемый_ВключитьАвтоЗаполнениеРеквизитов", 0.1, Истина);
	
	СтрокаПоиска = СокрЛП(СтрокаПоиска);
	ПроверятьИНН = ЗаполнениеПоИНН <> Истина;
	
	Если ЗаполнениеПоИНН = Неопределено Тогда
		ЗаполнениеПоИНН = ЭтоИНН(СтрокаПоиска);
	КонецЕсли;
	
	Если (ПроверятьИНН И ЗначениеЗаполнено(Объект.ИНН))
		ИЛИ ЗначениеЗаполнено(Объект.КПП)
		ИЛИ ЗначениеЗаполнено(Объект.Наименование) 
		ИЛИ ЗначениеЗаполнено(Объект.НаименованиеПолное) Тогда
		
		ТекстВопроса = НСтр("ru='Перезаполнить текущие реквизиты?'");
		ДопПараметры = Новый Структура("ЗаполнениеПоИНН,СтрокаПоиска", ЗаполнениеПоИНН, СтрокаПоиска);
		ОписаниеОповещения = Новый ОписаниеОповещения("ЗаполнитьПоДаннымЕдиныхГосРеестровЗавершение", 
			ЭтотОбъект, ДопПараметры);
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		Если ЗаполнениеПоИНН Тогда
			ЗаполнитьРеквизитыПоИНННаКлиенте(СтрокаПоиска);
			ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентаВСправочнике(ЭтотОбъект);
		Иначе 
			ЗаполнитьРеквизитыПоНаименованиюНаКлиенте(СтрокаПоиска);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоДаннымЕдиныхГосРеестровЗавершение(Ответ, ДопПараметры) Экспорт

	Если Ответ = КодВозвратаДиалога.Да Тогда
		Если ДопПараметры.ЗаполнениеПоИНН Тогда
			ЗаполнитьРеквизитыПоИНННаКлиенте(ДопПараметры.СтрокаПоиска);
		Иначе 
			ЗаполнитьРеквизитыПоНаименованиюНаКлиенте(ДопПараметры.СтрокаПоиска);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьРеквизитыПоИНННаКлиенте(СтрокаИНН)
	
	ОписаниеОшибки = "";
	ЗаполнитьРеквизитыПоИНННаСервере(СтрокаИНН, ОписаниеОшибки);
	
	Если ЗначениеЗаполнено(ОписаниеОшибки) Тогда
		// Обработка ошибок
		Если ОписаниеОшибки = "НеУказаныПараметрыАутентификации" Тогда
			ТекстВопроса = НСтр("ru='Для автоматического заполнения реквизитов контрагентов
				|необходимо подключиться к Интернет-поддержке пользователей.
				|Подключиться сейчас?'");
			ДопПараметры = Новый Структура("СтрокаПоиска,ЗаполнениеПоИНН", СтрокаИНН, Истина);
			ОписаниеОповещения = Новый ОписаниеОповещения("ПодключитьИнтернетПоддержку", ЭтотОбъект, ДопПараметры);
			ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		ИначеЕсли ОписаниеОшибки = "НеУказанПароль" Тогда
			ТекстВопроса = НСтр("ru='Необходимо указать пароль к Интернет-поддержке пользователей
				|и установить флажок ""Запомнить пароль"".
				|Указать сейчас?'");
			ДопПараметры = Новый Структура("СтрокаПоиска,ЗаполнениеПоИНН", СтрокаИНН, Истина);
			ОписаниеОповещения = Новый ОписаниеОповещения("ПодключитьИнтернетПоддержку", ЭтотОбъект, ДопПараметры);
			ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		Иначе
			ПоказатьПредупреждение(, ОписаниеОшибки);
		КонецЕсли;
	ИначеЕсли Объект.ЮридическоеФизическоеЛицо = ПредопределенноеЗначение(
		"Перечисление._ДемоЮридическоеФизическоеЛицо.ЮридическоеЛицо") Тогда
		// Проверка юридического лица по данным сервиса ИФНС после заполнения реквизитов - мог измениться КПП.
		ПроверкаКонтрагентовКлиент.ЗапуститьПроверкуКонтрагентаВСправочнике(ЭтотОбъект);		
	КонецЕсли;
	
КонецПроцедуры 

&НаКлиенте
Процедура ЗаполнитьРеквизитыПоНаименованиюНаКлиенте(СтрокаНаименование)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("СтрокаПоиска", СтрокаНаименование);
	ДопПараметры = Новый Структура;
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗаполнитьРеквизитыПоНаименованиюЗавершение", ЭтотОбъект, ДопПараметры);
	ОткрытьФорму("ОбщаяФорма.ЗаполнениеРеквизитовКонтрагента", 
		ПараметрыФормы, ЭтотОбъект, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьРеквизитыПоНаименованиюЗавершение(Результат, ДопПараметры) Экспорт

	Если НЕ ЭтоИНН(Результат) Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьРеквизитыПоИНННаКлиенте(Результат);
	ТекущийЭлемент = Элементы.Наименование;

КонецПроцедуры 

&НаКлиенте
Процедура ПодключитьИнтернетПоддержку(Ответ, ДопПараметры) Экспорт

	Если Ответ = КодВозвратаДиалога.Да Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ПодключитьИнтернетПоддержкуЗавершение", ЭтотОбъект, ДопПараметры);
		СтандартныеПодсистемыКлиент.АвторизоватьНаСайтеПоддержкиПользователей(ЭтотОбъект, ОписаниеОповещения);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПодключитьИнтернетПоддержкуЗавершение(Результат, ДопПараметры) Экспорт

	Если Результат <> Неопределено 
		И Результат <> КодВозвратаДиалога.Отмена Тогда
		ЗаполнитьПоДаннымЕдиныхГосРеестровНаКлиенте(ДопПараметры.СтрокаПоиска, ДопПараметры.ЗаполнениеПоИНН);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВключитьАвтоЗаполнениеРеквизитов()

	ОтключитьАвтоЗаполнениеРеквизитов = Неопределено;	

КонецПроцедуры 

&НаСервере
Процедура ЗаполнитьРеквизитыПоИНННаСервере(СтрокаИНН, ОписаниеОшибки = "")
	
	ЭтоЮридическоеЛицо = Объект.ЮридическоеФизическоеЛицо = Перечисления._ДемоЮридическоеФизическоеЛицо.ЮридическоеЛицо;
	Если ЭтоЮридическоеЛицо Тогда
		РеквизитыКонтрагента = ДанныеЕдиныхГосРеестров.РеквизитыЮридическогоЛицаПоИНН(СтрокаИНН);
	Иначе
		РеквизитыКонтрагента = ДанныеЕдиныхГосРеестров.РеквизитыПредпринимателяПоИНН(СтрокаИНН);
	КонецЕсли;
	Если ЗначениеЗаполнено(РеквизитыКонтрагента.ОписаниеОшибки) Тогда
		ОписаниеОшибки = РеквизитыКонтрагента.ОписаниеОшибки;
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(Объект, РеквизитыКонтрагента);
	
	Если ЭтоЮридическоеЛицо Тогда
		ЗаполнитьЭлементКонтактнойИнформации(Справочники.ВидыКонтактнойИнформации._ДемоАдресКонтрагента, 
			РеквизитыКонтрагента.ЮридическийАдрес);
	КонецЕсли;
	
	Модифицированность = Истина;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЭлементКонтактнойИнформации(ВидКонтактнойИнформации, СтруктураДанных)
	
	Если СтруктураДанных = Неопределено 
		ИЛИ НЕ ЗначениеЗаполнено(СтруктураДанных.Представление) Тогда
		Возврат;
	КонецЕсли;
	
	Отбор  = Новый Структура("Вид", ВидКонтактнойИнформации);
	Строки = ЭтотОбъект.КонтактнаяИнформацияОписаниеДополнительныхРеквизитов.НайтиСтроки(Отбор);
	ДанныеСтроки = ?(Строки.Количество() = 0, Неопределено, Строки[0]);
	Если ДанныеСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ДанныеСтроки.Представление = СтруктураДанных.Представление;
	ДанныеСтроки.ЗначенияПолей = СтруктураДанных.КонтактнаяИнформация;
	ЭтотОбъект[ДанныеСтроки.ИмяРеквизита] = СтруктураДанных.Представление;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ЭтоИНН(СтрокаИНН)
	Возврат ЗначениеЗаполнено(СтрокаИНН)
		И ТипЗнч(СтрокаИНН) = Тип("Строка")
		И (СтрДлина(СтрокаИНН) = 10 ИЛИ СтрДлина(СтрокаИНН) = 12)
		И СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(СтрокаИНН);
КонецФункции

// Конец СтандартныеПодсистемы.РаботаСКонтрагентами

#КонецОбласти
