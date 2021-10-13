﻿&НаКлиенте
Перем WshShell;

&НаКлиенте
Перем ЭтоLinux;

&НаКлиенте
Перем КонтекстЯдра;

// { Plugin interface
&НаКлиенте
Функция ОписаниеПлагина(КонтекстЯдра, ВозможныеТипыПлагинов) Экспорт
	Возврат ОписаниеПлагинаНаСервере(ВозможныеТипыПлагинов);
КонецФункции

&НаКлиенте
Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
	КонтекстЯдра = КонтекстЯдраПараметр;
КонецПроцедуры

&НаСервере
Функция ОписаниеПлагинаНаСервере(ВозможныеТипыПлагинов)
	КонтекстЯдраНаСервере = ВнешниеОбработки.Создать("xddTestRunner");
	Возврат ЭтотОбъектНаСервере().ОписаниеПлагина(КонтекстЯдраНаСервере, ВозможныеТипыПлагинов);
КонецФункции
// } Plugin interface

// { API

// Выполняет команду системы, при этом на экране не будет показано окно cmd
// Использует WshShell.
//
// Параметры:
//  СтрокаКоманды		 - Строка - выполняемая команда
//  ЖдатьОкончания		 - Булево, Число  - флаг ожидания окончания выполнения команды:
//		Если ЖдатьОкончания = Истина (или -1), тогда будет ожидания окончания работы приложения
//		Если ЖдатьОкончания = Ложь (или 0), тогда нет ожидания
//  ИспользоватьКодировкуТекстаUTF8	 - Булево - командный файл будет запущен с кодировкой консоли UTF8 через chcp 65001
//
// Возвращаемое значение:
//   - Результат выполнения скрипта. 0 - если не было ошибок.
//
&НаКлиенте
Функция ВыполнитьКомандуОСБезПоказаЧерногоОкна(Знач ТекстКоманды, Знач ЖдатьОкончания = Истина,
	Знач ИспользоватьКодировкуТекстаUTF8 = Истина) Экспорт

	Если КонтекстЯдра.ЭтоLinux Тогда
		КодВозврата = 0;
		ЗапуститьПриложение(ТекстКоманды,, ЖдатьОкончания, КодВозврата);
		Возврат КодВозврата;	
	КонецЕсли;

	Если ЖдатьОкончания = -1 Тогда
		ЖдатьОкончания = Истина;
	ИначеЕсли ЖдатьОкончания = 0 Тогда
		ЖдатьОкончания = Ложь;
	КонецЕсли;

	УдалятьФайл = Ложь;
	ИмяВременногоФайлаКоманды = ТекстКоманды;
	Если ИспользоватьКодировкуТекстаUTF8 Тогда

		ИмяВременногоФайлаКоманды = ПолучитьИмяВременногоФайла("bat");

		//эти строки нужны для записи файла без BOM
		ЗТ = Новый ЗаписьТекста(ИмяВременногоФайлаКоманды, "CESU-8", , Ложь);
		ЗТ.ЗаписатьСтроку("chcp 65001");

		ЗТ.ЗаписатьСтроку(ТекстКоманды);
		ЗТ.Закрыть();

		УдалятьФайл = Истина;
	КонецЕсли;

	ИмяВременногоФайлаКоманды = "cmd /c """ + ИмяВременногоФайлаКоманды + """";

	КонтекстЯдра.Отладка(ТекстКоманды);
	//КонтекстЯдра.Отладка(ИмяВременногоФайлаКоманды);

	Если WshShell = Неопределено Тогда
		WshShell = ПолучитьWshShell();
	КонецЕсли;

	Рез = WshShell.Run(ИмяВременногоФайлаКоманды, 0, ?(ЖдатьОкончания, -1, 0));

	Если ЖдатьОкончания И УдалятьФайл Тогда
		//иначе удалять нельзя
		Если КонтекстЯдра.ЕстьПоддержкаАсинхронныхВызовов Тогда
			// для скорости не удаляем временный файл, сервер потом удалит КонтекстЯдра.УдалитьФайлыКомандаСистемы(ИмяВременногоФайлаКоманды);
		Иначе
			УдалитьФайлы(ИмяВременногоФайлаКоманды);
		КонецЕсли;
	КонецЕсли;

	Возврат Рез;
КонецФункции

// Выполняет команду системы, при этом на экране не будет показано окно cmd
// Использует WshShell.
//
// Параметры:
//  ТекстКоманды           - Строка - выполняемая команда
//  ЖдатьОкончания          - Булево, Число  - флаг ожидания окончания выполнения команды:
//		Если ЖдатьОкончания = Истина (или -1), тогда будет ожидания окончания работы приложения
//		Если ЖдатьОкончания = Ложь (или 0), тогда нет ожидания
//  ИспользоватьКодировкуТекстаUTF8 - Булево - командный файл будет запущен с кодировкой консоли UTF8 через chcp 65001
//  КонсольныйВывод         - Строка - исходящий параметр. В нем возвращается весь консольный вывод скрипта
//
// Возвращаемое значение:
//  Число - Результат выполнения скрипта. 0 - если не было ошибок.
//
&НаКлиенте
Функция ВыполнитьКомандуОСБезПоказаЧерногоОкнаСВыводом(Знач ТекстКоманды, Знач ЖдатьОкончания = Истина,
	Знач ИспользоватьКодировкуТекстаUTF8 = Истина, КонсольныйВывод = "") Экспорт

	Если КонтекстЯдра.ЭтоLinux Тогда
		
		КодВозврата = 0;

		ИмяФайлаВывода = ПолучитьИмяВременногоФайла("txt");
		
		// `2>&1` редиректит stderr в stdout, чтобы весь вывод собрать в одном файле.
		ВремКоманда = ТекстКоманды + "> """ + ИмяФайлаВывода + """ 2>&1";

		Попытка

			ЗапуститьПриложение(ВремКоманда,, ЖдатьОкончания, КодВозврата);

			Если ФайлСуществует(ИмяФайлаВывода) Тогда
				КонсольныйВывод = ПрочитатьФайлКакТекст(ИмяФайлаВывода, ИспользоватьКодировкуТекстаUTF8);
			КонецЕсли;

		Исключение

			УдалитьВременныйФайл(ИмяФайлаВывода);

			ВызватьИсключение;

		КонецПопытки;

		УдалитьВременныйФайл(ИмяФайлаВывода);

		Возврат КодВозврата;

	КонецЕсли;

	Если ЖдатьОкончания = -1 Тогда
		ЖдатьОкончания = Истина;
	ИначеЕсли ЖдатьОкончания = 0 Тогда
		ЖдатьОкончания = Ложь;
	КонецЕсли;

	УдалятьФайл = Ложь;
	ИмяВременногоФайлаКоманды = ТекстКоманды;
	Если ИспользоватьКодировкуТекстаUTF8 Тогда

		ИмяВременногоФайлаКоманды = ПолучитьИмяВременногоФайла("bat");

		//эти строки нужны для записи файла без BOM
		ЗТ = Новый ЗаписьТекста(ИмяВременногоФайлаКоманды, "CESU-8", , Ложь);
		ЗТ.ЗаписатьСтроку("chcp 65001");

		ЗТ.ЗаписатьСтроку(ТекстКоманды);
		ЗТ.Закрыть();

		УдалятьФайл = Истина;
	КонецЕсли;

	ИмяФайлаВывода = ПолучитьИмяВременногоФайла("txt");
	ИмяВременногоФайлаКоманды = "cmd /c """"""" + ИмяВременногоФайлаКоманды + """"" > """"" + ИмяФайлаВывода + """"" 2>&1 "" ";

	КонтекстЯдра.Отладка(ТекстКоманды);
	//КонтекстЯдра.Отладка(ИмяВременногоФайлаКоманды);

	WshShell = ПолучитьWshShell();

	Попытка

		Рез = WshShell.Run(ИмяВременногоФайлаКоманды, 0, ?(ЖдатьОкончания, -1, 0));

		Если ФайлСуществует(ИмяФайлаВывода) Тогда
			// команда выполнилась успешно
			КонсольныйВывод = ПрочитатьФайлКакТекст(ИмяФайлаВывода, ИспользоватьКодировкуТекстаUTF8);
		КонецЕсли;

	Исключение

		УдалитьВременныйФайл(ИмяФайлаВывода);

		Если ЖдатьОкончания И УдалятьФайл Тогда
			//иначе удалять нельзя
			УдалитьВременныйФайл(ИмяВременногоФайлаКоманды);
		КонецЕсли;

		ВызватьИсключение;

	КонецПопытки;

	УдалитьВременныйФайл(ИмяФайлаВывода);

	Если ЖдатьОкончания И УдалятьФайл Тогда
		//иначе удалять нельзя
		УдалитьВременныйФайл(ИмяВременногоФайлаКоманды);
	КонецЕсли;

	Возврат Рез;

КонецФункции

// далее переменная WshShell будет закеширована, чтобы не создавать ComObject каждый раз
&НаКлиенте
Функция ПолучитьWshShell() Экспорт

	Если WshShell = Неопределено Тогда
		Попытка
			WshShell = Новый COMОбъект("WScript.Shell");
		Исключение
			ВызватьИсключение "Не удалось подключить COM объект <WScript.Shell>";
		КонецПопытки;
	КонецЕсли;

	Возврат WshShell;

КонецФункции

// Функция - Установлен OneScript
//
// Возвращаемое значение:
//   Булево - Истина = установлен, Ложь = Нет
//
&НаКлиенте
Функция УстановленOneScript() Экспорт

	ИнструментУстановлен = Ложь;

	ИмяФайлаЛога = ПолучитьИмяВременногоФайла("txt");
	Стр = "oscript > """ + ИмяФайлаЛога + """ 2>&1";

	ВыполнитьКомандуОСБезПоказаЧерногоОкна(Стр);

	Текст = Новый ЧтениеТекста;
	Текст.Открыть(ИмяФайлаЛога, "UTF-8");

	СтрокаВозврата = Неопределено;

	КолСтрокСчитано = 0;
	Стр = Текст.ПрочитатьСтроку();

	Если Стр <> Неопределено Тогда
		Образец = "1Script Execution Engine";
		Если Лев(Стр, СтрДлина(Образец)) = Образец Тогда
			ИнструментУстановлен = Истина;
		КонецЕсли;
	КонецЕсли;

	Текст.Закрыть();
	КонтекстЯдра.УдалитьФайлыКомандаСистемы(ИмяФайлаЛога);

	Возврат ИнструментУстановлен;

КонецФункции // УстановленOneScript()


&НаКлиенте
Функция ПолучитьМассивPIDПроцессов(ИмяОбраза) Экспорт
	МассивProcessID = Новый Массив;
	Если КонтекстЯдра.ЭтоLinux Тогда
		КонтекстЯдра.СделатьСообщение("ПолучитьМассивPIDПроцессов не доступно в Linux");
		Возврат МассивProcessID;	
	КонецЕсли;

	ИмяВременногоФайла = ПолучитьИмяВременногоФайла("txt");
	ИмяВременногоBat = ПолучитьИмяВременногоФайла("bat");
	ЗТ = Новый ЗаписьТекста(ИмяВременногоBat, "windows-1251", , Истина);
	ЗТ.ЗаписатьСтроку("chcp 65001");
	ЗТ.ЗаписатьСтроку("tasklist /v /fo list /fi ""imagename eq " + ИмяОбраза + """ > """ + ИмяВременногоФайла + """");
	ЗТ.Закрыть();

	ВыполнитьКомандуОСБезПоказаЧерногоОкна(ИмяВременногоBat);

	Текст = Новый ЧтениеТекста;
	Текст.Открыть(ИмяВременногоФайла, "UTF-8");

	ProcessID = Неопределено;
	Пока Истина Цикл
		Стр = Текст.ПрочитатьСтроку();
		Если Стр = Неопределено Тогда
			Прервать;
		КонецЕсли;

		Стр = НРег(Стр);
		Если Лев(Стр, 4) = "pid:" Тогда
			ProcessID = СокрЛП(Сред(Стр, 5));
		КонецЕсли;

		Если ProcessID <> Неопределено Тогда
			Если (Лев(Стр, 15) = "заголовок окна:") или (Лев(Стр, 13) = "window title:") Тогда
				МассивProcessID.Добавить(ProcessID);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	Текст.Закрыть();

	Возврат МассивProcessID;
КонецФункции

&НаКлиенте
Процедура ЗавершитьСеансыTestClientПринудительно() Экспорт
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла("txt");

	Если НЕ КонтекстЯдра.ЭтоLinux Тогда
		ИмяВременногоBat = ПолучитьИмяВременногоФайла("bat");
		ЗТ = Новый ЗаписьТекста(ИмяВременногоBat, "windows-1251", , Истина);
		ЗТ.ЗаписатьСтроку("chcp 65001");
		ЗТ.ЗаписатьСтроку("tasklist /v /fo list /fi ""imagename eq 1cv8c.exe"" > """ + ИмяВременногоФайла + """");
		ЗТ.Закрыть();

		ЗапуститьПриложение(ИмяВременногоBat, , Истина);

		Текст = Новый ЧтениеТекста;
		Текст.Открыть(ИмяВременногоФайла, "UTF-8");

		МассивProcessID = Новый Массив;
		ProcessID = Неопределено;
		Пока Истина Цикл
			Стр = Текст.ПрочитатьСтроку();
			Если Стр = Неопределено Тогда
				Прервать;
			КонецЕсли;

			Стр = НРег(Стр);
			Если Лев(Стр, 4) = "pid:" Тогда
				ProcessID = СокрЛП(Сред(Стр, 5));
			КонецЕсли;

			Если ProcessID <> Неопределено Тогда
				Если (Лев(Стр, 15) = "заголовок окна:") или (Лев(Стр, 13) = "window title:") Тогда
					Если Найти(Стр, "vanessa") = 0 Тогда
						МассивProcessID.Добавить(ProcessID);
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		Текст.Закрыть();

		Если МассивProcessID.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;

		ИмяВременногоBat = ПолучитьИмяВременногоФайла("bat");
		ЗТ = Новый ЗаписьТекста(ИмяВременногоBat, "UTF-8", , Истина);
		Стр = "taskkill /F ";
		Для каждого ProcessID Из МассивProcessID Цикл
			Стр = Стр + "/pid " + ProcessID + " ";
		КонецЦикла;
		ЗТ.ЗаписатьСтроку(Стр);
		ЗТ.Закрыть();

		ЗапуститьПриложение(ИмяВременногоBat, , Истина);

	Иначе

		СтрокаЗапуска = "kill -9 `ps aux | grep -ie TESTCLIENT | grep -ie 1cv8c | awk '{print $2}'`";
		ЗапуститьПриложение(СтрокаЗапуска);

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
// Получить массив PID процессов "1cv8.exe" и "1cv8c.exe"
//
// Параметры:
//   УчитыватьЗаголовокПриложения - Булево - учитываем только окно, у которых заголовок приложения
//		совпадает с заголовком текущего приложения
//
//  Возвращаемое значение:
//   Массив - массив PID процессов "1cv8.exe" и "1cv8c.exe"
//
Функция ПолучитьМассивPIDОкон1С(УчитыватьЗаголовокПриложения = Ложь) Экспорт
	Рез = Новый Массив;
	
	Если КонтекстЯдра.ЭтоLinux Тогда
		КонтекстЯдра.СделатьСообщение("ПолучитьМассивPIDОкон1С не доступно в Linux");
		Возврат Рез;
	КонецЕсли;

	ЗаполнитьМассивPIDПоИмениПроцесса("1cv8.exe", УчитыватьЗаголовокПриложения, Рез);
	ЗаполнитьМассивPIDПоИмениПроцесса("1cv8c.exe", УчитыватьЗаголовокПриложения, Рез);

	КонтекстЯдра.Отладка("ПолучитьМассивPIDОкон1С " + Рез.Количество());
	Возврат Рез;

КонецФункции

&НаКлиенте
Процедура СделатьОкноПроцессаАктивным(PID) Экспорт
	Если КонтекстЯдра.ЭтоLinux Тогда
		КонтекстЯдра.СделатьСообщение("СделатьОкноПроцессаАктивным не доступно в Linux");
		Возврат;
	КонецЕсли;

	WshShell = ПолучитьWshShell();

	Попытка
		WshShell.AppActivate(PID);
	Исключение
		КонтекстЯдра.СделатьСообщение(ОписаниеОшибки());
	КонецПопытки;
КонецПроцедуры

&НаКлиенте
Процедура TASKKILL(ИмяПриложения) Экспорт
	Если КонтекстЯдра.ЭтоLinux Тогда
		КонтекстЯдра.СделатьСообщение("TASKKILL не доступно в Linux");
		Возврат;
	КонецЕсли;
	СтрокаКоманды = "TASKKILL /F /IM " + ИмяПриложения;
	ВыполнитьКомандуОСБезПоказаЧерногоОкна(СтрокаКоманды);
КонецПроцедуры


// } Plugin interface

// { Helpers
&НаСервере
Функция ЭтотОбъектНаСервере()
	Возврат РеквизитФормыВЗначение("Объект");
КонецФункции

&НаКлиенте
Процедура ЗаполнитьМассивPIDПоИмениПроцесса(ИмяПроцесса, УчитыватьЗаголовокПриложения, Массив)
	Если УчитыватьЗаголовокПриложения Тогда
		Заголовок = КлиентскоеПриложение.ПолучитьЗаголовок();
		Заголовок = СтрЗаменить(Заголовок, """", "\""");
		Фильтр = "WINDOWTITLE eq " + Заголовок;
	Иначе
		Фильтр = "IMAGENAME eq " + ИмяПроцесса;
	КонецЕсли;
	ЛогФайл = ПолучитьИмяВременногоФайла("txt");
	Команда = "tasklist /FI """ + Фильтр +  """ /nh > """ + ЛогФайл + """";
	// Команда = "tasklist /FI ""IMAGENAME eq " + ИмяПроцесса +  """ /nh > """ + ЛогФайл + """";
	ВыполнитьКомандуОСБезПоказаЧерногоОкна(Команда);

	Если НЕ КонтекстЯдра.ФайлСуществуетКомандаСистемы(ЛогФайл, "ЗаполнитьМассивPIDПоИмениПроцесса") Тогда
		КонтекстЯдра.СделатьСообщение("Ошибка при получении списка процессов 1С.");
		Возврат;
	КонецЕсли;

	Текст = Новый ЧтениеТекста;
	Текст.Открыть(ЛогФайл, "UTF-8");

	Пока Истина Цикл
		Стр = Текст.ПрочитатьСтроку();
		Если Стр = Неопределено Тогда
			Прервать;
		КонецЕсли;

		Если СокрЛП(Стр) = "" Тогда
			Продолжить;
		КонецЕсли;
		КонтекстЯдра.Отладка("ЗаполнитьМассивPIDПоИмениПроцесса " + Стр);

		Стр = НРег(Стр);
		Стр = СокрЛП(СтрЗаменить(Стр, НРег(ИмяПроцесса), ""));
		Поз = Найти(Стр, " ");
		PID = Лев(Стр, Поз - 1);
		Если Найти(PID,"info") > 0 Тогда
			Продолжить;
		КонецЕсли;

		Попытка
			PID = Число(PID);
			Массив.Добавить(PID);
		Исключение
			ТекстСообщения = "Не смог преобразовать к числу PID=%1";
			ТекстСообщения = СтрЗаменить(ТекстСообщения,"%1",PID);
			КонтекстЯдра.СделатьСообщение(ТекстСообщения);
		КонецПопытки;

	КонецЦикла;

	Текст.Закрыть();

	КонтекстЯдра.УдалитьФайлыКомандаСистемы(ЛогФайл);

КонецПроцедуры

&НаКлиенте
Функция ПрочитатьФайлКакТекст(ИмяФайла, ИспользоватьКодировкуТекстаUTF8)

	Если ИспользоватьКодировкуТекстаUTF8 Тогда
		ЧТ = Новый ЧтениеТекста(ИмяФайла, КодировкаТекста.UTF8);
	Иначе
		ЧТ = Новый ЧтениеТекста(ИмяФайла);
	КонецЕсли;

	СодержимоеФайла = ЧТ.Прочитать();

	ЧТ.Закрыть();

	Возврат СодержимоеФайла;

КонецФункции

&НаКлиенте
Процедура УдалитьВременныйФайл(ИмяФайла)
	
	Если КонтекстЯдра.ЕстьПоддержкаАсинхронныхВызовов Тогда
		// для скорости не удаляем временный файл, сервер потом удалит КонтекстЯдра.УдалитьФайлыКомандаСистемы(ИмяФайла);
	Иначе
		УдалитьФайлы(ИмяФайла);
	КонецЕсли;

КонецПроцедуры

Функция ФайлСуществует(Путь)
	Файл = Новый Файл(Путь);
	Возврат Файл.Существует() И Файл.ЭтоФайл();
КонецФункции

// } Helpers
