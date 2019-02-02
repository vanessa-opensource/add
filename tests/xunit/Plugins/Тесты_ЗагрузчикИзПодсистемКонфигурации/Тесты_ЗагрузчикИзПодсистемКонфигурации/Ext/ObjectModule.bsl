﻿Перем КонтекстЯдра;
Перем Ожидаем;

Перем ЗагрузчикИзПодсистемКонфигурации;
Перем ТипыУзловДереваТестов;

Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
	КонтекстЯдра = КонтекстЯдраПараметр;
	Ожидаем = КонтекстЯдра.Плагин("УтвержденияBDD");
	ЗагрузчикИзПодсистемКонфигурации = КонтекстЯдра.Плагин("ЗагрузчикИзПодсистемКонфигурации");
	ТипыУзловДереваТестов = КонтекстЯдра.Плагин("ПостроительДереваТестов").ТипыУзловДереваТестов;
КонецПроцедуры

Функция ПолучитьСписокТестов() Экспорт
	ВсеТесты = Новый Массив;
	ВсеТесты.Добавить("ТестДолжен_Загрузить_Подсистему_Тестовая");
	ВсеТесты.Добавить("ТестДолжен_ВыполнитьТесты_Подсистемы_Тестовая");
	
	// Проверка загрузки тестовых обработок с новым API
	ВсеТесты.Добавить("ТестДолжен_Загрузить_ОбработкуСНовымAPI");
	ВсеТесты.Добавить("ТестДолжен_Сформировать_ПараметрыТеста_Простые");
	ВсеТесты.Добавить("ТестДолжен_Сформировать_ПараметрыТеста_СНеопределеноВСередине");
	ВсеТесты.Добавить("ТестДолжен_Сформировать_ПараметрыТеста_СНесколькимиНеопределеноВНачале");
	ВсеТесты.Добавить("ТестДолжен_Сформировать_ПараметрыТеста_СЕдинственнымПараметромНеопределено");
	
	Возврат ВсеТесты;
КонецФункции

Процедура ТестДолжен_Загрузить_Подсистему_Тестовая() Экспорт
	ИмяПодсистемы = "Тестовая";
	ДеревоТестов = ЗагрузчикИзПодсистемКонфигурации.Загрузить(КонтекстЯдра, "Метаданные.Подсистемы." + ИмяПодсистемы);
	
	Ожидаем.Что(ДеревоТестов).ИмеетТип("Структура");
	Ожидаем.Что(ДеревоТестов.Имя).Равно(ИмяПодсистемы);
	Ожидаем.Что(ДеревоТестов.Тип).Равно(ТипыУзловДереваТестов.Контейнер);
	
	Ожидаем.Что(ДеревоТестов.Строки).ИмеетДлину(4);
КонецПроцедуры

Процедура ТестДолжен_ВыполнитьТесты_Подсистемы_Тестовая() Экспорт
	ИмяПодсистемы = "Тестовая";
	ДеревоТестов = ЗагрузчикИзПодсистемКонфигурации.Загрузить(КонтекстЯдра, "Метаданные.Подсистемы." + ИмяПодсистемы);
	
	РезультатыТестирования = КонтекстЯдра.ВыполнитьТесты(ЗагрузчикИзПодсистемКонфигурации, ДеревоТестов);
	
	Ожидаем.Что(РезультатыТестирования.КоличествоТестов, "КоличествоТестов").Равно(11);
	Ожидаем.Что(РезультатыТестирования.КоличествоСломанныхТестов, "КоличествоСломанныхТестов").Равно(0);
	Ожидаем.Что(РезультатыТестирования.КоличествоНеРеализованныхТестов, "КоличествоНеРеализованныхТестов").Равно(0);
КонецПроцедуры

// { Проверка загрузки тестовых обработок с новым API
Процедура ТестДолжен_Загрузить_ОбработкуСНовымAPI() Экспорт
	ПутьОбработкиСНовымAPI = "Метаданные.Обработки.Тест_ЗагрузчикИзПодсистем_НовыйAPIОбъявленияТестов";
	ДеревоТестов = ЗагрузчикИзПодсистемКонфигурации.Загрузить(КонтекстЯдра, ПутьОбработкиСНовымAPI);
	
	ТестыОбработкиСНовымAPI = ДеревоТестов;
	
	Ожидаем.Что(ТестыОбработкиСНовымAPI.СлучайныйПорядокВыполнения, "ТестыОбработкиСНовымAPI порядок выполнения").ЭтоИстина();
	Ожидаем.Что(ТестыОбработкиСНовымAPI.Строки, "ТестыОбработкиСНовымAPI количество дочерних узлов").ИмеетДлину(4);
	
	Элемент1 = ТестыОбработкиСНовымAPI.Строки[0];
	Ожидаем.Что(Элемент1.Тип, "Элемент1.Тип").Равно(КонтекстЯдра.ТипыУзловДереваТестов.Элемент);
	Ожидаем.Что(Элемент1.Путь, "Элемент1.Путь").Равно(ПутьОбработкиСНовымAPI);
	Ожидаем.Что(Элемент1.ИмяМетода, "Элемент1.ИмяМетода").Равно("ТестДолжен_ПроверитьВыполнение_ПростогоТеста");
	
	ДочернийКонтейнер1 = ТестыОбработкиСНовымAPI.Строки[1];
	Ожидаем.Что(ДочернийКонтейнер1.Тип, "ДочернийКонтейнер1.Тип").Равно(КонтекстЯдра.ТипыУзловДереваТестов.Контейнер);
	Ожидаем.Что(ДочернийКонтейнер1.СлучайныйПорядокВыполнения, "ДочернийКонтейнер1 порядок выполнения").ЭтоИстина();
	Ожидаем.Что(ДочернийКонтейнер1.Имя, "ДочернийКонтейнер1.Имя").Равно("Группа со случайным порядком выполнения");
	Ожидаем.Что(ДочернийКонтейнер1.Строки, "ДочернийКонтейнер1.Строки").ИмеетТип("Массив").ИмеетДлину(2);
	
	ДочернийКонтейнер2 = ТестыОбработкиСНовымAPI.Строки[2];
	Ожидаем.Что(ДочернийКонтейнер2.Тип, "ДочернийКонтейнер2.Тип").Равно(КонтекстЯдра.ТипыУзловДереваТестов.Контейнер);
	Ожидаем.Что(ДочернийКонтейнер2.СлучайныйПорядокВыполнения, "ДочернийКонтейнер2 порядок выполнения").ЭтоЛожь();
	Ожидаем.Что(ДочернийКонтейнер2.Имя, "ДочернийКонтейнер2.Имя").Равно("Группа со строгим порядком выполнения");
	Ожидаем.Что(ДочернийКонтейнер2.Строки, "ДочернийКонтейнер2.Строки").ИмеетТип("Массив").ИмеетДлину(2);
	
	ДочернийКонтейнер3 = ТестыОбработкиСНовымAPI.Строки[3];
	Ожидаем.Что(ДочернийКонтейнер3.Тип, "ДочернийКонтейнер3.Тип").Равно(КонтекстЯдра.ТипыУзловДереваТестов.Контейнер);
	Ожидаем.Что(ДочернийКонтейнер3.СлучайныйПорядокВыполнения, "ДочернийКонтейнер3 порядок выполнения").ЭтоЛожь();
	Ожидаем.Что(ДочернийКонтейнер3.Имя, "ДочернийКонтейнер3.Имя").Равно("Группа параметризированных тестов со строгим порядком выполнения");
	Ожидаем.Что(ДочернийКонтейнер3.Строки, "ДочернийКонтейнер3.Строки").ИмеетТип("Массив").ИмеетДлину(2);
КонецПроцедуры

Процедура ТестДолжен_Сформировать_ПараметрыТеста_Простые() Экспорт
	Параметры = ЗагрузчикИзПодсистемКонфигурации.ПараметрыТеста(1, 2, 3, 4, 5, 6, 7, 8, 9);
	Ожидаем.Что(Параметры, "Параметры").ИмеетТип("Массив").ИмеетДлину(9);
	Ожидаем.Что(Параметры[0], "Параметры[0]").Равно(1);
	Ожидаем.Что(Параметры[4], "Параметры[0]").Равно(5);
	Ожидаем.Что(Параметры[8], "Параметры[0]").Равно(9);
КонецПроцедуры

Процедура ТестДолжен_Сформировать_ПараметрыТеста_СНеопределеноВСередине() Экспорт
	Параметры = ЗагрузчикИзПодсистемКонфигурации.ПараметрыТеста(Истина, , Ложь);
	Ожидаем.Что(Параметры, "Параметры").ИмеетДлину(3);
	Ожидаем.Что(Параметры[0], "Параметры[0]").ЭтоИстина();
	Ожидаем.Что(Параметры[1], "Параметры[1]").ЭтоНеопределено();
	Ожидаем.Что(Параметры[2], "Параметры[2]").ЭтоЛожь();
КонецПроцедуры

Процедура ТестДолжен_Сформировать_ПараметрыТеста_СНесколькимиНеопределеноВНачале() Экспорт
	Параметры = ЗагрузчикИзПодсистемКонфигурации.ПараметрыТеста(, , Истина, Ложь);
	Ожидаем.Что(Параметры, "Параметры").ИмеетДлину(4);
	Ожидаем.Что(Параметры[0], "Параметры[0]").ЭтоНеопределено();
	Ожидаем.Что(Параметры[1], "Параметры[1]").ЭтоНеопределено();
	Ожидаем.Что(Параметры[2], "Параметры[2]").ЭтоИстина();
	Ожидаем.Что(Параметры[3], "Параметры[3]").ЭтоЛожь();
КонецПроцедуры

Процедура ТестДолжен_Сформировать_ПараметрыТеста_СЕдинственнымПараметромНеопределено() Экспорт
	Параметры = ЗагрузчикИзПодсистемКонфигурации.ПараметрыТеста(Неопределено);
	Ожидаем.Что(Параметры, "Параметры").ИмеетДлину(1);
	Ожидаем.Что(Параметры[0], "Параметры[0]").ЭтоНеопределено();
КонецПроцедуры
// } Проверка загрузки тестовых обработок с новым API
