﻿Перем Регулярка;
Перем ЭтоLinux;

// { Plugin interface
Функция ОписаниеПлагина(ВозможныеТипыПлагинов) Экспорт
	Результат = Новый Структура;
	Результат.Вставить("Тип", ВозможныеТипыПлагинов.Утилита);
	Результат.Вставить("Идентификатор", Метаданные().Имя);
	Результат.Вставить("Представление", "УтвержденияПроверкаТаблиц");
	
	Возврат Новый ФиксированнаяСтруктура(Результат);
КонецФункции

Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
КонецПроцедуры
// } Plugin interface

Процедура ПроверитьРавенствоТаблиц(Таб1, Таб2, ДопСообщениеОшибки = "", ДопПараметры = Неопределено) Экспорт
	
	Если ТипЗнч(Таб1) <> Тип("ТаблицаЗначений") Тогда
		ВызватьИсключение "ПроверитьРавенствоТаблиц: Первый параметр-таблица таблицей не является";
	КонецЕсли;
	Если ТипЗнч(Таб2) <> Тип("ТаблицаЗначений") Тогда
		ВызватьИсключение "ПроверитьРавенствоТаблиц: Второй параметр-таблица таблицей не является";
	КонецЕсли;
	
	Различия = Новый ТаблицаЗначений;
	РезультатСравнения = СравнитьТаблицы(Таб1, Таб2, Различия, ДопСообщениеОшибки, ДопПараметры);
	
	Если РезультатыСравненияТаблиц.ТаблицыСовпадают <> РезультатСравнения Тогда
		
		ИменаРезультатов = Новый Соответствие;
		Для Каждого КлючЗначение Из РезультатыСравненияТаблиц Цикл
			ИменаРезультатов.Вставить(КлючЗначение.Значение, КлючЗначение.Ключ);
		КонецЦикла; 
		СтрокаОшибок = "Различия в таблицах:" + Символы.ПС;
		СтрокаОшибок = СтрокаОшибок + "Ожидали статус <" + ИменаРезультатов[РезультатыСравненияТаблиц.ТаблицыСовпадают] + ">, а получили <" + ИменаРезультатов[РезультатСравнения] + ">" + Символы.ПС;
		Для Каждого Строка Из Различия Цикл
			СтрокаОшибок = СтрокаОшибок + "Значение [" + Строка.Колонка + ":" + Строка.Строка + "]. Ожидали <" + Строка.Ожидание + ">, а получили <" + Строка.Результат + ">" + Символы.ПС;
		КонецЦикла;
		
		ВызватьОшибкуПроверки("Таблицы должны совпадать, а они различны" + Символы.ПС + СтрокаОшибок + Символы.ПС + ДопСообщениеОшибки);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьРавенствоТабличныхДокументовТолькоПоЗначениям(ТабДок1, ТабДок2, 
	УчитыватьТолькоВидимыеКолонкиИлиДопСообщениеОшибки = Ложь, УчитыватьТолькоВидимыеСтрокиИлиДопСообщениеОшибки = Ложь,
	Знач ДопСообщениеОшибки = "", Знач ДопПараметры = Неопределено) Экспорт
	
	Если ТипЗнч(ТабДок1) <> Тип("ТабличныйДокумент") Тогда
		ВызватьИсключение "ПроверитьРавенствоТабличныхДокументовТолькоПоЗначениям: Первый параметр-таблица не является табличным документов";
	КонецЕсли;
	Если ТипЗнч(ТабДок2) <> Тип("ТабличныйДокумент") Тогда
		ВызватьИсключение "ПроверитьРавенствоТабличныхДокументовТолькоПоЗначениям: Второй параметр-таблица не является табличным документов";
	КонецЕсли;
	
	УчитыватьТолькоВидимыеКолонки = Ложь;
	Если ТипЗнч(УчитыватьТолькоВидимыеКолонкиИлиДопСообщениеОшибки) = Тип("Булево") Тогда
		УчитыватьТолькоВидимыеКолонки = УчитыватьТолькоВидимыеКолонкиИлиДопСообщениеОшибки;
	ИначеЕсли ТипЗнч(УчитыватьТолькоВидимыеКолонкиИлиДопСообщениеОшибки) = Тип("Строка") Тогда
		ДопСообщениеОшибки = УчитыватьТолькоВидимыеКолонкиИлиДопСообщениеОшибки;
	КонецЕсли;
	УчитыватьТолькоВидимыеСтроки = Ложь;
	Если ТипЗнч(УчитыватьТолькоВидимыеСтрокиИлиДопСообщениеОшибки) = Тип("Булево") Тогда
		УчитыватьТолькоВидимыеСтроки = УчитыватьТолькоВидимыеСтрокиИлиДопСообщениеОшибки;
	ИначеЕсли ТипЗнч(УчитыватьТолькоВидимыеСтрокиИлиДопСообщениеОшибки) = Тип("Строка") Тогда
		ДопСообщениеОшибки = УчитыватьТолькоВидимыеСтрокиИлиДопСообщениеОшибки;
	КонецЕсли;
	
	Таб1 = ПолучитьТаблицуЗначенийИзТабличногоДокумента(ТабДок1, УчитыватьТолькоВидимыеКолонки, УчитыватьТолькоВидимыеСтроки);
	Таб2 = ПолучитьТаблицуЗначенийИзТабличногоДокумента(ТабДок2, УчитыватьТолькоВидимыеКолонки, УчитыватьТолькоВидимыеСтроки);
	
	ПроверитьРавенствоТаблиц(Таб1, Таб2, ДопСообщениеОшибки, ДопПараметры);
	
КонецПроцедуры

// портирован из Functest
Функция ПолучитьТаблицуЗначенийИзТабличногоДокумента(ТабличныйДокумент, УчитыватьТолькоВидимыеКолонки = Ложь, УчитыватьТолькоВидимыеСтроки = Ложь) Экспорт
	
	ТипТабличногоДокумента = ТипЗнч(ТабличныйДокумент);
	Если ТипТабличногоДокумента <> Тип("ТабличныйДокумент") И ТипТабличногоДокумента <> Тип("ПолеТабличногоДокумента") Тогда
		ВызватьИсключение "ПолучитьТаблицуЗначенийИзТабличногоДокумента: Требуется тип ТабличныйДокумент или ПолеТабличногоДокумента";
	КонецЕсли;
	
	НомерПоследнейКолонки = ТабличныйДокумент.ШиринаТаблицы;
	НомерПоследнейСтроки = ТабличныйДокумент.ВысотаТаблицы;
	
	НоваяТаблицаЗначений = Новый ТаблицаЗначений;
	Колонки = НоваяТаблицаЗначений.Колонки;
	ТипСтрока = Новый ОписаниеТипов("Строка");
	
	// TODO При определении видимости не учитывается наличие нескольких форматов строк, сейчас видимоcть колонки определяется по формату первой строки
	УчитываемыеКолонки = Новый Массив;
	Для НомерКолонки = 1 По НомерПоследнейКолонки Цикл
		ОбластьКолонки = ТабличныйДокумент.Область(0, НомерКолонки, 1, НомерКолонки);
		
		УчитыватьКолонку = Не УчитыватьТолькоВидимыеКолонки Или ОбластьКолонки.Видимость;
		Если УчитыватьКолонку Тогда
			УчитываемыеКолонки.Добавить(НомерКолонки);
			ШиринаКолонки = ОбластьКолонки.ШиринаКолонки;
			Если ШиринаКолонки <= 1 Тогда
				ШиринаКолонки = 1;
			КонецЕсли;
			ИмяКолонки = "К" + Формат(Колонки.Количество() + 1, "ЧН=; ЧГ=0");
			Колонки.Добавить(ИмяКолонки, ТипСтрока, ИмяКолонки, ШиринаКолонки);
		КонецЕсли;
	КонецЦикла;
	
	ГраницаКолонок = УчитываемыеКолонки.ВГраница();
	Для НомерСтроки = 1 По НомерПоследнейСтроки Цикл
		
		Если УчитыватьТолькоВидимыеСтроки И Не ТабличныйДокумент.Область(НомерСтроки,, НомерСтроки).Видимость Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = НоваяТаблицаЗначений.Добавить();
		
		Для Индекс = 0 По ГраницаКолонок Цикл
			НомерКолонки = УчитываемыеКолонки[Индекс];
			Область = ТабличныйДокумент.Область(НомерСтроки, НомерКолонки, НомерСтроки, НомерКолонки);
			НоваяСтрока[Индекс] = Область.Текст;
		КонецЦикла;
	КонецЦикла;
	
	Возврат НоваяТаблицаЗначений;
	
КонецФункции

// портирован из Functest
Функция СравнитьТаблицы(ТаблицаОжиданий, ТаблицаРезультатов, ТаблицаРазличий, ДопСообщениеОшибки = "", ДопПараметры = Неопределено)
	
	Перем Итог;
	
	Если ДопПараметры = Неопределено ИЛИ ТипЗнч(ДопПараметры) <> Тип("Структура") Тогда
		ДопПараметры = Новый Структура;
	КонецЕсли;
	//Если ТаблицаОжиданий.Количество() <> ТаблицаРезультатов.Количество() Тогда
	//	Возврат РезультатыСравненияТаблиц.РазноеКоличествоСтрок;
	//КонецЕсли;
	
	Если ТаблицаОжиданий.Количество() = 0 И ТаблицаРезультатов.Количество() = 0  Тогда
		Возврат РезультатыСравненияТаблиц.ТаблицыСовпадают; //Пустые таблицы всегда одинаковы
	КонецЕсли;
	
	//Проверим структуру колонок
	
	//TODO При этом сравнении в структуре ТаблицаРезультатов может оказаться больше колонок, чем в ТаблицаОжиданий,
	// так что для абсолютного точного сравнения нужно добавить проверку совпадения количества колонок.
	ОжидаемыеКолонки = ТаблицаОжиданий.Колонки;
	КолонкиРезультата = ТаблицаРезультатов.Колонки;
	Для Каждого Колонка Из ОжидаемыеКолонки Цикл
		Если КолонкиРезультата.Найти(Колонка.Имя) = Неопределено Тогда
			ДопСообщениеОшибки = "КолонкиЭталона.Количество()=" + ОжидаемыеКолонки.Количество() + ", КолонкиРезультата.Количество()=" + КолонкиРезультата.Количество();
			Возврат РезультатыСравненияТаблиц.РазличаютсяКолонки;
		КонецЕсли;
	КонецЦикла;
	
	Если ДопПараметры.Свойство("НечеткоеСравнение") Тогда
		Итог = СравнитьТаблицыБезУчетаПоследовательностиСтрок(ТаблицаОжиданий, ТаблицаРезультатов, ТаблицаРазличий, ДопПараметры);
	Иначе
		Итог = СравнитьЗначенияТаблиц(ТаблицаОжиданий, ТаблицаРезультатов, ТаблицаРазличий, ДопПараметры);
	КонецЕсли; 
	Возврат Итог;
	
КонецФункции

//+++ ЯрВет ПоповВ 30.05.2019
Функция СравнитьТаблицыБезУчетаПоследовательностиСтрок(ТаблицаОжиданий, ТаблицаРезультатов, Различия, ДопПараметры)

	РезультатСравнения = РезультатыСравненияТаблиц.ТаблицыСовпадают;
	
	Различия = Новый ТаблицаЗначений;
	Различия.Колонки.Очистить();
	Различия.Колонки.Добавить("Строка",Новый ОписаниеТипов("Число"));
	Различия.Колонки.Добавить("Колонка",Новый ОписаниеТипов("Строка"));
	Различия.Колонки.Добавить("Ожидание");
	Различия.Колонки.Добавить("Результат");
	
	ТаблицаОжиданийСлужебная = ТаблицаОжиданий.Скопировать();	
	ТаблицаОжиданийСлужебная.Колонки.Добавить("Обработано", Новый ОписаниеТипов("Булево"));
	ТаблицаРезультатовСлужебная = ТаблицаРезультатов.Скопировать();
	ТаблицаРезультатовСлужебная.Колонки.Добавить("Обработано", Новый ОписаниеТипов("Булево"));
	
	ПараметрыПоиска = ПараметрыПоискаВТаблицы(ТаблицаОжиданийСлужебная);
	ПараметрыПоиска.Удалить("Обработано");
	Индекс = 0;
	Для каждого СтрокаОжиданий Из ТаблицаОжиданийСлужебная Цикл
		
		Если СтрокаОжиданий.Обработано Тогда
			Продолжить;
		КонецЕсли; 
		ЗаполнитьЗначенияСвойств(ПараметрыПоиска, СтрокаОжиданий);	
		
		СтрокиОжиданий = ТаблицаОжиданийСлужебная.НайтиСтроки(ПараметрыПоиска);
		СтрокиРезультата = ТаблицаРезультатовСлужебная.НайтиСтроки(ПараметрыПоиска);
		Если СтрокиОжиданий.Количество() <> СтрокиРезультата.Количество() Тогда
			
			Различие = Различия.Добавить();
			Различие.Строка = ТаблицаРезультатовСлужебная.Индекс(СтрокаОжиданий)+1;
			Различие.Колонка = "";
			Различие.Ожидание = "Количество строк = "+СтрокиОжиданий.Количество();
			Различие.Результат = "Количество строк = "+СтрокиРезультата.Количество() + " для строки:"
				+ Символы.ПС + Символы.Таб
				+ ПредставлениеСтроки(СтрокаОжиданий, ПараметрыПоиска);
			РезультатСравнения = РезультатыСравненияТаблиц.НеСовпадаютЗначенияВЯчейкеТаблицы;
			
		КонецЕсли; 
		
		УстановитьФлагОбработано(СтрокиОжиданий);
		УстановитьФлагОбработано(СтрокиРезультата);
		
	КонецЦикла; 
	
	НенайденныеСтрокиВРезультате = ТаблицаРезультатовСлужебная.НайтиСтроки(Новый Структура("Обработано", Ложь));
	Для каждого НеобработаннаяСтрока Из НенайденныеСтрокиВРезультате Цикл
				
		Различие = Различия.Добавить();
		Различие.Строка = ТаблицаРезультатовСлужебная.Индекс(НеобработаннаяСтрока)+1;
		Различие.Колонка = "";
		Различие.Ожидание = "Есть в таблице эталоне";
		Различие.Результат = "Нет в таблице эталоне для строки: "
				+ Символы.ПС + Символы.Таб
				+ ПредставлениеСтроки(НеобработаннаяСтрока, ПараметрыПоиска);
		РезультатСравнения = РезультатыСравненияТаблиц.НеСовпадаютЗначенияВЯчейкеТаблицы;	
				
	КонецЦикла; 
	
	Возврат РезультатСравнения;

КонецФункции

Процедура УстановитьФлагОбработано(НаборСрок)

	Для каждого СтрокаНабора Из НаборСрок Цикл
		СтрокаНабора.Обработано = Истина;	
	КонецЦикла; 	

КонецПроцедуры

Функция ПредставлениеСтроки(СтрокаТаблицы, ПараметрыСравнения)

	Представление = Новый Массив;
	Для каждого КлючЗначение Из ПараметрыСравнения Цикл
	
		Представление.Добавить(КлючЗначение.Ключ+" = "+СтрокаТаблицы[КлючЗначение.Ключ]);
		
	КонецЦикла; 
	Возврат СтрСоединить(Представление, Символы.ПС+Символы.Таб);

КонецФункции 

Функция ПараметрыПоискаВТаблицы(Таблица)

	ПараметрыПоиска = Новый Структура;
	Для каждого Колонка Из Таблица.Колонки Цикл
		ПараметрыПоиска.Вставить(Колонка.Имя);
	КонецЦикла;
	
	Возврат ПараметрыПоиска;

КонецФункции 

Процедура ВТаблицеЕстьСтрока(Таблица, ПредставлениеСтроки) Экспорт

	Строки = Таблица.НайтиСтроки(ПредставлениеСтроки);
	Если Строки.Количество() = 0 Тогда
		ПредставлениеКлючаПоиска = "";
		Для каждого КлючЗначение Из ПредставлениеСтроки Цикл
			ПредставлениеКлючаПоиска = ПредставлениеКлючаПоиска + КлючЗначение.Ключ+":"+КлючЗначение.Значение+","
		КонецЦикла; 
		ПредставлениеКлючаПоиска = Лев(ПредставлениеКлючаПоиска, СтрДлина(ПредставлениеКлючаПоиска)-1);
		ВызватьОшибкуПроверки("Не найдена строка по ключу поиска: "+ПредставлениеКлючаПоиска);
	КонецЕсли; 

КонецПроцедуры
//--- ЯрВет ПоповВ КОНЕЦ  21.12.2018

Функция ПодготовитьШаблонКИспользованиюВРегулярке(Шаблон)

	// Экранируем все, кроме звездочки. Ее будем трактовать по-своему.
	СпецСимволы = Новый Массив;
	СпецСимволы.Добавить("\");
	СпецСимволы.Добавить("^");
	СпецСимволы.Добавить("$");
	СпецСимволы.Добавить("(");
	СпецСимволы.Добавить(")");
	СпецСимволы.Добавить("<");
	СпецСимволы.Добавить("[");
	СпецСимволы.Добавить("]");
	СпецСимволы.Добавить("{");
	СпецСимволы.Добавить("}");
	СпецСимволы.Добавить("|");
	СпецСимволы.Добавить(">");
	СпецСимволы.Добавить(".");
	СпецСимволы.Добавить("+");
	СпецСимволы.Добавить("?");
	
	Для Каждого СпецСимвол Из СпецСимволы Цикл
		Шаблон = СтрЗаменить(Шаблон, СпецСимвол, "\" + СпецСимвол); 
	КонецЦикла;
	
	// Трактуем * по-нашему.
	Шаблон = СтрЗаменить(Шаблон, "*", ".+");
	
	Возврат Шаблон;

КонецФункции 

//взято из https://infostart.ru/public/464971/
Функция ПроверитьСтрокуRexExpLinux(Строка, Фасет)
    Чтение = Новый ЧтениеXML;
    Чтение.УстановитьСтроку(
                "<Model xmlns=""http://v8.1c.ru/8.1/xdto"" xmlns:xs=""http://www.w3.org/2001/XMLSchema"" xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"" xsi:type=""Model"">
                |<package targetNamespace=""sample-my-package"">
                |<valueType name=""testtypes"" base=""xs:string"">
                |<pattern>" + Фасет + "</pattern>
                |</valueType>
                |<objectType name=""TestObj"">
                |<property xmlns:d4p1=""sample-my-package"" name=""TestItem"" type=""d4p1:testtypes""/>
                |</objectType>
                |</package>
                |</Model>");

    Модель = ФабрикаXDTO.ПрочитатьXML(Чтение);
    МояФабрикаXDTO = Новый ФабрикаXDTO(Модель);
    Пакет = МояФабрикаXDTO.Пакеты.Получить("sample-my-package");
    Тест = МояФабрикаXDTO.Создать(Пакет.Получить("TestObj"));

    Попытка
        Тест.TestItem = Строка;
        Возврат Истина
    Исключение
        Возврат Ложь
    КонецПопытки;
КонецФункции

//позволяет сделать поиск в строке "ПроверяемаяСтрока" подстроки "Шаблон"
//при этом подстрока "Шаблон" может содержать символы *
//например СтрокаСоответствуетШаблону("Привет","*вет")
Функция СтрокаСоответствуетШаблону(ПроверяемаяСтрока, Знач Шаблон) Экспорт
	Шаблон = ПодготовитьШаблонКИспользованиюВРегулярке(Шаблон);
	ЭтоLinux = Истина;
	Если ЭтоLinux Тогда
		Возврат ПроверитьСтрокуRexExpLinux(ПроверяемаяСтрока,Шаблон);
	Иначе	
		Если Регулярка = Неопределено Тогда
			Регулярка = Новый COMОбъект("VBScript.RegExp");
		КонецЕсли;
		
		Регулярка.Global = Истина;
		//для VBScript.RegExp явно указываем что есть начало и конец строки
		Шаблон            = "^" + Шаблон + "$";
		Регулярка.Pattern = Шаблон;
		Возврат Регулярка.Test(ПроверяемаяСтрока);
	КонецЕсли;	 
КонецФункции 

// портирован из Functest
Функция СравнитьЗначенияТаблиц(ТаблицаОжиданий, ТаблицаРезультатов, Различия, ДопПараметры)
	Перем СравнениеПоШаблону;
	СравнениеПоШаблону = Ложь;
	Если ДопПараметры <> Неопределено Тогда
		Если ДопПараметры.Свойство("СравнениеПоШаблону") Тогда
			СравнениеПоШаблону = ДопПараметры.СравнениеПоШаблону;
		КонецЕсли;
	КонецЕсли;
	
	

	Различия = Новый ТаблицаЗначений;
	Различия.Колонки.Очистить();
	Различия.Колонки.Добавить("Строка",Новый ОписаниеТипов("Число"));
	Различия.Колонки.Добавить("Колонка",Новый ОписаниеТипов("Строка"));
	Различия.Колонки.Добавить("Ожидание");
	Различия.Колонки.Добавить("Результат");
	
	РезультатСравнения = РезультатыСравненияТаблиц.ТаблицыСовпадают;
	
	Колонки = ТаблицаОжиданий.Колонки;
	ГраницаСтрокОжиданий = ТаблицаОжиданий.Количество() - 1;
	ГраницаСтрокРезультата = ТаблицаРезультатов.Количество() - 1;
	ГраницаСтрок = Макс(ГраницаСтрокОжиданий, ГраницаСтрокРезультата);
	Для Индекс = 0 По ГраницаСтрок Цикл
		
		ОжидаемаяСтрока = ?(Индекс <= ГраницаСтрокОжиданий, ТаблицаОжиданий[Индекс], ТаблицаОжиданий.Добавить());
		СтрокаРезультата = ?(Индекс <= ГраницаСтрокРезультата, ТаблицаРезультатов[Индекс], ТаблицаРезультатов.Добавить());
		
		Для Каждого Колонка Из Колонки Цикл
			ИмяКолонки = Колонка.Имя;
			
			ОжидаемоеЗначение = ОжидаемаяСтрока[ИмяКолонки];
			ЗначениеРезультата = СтрокаРезультата[ИмяКолонки];
			
			Если ОжидаемоеЗначение = "*" Тогда
				Продолжить;
			КонецЕсли;

			ОжидаемоеЗначение  = СтрЗаменить(ОжидаемоеЗначение,Символы.НПП," ");
			ЗначениеРезультата = СтрЗаменить(ЗначениеРезультата,Символы.НПП," ");
			
			Если НЕ СравнениеПоШаблону Тогда
				Если ОжидаемоеЗначение = ЗначениеРезультата
					Или (Не ЗначениеЗаполнено(ОжидаемоеЗначение) И Не ЗначениеЗаполнено(ЗначениеРезультата)) Тогда //Пустые значения разных типов 1С-м не считаются равными :(
					Продолжить;
				КонецЕсли;
			Иначе	
				Если СтрокаСоответствуетШаблону(ЗначениеРезультата,ОжидаемоеЗначение) Тогда
					Продолжить;
				КонецЕсли;	 
			КонецЕсли;	 
			
			Различие = Различия.Добавить();
			Различие.Строка = Индекс + 1;
			Различие.Колонка = ИмяКолонки;
			Различие.Ожидание = ОжидаемоеЗначение;
			Различие.Результат = ЗначениеРезультата;
			РезультатСравнения = РезультатыСравненияТаблиц.НеСовпадаютЗначенияВЯчейкеТаблицы;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат РезультатСравнения;
	
КонецФункции

Процедура ВызватьОшибкуПроверки(СообщениеОшибки = "")
	
	Префикс = "["+ СтатусыРезультатаТестирования().ОшибкаПроверки + "]";
	ВызватьИсключение Префикс + " " + СообщениеОшибки;
	
КонецПроцедуры

Функция СтатусыРезультатаТестирования()
	СтатусыРезультатаТестирования = Новый Структура;
	СтатусыРезультатаТестирования.Вставить("ОшибкаПроверки", "Failed");
	СтатусыРезультатаТестирования.Вставить("НеизвестнаяОшибка", "Broken");
	СтатусыРезультатаТестирования.Вставить("ТестПропущен", "Pending");
	
	Возврат Новый ФиксированнаяСтруктура(СтатусыРезультатаТестирования);
КонецФункции

РезультатыСравненияТаблиц = Новый Структура;
РезультатыСравненияТаблиц.Вставить("ТаблицыСовпадают", 0);
РезультатыСравненияТаблиц.Вставить("НеСовпадаютЗначенияВЯчейкеТаблицы", 1);
РезультатыСравненияТаблиц.Вставить("РазноеКоличествоСтрок", 2);
РезультатыСравненияТаблиц.Вставить("РазличаютсяКолонки", 3);
РезультатыСравненияТаблиц = Новый ФиксированнаяСтруктура(РезультатыСравненияТаблиц);
ЭтоLinux = Ложь;