﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Интерфейс для работы с подсистемой ЗапретРедактированияРеквизитовОбъектов.

// Возвращает описание блокируемых реквизитов.
//
// Возвращаемое значение:
//  Массив - содержит строки в формате ИмяРеквизита[;ИмяЭлементаФормы,...]
//           где ИмяРеквизита - имя реквизита объекта, ИмяЭлементаФормы - имя элемента формы,
//           связанного с реквизитом.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	БлокируемыеРеквизиты = Новый Массив;
	
	БлокируемыеРеквизиты.Добавить("Организация");
	БлокируемыеРеквизиты.Добавить("Партнер");
	БлокируемыеРеквизиты.Добавить("Контрагент");
	БлокируемыеРеквизиты.Добавить("Договор");
	БлокируемыеРеквизиты.Добавить("СчетаНаОплату");
	
	Возврат БлокируемыеРеквизиты;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Интерфейс для работы с подсистемой Взаимодействия.

// Возвращает партнера и контактных лиц сделки.
// 
Функция ПолучитьКонтакты(Ссылка) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Ссылка) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапросаПоКонтактам();
	Запрос.УстановитьПараметр("Предмет",Ссылка);
	
	НачатьТранзакцию();
	Попытка
		РезультатЗапроса = Запрос.Выполнить();
		
		Если РезультатЗапроса.Пустой() Тогда
			Результат = Неопределено;
		Иначе
			Результат = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Контакт");
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

Функция ТекстЗапросаПоКонтактам(ТекстВременнаяТаблица = "", Объединить = Ложь) Экспорт
	
	ШаблонВыбрать = ?(Объединить,"ВЫБРАТЬ РАЗЛИЧНЫЕ","ВЫБРАТЬ РАЗЛИЧНЫЕ РАЗРЕШЕННЫЕ");
	
	ТекстЗапроса = "
	|%ШаблонВыбрать%
	|	_ДемоЗаказПокупателя.Партнер КАК Контакт " + ТекстВременнаяТаблица + "
	|ИЗ
	|	Документ._ДемоЗаказПокупателя КАК _ДемоЗаказПокупателя
	|ГДЕ
	|	_ДемоЗаказПокупателя.Ссылка = &Предмет
	|	И (НЕ _ДемоЗаказПокупателя.Партнер = ЗНАЧЕНИЕ(Справочник._ДемоПартнеры.ПустаяСсылка))
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	_ДемоЗаказПокупателяПартнерыИКонтактныеЛица.Партнер
	|ИЗ
	|	Документ._ДемоЗаказПокупателя.ПартнерыИКонтактныеЛица КАК _ДемоЗаказПокупателяПартнерыИКонтактныеЛица
	|ГДЕ
	|	_ДемоЗаказПокупателяПартнерыИКонтактныеЛица.Ссылка = &Предмет
	|	И (НЕ _ДемоЗаказПокупателяПартнерыИКонтактныеЛица.Партнер = ЗНАЧЕНИЕ(Справочник._ДемоПартнеры.ПустаяСсылка))
	|	И _ДемоЗаказПокупателяПартнерыИКонтактныеЛица.КонтактноеЛицо = ЗНАЧЕНИЕ(Справочник._ДемоКонтактныеЛицаПартнеров.ПустаяСсылка)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	_ДемоЗаказПокупателяПартнерыИКонтактныеЛица.КонтактноеЛицо
	|ИЗ
	|	Документ._ДемоЗаказПокупателя.ПартнерыИКонтактныеЛица КАК _ДемоЗаказПокупателяПартнерыИКонтактныеЛица
	|ГДЕ
	|	_ДемоЗаказПокупателяПартнерыИКонтактныеЛица.Ссылка = &Предмет
	|	И (НЕ _ДемоЗаказПокупателяПартнерыИКонтактныеЛица.КонтактноеЛицо = ЗНАЧЕНИЕ(Справочник._ДемоКонтактныеЛицаПартнеров.ПустаяСсылка))";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"%ШаблонВыбрать%",ШаблонВыбрать);
	
	Если Объединить Тогда
		
		ТекстЗапроса = "
		| ОБЪЕДИНИТЬ ВСЕ
		|" + ТекстЗапроса;
		
	КонецЕсли;
	
	Возврат ТекстЗапроса;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Интерфейс для работы с подсистемой ГрупповоеИзменениеОбъектов.

// Возвращает список реквизитов, которые не нужно редактировать с помощью группового изменения реквизитов.
//
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	
	Результат.Добавить("АдресДоставки");
	Результат.Добавить("СтранаДоставки");
	Результат.Добавить("РегионДоставки");
	Результат.Добавить("ГородДоставки");
	
	Результат.Добавить("ЭлектроннаяПочта");
	Результат.Добавить("ДоменноеИмяСервера");
	
	Результат.Добавить("ПартнерыИКонтактныеЛица.ИдентификаторСтрокиТабличнойЧасти");
	Результат.Добавить("КонтактнаяИнформация.*");
	
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Добавление текущих дел.

// Заполняет список текущих дел пользователя.
//
// Параметры:
//  ТекущиеДела - ТаблицаЗначений - таблица значений с колонками:
//    * Идентификатор - Строка - внутренний идентификатор дела, используемый механизмом "Текущие дела".
//    * ЕстьДела      - Булево - если Истина, дело выводится в списке текущих дел пользователя.
//    * Важное        - Булево - если Истина, дело будет выделено красным цветом.
//    * Представление - Строка - представление дела, выводимое пользователю.
//    * Количество    - Число  - количественный показатель дела, выводится в строке заголовка дела.
//    * Форма         - Строка - полный путь к форме, которую необходимо открыть при нажатии на гиперссылку
//                               дела на панели "Текущие дела".
//    * ПараметрыФормы- Структура - параметры, с которыми нужно открывать форму показателя.
//    * Владелец      - Строка, объект метаданных - строковый идентификатор дела, которое будет владельцем для текущего
//                      или объект метаданных подсистема.
//    * Подсказка     - Строка - текст подсказки.
//
Процедура ПриЗаполненииСпискаТекущихДел(ТекущиеДела) Экспорт
	
	Если Не ПравоДоступа("Редактирование", Метаданные.Документы._ДемоЗаказПокупателя) Тогда
		Возврат;
	КонецЕсли;
	
	КоличествоЗаказовПокупателя = КоличествоЗаказовПокупателя();
	
	СписокОтбора = Новый СписокЗначений;
	СписокОтбора.Добавить(Перечисления._ДемоСтатусыЗаказовПокупателей.НеСогласован);
	СписокОтбора.Добавить(Перечисления._ДемоСтатусыЗаказовПокупателей.Согласован);
	
	ОтборПоСтатусу = Новый Структура("СтатусЗаказа", СписокОтбора);
	
	ИдентификаторЗаказыПокупателя = "ЗаказыПокупателя";
	Дело = ТекущиеДела.Добавить();
	Дело.Идентификатор  = ИдентификаторЗаказыПокупателя;
	Дело.ЕстьДела       = КоличествоЗаказовПокупателя.Всего > 0;
	Дело.Представление  = НСтр("ru = 'Заказы покупателя'");
	Дело.Количество     = КоличествоЗаказовПокупателя.Всего;
	Дело.Форма          = "Документ._ДемоЗаказПокупателя.Форма.ФормаСписка";
	Дело.ПараметрыФормы = Новый Структура("Отбор", ОтборПоСтатусу);
	Дело.Владелец       = Метаданные.Подсистемы._ДемоОрганайзер;
	
	Дело = ТекущиеДела.Добавить();
	Дело.Идентификатор  = "ЗаказыПокупателяНеСогласовано";
	Дело.ЕстьДела       = КоличествоЗаказовПокупателя.НеСогласовано > 0;
	Дело.Важное         = Истина;
	Дело.Представление  = НСтр("ru = 'Не согласовано'");
	Дело.Количество     = КоличествоЗаказовПокупателя.НеСогласовано;
	Дело.Владелец       = ИдентификаторЗаказыПокупателя;
	
	Дело = ТекущиеДела.Добавить();
	Дело.Идентификатор  = "ЗаказыПокупателяСогласовано";
	Дело.ЕстьДела       = КоличествоЗаказовПокупателя.Согласовано > 0;
	Дело.Представление  = НСтр("ru = 'Согласовано'");
	Дело.Количество     = КоличествоЗаказовПокупателя.Согласовано;
	Дело.Владелец       = ИдентификаторЗаказыПокупателя;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция КоличествоЗаказовПокупателя()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КОЛИЧЕСТВО(_ДемоЗаказПокупателя.Ссылка) КАК Количество
	|ИЗ
	|	Документ._ДемоЗаказПокупателя КАК _ДемоЗаказПокупателя
	|ГДЕ
	|	_ДемоЗаказПокупателя.СтатусЗаказа <> &ЗаказЗакрыт
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	КОЛИЧЕСТВО(_ДемоЗаказПокупателя.Ссылка)
	|ИЗ
	|	Документ._ДемоЗаказПокупателя КАК _ДемоЗаказПокупателя
	|ГДЕ
	|	_ДемоЗаказПокупателя.СтатусЗаказа = &ЗаказСогласован
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	КОЛИЧЕСТВО(_ДемоЗаказПокупателя.Ссылка)
	|ИЗ
	|	Документ._ДемоЗаказПокупателя КАК _ДемоЗаказПокупателя
	|ГДЕ
	|	_ДемоЗаказПокупателя.СтатусЗаказа = &ЗаказНеСогласован";
	
	Запрос.УстановитьПараметр("ЗаказСогласован", Перечисления._ДемоСтатусыЗаказовПокупателей.Согласован);
	Запрос.УстановитьПараметр("ЗаказЗакрыт", Перечисления._ДемоСтатусыЗаказовПокупателей.Закрыт);
	Запрос.УстановитьПараметр("ЗаказНеСогласован", Перечисления._ДемоСтатусыЗаказовПокупателей.НеСогласован);
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	
	Результат = Новый Структура("Всего, Согласовано, НеСогласовано");
	Результат.Всего = РезультатЗапроса[0].Количество;
	Результат.Согласовано = РезультатЗапроса[1].Количество;
	Результат.НеСогласовано = РезультатЗапроса[2].Количество;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли