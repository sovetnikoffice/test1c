﻿////////////////////////////////////////////////////////////////////////////////
// Проверка одного или нескольких контрагентов при помощи веб-сервиса ФНС.
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область Проверка

// Процедура - Отображение формы с предложением включить проверку контрагентов.
//
// Параметры:
//  Форма	 - УправляемаяФорма - Форма объекта, в котором выполняется проверка контрагентов.
Процедура ПредложитьВключитьПроверкуКонтрагентов(Форма) Экспорт
	
	Если Форма.РеквизитыПроверкиКонтрагентов.НужноПоказатьПредложениеВключитьПроверкуКонтрагентов Тогда
		
		ОткрытьФорму("ОбщаяФорма.ВключениеПроверкиКонтрагентов", , Форма);
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура - Проверка доступа к сервису.
Процедура ПроверитьДоступКСервису() Экспорт
	
	ТекстПредупреждения = ПроверкаКонтрагентовВызовСервера.РезультатПроверкиПараметровДоступа();
	ПоказатьПредупреждение(, ТекстПредупреждения);
	
КонецПроцедуры

// Процедура - Настройка параметров прокси сервера.
Процедура НастроитьПараметрыПроксиСервера() Экспорт
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПолучениеФайловИзИнтернета") Тогда
		МодульПолучениеФайловИзИнтернетаКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПолучениеФайловИзИнтернетаКлиент");
		МодульПолучениеФайловИзИнтернетаКлиент.ОткрытьФормуПараметровПроксиСервера();
	КонецЕсли;
	
КонецПроцедуры

// Функция - Вспомогательный API. Получает состояние контрагента из регистра сведений или из временного хранилища, если
//           передан адрес.
//
// Параметры:
//  КонтрагентСсылка - СправочникСсылка.<Контрагенты> - Проверяемый контрагент.
//  ИНН				 - Строка - ИНН контрагента.
//  КПП				 - Строка - КПП контрагента.
//  АдресХранилища	 - Строка - Адрес временного хранилища, в котором может содержаться 
//		результат проверки контрагента.
// Возвращаемое значение:
// ПеречислениеСсылка.СостоянияСуществованияКонтрагента - Состояние контрагента.
//
Функция ТекущееСостояниеКонтрагента(КонтрагентСсылка, ИНН, КПП, АдресХранилища = Неопределено) Экспорт
	
	Состояние = ПредопределенноеЗначение("Перечисление.СостоянияСуществованияКонтрагента.ПустаяСсылка");
	
	// 1. Пытаемся получить состояние контрагента из хранилища.
	Если ЗначениеЗаполнено(АдресХранилища) И ЭтоАдресВременногоХранилища(АдресХранилища) Тогда		
		Состояние = ПолучитьИзВременногоХранилища(АдресХранилища);			
	КонецЕсли;
	
	// 2. Если в хранилище нет результата, то пытаемся получить состояние из регистра.
	Если ЗначениеЗаполнено(КонтрагентСсылка) И НЕ ЗначениеЗаполнено(Состояние) Тогда
		Состояние = ПроверкаКонтрагентовВызовСервера.ТекущееСохраненноеСостояниеКонтрагента(КонтрагентСсылка, ИНН, КПП);
	КонецЕсли;
	
	Возврат Состояние;
		
КонецФункции

// Процедура - Открыть настройки сервиса.
Процедура ОткрытьНастройкиСервиса() Экспорт
	
	ОткрытьФорму("ОбщаяФорма.НастройкиПроверкиКонтрагентов");

КонецПроцедуры

#КонецОбласти

#Область ПроверкаКонтрагентовВДокументах

// Процедура - Подключение обработчиков результата проверки контрагентов из формы документа.
//
// Параметры:
//  Форма						 - УправляемаяФорма - Форма документа, в котором выполняется проверка контрагентов.
Процедура ПриОткрытииДокумент(Форма) Экспорт
	
	Если Форма.РеквизитыПроверкиКонтрагентов.ПроверкаИспользуется Тогда
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(Форма.ПроверкаКонтрагентовПараметрыОбработчикаОжидания);
		Форма.ПодключитьОбработчикОжидания("Подключаемый_ОбработатьРезультатПроверкиКонтрагентов", ИнтервалОбработкиРезультата(), Истина);
	Иначе
		Если Форма.РеквизитыПроверкиКонтрагентов.НужноПоказатьПредложениеВключитьПроверкуКонтрагентов Тогда
			Форма.ПодключитьОбработчикОжидания("Подключаемый_ПоказатьПредложениеИспользоватьПроверкуКонтрагентов", ИнтервалОбработкиРезультата(), Истина);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Процедура - Отображение предупреждения о причине выделения контрагента в строке таблице как некорректного.
//
// Параметры:
//  Форма	 - УправляемаяФорма - Форма документа, в котором выполняется проверка контрагентов.
//  Элемент	 - ТаблицаФормы - Таблица, в которой выполнили двойное нажатие на значке с информацией о наличии
//                            некорректного контрагента.
//  Поле	 - ПолеФормы - Колонка, в которой выполнили двойное нажатие на значке с информацией о наличии некорректного
//                      контрагента.
Процедура ТаблицаФормыВыбор(Форма, Элемент, Поле) Экспорт
	
	Если Форма.РеквизитыПроверкиКонтрагентов.ПроверкаИспользуется Тогда
	
		ТекущиеДанные = Элемент.ТекущиеДанные;
		Если ТекущиеДанные <> Неопределено Тогда
			Если Поле.Имя = ПроверкаКонтрагентовКлиентСервер.ИмяПоляКартинки(Элемент) Тогда
				Если ПроверкаКонтрагентовКлиентСерверПовтИсп.ЭтоСостояниеНедействующегоКонтрагента(ТекущиеДанные.Состояние, Истина) Тогда
				
					Описание = Новый Структура;
					Описание.Вставить("ДокументПустой", 		Ложь);
					Описание.Вставить("КонтрагентЗаполнен", 	Истина);
					Описание.Вставить("СостояниеКонтрагента", 	ТекущиеДанные.Состояние);
					Описание.Вставить("КонтрагентовНесколько", 	Ложь);
					
					СостояниеПроверки = ПредопределенноеЗначение("Перечисление.СостоянияПроверкиКонтрагентов.ПроверкаВыполнена");
					
					ПодсказкаВДокументе = ПроверкаКонтрагентовКлиентСервер.ПодсказкаВДокументе(Описание, СостояниеПроверки);
					ПоказатьПредупреждение(,ПодсказкаВДокументе.Текст, , НСтр("ru = 'Проверка контрагентов'"));
				КонецЕсли;
				
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
			
КонецПроцедуры

// Функция - Определяет, требует ли событие, вызванное оповещением, запуска проверки контрагентов.
//
// Параметры:
//  Форма						 - УправляемаяФорма - Форма документа, в котором выполняется проверка контрагентов.
//  ИмяСобытия					 - Строка - Имя события обработки оповещения.
//  Параметр					 - Произвольный - Параметр обработки оповещения.
//  Источник					 - Произвольный - Источник обработки оповещения.
// Возвращаемое значение:
// Булево - требует ли событие, вызванное оповещением, запуска проверки контрагентов.
Функция СобытиеТребуетПроверкиКонтрагента(Форма, ИмяСобытия, Параметр, Источник) Экспорт
	
	ТребуетсяПроверкаКонтрагентов = Ложь;
	
	РаботаСКонтрагентамиКлиентПереопределяемый.ОпределитьНеобходимостьПроверкиКонтрагентовВОбработкеОповещения(
		Форма, ИмяСобытия, Параметр, Источник, ТребуетсяПроверкаКонтрагентов);
		
	Возврат ТребуетсяПроверкаКонтрагентов;
	
КонецФункции

// Процедура - Запуск проверки контрагентов в документе после возникновения определенного события.
//
// Параметры:
//  Форма						 - УправляемаяФорма - Форма документа, в котором выполняется проверка контрагентов.
//  ДополнительныеПараметры		 - Дата - Дата документа, в случае если произошло изменение даты.
//								 - ТаблицаФормы - Если изменения произошли в табличной части.
//								 - ПолеФормы - Если изменился контрагент в определенном поле произошли в табличной части.
Процедура ЗапуститьПроверкуКонтрагентовВДокументе(Форма, ДополнительныеПараметры) Экспорт
	
	Если Форма.РеквизитыПроверкиКонтрагентов.ПроверкаИспользуется Тогда
		
		ПараметрыФоновогоЗадания = ПроверкаКонтрагентовКлиентСервер.ПараметрыФоновогоЗадания(ДополнительныеПараметры);
		Форма.ПроверитьКонтрагентовФоновоеЗадание(ПараметрыФоновогоЗадания);
		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(Форма.ПроверкаКонтрагентовПараметрыОбработчикаОжидания);
		
		Форма.ПодключитьОбработчикОжидания("Подключаемый_ОбработатьРезультатПроверкиКонтрагентов", ИнтервалОбработкиРезультата(), Истина);
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура - Обработка результата работы фонового задания по проверке контрагентов.
//
// Параметры:
//  Форма						 - УправляемаяФорма - Форма документа, в котором выполняется проверка контрагентов.
Процедура ОбработатьРезультатПроверкиКонтрагентовВДокументе(Форма) Экспорт

	Если Форма.РеквизитыПроверкиКонтрагентов.ПроверкаИспользуется Тогда
		
		// Если в настоящий момент выполняется редактирование табличной части, то результат проверки не прорисовываем,
		// чтобы не затереть данные, вводимые пользователем.
		Если НЕ Форма.РеквизитыПроверкиКонтрагентов.ОтложитьПрорисовкуРезультатаПроверкиКонтрагентов Тогда
			
			Результат = ПроверкаКонтрагентовВызовСервера.РезультатРаботыФоновогоЗаданияПроверкиКонтрагентовВДокументе(Форма.РеквизитыПроверкиКонтрагентов);
			
			// Если есть незавершившиеся фоновые задания, то продолжаем ждать результат.
			Если Результат.ЗаданиеВыполнено Тогда
				
				Форма.ПроверкаКонтрагентовПараметрыОбработчикаОжидания = Неопределено;
				Если НЕ Результат.ДанныеКонтрагентовИзКэшаСовпадаютСДаннымиФНС Тогда
					
					// Контекстный серверный вызов
					Форма.ОтобразитьРезультатПроверкиКонтрагента();
					
				КонецЕсли;
				
				// Определение объекта и ссылки.
				ОбъектИСсылкаПоФорме 	= ПроверкаКонтрагентовКлиентСервер.ОбъектИСсылкаПоФорме(Форма);
				ДокументСсылка 			= ОбъектИСсылкаПоФорме.Ссылка;
				
				ОповеститьОбИзменении(ДокументСсылка);
				
			Иначе
				
				Если Форма.ПроверкаКонтрагентовПараметрыОбработчикаОжидания <> Неопределено Тогда
					ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(Форма.ПроверкаКонтрагентовПараметрыОбработчикаОжидания);
					Форма.ПодключитьОбработчикОжидания("Подключаемый_ОбработатьРезультатПроверкиКонтрагентов", Форма.ПроверкаКонтрагентовПараметрыОбработчикаОжидания.ТекущийИнтервал, Истина);
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры

// Процедура - Запускает проверку контрагента из документа, если было определено, что возникло событие,
//	требующее обновления результата проверки контрагентов.
//
// Параметры:
//  Форма						 - УправляемаяФорма - Форма документа, в котором выполняется проверка контрагентов.
//  ИмяСобытия					 - Строка - Имя события обработки оповещения.
//  Параметр					 - Произвольный - Параметр обработки оповещения.
//  Источник					 - Произвольный - Источник обработки оповещения.
Процедура ОбработкаОповещения(Форма, ИмяСобытия, Параметр, Источник) Экспорт
	
	Если Форма.РеквизитыПроверкиКонтрагентов.ПроверкаИспользуется Тогда
		Если СобытиеТребуетПроверкиКонтрагента(Форма, ИмяСобытия, Параметр, Источник) Тогда
			
			// Добавляем в параметры источник события.
			ДополнительныеПараметры = ПроверкаКонтрагентовКлиентСервер.ПараметрыФоновогоЗадания(Источник);
			// Добавляем в параметры признак, что после проверки нужно записать результат в регистр.
			ДополнительныеПараметры = ПроверкаКонтрагентовКлиентСервер.ПараметрыФоновогоЗадания(Истина, ДополнительныеПараметры);
			
			ЗапуститьПроверкуКонтрагентовВДокументе(Форма, ДополнительныеПараметры);
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Процедура - Взводит флаг, что редактируется табличная часть.
//		Если взведен флаг, то результат проверки контрагента не будет отображен до тех пор, 
//		пока не завершится редактирование табличной части.
//
// Параметры:
//  Форма - УправляемаяФорма - Форма документа, в котором выполняется проверка контрагентов.
//
Процедура ПриНачалеРедактированияТабличнойЧасти(Форма) Экспорт
	
	Если Форма.РеквизитыПроверкиКонтрагентов.ПроверкаИспользуется Тогда
		
		Форма.РеквизитыПроверкиКонтрагентов.ОтложитьПрорисовкуРезультатаПроверкиКонтрагентов = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура - Сбрасывает флаг, что редактируется табличная часть.
//		Если взведен флаг, то результат проверки контрагента не будет отображен до тех пор, 
//		пока не завершится редактирование табличной части.
//
// Параметры:
//  Форма - УправляемаяФорма - Форма документа, в котором выполняется проверка контрагентов.
//
Процедура ПриОкончанииРедактированияТабличнойЧасти(Форма) Экспорт
	
	Если Форма.РеквизитыПроверкиКонтрагентов.ПроверкаИспользуется Тогда
		
		Форма.РеквизитыПроверкиКонтрагентов.ОтложитьПрорисовкуРезультатаПроверкиКонтрагентов = Ложь;
		
		Если Форма.ПроверкаКонтрагентовПараметрыОбработчикаОжидания <> Неопределено Тогда
			ОбработатьРезультатПроверкиКонтрагентовВДокументе(Форма);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПроверкаКонтрагентовВОтчетах

// Процедура - Подключение обработчика ожидания для отображения предложения на использование проверки.
//
// Параметры:
//  Форма	 - УправляемаяФорма - Форма отчета, в котором выполняется проверка контрагентов.
Процедура ОтчетПриОткрытии(Форма) Экспорт
	
	Если НЕ Форма.РеквизитыПроверкиКонтрагентов.ПроверкаИспользуется
		И Форма.РеквизитыПроверкиКонтрагентов.НужноПоказатьПредложениеВключитьПроверкуКонтрагентов Тогда
		Форма.ПодключитьОбработчикОжидания("Подключаемый_ПоказатьПредложениеИспользоватьПроверкуКонтрагентов", ИнтервалОбработкиРезультата(), Истина);
	КонецЕсли;
	
КонецПроцедуры

// Процедура - Сброс актуальности, сброс вида панели проверки контрагентов при изменении отборов отчета.
//
// Параметры:
//  Форма	 - УправляемаяФорма - Форма отчета, в котором выполняется проверка контрагентов.
Процедура СброситьАктуальностьОтчета(Форма) Экспорт
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Форма.Элементы.Результат, "НеАктуальность");
	ПроверкаКонтрагентовКлиентСервер.УстановитьВидПанелиПроверкиКонтрагентовВОтчете(Форма);

КонецПроцедуры

// Процедура - Запуск проверки контрагентов в отчете после первичного формирования отчета.
//
// Параметры:
//  Форма						 - УправляемаяФорма - Форма отчета, в котором выполняется проверка контрагентов.
Процедура ЗапуститьПроверкуКонтрагентовВОтчете(Форма) Экспорт
	
	Форма.РеквизитыПроверкиКонтрагентов.ПроверкаВыполнялась = Ложь;
	Если Форма.РеквизитыПроверкиКонтрагентов.ПроверкаИспользуется И Форма.ПроверкаКонтрагентовНедействующиеКонтрагенты.Количество() > 0 Тогда
		
		Если Форма.РеквизитыПроверкиКонтрагентов.ЕстьДоступКВебСервисуФНС Тогда
			Форма.ОтключитьОбработчикОжидания("Подключаемый_ОбработатьРезультатПроверкиКонтрагентов");
			ПроверкаКонтрагентовКлиентСервер.УстановитьВидПанелиПроверкиКонтрагентовВОтчете(Форма, "ПроверкаВПроцессеВыполнения");

			Форма.ПроверитьКонтрагентов();
			
			Если Форма.РеквизитыПроверкиКонтрагентов.ЗаданиеВыполнено Тогда
				Форма.ОтобразитьРезультатПроверкиКонтрагента();
				Форма.РеквизитыПроверкиКонтрагентов.ИдентификаторЗадания = Неопределено;
			Иначе
				// Результата еще нет, но есть шансы дождаться.
				ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(Форма.ПроверкаКонтрагентовПараметрыОбработчикаОжидания);
				Форма.ПодключитьОбработчикОжидания("Подключаемый_ОбработатьРезультатПроверкиКонтрагентов", ИнтервалОбработкиРезультата(), Истина);
			КонецЕсли;
		Иначе
			ПроверкаКонтрагентовКлиентСервер.ВывестиНужнуюПанельПроверкиКонтрагентовВОтчете(Форма);
		КонецЕсли;
	Иначе
		ПроверкаКонтрагентовКлиентСервер.ВывестиНужнуюПанельПроверкиКонтрагентовВОтчете(Форма);
	КонецЕсли;
	
КонецПроцедуры

// Процедура - Обработка результата проверки контрагентов в отчете.
//
// Параметры:
//  Форма						 - УправляемаяФорма - Форма документа, в котором выполняется проверка контрагентов.
Процедура ОбработатьРезультатПроверкиКонтрагентовВОтчете(Форма) Экспорт

	Попытка
		Если ПроверкаКонтрагентовВызовСервера.ЗаданиеВыполнено(Форма.РеквизитыПроверкиКонтрагентов.ИдентификаторЗадания) Тогда
			Форма.ОтобразитьРезультатПроверкиКонтрагента();
			Форма.РеквизитыПроверкиКонтрагентов.ИдентификаторЗадания = Неопределено;
		Иначе
			ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(Форма.ПроверкаКонтрагентовПараметрыОбработчикаОжидания);
			Форма.ПодключитьОбработчикОжидания("Подключаемый_ОбработатьРезультатПроверкиКонтрагентов",
				Форма.ПроверкаКонтрагентовПараметрыОбработчикаОжидания.ТекущийИнтервал, Истина);
		КонецЕсли;
	Исключение
		ВызватьИсключение;
	КонецПопытки;

КонецПроцедуры

#КонецОбласти

#Область ПроверкаКонтрагентовВСправочнике

// Процедура - Подключение обработчиков результата проверки контрагента из карточки контрагента.
//
// Параметры:
//  Форма	 - УправляемаяФорма - Карточка контрагента.
Процедура ПриОткрытииКонтрагент(Форма) Экспорт
	
	Если Форма.РеквизитыПроверкиКонтрагентов.НужноПоказатьПредложениеВключитьПроверкуКонтрагентов Тогда
		Форма.ПодключитьОбработчикОжидания("Подключаемый_ПоказатьПредложениеИспользоватьПроверкуКонтрагентов", ИнтервалОбработкиРезультата(), Истина);
	КонецЕсли;
		
	// Если состояние контрагента не известно, то пытаемся его определить.
	Если Форма.РеквизитыПроверкиКонтрагентов.ПроверкаИспользуется Тогда
		Если Форма.РеквизитыПроверкиКонтрагентов.ФоновоеЗаданиеЗапущено Тогда
			Форма.РеквизитыПроверкиКонтрагентов.ИнтервалПроверкиРезультата = 1;
			Форма.ПодключитьОбработчикОжидания("Подключаемый_ОбработатьРезультатПроверкиКонтрагентов", Форма.РеквизитыПроверкиКонтрагентов.ИнтервалПроверкиРезультата, Истина);
		КонецЕсли;
	КонецЕсли
	
КонецПроцедуры

// Процедура - Запуск проверки из карточки контрагента.
//
// Параметры:
//  Форма	 - УправляемаяФорма - Карточка контрагента.
Процедура ЗапуститьПроверкуКонтрагентаВСправочнике(Форма) Экспорт
	
	// Если ИНН или КПП некорректные, или проверка не включена, то не запускаем проверку.
	Если Форма.РеквизитыПроверкиКонтрагентов.ПроверкаИспользуется Тогда
		
		ПроверкаКонтрагентовКлиентСервер.ПроверитьКонтрагентаИзКарточки(Форма);
		
		// Прерываем предыдущую проверку.
		Форма.РеквизитыПроверкиКонтрагентов.ИнтервалПроверкиРезультата = 1;
		Форма.ПодключитьОбработчикОжидания("Подключаемый_ОбработатьРезультатПроверкиКонтрагентов", Форма.РеквизитыПроверкиКонтрагентов.ИнтервалПроверкиРезультата, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура - Обработка результата фонового задания по проверке контрагента из карточки контрагента.
//
// Параметры:
//  Форма	 - УправляемаяФорма - Карточка контрагента.
Процедура ОбработатьРезультатПроверкиКонтрагентовВСправочнике(Форма) Экспорт

	СвойстваСправочника = ПроверкаКонтрагентовКлиентСервер.СвойстваСправочникаКонтрагенты();
	
	// Определение объекта и ссылки.
	ОбъектИСсылкаПоФорме 	= ПроверкаКонтрагентовКлиентСервер.ОбъектИСсылкаПоФорме(Форма);
	КонтрагентОбъект 		= ОбъектИСсылкаПоФорме.Объект;
	КонтрагентСсылка 		= ОбъектИСсылкаПоФорме.Ссылка;
	
	ИНН = КонтрагентОбъект[СвойстваСправочника.ИНН];
	КПП = КонтрагентОбъект[СвойстваСправочника.КПП];
	
	Форма.РеквизитыПроверкиКонтрагентов.СостояниеКонтрагента = 
		ТекущееСостояниеКонтрагента(КонтрагентСсылка, ИНН, КПП, Форма.РеквизитыПроверкиКонтрагентов.АдресХранилища);
		
	// Проверяем готовность результата фонового задания.
	Если НЕ ЗначениеЗаполнено(Форма.РеквизитыПроверкиКонтрагентов.СостояниеКонтрагента) Тогда
		ПроверкаКонтрагентовКлиентСервер.ОтобразитьРезультатПроверкиКонтрагентаВСправочнике(Форма);
		// Проверяем результат через 1,3 и 9 сек.
		Если Форма.РеквизитыПроверкиКонтрагентов.ИнтервалПроверкиРезультата < 9 Тогда
			Форма.РеквизитыПроверкиКонтрагентов.ИнтервалПроверкиРезультата = Форма.РеквизитыПроверкиКонтрагентов.ИнтервалПроверкиРезультата * 3;
			Форма.ПодключитьОбработчикОжидания("Подключаемый_ОбработатьРезультатПроверкиКонтрагентов", Форма.РеквизитыПроверкиКонтрагентов.ИнтервалПроверкиРезультата, Истина);
			Возврат;
		КонецЕсли;
	Иначе
		// Результат получен
		Форма.РеквизитыПроверкиКонтрагентов.ФоновоеЗаданиеЗапущено = Ложь;
		ПроверкаКонтрагентовКлиентСервер.ОтобразитьРезультатПроверкиКонтрагентаВСправочнике(Форма);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ИнтервалОбработкиРезультата()
	
	Возврат 0.1;
	
КонецФункции

#КонецОбласти