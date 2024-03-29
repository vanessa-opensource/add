﻿Перем КонтекстЯдра;
Перем Ожидаем;

Перем ПарсерКоманднойСтроки;
Перем ИмяКаталогаВременныхФайлов;
Перем ФайлЛогаUI;
Перем ФайлСОтчетомОТестировании;
Перем ФайлСОтчетомОТестировании_Аллюр;
Перем ФайлКодаВозврата;

// Переменная с путем к обработке в файловой системы
// Используется в случаях, когда обработка запущена из встроенного в конфигурацию браузера тестов,
// т.к. в этом случае в свойстве ИспользуемоеИмяФайла содержится адрес временного хранилища, а не непосредственный путь
Перем ПутьКФайлуПолный Экспорт;

Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
	КонтекстЯдра = КонтекстЯдраПараметр;
	Ожидаем = КонтекстЯдра.Плагин("УтвержденияBDD");
	ПарсерКоманднойСтроки = КонтекстЯдра.Плагин("ПарсерКоманднойСтроки");
КонецПроцедуры

Функция ПолучитьСписокТестов() Экспорт
	ВсеТесты = Новый Массив;

	// Для встроенной в состав конфигурации подсистемы xUnitFor1C тесты еще не адаптированы
	Попытка // На случай, если контекст не определен на момент получения тестов
		Если КонтекстЯдра.ЭтоВстроеннаяОбработка Тогда
			Возврат ВсеТесты;
		КонецЕсли;
	Исключение
	КонецПопытки;

	// Позитивные
	ВсеТесты.Добавить("ТестДолжен_ПроверитьЗапускВПакетномРежиме_ТолстыйКлиент");
	ВсеТесты.Добавить("ТестДолжен_ПроверитьЗапускВПакетномРежиме_ТолстыйКлиент_ДваОтчетаТестирования");

	ВсеТесты.Добавить("ТестДолжен_ПроверитьЗапускВПакетномРежиме_ТонкийКлиент");
	ВсеТесты.Добавить("ТестДолжен_ПроверитьЗапускВПакетномРежиме_ТонкийКлиент_ДваОтчетаТестирования");

	// Негативные
	ВсеТесты.Добавить("ТестДолжен_ПроверитьЗапускВПакетномРежиме_ТолстыйКлиент_СПлохимиПараметрами_xddRun");
	ВсеТесты.Добавить("ТестДолжен_ПроверитьЗапускВПакетномРежиме_ТолстыйКлиент_СПлохимиПараметрами_xddReport");
	ВсеТесты.Добавить("ТестДолжен_ПроверитьЗапускВПакетномРежиме_ТонкийКлиент_СПлохимиПараметрами_xddRun");
	ВсеТесты.Добавить("ТестДолжен_ПроверитьЗапускВПакетномРежиме_ТонкийКлиент_СПлохимиПараметрами_xddReport");

	ВсеТесты.Добавить("ТестДолжен_ПроверитьЗапускТестаЧтенияКонфигурацииВПакетномРежиме_ТолстыйКлиент");
	ВсеТесты.Добавить("ТестДолжен_ПроверитьЗапускТестаЧтенияКонфигурацииВПакетномРежиме_ТонкийКлиент");
	ВсеТесты.Добавить("ТестДолжен_ПроверитьЗапускТестаЧтенияИерархииФайловКонфигурацииВПакетномРежиме_ТолстыйКлиент");
	ВсеТесты.Добавить("ТестДолжен_ПроверитьЗапускТестаЧтенияИерархииФайловКонфигурацииВПакетномРежиме_ТонкийКлиент");

	Возврат ВсеТесты;
КонецФункции

Процедура ПередЗапускомТеста() Экспорт
	Если КонтекстЯдра.ЭтоВстроеннаяОбработка Тогда
		ВызватьИсключение "[Pending] Тестирование пакетного запуска не реализовано для встроенной в конфигурацию подсистемы";
	КонецЕсли;

	//ИмяКаталогаВременныхФайлов = ПолучитьИмяВременногоФайла();
	ВременныйКаталог = Новый Файл(ПолучитьИмяВременногоФайла());
	ИмяКаталогаВременныхФайлов = ВременныйКаталог.Путь + "\a-" + ВременныйКаталог.Имя;

	СоздатьКаталог(ИмяКаталогаВременныхФайлов);

	ФайлЛогаUI = Новый Файл(ИмяКаталогаВременныхФайлов + "\log.txt");
	ФайлСОтчетомОТестировании = Новый Файл(ИмяКаталогаВременныхФайлов + "\report.xml");
	ФайлСОтчетомОТестировании_Аллюр = Новый Файл(ИмяКаталогаВременныхФайлов + "\report2.xml");

	ФайлКодаВозврата = Новый Файл(ИмяКаталогаВременныхФайлов + "\ExitCodePath.log");
	Ожидаем.Что(ФайлКодаВозврата.Существует(), "ФайлКодаВозврата существует, что неверно").ЭтоЛожь();
КонецПроцедуры

Процедура ПослеЗапускаТеста() Экспорт
	Попытка
		//УдалитьФайлы(ИмяКаталогаВременныхФайлов);
	Исключение
		// При ошибке удаления временного файла не считаем тест проваленым
	КонецПопытки;
КонецПроцедуры

Процедура ТестДолжен_ПроверитьЗапускВПакетномРежиме_ТолстыйКлиент() Экспорт
	ФайлСТестами = ПолучитьФайлПроекта("tests\xunit\core\Тесты_СистемаПлагинов.epf");
	СтрокаПараметров = СформироватьСтрокуПараметров("ЗагрузчикФайла", ФайлСТестами, "ГенераторОтчетаJUnitXML");

	ВыполнитьПакетныйЗапуск(РежимЗапускаКлиентскогоПриложения.ОбычноеПриложение, СтрокаПараметров);

	Ожидаем.Что(ФайлЛогаUI.Существует(), "ФайлЛогаUI не существует").ЭтоИстина();
	Ожидаем.Что(ФайлСОтчетомОТестировании.Существует(), "ФайлСОтчетомОТестировании существует").ЭтоИстина();
	Ожидаем.Что(ФайлКодаВозврата.Существует(), "ФайлКодаВозврата не существует").ЭтоИстина();
КонецПроцедуры

Функция ПолучитьФайлПроекта(Знач ОтносительныйПуть)

	ФайлСТестами = Новый Файл(ПолучитьКаталогПроекта().ПолноеИмя + "/" + ОтносительныйПуть);
	Возврат ФайлСТестами;
КонецФункции

Функция ПолучитьКаталогПроекта()

	Если КонтекстЯдра.ЭтоВстроеннаяОбработка Тогда
		ФайлЯдра = Новый Файл(ПутьКФайлуПолный);
	Иначе
		ФайлЯдра = Новый Файл(КонтекстЯдра["ИспользуемоеИмяФайла"]);
	КонецЕсли;
	КаталогЯдра = Новый Файл(ФайлЯдра.Путь);

	Возврат КаталогЯдра;
КонецФункции

Функция СформироватьСтрокуПараметров(ИдентификаторЗагрузчика, ФайлСТестами, ИдентификаторГенератораОтчета, ИдентификаторГенератораОтчета2 = "")
	СтрокаПараметров =
		ПарсерКоманднойСтроки.ВозможныеКлючи.xddRun + " " + ИдентификаторЗагрузчика + " """"" + ФайлСТестами.ПолноеИмя + """"";"
		+ ПарсерКоманднойСтроки.ВозможныеКлючи.xddShutdown + ";"
		+ ПарсерКоманднойСтроки.ВозможныеКлючи.xddReport + " " + ИдентификаторГенератораОтчета + " """"" + ФайлСОтчетомОТестировании.ПолноеИмя +  """"""
		+ ?(ИдентификаторГенератораОтчета2 = "", "", " ; " + ПарсерКоманднойСтроки.ВозможныеКлючи.xddReport + " " + ИдентификаторГенератораОтчета2 + " """"" + ФайлСОтчетомОТестировании_Аллюр.ПолноеИмя +  """""")
		+ "; " + ПарсерКоманднойСтроки.ВозможныеКлючи.xddExitCodePath + " ГенерацияКодаВозврата """"" +  ФайлКодаВозврата.ПолноеИмя +  """""" + ";"
		;

	Возврат СтрокаПараметров;
КонецФункции

Процедура ВыполнитьПакетныйЗапуск(Знач РежимЗапуска, Знач СтрокаПараметров)
	ПутьКПлатформе1С = ПолучитьПутьКПлатформе1С(РежимЗапуска);
	ВсякиеКлючи = " /Lru /VLru /DisableStartupMessages /DisableStartupDialogs ";
	СтрокаРежимЗапуска = ПолучитьСтрокаРежимаЗапуска(РежимЗапуска);
	СтрокаСоединения = ПолучитьСтрокуСоединения();
	СтрокаЛогированияUI = " /LogUI /Out """ + ФайлЛогаUI.ПолноеИмя + """";

	СтрокаКоманды = """" + ПутьКПлатформе1С + """";
	СтрокаКоманды = СтрокаКоманды + ВсякиеКлючи;
	СтрокаКоманды = СтрокаКоманды + СтрокаРежимЗапуска;
	СтрокаКоманды = СтрокаКоманды + СтрокаСоединения;
	СтрокаКоманды = СтрокаКоманды + " /Execute " + КонтекстЯдра["ИспользуемоеИмяФайла"];
	СтрокаКоманды = СтрокаКоманды + СтрокаЛогированияUI;
	СтрокаПараметров = " /C """ + СтрокаПараметров + """";

	СтрокаКоманды = СтрокаКоманды + СтрокаПараметров;

	//СтрокаКоманды = СтрокаКоманды + " /Debug /DebuggerURL tcp://localhost:1561 ";
	Сообщить(СтрокаКоманды);

	ЗапуститьПриложение(СтрокаКоманды, , Истина);
КонецПроцедуры

Функция ПолучитьПутьКПлатформе1С(Знач РежимЗапуска)
	Если РежимЗапуска = РежимЗапускаКлиентскогоПриложения.УправляемоеПриложение Тогда
		ИмяФайлаПриложения1С = "1cv8c";
	ИначеЕсли РежимЗапуска = РежимЗапускаКлиентскогоПриложения.ОбычноеПриложение Тогда
		ИмяФайлаПриложения1С = "1cv8";
	КонецЕсли;
	ПутьКПлатформе1С = КаталогПрограммы() + ИмяФайлаПриложения1С;

	Возврат ПутьКПлатформе1С;
КонецФункции

Функция ПолучитьСтрокаРежимаЗапуска(РежимЗапуска)
	Перем СтрокаРежимЗапуска;
	Если РежимЗапуска = РежимЗапускаКлиентскогоПриложения.УправляемоеПриложение Тогда
		СтрокаРежимЗапуска = " /RunModeManagedApplication ";
	ИначеЕсли РежимЗапуска = РежимЗапускаКлиентскогоПриложения.ОбычноеПриложение Тогда
		СтрокаРежимЗапуска = " /RunModeOrdinaryApplication ";
	КонецЕсли;

	Возврат СтрокаРежимЗапуска;
КонецФункции

Функция ПолучитьСтрокуСоединения()
	СтрокаСоединения = СтрокаСоединенияИнформационнойБазы();
	ПутьКФайловойБазе = НСтр(СтрокаСоединения, "File");
	Если НЕ ПустаяСтрока(ПутьКФайловойБазе) Тогда
		СтрокаСоединения = " /F """ + ПутьКФайловойБазе+"""";
	Иначе
		СтрокаСоединения = " /S " + НСтр(СтрокаСоединения, "Srvr") + "\" + НСтр(СтрокаСоединения, "Ref");
	КонецЕсли;
	ТекущийПользователь = ПользователиИнформационнойБазы.ТекущийПользователь();
	ИмяПользователя = ТекущийПользователь.Имя;
	СтрокаСоединения = СтрокаСоединения + " /N """ + ИмяПользователя + """";

	Возврат СтрокаСоединения;
КонецФункции

Процедура ТестДолжен_ПроверитьЗапускВПакетномРежиме_ТонкийКлиент() Экспорт
	ФайлСТестами = ПолучитьФайлПроекта("tests\xunit\core\Тесты_СистемаПлагинов.epf");
	СтрокаПараметров = СформироватьСтрокуПараметров("ЗагрузчикФайла", ФайлСТестами, "ГенераторОтчетаJUnitXML");

	ВыполнитьПакетныйЗапуск(РежимЗапускаКлиентскогоПриложения.УправляемоеПриложение, СтрокаПараметров);

	ПроверитьНаличиеОтчетаТестирования();
	//Ожидаем.Что(ФайлСОтчетомОТестировании.Существует(), "ФайлСОтчетомОТестировании существует").ЭтоИстина();
	Ожидаем.Что(ФайлКодаВозврата.Существует(), "ФайлКодаВозврата не существует").ЭтоИстина();
КонецПроцедуры

Процедура ТестДолжен_ПроверитьЗапускВПакетномРежиме_ТолстыйКлиент_СПлохимиПараметрами_xddRun() Экспорт

	КонтекстЯдра.ПропуститьТест("Тест временно отключен");

	ФайлСТестами = ПолучитьФайлПроекта("tests\xunit\core\Тесты_СистемаПлагинов.epf");
	СтрокаПараметров = СформироватьСтрокуПараметров("НесуществующийЗагрузчик", ФайлСТестами, "ГенераторОтчетаJUnitXML");

	ВыполнитьПакетныйЗапуск(РежимЗапускаКлиентскогоПриложения.ОбычноеПриложение, СтрокаПараметров);

	Ожидаем.Что(ФайлЛогаUI.Существует(), "ФайлЛогаUI").ЭтоИстина();
	Лог = Новый ЧтениеТекста(ФайлЛогаUI.ПолноеИмя);
	СодержаниеЛога = Лог.Прочитать();
	Ожидаем.Что(СодержаниеЛога, "СодержаниеЛога").Существует();
	Ожидаем.Что(ФайлСОтчетомОТестировании.Существует(), "ФайлСОтчетомОТестировании").ЭтоЛожь();
КонецПроцедуры

Процедура ТестДолжен_ПроверитьЗапускВПакетномРежиме_ТолстыйКлиент_СПлохимиПараметрами_xddReport() Экспорт

	КонтекстЯдра.ПропуститьТест("Тест временно отключен");

	ФайлСТестами = ПолучитьФайлПроекта("tests\xunit\core\Тесты_СистемаПлагинов.epf");
	СтрокаПараметров = СформироватьСтрокуПараметров("ЗагрузчикФайла", ФайлСТестами, "НесуществующийГенераторОтчета");

	ВыполнитьПакетныйЗапуск(РежимЗапускаКлиентскогоПриложения.ОбычноеПриложение, СтрокаПараметров);

	Ожидаем.Что(ФайлЛогаUI.Существует(), "ФайлЛогаUI").ЭтоИстина();
	Лог = Новый ЧтениеТекста(ФайлЛогаUI.ПолноеИмя);
	СодержаниеЛога = Лог.Прочитать();
	Ожидаем.Что(СодержаниеЛога, "СодержаниеЛога").Существует();
	Ожидаем.Что(ФайлСОтчетомОТестировании.Существует(), "ФайлСОтчетомОТестировании").ЭтоЛожь();
КонецПроцедуры

Процедура ТестДолжен_ПроверитьЗапускВПакетномРежиме_ТонкийКлиент_СПлохимиПараметрами_xddRun() Экспорт
	ФайлСТестами = ПолучитьФайлПроекта("tests\xunit\core\Тесты_СистемаПлагинов.epf");
	СтрокаПараметров = СформироватьСтрокуПараметров("НесуществующийЗагрузчик", ФайлСТестами, "ГенераторОтчетаJUnitXML");

	ВыполнитьПакетныйЗапуск(РежимЗапускаКлиентскогоПриложения.УправляемоеПриложение, СтрокаПараметров);

	Ожидаем.Что(ФайлСОтчетомОТестировании.Существует()).ЭтоЛожь();
КонецПроцедуры

Процедура ТестДолжен_ПроверитьЗапускВПакетномРежиме_ТонкийКлиент_СПлохимиПараметрами_xddReport() Экспорт
	ФайлСТестами = ПолучитьФайлПроекта("tests\xunit\core\Тесты_СистемаПлагинов.epf");
	СтрокаПараметров = СформироватьСтрокуПараметров("ЗагрузчикФайла", ФайлСТестами, "НесуществующийГенераторОтчета");

	ВыполнитьПакетныйЗапуск(РежимЗапускаКлиентскогоПриложения.УправляемоеПриложение, СтрокаПараметров);

	Ожидаем.Что(ФайлСОтчетомОТестировании.Существует()).ЭтоЛожь();
КонецПроцедуры

Процедура ТестДолжен_ПроверитьЗапускВПакетномРежиме_ТолстыйКлиент_ДваОтчетаТестирования() Экспорт
	ФайлСТестами = ПолучитьФайлПроекта("tests\xunit\core\Тесты_СистемаПлагинов.epf");
	СтрокаПараметров = СформироватьСтрокуПараметров("ЗагрузчикФайла", ФайлСТестами, "ГенераторОтчетаJUnitXML", "ГенераторОтчетаAllureXML");

	ВыполнитьПакетныйЗапуск(РежимЗапускаКлиентскогоПриложения.ОбычноеПриложение, СтрокаПараметров);

	Ожидаем.Что(ФайлЛогаUI.Существует(), "ФайлЛогаUI").ЭтоИстина();
	//ПроверитьНаличиеОтчетаТестирования();
	ПроверитьНаличиеОтчетаТестирования_Аллюр();
	Ожидаем.Что(ФайлСОтчетомОТестировании.Существует(), "ФайлСОтчетомОТестировании").ЭтоИстина();
	//Ожидаем.Что(ФайлСОтчетомОТестировании_Аллюр.Существует(), "ФайлСОтчетомОТестировании_Аллюр").ЭтоИстина();
	Ожидаем.Что(ФайлКодаВозврата.Существует(), "ФайлКодаВозврата не существует").ЭтоИстина();
КонецПроцедуры

Процедура ТестДолжен_ПроверитьЗапускВПакетномРежиме_ТонкийКлиент_ДваОтчетаТестирования() Экспорт
	ФайлСТестами = ПолучитьФайлПроекта("tests\xunit\core\Тесты_СистемаПлагинов.epf");
	СтрокаПараметров = СформироватьСтрокуПараметров("ЗагрузчикФайла", ФайлСТестами, "ГенераторОтчетаJUnitXML", "ГенераторОтчетаAllureXML");

	ВыполнитьПакетныйЗапуск(РежимЗапускаКлиентскогоПриложения.УправляемоеПриложение, СтрокаПараметров);

	ПроверитьНаличиеОтчетаТестирования();
	ПроверитьНаличиеОтчетаТестирования_Аллюр();
	//Ожидаем.Что(ФайлСОтчетомОТестировании.Существует(), "ФайлСОтчетомОТестировании существует").ЭтоИстина();
	Ожидаем.Что(ФайлКодаВозврата.Существует(), "ФайлКодаВозврата не существует").ЭтоИстина();
КонецПроцедуры

Процедура ТестДолжен_ПроверитьЗапускТестаЧтенияКонфигурацииВПакетномРежиме_ТолстыйКлиент() Экспорт
	КонтекстЯдра.ПропуститьТест("Тест временно отключен");

	ОжидаемоеКоличествоУпавшихТестов = 0;
	ОжидаемоеКоличествоЗеленыхТестов = 2;

	ФайлСТестами = ПолучитьФайлПроекта("fixtures\core\Тесты_Настройки.epf");
	ФайлНастройки = ПолучитьФайлПроекта("fixtures\core\Тесты_Настройки.json");

	СтрокаПараметров = СформироватьСтрокуПараметров("ЗагрузчикФайла", ФайлСТестами, "ГенераторОтчетаJUnitXML");
	СтрокаПараметров = СтрокаПараметров
		+ "; " + ПарсерКоманднойСтроки.ВозможныеКлючи.xddConfig + " """"" +  ФайлНастройки.ПолноеИмя +  """""" + ";";

	ВыполнитьПакетныйЗапуск(РежимЗапускаКлиентскогоПриложения.ОбычноеПриложение, СтрокаПараметров);

	ПроверитьПравильностьПакетногоЗапуска(ОжидаемоеКоличествоЗеленыхТестов, ОжидаемоеКоличествоУпавшихТестов);
КонецПроцедуры

Процедура ТестДолжен_ПроверитьЗапускТестаЧтенияКонфигурацииВПакетномРежиме_ТонкийКлиент() Экспорт
	КонтекстЯдра.ПропуститьТест("Тест временно отключен");

	ОжидаемоеКоличествоУпавшихТестов = 0;
	ОжидаемоеКоличествоЗеленыхТестов = 2;

	ФайлСТестами = ПолучитьФайлПроекта("fixtures\core\Тесты_Настройки.epf");
	ФайлНастройки = ПолучитьФайлПроекта("fixtures\core\Тесты_Настройки.json");

	СтрокаПараметров = СформироватьСтрокуПараметров("ЗагрузчикФайла", ФайлСТестами, "ГенераторОтчетаJUnitXML");
	СтрокаПараметров = СтрокаПараметров
		+ "; " + ПарсерКоманднойСтроки.ВозможныеКлючи.xddConfig + " """"" +  ФайлНастройки.ПолноеИмя +  """""" + ";";

	ВыполнитьПакетныйЗапуск(РежимЗапускаКлиентскогоПриложения.УправляемоеПриложение, СтрокаПараметров);

	ПроверитьПравильностьПакетногоЗапуска(ОжидаемоеКоличествоЗеленыхТестов, ОжидаемоеКоличествоУпавшихТестов, Ложь);
КонецПроцедуры

Процедура ТестДолжен_ПроверитьЗапускТестаЧтенияИерархииФайловКонфигурацииВПакетномРежиме_ТолстыйКлиент() Экспорт
	КонтекстЯдра.ПропуститьТест("Тест временно отключен");

	ОжидаемоеКоличествоУпавшихТестов = 0;
	ОжидаемоеКоличествоЗеленыхТестов = 2;

	ФайлСТестами = ПолучитьФайлПроекта("fixtures\core\Тесты_Настройки.epf");
	ФайлНастройки = ПолучитьФайлПроекта("fixtures\core\Тесты_Настройки_Родитель.json");

	СтрокаПараметров = СформироватьСтрокуПараметров("ЗагрузчикФайла", ФайлСТестами, "ГенераторОтчетаJUnitXML");
	СтрокаПараметров = СтрокаПараметров
		+ "; " + ПарсерКоманднойСтроки.ВозможныеКлючи.xddConfig + " """"" +  ФайлНастройки.ПолноеИмя +  """""" + ";";

	ВыполнитьПакетныйЗапуск(РежимЗапускаКлиентскогоПриложения.ОбычноеПриложение, СтрокаПараметров);

	ПроверитьПравильностьПакетногоЗапуска(ОжидаемоеКоличествоЗеленыхТестов, ОжидаемоеКоличествоУпавшихТестов);
КонецПроцедуры

Процедура ТестДолжен_ПроверитьЗапускТестаЧтенияИерархииФайловКонфигурацииВПакетномРежиме_ТонкийКлиент() Экспорт
	КонтекстЯдра.ПропуститьТест("Тест временно отключен");

	ОжидаемоеКоличествоУпавшихТестов = 0;
	ОжидаемоеКоличествоЗеленыхТестов = 2;

	ФайлСТестами = ПолучитьФайлПроекта("fixtures\core\Тесты_Настройки.epf");
	ФайлНастройки = ПолучитьФайлПроекта("fixtures\core\Тесты_Настройки_Родитель.json");

	СтрокаПараметров = СформироватьСтрокуПараметров("ЗагрузчикФайла", ФайлСТестами, "ГенераторОтчетаJUnitXML");
	СтрокаПараметров = СтрокаПараметров
		+ "; " + ПарсерКоманднойСтроки.ВозможныеКлючи.xddConfig + " """"" +  ФайлНастройки.ПолноеИмя +  """""" + ";";

	ВыполнитьПакетныйЗапуск(РежимЗапускаКлиентскогоПриложения.УправляемоеПриложение, СтрокаПараметров);

	ПроверитьПравильностьПакетногоЗапуска(ОжидаемоеКоличествоЗеленыхТестов, ОжидаемоеКоличествоУпавшихТестов, Ложь);
КонецПроцедуры

Процедура ПроверитьПравильностьПакетногоЗапуска(Знач ОжидаемоеКоличествоЗеленыхТестов, Знач ОжидаемоеКоличествоУпавшихТестов, Знач ПроверятьЛогUI = Истина)

	Если ПроверятьЛогUI Тогда
		Ожидаем.Что(ФайлЛогаUI.Существует(), "ФайлЛогаUI не существует").ЭтоИстина();
	КонецЕсли;

	ПроверитьНаличиеОтчетаТестирования();
	//Ожидаем.Что(ФайлСОтчетомОТестировании.Существует(), "ФайлСОтчетомОТестировании не существует").ЭтоИстина();
	Ожидаем.Что(ФайлКодаВозврата.Существует(), "ФайлКодаВозврата не существует").ЭтоИстина();

	РезультатыТестирования = ПолучитьРезультатыТестированияИзФайлаJUnit(ФайлСОтчетомОТестировании);
	КоличествоУпавшихТестов = РезультатыТестирования.КоличествоУпавшихТестов;
	КоличествоЗеленыхТестов = РезультатыТестирования.КоличествоЗеленыхТестов;

	Если КоличествоУпавшихТестов <> ОжидаемоеКоличествоУпавшихТестов или КоличествоЗеленыхТестов <> ОжидаемоеКоличествоЗеленыхТестов Тогда
		Для каждого КлючЗначение Из РезультатыТестирования.УпавшиеТесты Цикл
			УпавшийТест = КлючЗначение.Значение;
			Сообщить(СтрШаблон_("Упал тест <%1>, ошибка %2%3", УпавшийТест.Имя, Символы.ПС, УпавшийТест.ТекстОшибки));
		КонецЦикла;
	КонецЕсли;

	Если ОжидаемоеКоличествоУпавшихТестов <> 0 Тогда
		Ожидаем.Что(КоличествоУпавшихТестов,
			"Ожидали, что упадут тесты ("+ОжидаемоеКоличествоУпавшихТестов+"шт), а остальные пройдут, а получили <"+КоличествоУпавшихТестов+"> упавших тестов.")
			.Равно(ОжидаемоеКоличествоУпавшихТестов);
	Иначе
		Ожидаем.Что(КоличествоУпавшихТестов,
			"Ожидали, что пройдут все тесты, а получили <"+КоличествоУпавшихТестов+"> упавших тестов.")
			.Равно(ОжидаемоеКоличествоУпавшихТестов);
	КонецЕсли;
	Если ОжидаемоеКоличествоЗеленыхТестов <> 0 Тогда
		Ожидаем.Что(КоличествоЗеленыхТестов,
			"Ожидали, что пройдут тесты ("+ОжидаемоеКоличествоЗеленыхТестов+"шт), а остальные упадут, а получили <"+КоличествоЗеленыхТестов+"> прошедших тестов.")
			.Равно(ОжидаемоеКоличествоЗеленыхТестов);
	Иначе
		Ожидаем.Что(КоличествоЗеленыхТестов,
			"Ожидали, что упадут все тесты, а получили <"+КоличествоЗеленыхТестов+"> прошедших тестов.")
			.Равно(ОжидаемоеКоличествоЗеленыхТестов);
	КонецЕсли;

	КодВозврата = ПрочитатьФайлИнформации(ФайлКодаВозврата.ПолноеИмя);
	Ожидаем.Что(КодВозврата, "Ожидали нулевой код возврата, а получили другой код").Равно("0");

КонецПроцедуры

Функция ПрочитатьФайлИнформации(Знач ПутьКФайлу) Экспорт

	ФайлКодаВозврата = Новый Файл(ПутьКФайлу);
	Ожидаем.Что(ФайлКодаВозврата.Существует(), "Ожидали, что будет сформирован файл кода возврата, а файла нет").ЭтоИстина();

	Чтение = Новый ЧтениеТекста(ФайлКодаВозврата.ПолноеИмя);
	Текст = Чтение.Прочитать();
	Чтение.Закрыть();

	Возврат Текст;

КонецФункции

Функция ПолучитьРезультатыТестированияИзФайлаJUnit(Знач ФайлСОтчетомОТестированииJUnit)
	КоличествоУпавшихТестов = 0;
	КоличествоЗеленыхТестов = 0;
	УпавшиеТесты = Новый Соответствие;

	ТекущийТест = Неопределено;

	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.ОткрытьФайл(ФайлСОтчетомОТестированииJUnit.ПолноеИмя);
	Пока ЧтениеXML.Прочитать() Цикл
		Если ЧтениеXML.ТипУзла	= ТипУзлаXML.НачалоЭлемента и ЧтениеXML.Имя = "testsuites" Тогда
			Для сч = 0 По ЧтениеXML.КоличествоАтрибутов()-1 Цикл
				Если ЧтениеXML.ИмяАтрибута(сч) = "failures" Тогда
					КоличествоУпавшихТестов = КоличествоУпавшихТестов + Число(ЧтениеXML.ЗначениеАтрибута(сч));
				ИначеЕсли ЧтениеXML.ИмяАтрибута(сч) = "errors" Тогда
					КоличествоУпавшихТестов = КоличествоУпавшихТестов + Число(ЧтениеXML.ЗначениеАтрибута(сч));
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		Если ЧтениеXML.ТипУзла	= ТипУзлаXML.НачалоЭлемента и ЧтениеXML.Имя = "testcase" Тогда
			ТекущийТест = Новый Структура("Имя,Результат,ТекстОшибки");
			Для сч = 0 По ЧтениеXML.КоличествоАтрибутов()-1 Цикл
				Если ЧтениеXML.ИмяАтрибута(сч) = "status" Тогда
					СтатусТеста = НРег(Строка(ЧтениеXML.ЗначениеАтрибута(сч)));
					ТекущийТест.Вставить("Результат", СтатусТеста);
					Если СтатусТеста = "passed" Тогда
						КоличествоЗеленыхТестов = КоличествоЗеленыхТестов + 1;
					КонецЕсли;
				ИначеЕсли ЧтениеXML.ИмяАтрибута(сч) = "name" Тогда
					ТекущийТест.Вставить("Имя", Строка(ЧтениеXML.ЗначениеАтрибута(сч)));
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		Если ЧтениеXML.ТипУзла	= ТипУзлаXML.НачалоЭлемента и ЧтениеXML.Имя = "failure" или ЧтениеXML.Имя = "error" Тогда
			Для сч = 0 По ЧтениеXML.КоличествоАтрибутов()-1 Цикл
				Если ЧтениеXML.ИмяАтрибута(сч) = "message" Тогда
					ТекущийТест.Вставить("ТекстОшибки", Строка(ЧтениеXML.ЗначениеАтрибута(сч)));
					УпавшиеТесты.Вставить(ТекущийТест.Имя, ТекущийТест);
					Прервать;
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	Результат = Новый Структура("КоличествоЗеленыхТестов, КоличествоУпавшихТестов", КоличествоЗеленыхТестов, КоличествоУпавшихТестов);
	Результат.Вставить("УпавшиеТесты", УпавшиеТесты);
	Возврат Новый ФиксированнаяСтруктура(Результат);
КонецФункции

Процедура ПроверитьНаличиеОтчетаТестирования()
	НашлиФайлы = НайтиФайлы(ИмяКаталогаВременныхФайлов, "*-result.xml", Ложь);
	Ожидаем.Что(НашлиФайлы.Количество() > 0, "ФайлСОтчетомОТестировании не существует, а он должен быть").ЭтоИстина();
КонецПроцедуры

Процедура ПроверитьНаличиеОтчетаТестирования_Аллюр()
	НашлиФайлы = НайтиФайлы(ИмяКаталогаВременныхФайлов, "*-report*-testsuite.xml", Ложь);
	Ожидаем.Что(НашлиФайлы.Количество() > 0, "ФайлСОтчетомОТестировании Аллюр не существует, а он должен быть").ЭтоИстина();
КонецПроцедуры


Функция СтрШаблон_(Знач СтрокаШаблон, Знач Парам1 = Неопределено, Знач Парам2 = Неопределено, Знач Парам3 = Неопределено, Знач Парам4 = Неопределено, Знач Парам5 = Неопределено) Экспорт

	МассивПараметров = Новый Массив;
	МассивПараметров.Добавить(Парам1);
	МассивПараметров.Добавить(Парам2);
	МассивПараметров.Добавить(Парам3);
	МассивПараметров.Добавить(Парам4);
	МассивПараметров.Добавить(Парам5);

	Для Сч = 1 По МассивПараметров.Количество() Цикл
		ТекЗначение = МассивПараметров[Сч-1];
		СтрокаШаблон = СтрЗаменить(СтрокаШаблон, "%"+Сч, Строка(ТекЗначение));
	КонецЦикла;

	Возврат СтрокаШаблон;

КонецФункции
