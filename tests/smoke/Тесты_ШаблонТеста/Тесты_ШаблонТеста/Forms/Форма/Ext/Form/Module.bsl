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
Перем ОтборПоПрефиксу;
&НаКлиенте
Перем ПрефиксОбъектов;

#КонецОбласти

#Область ИнтерфейсТестирования

// Инициализация
//
// Параметры:
//  КонтекстЯдраПараметр - xddTestRunner.epf - Внешняя обработка, браузер тестов. По умолчанию находится в каталоге "C:\Program Files\OneScript\lib\add\"
//
&НаКлиенте
Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
	
	КонтекстЯдра 		= КонтекстЯдраПараметр;
	
	// подключение плагинов, установка переменных формы
	Утверждения 		= КонтекстЯдра.Плагин("БазовыеУтверждения"); // обработка с именем "БазовыеУтверждения.epf", находится в каталоге "C:\Program Files\OneScript\lib\add\plugins" 
	СтроковыеУтилиты 	= КонтекстЯдра.Плагин("СтроковыеУтилиты"); // обработка с именем "СтроковыеУтилиты.epf", находится в каталоге "C:\Program Files\OneScript\lib\add\plugins"
	
	Настройки(КонтекстЯдра, ИмяТеста());
	
КонецПроцедуры

// Выполняет заполнение набора тестов
//
// Параметры:
//  НаборТестов			 - ЗагрузчикФайла.epf	 - Внешняя обработка - плагин. По умолчанию находится в каталоге "C:\Program Files\OneScript\lib\add\plugins"
//  КонтекстЯдраПараметр - xddTestRunner.epf	 - Внешняя обработка, браузер тестов. По умолчанию находится в каталоге "C:\Program Files\OneScript\lib\add\"
//
&НаКлиенте
Процедура ЗаполнитьНаборТестов(НаборТестов, КонтекстЯдраПараметр) Экспорт
	
	Инициализация(КонтекстЯдраПараметр);
	
	Если Не ВыполнятьТест(КонтекстЯдра) Тогда
		Возврат;
	КонецЕсли;
	
	СтрогийПорядокВыполнения = Ложь;
	НаборТестов.НачатьГруппу("ИмяГруппы", СтрогийПорядокВыполнения);
	
	НаборТестов.Добавить("ТестДолжен_ПроверитьЧто", НаборТестов.ПараметрыТеста("ПараметрТеста"), "Пользовательское представление теста");
			
КонецПроцедуры

#КонецОбласти

#Область РаботаСНастройками

// Применить настройки теста из внешнего файла
//
// Параметры:
//  КонтекстЯдра	 - xddTestRunner.epf - Внешняя обработка, браузер тестов. По умолчанию находится в каталоге "C:\Program Files\OneScript\lib\add\"
//  ПутьНастройки	 - Строка			 - имя теста, как указано  в имени обработки
//
&НаКлиенте
Процедура Настройки(КонтекстЯдра, Знач ПутьНастройки)

	Если ЗначениеЗаполнено(Объект.Настройки) Тогда
		Возврат;
	КонецЕсли;
	
	ПрефиксОбъектов 		= "";
	ОтборПоПрефиксу 		= Ложь;
	ИсключенияИзПроверок 	= Новый Соответствие;
	ВыводитьИсключения 		= Истина;
	ПлагинНастроек 			= КонтекстЯдра.Плагин("Настройки");
	Объект.Настройки 		= ПлагинНастроек.ПолучитьНастройку(ПутьНастройки); // выполняет чтение настроек из JSON - файла по ключу ИмяТеста()
	Настройки 				= Объект.Настройки;
	
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
	
	Если Настройки.Свойство("ИсключенияИзПроверок") Тогда
		ИсключенияИзПроверок(Настройки);
	КонецЕсли;
	
КонецПроцедуры

// Исключения из проверок
//
// Параметры:
//  Настройки	 - Структура, ФиксированнаяСтруктура - см. ПлагинНастроек.ПолучитьНастройку(ПутьНастройки) 
//
&НаКлиенте
Процедура ИсключенияИзПроверок(Настройки)

	Для Каждого ИсключенияИзПроверокПоОбъектам Из Настройки.ИсключенияИзПроверок Цикл
		Для Каждого ИсключениеИзПроверок Из ИсключенияИзПроверокПоОбъектам.Значение Цикл
			ИсключенияИзПроверок.Вставить(ВРег(ИсключенияИзПроверокПоОбъектам.Ключ + "." + ИсключениеИзПроверок), Истина); 	
		КонецЦикла;
	КонецЦикла;	

КонецПроцедуры

#КонецОбласти

#Область Тесты

&НаКлиенте
Процедура ТестДолжен_ПроверитьЧто(ПолноеИмяМетаданных) Экспорт
		
	ПропускатьТест = ПропускатьТест(ПолноеИмяМетаданных);
	
	Результат = ПроверитьЧто();
	Если Не Результат И ПропускатьТест.Пропустить Тогда
		Утверждения.ПропуститьТест(ТекстСообщения(ПолноеИмяМетаданных));
	Иначе
		Утверждения.Проверить(Результат, ТекстСообщения(ПолноеИмяМетаданных));
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьЧто()
	
	Результат = Истина;
	
	Возврат Результат;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ПропускатьТест(ПолноеИмяМетаданных)

	Результат = Новый Структура;
	Результат.Вставить("ТекстСообщения", "");
	Результат.Вставить("Пропустить", Ложь);
		
	Если ИсключенИзПроверок(ВРег(ПолноеИмяМетаданных)) Тогда
		ШаблонСообщения = НСтр("ru = '""%1"" исключен из проверки.'");
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
	ИсключениеВсехОбъектов = СтроковыеУтилиты.ПодставитьПараметрыВСтроку("%1.*", МассивСтрокИмени[0]);
	
	Если ИсключенияИзПроверок.Получить(ВРег(ПолноеИмяМетаданных)) <> Неопределено
	 Или ИсключенияИзПроверок.Получить(ВРег(ИсключениеВсехОбъектов)) <> Неопределено Тогда
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

	ШаблонСообщения = НСтр("ru = 'Тест не пройден: %1.'");
	ТекстСообщения = СтроковыеУтилиты.ПодставитьПараметрыВСтроку(ШаблонСообщения, ПолноеИмяМетаданных);
	
	Возврат ТекстСообщения;

КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ИмяСодержитПрефикс(Имя, Префикс)
	
	Если Не ЗначениеЗаполнено(Префикс) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ДлинаПрефикса = СтрДлина(Префикс);
	Возврат СтрНайти(ВРег(Лев(Имя, ДлинаПрефикса)), Префикс) > 0;
	
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

// Выполняет проверку выполнять тест
//
// Параметры:
//  КонтекстЯдра - xddTestRunner.epf - Внешняя обработка, браузер тестов. По умолчанию находится в каталоге "C:\Program Files\OneScript\lib\add\"
//
// Для включения теста необходимо изменить переменную ВыполнятьТест на Истина.
// При наличии файла - настроек значение ВыполнятьТест определяется из файла.
// 
// Возвращаемое значение:
//  ВыполнятьТест - Булево
//
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
