﻿&НаКлиенте
Перем ПостроительДереваТестов;
&НаКлиенте
Перем ЗагружаемыйПуть;

&НаКлиенте
Перем КонтейнерТестов;
&НаКлиенте
Перем ТекущаяГруппа;

// { Plugin interface
&НаКлиенте
Функция ОписаниеПлагина(КонтекстЯдра, ВозможныеТипыПлагинов) Экспорт
	Возврат ОписаниеПлагинаНаСервере(ВозможныеТипыПлагинов);
КонецФункции

&НаСервере
Функция ОписаниеПлагинаНаСервере(ВозможныеТипыПлагинов)
	КонтекстЯдраНаСервере = ВнешниеОбработки.Создать("xddTestRunner");
	Возврат ЭтотОбъектНаСервере().ОписаниеПлагина(КонтекстЯдраНаСервере, ВозможныеТипыПлагинов);
КонецФункции
// } Plugin interface

// { Loader interface

&НаКлиенте
Функция ВыбратьПутьИнтерактивно(КонтекстЯдра, ТекущийПуть = "") Экспорт
	
	Возврат ВыбратьПутьИнтерактивноРаботаСОкном(КонтекстЯдра);
	
КонецФункции

&НаКлиенте
Функция Загрузить(КонтекстЯдра, Путь) Экспорт
	ПолноеИмяБраузераТестов = КонтекстЯдра.Объект.ПолноеИмяБраузераТестов;
	
	СтруктураМетаданных = СтруктураМетаданныхПоПереданномуПути(Путь);
	ПостроительДереваТестов = КонтекстЯдра.Плагин("ПостроительДереваТестов");
	ДеревоТестов = Неопределено;
	ОбработатьОбъектМетаданных(СтруктураМетаданных, ДеревоТестов);
	Возврат ДеревоТестов;
КонецФункции

&НаКлиенте
Процедура НачатьЗагрузку(ОбработкаОповещения, КонтекстЯдра, Путь) Экспорт
	ПолноеИмяБраузераТестов = КонтекстЯдра.Объект.ПолноеИмяБраузераТестов;

	СтруктураМетаданных = СтруктураМетаданныхПоПереданномуПути(Путь);
	ПостроительДереваТестов = КонтекстЯдра.Плагин("ПостроительДереваТестов");
	ДеревоТестов = Неопределено;
	ОбработатьОбъектМетаданных(СтруктураМетаданных, ДеревоТестов);

	ВыполнитьОбработкуОповещения(ОбработкаОповещения, ДеревоТестов);

КонецПроцедуры

&НаКлиенте
Функция ПолучитьКонтекстПоПути(КонтекстЯдра, Путь) Экспорт
	Перем Контекст;
	Если ЭтоПутьККлиентскомуКонтексту(Путь) Тогда
		Контекст = ПолучитьКлиентскийКонтекст(КонтекстЯдра, Путь);
	Иначе
		Контекст = ПолучитьСерверныйКонтекст(КонтекстЯдра, Путь);
	КонецЕсли;
	
	Возврат Контекст;
КонецФункции
// } Loader interface

&НаКлиенте
Функция ПолучитьКлиентскийКонтекст(КонтекстЯдра, Путь)
	ИдентификаторКонтекста = ПолучитьИдентификаторКонтекстаПоПутиНаСервере(Сред(Путь, СтрДлина(ПрефиксПутейСФормами()) + 1));
	ОписаниеКонтекста = ПолучитьФорму("Обработка." + ИдентификаторКонтекста + ".Форма", , ЭтаФорма, Новый УникальныйИдентификатор);
	КонтекстЯдра.ПолучитьОписаниеКонтекстаВыполнения(ИдентификаторКонтекста, Истина);
	
	Возврат ОписаниеКонтекста;
КонецФункции

&НаКлиенте
Функция ПолучитьСерверныйКонтекст(КонтекстЯдра, Путь)
	ИдентификаторКонтекста = ПолучитьИдентификаторКонтекстаПоПутиНаСервере(Путь);
	ОписаниеКонтекста = КонтекстЯдра.ПолучитьОписаниеКонтекстаВыполнения(ИдентификаторКонтекста, Истина);
	
	Возврат ОписаниеКонтекста;
КонецФункции

&НаСервере
Функция СтруктураМетаданныхПоПереданномуПути(Путь)
	ОбъектМетаданных = ЭтотОбъектНаСервере().ПолучитьОбъектМетаданныхПоПути(Путь);
	Если ЭтоПодсистема(ОбъектМетаданных.ПолноеИмя()) Тогда
		СтруктураМетаданных = СтруктураМетаданныхПодсистемы(ОбъектМетаданных);
	Иначе
		СтруктураМетаданных = СтрокаДереваМетаданных(ОбъектМетаданных);
	КонецЕсли;
	Возврат СтруктураМетаданных;
КонецФункции

&НаСервере
Функция СтруктураМетаданныхПодсистемы(Подсистема)
	СтруктураМетаданных = СтрокаДереваМетаданных(Подсистема);
	Для Каждого ПодчиненнаяПодсистема Из Подсистема.Подсистемы Цикл
		СтруктураМетаданных.Строки.Добавить(СтруктураМетаданныхПодсистемы(ПодчиненнаяПодсистема));
	КонецЦикла;
	
	Для Каждого ДочернееМетаданное Из Подсистема.Состав цикл
		Если Метаданные.Обработки.Найти(ДочернееМетаданное.Имя) <> Неопределено
			ИЛИ Метаданные.Отчеты.Найти(ДочернееМетаданное.Имя) <> Неопределено Тогда
			СтруктураМетаданныхОбработки = СтрокаДереваМетаданных(ДочернееМетаданное);
			СтруктураМетаданных.Строки.Добавить(СтруктураМетаданныхОбработки);
		КонецЕсли;
	КонецЦикла;
	
	Возврат СтруктураМетаданных;
КонецФункции

&НаСервере
Функция СтрокаДереваМетаданных(ОбъектМетаданных)
	СтрокаДерева = Новый Структура();
	СтрокаДерева.Вставить("Имя", ОбъектМетаданных.Имя);
	СтрокаДерева.Вставить("ПолноеИмя", ОбъектМетаданных.ПолноеИмя());
	СтрокаДерева.Вставить("Строки", Новый Массив);
	
	Возврат СтрокаДерева;
КонецФункции

&НаКлиенте
Функция ОбработатьОбъектМетаданных(СтруктураМетаданных, ДеревоТестов)
	Если ЭтоПодсистема(СтруктураМетаданных.ПолноеИмя) Тогда
		Контейнер = ЗагрузитьПодсистему(СтруктураМетаданных, ДеревоТестов);
	Иначе
		Контейнер = ЗагрузитьОбработку(СтруктураМетаданных, ДеревоТестов);
	КонецЕсли;
	
	Возврат Контейнер;
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ЭтоПодсистема(ПолноеИмяОбъектаМетаданных)
	Возврат (Найти(НРег(ПолноеИмяОбъектаМетаданных), НРег("Подсистема")) > 0);
КонецФункции

&НаКлиенте
Функция ЗагрузитьПодсистему(СтруктураМетаданных, ДеревоТестов)

	Контейнер = ПостроительДереваТестов.СоздатьКонтейнер(СтруктураМетаданных.Имя, ПостроительДереваТестов.Объект.ИконкиУзловДереваТестов.Подсистема);
	Для Каждого ПодчиненноеМетаданное Из СтруктураМетаданных.Строки Цикл
		Если ЭтоПодсистема(ПодчиненноеМетаданное.ПолноеИмя) Тогда
			ЗагрузитьПодсистему(ПодчиненноеМетаданное, Контейнер);
		Иначе
			ЗагрузитьОбработку(ПодчиненноеМетаданное, Контейнер);
		КонецЕсли;
	КонецЦикла;
	
	Если ДеревоТестов = Неопределено Тогда
		ДеревоТестов = Контейнер;
	ИначеЕсли Контейнер.Строки.Количество() > 0 Тогда
		ДеревоТестов.Строки.Добавить(Контейнер);
	КонецЕсли;
	
	Возврат Контейнер;
КонецФункции

&НаКлиенте
Функция ЗагрузитьОбработку(СтруктураМетаданных, ДеревоТестов)
	ЗагружаемыйПуть = СтрЗаменить("Метаданные." + СтруктураМетаданных.ПолноеИмя, ".Обработка.", ".Обработки.");
	ЗагружаемыйПуть = СтрЗаменить(ЗагружаемыйПуть, ".Отчет.", ".Отчеты."); 
	Контейнер = ЗагрузитьОбработкуНаСервере(ЗагружаемыйПуть);
	КонтейнерСКлиентскимиТестамиОбработки = ЗагрузитьОбработкуНаКлиенте(СтруктураМетаданных);
	Если КонтейнерСКлиентскимиТестамиОбработки.Строки.Количество() > 0 Тогда
		Контейнер.Строки.Добавить(КонтейнерСКлиентскимиТестамиОбработки);
	КонецЕсли;
	Если ДеревоТестов = Неопределено Тогда
		ДеревоТестов = Контейнер;
	ИначеЕсли Контейнер.Строки.Количество() > 0 Тогда
		ДеревоТестов.Строки.Добавить(Контейнер);
	КонецЕсли;
	
	Возврат Контейнер;
КонецФункции

&НаСервере
Функция ЗагрузитьОбработкуНаСервере(Путь)
	КонтекстЯдра = ПолучитьКонтекстЯдраНаСервере();
	
	ПостроительДереваТестов = КонтекстЯдра.СоздатьОбъектПлагина("ПостроительДереваТестов");
	ЗагрузчикФайла = КонтекстЯдра.СоздатьОбъектПлагина("ЗагрузчикФайла");
	
	ДеревоТестов = ЭтотОбъектНаСервере().ЗагрузитьПуть(Путь, ПостроительДереваТестов, ЗагрузчикФайла);
	
	Возврат ДеревоТестов;
КонецФункции

&НаКлиенте
Функция ЗагрузитьОбработкуНаКлиенте(СтруктураМетаданных)
	ФормаОбработки = ПолучитьФорму(СтруктураМетаданных.ПолноеИмя + ".Форма");
	Попытка
		Контейнер = ЗагрузитьТестыВНовомФормате_НаКлиенте(ФормаОбработки);
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		Если ЭтоНовыйФорматОбработки(ТекстОшибки) Тогда
			ВызватьИсключение;
		Иначе
			Контейнер = ЗагрузитьТестыВСтаромФормате_НаКлиенте(ФормаОбработки);
		КонецЕсли;
	КонецПопытки;
	Возврат Контейнер;
КонецФункции

&НаКлиенте
Функция ЭтоНовыйФорматОбработки(Знач ТекстОшибки)
	ЭтоНовыйФорматОбработки = Не ЕстьОшибка_МетодОбъектаНеОбнаружен(ТекстОшибки, "ЗаполнитьНаборТестов");
	
	Возврат ЭтоНовыйФорматОбработки;
КонецФункции

&НаКлиенте
Функция ЗагрузитьТестыВНовомФормате_НаКлиенте(ФормаОбработки)
	КонтейнерТестов = ПостроительДереваТестов.СоздатьКонтейнер(ПрефиксПутейСФормами() + СтрЗаменить(ЗагружаемыйПуть, "Метаданные.Обработки.", ""), ПостроительДереваТестов.Объект.ИконкиУзловДереваТестов.Форма);
	ФормаОбработки.ЗаполнитьНаборТестов(ЭтаФорма);
	Результат = КонтейнерТестов;
	КонтейнерТестов = Неопределено;
	ТекущаяГруппа = Неопределено;
	
	Возврат Результат;
КонецФункции

&НаКлиенте
Функция ЗагрузитьТестыВСтаромФормате_НаКлиенте(ФормаОбработки)
	Попытка
		СписокТестов = ФормаОбработки.ПолучитьСписокТестов();
	Исключение
		Описание = ОписаниеОшибки();
		Если Найти(Описание, "Недостаточно фактических параметров") > 0 Тогда
			ВызватьИсключение "Старый формат тестов в обработке тестов <"+ЗагружаемыйПуть+">."+Символы.ПС+
				"Метод ПолучитьСписокТестов сейчас не принимает параметров";
		КонецЕсли;
		
		Если Найти(Описание, "Метод объекта не обнаружен (ПолучитьСписокТестов)") = 0 Тогда
			ВызватьИсключение Описание;
		КонецЕсли;
	КонецПопытки;
	СлучайныйПорядокВыполнения = Истина;
	Попытка
		СлучайныйПорядокВыполнения = ФормаОбработки.РазрешенСлучайныйПорядокВыполненияТестов();
	Исключение
	КонецПопытки;
	
	Контейнер = ПолучитьКонтейнерДереваТестовПоСпискуТестовНаСервере(СписокТестов, ПрефиксПутейСФормами() + СтрЗаменить(ЗагружаемыйПуть, "Обработка.", ""), ПрефиксПутейСФормами() + ЗагружаемыйПуть, СлучайныйПорядокВыполнения);
	Контейнер.ИконкаУзла = ПостроительДереваТестов.Объект.ИконкиУзловДереваТестов.Форма;
	
	Возврат Контейнер;
КонецФункции

&НаСервере
Функция ПолучитьИдентификаторКонтекстаПоПутиНаСервере(Путь)
	ОбъектМетаданных = ЭтотОбъектНаСервере().ПолучитьОбъектМетаданныхПоПути(Путь);
	
	Возврат ОбъектМетаданных.Имя;
КонецФункции

&НаСервере
Функция ПолучитьКонтейнерДереваТестовПоСпискуТестовНаСервере(СписокТестов, ИмяКонтейнера, Путь, СлучайныйПорядокВыполнения = Истина)
	КонтекстЯдра = ПолучитьКонтекстЯдраНаСервере();
	
	ПостроительДереваТестов = КонтекстЯдра.СоздатьОбъектПлагина("ПостроительДереваТестов");
	ЗагрузчикФайла = КонтекстЯдра.СоздатьОбъектПлагина("ЗагрузчикФайла");

	Контейнер = ЭтотОбъектНаСервере().ПолучитьКонтейнерДереваТестовПоСпискуТестов(ПостроительДереваТестов, ЗагрузчикФайла, СписокТестов, ИмяКонтейнера, Путь, СлучайныйПорядокВыполнения);
	
	Возврат Контейнер;
КонецФункции

&НаКлиенте
Функция ЭтоПутьККлиентскомуКонтексту(Путь)
	ПрефиксПутейСФормами = ПрефиксПутейСФормами();
	Результат = (Найти(Путь, ПрефиксПутейСФормами) = 1);
	
	Возврат Результат;
КонецФункции

&НаКлиенте
Функция ПрефиксПутейСФормами()
	Возврат "УпрФорма # ";
КонецФункции

// { API нового формата
&НаКлиенте
Процедура СлучайныйПорядокВыполнения() Экспорт
	Если ЗначениеЗаполнено(КонтейнерТестов) Тогда
		КонтейнерТестов.СлучайныйПорядокВыполнения = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СтрогийПорядокВыполнения() Экспорт
	Если ЗначениеЗаполнено(КонтейнерТестов) Тогда
		КонтейнерТестов.СлучайныйПорядокВыполнения = Ложь;

		ОстановитьВыполнениеПослеПаденияТестов();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьВыполнениеПослеПаденияТеста() Экспорт
	Если ЗначениеЗаполнено(КонтейнерТестов) Тогда
		КонтейнерТестов.ПродолжитьВыполнениеПослеПаденияТеста = Истина;
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ОстановитьВыполнениеПослеПаденияТестов() Экспорт
	Если ЗначениеЗаполнено(КонтейнерТестов) Тогда
		КонтейнерТестов.ПродолжитьВыполнениеПослеПаденияТеста = Ложь;
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура НачатьГруппу(Знач ИмяГруппы, Знач СтрогийПорядокВыполнения = Ложь) Экспорт
	ТекущаяГруппа = ПостроительДереваТестов.СоздатьКонтейнер(ИмяГруппы, ПостроительДереваТестов.Объект.ИконкиУзловДереваТестов.Группа);
	ТекущаяГруппа.Путь = ПрефиксПутейСФормами() + ЗагружаемыйПуть;
	ТекущаяГруппа.СлучайныйПорядокВыполнения = Не СтрогийПорядокВыполнения;
	КонтейнерТестов.Строки.Добавить(ТекущаяГруппа);
КонецПроцедуры

&НаКлиенте
Функция Добавить(Знач ИмяМетода, Знач Параметры = Неопределено, Знач Представление = "") Экспорт
	Если Не ЗначениеЗаполнено(Параметры) ИЛИ ТипЗнч(Параметры) <> Тип("Массив") Тогда
		Если ТипЗнч(Параметры) = Тип("Строка") И Представление = "" Тогда
			Представление = Параметры;
		КонецЕсли;
		Параметры = Неопределено;
	КонецЕсли;
	Элемент = ПостроительДереваТестов.СоздатьЭлемент(ПрефиксПутейСФормами() + ЗагружаемыйПуть, ИмяМетода, Представление);
	Если Параметры <> Неопределено Тогда
		Элемент.Параметры = Параметры;
	КонецЕсли;
	Если ЗначениеЗаполнено(ТекущаяГруппа) Тогда
		ТекущаяГруппа.Строки.Добавить(Элемент);
	Иначе
		КонтейнерТестов.Строки.Добавить(Элемент);
	КонецЕсли;
	
	Возврат Элемент;
КонецФункции

&НаКлиенте
Функция ДобавитьДеструктор(Знач ИмяМетодаДеструктора, Знач Представление = "") Экспорт
	ЭлементДеструктор = Добавить(ИмяМетодаДеструктора, Неопределено, Представление);
	Если ЗначениеЗаполнено(ТекущаяГруппа) Тогда
		ТекущаяГруппа.ЭлементДеструктор = ЭлементДеструктор;
	Иначе
		КонтейнерТестов.ЭлементДеструктор = ЭлементДеструктор;
	КонецЕсли;
	Возврат ЭлементДеструктор;
КонецФункции

&НаКлиенте
Функция ПараметрыТеста(Знач Парам1, Знач Парам2 = Неопределено, Знач Парам3 = Неопределено, Знач Парам4 = Неопределено, Знач Парам5 = Неопределено, Знач Парам6 = Неопределено, Знач Парам7 = Неопределено, Знач Парам8 = Неопределено, Знач Парам9 = Неопределено) Экспорт
	ВсеПараметры = Новый Массив;
	ВсеПараметры.Добавить(Парам1);
	ВсеПараметры.Добавить(Парам2);
	ВсеПараметры.Добавить(Парам3);
	ВсеПараметры.Добавить(Парам4);
	ВсеПараметры.Добавить(Парам5);
	ВсеПараметры.Добавить(Парам6);
	ВсеПараметры.Добавить(Парам7);
	ВсеПараметры.Добавить(Парам8);
	ВсеПараметры.Добавить(Парам9);
	
	ИндексСПоследнимПараметром = 0;
	Для Сч = 0 По ВсеПараметры.ВГраница() Цикл
		Индекс = ВсеПараметры.ВГраница() - Сч;
		Если ВсеПараметры[Индекс] <> Неопределено Тогда
			ИндексСПоследнимПараметром = Индекс;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	ПараметрыТеста = Новый Массив;
	Для Сч = 0 По ИндексСПоследнимПараметром Цикл
		ПараметрыТеста.Добавить(ВсеПараметры[Сч]);
	КонецЦикла;
	
	Возврат ПараметрыТеста;
КонецФункции

// Пропустить тест, при этом ядро не пытается найти и выполнять тест, а сразу помечает его неиспользованным
//	Такой подход значительно ускорит прогон тестов, о которых еще на этапе подготовки известно, что они должны быть пропущены.
//
// Параметры:
//  Представление	 - Строка	 - Представление теста
// 
// Возвращаемое значение:
//   Произвольный - созданный элемент. См. Добавить
//
&НаКлиенте
Функция ПропуститьТест(Знач Представление) Экспорт

	Элемент = Добавить(Представление, Неопределено, Представление);
	Элемент.ПропуститьТест = Истина;
	
	Возврат Элемент;

КонецФункции

// } API нового формата

// { Helpers
&НаСервере
Функция ЭтотОбъектНаСервере()
	Возврат РеквизитФормыВЗначение("Объект");
КонецФункции

&НаКлиенте
Функция ЕстьОшибка_МетодОбъектаНеОбнаружен(Знач ТекстОшибки, Знач ИмяМетода)
	Результат = Ложь;
	Если Найти(текстОшибки, "Метод объекта не обнаружен (" + ИмяМетода + ")") > 0 
		Или Найти(текстОшибки, "Object method not found (" + ИмяМетода + ")") > 0  Тогда
		Результат = Истина;
	КонецЕсли;
	
	Возврат Результат;
КонецФункции
// } Helpers

// { Подсистема конфигурации xUnitFor1C

&НаСервере
Функция ПолучитьКонтекстЯдраНаСервере()
	
	// Получаем доступ к серверному контексту обработки с использованием 
	// полного имени метаданных браузера тестов. Иначе нет возможности получить
	// доступ к серверному контексту ядра, т.к. изначально вызов был выполнен на клиенте.
	// При передаче на сервер клиентский контекст теряется.
	КонтекстЯдра = Неопределено;
	МетаданныеЯдра = Метаданные.НайтиПоПолномуИмени(ПолноеИмяБраузераТестов);
	Если НЕ МетаданныеЯдра = Неопределено
		И Метаданные.Обработки.Содержит(МетаданныеЯдра) Тогда
		ИмяОбработкиКонекстаЯдра = СтрЗаменить(ПолноеИмяБраузераТестов, "Обработка", "Обработки");
		Выполнить("КонтекстЯдра = " + ИмяОбработкиКонекстаЯдра + ".Создать()");	
	Иначе
		ИмяОбработкиКонекстаЯдра = СтрЗаменить(ПолноеИмяБраузераТестов, "ВнешняяОбработка", "ВнешниеОбработки");
		ИмяОбработкиКонекстаЯдра = СтрЗаменить(ИмяОбработкиКонекстаЯдра, ".", Символы.ПС);
		МенеджерОбъектов = СтрПолучитьСтроку(ИмяОбработкиКонекстаЯдра, 1);
		ИмяОбъекта = СтрПолучитьСтроку(ИмяОбработкиКонекстаЯдра, 2);
		Выполнить("КонтекстЯдра = " + МенеджерОбъектов + ".Создать("""+ИмяОбъекта+""")");	
	КонецЕсли;
		
	Возврат КонтекстЯдра;
	
КонецФункции

// } Подсистема конфигурации xUnitFor1C

// { Вспомогательные методы

&НаКлиенте
Функция ВыбратьПутьИнтерактивноРаботаСОкном(КонтекстЯдра) Экспорт 
	
	ПараметрыОткрытия = Новый Структура("ОтборПоИмениТеста", "");
	ИмяФормыВыбораПодсистемыУФ = СтрЗаменить(ЭтаФорма.ИмяФормы, "УправляемаяФорма", "ФормаВыбораПодсистемУФ");

	ОткрытьФорму(ИмяФормыВыбораПодсистемыУФ, 
		ПараметрыОткрытия, ЭтаФорма,,,, 
		Новый ОписаниеОповещения("ВыбратьПутьИнтерактивноРаботаСОкномЗавершение", ЭтаФорма, КонтекстЯдра), 
		РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
	Возврат "";
КонецФункции

&НаКлиенте
Процедура ВыбратьПутьИнтерактивноРаботаСОкномЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	КонтекстЯдра = ДополнительныеПараметры;
	Описание = ОписаниеПлагина(КонтекстЯдра, КонтекстЯдра.Объект.ТипыПлагинов);
	КонтекстЯдра.ЗагрузитьТесты(Описание.Идентификатор, Результат);
	
КонецПроцедуры

// } Вспомогательные методы