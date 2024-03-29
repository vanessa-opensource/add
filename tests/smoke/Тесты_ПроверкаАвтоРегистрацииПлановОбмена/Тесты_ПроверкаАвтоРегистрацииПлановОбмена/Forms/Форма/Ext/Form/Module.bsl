﻿#Область ОписаниеПеременных

&НаКлиенте
Перем КонтекстЯдра;
&НаКлиенте
Перем Утверждения;
&НаКлиенте
Перем СтроковыеУтилиты;
&НаКлиенте
Перем ПрефиксОбъектов;
&НаКлиенте
Перем ОтборПоПрефиксу;
&НаКлиенте
Перем ВыводитьИсключения;
&НаКлиенте
Перем ИсключенияИзПроверок;

#КонецОбласти

#Область ИнтерфейсТестирования

&НаКлиенте
Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
	
	КонтекстЯдра = КонтекстЯдраПараметр;
	Утверждения = КонтекстЯдра.Плагин("БазовыеУтверждения");
	СтроковыеУтилиты = КонтекстЯдра.Плагин("СтроковыеУтилиты");
	
	ПутьНастройки = ИмяТеста();
	Настройки(КонтекстЯдра, ПутьНастройки);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьНаборТестов(НаборТестов, КонтекстЯдраПараметр) Экспорт
	
	Инициализация(КонтекстЯдраПараметр);
	
	Если Не ВыполнятьТест(КонтекстЯдра) Тогда
		Возврат;
	КонецЕсли;
		
	мПланыОбмена = ПланыОбмена(ПрефиксОбъектов, ОтборПоПрефиксу);
	
	Для Каждого ПланОбмена Из мПланыОбмена Цикл
		Если Не ВыводитьИсключения Тогда
			МассивТестов = УбратьИсключения(ПланОбмена.Ключ, ПланОбмена.Значение);
		Иначе
			МассивТестов = ПланОбмена.Значение;
		КонецЕсли;		
		Если МассивТестов.Количество() = 0 Тогда
			Продолжить;
		КонецЕсли;
		НаборТестов.НачатьГруппу(ПланОбмена.Ключ, Ложь);
		Для Каждого Элемент Из МассивТестов Цикл
			НаборТестов.Добавить(
				"ТестДолжен_ПроверитьАвтоРегистрацииПланаОбмена", 
				НаборТестов.ПараметрыТеста(ПланОбмена.Ключ, Элемент.ПолноеИмя, Элемент.АвтоРегистрация), 
				КонтекстЯдра.СтрШаблон_("%1 [%2]", Элемент.Имя, НСтр("ru = 'Проверка авторегистрации плана обмена'")));	
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
	
	ВыводитьИсключения = Истина;
	ОтборПоПрефиксу = Ложь;
	ПрефиксОбъектов = "";
	ИсключенияИзПроверок = Новый Соответствие;
	ПлагинНастроек = КонтекстЯдра.Плагин("Настройки");		
	Объект.Настройки = ПлагинНастроек.ПолучитьНастройку(ПутьНастройки);
	Настройки = Объект.Настройки;
	
	Если Не ЗначениеЗаполнено(Настройки) Тогда
		Объект.Настройки = Новый Структура(ПутьНастройки, Неопределено);
		Возврат;
	КонецЕсли;

	Если Настройки.Свойство("Префикс") Тогда
		ПрефиксОбъектов = ВРег(Настройки.Префикс);
	КонецЕсли;
	
	Если Настройки.Свойство("ОтборПоПрефиксу") Тогда
		ОтборПоПрефиксу = Настройки.ОтборПоПрефиксу;
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
Процедура ТестДолжен_ПроверитьАвтоРегистрацииПланаОбмена(ПланОбмена, ПолноеИмяМетаданных, АвтоРегистрация) Экспорт
	
	ПропускатьТест = ПропускатьТест(ПланОбмена, ПолноеИмяМетаданных);
	Результат = (АвтоРегистрация = "Запретить");
	
	Если Не Результат И ПропускатьТест.Пропустить Тогда
		Утверждения.ПропуститьТест(ТекстСообщения(ПланОбмена, ПолноеИмяМетаданных));
	Иначе
		Утверждения.Проверить(Результат = Истина, ТекстСообщения(ПланОбмена, ПолноеИмяМетаданных));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ПропускатьТест(ПланОбмена, ПолноеИмяМетаданных)

	Результат = Новый Структура;
	Результат.Вставить("ТекстСообщения", "");
	Результат.Вставить("Пропустить", Ложь);
	
	Если ИсключенИзПроверок(ПланОбмена, ПолноеИмяМетаданных) Тогда
		ШаблонСообшения = НСтр("ru = 'Объект ""%1"" исключен из проверки'");
		Результат.ТекстСообщения = СтроковыеУтилиты.ПодставитьПараметрыВСтроку(ШаблонСообшения, ПолноеИмяМетаданных);
		Результат.Пропустить = Истина;
		Возврат Результат;
	КонецЕсли;
			
	Возврат Результат;

КонецФункции 

&НаКлиенте
Функция ИсключенИзПроверок(ПланОбмена, ПолноеИмяМетаданных)
	
	Результат = Ложь;
	МассивСтрокИмени = СтроковыеУтилиты.РазложитьСтрокуВМассивПодстрок(ПланОбмена, ".");
	ИмяТеста = СтроковыеУтилиты.ПодставитьПараметрыВСтроку("%1.%2", МассивСтрокИмени[1], ПолноеИмяМетаданных);
	ИслючениеВсехОбъектов = СтроковыеУтилиты.ПодставитьПараметрыВСтроку("%1.*", МассивСтрокИмени[0]);
	
	Если ИсключенияИзПроверок.Получить(ВРег(ИмяТеста)) <> Неопределено
	 Или ИсключенияИзПроверок.Получить(ВРег(ИслючениеВсехОбъектов)) <> Неопределено Тогда
		Результат = Истина;	
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Функция УбратьИсключения(ПланОбмена, МассивТестов)

	Результат = Новый Массив;
	
	Для Каждого Тест Из МассивТестов Цикл
		Если Не ИсключенИзПроверок(ПланОбмена, Тест.ПолноеИмя) Тогда
			Результат.Добавить(Тест);
		КонецЕсли;	
	КонецЦикла;
	
	Возврат Результат;

КонецФункции

&НаКлиенте
Функция ТекстСообщения(ПланОбмена, ПолноеИмяМетаданных)

	ШаблонСообщения = НСтр("ru = 'Для объекта ""%1"" в плане обмена %2 включена авторегистрация.'");
	ТекстСообщения = СтроковыеУтилиты.ПодставитьПараметрыВСтроку(
						ШаблонСообщения, ПолноеИмяМетаданных, ПланОбмена);
	
	Возврат ТекстСообщения;

КонецФункции

&НаСервереБезКонтекста
Функция ПланыОбмена(ПрефиксОбъектов, ОтборПоПрефиксу)
		
	СтроковыеУтилиты = СтроковыеУтилиты();
	мПланыОбмена = Новый Соответствие;
	
	Для Каждого ПланОбмена Из Метаданные.ПланыОбмена Цикл
		мПланыОбмена.Вставить(ПланОбмена.ПолноеИмя(), Новый Массив);
	КонецЦикла;
	
	Для Каждого ПланОбмена Из мПланыОбмена Цикл
		
		ПланОбменаМетаданные = Метаданные.НайтиПоПолномуИмени(ПланОбмена.Ключ);
		Если ОтборПоПрефиксу И СтрНайти(ВРег(ПланОбмена.Ключ), ПрефиксОбъектов) = 0 Тогда
			Продолжить;
		КонецЕсли;
		
		Для Каждого ЭлементСостава Из ПланОбменаМетаданные.Состав Цикл
			СтруктураЭлемента = Новый Структура;
			СтруктураЭлемента.Вставить("ПолноеИмя", ЭлементСостава.Метаданные.ПолноеИмя());
			ИмяТеста = СтроковыеУтилиты.ПодставитьПараметрыВСтроку(
							"%1.%2", 
							ПланОбменаМетаданные.Имя, 
							ЭлементСостава.Метаданные.ПолноеИмя());
			СтруктураЭлемента.Вставить("Имя", ИмяТеста);
			СтруктураЭлемента.Вставить("АвтоРегистрация", Строка(ЭлементСостава.АвтоРегистрация));
			ПланОбмена.Значение.Добавить(СтруктураЭлемента);
		КонецЦикла;

	КонецЦикла;
	
	Возврат мПланыОбмена;

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
Функция ВыполнятьТест(КонтекстЯдра)
	
	ВыполнятьТест = Ложь;
	ПутьНастройки = ИмяТеста();
	Настройки(КонтекстЯдра, ПутьНастройки);
	Настройки = Объект.Настройки;
	
	Если Не ЗначениеЗаполнено(Настройки) Тогда
		Возврат ВыполнятьТест;
	КонецЕсли;
		
	Если ТипЗнч(Настройки) = Тип("Структура") И Настройки.Свойство("Используется") Тогда
		ВыполнятьТест = Настройки.Используется;	
	КонецЕсли;
	
	Возврат ВыполнятьТест;

КонецФункции

&НаСервереБезКонтекста
Процедура ЗаписатьИнформациюВЖурналРегистрации(Знач Комментарий)
	ЗаписьЖурналаРегистрации(ИмяСобытия(), УровеньЖурналаРегистрации.Информация,,, Комментарий);
КонецПроцедуры
  
&НаСервереБезКонтекста
Процедура ЗаписатьПредупреждениеВЖурналРегистрацииСервер(Комментарий)
	ЗаписьЖурналаРегистрации(ИмяСобытия(), УровеньЖурналаРегистрации.Предупреждение, , , Комментарий);
КонецПроцедуры
	
&НаСервереБезКонтекста
Процедура ЗаписатьОшибкуВЖурналРегистрации(Комментарий)
	ЗаписьЖурналаРегистрации(ИмяСобытия(), УровеньЖурналаРегистрации.Ошибка, , , Комментарий);
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИмяСобытия()
	Возврат "VanessaADD.Дымовые.Тесты_ПроверкаАвтоРегистрацииПлановОбмена"; // по аналогии с другими тестами
КонецФункции
#КонецОбласти