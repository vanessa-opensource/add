﻿&НаКлиенте
Перем КонтекстЯдра;
&НаКлиенте
Перем СтроковыеУтилиты;
&НаКлиенте
Перем УправлениеПриложениями;


// { Plugin interface

&НаКлиенте
Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
	
	КонтекстЯдра = КонтекстЯдраПараметр;
	СтроковыеУтилиты    	= КонтекстЯдра.Плагин("СтроковыеУтилиты");
	УправлениеПриложениями	= КонтекстЯдра.Плагин("УправлениеПриложениями");
	
	// Инициализация параметров
	
КонецПроцедуры

&НаКлиенте
Функция ОписаниеПлагина(ВозможныеТипыПлагинов) Экспорт
	Возврат ОписаниеПлагинаНаСервере(ВозможныеТипыПлагинов);
КонецФункции

&НаСервере
Функция ОписаниеПлагинаНаСервере(ВозможныеТипыПлагинов)
	Возврат ЭтотОбъектНаСервере().ОписаниеПлагина(ВозможныеТипыПлагинов);
КонецФункции

// } Plugin interface

&НаКлиенте
Процедура ПустоеОповещение(ДополнительныеПараметры = Неопределено) Экспорт
	
КонецПроцедуры

&НаКлиенте
// Считывает переменные окружения в соответствие
//
// Параметры:
//
// Возвращаемое значение:
//   Соответствие   - все переменные окружения
//
Функция ВсеПеременныеОкружения() Экспорт

	ПеременныеОкружения = Новый Соответствие;
	
	ФайлСПеременными = СчитатьПеременныеОкруженияВФайл();
	
	Текст = Новый ЧтениеТекста;
	Текст.Открыть(ФайлСПеременными);
	Стр = Текст.ПрочитатьСтроку();

	Пока Стр <> Неопределено Цикл
		
		СоставСтроки = СтроковыеУтилиты.РазложитьСтрокуВМассивПодстрок(Стр, "=");
		
		ИмяНайденнойПеременной      = ВРег(СоставСтроки[0]);
		Если СоставСтроки.Количество() = 2 Тогда

			ЗначениеПеременнойОкружения = СоставСтроки[1];

		Иначе

			ЗначениеПеременнойОкружения = "";

		КонецЕсли;

		ПеременныеОкружения.Вставить(ИмяНайденнойПеременной
										, ЗначениеПеременнойОкружения);
										
		Стр = Текст.ПрочитатьСтроку();
		
	КонецЦикла;

	Текст.Закрыть();
	
	Описание = КонтекстЯдра.АСинк().смв_НовыйОписаниеОповещения("ПустоеОповещение", ЭтаФорма);
	
	КонтекстЯдра.АСинк().смв_УдалитьФайлы(Описание, ФайлСПеременными);	
	
	Возврат ПеременныеОкружения;

КонецФункции // ПолучитьПеременныеОкружения()

&НаКлиенте
// Считывает переменные окружения в соответствие
//
// Параметры:
//	ИмяПеременной		- Строка - имя переменной, значение которой надо получить
//	ЗначениеПоУмолчанию - Строка - значение, которое вернуть если переменная не определена
//
// Возвращаемое значение:
//   Соответствие   - все переменные окружения
//
Функция ЗначениеПеременнойОкружения(ИмяПеременной
									, ЗначениеПоУмолчанию = Неопределено) Экспорт

	Результат = ВсеПеременныеОкружения()[ВРег(ИмяПеременной)];
	Если Результат = Неопределено Тогда
		
		Результат = ЗначениеПоУмолчанию;
		
	КонецЕсли;
	
	Возврат Результат;

КонецФункции // ПолучитьЗначениеПеременнойОкружения()

&НаКлиенте
// Устанавливает значение переменной
//
// Параметры:
//  ИмяПеременной	- Строка - имя переменной для установки
//  Значение		- Строка - устанавливаемое значение
//
Процедура УстановитьЗначениеПеременнойОкружения(ИмяПеременной, Значение) Экспорт

	Если КонтекстЯдра.ЭтоLinux Тогда
		
		ТекстКоманды = "export " + ИмяПеременной + "=" + Строка(Значение);
		
	Иначе
		
		ТекстКоманды = "setx /M " + ИмяПеременной + " """ + Строка(Значение) + """";
		
	КонецЕсли;
	
	УправлениеПриложениями.ВыполнитьКомандуОСБезПоказаЧерногоОкна(ТекстКоманды);

КонецПроцедуры // УстановитьЗначениеПеременнойОкружения()


&НаКлиенте
Функция СчитатьПеременныеОкруженияВФайл()
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла();
	
	Если КонтекстЯдра.ЭтоLinux Тогда
		
		ТекстКоманды = "sh -c 'env = > " + ИмяВременногоФайла + "'";
		
	Иначе
		
		ТекстКоманды = "SET > """ + ИмяВременногоФайла + """";
		
	КонецЕсли;
	
	УправлениеПриложениями.ВыполнитьКомандуОСБезПоказаЧерногоОкна(ТекстКоманды);

	Возврат ИмяВременногоФайла;
		
КонецФункции

// { Helpers
&НаСервере
Функция ЭтотОбъектНаСервере()
	Возврат РеквизитФормыВЗначение("Объект");
КонецФункции

&НаКлиенте
Процедура Отладка(ТекстСообщения)
	
	КонтекстЯдра.Отладка(ТекстСообщения);
	
КонецПроцедуры

&НаКлиенте
Процедура Лог(ТекстСообщения, Важное = Ложь)
	
	Если Важное Тогда
		
		КонтекстЯдра.ВывестиСообщение(ТекстСообщения, СтатусСообщения.Важное);
		
	Иначе
		
		КонтекстЯдра.ВывестиСообщение(ТекстСообщения);
		
	КонецЕсли;		
	
КонецПроцедуры
// } Helpers
