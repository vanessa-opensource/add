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
Перем ПропускатьОбъектыСПрефиксомУдалить;
&НаКлиенте
Перем ОтборПоПрефиксу;
&НаКлиенте
Перем ПрефиксОбъектов;
&НаКлиенте
Перем РольБазовыеПрава;
&НаКлиенте
Перем ВыводитьИсключения;

#КонецОбласти

#Область ИнтерфейсТестирования

&НаКлиенте
Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
	
	КонтекстЯдра = КонтекстЯдраПараметр;
	Утверждения = КонтекстЯдра.Плагин("БазовыеУтверждения");
	СтроковыеУтилиты = КонтекстЯдра.Плагин("СтроковыеУтилиты");
	
	Настройки(ИмяТеста());
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьНаборТестов(НаборТестов, КонтекстЯдраПараметр) Экспорт
	
	Инициализация(КонтекстЯдраПараметр);
	
	Если Не ВыполнятьТест() Тогда
		Возврат;
	КонецЕсли;
	
	ОбъектыМетаданных = ОбъектыМетаданных(ПрефиксОбъектов, ОтборПоПрефиксу);
	
	Для Каждого ОбъектМетаданных Из ОбъектыМетаданных Цикл
		Если Не ВыводитьИсключения Тогда
			МассивТестов = УбратьИсключения(ОбъектМетаданных.Значение);
		Иначе
			МассивТестов = ОбъектМетаданных.Значение;
		КонецЕсли;		
		Если МассивТестов.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		НаборТестов.НачатьГруппу(ОбъектМетаданных.Ключ, Ложь);
		Для Каждого Элемент Из МассивТестов Цикл
			НаборТестов.Добавить(
				"ТестДолжен_ПроверитьЧтоЕстьПраваНаЧтение", 
				НаборТестов.ПараметрыТеста(Элемент.ПолноеИмя), 
				КонтекстЯдра.СтрШаблон_("%1 [%2]", Элемент.Имя, НСтр("ru = 'Проверка прав на чтение объекта'")));	
		КонецЦикла;
	КонецЦикла;
			
КонецПроцедуры

#КонецОбласти

#Область РаботаСНастройками

&НаКлиенте
Процедура Настройки(Знач ПутьНастройки)

	Если ЗначениеЗаполнено(Объект.Настройки) Тогда
		Возврат;
	КонецЕсли;
	
	ОтборПоПрефиксу = Ложь;
	ВыводитьИсключения = Ложь;
	ПропускатьОбъектыСПрефиксомУдалить = Ложь;
	ПрефиксОбъектов = "";
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
	
	Если Настройки.Свойство("ОтборПоПрефиксу") Тогда
		ОтборПоПрефиксу = Настройки.ОтборПоПрефиксу;		
	КонецЕсли;
	
	Если Настройки.Свойство("ПропускатьОбъектыСПрефиксомУдалить") Тогда
		ПропускатьОбъектыСПрефиксомУдалить = Настройки.ПропускатьОбъектыСПрефиксомУдалить;
	КонецЕсли;
	
	Если Настройки.Свойство("РольБазовыеПрава") Тогда
		РольБазовыеПрава = Настройки.РольБазовыеПрава;
	КонецЕсли;
	
	Если Настройки.Свойство("ВыводитьИсключения") Тогда
		ВыводитьИсключения = Настройки.ВыводитьИсключения;
	КонецЕсли;
		
	Если Настройки.Свойство("ИсключенияИзпроверок") Тогда
		ИсключенияИзПроверок(Настройки);
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ИсключенияИзПроверок(Настройки)

	Для Каждого ИсключенияИзПроверокПоОбъектам Из Настройки.ИсключенияИзпроверок Цикл
		Для Каждого ИсключениеИзПроверок Из ИсключенияИзПроверокПоОбъектам.Значение Цикл
			ИсключенияИзПроверок.Вставить(ВРег(ИсключенияИзПроверокПоОбъектам.Ключ + "." + ИсключениеИзПроверок), Истина); 	
		КонецЦикла;
	КонецЦикла;	

КонецПроцедуры

#КонецОбласти

#Область Тесты

&НаКлиенте
Процедура ТестДолжен_ПроверитьЧтоЕстьПраваНаЧтение(ПолноеИмяМетаданных) Экспорт
	
	ПропускатьТест = ПропускатьТест(ПолноеИмяМетаданных);
	Право = ПравоДляПроверки(ПолноеИмяМетаданных);
	
	Результат = ПроверитьЧтоЕстьПраваНаЧтениеСервер(
					ПолноеИмяМетаданных, 
					Право,
					РольБазовыеПрава,
					ПрефиксОбъектов, 
					ОтборПоПрефиксу);
		
	Если Не Результат И ПропускатьТест.Пропустить Тогда
		Утверждения.ПропуститьТест(ТекстСообщения(ПолноеИмяМетаданных, Право));
	Иначе
		Утверждения.Проверить(Результат, ТекстСообщения(ПолноеИмяМетаданных, Право));
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьЧтоЕстьПраваНаЧтениеСервер(ПолноеИмяМетаданных, 
											Право, 
											РольБазовыеПрава, 
											ПрефиксОбъектов, 
											ОтборПоПрефиксу)

	ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ПолноеИмяМетаданных);	
	ЕстьРольБазовыеПрава = ЗначениеЗаполнено(РольБазовыеПрава);
	ЕстьПраво = Ложь;
	
	Если ЕстьРольБазовыеПрава И ПравоДоступа(Право, ОбъектМетаданных, Метаданные.Роли.Найти(РольБазовыеПрава)) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Для Каждого Роль Из Метаданные.Роли Цикл
		
		Если ОтборПоПрефиксу И Не ИмяСодержитПрефикс(Роль.Имя, ПрефиксОбъектов) Тогда
			Продолжить;
		КонецЕсли;
		
		Если Метаданные.ОсновныеРоли.Содержит(Роль) Тогда
			Продолжить;
		КонецЕсли;
		
		ЕстьПраво = ПравоДоступа(Право, ОбъектМетаданных, Роль);
		Если ЕстьПраво Тогда
			Возврат Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Ложь;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ПропускатьТест(ПолноеИмяМетаданных)

	Результат = Новый Структура;
	Результат.Вставить("ТекстСообщения", "");
	Результат.Вставить("Пропустить", Ложь);
	
	Если ИсключенИзПроверок(ПолноеИмяМетаданных) Тогда
		ШаблонСообшения = НСтр("ru = 'Объект ""%1"" исключен из проверки'");
		Результат.ТекстСообщения = СтроковыеУтилиты.ПодставитьПараметрыВСтроку(ШаблонСообшения, ПолноеИмяМетаданных);
		Результат.Пропустить = Истина;
		Возврат Результат;
	КонецЕсли;
	
	Если ПропускатьОбъектыСПрефиксомУдалить = Истина И СтрНайти(ВРег(ПолноеИмяМетаданных), ".УДАЛИТЬ") > 0 Тогда
		ШаблонСообшения = НСтр("ru = 'Объект ""%1"" исключен из проверки, префикс ""Удалить""'");
		Результат.ТекстСообщения = СтроковыеУтилиты.ПодставитьПараметрыВСтроку(ШаблонСообшения, ПолноеИмяМетаданных);
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
Функция ТекстСообщения(ПолноеИмяМетаданных, Право)

	ШаблонСообщения = НСтр("ru = 'Нет роли с правом ""%1"", кроме основных ролей, на объект метаданныхх ""%2""'");
	ТекстСообщения = СтроковыеУтилиты.ПодставитьПараметрыВСтроку(ШаблонСообщения, Право, ПолноеИмяМетаданных);
	
	Возврат ТекстСообщения;

КонецФункции

&НаСервереБезКонтекста
Функция ОбъектыМетаданных(ПрефиксОбъектов, ОтборПоПрефиксу)
	
	ОбъектыМетаданных = Новый Структура;
		
	ОбъектыМетаданных.Вставить("ПланыОбмена", Новый Массив);
	ОбъектыМетаданных.Вставить("Константы", Новый Массив);
	ОбъектыМетаданных.Вставить("Документы", Новый Массив);
	ОбъектыМетаданных.Вставить("Справочники", Новый Массив);
	ОбъектыМетаданных.Вставить("ПланыВидовХарактеристик", Новый Массив);
	ОбъектыМетаданных.Вставить("ПланыСчетов", Новый Массив);
	ОбъектыМетаданных.Вставить("ПланыВидовРасчета", Новый Массив);
	ОбъектыМетаданных.Вставить("Отчеты", Новый Массив);
	ОбъектыМетаданных.Вставить("Обработки", Новый Массив);
	ОбъектыМетаданных.Вставить("РегистрыСведений", Новый Массив);
	ОбъектыМетаданных.Вставить("РегистрыНакопления", Новый Массив);
	ОбъектыМетаданных.Вставить("РегистрыБухгалтерии", Новый Массив);
	ОбъектыМетаданных.Вставить("РегистрыРасчета", Новый Массив);
	ОбъектыМетаданных.Вставить("БизнесПроцессы", Новый Массив);
	ОбъектыМетаданных.Вставить("Задачи", Новый Массив);
	ОбъектыМетаданных.Вставить("ОбщиеФормы", Новый Массив);
	ОбъектыМетаданных.Вставить("ОбщиеКоманды", Новый Массив);
	
	СтроковыеУтилиты = СтроковыеУтилиты();
	
	Для Каждого Элемент Из ОбъектыМетаданных Цикл
		Для Каждого ОбъектМетаданных Из Метаданные[Элемент.Ключ] Цикл
			
			Если ОтборПоПрефиксу И Не ИмяСодержитПрефикс(ОбъектМетаданных.Имя, ПрефиксОбъектов) Тогда
				Продолжить;
			КонецЕсли;
			
			ДобавитьЭлементКоллекцииОбъектовМетаданных(
				ОбъектыМетаданных[Элемент.Ключ], 
				ОбъектМетаданных.ПолноеИмя(), 
				ОбъектМетаданных.ПолноеИмя());
			
			Параметры = Новый Структура;
			Параметры.Вставить("ОбъектМетаданных", ОбъектМетаданных);
			Параметры.Вставить("СтруктураОбъектовМетаданных", ОбъектыМетаданных);
			Параметры.Вставить("ИмяМетаданных", Элемент.Ключ);
			Параметры.Вставить("СтроковыеУтилиты", СтроковыеУтилиты);
			ОбработатьЭлементыОбъекта(Параметры, "Команды", "Команда");
			
		КонецЦикла;
	КонецЦикла;
	
	Возврат ОбъектыМетаданных;

КонецФункции

&НаСервереБезКонтекста
Процедура ОбработатьЭлементыОбъекта(Параметры, ИмяКоллекции, ИмяЭлемента)

	ОбъектМетаданных = Параметры.ОбъектМетаданных;
	СтруктураОбъектовМетаданных = Параметры.СтруктураОбъектовМетаданных;
	ИмяМетаданных = Параметры.ИмяМетаданных;
	СтроковыеУтилиты = Параметры.СтроковыеУтилиты;
	
	Если Не ЕстьРеквизитИлиСвойствоОбъекта(ОбъектМетаданных, ИмяКоллекции) Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ЭлементКоллекции Из ОбъектМетаданных[ИмяКоллекции] Цикл
		
		ДобавитьЭлементКоллекцииОбъектовМетаданных(
			СтруктураОбъектовМетаданных[ИмяМетаданных], 
			ЭлементКоллекции.ПолноеИмя(), 
			ЭлементКоллекции.ПолноеИмя());
						
	КонецЦикла;

КонецПроцедуры 

&НаСервереБезКонтекста
Процедура ДобавитьЭлементКоллекцииОбъектовМетаданных(Коллекция, Имя, ПолноеИмя)

	СтруктураЭлемента = Новый Структура;
	СтруктураЭлемента.Вставить("Имя", Имя);
	СтруктураЭлемента.Вставить("ПолноеИмя", ПолноеИмя);
	Коллекция.Добавить(СтруктураЭлемента);

КонецПроцедуры 

&НаКлиентеНаСервереБезКонтекста
Функция ЕстьРеквизитИлиСвойствоОбъекта(Объект, ИмяРеквизита) Экспорт
	
	КлючУникальности   = Новый УникальныйИдентификатор;
	СтруктураРеквизита = Новый Структура(ИмяРеквизита, КлючУникальности);
	ЗаполнитьЗначенияСвойств(СтруктураРеквизита, Объект);
	
	Возврат СтруктураРеквизита[ИмяРеквизита] <> КлючУникальности;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПравоДляПроверки(ПолноеИмяМетаданных)
	
	Если СтрНайти(ПолноеИмяМетаданных, "ОбщаяФорма.") > 0
	 Или СтрНайти(ПолноеИмяМетаданных, "ОбщаяКоманда.") > 0
	 Или СтрНайти(ПолноеИмяМетаданных, ".Команда.") > 0 Тогда
		Право = "Просмотр";
	ИначеЕсли СтрНайти(ПолноеИмяМетаданных, "Обработка.") > 0
	 Или СтрНайти(ПолноеИмяМетаданных, "Отчет.") > 0 Тогда
		Право = "Использование";
	Иначе
		Право = "Чтение";
	КонецЕсли;
	
	Возврат Право;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ИмяСодержитПрефикс(Имя, Префикс)
	
	Если Не ЗначениеЗаполнено(Префикс) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ДлинаПрефикса = СтрДлина(Префикс);
	Возврат СтрНайти(ВРег(Лев(Имя, ДлинаПрефикса)), ВРег(Префикс)) > 0;
	
КонецФункции

&НаСервереБезКонтекста
Функция СтроковыеУтилиты()
	Возврат ВнешниеОбработки.Создать("СтроковыеУтилиты");	
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
Функция ВыполнятьТест()
	
	ВыполнятьТест = Ложь;
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