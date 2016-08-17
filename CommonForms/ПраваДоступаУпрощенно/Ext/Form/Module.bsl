﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Параметры.Пользователь) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Пользователи.ЭтоПолноправныйПользователь() Тогда
		// Просмотр и редактирование состава профилей и ограничений доступа.
		ОтборПрофилейТолькоТекущегоПользователя = Ложь;
		
	ИначеЕсли Параметры.Пользователь = Пользователи.АвторизованныйПользователь() Тогда
		// Просмотр своих профилей и отчета о правах доступа.
		ОтборПрофилейТолькоТекущегоПользователя = Истина;
		// Скрытие лишних сведений.
		Элементы.Профили.ТолькоПросмотр = Истина;
		Элементы.ПрофилиПометка.Видимость = Ложь;
		Элементы.Доступ.Видимость = Ложь;
		Элементы.ФормаЗаписать.Видимость = Ложь;
	Иначе
		Элементы.ФормаЗаписать.Видимость = Ложь;
		Элементы.ФормаОтчетПраваДоступа.Видимость = Ложь;
		Элементы.ПраваИОграничения.Видимость = Ложь;
		Элементы.НедостаточноПравНаПросмотр.Видимость = Истина;
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Параметры.Пользователь) = Тип("СправочникСсылка.ВнешниеПользователи") Тогда
		Элементы.Профили.Заголовок = НСтр("ru = 'Профили внешнего пользователя'");
	Иначе
		Элементы.Профили.Заголовок = НСтр("ru = 'Профили пользователя'");
	КонецЕсли;
	
	ЗагрузитьДанные(ОтборПрофилейТолькоТекущегоПользователя);
	
	// Подготовка вспомогательных данных.
	УправлениеДоступомСлужебный.ПриСозданииНаСервереФормыРедактированияРазрешенныхЗначений(ЭтотОбъект, , "");
	
	Для каждого СвойстваПрофиля Из Профили Цикл
		ТекущаяГруппаДоступа = СвойстваПрофиля.Профиль;
		УправлениеДоступомСлужебныйКлиентСервер.ЗаполнитьСвойстваВидовДоступаВФорме(ЭтотОбъект);
	КонецЦикла;
	ТекущаяГруппаДоступа = "";
	
	ПрофильАдминистратор = Справочники.ПрофилиГруппДоступа.Администратор;
	
	// Определение необходимости настройки ограничений доступа.
	Если НЕ УправлениеДоступом.ОграничиватьДоступНаУровнеЗаписей() Тогда
		Элементы.Доступ.Видимость = Ложь;
	КонецЕсли;
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено()
	   И ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.ПользователиВМоделиСервиса") Тогда
		
		МодульПользователиСлужебныйВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("ПользователиСлужебныйВМоделиСервиса");
		ДействияСПользователемСервиса = МодульПользователиСлужебныйВМоделиСервиса.ПолучитьДействияСПользователемСервиса();
		
		ЗапретИзмененияАдминистративногоДоступа = НЕ ДействияСПользователемСервиса.ИзменениеАдминистративногоДоступа;
	КонецЕсли;
	
	СтандартныеПодсистемыСервер.УстановитьОтображениеЗаголовковГрупп(ЭтотОбъект, "Доступ");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ТипЗнч(ВладелецФормы) <> Тип("УправляемаяФорма")
	 Или ВладелецФормы.Окно <> Окно Тогда
		
		АвтоЗаголовок = Ложь;
		Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Права доступа (%1)'"), Строка(Параметры.Пользователь));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ЗаписатьИЗакрытьОповещение", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// Проверка незаполненных и повторяющихся значений доступа.
	Ошибки = Неопределено;
	
	Для каждого СвойстваПрофиля Из Профили Цикл
		
		ТекущаяГруппаДоступа = СвойстваПрофиля.Профиль;
		УправлениеДоступомСлужебныйКлиентСервер.ОбработкаПроверкиЗаполненияНаСервереФормыРедактированияРазрешенныхЗначений(
			ЭтотОбъект, Отказ, Новый Массив, Ошибки);
		
		Если Отказ Тогда
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Если Отказ Тогда
		ТекущаяСтрокаВидаДоступа = Элементы.ВидыДоступа.ТекущаяСтрока;
		ТекущаяСтрокаЗначенияДоступаПриОшибке = Элементы.ЗначенияДоступа.ТекущаяСтрока;
		
		Элементы.Профили.ТекущаяСтрока = СвойстваПрофиля.ПолучитьИдентификатор();
		ПриИзмененииТекущегоПрофиля(ЭтотОбъект, Ложь);
		
		Элементы.ВидыДоступа.ТекущаяСтрока = ТекущаяСтрокаВидаДоступа;
		УправлениеДоступомСлужебныйКлиентСервер.ПриИзмененииТекущегоВидаДоступа(ЭтотОбъект, Ложь);
		
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	Иначе
		ТекущаяГруппаДоступа = ТекущийПрофиль;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьТекущуюСтрокуЗначенияДоступаПриОшибке()
	
	Если ТекущаяСтрокаЗначенияДоступаПриОшибке <> Неопределено Тогда
		Элементы.ЗначенияДоступа.ТекущаяСтрока = ТекущаяСтрокаЗначенияДоступаПриОшибке;
		ТекущаяСтрокаЗначенияДоступаПриОшибке = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПрофили

&НаКлиенте
Процедура ПрофилиПриАктивизацииСтроки(Элемент)
	
	ПриИзмененииТекущегоПрофиля(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрофилиПометкаПриИзменении(Элемент)
	
	Отказ = Ложь;
	ТекущиеДанные = Элементы.Профили.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено
	   И НЕ ТекущиеДанные.Пометка Тогда
		// Проверка незаполненных и повторяющихся значений доступа
		// перед отключением профиля и отключением доступности его настройки.
		ОчиститьСообщения();
		Ошибки = Неопределено;
		УправлениеДоступомСлужебныйКлиентСервер.ОбработкаПроверкиЗаполненияНаСервереФормыРедактированияРазрешенныхЗначений(
			ЭтотОбъект, Отказ, Новый Массив, Ошибки);
		ТекущаяСтрокаЗначенияДоступаПриОшибке = Элементы.ЗначенияДоступа.ТекущаяСтрока;
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
		ПодключитьОбработчикОжидания("УстановитьТекущуюСтрокуЗначенияДоступаПриОшибке", Истина, 0.1);
	КонецЕсли;
	
	Если Отказ Тогда
		ТекущиеДанные.Пометка = Истина;
	Иначе
		ПриИзмененииТекущегоПрофиля(ЭтотОбъект);
	КонецЕсли;
	
	Если ТекущиеДанные <> Неопределено
		И ТекущиеДанные.Профиль = ПредопределенноеЗначение("Справочник.ПрофилиГруппДоступа.Администратор") Тогда
		
		ТребуетсяСинхронизацияССервисом = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВидыДоступа

&НаКлиенте
Процедура ВидыДоступаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если РедактированиеТекущихОграничений Тогда
		Элементы.ВидыДоступа.ИзменитьСтроку();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыДоступаПриАктивизацииСтроки(Элемент)
	
	УправлениеДоступомСлужебныйКлиент.ВидыДоступаПриАктивизацииСтроки(
		ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыДоступаПриАктивизацииЯчейки(Элемент)
	
	УправлениеДоступомСлужебныйКлиент.ВидыДоступаПриАктивизацииЯчейки(
		ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыДоступаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	УправлениеДоступомСлужебныйКлиент.ВидыДоступаПриНачалеРедактирования(
		ЭтотОбъект, Элемент, НоваяСтрока, Копирование);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыДоступаПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	УправлениеДоступомСлужебныйКлиент.ВидыДоступаПриОкончанииРедактирования(
		ЭтотОбъект, Элемент, НоваяСтрока, ОтменаРедактирования);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий элемента ВсеРазрешеныПредставление таблицы формы ВидыДоступа.

&НаКлиенте
Процедура ВидыДоступаВсеРазрешеныПредставлениеПриИзменении(Элемент)
	
	УправлениеДоступомСлужебныйКлиент.ВидыДоступаВсеРазрешеныПредставлениеПриИзменении(
		ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидыДоступаВсеРазрешеныПредставлениеОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	УправлениеДоступомСлужебныйКлиент.ВидыДоступаВсеРазрешеныПредставлениеОбработкаВыбора(
		ЭтотОбъект, Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЗначенияДоступа

&НаКлиенте
Процедура ЗначенияДоступаПриИзменении(Элемент)
	
	УправлениеДоступомСлужебныйКлиент.ЗначенияДоступаПриИзменении(
		ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗначенияДоступаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	УправлениеДоступомСлужебныйКлиент.ЗначенияДоступаПриНачалеРедактирования(
		ЭтотОбъект, Элемент, НоваяСтрока, Копирование);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗначенияДоступаПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	УправлениеДоступомСлужебныйКлиент.ЗначенияДоступаПриОкончанииРедактирования(
		ЭтотОбъект, Элемент, НоваяСтрока, ОтменаРедактирования);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеДоступаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	УправлениеДоступомСлужебныйКлиент.ЗначениеДоступаНачалоВыбора(
		ЭтотОбъект, Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеДоступаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	УправлениеДоступомСлужебныйКлиент.ЗначениеДоступаОбработкаВыбора(
		ЭтотОбъект, Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеДоступаОчистка(Элемент, СтандартнаяОбработка)
	
	УправлениеДоступомСлужебныйКлиент.ЗначениеДоступаОчистка(
		ЭтотОбъект, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеДоступаАвтоПодбор(Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка)
	
	УправлениеДоступомСлужебныйКлиент.ЗначениеДоступаАвтоПодбор(
		ЭтотОбъект, Элемент, Текст, ДанныеВыбора, Ожидание, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеДоступаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	УправлениеДоступомСлужебныйКлиент.ЗначениеДоступаОкончаниеВводаТекста(
		ЭтотОбъект, Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Записать(Команда)
	
	ЗаписатьИзменения();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчетПоПравамДоступа(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Пользователь", Параметры.Пользователь);
	
	ОткрытьФорму("Отчет.ПраваДоступа.Форма", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьНеиспользуемыеВидыДоступа(Команда)
	
	ПоказыватьНеИспользуемыеВидыДоступаНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПрофилиПометка.Имя);

	ГруппаОтбора1 = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора1.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;

	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЗапретИзмененияАдминистративногоДоступа");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Профили.Профиль");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Справочники.ПрофилиГруппДоступа.Администратор;

	Элемент.Оформление.УстановитьЗначениеПараметра("Доступность", Ложь);

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПрофилиПометка.Имя);

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ПрофилиПрофильПредставление.Имя);

	ГруппаОтбора1 = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора1.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;

	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЗапретИзмененияАдминистративногоДоступа");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;

	ОтборЭлемента = ГруппаОтбора1.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Профили.Профиль");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Справочники.ПрофилиГруппДоступа.Администратор;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветФона", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);

КонецПроцедуры

// Продолжение обработчика события ПередЗакрытием.
&НаКлиенте
Процедура ЗаписатьИЗакрытьОповещение(Результат, Неопределен) Экспорт
	
	ЗаписатьИзменения(Новый ОписаниеОповещения("ЗаписатьИЗакрытьЗавершение", ЭтотОбъект));
	
КонецПроцедуры

// Продолжение обработчика события ПередЗакрытием.
&НаКлиенте
Процедура ЗаписатьИЗакрытьЗавершение(Отказ, Неопределен) Экспорт
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИзменения(ОбработкаПродолжения = Неопределено)
	
	Если СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().РазделениеВключено
	   И ТребуетсяСинхронизацияССервисом Тогда
		
		СтандартныеПодсистемыКлиент.ПриЗапросеПароляДляАутентификацииВСервисе(
			Новый ОписаниеОповещения("ЗаписатьИзмененияЗавершение", ЭтотОбъект, ОбработкаПродолжения),
			ЭтотОбъект,
			ПарольПользователяСервиса);
	Иначе
		ЗаписатьИзмененияЗавершение(Null, ОбработкаПродолжения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИзмененияЗавершение(НовыйПарольПользователяСервиса, ОбработкаПродолжения) Экспорт
	
	Если НовыйПарольПользователяСервиса = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если НовыйПарольПользователяСервиса <> Null Тогда
		ПарольПользователяСервиса = НовыйПарольПользователяСервиса;
	КонецЕсли;
	
	ОчиститьСообщения();
	
	Отказ = Ложь;
	ЗаписатьИзмененияНаСервере(Отказ);
	
	ПодключитьОбработчикОжидания("УстановитьТекущуюСтрокуЗначенияДоступаПриОшибке", Истина, 0.1);
	
	Если ОбработкаПродолжения = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(ОбработкаПродолжения, Отказ);
	
КонецПроцедуры

&НаСервере
Процедура ПоказыватьНеИспользуемыеВидыДоступаНаСервере()
	
	УправлениеДоступомСлужебный.ОбновитьОтображениеНеиспользуемыхВидовДоступа(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьДанные(ОтборПрофилейТолькоТекущегоПользователя)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Пользователь", Параметры.Пользователь);
	Запрос.УстановитьПараметр("ОтборПрофилейТолькоТекущегоПользователя",
	                           ОтборПрофилейТолькоТекущегоПользователя);
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Профили.Ссылка,
	|	ЕСТЬNULL(ГруппыДоступа.Ссылка, НЕОПРЕДЕЛЕНО) КАК ПерсональнаяГруппаДоступа,
	|	ВЫБОР
	|		КОГДА ГруппыДоступаПользователи.Ссылка ЕСТЬ NULL 
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК Пометка
	|ПОМЕСТИТЬ Профили
	|ИЗ
	|	Справочник.ПрофилиГруппДоступа КАК Профили
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ГруппыДоступа КАК ГруппыДоступа
	|		ПО Профили.Ссылка = ГруппыДоступа.Профиль
	|			И (НЕ(ГруппыДоступа.Пользователь <> &Пользователь
	|					И НЕ Профили.Ссылка В (ЗНАЧЕНИЕ(Справочник.ПрофилиГруппДоступа.Администратор))))
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ГруппыДоступа.Пользователи КАК ГруппыДоступаПользователи
	|		ПО (ГруппыДоступа.Ссылка = ГруппыДоступаПользователи.Ссылка)
	|			И (ГруппыДоступаПользователи.Пользователь = &Пользователь)
	|ГДЕ
	|	НЕ Профили.ПометкаУдаления
	|	И НЕ(&ОтборПрофилейТолькоТекущегоПользователя = ИСТИНА
	|				И ГруппыДоступаПользователи.Ссылка ЕСТЬ NULL )
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Профили.Ссылка КАК Профиль,
	|	Профили.Ссылка.Наименование КАК ПрофильПредставление,
	|	Профили.Пометка,
	|	Профили.ПерсональнаяГруппаДоступа КАК ГруппаДоступа
	|ИЗ
	|	Профили КАК Профили
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПрофильПредставление
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Профили.Ссылка КАК ГруппаДоступа,
	|	ПрофилиВидыДоступа.ВидДоступа,
	|	ЕСТЬNULL(ГруппыДоступаВидыДоступа.ВсеРазрешены, ПрофилиВидыДоступа.ВсеРазрешены) КАК ВсеРазрешены,
	|	"""" КАК ВидДоступаПредставление,
	|	"""" КАК ВсеРазрешеныПредставление
	|ИЗ
	|	Профили КАК Профили
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ПрофилиГруппДоступа.ВидыДоступа КАК ПрофилиВидыДоступа
	|		ПО Профили.Ссылка = ПрофилиВидыДоступа.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ГруппыДоступа.ВидыДоступа КАК ГруппыДоступаВидыДоступа
	|		ПО Профили.ПерсональнаяГруппаДоступа = ГруппыДоступаВидыДоступа.Ссылка
	|			И (ПрофилиВидыДоступа.ВидДоступа = ГруппыДоступаВидыДоступа.ВидДоступа)
	|ГДЕ
	|	НЕ ПрофилиВидыДоступа.Предустановленный
	|
	|УПОРЯДОЧИТЬ ПО
	|	Профили.Ссылка.Наименование,
	|	ПрофилиВидыДоступа.НомерСтроки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Профили.Ссылка КАК ГруппаДоступа,
	|	ПрофилиВидыДоступа.ВидДоступа,
	|	0 КАК НомерСтрокиПоВиду,
	|	ГруппыДоступаЗначенияДоступа.ЗначениеДоступа
	|ИЗ
	|	Профили КАК Профили
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ПрофилиГруппДоступа.ВидыДоступа КАК ПрофилиВидыДоступа
	|		ПО Профили.Ссылка = ПрофилиВидыДоступа.Ссылка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ГруппыДоступа.ЗначенияДоступа КАК ГруппыДоступаЗначенияДоступа
	|		ПО Профили.ПерсональнаяГруппаДоступа = ГруппыДоступаЗначенияДоступа.Ссылка
	|			И (ПрофилиВидыДоступа.ВидДоступа = ГруппыДоступаЗначенияДоступа.ВидДоступа)
	|ГДЕ
	|	НЕ ПрофилиВидыДоступа.Предустановленный
	|
	|УПОРЯДОЧИТЬ ПО
	|	Профили.Ссылка.Наименование,
	|	ПрофилиВидыДоступа.НомерСтроки,
	|	ГруппыДоступаЗначенияДоступа.НомерСтроки";
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	УстановитьПривилегированныйРежим(Ложь);
	
	ЗначениеВРеквизитФормы(РезультатыЗапроса[1].Выгрузить(), "Профили");
	ЗначениеВРеквизитФормы(РезультатыЗапроса[2].Выгрузить(), "ВидыДоступа");
	ЗначениеВРеквизитФормы(РезультатыЗапроса[3].Выгрузить(), "ЗначенияДоступа");
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьИзмененияНаСервере(Отказ)
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Пользователи.НайтиНеоднозначныхПользователейИБ(Неопределено);
	
	// Получение списка изменений.
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Пользователь", Параметры.Пользователь);
	
	Запрос.УстановитьПараметр(
		"Профили", Профили.Выгрузить(, "Профиль, Пометка"));
	
	Запрос.УстановитьПараметр(
		"ВидыДоступа", ВидыДоступа.Выгрузить(, "ГруппаДоступа, ВидДоступа, ВсеРазрешены"));
	
	ТаблицаЗначений = ЗначенияДоступа.Выгрузить(, "ГруппаДоступа, ВидДоступа, ЗначениеДоступа");
	ТаблицаЗначений.Колонки.Добавить("НомерСтроки", Новый ОписаниеТипов("Число",,,
		Новый КвалификаторыЧисла(10, 0, ДопустимыйЗнак.Неотрицательный)));
	
	ГруппаДоступаВСтроке = Неопределено;
	Для Каждого Строка Из ТаблицаЗначений Цикл
		Если ГруппаДоступаВСтроке <> Строка.ГруппаДоступа Тогда
			ГруппаДоступаВСтроке = Строка.ГруппаДоступа;
			ТекущийНомерСтроки = 1;
		КонецЕсли;
		Строка.НомерСтроки = ТекущийНомерСтроки;
		ТекущийНомерСтроки = ТекущийНомерСтроки + 1;
	КонецЦикла;
	Запрос.УстановитьПараметр("ЗначенияДоступа", ТаблицаЗначений);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Профили.Профиль КАК Ссылка,
	|	Профили.Пометка
	|ПОМЕСТИТЬ Профили
	|ИЗ
	|	&Профили КАК Профили
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВидыДоступа.ГруппаДоступа КАК Профиль,
	|	ВидыДоступа.ВидДоступа,
	|	ВидыДоступа.ВсеРазрешены
	|ПОМЕСТИТЬ ВидыДоступа
	|ИЗ
	|	&ВидыДоступа КАК ВидыДоступа
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗначенияДоступа.ГруппаДоступа КАК Профиль,
	|	ЗначенияДоступа.ВидДоступа,
	|	ЗначенияДоступа.НомерСтроки,
	|	ЗначенияДоступа.ЗначениеДоступа
	|ПОМЕСТИТЬ ЗначенияДоступа
	|ИЗ
	|	&ЗначенияДоступа КАК ЗначенияДоступа
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Профили.Ссылка,
	|	ЕСТЬNULL(ГруппыДоступа.Ссылка, НЕОПРЕДЕЛЕНО) КАК ПерсональнаяГруппаДоступа,
	|	ВЫБОР
	|		КОГДА ГруппыДоступаПользователи.Ссылка ЕСТЬ NULL 
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ ИСТИНА
	|	КОНЕЦ КАК Пометка
	|ПОМЕСТИТЬ ТекущиеПрофили
	|ИЗ
	|	Справочник.ПрофилиГруппДоступа КАК Профили
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ГруппыДоступа КАК ГруппыДоступа
	|		ПО Профили.Ссылка = ГруппыДоступа.Профиль
	|			И (НЕ(ГруппыДоступа.Пользователь <> &Пользователь
	|					И НЕ Профили.Ссылка В (ЗНАЧЕНИЕ(Справочник.ПрофилиГруппДоступа.Администратор))))
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ГруппыДоступа.Пользователи КАК ГруппыДоступаПользователи
	|		ПО (ГруппыДоступа.Ссылка = ГруппыДоступаПользователи.Ссылка)
	|			И (ГруппыДоступаПользователи.Пользователь = &Пользователь)
	|ГДЕ
	|	НЕ Профили.ПометкаУдаления
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Профили.Ссылка КАК Профиль,
	|	ГруппыДоступаВидыДоступа.ВидДоступа,
	|	ГруппыДоступаВидыДоступа.ВсеРазрешены
	|ПОМЕСТИТЬ ТекущиеВидыДоступа
	|ИЗ
	|	ТекущиеПрофили КАК Профили
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ГруппыДоступа.ВидыДоступа КАК ГруппыДоступаВидыДоступа
	|		ПО Профили.ПерсональнаяГруппаДоступа = ГруппыДоступаВидыДоступа.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Профили.Ссылка КАК Профиль,
	|	ГруппыДоступаЗначенияДоступа.ВидДоступа,
	|	ГруппыДоступаЗначенияДоступа.НомерСтроки,
	|	ГруппыДоступаЗначенияДоступа.ЗначениеДоступа
	|ПОМЕСТИТЬ ТекущиеЗначенияДоступа
	|ИЗ
	|	ТекущиеПрофили КАК Профили
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ГруппыДоступа.ЗначенияДоступа КАК ГруппыДоступаЗначенияДоступа
	|		ПО Профили.ПерсональнаяГруппаДоступа = ГруппыДоступаЗначенияДоступа.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПрофилиИзмененныхГрупп.Профиль
	|ПОМЕСТИТЬ ПрофилиИзмененныхГрупп
	|ИЗ
	|	(ВЫБРАТЬ
	|		Профили.Ссылка КАК Профиль
	|	ИЗ
	|		Профили КАК Профили
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТекущиеПрофили КАК ТекущиеПрофили
	|			ПО Профили.Ссылка = ТекущиеПрофили.Ссылка
	|	ГДЕ
	|		Профили.Пометка <> ТекущиеПрофили.Пометка
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ВидыДоступа.Профиль
	|	ИЗ
	|		ВидыДоступа КАК ВидыДоступа
	|			ЛЕВОЕ СОЕДИНЕНИЕ ТекущиеВидыДоступа КАК ТекущиеВидыДоступа
	|			ПО ВидыДоступа.Профиль = ТекущиеВидыДоступа.Профиль
	|				И ВидыДоступа.ВидДоступа = ТекущиеВидыДоступа.ВидДоступа
	|				И ВидыДоступа.ВсеРазрешены = ТекущиеВидыДоступа.ВсеРазрешены
	|	ГДЕ
	|		ТекущиеВидыДоступа.ВидДоступа ЕСТЬ NULL 
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТекущиеВидыДоступа.Профиль
	|	ИЗ
	|		ТекущиеВидыДоступа КАК ТекущиеВидыДоступа
	|			ЛЕВОЕ СОЕДИНЕНИЕ ВидыДоступа КАК ВидыДоступа
	|			ПО (ВидыДоступа.Профиль = ТекущиеВидыДоступа.Профиль)
	|				И (ВидыДоступа.ВидДоступа = ТекущиеВидыДоступа.ВидДоступа)
	|				И (ВидыДоступа.ВсеРазрешены = ТекущиеВидыДоступа.ВсеРазрешены)
	|	ГДЕ
	|		ВидыДоступа.ВидДоступа ЕСТЬ NULL 
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ЗначенияДоступа.Профиль
	|	ИЗ
	|		ЗначенияДоступа КАК ЗначенияДоступа
	|			ЛЕВОЕ СОЕДИНЕНИЕ ТекущиеЗначенияДоступа КАК ТекущиеЗначенияДоступа
	|			ПО ЗначенияДоступа.Профиль = ТекущиеЗначенияДоступа.Профиль
	|				И ЗначенияДоступа.ВидДоступа = ТекущиеЗначенияДоступа.ВидДоступа
	|				И ЗначенияДоступа.НомерСтроки = ТекущиеЗначенияДоступа.НомерСтроки
	|				И ЗначенияДоступа.ЗначениеДоступа = ТекущиеЗначенияДоступа.ЗначениеДоступа
	|	ГДЕ
	|		ТекущиеЗначенияДоступа.ВидДоступа ЕСТЬ NULL 
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ТекущиеЗначенияДоступа.Профиль
	|	ИЗ
	|		ТекущиеЗначенияДоступа КАК ТекущиеЗначенияДоступа
	|			ЛЕВОЕ СОЕДИНЕНИЕ ЗначенияДоступа КАК ЗначенияДоступа
	|			ПО (ЗначенияДоступа.Профиль = ТекущиеЗначенияДоступа.Профиль)
	|				И (ЗначенияДоступа.ВидДоступа = ТекущиеЗначенияДоступа.ВидДоступа)
	|				И (ЗначенияДоступа.НомерСтроки = ТекущиеЗначенияДоступа.НомерСтроки)
	|				И (ЗначенияДоступа.ЗначениеДоступа = ТекущиеЗначенияДоступа.ЗначениеДоступа)
	|	ГДЕ
	|		ЗначенияДоступа.ВидДоступа ЕСТЬ NULL ) КАК ПрофилиИзмененныхГрупп
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Профили.Ссылка КАК Профиль,
	|	СправочникПрофили.Наименование КАК ПрофильНаименование,
	|	Профили.Пометка,
	|	ТекущиеПрофили.ПерсональнаяГруппаДоступа
	|ИЗ
	|	ПрофилиИзмененныхГрупп КАК ПрофилиИзмененныхГрупп
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Профили КАК Профили
	|		ПО ПрофилиИзмененныхГрупп.Профиль = Профили.Ссылка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТекущиеПрофили КАК ТекущиеПрофили
	|		ПО ПрофилиИзмененныхГрупп.Профиль = ТекущиеПрофили.Ссылка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ПрофилиГруппДоступа КАК СправочникПрофили
	|		ПО (СправочникПрофили.Ссылка = ПрофилиИзмененныхГрупп.Профиль)";
	
	НачатьТранзакцию();
	Попытка
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			
			Если ЗначениеЗаполнено(Выборка.ПерсональнаяГруппаДоступа) Тогда
				ЗаблокироватьДанныеДляРедактирования(Выборка.ПерсональнаяГруппаДоступа);
				ГруппаДоступаОбъект = Выборка.ПерсональнаяГруппаДоступа.ПолучитьОбъект();
			Иначе
				// Создание персональной группы доступа.
				ГруппаДоступаОбъект = Справочники.ГруппыДоступа.СоздатьЭлемент();
				ГруппаДоступаОбъект.Родитель     = Справочники.ГруппыДоступа.РодительПерсональныхГруппДоступа();
				ГруппаДоступаОбъект.Наименование = Выборка.ПрофильНаименование;
				ГруппаДоступаОбъект.Пользователь = Параметры.Пользователь;
				ГруппаДоступаОбъект.Профиль      = Выборка.Профиль;
			КонецЕсли;
			
			Если Выборка.Профиль = Справочники.ПрофилиГруппДоступа.Администратор Тогда
				
				Если ТребуетсяСинхронизацияССервисом Тогда
					ГруппаДоступаОбъект.ДополнительныеСвойства.Вставить("ПарольПользователяСервиса", ПарольПользователяСервиса);
				КонецЕсли;
				
				Если Выборка.Пометка Тогда
					Если ГруппаДоступаОбъект.Пользователи.Найти(
							Параметры.Пользователь, "Пользователь") = Неопределено Тогда
						
						ГруппаДоступаОбъект.Пользователи.Добавить().Пользователь = Параметры.Пользователь;
					КонецЕсли;
				Иначе
					ОписаниеПользователя =  ГруппаДоступаОбъект.Пользователи.Найти(
						Параметры.Пользователь, "Пользователь");
					
					Если ОписаниеПользователя <> Неопределено Тогда
						ГруппаДоступаОбъект.Пользователи.Удалить(ОписаниеПользователя);
						
						Если НЕ ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
							// Проверка пустого списка пользователей ИБ в группе доступа Администраторы.
							ОписаниеОшибки = "";
							УправлениеДоступомСлужебный.ПроверитьНаличиеПользователяИБВГруппеДоступаАдминистраторы(
								ГруппаДоступаОбъект.Пользователи, ОписаниеОшибки);
							
							Если ЗначениеЗаполнено(ОписаниеОшибки) Тогда
								ВызватьИсключение
									НСтр("ru = 'Профиль Администратор должен быть хотя бы у одного пользователя,
									           |которому разрешен вход в программу.'");
							КонецЕсли;
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
			Иначе
				ГруппаДоступаОбъект.Пользователи.Очистить();
				Если Выборка.Пометка Тогда
					ГруппаДоступаОбъект.Пользователи.Добавить().Пользователь = Параметры.Пользователь;
				КонецЕсли;
				
				Отбор = Новый Структура("ГруппаДоступа", Выборка.Профиль);
				
				ГруппаДоступаОбъект.ВидыДоступа.Загрузить(
					ВидыДоступа.Выгрузить(Отбор, "ВидДоступа, ВсеРазрешены"));
				
				ГруппаДоступаОбъект.ЗначенияДоступа.Загрузить(
					ЗначенияДоступа.Выгрузить(Отбор, "ВидДоступа, ЗначениеДоступа"));
			КонецЕсли;
			
			Попытка
				ГруппаДоступаОбъект.Записать();
			Исключение
				ПарольПользователяСервиса = Неопределено;
				ВызватьИсключение;
			КонецПопытки;
			
			Если ЗначениеЗаполнено(Выборка.ПерсональнаяГруппаДоступа) Тогда
				РазблокироватьДанныеДляРедактирования(Выборка.ПерсональнаяГруппаДоступа);
			КонецЕсли;
		КонецЦикла;
		ЗафиксироватьТранзакцию();
		Модифицированность = Ложь;
		ТребуетсяСинхронизацияССервисом = Ложь;
	Исключение
		ОтменитьТранзакцию();
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			КраткоеПредставлениеОшибки(ИнформацияОбОшибке()), , , , Отказ);
	КонецПопытки;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ПриИзмененииТекущегоПрофиля(Знач Форма, Знач НаКлиенте = Истина)
	
	Элементы    = Форма.Элементы;
	Профили     = Форма.Профили;
	ВидыДоступа = Форма.ВидыДоступа;
	
	Если НаКлиенте Тогда
		ТекущиеДанные = Элементы.Профили.ТекущиеДанные;
	Иначе
		ТекущиеДанные = Профили.НайтиПоИдентификатору(?(Элементы.Профили.ТекущаяСтрока = Неопределено, -1, Элементы.Профили.ТекущаяСтрока));
	КонецЕсли;
	
	Форма.ТекущийПрофиль = Неопределено;
	РедактированиеТекущихОграничений = Ложь;
	
	Если ТекущиеДанные <> Неопределено Тогда
		Форма.ТекущийПрофиль = ТекущиеДанные.Профиль;
		РедактированиеТекущихОграничений = ТекущиеДанные.Пометка
		                                   И Форма.ТекущийПрофиль <> Форма.ПрофильАдминистратор
		                                   И НЕ Форма.ТолькоПросмотр;
	КонецЕсли;
	
	Элементы.Доступ.Доступность                             =    ТекущиеДанные <> Неопределено И ТекущиеДанные.Пометка;
	Элементы.ВидыДоступа.ТолькоПросмотр                     = НЕ РедактированиеТекущихОграничений;
	Элементы.ЗначенияДоступаПоВидуДоступа.Доступность       =    ТекущиеДанные <> Неопределено И ТекущиеДанные.Пометка;
	Элементы.ЗначенияДоступа.ТолькоПросмотр                 = НЕ РедактированиеТекущихОграничений;
	Элементы.ВидыДоступаКонтекстноеМенюИзменить.Доступность =    РедактированиеТекущихОграничений;
	
	Если Форма.ТекущийПрофиль = Неопределено Тогда
		Форма.ТекущаяГруппаДоступа = "";
	Иначе
		Форма.ТекущаяГруппаДоступа = Форма.ТекущийПрофиль;
	КонецЕсли;
	
	Если Элементы.ВидыДоступа.ОтборСтрок = Неопределено
	 ИЛИ Элементы.ВидыДоступа.ОтборСтрок.ГруппаДоступа <> Форма.ТекущаяГруппаДоступа Тогда
		
		Если Элементы.ВидыДоступа.ОтборСтрок = Неопределено Тогда
			ОтборСтрок = Новый Структура;
		Иначе
			ОтборСтрок = Новый Структура(Элементы.ВидыДоступа.ОтборСтрок);
		КонецЕсли;
		ОтборСтрок.Вставить("ГруппаДоступа", Форма.ТекущаяГруппаДоступа);
		Элементы.ВидыДоступа.ОтборСтрок = Новый ФиксированнаяСтруктура(ОтборСтрок);
		ТекущиеВидыДоступа = ВидыДоступа.НайтиСтроки(Новый Структура("ГруппаДоступа", Форма.ТекущаяГруппаДоступа));
		Если ТекущиеВидыДоступа.Количество() = 0 Тогда
			Элементы.ЗначенияДоступа.ОтборСтрок = Новый ФиксированнаяСтруктура("ГруппаДоступа, ВидДоступа", Форма.ТекущаяГруппаДоступа, "");
			УправлениеДоступомСлужебныйКлиентСервер.ПриИзмененииТекущегоВидаДоступа(Форма, НаКлиенте);
		Иначе
			Элементы.ВидыДоступа.ТекущаяСтрока = ТекущиеВидыДоступа[0].ПолучитьИдентификатор();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
