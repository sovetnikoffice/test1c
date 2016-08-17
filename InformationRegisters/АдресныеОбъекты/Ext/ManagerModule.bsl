﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Обновляет данные субъектов РФ в адресных объектах.
// Записи сопоставляются по полю КодСубъектаРФ.
//
Процедура ОбновитьСоставСубъектовРФПоКлассификатору(НачальноеЗаполнениеИОбновлениеДанных = Ложь) Экспорт
	
	Классификатор = КлассификаторСубъектовРФ();
	
	// Выбираем те, которые есть в макете, но отсутствующие в регистре.
	Запрос = Новый Запрос("
		|ВЫБРАТЬ
		|	Параметр.КодСубъектаРФ КАК КодСубъектаРФ
		|ПОМЕСТИТЬ
		|	Классификатор
		|ИЗ
		|	&Классификатор КАК Параметр
		|ИНДЕКСИРОВАТЬ ПО
		|	КодСубъектаРФ
		|;
		|
		|ВЫБРАТЬ
		|	Классификатор.КодСубъектаРФ КАК КодСубъектаРФ
		|ИЗ
		|	Классификатор КАК Классификатор
		|ЛЕВОЕ СОЕДИНЕНИЕ
		|	РегистрСведений.АдресныеОбъекты КАК АдресныеОбъекты
		|ПО
		|	  АдресныеОбъекты.Уровень                    = 1
		|	И АдресныеОбъекты.КодСубъектаРФ              = Классификатор.КодСубъектаРФ
		|	И АдресныеОбъекты.КодОкруга                  = 0
		|	И АдресныеОбъекты.КодРайона                  = 0
		|	И АдресныеОбъекты.КодГорода                  = 0
		|	И АдресныеОбъекты.КодВнутригородскогоРайона  = 0
		|	И АдресныеОбъекты.КодНаселенногоПункта       = 0
		|	И АдресныеОбъекты.КодУлицы                   = 0
		|	И АдресныеОбъекты.КодДополнительногоЭлемента = 0
		|	И АдресныеОбъекты.КодПодчиненногоЭлемента    = 0
		|ГДЕ
		|	АдресныеОбъекты.Идентификатор ЕСТЬ NULL
		|");
	Запрос.УстановитьПараметр("Классификатор", Классификатор);
	НовыеСубъектыРФ = Запрос.Выполнить().Выгрузить();
	
	// Перезаписываем только отсутствующих.
	Набор = РегистрыСведений.АдресныеОбъекты.СоздатьНаборЗаписей();
	Отбор = Набор.Отбор.КодСубъектаРФ;
	
	Для Каждого СубъектРФ Из НовыеСубъектыРФ Цикл
		Отбор.Установить(СубъектРФ.КодСубъектаРФ);
		Набор.Очистить();
		
		ИсходныеДанные = Классификатор.Найти(СубъектРФ.КодСубъектаРФ, "КодСубъектаРФ");
		
		НовыйСубъектРФ = Набор.Добавить();
		ЗаполнитьЗначенияСвойств(НовыйСубъектРФ, ИсходныеДанные);
		НовыйСубъектРФ.Уровень = 1;
		
		Если НачальноеЗаполнениеИОбновлениеДанных Тогда
			ОбновлениеИнформационнойБазы.ЗаписатьДанные(Набор);
		Иначе
			Набор.Записать();
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Возвращает информацию из классификатора субъектов РФ.
//
// Возвращаемое значение:
//     ТаблицаЗначений - поставляемые данные. Колонки:
//       * КодСубъектаРФ  - Число  - код классификатора субъекта, например 77 для Москвы.
//       * Наименование   - Строка - наименование субъекта по классификатору. Например "Московская".
//       * Сокращение     - Строка - наименование субъекта по классификатору. Например "Обл".
//       * ПочтовыйИндекс - Число  - индекс региона. Если 0 - то неопределено.
//       * Идентификатор  - УникальныйИдентификатор - идентификатор ФИАС.
//
Функция КлассификаторСубъектовРФ() Экспорт
	
	Макет = РегистрыСведений.АдресныеОбъекты.ПолучитьМакет("КлассификаторСубъектовРФ");
	
	Чтение = Новый ЧтениеXML;
	Чтение.УстановитьСтроку(Макет.ПолучитьТекст());
	Результат = СериализаторXDTO.ПрочитатьXML(Чтение);
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли