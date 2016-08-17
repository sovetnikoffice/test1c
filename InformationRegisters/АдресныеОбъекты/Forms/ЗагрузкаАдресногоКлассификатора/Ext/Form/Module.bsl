﻿// Форма параметризуется. Необязательные параметры:
//
//     КодРегионаДляЗагрузки      - Число, Строка, Массив - Код субъекта РФ (или их массив), загрузка которого
//                                  предлагается.
//     НазваниеРегионаДляЗагрузки - Строка                - Название субъекта РФ, загрузка которого предлагается.
//     Режим                      - Строка                - Режим работы формы.
//
//   Если указан параметр КодРегионаДляЗагрузки или НазваниеРегионаДляЗагрузки, то предлагаемый регион или регионы
// будут отмечены для загрузки, первый из них выделен как текущий.
//   Если параметр Режим равен "ПроверкаОбновления", то будет запущена проверка обновления на сайте и предложено 
// загрузить обновленные.
//

&НаКлиенте
Перем ПодтверждениеЗакрытияФормы;

// Параметры загрузки для передачи между клиентскими вызовами.
&НаКлиенте
Перем ПараметрыФоновойЗагрузкиКлассификатора;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыДлительнойОперации = Новый Структура("Завершено, АдресРезультата, Идентификатор, Ошибка, ПодробноеПредставлениеОшибки");
	ПараметрыДлительнойОперации.Вставить("ИнтервалОжидания", 5);
	ОставшиесяКоличествоПопытокПолучитьОбновление = 20;
	
	ЗаполнитьЗначенияСвойств(ДоступныеИсточникиЗагрузки.Добавить(), Элементы.ДоступныеИсточникиЗагрузки.СписокВыбора[0]);
	ЗаполнитьЗначенияСвойств(ДоступныеИсточникиЗагрузки.Добавить(), Элементы.ДоступныеИсточникиЗагрузки.СписокВыбора[1]);
	
	// Умолчание, возможно будет перекрыто при восстановлении настроек.
	КодИсточникаЗагрузки = "КАТАЛОГ";
	
	// Получаем уже загруженные регионы.
	ТаблицаРегионов = АдресныйКлассификаторСлужебный.СведенияОЗагрузкеСубъектовРФ();
	ТаблицаРегионов.Колонки.Добавить("Загружать", Новый ОписаниеТипов("Булево"));
	
	Для Каждого Регион Из ТаблицаРегионов Цикл
		Регион.Представление = " " + Формат(Регион.КодСубъектаРФ, "ЧЦ=2; ЧН=; ЧВН=; ЧГ=") + ", " + Регион.Представление;
	КонецЦикла;
	
	ТекущийКодРегиона = Неопределено;
	Параметры.Свойство("КодРегионаДляЗагрузки", ТекущийКодРегиона);
	
	// Анализируем варианты работы - нас могли вызвать для проверки обновления.
	ИдентификаторыДляОбновления = Новый Массив;
	ТаблицаРегионов.ЗагрузитьКолонку(ТаблицаРегионов.ВыгрузитьКолонку("Загружено"), "Загружать");
	
	// Добавляем пометку для загружаемого региона-параметра и ставим его текущей строкой.
	ТипТекущегоКодаРегиона = ТипЗнч(ТекущийКодРегиона);
	ТипЧисло               = Новый ОписаниеТипов("Число");
	
	Если ТипТекущегоКодаРегиона = Тип("Массив") И ТекущийКодРегиона.Количество() > 0 Тогда
		// Указан массив для загрузки
		Фильтр = Новый Структура("КодСубъектаРФ");
		Для Каждого КодРегиона Из ТекущийКодРегиона Цикл 
			Фильтр.КодСубъектаРФ = ТипЧисло.ПривестиЗначение(КодРегиона);
			Кандидаты = ТаблицаРегионов.НайтиСтроки(Фильтр); 
			Если Кандидаты.Количество() > 0 Тогда
				Кандидаты[0].Загружать = Истина;
			КонецЕсли;
		КонецЦикла;
		ТекущийКодРегиона = ТекущийКодРегиона[0];
		
	ИначеЕсли ТипТекущегоКодаРегиона = Тип("Строка") Тогда
		// Как код
		ТекущийКодРегиона = ТипЧисло.ПривестиЗначение(ТекущийКодРегиона);
		
	ИначеЕсли Параметры.Свойство("НазваниеРегионаДляЗагрузки") Тогда
		// Как наименование
		ТекущийКодРегиона = АдресныйКлассификатор.КодРегионаПоНаименованию(Параметры.НазваниеРегионаДляЗагрузки);
		
	КонецЕсли;
	
	ЗначениеВРеквизитФормы(ТаблицаРегионов, "СубъектыРФ");
	
	// Установка текущей строки по коду.
	Если ТекущийКодРегиона <> Неопределено Тогда
		Кандидаты = СубъектыРФ.НайтиСтроки(Новый Структура("КодСубъектаРФ",  ТекущийКодРегиона)); 
		Если Кандидаты.Количество() > 0 Тогда
			ТекущаяСтрока = Кандидаты[0];
			ТекущаяСтрока.Загружать = Истина;
			Элементы.СубъектыРФ.ТекущаяСтрока = ТекущаяСтрока.ПолучитьИдентификатор();
		КонецЕсли;
	КонецЕсли;
	
	// Если не установили текущую строку по параметру, то пытаемся поставить ее на первый отмеченный.
	Если Элементы.СубъектыРФ.ТекущаяСтрока = Неопределено Тогда
		Кандидаты = СубъектыРФ.НайтиСтроки(Новый Структура("Загружать", Истина)); 
		Если Кандидаты.Количество() > 0 Тогда
			Элементы.СубъектыРФ.ТекущаяСтрока = Кандидаты[0].ПолучитьИдентификатор();
		КонецЕсли;
	КонецЕсли;
	
	// Зависимости от интерфейса
	Если ТекущийВариантИнтерфейсаКлиентскогоПриложения() = ВариантИнтерфейсаКлиентскогоПриложения.Версия8_2 Тогда
		Элементы.АдресЗагрузки.КартинкаКнопкиВыбора = Новый Картинка;
	КонецЕсли;
	
	Аутентификация = СохраненныеДанныеАутентификацииСайта();
	Элементы.АвторизацияНаСайтеПоддержкиПользователей.Видимость = ПустаяСтрока(Аутентификация.Пароль);
	Элементы.ИнформацияОбОбновление.Видимость = НЕ Элементы.АвторизацияНаСайтеПоддержкиПользователей.Видимость;

	ПроверитьДоступностьОбновления();
	
	// Автосохранение настроек
	СохраняемыеВНастройкахДанныеМодифицированы = Истина;
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	// Контроль корректности кода источника данных для загрузки.
	КодИсточника = Настройки["КодИсточникаЗагрузки"];
	Если ДоступныеИсточникиЗагрузки.НайтиПоЗначению(КодИсточника) = Неопределено Тогда
		// Оставляем умолчания
		Настройки.Удалить("КодИсточникаЗагрузки");
		Настройки.Удалить("АдресЗагрузки");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ПредупреждениеПриОткрытии <> "" Тогда
		ПоказатьПредупреждение(, ПредупреждениеПриОткрытии);
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ОбновитьИнтерфейсПоКоличествуЗагружаемых();
	УстановитьДоступностьИсточниковЗагрузки();
	
	ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 0.5, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если Элементы.ШагиЗагрузки.ТекущаяСтраница <> Элементы.ОжиданиеЗагрузки 
		Или ПодтверждениеЗакрытияФормы = Истина Тогда
		Возврат;
	КонецЕсли;		
	
	Оповещение = Новый ОписаниеОповещения("ЗакрытиеФормыЗавершение", ЭтотОбъект);
	Отказ = Истина;
	
	Текст = НСтр("ru = 'Прервать загрузку адресного классификатора?'");
	ПоказатьВопрос(Оповещение, Текст, РежимДиалогаВопрос.ДаНет);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	Если ПараметрыДлительнойОперации.Идентификатор <> Неопределено Тогда
		ОтменитьФоновоеЗадание(ПараметрыДлительнойОперации.Идентификатор);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура АдресЗагрузкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	АдресныйКлассификаторКлиент.ВыбратьКаталог(ЭтотОбъект, "АдресЗагрузки", 
		НСтр("ru = 'Каталог с файлами адресного классификатора'"),
		СтандартнаяОбработка,
		Новый ОписаниеОповещения("ЗавершениеВыбораКаталогаАдресаЗагрузки", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура СубъектыРФЗагружатьПриИзменении(Элемент)
	
	ОбновитьИнтерфейсПоКоличествуЗагружаемых();
	
КонецПроцедуры

&НаКлиенте
Процедура ДоступныеИсточникиЗагрузкиПриИзменении(Элемент)
	
	УстановитьДоступностьИсточниковЗагрузки();
	
КонецПроцедуры

&НаКлиенте
Процедура АдресЗагрузкиПриИзменении(Элемент)
	
	УстановитьИсточникомЗагрузкиКаталог();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСубъектыРФ

&НаКлиенте
Процедура СубъектыРФВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	Если Поле = Элементы.СубъектыРФПредставление Тогда
		ТекущиеДанные = СубъектыРФ.НайтиПоИдентификатору(ВыбраннаяСтрока);
		Если ТекущиеДанные <> Неопределено Тогда
			ТекущиеДанные.Загружать = Не ТекущиеДанные.Загружать;
			ОбновитьИнтерфейсПоКоличествуЗагружаемых();
		КонецЕсли
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	
	УстановитьПометкиСпискаРегионов(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	УстановитьПометкиСпискаРегионов(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура Загрузить(Команда)
	
	Если КодИсточникаЗагрузки = "КАТАЛОГ" Тогда
		Текст = НСтр("ru = 'Для загрузки адресного классификатора из папки
		                   |необходимо установить расширение для работы с файлами.'");
		КонтрольРасширенияРаботыСФайлами(Текст, КодИсточникаЗагрузки, АдресЗагрузки);
		
	ИначеЕсли КодИсточникаЗагрузки = "САЙТ" Тогда
		ЗагрузитьКлассификаторССайта(Аутентификация);
		
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю( НСтр("ru = 'Не указан вариант загрузки классификатора.'") );
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ПрерватьЗагрузку(Команда)
	
	ПодтверждениеЗакрытияФормы = Неопределено;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура АвторизацияНаСайтеПоддержкиПользователей(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ПослеВводаЛогинИПароля", ЭтотОбъект);
	СтандартныеПодсистемыКлиент.АвторизоватьНаСайтеПоддержкиПользователей(ЭтотОбъект, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВводаЛогинИПароля(Результат, Параметр) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура")
		И ЗначениеЗаполнено(Результат.Логин)
		И ЗначениеЗаполнено(Результат.Пароль) Тогда
			Аутентификация = Результат;
			Элементы.АвторизацияНаСайтеПоддержкиПользователей.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьБезПодтверждения(Команда)
	
	ПодтверждениеЗакрытияФормы = Истина;
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	ОставшиесяКоличествоПопытокПолучитьОбновление = ОставшиесяКоличествоПопытокПолучитьОбновление - 1;
	Если ОставшиесяКоличествоПопытокПолучитьОбновление > 0 Тогда
		Если Не ПустаяСтрока(АдресВоВременномХранилище) Тогда
			Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда
				ОбновитьДоступностьОбновления();
			Иначе	
				ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 2, Истина);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура КонтрольРасширенияРаботыСФайлами(Знач ТекстПредложения, Знач КодИсточника, Знач АдресИсточника)
	
	Оповещение = Новый ОписаниеОповещения("КонтрольРасширенияРаботыСФайламиЗавершение", ЭтотОбъект, Новый Структура);
	Оповещение.ДополнительныеПараметры.Вставить("КодИсточникаЗагрузки", КодИсточника);
	Оповещение.ДополнительныеПараметры.Вставить("АдресЗагрузки",        АдресИсточника);
	
	ОбщегоНазначенияКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(Оповещение, ТекстПредложения, Ложь);
КонецПроцедуры

// Завершение диалога предложения расширения для работы с файлами.
//
&НаКлиенте
Процедура КонтрольРасширенияРаботыСФайламиЗавершение(Знач Результат, Знач ДополнительныеПараметры) Экспорт
	
	Если Результат <> Истина Тогда
		Возврат;
	КонецЕсли;
	
	ЗагрузитьКлассификаторИзКаталога(ДополнительныеПараметры.АдресЗагрузки);
	
КонецПроцедуры

// Завершение диалога закрытия формы.
&НаКлиенте
Процедура ЗакрытиеФормыЗавершение(Знач РезультатВопроса, Знач ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ПодтверждениеЗакрытияФормы = Истина;
		Закрыть();
	Иначе 
		ПодтверждениеЗакрытияФормы = Неопределено;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьРазрешениеЗагрузки(Знач КоличествоЗагружаемых = Неопределено)
	
	Если КоличествоЗагружаемых = Неопределено Тогда
		Фильтр = Новый Структура("Загружать", Истина);
		КоличествоЗагружаемых = СубъектыРФ.НайтиСтроки(Фильтр).Количество();
	КонецЕсли;
	
	Элементы.Загрузить.Доступность = (КоличествоЗагружаемых > 0)
		И ДоступныеИсточникиЗагрузки.НайтиПоЗначению(КодИсточникаЗагрузки) <> Неопределено;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	УсловноеОформление.Элементы.Очистить();
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	Поля = Элемент.Поля.Элементы;
	Поля.Добавить().Поле = Новый ПолеКомпоновкиДанных("СубъектыРФКодСубъектаРФ");
	Поля.Добавить().Поле = Новый ПолеКомпоновкиДанных("СубъектыРФПредставление");

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СубъектыРФ.Загружено");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;

	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Черный);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПометкиСпискаРегионов(Знач Пометка)
	
	// Устанавливаем пометки только для видимых строк.
	ЭлементТаблицы = Элементы.СубъектыРФ;
	Для Каждого СтрокаРегиона Из СубъектыРФ Цикл
		Если ЭлементТаблицы.ДанныеСтроки( СтрокаРегиона.ПолучитьИдентификатор() ) <> Неопределено Тогда
			СтрокаРегиона.Загружать = Пометка;
		КонецЕсли;
	КонецЦикла;
	
	ОбновитьИнтерфейсПоКоличествуЗагружаемых();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПоКоличествуЗагружаемых()
	
	// Страница выбора
	ВыбраноРегионовДляЗагрузки = СубъектыРФ.НайтиСтроки( Новый Структура("Загружать", Истина) ).Количество();
	
	// Страница загрузки
	ТекстОписанияЗагрузки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Загружаются данные по выбранным регионам (%1)'"), ВыбраноРегионовДляЗагрузки);
	
	УстановитьРазрешениеЗагрузки(ВыбраноРегионовДляЗагрузки);
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьКлассификаторИзКаталога(Знач КаталогДанных)
	
	КодыРегионов = КодыРегионовДляЗагрузки();
	
	// Проверка доступности и наличия файлов.
	ПараметрыЗагрузки = Новый Структура("КодИсточникаЗагрузки, ПолеОшибки", КодИсточникаЗагрузки, "АдресЗагрузки");
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗагрузитьКлассификаторИзКаталогаЗавершение", ЭтотОбъект);
	АдресныйКлассификаторКлиент.АнализДоступностиФайловКлассификатораВКаталоге(ОписаниеОповещения, КодыРегионов, КаталогДанных, ПараметрыЗагрузки);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьКлассификаторИзКаталогаЗавершение(РезультатАнализа, ДополнительныеПараметры) Экспорт
	
	Если РезультатАнализа.Ошибки <> Неопределено Тогда
		// Не хватает файлов для загрузки по указанным режимам.
		ОчиститьСообщения();
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(РезультатАнализа.Ошибки);
		Возврат;
	КонецЕсли;
	
	// Загружаем в фоне
	УдалитьПослеПередачиНаСервер = Новый Массив;
	РезультатАнализа.Вставить("УдалитьПослеПередачиНаСервер", УдалитьПослеПередачиНаСервер);
	
	ЗапуститьФоновуюЗагрузкуИзКаталогаКлиента(РезультатАнализа);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьКлассификаторССайта(Знач Аутентификация = Неопределено)
	
	КодыРегионов = КодыРегионовДляЗагрузки();
	
	Если Аутентификация = Неопределено Тогда
		Аутентификация = СохраненныеДанныеАутентификацииСайта();
	КонецЕсли;
	
	Если ПустаяСтрока(Аутентификация.Пароль) Тогда
		// Проходим через форму авторизации принудительно.
		Оповещение = Новый ОписаниеОповещения("ЗагрузитьКлассификаторССайтаЗапросАутентификации", ЭтотОбъект, Новый Структура);
		Оповещение.ДополнительныеПараметры.Вставить("КодыРегионов", КодыРегионов);
		СтандартныеПодсистемыКлиент.АвторизоватьНаСайтеПоддержкиПользователей(ЭтотОбъект, Оповещение);
		Возврат;
	КонецЕсли;
	
	ЗагрузитьКлассификаторССайтаАутентификация(Аутентификация, КодыРегионов);
КонецПроцедуры

// Завершение диалога авторизации.
//
&НаКлиенте
Процедура ЗагрузитьКлассификаторССайтаЗапросАутентификации(Знач Аутентификация, Знач ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Аутентификация) <> Тип("Структура") Тогда
		// Возвращаемся на страницу выбора.
		Элементы.ШагиЗагрузки.ТекущаяСтраница = Элементы.ВыборРегионовЗагрузки;
		Возврат;
		
	ИначеЕсли ПустаяСтрока(Аутентификация.Логин) Или ПустаяСтрока(Аутентификация.Пароль) Тогда
		// На повторный ввод пароля
		ЗагрузитьКлассификаторССайта(Аутентификация);
		Возврат;
		
	КонецЕсли;
	
	ЗагрузитьКлассификаторССайтаАутентификация(Аутентификация, ДополнительныеПараметры.КодыРегионов);
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьКлассификаторССайтаАутентификация(Знач Аутентификация, Знач КодыРегионов)
	
	ОчиститьСообщения();
	
	// Переключаем режим - страницу.
	Элементы.ШагиЗагрузки.ТекущаяСтраница = Элементы.ОжиданиеЗагрузки;
	ТекстСостоянияЗагрузки = НСтр("ru = 'Загрузка файлов с сайта поддержки пользователей...'");
	
	Элементы.ПрерватьЗагрузку.Доступность = Ложь;
	
	ПараметрыФоновойЗагрузкиКлассификатора = Новый Структура;
	ПараметрыФоновойЗагрузкиКлассификатора.Вставить("Аутентификация", Аутентификация);
	ПараметрыФоновойЗагрузкиКлассификатора.Вставить("КодыРегионов",   КодыРегионов);
	
	ПодключитьОбработчикОжидания("ЗагрузитьКлассификаторССайтаФИАС", 0.1, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьКлассификаторССайтаФИАС()
	КодыРегионов   = ПараметрыФоновойЗагрузкиКлассификатора.КодыРегионов;
	Аутентификация = ПараметрыФоновойЗагрузкиКлассификатора.Аутентификация;
	
	ПараметрыФоновойЗагрузкиКлассификатора = Неопределено;
	
	ЗапуститьФоновуюЗагрузкуССайтаНаСервере(КодыРегионов, Аутентификация);
	ПодключитьОбработчикОжидания("Подключаемый_ОжиданиеДлительнойОперации", 0.1, Истина);
КонецПроцедуры

&НаСервере
Процедура ЗапуститьФоновуюЗагрузкуССайтаНаСервере(КодыРегионов, Аутентификация)
	
	ПараметрыМетода = Новый Массив;
	ПараметрыМетода.Добавить(КодыРегионов);
	ПараметрыМетода.Добавить(Аутентификация);
	
	ПараметрыДлительнойОперации.Идентификатор   = Неопределено;
	ПараметрыДлительнойОперации.Завершено       = Истина;
	ПараметрыДлительнойОперации.АдресРезультата = Неопределено;
	ПараметрыДлительнойОперации.ПодробноеПредставлениеОшибки = Неопределено;
	ПараметрыДлительнойОперации.Ошибка                       = Неопределено;
	
	Попытка
		РезультатЗапуска = ДлительныеОперации.ЗапуститьВыполнениеВФоне(УникальныйИдентификатор,
			"АдресныйКлассификаторСлужебный.ФоновоеЗаданиеЗагрузкиКлассификатораАдресовССайта",
			ПараметрыМетода,
			НСтр("ru = 'Загрузка адресного классификатора с сайта'"));
	Исключение
		Информация = ИнформацияОбОшибке();
		КраткоеПредставлениеОшибки = КраткоеПредставлениеОшибки(Информация);
		Если СтрНайти(КраткоеПредставлениеОшибки , "404 Not Found") > 0 ИЛИ СтрНайти(КраткоеПредставлениеОшибки , "401 Unauthorized") > 0 Тогда
			ТекстОшибки = НСтр("ru = 'Не удается загрузить адресные сведения.'");
			ТекстОшибки = ТекстОшибки + НСтр("ru = 'Возможные причины:'") + Символы.ПС;
			ТекстОшибки = ТекстОшибки + НСтр("ru = '• Некорректно введен или не введен логин и пароль;'") + Символы.ПС;
			ТекстОшибки = ТекстОшибки + НСтр("ru = '• Нет подключения к Интернету;'") + Символы.ПС;
			ТекстОшибки = ТекстОшибки + НСтр("ru = '• На сайте ведутся технические работы. Попробуйте повторить загрузку позднее.'") + Символы.ПС;
			ТекстОшибки = ТекстОшибки + НСтр("ru = '• Брандмауэр или другое промежуточное ПО (антивирусы и т.п.) блокируют попытки программы подключиться к Интернету;'") + Символы.ПС;
			ТекстОшибки = ТекстОшибки + НСтр("ru = '• Подключение к Интернету выполняется через прокси-сервер, но его параметры не заданы в программе.'") + Символы.ПС;
			ТекстОшибки = ТекстОшибки + НСтр("ru = 'Техническая информация:'") + " " + Символы.ПС;
			ТекстОшибки = ТекстОшибки + СтрПолучитьСтроку(КраткоеПредставлениеОшибки(Информация), 1);
		Иначе
			ТекстОшибки = НСтр("ru = 'Вероятно в данный момент на сайте ведутся технические работы. Попробуйте повторить загрузку позднее.'") + Символы.ПС;
			ТекстОшибки = ТекстОшибки + НСтр("ru = 'Техническая информация:'") + " " + Символы.ПС;
			ТекстОшибки = ТекстОшибки + КраткоеПредставлениеОшибки(Информация);
		КонецЕсли;
		ПараметрыДлительнойОперации.Ошибка = ТекстОшибки;
		ПараметрыДлительнойОперации.ПодробноеПредставлениеОшибки = ПодробноеПредставлениеОшибки(Информация);
		Элементы.АвторизацияНаСайтеПоддержкиПользователей.Видимость = Истина;

		Возврат;
	КонецПопытки;
	
	ПараметрыДлительнойОперации.Идентификатор   = РезультатЗапуска.ИдентификаторЗадания;
	ПараметрыДлительнойОперации.Завершено       = РезультатЗапуска.ЗаданиеВыполнено;
	ПараметрыДлительнойОперации.АдресРезультата = РезультатЗапуска.АдресХранилища;
	
	Элементы.ПрерватьЗагрузку.Доступность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ЗапуститьФоновуюЗагрузкуИзКаталогаКлиента(Знач ПараметрыЗагрузки)
	// Переключаем режим - страницу.
	Элементы.ШагиЗагрузки.ТекущаяСтраница = Элементы.ОжиданиеЗагрузки;
	ТекстСостоянияЗагрузки = НСтр("ru = 'Передача файлов на сервер приложения...'");
	
	Элементы.ПрерватьЗагрузку.Доступность = Ложь;
	ПараметрыФоновойЗагрузкиКлассификатора = ПараметрыЗагрузки;
	ПодключитьОбработчикОжидания("ЗапуститьФоновуюЗагрузкуИзКаталогаКлиентаПродолжение", 0.1, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ЗапуститьФоновуюЗагрузкуИзКаталогаКлиентаПродолжение()
	ПараметрыЗагрузки = ПараметрыФоновойЗагрузкиКлассификатора;
	ПараметрыФоновойЗагрузкиКлассификатора = Неопределено;
	
	Если ПараметрыЗагрузки = Неопределено Тогда
		// Возвращаемся на страницу выбора.
		Элементы.ШагиЗагрузки.ТекущаяСтраница = Элементы.ВыборРегионовЗагрузки;
		Возврат;
	КонецЕсли;
		
	// Список передаваемых на сервер файлов.
	ПомещаемыеФайлы = Новый Массив;
	Для Каждого КлючЗначение Из ПараметрыЗагрузки.ФайлыПоРегионам Цикл
		Если ТипЗнч(КлючЗначение.Значение) = Тип("Массив") Тогда
			Для Каждого ИмяФайла Из КлючЗначение.Значение Цикл
				ПомещаемыеФайлы.Добавить(Новый ОписаниеПередаваемогоФайла(ИмяФайла));
			КонецЦикла;
		Иначе
			ПомещаемыеФайлы.Добавить(Новый ОписаниеПередаваемогоФайла(КлючЗначение.Значение));
		КонецЕсли;
	КонецЦикла;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ПараметрыЗагрузки", ПараметрыЗагрузки);
	ДополнительныеПараметры.Вставить("Позиция", 0);
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗапуститьФоновуюЗагрузкуИзКаталогаКлиентаПослеПомещенияФайлов",
		ЭтотОбъект, ДополнительныеПараметры);
	НачатьПомещениеФайлов(ОписаниеОповещения, ПомещаемыеФайлы,, Ложь, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапуститьФоновуюЗагрузкуИзКаталогаКлиентаПослеПомещенияФайлов(ПомещенныеФайлы, ДополнительныеПараметры) Экспорт
	
	Позиция = ДополнительныеПараметры.Позиция;
	Если Позиция <= ПомещенныеФайлы.ВГраница() Тогда
		
		// Сохраняем время изменения - версию.
		Описание = ПомещенныеФайлы[Позиция];
		
		ДанныеФайла = Новый Структура("Имя, Хранение");
		ЗаполнитьЗначенияСвойств(ДанныеФайла, Описание);
		
		ДополнительныеПараметры.Вставить("ДанныеФайла", ДанныеФайла);
		ДополнительныеПараметры.Вставить("ПомещенныеФайлы", ПомещенныеФайлы);
		ОписаниеОповещения = Новый ОписаниеОповещения("ЗапуститьФоновуюЗагрузкуИзКаталогаКлиентаПослеИнициализации", ЭтотОбъект, ДополнительныеПараметры);
		
		Файл = Новый Файл();
		Файл.НачатьИнициализацию(ОписаниеОповещения, Описание.Имя);
		
	Иначе
		
		// Запуск фонового по загрузке из переданных файлов.
		Если ЭтоАдресВременногоХранилища(ПараметрыДлительнойОперации.АдресРезультата) Тогда
			УдалитьИзВременногоХранилища(ПараметрыДлительнойОперации.АдресРезультата);
		КонецЕсли;
		ПараметрыДлительнойОперации.АдресРезультата = Неопределено;
		
		Режим = Неопределено;
		ДополнительныеПараметры.ПараметрыЗагрузки.Свойство("Режим", Режим);
		
		ЗапуститьФоновуюЗагрузкуНаСервере(ДополнительныеПараметры.ПараметрыЗагрузки.КодыРегионов, ПомещенныеФайлы, Режим);
		ПодключитьОбработчикОжидания("Подключаемый_ОжиданиеДлительнойОперации", 0.1, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапуститьФоновуюЗагрузкуИзКаталогаКлиентаПослеИнициализации(Файл, ДополнительныеПараметры) Экспорт
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗапуститьФоновуюЗагрузкуИзКаталогаКлиентаПослеПолученияВремениИзменения",
		ЭтотОбъект, ДополнительныеПараметры);
	Файл.НачатьПолучениеУниверсальногоВремениИзменения(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапуститьФоновуюЗагрузкуИзКаталогаКлиентаПослеПолученияВремениИзменения(ВремяИзменения, ДополнительныеПараметры) Экспорт
	
	ДополнительныеПараметры.ДанныеФайла.Вставить("ВремяИзменения", ВремяИзменения);
	ДополнительныеПараметры.ПомещенныеФайлы[ДополнительныеПараметры.Позиция] = ДополнительныеПараметры.ДанныеФайла;
	ДополнительныеПараметры.Позиция = ДополнительныеПараметры.Позиция + 1;
	ЗапуститьФоновуюЗагрузкуИзКаталогаКлиентаПослеПомещенияФайлов(ДополнительныеПараметры.ПомещенныеФайлы, ДополнительныеПараметры);
	
КонецПроцедуры

&НаСервере
Процедура ЗапуститьФоновуюЗагрузкуНаСервере(Знач КодыРегионов, Знач ОписаниеФайловЗагрузки, Знач Режим)
	ПараметрыМетода = Новый Массив;
	ПараметрыМетода.Добавить(КодыРегионов);
	
	// Файлы преобразуем в двоичные данные - хранилище не может быть разделено с сеансом фонового задания.
	ОписаниеФайлов = Новый Массив;
	Для Каждого Описание Из ОписаниеФайловЗагрузки Цикл
		
		ДанныеФайла = Новый Структура("Имя, ВремяИзменения");
		ЗаполнитьЗначенияСвойств(ДанныеФайла, Описание);
		ДанныеФайла.Вставить("Хранение", ПолучитьИзВременногоХранилища(Описание.Хранение));
		
		ОписаниеФайлов.Добавить(ДанныеФайла);
	КонецЦикла;
	ПараметрыМетода.Добавить(ОписаниеФайлов);
	
	ПараметрыМетода.Добавить(Режим);
	
	ПараметрыДлительнойОперации.Идентификатор   = Неопределено;
	ПараметрыДлительнойОперации.Завершено       = Истина;
	ПараметрыДлительнойОперации.АдресРезультата = Неопределено;
	ПараметрыДлительнойОперации.Ошибка          = Неопределено;
	
	Попытка
		РезультатЗапуска = ДлительныеОперации.ЗапуститьВыполнениеВФоне(УникальныйИдентификатор,
			"АдресныйКлассификаторСлужебный.ФоновоеЗаданиеЗагрузкиКлассификатораАдресов",
			ПараметрыМетода,
			НСтр("ru = 'Загрузка адресного классификатора'"));
	Исключение
		ТекстОшибки = НСтр("ru = 'Не удается загрузить адресные сведения из файлов.'");
		ТекстОшибки = ТекстОшибки + НСтр("ru = 'Необходимо сохранить файлы с сайта «1С» http://its.1c.ru/download/fias на диск, а затем загрузить в программу.'") + Символы.ПС;
		ТекстОшибки = ТекстОшибки + НСтр("ru = 'Техническая информация:'") + Символы.ПС + КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		ПараметрыДлительнойОперации.Ошибка = ТекстОшибки;
		Возврат;
	КонецПопытки;
	
	ПараметрыДлительнойОперации.Идентификатор   = РезультатЗапуска.ИдентификаторЗадания;
	ПараметрыДлительнойОперации.Завершено       = РезультатЗапуска.ЗаданиеВыполнено;
	ПараметрыДлительнойОперации.АдресРезультата = РезультатЗапуска.АдресХранилища;
	
	Элементы.ПрерватьЗагрузку.Доступность = Истина;
КонецПроцедуры

&НаСервере
Функция СостояниеФоновогоЗадания()
	Результат = Новый Структура("Прогресс, Завершено, Ошибка, ПодробноеПредставлениеОшибки");
	
	Результат.Ошибка = "";
	Если ПараметрыДлительнойОперации.Идентификатор = Неопределено Тогда
		Результат.Завершено = Истина;
		Результат.Прогресс  = Неопределено;
		Результат.ПодробноеПредставлениеОшибки = ПараметрыДлительнойОперации.ПодробноеПредставлениеОшибки;
		Результат.Ошибка                       = ПараметрыДлительнойОперации.Ошибка;
	Иначе
		Попытка
			Результат.Завершено = ДлительныеОперации.ЗаданиеВыполнено(ПараметрыДлительнойОперации.Идентификатор);
			Результат.Прогресс  = ДлительныеОперации.ПрочитатьПрогресс(ПараметрыДлительнойОперации.Идентификатор);
		Исключение
			Информация = ИнформацияОбОшибке();
			Результат.ПодробноеПредставлениеОшибки = ПодробноеПредставлениеОшибки(Информация);
			Результат.Ошибка                       = КраткоеПредставлениеОшибки(Информация);
		КонецПопытки
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

&НаСервереБезКонтекста
Процедура ОтменитьФоновоеЗадание(Знач Идентификатор)
	
	Если Идентификатор <> Неопределено Тогда
		Попытка
			ДлительныеОперации.ОтменитьВыполнениеЗадания(Идентификатор);
		Исключение
			// Действие не требуется, запись в журнал регистрации уже произведена.
		КонецПопытки
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОжиданиеДлительнойОперации()
	
	// Обновим статус
	Состояние = СостояниеФоновогоЗадания();
	Если Не ПустаяСтрока(Состояние.Ошибка) Тогда
		// Завершено с ошибкой, сообщим и вернемся на первую страницу.
		Элементы.ШагиЗагрузки.ТекущаяСтраница = Элементы.ВыборРегионовЗагрузки;
		Элементы.АвторизацияНаСайтеПоддержкиПользователей.Видимость = Истина;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Состояние.Ошибка);
		Возврат;
		
	ИначеЕсли Состояние.Завершено Тогда
		Элементы.ШагиЗагрузки.ТекущаяСтраница = Элементы.УспешноеЗавершение;
		ТекстОписанияЗагрузки = НСтр("ru = 'Адресный классификатор успешно загружен.'");
		
		Оповестить("ЗагруженАдресныйКлассификатор", , ЭтотОбъект);
		
		Элементы.Закрыть.КнопкаПоУмолчанию = Истина;
		ТекущийЭлемент = Элементы.Закрыть;
		ПодтверждениеЗакрытияФормы = Истина;
		// Для сброса признака АдресныйКлассификаторУстарел в параметрах работы клиента.
		ОбновитьПовторноИспользуемыеЗначения();
		Если ЕстьУстаревшиеАдресныеСведенияКЛАДРДляУдаления() Тогда
			ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВопросаОбУдалениеКЛАДР", ЭтотОбъект);
			ТекстВопроса = НСтр("ru = 'Найдены устаревшие сведения о регионах в формате КЛАДР, которые не используются в программе.'");
			ТекстВопроса = ТекстВопроса + Символы.ПС + НСтр("ru = 'Если загруженных регионов много, то процесс очистки может занять продолжительное время.'");
			ТекстВопроса = ТекстВопроса + Символы.ПС + НСтр("ru = 'Очистить?'");
			ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		КонецЕсли;
		Возврат;
		
	КонецЕсли;
	
	// Процесс продолжается
	Если ТипЗнч(Состояние.Прогресс) = Тип("Структура") Тогда
		ТекстСостоянияЗагрузки = Состояние.Прогресс.Текст;
	КонецЕсли;
	ПодключитьОбработчикОжидания("Подключаемый_ОжиданиеДлительнойОперации", ПараметрыДлительнойОперации.ИнтервалОжидания, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВопросаОбУдалениеКЛАДР(Результат, Параметр) Экспорт
	Если Результат = КодВозвратаДиалога.Да Тогда 
		ОчиститьУстаревшиеАдресныеСведенияКЛАДР();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Функция КодыРегионовДляЗагрузки()
	Результат = Новый Массив;
	
	Для Каждого Регион Из СубъектыРФ.НайтиСтроки( Новый Структура("Загружать", Истина) ) Цикл
		Результат.Добавить(Регион.КодСубъектаРФ);
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

&НаСервереБезКонтекста
Функция СохраненныеДанныеАутентификацииСайта()
	
	Результат = СтандартныеПодсистемыСервер.ПараметрыАутентификацииНаСайте();
	Возврат ?(Результат <> Неопределено, Результат, Новый Структура("Логин,Пароль"));
	
КонецФункции

&НаКлиенте
Процедура ЗавершениеВыбораКаталогаАдресаЗагрузки(Каталог, ДополнительныеПараметры) Экспорт
	
	УстановитьИсточникомЗагрузкиКаталог();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИсточникомЗагрузкиКаталог()
	
	КодИсточникаЗагрузки = "КАТАЛОГ";

КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьИсточниковЗагрузки()
	
	Элементы.АдресЗагрузки.Доступность = КодИсточникаЗагрузки = "КАТАЛОГ";
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЕстьУстаревшиеАдресныеСведенияКЛАДРДляУдаления()
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
		|	УдалитьАдресныйКлассификатор.Код
		|ИЗ
		|	РегистрСведений.УдалитьАдресныйКлассификатор КАК УдалитьАдресныйКлассификатор";
	
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
	Если РезультатЗапроса .Следующий() Тогда 
		Возврат Истина;
	КонецЕсли;
	Возврат Ложь;
КонецФункции

&НаСервере
Процедура ПроверитьДоступностьОбновления(Знач РезультатПроверки = Неопределено)
	
	Элементы.Отступ.Видимость = Истина;
	АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(РезультатПроверки, УникальныйИдентификатор);
	Если РезультатПроверки = Неопределено Тогда
		Если ОбщегоНазначенияКлиентСервер.РежимОтладки() Тогда
			АдресныйКлассификаторСлужебный.ДоступныеВерсииАдресныхСведений(АдресВоВременномХранилище);
		Иначе
			ПараметрыПроцедуры = Новый Массив;
			ПараметрыПроцедуры.Добавить(АдресВоВременномХранилище);
			
			ПараметрыЗадания = Новый Массив;
			ПараметрыЗадания.Добавить("АдресныйКлассификаторСлужебный.ДоступныеВерсииАдресныхСведений");
			ПараметрыЗадания.Добавить(ПараметрыПроцедуры);
			
			НаименованиеЗадания = НСтр("ru = 'Проверка доступности сервиса адресного классификатора'");
			Задание = ФоновыеЗадания.Выполнить("РаботаВБезопасномРежиме.ВыполнитьМетодКонфигурации", ПараметрыЗадания,, НаименованиеЗадания);
			ИдентификаторЗадания = Задание.УникальныйИдентификатор;
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ОбновитьДоступностьОбновления()
	
	ИнформацияОбновление = ПолучитьИзВременногоХранилища(АдресВоВременномХранилище);
	АдресВоВременномХранилище = "";
	ИдентификаторЗадания = "";
	
	Если ЗначениеЗаполнено(ИнформацияОбновление) Тогда
		ОставшиесяКоличествоПопытокПолучитьОбновление = 0;
		ДатаОбновления = Формат(ИнформацияОбновление.Таблица[0].ДатаОбновления, "ДЛФ=DD");
		ИнформацияОбОбновление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Доступно обновление от %1'"), ДатаОбновления);
		Элементы.ИнформацияОбОбновление.Видимость = НЕ ИнформацияОбновление.Отказ;
	КонецЕсли;
	
КонецФункции

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Если ОбщегоНазначенияКлиентСервер.РежимОтладки() Тогда
		ЗаданиеВыполненоУспешно = Истина;
	Иначе
		ЗаданиеВыполненоУспешно = ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	КонецЕсли;
	
	Возврат ЗаданиеВыполненоУспешно;
	
КонецФункции

// Удаляет устаревшие данные КЛАДР если они есть.
//
&НаСервере
Процедура ОчиститьУстаревшиеАдресныеСведенияКЛАДР()
		
	Попытка
		ПараметрыМетода = Новый Структура();
		РезультатЗапуска = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор,
			"АдресныйКлассификаторСлужебный.ОчиститьУстаревшиеАдресныеСведенияКЛАДР",
			ПараметрыМетода, НСтр("ru = 'Очистка адресного классификатора в формате КЛАДР'"));
	Исключение
		Информация = ИнформацияОбОшибке();
		КраткоеПредставлениеОшибки = КраткоеПредставлениеОшибки(Информация);
		ТекстОшибки = НСтр("ru = 'Не удается загрузить адресные сведения.'");
		ТекстОшибки = ТекстОшибки + НСтр("ru = 'Техническая информация:'") + " " + Символы.ПС;
		ТекстОшибки = ТекстОшибки + КраткоеПредставлениеОшибки(Информация);
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Очистка адресного классификатора в формате КЛАДР'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), УровеньЖурналаРегистрации.Предупреждение,
				Метаданные.РегистрыСведений.УдалитьАдресныйКлассификатор,, ТекстОшибки);
	КонецПопытки;
КонецПроцедуры


#КонецОбласти
