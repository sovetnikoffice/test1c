﻿////////////////////////////////////////////////////////////////////////////////
// Работа с манифестом дополнительных отчетов и обработок
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// ПРОГРАММНЫЙ ИНТЕРФЕЙС

// Формирует манифест дополнительного отчета или обработки
//
// Параметры:
//  ОбъектОбработки - объект, значения свойств которого будет использоваться в
//    качестве значений свойств дополнительного отчета или обработки (предположительно
//    СправочникОбъект.ДополнительныеОтчетыИОбработки или
//    СправочникОбъект.ПоставляемыеДополнительныеОтчетыИОбработки,
//  ОбъектВерсии - объект, значения свойств которого будет использоваться в
//    качестве значений свойств версии дополнительного отчета или обработки (предположительно
//    СправочникОбъект.ДополнительныеОтчетыИОбработки или
//    СправочникОбъект.ПоставляемыеДополнительныеОтчетыИОбработки,
//  ВариантыОтчета - ТаблицаЗначений, колонки:
//    КлючВарианта - строка, ключ варианта дополнительного отчета,
//    Представление - строка, представление варианта дополнительного отчета,
//    Назначение - ТаблицаЗначений, колонки:
//      РазделИлиГруппа - строка, которой можно сопоставить элемент справочника
//        ИдентификаторыОбъектовМетаданных,
//      Важный - булево,
//      СмТакже - булево.
//
// Возвращаемое значение:
//  ОбъектXDTO {http://www.1c.ru/1cFresh/ApplicationExtensions/Manifest/a.b.c.d}ExtensionManifest -
//    манифест дополнительного отчета или обработки.
//
// Примечание:
//  Помимо кода БСП, данная функция может вызываться из внешней обработки
//   ПодготовкаДополнительныхОтчетовИОбработокКПубликацииВМоделиСервиса.epf, входящей
//   в комплект поставки менеджера сервиса. При изменении структуры параметров данной
//   функции необходимо актуализировать их и в данной внешней обработке.
//
Функция СформироватьМанифест(Знач ОбъектОбработки, Знач ОбъектВерсии, Знач ВариантыОтчета = Неопределено, Знач РасписанияКоманд = Неопределено, Знач РазрешенияОбработки = Неопределено) Экспорт
	
	Попытка
		РежимСовместимостиРазрешений = ОбъектОбработки.РежимСовместимостиРазрешений;
	Исключение
		РежимСовместимостиРазрешений = Перечисления.РежимыСовместимостиРазрешенийДополнительныхОтчетовИОбработок.Версия_2_1_3;
	КонецПопытки;
	
	Если РежимСовместимостиРазрешений = Перечисления.РежимыСовместимостиРазрешенийДополнительныхОтчетовИОбработок.Версия_2_1_3 Тогда
		Пакет = ДополнительныеОтчетыИОбработкиВМоделиСервисаМанифестИнтерфейс.Пакет("1.0.0.1");
	Иначе
		Пакет = ДополнительныеОтчетыИОбработкиВМоделиСервисаМанифестИнтерфейс.Пакет();
	КонецЕсли;
	
	Манифест = ФабрикаXDTO.Создать(
		ДополнительныеОтчетыИОбработкиВМоделиСервисаМанифестИнтерфейс.ТипМанифест(Пакет));
	
	Манифест.Name = ОбъектОбработки.Наименование;
	Манифест.ObjectName = ОбъектВерсии.ИмяОбъекта;
	Манифест.Version = ОбъектВерсии.Версия;
	
	Если РежимСовместимостиРазрешений = Перечисления.РежимыСовместимостиРазрешенийДополнительныхОтчетовИОбработок.Версия_2_1_3 Тогда
		Манифест.SafeMode = ОбъектВерсии.БезопасныйРежим;
	КонецЕсли;
	
	Манифест.Description = ОбъектВерсии.Информация;
	Манифест.FileName = ОбъектВерсии.ИмяФайла;
	Манифест.UseReportVariantsStorage = ОбъектВерсии.ИспользуетХранилищеВариантов;
	
	ВидXDTO = Неопределено;
	СловарьПреобразованияВидовОбработок =
		ДополнительныеОтчетыИОбработкиВМоделиСервисаМанифестИнтерфейс.СловарьВидыДополнительныхОтчетовИОбработок();
	Для Каждого ФрагментСловаря Из СловарьПреобразованияВидовОбработок Цикл
		Если ФрагментСловаря.Значение = ОбъектВерсии.Вид Тогда
			ВидXDTO = ФрагментСловаря.Ключ;
		КонецЕсли;
	КонецЦикла;
	Если ЗначениеЗаполнено(ВидXDTO) Тогда
		Манифест.Category = ВидXDTO;
	Иначе
		ВызватьИсключение СтрШаблон(
			НСтр("ru = 'Вид дополнительных отчетов и обработок %1 не поддерживается в модели сервиса!'"),
			ОбъектВерсии.Вид);
	КонецЕсли;
	
	Если ОбъектВерсии.Команды.Количество() > 0 Тогда
		
		Если ОбъектОбработки.Вид = Перечисления.ВидыДополнительныхОтчетовИОбработок.ДополнительнаяОбработка Или
				ОбъектОбработки.Вид = Перечисления.ВидыДополнительныхОтчетовИОбработок.ДополнительныйОтчет Тогда
			
			// Обработка назначения разделам
			
			ВыбранныеРазделы = ОбъектВерсии.Разделы.Выгрузить();
			
			Если ОбъектОбработки.Вид = Перечисления.ВидыДополнительныхОтчетовИОбработок.ДополнительнаяОбработка Тогда
				ВозможныеРазделы = ДополнительныеОтчетыИОбработки.РазделыДополнительныхОбработок();
			Иначе
				ВозможныеРазделы = ДополнительныеОтчетыИОбработки.РазделыДополнительныхОтчетов();
			КонецЕсли;
			
			РабочийСтол = ДополнительныеОтчетыИОбработкиКлиентСервер.ИдентификаторРабочегоСтола();
			
			НазначениеXDTO = ФабрикаXDTO.Создать(
				ДополнительныеОтчетыИОбработкиВМоделиСервисаМанифестИнтерфейс.ТипНазначениеРазделам(Пакет));
			
			Для Каждого Раздел Из ВозможныеРазделы Цикл
				
				Если Раздел = РабочийСтол Тогда
					ИмяРаздела = РабочийСтол;
					ИдентификаторОбъектаМетаданных = Справочники.ИдентификаторыОбъектовМетаданных.ПустаяСсылка();
				Иначе
					ИмяРаздела = Раздел.ПолноеИмя();
					ИдентификаторОбъектаМетаданных = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Раздел);
				КонецЕсли;
				ПредставлениеОбъектаМетаданных = ДополнительныеОтчетыИОбработки.ПредставлениеРаздела(Раздел);
				
				ОбъектНазначенияXDTO = ФабрикаXDTO.Создать(
					ДополнительныеОтчетыИОбработкиВМоделиСервисаМанифестИнтерфейс.ТипОбъектНазначения(Пакет));
				ОбъектНазначенияXDTO.ObjectName = ИмяРаздела;
				ОбъектНазначенияXDTO.ObjectType = "SubSystem";
				ОбъектНазначенияXDTO.Representation = ПредставлениеОбъектаМетаданных;
				ОбъектНазначенияXDTO.Enabled = (
					ВыбранныеРазделы.Найти(
						ИдентификаторОбъектаМетаданных, "Раздел"
					) <> Неопределено);
				
				НазначениеXDTO.Objects.Добавить(ОбъектНазначенияXDTO);
				
			КонецЦикла;
			
		Иначе
			
			// Обработка назначения объектам метаданных
			
			ВыбранныеОбъектыНазначения = ОбъектВерсии.Назначение.Выгрузить();
			
			ВозможныеОбъектыНазначения = Новый Массив();
			ПодключенныеОбъектыМетаданных = ДополнительныеОтчетыИОбработки.ПодключенныеОбъектыМетаданных(ОбъектОбработки.Вид);
			Для Каждого ТипПараметраКоманды Из ПодключенныеОбъектыМетаданных.Метаданные.ТипПараметраКоманды.Типы() Цикл
				ВозможныеОбъектыНазначения.Добавить(Метаданные.НайтиПоТипу(ТипПараметраКоманды));
			КонецЦикла;
			
			НазначениеXDTO = ФабрикаXDTO.Создать(
				ДополнительныеОтчетыИОбработкиВМоделиСервисаМанифестИнтерфейс.ТипНазначениеСправочникамИДокументам(Пакет));
			
			Для Каждого ОбъектНазначения Из ВозможныеОбъектыНазначения Цикл
				
				ИдентификаторОбъектаМетаданных = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(ОбъектНазначения);
				
				ОбъектНазначенияXDTO = ФабрикаXDTO.Создать(
					ДополнительныеОтчетыИОбработкиВМоделиСервисаМанифестИнтерфейс.ТипОбъектНазначения(Пакет));
				ОбъектНазначенияXDTO.ObjectName = ОбъектНазначения.ПолноеИмя();
				Если ОбщегоНазначения.ЭтоСправочник(ОбъектНазначения) Тогда
					ОбъектНазначенияXDTO.ObjectType = "Catalog";
				ИначеЕсли ОбщегоНазначения.ЭтоДокумент(ОбъектНазначения) Тогда
					ОбъектНазначенияXDTO.ObjectType = "Document";
				ИначеЕсли ОбщегоНазначения.ЭтоБизнесПроцесс(ОбъектНазначения) Тогда
					ОбъектНазначенияXDTO.ObjectType = "BusinessProcess";
				ИначеЕсли ОбщегоНазначения.ЭтоЗадача(ОбъектНазначения) Тогда
					ОбъектНазначенияXDTO.ObjectType = "Task";
				КонецЕсли;
				ОбъектНазначенияXDTO.Representation = ОбъектНазначения.Представление();
				ОбъектНазначенияXDTO.Enabled = (
					ВыбранныеОбъектыНазначения.Найти(
						ИдентификаторОбъектаМетаданных, "ОбъектНазначения"
					) <> Неопределено);
				
				НазначениеXDTO.Objects.Добавить(ОбъектНазначенияXDTO);
				
			КонецЦикла;
			
			НазначениеXDTO.UseInListsForms = ОбъектВерсии.ИспользоватьДляФормыСписка;
			НазначениеXDTO.UseInObjectsForms = ОбъектВерсии.ИспользоватьДляФормыОбъекта;
			
		КонецЕсли;
		
		Манифест.Assignment = НазначениеXDTO;
		
		Для Каждого ОписаниеКоманды Из ОбъектВерсии.Команды Цикл
			
			КомандаXDTO = ФабрикаXDTO.Создать(
				ДополнительныеОтчетыИОбработкиВМоделиСервисаМанифестИнтерфейс.ТипКоманда(Пакет));
			КомандаXDTO.Id = ОписаниеКоманды.Идентификатор;
			КомандаXDTO.Representation = ОписаниеКоманды.Представление;
			
			ТипЗапускаXDTO = Неопределено;
			СловарьПреобразованияСпособовВызова =
				ДополнительныеОтчетыИОбработкиВМоделиСервисаМанифестИнтерфейс.СловарьСпособыВызоваДополнительныхОтчетовИОбработок();
			Для Каждого ФрагментСловаря Из СловарьПреобразованияСпособовВызова Цикл
				Если ФрагментСловаря.Значение = ОписаниеКоманды.ВариантЗапуска Тогда
					ТипЗапускаXDTO = ФрагментСловаря.Ключ;
				КонецЕсли;
			КонецЦикла;
			Если ЗначениеЗаполнено(ТипЗапускаXDTO) Тогда
				КомандаXDTO.StartupType = ТипЗапускаXDTO;
			Иначе
				ВызватьИсключение СтрШаблон(НСтр("ru = 'Способ запуска дополнительных отчетов и обработок %1 не поддерживается в модели сервиса!'"),
					ОписаниеКоманды.ВариантЗапуска);
			КонецЕсли;
			
			КомандаXDTO.ShowNotification = ОписаниеКоманды.ПоказыватьОповещение;
			КомандаXDTO.Modifier = ОписаниеКоманды.Модификатор;
			
			Если ЗначениеЗаполнено(РасписанияКоманд) Тогда
				
				РасписаниеКоманды = Неопределено;
				Если РасписанияКоманд.Свойство(ОписаниеКоманды.Идентификатор, РасписаниеКоманды) Тогда
					
					КомандаXDTO.DefaultSettings = ФабрикаXDTO.Создать(
						ДополнительныеОтчетыИОбработкиВМоделиСервисаМанифестИнтерфейс.ТипНастройкиКоманды(Пакет));
					
					КомандаXDTO.DefaultSettings.Schedule = СериализаторXDTO.ЗаписатьXDTO(РасписаниеКоманды);
					
				КонецЕсли;
				
			КонецЕсли;
			
			Манифест.Commands.Добавить(КомандаXDTO);
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ВариантыОтчета) Тогда
		
		Для Каждого ВариантОтчета Из ВариантыОтчета Цикл
			
			ВариантXDTO = ФабрикаXDTO.Создать(
				ДополнительныеОтчетыИОбработкиВМоделиСервисаМанифестИнтерфейс.ТипВариантОтчета(Пакет));
			ВариантXDTO.VariantKey = ВариантОтчета.КлючВарианта;
			ВариантXDTO.Representation = ВариантОтчета.Представление;
			
			Если ВариантОтчета.Назначение <> Неопределено Тогда
				
				Для Каждого НазначениеВариантаОтчета Из ВариантОтчета.Назначение Цикл
					
					НазначениеXDTO = ФабрикаXDTO.Создать(
						ДополнительныеОтчетыИОбработкиВМоделиСервисаМанифестИнтерфейс.ТипНазначениеВариантаОтчета(Пакет));
					
					НазначениеXDTO.ObjectName = НазначениеВариантаОтчета.ПолноеИмя;
					НазначениеXDTO.Representation = НазначениеВариантаОтчета.Представление;
					НазначениеXDTO.Parent = НазначениеВариантаОтчета.ПолноеИмяРодителя;
					НазначениеXDTO.Enabled = НазначениеВариантаОтчета.Использование;
					
					Если НазначениеВариантаОтчета.Важный Тогда
						НазначениеXDTO.Importance = "High";
					ИначеЕсли НазначениеВариантаОтчета.СмТакже Тогда
						НазначениеXDTO.Importance = "Low";
					Иначе
						НазначениеXDTO.Importance = "Ordinary";
					КонецЕсли;
					
					ВариантXDTO.Assignments.Добавить(НазначениеXDTO);
					
				КонецЦикла;
				
			КонецЕсли;
			
			Манифест.ReportVariants.Добавить(ВариантXDTO);
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если РазрешенияОбработки = Неопределено Тогда
		
		РазрешенияОбработки = ОбъектОбработки.Разрешения;
		
	КонецЕсли;
	
	Для Каждого Разрешение Из РазрешенияОбработки Цикл
		
		Если ТипЗнч(Разрешение) = Тип("ОбъектXDTO") Тогда
			
			Манифест.Permissions.Добавить(Разрешение);
			
		Иначе
			
			Если РежимСовместимостиРазрешений = Перечисления.РежимыСовместимостиРазрешенийДополнительныхОтчетовИОбработок.Версия_2_1_3 Тогда
				
				РазрешениеXDTO = ФабрикаXDTO.Создать(
					ФабрикаXDTO.Тип(
						ДополнительныеОтчетыИОбработкиВБезопасномРежимеИнтерфейс.Пакет(Пакет),
						Разрешение.ВидРазрешения));
				
			Иначе
				
				РазрешениеXDTO = ФабрикаXDTO.Создать(
					ФабрикаXDTO.Тип(
						"http://www.1c.ru/1cFresh/Application/Permissions/1.0.0.1",
						Разрешение.ВидРазрешения));
				
			КонецЕсли;
			
			Параметры = Разрешение.Параметры.Получить();
			Если Параметры <> Неопределено Тогда
				
				Для Каждого Параметр Из Параметры Цикл
					
					РазрешениеXDTO[Параметр.Ключ] = Параметр.Значение;
					
				КонецЦикла;
				
			КонецЕсли;
			
			Манифест.Permissions.Добавить(РазрешениеXDTO);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Манифест;
	
КонецФункции

// Заполняет переданные объекты данными, считываемыми из манифеста дополнительного
//  отчета или обработки.
//
// Параметры:
//  Манифест - ОбъектXDTO {http://www.1c.ru/1cFresh/ApplicationExtensions/Manifest/a.b.c.d}ExtensionManifest - манифест
//    дополнительного отчета или обработки,
//  ОбъектОбработки - объект, значения свойств которого будет установлены
//    значениями свойств дополнительного отчета или обработки из манифеста (предположительно
//    СправочникОбъект.ДополнительныеОтчетыИОбработки или
//    СправочникОбъект.ПоставляемыеДополнительныеОтчетыИОбработки,
//  ОбъектВерсии - объект, значения свойств которого будет установлены
//    значениями свойств версии дополнительного отчета или обработки из манифеста (предположительно
//    СправочникОбъект.ДополнительныеОтчетыИОбработки или
//    СправочникОбъект.ПоставляемыеДополнительныеОтчетыИОбработки,
//  ВариантыОтчета - ТаблицаЗначений, колонки:
//    КлючВарианта - строка, ключ варианта дополнительного отчета,
//    Представление - строка, представление варианта дополнительного отчета,
//    Назначение - ТаблицаЗначений, колонки:
//      РазделИлиГруппа - строка, которой можно сопоставить элемент справочника
//        ИдентификаторыОбъектовМетаданных,
//      Важный - булево,
//      СмТакже - булево.
//
Процедура ПрочитатьМанифест(Знач Манифест, ОбъектОбработки, ОбъектВерсии, ВариантыОтчета) Экспорт
	
	Если Манифест.Тип().URIПространстваИмен = ДополнительныеОтчетыИОбработкиВМоделиСервисаМанифестИнтерфейс.Пакет("1.0.0.1") Тогда
		ОбъектОбработки.РежимСовместимостиРазрешений = Перечисления.РежимыСовместимостиРазрешенийДополнительныхОтчетовИОбработок.Версия_2_1_3;
	ИначеЕсли Манифест.Тип().URIПространстваИмен = ДополнительныеОтчетыИОбработкиВМоделиСервисаМанифестИнтерфейс.Пакет("1.0.0.2") Тогда
		ОбъектОбработки.РежимСовместимостиРазрешений = Перечисления.РежимыСовместимостиРазрешенийДополнительныхОтчетовИОбработок.Версия_2_2_2;
	КонецЕсли;
	
	ОбъектОбработки.Наименование = Манифест.Name;
	ОбъектВерсии.ИмяОбъекта = Манифест.ObjectName;
	ОбъектВерсии.Версия = Манифест.Version;
	Если ОбъектОбработки.РежимСовместимостиРазрешений = Перечисления.РежимыСовместимостиРазрешенийДополнительныхОтчетовИОбработок.Версия_2_1_3 Тогда
		ОбъектВерсии.БезопасныйРежим = Манифест.SafeMode;
	КонецЕсли;
	ОбъектВерсии.Информация = Манифест.Description;
	ОбъектВерсии.ИмяФайла = Манифест.FileName;
	ОбъектВерсии.ИспользуетХранилищеВариантов = Манифест.UseReportVariantsStorage;
	
	СловарьПреобразованияВидовОбработок = ДополнительныеОтчетыИОбработкиВМоделиСервисаМанифестИнтерфейс.СловарьВидыДополнительныхОтчетовИОбработок();
	ОбъектВерсии.Вид = СловарьПреобразованияВидовОбработок[Манифест.Category];
	
	ОбъектВерсии.Команды.Очистить();
	Для Каждого Command Из Манифест.Commands Цикл
		
		СтрокаКоманды = ОбъектВерсии.Команды.Добавить();
		СтрокаКоманды.Идентификатор = Command.Id;
		СтрокаКоманды.Представление = Command.Representation;
		СтрокаКоманды.ПоказыватьОповещение = Command.ShowNotification;
		СтрокаКоманды.Модификатор = Command.Modifier;
		
		СловарьПреобразованияСпособовВызова =
			ДополнительныеОтчетыИОбработкиВМоделиСервисаМанифестИнтерфейс.СловарьСпособыВызоваДополнительныхОтчетовИОбработок();
		СтрокаКоманды.ВариантЗапуска = СловарьПреобразованияСпособовВызова[Command.StartupType];
		
	КонецЦикла;
	
	ОбъектВерсии.Разрешения.Очистить();
	Для Каждого Permission Из Манифест.Permissions Цикл
		
		ТипXDTO = Permission.Тип();
		
		Разрешение = ОбъектВерсии.Разрешения.Добавить();
		Разрешение.ВидРазрешения = ТипXDTO.Имя;
		
		Параметры = Новый Структура();
		
		Для Каждого СвойствоXDTO Из ТипXDTO.Свойства Цикл
			
			Контейнер = Permission.ПолучитьXDTO(СвойствоXDTO.Имя);
			
			Если Контейнер <> Неопределено Тогда
				Параметры.Вставить(СвойствоXDTO.Имя, Контейнер.Значение);
			Иначе
				Параметры.Вставить(СвойствоXDTO.Имя);
			КонецЕсли;
			
		КонецЦикла;
		
		Разрешение.Параметры = Новый ХранилищеЗначения(Параметры);
		
	КонецЦикла;
	
КонецПроцедуры
