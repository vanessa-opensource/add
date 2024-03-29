﻿// портировано из https://github.com/artbear/1bdd

#Область Служебные_функции_и_процедуры

&НаКлиенте
// контекст фреймворка Vanessa-ADD
Перем Ванесса;

&НаКлиенте
// Структура, в которой хранится состояние сценария между выполнением шагов. Очищается перед выполнением каждого сценария.
Перем Контекст Экспорт;

&НаКлиенте
// Структура, в которой можно хранить служебные данные между запусками сценариев. Существует, пока открыта форма Vanessa-ADD.
Перем КонтекстСохраняемый Экспорт;

&НаКлиенте
Перем Ожидаем;

&НаКлиенте
Перем РегулярныеВыражения;

&НаКлиенте
// Функция экспортирует список шагов, которые реализованы в данной внешней обработке.
Функция ПолучитьСписокТестов(КонтекстФреймворкаBDD) Экспорт
	Ванесса = КонтекстФреймворкаBDD;
	Ожидаем = Ванесса.Плагин("УтвержденияBDD");

	ВсеТесты = Новый Массив;

	// описание шагов
	// пример вызова Ванесса.ДобавитьШагВМассивТестов(ВсеТесты, Снипет, ИмяПроцедуры, ПредставлениеТеста, ОписаниеШага, ТипШагаДляОписания, ТипШагаВДереве);

	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ЯУстанавливаюВременныйКаталогКакРабочийКаталог()","ЯУстанавливаюВременныйКаталогКакРабочийКаталог","И Я устанавливаю временный каталог как рабочий каталог","","Файлы");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ЯСоздаюВременныйКаталогИСохраняюЕгоВКонтекст()","ЯСоздаюВременныйКаталогИСохраняюЕгоВКонтекст","Допустим Я создаю временный каталог и сохраняю его в контекст","","Файлы.Создание файлов/каталогов");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ЯСоздаюКаталогВРабочемКаталоге(Парам01)","ЯСоздаюКаталогВРабочемКаталоге","И Я создаю каталог ""folder0/folder01"" в рабочем каталоге","","Файлы.Создание файлов/каталогов");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ЯСоздаюКаталогВПодкаталогеРабочегоКаталога(Парам01,Парам02)","ЯСоздаюКаталогВПодкаталогеРабочегоКаталога","И Я создаю каталог ""folder011"" в подкаталоге ""folder0/folder01"" рабочего каталога","","Файлы.Создание файлов/каталогов");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ЯСоздаюФайлВРабочемКаталоге(Парам01)","ЯСоздаюФайлВРабочемКаталоге","Допустим Я создаю файл ""folder0/file01.txt"" в рабочем каталоге","","Файлы.Создание файлов/каталогов");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ЯСоздаюВременныйКаталогИСохраняюЕгоВПеременной(Парам01)","ЯСоздаюВременныйКаталогИСохраняюЕгоВПеременной","Дано Я создаю временный каталог и сохраняю его в переменной ""СпециальныйКаталог""","","Файлы.Создание файлов/каталогов");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ЯСоздаюКаталог(Парам01)","ЯСоздаюКаталог","Когда Я создаю каталог ""СпециальныйКаталог/folder0/folder01""","","Файлы.Создание файлов/каталогов");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ЯСоздаюКаталогВнутриКаталога(Парам01,Парам02)","ЯСоздаюКаталогВнутриКаталога","Когда Я создаю каталог ""folder1/folder11"" внутри каталога ""СпециальныйКаталог""","","Файлы.Создание файлов/каталогов");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ЯСоздаюФайлВПодкаталогеРабочегоКаталога(Парам01,Парам02)","ЯСоздаюФайлВПодкаталогеРабочегоКаталога","И Я создаю файл ""file01"" в подкаталоге ""folder0/folder01"" рабочего каталога","","Файлы.Создание файлов/каталогов");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ЯСоздаюФайлВнутриКаталога(Парам01,Парам02)","ЯСоздаюФайлВнутриКаталога","Когда Я создаю файл ""folder1/file11.txt"" внутри каталога ""СпециальныйКаталог""","","Файлы.Создание файлов/каталогов");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ЯСоздаюФайл(Парам01)","ЯСоздаюФайл","Когда Я создаю файл ""СпециальныйКаталог/file01.txt""","","Файлы.Создание файлов/каталогов");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ВРабочемКаталогеСуществуетКаталог(Парам01)","ВРабочемКаталогеСуществуетКаталог","Тогда В рабочем каталоге существует каталог ""folder0/folder01""","","Файлы.Проверка существования");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ВПодкаталогеРабочегоКаталогаСуществуетКаталог(Парам01,Парам02)","ВПодкаталогеРабочегоКаталогаСуществуетКаталог","И В подкаталоге ""folder0/folder01"" рабочего каталога существует каталог ""folder011""","","Файлы.Проверка существования");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"КаталогСуществует(Парам01)","КаталогСуществует","Тогда Каталог ""СпециальныйКаталог/folder0"" существует","","Файлы.Проверка существования");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"КаталогНеСуществует(Парам01)","КаталогНеСуществует","И Каталог ""СпециальныйКаталог/folder0/folder01-unknown"" не существует","","Файлы.Проверка существования");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"КаталогВнутриКаталогаСуществует(Парам01,Парам02)","КаталогВнутриКаталогаСуществует","Тогда Каталог ""folder0"" внутри каталога ""СпециальныйКаталог"" существует","","Файлы.Проверка существования");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"КаталогВнутриКаталогаНеСуществует(Парам01,Парам02)","КаталогВнутриКаталогаНеСуществует","И Каталог ""folder0/folder01-unknown"" внутри каталога ""СпециальныйКаталог"" не существует","","Файлы.Проверка существования");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ВРабочемКаталогеСуществуетФайл(Парам01)","ВРабочемКаталогеСуществуетФайл","Тогда В рабочем каталоге существует файл ""folder0/file01.txt""","","Файлы.Проверка существования");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ВПодкаталогеРабочегоКаталогаСуществуетФайл(Парам01,Парам02)","ВПодкаталогеРабочегоКаталогаСуществуетФайл","И В подкаталоге ""folder0/folder01"" рабочего каталога существует файл ""file01""","","Файлы.Проверка существования");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ФайлСуществует(Парам01)","ФайлСуществует","Тогда Файл ""СпециальныйКаталог/file01.txt"" существует","","Файлы.Проверка существования");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ФайлНеСуществует(Парам01)","ФайлНеСуществует","И Файл ""folder01/file01-unknown.txt"" не существует","","Файлы.Проверка существования");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ФайлВнутриКаталогаСуществует(Парам01,Парам02)","ФайлВнутриКаталогаСуществует","И Файл ""file01.txt"" внутри каталога ""СпециальныйКаталог"" существует","","Файлы.Проверка существования");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ФайлВнутриКаталогаНеСуществует(Парам01,Парам02)","ФайлВнутриКаталогаНеСуществует","И Файл ""folder1/file01-unknown.txt"" внутри каталога ""СпециальныйКаталог"" не существует","","Файлы.Проверка существования");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ЯКопируюФайлИзКаталогаПроектаВРабочийКаталог(Парам01,Парам02)","ЯКопируюФайлИзКаталогаПроектаВРабочийКаталог","Когда Я копирую файл ""step_definitions/БезПараметров.os"" из каталога ""tests/fixtures"" проекта в рабочий каталог","","Файлы.Копирование");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ЯКопируюФайлИзКаталогаПроектаВПодкаталогРабочегоКаталога(Парам01,Парам02,Парам03)","ЯКопируюФайлИзКаталогаПроектаВПодкаталогРабочегоКаталога","И Я копирую файл ""fixtures/test-report.xml"" из каталога ""tests"" проекта в подкаталог ""folder0/folder01"" рабочего каталога","","Файлы.Копирование");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ЯКопируюКаталогИзКаталогаПроектаВРабочийКаталог(Парам01,Парам02)","ЯКопируюКаталогИзКаталогаПроектаВРабочийКаталог","Когда Я копирую каталог ""fixtures/step_definitions"" из каталога ""tests/fixtures"" проекта в рабочий каталог","","Файлы.Копирование");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ЯКопируюКаталогИзКаталогаПроектаВПодкаталогРабочегоКаталога(Парам01,Парам02,Парам03)","ЯКопируюКаталогИзКаталогаПроектаВПодкаталогРабочегоКаталога","И Я копирую каталог ""fixtures/step_definitions"" из каталога ""tests"" проекта в подкаталог ""folder0/folder01"" рабочего каталога","","Файлы.Копирование");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ЯУдаляюКаталог(Парам01)","ЯУдаляюКаталог","Когда Я удаляю каталог ""СпециальныйКаталог/КаталогДляУдаления""","","Файлы.Удаление");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ЯУдаляюФайл(Парам01)","ЯУдаляюФайл","Когда Я удаляю файл ""СпециальныйКаталог/ФайлДляУдаления.txt""","","Файлы.Удаление");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ЯПоказываюТекущийКаталог()","ЯПоказываюТекущийКаталог","И Я показываю текущий каталог","","Файлы");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ЯСохраняюКаталогПроектаВКонтекст()","ЯСохраняюКаталогПроектаВКонтекст","Когда Я сохраняю каталог проекта в контекст","","Файлы");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ЯПоказываюКаталогПроекта()","ЯПоказываюКаталогПроекта","Тогда Я показываю каталог проекта","","Файлы");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ЯПоказываюРабочийКаталог()","ЯПоказываюРабочийКаталог","И Я показываю рабочий каталог","","Файлы");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ФайлВРабочемКаталогеСодержит(Парам01,Парам02)","ФайлВРабочемКаталогеСодержит","Тогда Файл ""folder0/file01.txt"" в рабочем каталоге содержит ""Текст файла""","","Файлы.Проверка содержимого файлов");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ФайлВРабочемКаталогеНеСодержит(Парам01,Парам02)","ФайлВРабочемКаталогеНеСодержит","И Файл ""folder0/file01.txt"" в рабочем каталоге не содержит ""Не существующий текст""","","Файлы.Проверка содержимого файлов");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ФайлСодержит(Парам01,Парам02)","ФайлСодержит","Тогда Файл ""folder0/file01.txt"" содержит ""Текст файла""","","Файлы.Проверка содержимого файлов");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ФайлНеСодержит(Парам01,Парам02)","ФайлНеСодержит","И Файл ""folder0/file01.txt"" не содержит ""Не существующий текст""","","Файлы.Проверка содержимого файлов");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ЯСоздаюФайлСТекстом(Парам01,Парам02)","ЯСоздаюФайлСТекстом","Когда Я создаю файл ""СпециальныйКаталог/ФайлСТекстом.txt"" с текстом ""текст178""","","Файлы.Проверка содержимого файлов");

	Возврат ВсеТесты;
КонецФункции

&НаСервере
// Служебная функция.
Функция ПолучитьМакетСервер(ИмяМакета)
	ОбъектСервер = РеквизитФормыВЗначение("Объект");
	Возврат ОбъектСервер.ПолучитьМакет(ИмяМакета);
КонецФункции

&НаКлиенте
// Служебная функция для подключения библиотеки создания fixtures.
Функция ПолучитьМакетОбработки(ИмяМакета) Экспорт
	Возврат ПолучитьМакетСервер(ИмяМакета);
КонецФункции

&НаКлиенте
// Процедура выполняется перед началом каждого сценария
Процедура ПередНачаломСценария() Экспорт

	РегулярныеВыражения();

КонецПроцедуры

&НаКлиенте
Функция РегулярныеВыражения()

	Если РегулярныеВыражения = Неопределено Тогда

		РегулярныеВыражения = Ванесса.Плагин("РегулярныеВыражения");
		РегулярныеВыражения.Подготовить("[\*,\?]");

	КонецЕсли;

	Возврат РегулярныеВыражения;

КонецФункции

#КонецОбласти

#Область Шаги

///////////////////////////////////////////////////
//Реализация шагов
///////////////////////////////////////////////////

&НаКлиенте
//Допустим Я создаю временный каталог и сохраняю его в контекст
//@ЯСоздаюВременныйКаталогИСохраняюЕгоВКонтекст()
Процедура ЯСоздаюВременныйКаталогИСохраняюЕгоВКонтекст() Экспорт
	ВременныйКаталог = ПолучитьИмяВременногоФайла();
	Ванесса.СоздатьКаталогКомандаСистемы(ВременныйКаталог);
	Контекст.Вставить("ВременныйКаталог", ВременныйКаталог);
КонецПроцедуры

&НаКлиенте
//Дано Я создаю временный каталог и сохраняю его в переменной "СпециальныйКаталог"
//@ЯСоздаюВременныйКаталогИСохраняюЕгоВПеременной(Парам01)
Процедура ЯСоздаюВременныйКаталогИСохраняюЕгоВПеременной(Знач ИмяПеременной) Экспорт
	ВременныйКаталог = ПолучитьИмяВременногоФайла();
	Ванесса.СоздатьКаталогКомандаСистемы(ВременныйКаталог);
	Контекст.Вставить(ИмяПеременной, ВременныйКаталог);
КонецПроцедуры

&НаКлиенте
//И Я устанавливаю временный каталог как рабочий каталог
//@ЯУстанавливаюВременныйКаталогКакРабочийКаталог()
Процедура ЯУстанавливаюВременныйКаталогКакРабочийКаталог() Экспорт
	ВременныйКаталог = Контекст["ВременныйКаталог"];
	Контекст.Вставить("РабочийКаталог", ВременныйКаталог);
КонецПроцедуры

&НаКлиенте
//Когда Я создаю каталог "СпециальныйКаталог/folder0/folder01"
//@ЯСоздаюКаталог(Парам01)
Процедура ЯСоздаюКаталог(Знач ИмяКаталога) Экспорт
	Ванесса.СоздатьКаталогКомандаСистемы(ИмяКаталога);
КонецПроцедуры

&НаКлиенте
//И Я создаю каталог "folder0/folder01" в рабочем каталоге
//@ЯСоздаюКаталогВРабочемКаталоге(Парам01)
Процедура ЯСоздаюКаталогВРабочемКаталоге(Знач ИмяКаталога) Экспорт
	НовыйПуть = ОбъединитьПути(РабочийКаталог(), ИмяКаталога);
	Ванесса.СоздатьКаталогКомандаСистемы(НовыйПуть);
КонецПроцедуры

&НаКлиенте
//И Я создаю каталог "folder011" в подкаталоге "folder0/folder01" рабочего каталога
//@ЯСоздаюКаталогВПодкаталогеРабочегоКаталога(Парам01,Парам02)
Процедура ЯСоздаюКаталогВПодкаталогеРабочегоКаталога(Знач ПутьНовогоКаталога, Знач ПутьКаталога) Экспорт
	НовыйПуть = ОбъединитьПути(РабочийКаталог(), ПутьКаталога, ПутьНовогоКаталога);
	Ванесса.СоздатьКаталогКомандаСистемы(НовыйПуть);
КонецПроцедуры

&НаКлиенте
//Когда Я создаю каталог "folder1/folder11" внутри каталога "СпециальныйКаталог"
//@ЯСоздаюКаталогВнутриКаталога(Парам01,Парам02)
Процедура ЯСоздаюКаталогВнутриКаталога(Знач ЧтоСоздаем, Знач ГдеСоздаем) Экспорт
	НовыйПуть = ОбъединитьПути(ГдеСоздаем, ЧтоСоздаем);
	Ванесса.СоздатьКаталогКомандаСистемы(НовыйПуть);
КонецПроцедуры

&НаКлиенте
//Тогда В рабочем каталоге существует каталог "folder0/folder01"
//@ВРабочемКаталогеСуществуетКаталог(Парам01)
Процедура ВРабочемКаталогеСуществуетКаталог(Знач ПутьКаталога) Экспорт
	ПолныйПуть = "";
	ФайлСуществует = ФайлИлиКаталогСуществует(ПутьКаталога, ПолныйПуть, Истина, РабочийКаталог());
	Ожидаем.Что(ФайлСуществует, Ванесса.СтрШаблон_("Ожидаем, что каталог <%1> существует, а его нет!", ПолныйПуть)).ЭтоИстина();
КонецПроцедуры

&НаКлиенте
//И В подкаталоге "folder0/folder01" рабочего каталога существует каталог "folder011"
//@ВПодкаталогеРабочегоКаталогаСуществуетКаталог(Парам01,Парам02)
Процедура ВПодкаталогеРабочегоКаталогаСуществуетКаталог(Знач ПутьПодКаталога, Знач ПутьПроверяемогоКаталога) Экспорт
	ПутьПодКаталога = ПутьПодКаталога;
	ПолныйПуть = "";
	ФайлСуществует = ФайлИлиКаталогСуществует(ПутьПроверяемогоКаталога, ПолныйПуть, Истина,
		ОбъединитьПути(РабочийКаталог(), ПутьПодКаталога));
	Ожидаем.Что(ФайлСуществует, Ванесса.СтрШаблон_("Ожидаем, что каталог <%1> существует, а его нет!", ПолныйПуть)).ЭтоИстина();
КонецПроцедуры

&НаКлиенте
//Тогда Каталог "СпециальныйКаталог/folder0" существует
//@КаталогСуществует(Парам01)
Процедура КаталогСуществует(Знач ПутьКаталога) Экспорт
	ПолныйПуть = "";
	ФайлСуществует = ФайлИлиКаталогСуществует(ПутьКаталога, ПолныйПуть, Истина);
	Ожидаем.Что(ФайлСуществует, Ванесса.СтрШаблон_("Ожидаем, что каталог <%1> существует, а его нет!", ПолныйПуть)).ЭтоИстина();
КонецПроцедуры

&НаКлиенте
//И Каталог "СпециальныйКаталог/folder0/folder01-unknown" не существует
//@КаталогНеСуществует(Парам01)
Процедура КаталогНеСуществует(Знач ПутьКаталога) Экспорт
	ПолныйПуть = "";
	ФайлСуществует = ФайлИлиКаталогСуществует(ПутьКаталога, ПолныйПуть, Истина);
	Ожидаем.Что(ФайлСуществует, Ванесса.СтрШаблон_("Ожидаем, что каталога <%1> нет, а он существует!", ПолныйПуть)).ЭтоЛожь();
КонецПроцедуры

&НаКлиенте
//Тогда Каталог "folder0" внутри каталога "СпециальныйКаталог" существует
//@КаталогВнутриКаталогаСуществует(Парам01,Парам02)
Процедура КаталогВнутриКаталогаСуществует(Знач ПутьПроверяемогоКаталога, Знач ПутьПодКаталога) Экспорт
	ПолныйПуть = "";
	ФайлСуществует = ФайлИлиКаталогСуществует(ПутьПроверяемогоКаталога, ПолныйПуть, Истина,
		ОбъединитьПути(РабочийКаталог(), ПутьПодКаталога));
	Ожидаем.Что(ФайлСуществует, Ванесса.СтрШаблон_("Ожидаем, что каталог <%1> существует, а его нет!", ПолныйПуть)).ЭтоИстина();
КонецПроцедуры

&НаКлиенте
//И Каталог "folder0/folder01-unknown" внутри каталога "СпециальныйКаталог" не существует
//@КаталогВнутриКаталогаНеСуществует(Парам01,Парам02)
Процедура КаталогВнутриКаталогаНеСуществует(Знач ПутьПроверяемогоКаталога, Знач ПутьПодКаталога) Экспорт
	//ПутьПодКаталога = БДД.ПолучитьПутьФайлаСУчетомПеременныхКонтекста(ПутьПодКаталога);
	ПолныйПуть = "";
	ФайлСуществует = ФайлИлиКаталогСуществует(ПутьПроверяемогоКаталога, ПолныйПуть, Истина,
		ОбъединитьПути(РабочийКаталог(), ПутьПодКаталога));
	Ожидаем.Что(ФайлСуществует, Ванесса.СтрШаблон_("Ожидаем, что каталога <%1> нет, а он существует!", ПолныйПуть)).ЭтоЛожь();
КонецПроцедуры

&НаКлиенте
//Когда Я создаю файл "СпециальныйКаталог/file01.txt"
//@ЯСоздаюФайл(Парам01)
Процедура ЯСоздаюФайл(Знач ПутьФайла) Экспорт
	СоздатьФайлПример(ПутьФайла);
КонецПроцедуры

&НаКлиенте
//Когда Я создаю файл "folder1/file11.txt" внутри каталога "СпециальныйКаталог"
//@ЯСоздаюФайлВнутриКаталога(Парам01,Парам02)
Процедура ЯСоздаюФайлВнутриКаталога(Знач ПутьФайла, Знач ПутьКаталога) Экспорт

	НовыйПуть = ОбъединитьПути(ПутьКаталога, ПутьФайла);
	СоздатьФайлПример(НовыйПуть);
КонецПроцедуры

&НаКлиенте
//Допустим Я создаю файл "folder0/file01.txt" в рабочем каталоге
//@ЯСоздаюФайлВРабочемКаталоге(Парам01)
Процедура ЯСоздаюФайлВРабочемКаталоге(Знач ПутьФайла) Экспорт
	НовыйПуть = ОбъединитьПути(РабочийКаталог(), ПутьФайла);
	СоздатьФайлПример(НовыйПуть);
КонецПроцедуры

&НаКлиенте
//И Я создаю файл "file01" в подкаталоге "folder0/folder01" рабочего каталога
//@ЯСоздаюФайлВПодкаталогеРабочегоКаталога(Парам01,Парам02)
Процедура ЯСоздаюФайлВПодкаталогеРабочегоКаталога(Знач ПутьФайла, Знач ПутьКаталога) Экспорт
	НовыйПуть = ОбъединитьПути(РабочийКаталог(), ПутьКаталога, ПутьФайла);
	СоздатьФайлПример(НовыйПуть);
КонецПроцедуры

&НаКлиенте
//Тогда В рабочем каталоге существует файл "folder0/file01.txt"
//@ВРабочемКаталогеСуществуетФайл(Парам01)
Процедура ВРабочемКаталогеСуществуетФайл(Знач ПутьФайла) Экспорт
	ПолныйПуть = "";
	ФайлСуществует = ФайлИлиКаталогСуществует(ПутьФайла, ПолныйПуть, Ложь, РабочийКаталог());
	Ожидаем.Что(ФайлСуществует, Ванесса.СтрШаблон_("Ожидаем, что файл <%1> существует, а его нет!", ПолныйПуть)).ЭтоИстина();
КонецПроцедуры

&НаКлиенте
//И В подкаталоге "folder0/folder01" рабочего каталога существует файл "file01"
//@ВПодкаталогеРабочегоКаталогаСуществуетФайл(Парам01,Парам02)
Процедура ВПодкаталогеРабочегоКаталогаСуществуетФайл(Знач ПутьПодКаталога, Знач ПутьФайла) Экспорт
	ПолныйПуть = "";
	ФайлСуществует = ФайлИлиКаталогСуществует(ПутьФайла, ПолныйПуть, Ложь,
		ОбъединитьПути(РабочийКаталог(), ПутьПодКаталога));
	Ожидаем.Что(ФайлСуществует, Ванесса.СтрШаблон_("Ожидаем, что файл <%1> существует, а его нет!", ПолныйПуть)).ЭтоИстина();
КонецПроцедуры

&НаКлиенте
//Тогда Файл "СпециальныйКаталог/file01.txt" существует
//@ФайлСуществует(Парам01)
Процедура ФайлСуществует(Знач ПутьФайла) Экспорт
	ПолныйПуть = "";
	ФайлСуществует = ФайлИлиКаталогСуществует(ПутьФайла, ПолныйПуть);
	Ожидаем.Что(ФайлСуществует, Ванесса.СтрШаблон_("Ожидаем, что файл <%1> существует, а его нет!", ПолныйПуть)).ЭтоИстина();
КонецПроцедуры

&НаКлиенте
//И Файл "folder01/file01-unknown.txt" не существует
//@ФайлНеСуществует(Парам01)
Процедура ФайлНеСуществует(Знач ПутьФайла) Экспорт
	ПолныйПуть = "";
	ФайлСуществует = ФайлИлиКаталогСуществует(ПутьФайла, ПолныйПуть);
	Ожидаем.Что(ФайлСуществует, Ванесса.СтрШаблон_("Ожидаем, что файла <%1> нет, а он существует!", ПолныйПуть)).ЭтоЛожь();
КонецПроцедуры

&НаКлиенте
//И Файл "file01.txt" внутри каталога "СпециальныйКаталог" существует
//@ФайлВнутриКаталогаСуществует(Парам01,Парам02)
Процедура ФайлВнутриКаталогаСуществует(Знач ПутьФайла, Знач ПутьКаталога) Экспорт
	ПолныйПуть = "";
	ФайлСуществует = ФайлИлиКаталогСуществует(ПутьФайла, ПолныйПуть, Ложь,
		ОбъединитьПути(РабочийКаталог(), ПутьКаталога));
	Ожидаем.Что(ФайлСуществует, Ванесса.СтрШаблон_("Ожидаем, что файл <%1> существует, а его нет!", ПолныйПуть)).ЭтоИстина();
КонецПроцедуры

&НаКлиенте
//И Файл "folder1/file01-unknown.txt" внутри каталога "СпециальныйКаталог" не существует
//@ФайлВнутриКаталогаНеСуществует(Парам01,Парам02)
Процедура ФайлВнутриКаталогаНеСуществует(Знач ПутьФайла, Знач ПутьКаталога) Экспорт
	ПолныйПуть = "";
	ФайлСуществует = ФайлИлиКаталогСуществует(ПутьФайла, ПолныйПуть, Ложь,
		ОбъединитьПути(РабочийКаталог(), ПутьКаталога));
	Ожидаем.Что(ФайлСуществует, Ванесса.СтрШаблон_("Ожидаем, что файла <%1> нет, а он существует!", ПолныйПуть)).ЭтоЛожь();
КонецПроцедуры

&НаКлиенте
//Когда Я копирую файл "step_definitions/БезПараметров.os" из каталога "tests/fixtures" проекта в рабочий каталог
//@ЯКопируюФайлИзКаталогаПроектаВРабочийКаталог(Парам01,Парам02)
Процедура ЯКопируюФайлИзКаталогаПроектаВРабочийКаталог(Знач ПутьФайла, Знач ПодКаталогПроекта) Экспорт

	ПолныйПутьФайла = ОбъединитьПути(КаталогПроекта(), ПодКаталогПроекта, ПутьФайла);
	Файл = Новый Файл(ПолныйПутьФайла);
	Ванесса.КопироватьФайлКомандаСистемы(ПолныйПутьФайла, ОбъединитьПути(РабочийКаталог(), Файл.Имя));
КонецПроцедуры

&НаКлиенте
//И Я копирую файл "fixtures/test-report.xml" из каталога "tests" проекта в подкаталог "folder0/folder01" рабочего каталога
//@ЯКопируюФайлИзКаталогаПроектаВПодкаталогРабочегоКаталога(Парам01,Парам02,Парам03)
Процедура ЯКопируюФайлИзКаталогаПроектаВПодкаталогРабочегоКаталога(Знач ПутьФайла, Знач ПодКаталогПроекта,
		Знач ПутьПодКаталога) Экспорт

	ПолныйПутьФайла = ОбъединитьПути(КаталогПроекта(), ПодКаталогПроекта, ПутьФайла);
	Файл = Новый Файл(ПолныйПутьФайла);
	Если Ванесса.ЕстьПоддержкаАсинхронныхВызовов Тогда
		Ванесса.КопироватьФайлКомандаСистемы(ПолныйПутьФайла, ОбъединитьПути(РабочийКаталог(), ПутьПодКаталога, Файл.Имя));
	Иначе
		КопироватьФайл(ПолныйПутьФайла, ОбъединитьПути(РабочийКаталог(), ПутьПодКаталога, Файл.Имя));
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
//Когда Я копирую каталог "fixtures/step_definitions" из каталога "tests/fixtures" проекта в рабочий каталог
//@ЯКопируюКаталогИзКаталогаПроектаВРабочийКаталог(Парам01,Парам02)
Процедура ЯКопируюКаталогИзКаталогаПроектаВРабочийКаталог(Знач ПутьНовогоКаталога, Знач ПодКаталогПроекта) Экспорт

	ПолныйПутьКаталога = ОбъединитьПути(КаталогПроекта(), ПодКаталогПроекта, ПутьНовогоКаталога);
	ОбъектКаталога = Новый Файл(ПолныйПутьКаталога);
	ПутьНовогоКаталога = ОбъединитьПути(РабочийКаталог(), ОбъектКаталога.Имя);

	Ванесса.ОбеспечитьКаталогКомандаСистемы(ПутьНовогоКаталога);
	Ванесса.КопироватьКаталогКомандаСистемы(ПолныйПутьКаталога, ПутьНовогоКаталога);
КонецПроцедуры

&НаКлиенте
//И Я копирую каталог "fixtures/step_definitions" из каталога "tests" проекта в подкаталог "folder0/folder01" рабочего каталога
//@ЯКопируюКаталогИзКаталогаПроектаВПодкаталогРабочегоКаталога(Парам01,Парам02,Парам03)
Процедура ЯКопируюКаталогИзКаталогаПроектаВПодкаталогРабочегоКаталога(Знач ПутьНовогоКаталога, Знач ПодКаталогПроекта,
		Знач ПутьПодКаталога) Экспорт

	ПолныйПутьКаталога = ОбъединитьПути(КаталогПроекта(), ПодКаталогПроекта, ПутьНовогоКаталога);
	ОбъектКаталога = Новый Файл(ПолныйПутьКаталога);

	ПутьНовогоКаталога = ОбъединитьПути(РабочийКаталог(), ПутьПодКаталога, ОбъектКаталога.Имя);

	Ванесса.ОбеспечитьКаталогКомандаСистемы(ПутьНовогоКаталога);
	Ванесса.КопироватьКаталогКомандаСистемы(ПолныйПутьКаталога, ПутьНовогоКаталога);
КонецПроцедуры

&НаКлиенте
//Когда Я удаляю каталог "СпециальныйКаталог/КаталогДляУдаления"
//@ЯУдаляюКаталог(Парам01)
Процедура ЯУдаляюКаталог(Знач ПутьККаталогу) Экспорт
	УдалитьФайлИлиКаталог(ПутьККаталогу);
КонецПроцедуры

&НаКлиенте
//Когда Я удаляю файл "СпециальныйКаталог/ФайлДляУдаления.txt"
//@ЯУдаляюФайл(Парам01)
Процедура ЯУдаляюФайл(Знач ПутьКФайлу) Экспорт
	УдалитьФайлИлиКаталог(ПутьКФайлу);
КонецПроцедуры

&НаКлиенте
//Когда Я сохраняю каталог проекта в контекст
//@ЯСохраняюКаталогПроектаВКонтекст()
Процедура ЯСохраняюКаталогПроектаВКонтекст() Экспорт
	Контекст.Вставить("КаталогПроекта", КаталогПроекта());
КонецПроцедуры

&НаКлиенте
//Тогда Я показываю каталог проекта
//@ЯПоказываюКаталогПроекта()
Процедура ЯПоказываюКаталогПроекта() Экспорт
	Сообщить(КаталогПроекта());
КонецПроцедуры

&НаКлиенте
//И Я показываю рабочий каталог
//@ЯПоказываюРабочийКаталог()
Процедура ЯПоказываюРабочийКаталог() Экспорт
	Сообщить(РабочийКаталог());
КонецПроцедуры

&НаКлиенте
//И Я показываю текущий каталог
//@ЯПоказываюТекущийКаталог()
Процедура ЯПоказываюТекущийКаталог() Экспорт
	Сообщить(РабочийКаталог());
КонецПроцедуры

&НаКлиенте
//Тогда Файл "folder0/file01.txt" в рабочем каталоге содержит "Текст файла"
//@ФайлВРабочемКаталогеСодержит(Парам01,Парам02)
Процедура ФайлВРабочемКаталогеСодержит(Знач ПутьФайла, Знач ЧтоИщем) Экспорт

	Файл = Новый Файл(ОбъединитьПути(РабочийКаталог(), ПутьФайла));
	ПроверитьСодержимоеФайла(Файл, ЧтоИщем);
КонецПроцедуры

&НаКлиенте
//И Файл "folder0/file01.txt" в рабочем каталоге не содержит "Не существующий текст"
//@ФайлВРабочемКаталогеНеСодержит(Парам01,Парам02)
Процедура ФайлВРабочемКаталогеНеСодержит(Знач ПутьФайла, Знач ЧтоИщем) Экспорт

	Файл = Новый Файл(ОбъединитьПути(РабочийКаталог(), ПутьФайла));
	ПроверитьОтсутствиеВФайле(Файл, ЧтоИщем);
КонецПроцедуры

&НаКлиенте
//Тогда Файл "folder0/file01.txt" содержит "Текст файла"
//@ФайлСодержит(Парам01,Парам02)
Процедура ФайлСодержит(Знач ПутьФайла, Знач ЧтоИщем) Экспорт

	Файл = Новый Файл(ОбъединитьПути(РабочийКаталог(), ПутьФайла));
	ПроверитьСодержимоеФайла(Файл, ЧтоИщем);
КонецПроцедуры

&НаКлиенте
//И Файл "folder0/file01.txt" не содержит "Не существующий текст"
//@ФайлНеСодержит(Парам01,Парам02)
Процедура ФайлНеСодержит(Знач ПутьФайла, Знач ЧтоИщем) Экспорт

	Файл = Новый Файл(ОбъединитьПути(РабочийКаталог(), ПутьФайла));
	ПроверитьОтсутствиеВФайле(Файл, ЧтоИщем);
КонецПроцедуры

&НаКлиенте
//Когда Я создаю файл "СпециальныйКаталог/ФайлСТекстом.txt" с текстом "текст178"
//@ЯСоздаюФайлСТекстом(Парам01,Парам02)
Процедура ЯСоздаюФайлСТекстом(Знач ПутьФайла, Знач ТекстФайла) Экспорт
	ПутьФайла = ОбъединитьПути(РабочийКаталог(), ПутьФайла);
	ЗаписьТекста = Новый ЗаписьТекста(ПутьФайла, "utf-8");
	ЗаписьТекста.ЗаписатьСтроку(ТекстФайла);
	ЗаписьТекста.Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ОбъединитьПути(Каталог, Элем1, Элем2 = "", Элем3 = "")
	Рез = "";
	Если ЗначениеЗаполнено(Каталог) Тогда
		Рез = Каталог + ПолучитьРазделительПути();
	КонецЕсли;
	Если ЗначениеЗаполнено(Элем1) Тогда
		Если Найти(Элем1, Каталог) = 0 И Не ЭтоАбсолютныйПуть(Элем1) Тогда
			Рез = Рез + Элем1;
		Иначе
			Рез = Элем1; // если явно указали абсолютный каталог
		КонецЕсли;
	КонецЕсли;
	Если ЗначениеЗаполнено(Элем2) Тогда
		Рез = Рез + ПолучитьРазделительПути() + Элем2;
	КонецЕсли;
	Если ЗначениеЗаполнено(Элем3) Тогда
		Рез = Рез + ПолучитьРазделительПути() + Элем3;
	КонецЕсли;

	Возврат ЗаменитьРазделителиПути(Рез);
КонецФункции

&НаКлиенте
Функция ЭтоАбсолютныйПуть(Знач Путь)
	Результат = Ложь;
	ПервыйСимвол = Лев(Путь, 1);
	Если Ванесса.ЭтоЛинукс() Тогда
		Результат = ПервыйСимвол = "/";
	Иначе
		Если ПервыйСимвол = "\" Или ПервыйСимвол = "/"
				Или Сред(Путь, 2, 1) = ":" Или Лев(Путь, 2) = "\\" Тогда

			Результат = Истина;
		КонецЕсли;
	КонецЕсли;
	Возврат Результат;
КонецФункции

&НаКлиенте
Функция ЗаменитьРазделителиПути(Знач Путь)
	Если Ванесса.ЭтоЛинукс() Тогда
		ЗаменяемыйРазделитель = "\";
	Иначе
		ЗаменяемыйРазделитель = "/";
	КонецЕсли;
	Рез = СтрЗаменить(Путь, ЗаменяемыйРазделитель, ПолучитьРазделительПути());
	Возврат Рез;
КонецФункции

&НаКлиенте
Функция РабочийКаталог()
	Возврат Контекст["РабочийКаталог"];
КонецФункции

&НаКлиенте
Функция КаталогПроекта()
	Возврат Ванесса.Объект.КаталогПроекта;
КонецФункции

&НаКлиенте
Функция ФайлИлиКаталогСуществует(Знач ПутьФайла, ПолныйПуть, Знач ЭтоКаталог = Ложь, Знач ИсходныйКаталог = "")

	Если ИсходныйКаталог = "" Тогда
		ИсходныйКаталог = РабочийКаталог();
	КонецЕсли;
	Если ИсходныйКаталог = "" Тогда
		ИсходныйКаталог = Ванесса.Объект.КаталогПроекта;
	КонецЕсли;
	ПутьФайла = ЗаменитьРазделителиПути(ПутьФайла);
	ИсходныйКаталог = ЗаменитьРазделителиПути(ИсходныйКаталог);

	//ПутьФайла = ЗаменитьШаблоныВПараметрахКоманды(ПутьФайла);

	ПутьБезРегулярок = Не РегулярныеВыражения().Совпадает(ПутьФайла);

	Рез = Ложь;
	Если ПутьБезРегулярок Тогда
		Файл = Новый Файл(ОбъединитьПути(ИсходныйКаталог, ПутьФайла));
		ПолныйПуть = Файл.ПолноеИмя;
		Если Ванесса.ЕстьПоддержкаАсинхронныхВызовов Тогда
			Рез = Ванесса.ФайлСуществуетКомандаСистемы(ПолныйПуть);
			//для ускорения в асинхронном режиме не проверяю, файл это или каталог
		Иначе
			Рез = Файл.Существует();
			Если Рез Тогда
				Рез = ЭтоКаталог И Файл.ЭтоКаталог() Или Не ЭтоКаталог И Не Файл.ЭтоКаталог();
			КонецЕсли;
		КонецЕсли;
	Иначе
		СписокКаталогов = Новый СписокЗначений;
		СписокФайлов = Новый СписокЗначений;
		ИскатьВПодкаталогах = Истина;
		ДопМаска = "";
		Если ЭтоКаталог Тогда
			ДопМаска = "*";
		КонецЕсли;
		Попытка
			НайтиФайлыИлиКаталоги(ИсходныйКаталог, ПутьФайла + ДопМаска, СписокКаталогов, СписокФайлов, ИскатьВПодкаталогах);
			Если ЭтоКаталог Тогда
				Рез = СписокКаталогов.Количество() > 0;
			Иначе
				Рез = СписокФайлов.Количество() > 0;
			КонецЕсли;
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			Сообщить("Ошибка " + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
			Рез = Ложь;
		КонецПопытки;
	КонецЕсли;
	Возврат Рез;
КонецФункции

&НаКлиенте
Процедура СоздатьФайлПример(Знач ПутьФайла) Экспорт
	ЗаписьТекста = Новый ЗаписьТекста(ПутьФайла);
	ЗаписьТекста.Записать("Текст файла");
	ЗаписьТекста.Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура УдалитьФайлИлиКаталог(Знач Путь) Экспорт
	//Путь = ЗаменитьШаблоныВПараметрахКоманды(Путь);
	Путь = ОбъединитьПути(РабочийКаталог(), Путь);

	Файл = Новый Файл(Путь);
	Если Ванесса.ФайлСуществуетКомандаСистемы(Путь) Тогда
		Ванесса.УдалитьКаталогКомандаСистемы(Файл.ПолноеИмя);
	КонецЕсли;
	Если Ванесса.ФайлСуществуетКомандаСистемы(Путь) Тогда
		Ванесса.УдалитьФайлыКомандаСистемы(Файл.ПолноеИмя);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьСодержимоеФайла(Знач Файл, Знач ЧтоИщем)
	ТекстФайла = ПрочитатьТекстФайла(Файл);
	//ТекстФайла = ЗаменитьШаблоныВПараметрахКоманды(ТекстФайла);
	//ЧтоИщем = ЗаменитьШаблоныВПараметрахКоманды(ЧтоИщем);

	ОписаниеОшибки = Ванесса.СтрШаблон_("Ожидали, что файл <%1> содержит `<%2>`, а это не так!", Файл.ПолноеИмя, ЧтоИщем);
	Ожидаем.Что(ТекстФайла, ОписаниеОшибки).Содержит(ЧтоИщем);
КонецПроцедуры

&НаКлиенте
Функция ПрочитатьТекстФайла(Знач Файл, Кодировка = "UTF-8")
	ЧтениеТекста = Новый ЧтениеТекста;
	ЧтениеТекста.Открыть(Файл.ПолноеИмя, Кодировка);

	Строка = ЧтениеТекста.Прочитать();
	ЧтениеТекста.Закрыть();
	Возврат Строка;
КонецФункции // ПрочитатьТекстФайла()

&НаКлиенте
Процедура ПроверитьОтсутствиеВФайле(Знач Файл, Знач ЧтоИщем)
	ТекстФайла = ПрочитатьТекстФайла(Файл);
	//ТекстФайла = ЗаменитьШаблоныВПараметрахКоманды(ТекстФайла);
	//ЧтоИщем = ЗаменитьШаблоныВПараметрахКоманды(ЧтоИщем);

	ОписаниеОшибки = Ванесса.СтрШаблон_("Ожидали, что файл <%1> не содержит `<%2>`, а это не так!", Файл.ПолноеИмя, ЧтоИщем);
	Ожидаем.Что(ТекстФайла, ОписаниеОшибки).Не_().Содержит(ЧтоИщем);
КонецПроцедуры

&НаКлиенте
Процедура НайтиФайлыИлиКаталоги(Знач Путь, Знач МаскаФайлов, СписокКаталогов, СписокФайлов, Знач ИскатьВПодкаталогах,
		Знач КаталогДляВременныхФайлов = "") //Экспорт

	Путь = ЗаменитьРазделителиПути(Путь);
	МаскаФайлов = ЗаменитьРазделителиПути(МаскаФайлов);
	Если Найти(НРег(МаскаФайлов), НРег(Путь)) = 1 Тогда
		МаскаФайлов = Сред(МаскаФайлов, СтрДлина(Путь) + 1);
	КонецЕсли;
	Если НЕ Ванесса.ЕстьПоддержкаАсинхронныхВызовов Тогда
		Файлы = НайтиФайлы(Путь, МаскаФайлов, ИскатьВПодкаталогах);

		Для Каждого Файл Из Файлы Цикл
			Если Файл.ЭтоКаталог() Тогда
				СписокКаталогов.Добавить(Файл, Файл.ПолноеИмя);
			Иначе
				СписокФайлов.Добавить(Файл, Файл.ПолноеИмя);
			КонецЕсли;
		КонецЦикла;
	Иначе

		//получение каталогов
		Если Не ЗначениеЗаполнено(КаталогДляВременныхФайлов) Тогда
			ИмяФайлаЛога = ПолучитьИмяВременногоФайла("txt"); // имя этого временного файла буду переиспользовать для ускорения
		Иначе
			ИмяФайлаЛога = ПолучитьПутьВременногоФайла(КаталогДляВременныхФайлов);
		КонецЕсли;

		Если Ванесса.ЭтоЛинукс() Тогда

			КомандаКаталоги = "find """ + Путь + """ "+ ?(ИскатьВПодкаталогах, "", "-maxdepth 1") + "-type d -name '" + МаскаФайлов + "'" + " > """ + ИмяФайлаЛога + """";
			КомандаСистемы(КомандаКаталоги);
		Иначе

			КомандаКаталоги = "DIR """ + Путь + "\" + МаскаФайлов + """ /A:D /B " + ?(ИскатьВПодкаталогах, "/S", "") + " > """ + ИмяФайлаЛога + """";
			//последний параметр важен для правильного чтения русских имен файлов
			Ванесса.ВыполнитьКомандуОСБезПоказаЧерногоОкна(КомандаКаталоги, Истина, Истина);

		КонецЕсли;

		МассивСтрокИзФайла = ЗагрузитьФайлВМассив(ИмяФайлаЛога);
		Для каждого Стр Из МассивСтрокИзФайла Цикл
			СписокКаталогов.Добавить(Новый Файл(Стр), Стр);
		КонецЦикла;

		//получение файлов

		Если Ванесса.ЭтоЛинукс() Тогда

			КомандаКаталоги = "find """ + Путь + """ "+ ?(ИскатьВПодкаталогах, "", "-maxdepth 1") + "-type f -name '" + МаскаФайлов + "'" + " > """ + ИмяФайлаЛога + """";
			КомандаСистемы(КомандаКаталоги);
		Иначе

			КомандаФайлы = "DIR """ + Путь + "\" + МаскаФайлов + """ /A:-D /B " + ?(ИскатьВПодкаталогах, "/S", "") + " > """ + ИмяФайлаЛога + """";

			//последний параметр важен для правильного чтения русских имен файлов
			Ванесса.ВыполнитьКомандуОСБезПоказаЧерногоОкна(КомандаФайлы, Истина, Истина);
		КонецЕсли;

		МассивСтрокИзФайла = ЗагрузитьФайлВМассив(ИмяФайлаЛога);
		Для каждого Стр Из МассивСтрокИзФайла Цикл
			СписокФайлов.Добавить(Новый Файл(Стр), Стр);
		КонецЦикла;

		Если Не ЗначениеЗаполнено(КаталогДляВременныхФайлов) И Не Ванесса.ЕстьПоддержкаАсинхронныхВызовов Тогда
			Ванесса.УдалитьФайлыКомандаСистемы(ИмяФайлаЛога);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Функция ПолучитьПутьВременногоФайла(Знач КаталогДляВременныхФайлов, Знач Расширение = "")
	НовоеИмя = ПолучитьИмяВременногоФайла(Расширение);
	Файл = Новый Файл(НовоеИмя);
	НовоеИмя = КаталогДляВременныхФайлов + "/" + Файл.Имя;
	Возврат НовоеИмя;
КонецФункции

&НаКлиенте
Функция ЗагрузитьФайлВМассив(Знач ИмяФайла, РезМассив = Неопределено)
	Если РезМассив <> Неопределено Тогда
		Массив = РезМассив;
	Иначе
		Массив = Новый Массив;
	КонецЕсли;

	Текст = Новый ЧтениеТекста;
	Текст.Открыть(ИмяФайла, "UTF-8");

	Пока Истина Цикл
		Стр = Текст.ПрочитатьСтроку();
		Если Стр = Неопределено Тогда
			Прервать;
		КонецЕсли;

		Массив.Добавить(Стр);
	КонецЦикла;

	Текст.Закрыть();

	Возврат Массив;
КонецФункции

#КонецОбласти
