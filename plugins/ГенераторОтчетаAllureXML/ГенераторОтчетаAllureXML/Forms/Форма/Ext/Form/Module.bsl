﻿&НаКлиенте
Перем КонтекстЯдра;

// { Plugin interface

&НаКлиенте
Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
	КонтекстЯдра = КонтекстЯдраПараметр;
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

// { Report generator interface
&НаКлиенте
Функция СоздатьОтчет(КонтекстЯдра, РезультатыТестирования) Экспорт
	Объект.ТипыУзловДереваТестов = КонтекстЯдра.Плагин("ПостроительДереваТестов").Объект.ТипыУзловДереваТестов;
	Объект.ИконкиУзловДереваТестов = КонтекстЯдра.Плагин("ПостроительДереваТестов").Объект.ИконкиУзловДереваТестов;
	Объект.СостоянияТестов = КонтекстЯдра.Объект.СостоянияТестов;
	Возврат СоздатьОтчетНаСервере(РезультатыТестирования);
КонецФункции

&НаСервере
Функция СоздатьОтчетНаСервере(РезультатыТестирования)
	Возврат ЭтотОбъектНаСервере().СоздатьОтчетНаСервере(РезультатыТестирования);
КонецФункции

&НаКлиенте
Процедура Показать(Отчет) Экспорт
	Отчет.Показать();
КонецПроцедуры

&НаКлиенте
Процедура Экспортировать(Отчет, ПутьКОтчету) Экспорт

	СтрокаXML = Отчет.ПолучитьТекст();
	
	ИмяФайла = ПутьКОтчету;
	
	ИмяФайла = ПолучитьУникальноеИмяФайла(ИмяФайла); 
	
	ПроверитьИмяФайлаРезультатаAllureСервер(ИмяФайла);
	
	// Запись файла с кодировкой "UTF-8", а не "UTF-8 with BOM"
	ЗаписьТекста = Новый ЗаписьТекста(ИмяФайла, КодировкаТекста.ANSI);
	ЗаписьТекста.Закрыть();
	
	ЗаписьТекста = Новый ЗаписьТекста(ИмяФайла,,, Истина);
	КоличествоСтрок = СтрЧислоСтрок(СтрокаXML);
	Для НомерСтроки = 1 По КоличествоСтрок Цикл
		Стр = СтрПолучитьСтроку(СтрокаXML, НомерСтроки);
		ЗаписьТекста.ЗаписатьСтроку(Стр);
	КонецЦикла;	
	ЗаписьТекста.Закрыть();

КонецПроцедуры
// } Report generator interface

&НаКлиенте
Процедура НачатьЭкспорт(ОбработкаОповещения, Отчет, ПолныйПутьФайла) Экспорт

	Экспортировать(Отчет, ПолныйПутьФайла);
	ВыполнитьОбработкуОповещения(ОбработкаОповещения);

КонецПроцедуры


// { Helpers

&НаКлиенте
// задаю уникальное имя для возможности получения одного отчета allure по разным тестовым наборам
Функция ПолучитьУникальноеИмяФайла(Знач ПутьКОтчету)
	Файл = Новый Файл(ПутьКОтчету);
	ГУИД = Новый УникальныйИдентификатор;
	ИмяФайла = СтрЗаменить("%1-%2-testsuite.xml", "%1", ГУИД);
	
	Если Файл.Существует() И Файл.ЭтоКаталог() Тогда
		
		ПутьКаталога = Файл.ПолноеИмя; 
		МаскаИмени	= "";
		
	Иначе
		
		ПутьКаталога = Файл.Путь; 
		МаскаИмени = Файл.ИмяБезРасширения;
		
	КонецЕсли;

	ИмяФайла = СтрЗаменить(ИмяФайла, "%2", МаскаИмени);
	КонечноеИмя = ПутьКаталога + "/" + ИмяФайла;
	
	Возврат КонечноеИмя;
КонецФункции

&НаСервере
Процедура ПроверитьИмяФайлаРезультатаAllureСервер(ИмяФайла) Экспорт
	
	Сообщение = "Уникальное имя файла " + ИмяФайла;
	ЗаписьЖурналаРегистрации("xUnitFor1C.ГенераторОтчетаAllureXML", УровеньЖурналаРегистрации.Информация, , , Сообщение);
	
	ЭтотОбъектНаСервере().ПроверитьИмяФайлаРезультатаAllure(ИмяФайла);
КонецПроцедуры

&НаСервере
Функция ЭтотОбъектНаСервере()
	Возврат РеквизитФормыВЗначение("Объект");
КонецФункции
// } Helpers

