﻿#Область ОписаниеПеременных

&НаКлиенте
Перем КонтекстЯдра;
&НаКлиенте
Перем Утверждения;
&НаКлиенте
Перем СтроковыеУтилиты;
&НаКлиенте
Перем ИсключенияИзПроверок;
&НаКлиенте
Перем ВыводитьИсключения;
&НаКлиенте
Перем ПрефиксОбъектов;

#КонецОбласти

#Область ИнтерфейсТестирования

&НаКлиенте
Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
	
	КонтекстЯдра = КонтекстЯдраПараметр;
	Утверждения = КонтекстЯдра.Плагин("БазовыеУтверждения");
	СтроковыеУтилиты = КонтекстЯдра.Плагин("СтроковыеУтилиты");
	
	Настройки(КонтекстЯдра, ИмяТеста());
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьНаборТестов(НаборТестов, КонтекстЯдраПараметр) Экспорт
	
	Инициализация(КонтекстЯдраПараметр);
	
	Если Не ВыполнятьТест(КонтекстЯдра) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ПрефиксОбъектов) Тогда
		Возврат;
	КонецЕсли;
		
	ОбъектыМетаданных = ОбъектыМетаданных(ПрефиксОбъектов);
	Пояснение = НСтр("ru = 'Проверка каноничности префикса объекта/свойства'");
	
	Для Каждого ОбъектМетаданных Из ОбъектыМетаданных Цикл
		
		Если Не ВыводитьИсключения Тогда
			МассивТестов = УбратьИсключения(ОбъектМетаданных.Значение);
		Иначе
			МассивТестов = ОбъектМетаданных.Значение;
		КонецЕсли;
		Если МассивТестов.Количество() Тогда
			НаборТестов.НачатьГруппу(ОбъектМетаданных.Ключ, Истина);
		КонецЕсли;
		
		Для Каждого Тест Из МассивТестов Цикл
			ИмяТеста = СтроковыеУтилиты.ПодставитьПараметрыВСтроку("%1 [%2]", Тест.ПолноеИмя, Пояснение);
			НаборТестов.Добавить(Тест.ИмяПроцедуры, НаборТестов.ПараметрыТеста(Тест.Имя, Тест.ПолноеИмя), ИмяТеста);	
		КонецЦикла;
			
	КонецЦикла;
			
КонецПроцедуры

#КонецОбласти

#Область РаботаСНастройками

&НаКлиенте
Процедура Настройки(КонтекстЯдра, Знач ПутьНастройки)

	Если ЗначениеЗаполнено(Объект.Настройки) Тогда
		Возврат;
	КонецЕсли;
	
	ИсключенияИзПроверок = Новый Соответствие;
	ПлагинНастроек = КонтекстЯдра.Плагин("Настройки");
	Объект.Настройки = ПлагинНастроек.ПолучитьНастройкиТеста(ПутьНастройки);
	Настройки = Объект.Настройки;
	
	Если Не ЗначениеЗаполнено(Настройки) Тогда
		Объект.Настройки = Новый Структура(ПутьНастройки, Неопределено);
		Возврат;
	КонецЕсли;
		
	Если Настройки.Свойство("Префикс") Тогда
		ПрефиксОбъектов = Настройки.Префикс;		
	КонецЕсли;
			
	Если Настройки.Свойство("ВыводитьИсключения") Тогда
		ВыводитьИсключения = Настройки.ВыводитьИсключения;
	КонецЕсли;
	
	Если Настройки.Свойство("ИсключенияИзПроверок") Тогда
		ИсключенияИзПроверок(Настройки);
	КонецЕсли;
			
КонецПроцедуры

&НаКлиенте
Процедура ИсключенияИзПроверок(Настройки)

	Для Каждого ИсключенияИзПроверокПоОбъектам Из Настройки.ИсключенияИзПроверок Цикл
		Для Каждого ИсключениеИзПроверок Из ИсключенияИзПроверокПоОбъектам.Значение Цикл
			ТекстИсключения = ВРег(ИсключенияИзПроверокПоОбъектам.Ключ + "." + ИсключениеИзПроверок);
			ИсключенияИзПроверок.Вставить(ТекстИсключения, Истина); 	
		КонецЦикла;
	КонецЦикла;	

КонецПроцедуры

#КонецОбласти

#Область Тесты

&НаКлиенте
Процедура ТестДолжен_ПроверитьКаноничностьПрефиксаОбъектаИлиРеквизитов(ИмяМетаданных, ПолноеИмяМетаданных) Экспорт
	
	ПропускатьТест = ПропускатьТест(ПолноеИмяМетаданных);	
	ДлинаПрефикса = СтрДлина(ПрефиксОбъектов);
	
	Результат = (Лев(ИмяМетаданных, ДлинаПрефикса) = ПрефиксОбъектов);
	Если Не Результат И ПропускатьТест.Пропустить Тогда
		Утверждения.ПропуститьТест(ТекстСообщения(ПолноеИмяМетаданных));
	Иначе
		Утверждения.Проверить(Результат, ТекстСообщения(ПолноеИмяМетаданных));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ПропускатьТест(ПолноеИмяМетаданных)

	Результат = Новый Структура;
	Результат.Вставить("ТекстСообщения", "");
	Результат.Вставить("Пропустить", Ложь);
	
	Если ИсключенИзПроверок(ВРег(ПолноеИмяМетаданных)) Тогда
		ШаблонСообщения = НСтр("ru = 'Объект ""%1"" исключен из проверки'");
		Результат.ТекстСообщения = СтроковыеУтилиты.ПодставитьПараметрыВСтроку(ШаблонСообщения, ПолноеИмяМетаданных);
		Результат.Пропустить = Истина;
		Возврат Результат;
	КонецЕсли;
	
	Возврат Результат;

КонецФункции 

&НаКлиенте
Функция ИсключенИзПроверок(ПолноеИмяМетаданных)
	
	Результат = Ложь;
	МассивСтрокИмени = СтроковыеУтилиты.РазложитьСтрокуВМассивПодстрок(ПолноеИмяМетаданных, ".");
	ИслючениеВсехОбъектов = СтроковыеУтилиты.ПодставитьПараметрыВСтроку("%1.*", МассивСтрокИмени[0]);
	
	Если ИсключенияИзПроверок.Получить(ВРег(ПолноеИмяМетаданных)) <> Неопределено
	 Или ИсключенияИзПроверок.Получить(ВРег(ИслючениеВсехОбъектов)) <> Неопределено Тогда
		Результат = Истина;	
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Функция УбратьИсключения(МассивТестов)

	Результат = Новый Массив;
	
	Для Каждого Тест Из МассивТестов Цикл
		Если Не ИсключенИзПроверок(Тест.ПолноеИмя) Тогда
			Результат.Добавить(Тест);
		КонецЕсли;	
	КонецЦикла;
	
	Возврат Результат;

КонецФункции

&НаКлиенте
Функция ТекстСообщения(ПолноеИмяМетаданных)

	ШаблонСообщения = НСтр("ru = 'Префикс объекта ""%1"" отличается от канонического написания.'");
	ТекстСообщения = СтроковыеУтилиты.ПодставитьПараметрыВСтроку(ШаблонСообщения, ПолноеИмяМетаданных);
	
	Возврат ТекстСообщения;

КонецФункции

&НаСервереБезКонтекста
Функция ОбъектыМетаданных(ПрефиксОбъектов)
	
	МассивИменОбъектовМетаданных = МассивИменОбъектовМетаданных();
		
	СтруктураОбъектовМетаданных = Новый Структура;
	Для Каждого ЭлементМассива Из МассивИменОбъектовМетаданных Цикл
		СтруктураОбъектовМетаданных.Вставить(ЭлементМассива, Новый Массив);
	КонецЦикла;
	
	Для Каждого ЭлементСтруктурыОбъектовМетаданных Из СтруктураОбъектовМетаданных Цикл
		
		Для Каждого ОбъектМетаданных Из Метаданные[ЭлементСтруктурыОбъектовМетаданных.Ключ] Цикл
			
			Если ИмяСодержитПрефикс(ОбъектМетаданных.Имя, ПрефиксОбъектов) Тогда 
				
				ДобавитьЭлементКоллекцииОбъектовМетаданных(
					СтруктураОбъектовМетаданных[ЭлементСтруктурыОбъектовМетаданных.Ключ], 
					ОбъектМетаданных.ПолноеИмя(),
					ОбъектМетаданных.Имя);
					
			КонецЕсли;
							
			Параметры = Новый Структура;
			Параметры.Вставить("ОбъектМетаданных", ОбъектМетаданных);
			Параметры.Вставить("СтруктураОбъектовМетаданных", СтруктураОбъектовМетаданных);
			Параметры.Вставить("ИмяМетаданных", ЭлементСтруктурыОбъектовМетаданных.Ключ);
			Параметры.Вставить("ПрефиксОбъектов", ПрефиксОбъектов);
			
			ОбработатьЭлементыОбъекта(Параметры, "Подсистемы", "Подсистема");
			ОбработатьЭлементыОбъекта(Параметры, "ЗначенияПеречисления", "ЗначениеПеречисления");
			ОбработатьЭлементыОбъекта(Параметры, "Измерения", "Измерение");
			ОбработатьЭлементыОбъекта(Параметры, "Ресурсы", "Ресурс");
			ОбработатьЭлементыОбъекта(Параметры, "Реквизиты", "Реквизит");
			ОбработатьЭлементыОбъекта(Параметры, "РеквизитыАдресации", "РеквизитАдресации");
			ОбработатьЭлементыОбъекта(Параметры, "Перерасчеты", "Перерасчет");
			ОбработатьЭлементыОбъекта(Параметры, "ПризнакиУчета", "ПризнакУчета");
			ОбработатьЭлементыОбъекта(Параметры, "ПризнакиУчетаСубконто", "ПризнакУчетаСубконто");
			ОбработатьТабличныеЧастиОбъекта(Параметры, "ТабличныеЧасти", "ТабличнаяЧасть");
			ОбработатьЭлементыОбъекта(Параметры, "Графы", "Граф");
			ОбработатьЭлементыОбъекта(Параметры, "Формы", "Форма");
			ОбработатьЭлементыОбъекта(Параметры, "Команды", "Команда");
			ОбработатьЭлементыОбъекта(Параметры, "Макеты", "Макет");
													
		КонецЦикла;
			
	КонецЦикла;
	
	Возврат СтруктураОбъектовМетаданных;

КонецФункции 

&НаСервереБезКонтекста
Процедура ОбработатьТабличныеЧастиОбъекта(Параметры, ИмяКоллекции, ИмяЭлемента)

	ОбъектМетаданных = Параметры.ОбъектМетаданных;
	СтруктураОбъектовМетаданных = Параметры.СтруктураОбъектовМетаданных;
	ИмяМетаданных = Параметры.ИмяМетаданных;
	ПрефиксОбъектов = Параметры.ПрефиксОбъектов;
	
	Если Не ЕстьРеквизитИлиСвойствоОбъекта(ОбъектМетаданных, ИмяКоллекции) Тогда
		Возврат;
	КонецЕсли;
	
	ШаблонПоиска = "%1.%2.%3";
	ШаблонРеквизит = "%1.%2.%3.Реквизит.%4";
	
	Для Каждого ЭлементКоллекции Из ОбъектМетаданных[ИмяКоллекции] Цикл
		
		ИмяОбъекта = СтроковыеУтилиты().ПодставитьПараметрыВСтроку(
						ШаблонПоиска, 
						ОбъектМетаданных.Имя, 
						ИмяЭлемента, 
						ЭлементКоллекции.Имя);
		
		Если ИмяСодержитПрефикс(ЭлементКоллекции.Имя, ПрефиксОбъектов) Тогда
			ДобавитьЭлементКоллекцииОбъектовМетаданных(
				СтруктураОбъектовМетаданных[ИмяМетаданных], 
				ЭлементКоллекции.ПолноеИмя(),
				ЭлементКоллекции.Имя);
		КонецЕсли;
		
		Для Каждого Реквизит Из ЭлементКоллекции.Реквизиты Цикл
			
			ИмяОбъекта = СтроковыеУтилиты().ПодставитьПараметрыВСтроку(
							ШаблонРеквизит, 
							ОбъектМетаданных.Имя, 
							ИмяЭлемента, 
							ЭлементКоллекции.Имя, 
							Реквизит.Имя);
			
			Если ИмяСодержитПрефикс(Реквизит.Имя, ПрефиксОбъектов) Тогда
				ДобавитьЭлементКоллекцииОбъектовМетаданных(
					СтруктураОбъектовМетаданных[ИмяМетаданных], 
					Реквизит.ПолноеИмя(),
					Реквизит.Имя);
			КонецЕсли;
		КонецЦикла;	
		
		
	КонецЦикла;

КонецПроцедуры 

&НаСервереБезКонтекста
Процедура ОбработатьЭлементыОбъекта(Параметры, ИмяКоллекции, ИмяЭлемента, ИмяРодителя = "")

	ОбъектМетаданных = Параметры.ОбъектМетаданных;
	СтруктураОбъектовМетаданных = Параметры.СтруктураОбъектовМетаданных;
	ИмяМетаданных = Параметры.ИмяМетаданных;
	ПрефиксОбъектов = Параметры.ПрефиксОбъектов;
	
	Если Не ЕстьРеквизитИлиСвойствоОбъекта(ОбъектМетаданных, ИмяКоллекции) Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ЭлементКоллекции Из ОбъектМетаданных[ИмяКоллекции] Цикл
		
		мИмяОбъекта = ?(ЗначениеЗаполнено(ИмяРодителя), ИмяРодителя, ОбъектМетаданных.Имя);
		ИмяОбъекта = СтроковыеУтилиты().ПодставитьПараметрыВСтроку(
						"%1.%2.%3", 
						мИмяОбъекта, 
						ИмяЭлемента, 
						ЭлементКоллекции.Имя);
		
		Если ИмяСодержитПрефикс(ЭлементКоллекции.Имя, ПрефиксОбъектов) Тогда
			ДобавитьЭлементКоллекцииОбъектовМетаданных(
				СтруктураОбъектовМетаданных[ИмяМетаданных], 
				ЭлементКоллекции.ПолноеИмя(),
				ЭлементКоллекции.Имя);
		КонецЕсли;
		
		Если Не ЕстьРеквизитИлиСвойствоОбъекта(ЭлементКоллекции, ИмяКоллекции) Тогда
			мПараметры = Новый Структура;
			мПараметры.Вставить("ОбъектМетаданных", ЭлементКоллекции);
			мПараметры.Вставить("СтруктураОбъектовМетаданных", СтруктураОбъектовМетаданных);
			мПараметры.Вставить("ИмяМетаданных", ИмяМетаданных);
			мПараметры.Вставить("ПрефиксОбъектов", ПрефиксОбъектов);
			ОбработатьЭлементыОбъекта(мПараметры, ИмяКоллекции, ИмяЭлемента, ИмяОбъекта);
		КонецЕсли;
		
	КонецЦикла;

КонецПроцедуры 

&НаСервереБезКонтекста
Процедура ДобавитьЭлементКоллекцииОбъектовМетаданных(Коллекция, ПолноеИмя, Имя)

	СтруктураТеста = Новый Структура;
	СтруктураТеста.Вставить("Имя", Имя);
	СтруктураТеста.Вставить("ПолноеИмя", ПолноеИмя);
	СтруктураТеста.Вставить("ИмяПроцедуры", "ТестДолжен_ПроверитьКаноничностьПрефиксаОбъектаИлиРеквизитов");
	Коллекция.Добавить(СтруктураТеста);

КонецПроцедуры 

&НаКлиентеНаСервереБезКонтекста
Функция МассивИменОбъектовМетаданных()

	МассивИменОбъектовМетаданных = Новый Массив;
	                                 
	МассивИменОбъектовМетаданных.Добавить("Подсистемы");    
	МассивИменОбъектовМетаданных.Добавить("ОбщиеМодули");
	МассивИменОбъектовМетаданных.Добавить("ПараметрыСеанса");
	МассивИменОбъектовМетаданных.Добавить("Роли");
	МассивИменОбъектовМетаданных.Добавить("ОбщиеРеквизиты");
	МассивИменОбъектовМетаданных.Добавить("ПланыОбмена");
	МассивИменОбъектовМетаданных.Добавить("КритерииОтбора");
	МассивИменОбъектовМетаданных.Добавить("ПодпискиНаСобытия");
	МассивИменОбъектовМетаданных.Добавить("РегламентныеЗадания");
	МассивИменОбъектовМетаданных.Добавить("ФункциональныеОпции");	
	МассивИменОбъектовМетаданных.Добавить("ПараметрыФункциональныхОпций");
	МассивИменОбъектовМетаданных.Добавить("ОпределяемыеТипы");
	МассивИменОбъектовМетаданных.Добавить("ХранилищаНастроек");
	МассивИменОбъектовМетаданных.Добавить("ОбщиеФормы");
	МассивИменОбъектовМетаданных.Добавить("ОбщиеКоманды");
	МассивИменОбъектовМетаданных.Добавить("ГруппыКоманд");
	МассивИменОбъектовМетаданных.Добавить("Интерфейсы");
	МассивИменОбъектовМетаданных.Добавить("ОбщиеМакеты");
	МассивИменОбъектовМетаданных.Добавить("ОбщиеКартинки");
	МассивИменОбъектовМетаданных.Добавить("ПакетыXDTO");
	МассивИменОбъектовМетаданных.Добавить("WebСервисы");
	МассивИменОбъектовМетаданных.Добавить("HTTPСервисы");  
	МассивИменОбъектовМетаданных.Добавить("WSСсылки");
	МассивИменОбъектовМетаданных.Добавить("ЭлементыСтиля");
	МассивИменОбъектовМетаданных.Добавить("Стили");
	МассивИменОбъектовМетаданных.Добавить("Языки");    
	МассивИменОбъектовМетаданных.Добавить("Константы");
	МассивИменОбъектовМетаданных.Добавить("Справочники");
	МассивИменОбъектовМетаданных.Добавить("Документы");
	МассивИменОбъектовМетаданных.Добавить("ЖурналыДокументов");
	МассивИменОбъектовМетаданных.Добавить("Перечисления");
	МассивИменОбъектовМетаданных.Добавить("Отчеты");
	МассивИменОбъектовМетаданных.Добавить("Обработки");
	МассивИменОбъектовМетаданных.Добавить("ПланыВидовХарактеристик");
	МассивИменОбъектовМетаданных.Добавить("ПланыСчетов");
	МассивИменОбъектовМетаданных.Добавить("ПланыВидовРасчета");
	МассивИменОбъектовМетаданных.Добавить("РегистрыСведений");
	МассивИменОбъектовМетаданных.Добавить("РегистрыНакопления");
	МассивИменОбъектовМетаданных.Добавить("РегистрыБухгалтерии");
	МассивИменОбъектовМетаданных.Добавить("РегистрыРасчета");
	МассивИменОбъектовМетаданных.Добавить("БизнесПроцессы");
	МассивИменОбъектовМетаданных.Добавить("Задачи");
	МассивИменОбъектовМетаданных.Добавить("ВнешниеИсточникиДанных");
	
	Возврат МассивИменОбъектовМетаданных;

КонецФункции 

&НаКлиентеНаСервереБезКонтекста
Функция ЕстьРеквизитИлиСвойствоОбъекта(Объект, ИмяРеквизита) Экспорт
	
	КлючУникальности   = Новый УникальныйИдентификатор;
	СтруктураРеквизита = Новый Структура(ИмяРеквизита, КлючУникальности);
	ЗаполнитьЗначенияСвойств(СтруктураРеквизита, Объект);
	
	Возврат СтруктураРеквизита[ИмяРеквизита] <> КлючУникальности;
	
КонецФункции

&НаСервереБезКонтекста
Функция СтроковыеУтилиты()
	Возврат ВнешниеОбработки.Создать("СтроковыеУтилиты");	
КонецФункции 

&НаКлиентеНаСервереБезКонтекста
Функция ИмяСодержитПрефикс(Имя, Префикс)
	
	Если Не ЗначениеЗаполнено(Префикс) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ДлинаПрефикса = СтрДлина(Префикс);
	Возврат СтрНайти(ВРег(Лев(Имя, ДлинаПрефикса)), ВРег(Префикс)) > 0;
	
КонецФункции

&НаКлиенте
Функция ИмяТеста()
	
	Если Не ЗначениеЗаполнено(Объект.ИмяТеста) Тогда
		Объект.ИмяТеста = ИмяТестаНаСервере();
	КонецЕсли;
	
	Возврат Объект.ИмяТеста;
	
КонецФункции

&НаСервере
Функция ИмяТестаНаСервере()
	Возврат РеквизитФормыВЗначение("Объект").Метаданные().Имя;
КонецФункции

&НаКлиенте
Функция ВыполнятьТест(КонтекстЯдра)
	
	ВыполнятьТест = Ложь;
	Настройки(КонтекстЯдра, ИмяТеста());
	Настройки = Объект.Настройки;
	
	Если Не ЗначениеЗаполнено(Настройки) Тогда
		Возврат ВыполнятьТест;
	КонецЕсли;
		
	Если ТипЗнч(Настройки) = Тип("Структура") И Настройки.Свойство("Используется") Тогда
		ВыполнятьТест = Настройки.Используется;	
	КонецЕсли;
	
	Возврат ВыполнятьТест;

КонецФункции

#КонецОбласти