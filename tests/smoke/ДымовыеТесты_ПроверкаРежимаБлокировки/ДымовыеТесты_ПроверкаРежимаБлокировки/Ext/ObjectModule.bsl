﻿Перем Ожидаем;
Перем ИтераторМетаданных;

#Область Стандартный_интерфейс

Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
	
	// Подключаем плагин для текучих утверждений
	Ожидаем = КонтекстЯдраПараметр.Плагин("УтвержденияBDD");
	
	// Подключаем Итератор
	ИтераторМетаданных = КонтекстЯдраПараметр.Плагин("ИтераторМетаданных");
	ИтераторМетаданных.Инициализация(КонтекстЯдраПараметр); // Сбрасываем настройки Итератора
	ИтераторМетаданных.ДополнятьЗависимымиОбъектами = Истина;	
	// Исключим коллекции, у элементов которых нет свойства РежимУправленияБлокировкойДанных
	ИтераторМетаданных.ИсключаемыеМетаданные.Добавить(Метаданные.Перечисления);	
	ИтераторМетаданных.ИсключаемыеМетаданные.Добавить(Метаданные.Обработки);	
	ИтераторМетаданных.ИсключаемыеМетаданные.Добавить(Метаданные.ЖурналыДокументов);	
	ИтераторМетаданных.ИсключаемыеМетаданные.Добавить(Метаданные.КритерииОтбора);	
	
КонецПроцедуры

Процедура ЗаполнитьНаборТестов(НаборТестовПараметр, КонтекстЯдраПараметр) Экспорт
	
	// Инициализируем плагины
	Инициализация(КонтекстЯдраПараметр);
	
	// Из итератора получаем ДеревоЗначений с описанием метаданных
	ДеревоМетаданных = ИтераторМетаданных.ДеревоМетаданных();
	
	// Проходим по дереву, по корневым узлам
	Для Каждого КорневаяСтрока Из ДеревоМетаданных.Строки Цикл 
		
		Родитель = КорневаяСтрока.ОбъектМетаданных;
		// Начинаем группу тестов по разделу метаданных
		НаборТестовПараметр.НачатьГруппу("Проверка режима блокировки данных " + Родитель);
		
		// Проходим по составу раздела метаданных
		Для Каждого СтрокаМетаданных Из КорневаяСтрока.Строки Цикл 
			
			ТекОбъектМетаданных = СтрокаМетаданных.ОбъектМетаданных;
			ПолноеИмяОбъекта = ТекОбъектМетаданных.ПолноеИмя();
			ЭтоВебСервис = Найти(ПолноеИмяОбъекта, "WebСервис")=1;
			
			Если ЭтоВебСервис Тогда 
				// Для веб-сервиса режим блокировки проверяем у его операций
				Для Каждого Операция Из ТекОбъектМетаданных.Операции Цикл 
					ПараметрыТеста = НаборТестовПараметр.ПараметрыТеста(Операция, Родитель);
					ЗаголовокТеста = "" + ТекОбъектМетаданных.ПолноеИмя() + "." + Операция.Имя;
					НаборТестовПараметр.Добавить("Тест_ПроверитьРежимБлокировкиОбъекта", ПараметрыТеста, ЗаголовокТеста);
				КонецЦикла;
			Иначе
				ПараметрыТеста = НаборТестовПараметр.ПараметрыТеста(ТекОбъектМетаданных, Родитель);
				ЗаголовокТеста = "" + ТекОбъектМетаданных.ПолноеИмя();
				НаборТестовПараметр.Добавить("Тест_ПроверитьРежимБлокировкиОбъекта", ПараметрыТеста, ЗаголовокТеста);
			КонецЕсли;
			
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

// Сам тест
Процедура Тест_ПроверитьРежимБлокировкиОбъекта(ОбъектМетаданных, Родитель) Экспорт
	
	РежимПроверен = ОбъектМетаданных.РежимУправленияБлокировкойДанных=Метаданные.РежимУправленияБлокировкойДанных;
	Ожидаем.Что(РежимПроверен).ЕстьИстина();
	
КонецПроцедуры

Процедура ПередЗапускомТеста() Экспорт
	// Ничего не делаем
КонецПроцедуры

Процедура ПослеЗапускаТеста() Экспорт
	// Ничего не делаем	
КонецПроцедуры

#КонецОбласти

