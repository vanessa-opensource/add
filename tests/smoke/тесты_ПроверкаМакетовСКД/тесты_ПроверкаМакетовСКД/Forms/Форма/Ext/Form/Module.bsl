﻿#Область ОписаниеПеременных

&НаКлиенте
Перем КонтекстЯдра;
&НаКлиенте
Перем Утверждения;

#КонецОбласти

#Область ОсновныеПроцедурыТеста

&НаСервере
Функция КлючНастройки() Экспорт
	Возврат МодульОбъекта().КлючНастройки();
КонецФункции

&НаКлиенте
Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
	КонтекстЯдра = КонтекстЯдраПараметр;
	Утверждения = КонтекстЯдра.Плагин("БазовыеУтверждения");
	
	ЗагрузитьНастройки();
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьНаборТестов(НаборТестов, КонтекстЯдраПараметр) Экспорт
	
	Если ТекущийРежимЗапуска() = РежимЗапускаКлиентскогоПриложения.ОбычноеПриложение Then
		Возврат;	
	КонецЕсли;
	
	КонтекстЯдра = КонтекстЯдраПараметр;
	ЗагрузитьНастройки();
	
	Если Не НужноВыполнятьТест() Тогда
		Возврат;
	КонецЕсли;
	
	КонтекстЯдра = КонтекстЯдраПараметр;
		
	ДобавитьОбщиеМакеты(НаборТестов);
	
	ДобавитьМакетМетаданных(НаборТестов);
	
КонецПроцедуры

&НаКлиенте
Процедура ТестДолжен_ПроверитьМакетСКД(ИмяМенеджера, ИмяОбьекта, ИмяМакета) Экспорт
	ПроверитьМакетСКД(ИмяМенеджера, ИмяОбьекта, ИмяМакета);	
КонецПроцедуры

&НаСервере
Процедура ПроверитьМакетСКД(ИмяМенеджера, ИмяОбьекта, ИмяМакета)
	МодульОбъекта().ТестДолжен_ПроверитьМакетСКД(ИмяМенеджера, ИмяОбьекта, ИмяМакета);	
КонецПроцедуры

&НаКлиенте
Процедура ТестДолжен_ПроверитьОбщийМакетСКД(ИмяМакета) Экспорт
	ПроверитьОбщийМакетСКД(ИмяМакета);		
КонецПроцедуры

&НаСервере
Процедура ПроверитьОбщийМакетСКД(ИмяМакета)
	МодульОбъекта().ТестДолжен_ПроверитьОбщийМакетСКД(ИмяМакета);
КонецПроцедуры

&НаКлиенте
Процедура ТестДолжен_ПроверитьВложенныйМакетСКД(ИмяМенеджера, ИмяОбьекта, ИменаМакетов) Экспорт
	ПроверитьВложенныйМакетСКД(ИмяМенеджера, ИмяОбьекта, ИменаМакетов);		
КонецПроцедуры

&НаСервере
Процедура ПроверитьВложенныйМакетСКД(ИмяМенеджера, ИмяОбьекта, ИменаМакетов)
	МодульОбъекта().ТестДолжен_ПроверитьВложенныйМакетСКД(ИмяМенеджера, ИмяОбьекта, ИменаМакетов);
КонецПроцедуры

&НаКлиенте
Процедура ТестДолжен_ПропуститьМакетСКД(ТекстСообщения) Экспорт
	Утверждения.ПропуститьТест(ТекстСообщения);	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Настройки

&НаКлиенте
Процедура ЗагрузитьНастройки()
	Если ЗначениеЗаполнено(Объект.Настройки) Тогда
		Возврат;
	КонецЕсли;

    ПлагинНастройки = КонтекстЯдра.Плагин("Настройки");
    ПлагинНастройки.Инициализация(КонтекстЯдра);
    
    Объект.Настройки = ПлагинНастройки.ПолучитьНастройку(КлючНастройки());
	
	НастройкиПоУмолчанию = НастройкиПоУмолчанию();
    Если ТипЗнч(Объект.Настройки) <> Тип("Структура") Then
        Объект.Настройки = НастройкиПоУмолчанию;
	Иначе
		ЗаполнитьЗначенияСвойств(НастройкиПоУмолчанию, Объект.Настройки);
        Объект.Настройки = НастройкиПоУмолчанию;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Функция НастройкиПоУмолчанию()
	
	Результат = Новый Структура;
	
	Результат.Вставить("Используется", Истина);
	Результат.Вставить("ИсключенияОбщихМакетов", Новый Массив);
	Результат.Вставить("ИсключенияПоИмениМетаданных", Новый Массив);
	Результат.Вставить("ИсключенияПоИмениМакетов", Новый Массив);
	Результат.Вставить("ОтборПоПрефиксу", Ложь);
	Результат.Вставить("Префикс", "");
	
	Возврат Результат;
КонецФункции

&НаКлиенте
Функция НужноВыполнятьТест()
	
	ЗагрузитьНастройки();
	
	Если Не ЗначениеЗаполнено(Объект.Настройки) Тогда
		Возврат Истина;
	КонецЕсли;
	
	КлючНастройки = КлючНастройки();
	
	ВыполнятьТест = Истина;
	Если ТипЗнч(Объект.Настройки) = Тип("Структура") 
		И Объект.Настройки.Свойство("Используется", ВыполнятьТест) Тогда

			Возврат ВыполнятьТест = Истина;	
	КонецЕсли;
	
	Возврат Истина;

КонецФункции

#КонецОбласти

&НаКлиенте
Процедура ДобавитьОбщиеМакеты(НаборТестов)
	
	мОбщиеМакеты = ОбщиеМакеты();
			
	Если мОбщиеМакеты.Количество() > 0 Тогда
		
		НаборТестов.НачатьГруппу(ТекстОбщиеМакеты(), Ложь);
		
		Для Каждого ОбщийМакет Из мОбщиеМакеты Цикл
			
			НаборТестов.Добавить(ОбщийМакет.ИмяПроцедуры, ОбщийМакет.Параметры, ОбщийМакет.Представление);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ОбщиеМакеты()
	Возврат МодульОбъекта().ОбщиеМакеты(Объект.Настройки.ОтборПоПрефиксу, Объект.Настройки.Префикс);
КонецФункции

&НаКлиенте
Процедура ДобавитьМакетМетаданных(НаборТестов)

	ГруппыМакетовМетаданных = ГруппыМакетовМетаданных();

	Для Каждого ГруппаМакетовМетаданных Из ГруппыМакетовМетаданных Цикл

		Если ГруппаМакетовМетаданных.Значение.Количество() > 0 Тогда

			НаборТестов.НачатьГруппу(ГруппаМакетовМетаданных.Ключ, Ложь);

			Для Каждого МакетМетаданных Из ГруппаМакетовМетаданных.Значение Цикл

				НаборТестов.Добавить(
					МакетМетаданных.ИмяПроцедуры, 
					МакетМетаданных.Параметры, 
					МакетМетаданных.Представление);

			КонецЦикла;

		КонецЕсли;

	КонецЦикла;

КонецПроцедуры

&НаСервере
Функция ГруппыМакетовМетаданных()
	Возврат МодульОбъекта().ГруппыМакетовМетаданных(Объект.Настройки.ОтборПоПрефиксу, Объект.Настройки.Префикс);
КонецФункции

&НаСервере
Функция МодульОбъекта()
	Возврат РеквизитФормыВЗначение("Объект");
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ТекстОбщиеМакеты() Экспорт
	Возврат "ОбщиеМакеты";
КонецФункции

&НаКлиенте
Функция ДобавитьТестИсключениеЕслиЕстьВИсключаемойКоллекции(Знач ЧтоИщем, 
															Знач КоллекцияДляПоиска, 
															Знач Сообщение, 
															Знач НаборТестов)
			
	Если КонтекстЯдра.ЕстьВИсключаемойКоллекции(ЧтоИщем, КоллекцияДляПоиска) Тогда
		
		КонтекстЯдра.Отладка(Сообщение);
		ПараметрыТеста = НаборТестов.ПараметрыТеста(Сообщение);
		
		НаборТестов.Добавить("Тест_ПропуститьМакетСКД", ПараметрыТеста, Сообщение);	
		
		Возврат Истина;
		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ЗаписатьИнформациюВЖурналРегистрации(Знач Комментарий)
	ЗаписьЖурналаРегистрации(ИмяСобытия(), УровеньЖурналаРегистрации.Информация,,, Комментарий);
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИмяСобытия()
	Возврат "VanessaADD.Дымовые.тесты_ПроверкаМакетовСКД"; // по аналогии с другими тестами
КонецФункции
  
&НаСервереБезКонтекста
Процедура ЗаписатьПредупреждениеВЖурналРегистрацииСервер(Комментарий)
	ЗаписьЖурналаРегистрации(ИмяСобытия(), УровеньЖурналаРегистрации.Предупреждение, , , Комментарий);
КонецПроцедуры
	
&НаСервереБезКонтекста
Процедура ЗаписатьОшибкуВЖурналРегистрации(Комментарий)
	ЗаписьЖурналаРегистрации(ИмяСобытия(), УровеньЖурналаРегистрации.Ошибка, , , Комментарий);
КонецПроцедуры

#КонецОбласти