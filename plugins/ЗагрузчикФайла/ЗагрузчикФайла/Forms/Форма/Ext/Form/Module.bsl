﻿&НаКлиенте
Перем КэшПостроительДереваТестов;
&НаКлиенте
Перем ЗагружаемыйПуть;

&НаКлиенте
Перем КонтейнерТестов;
&НаКлиенте
Перем ТекущаяГруппа;

// { Plugin interface
&НаКлиенте
Функция ОписаниеПлагина(ВозможныеТипыПлагинов) Экспорт
	Возврат ОписаниеПлагинаНаСервере(ВозможныеТипыПлагинов);
КонецФункции

&НаКлиенте
Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
КонецПроцедуры

&НаСервере
Функция ОписаниеПлагинаНаСервере(ВозможныеТипыПлагинов)
	Возврат ЭтотОбъектНаСервере().ОписаниеПлагина(ВозможныеТипыПлагинов);
КонецФункции
// } Plugin interface

// { Loader interface
&НаКлиенте
Функция ВыбратьПутьИнтерактивно(КонтекстЯдра, ТекущийПуть = "") Экспорт
	
	ДиалогВыбораТеста = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогВыбораТеста.Фильтр = "Обработка-тест (*.epf)|*.epf|Отчет-тест (*.erf)|*.erf|Все файлы|*";
	ДиалогВыбораТеста.МножественныйВыбор = Истина;
	ДиалогВыбораТеста.ПроверятьСуществованиеФайла = Истина;
	ДиалогВыбораТеста.ПолноеИмяФайла = ТекущийПуть;
	
	Результат = Новый ТекстовыйДокумент;
	ДиалогВыбораТеста.Показать(Новый ОписаниеОповещения("ВыбратьПутьИнтерактивноЗавершение", ЭтаФорма, 
		Новый Структура("ДиалогВыбораТеста, Результат, КонтекстЯдра", ДиалогВыбораТеста, Результат, КонтекстЯдра)));
		
КонецФункции

&НаКлиенте
Функция Загрузить(КонтекстЯдра, Путь) Экспорт
	
	ПолноеИмяБраузераТестов = КонтекстЯдра.Объект.ПолноеИмяБраузераТестов;
	
	ПостроительДереваТестов = КонтекстЯдра.Плагин("ПостроительДереваТестов");
	ДеревоТестов = Неопределено;
	Для Сч = 1 По СтрЧислоСтрок(Путь) Цикл
		ФайлОбработки = Новый Файл(СтрПолучитьСтроку(Путь, Сч));
		ПроверитьКорректностьФайла(ФайлОбработки);
		
		Если ДеревоТестов = Неопределено Тогда
			ДеревоТестов = ПостроительДереваТестов.СоздатьКонтейнер(ФайлОбработки.Путь);
		КонецЕсли;
		
		КонтекстЯдра.ПодключитьВнешнююОбработку(ФайлОбработки);
		
		КонтейнерССервернымиТестамиОбработки = ЗагрузитьФайлНаСервере(ФайлОбработки.ПолноеИмя);
		КонтейнерСКлиентскимиТестамиОбработки = ЗагрузитьФайлНаКлиенте(ПостроительДереваТестов, ФайлОбработки, КонтекстЯдра);
		Если КонтейнерСКлиентскимиТестамиОбработки.Строки.Количество() > 0 Тогда
			КонтейнерССервернымиТестамиОбработки.Строки.Добавить(КонтейнерСКлиентскимиТестамиОбработки);
		КонецЕсли;
		Если КонтейнерССервернымиТестамиОбработки.Строки.Количество() > 0 Тогда
			ДеревоТестов.Строки.Добавить(КонтейнерССервернымиТестамиОбработки);
		КонецЕсли;
	КонецЦикла;
	
	Возврат ДеревоТестов;
КонецФункции

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
	ПрефиксПутейСФормами = ПрефиксПутейСФормами();
	ФайлОбработки = Новый Файл(Сред(Путь, СтрДлина(ПрефиксПутейСФормами) + 1));
	ПроверитьКорректностьФайла(ФайлОбработки);
	КонтекстЯдра.ПодключитьВнешнююОбработку(ФайлОбработки);
	Контекст = ПолучитьФорму("ВнешняяОбработка." + ФайлОбработки.ИмяБезРасширения + ".Форма", , ЭтаФорма, Новый УникальныйИдентификатор);
	Если ПеременнаяСодержитСвойство(Контекст, "ПутьКФайлуПолный") Тогда
		Контекст.ПутьКФайлуПолный = ФайлОбработки.ПолноеИмя; 	
	КонецЕсли;
	
	Возврат Контекст;
КонецФункции

&НаКлиенте
Функция ПолучитьСерверныйКонтекст(КонтекстЯдра, Путь)
	ФайлОбработки = Новый Файл(Путь);
	ПроверитьКорректностьФайла(ФайлОбработки);
	КонтекстЯдра.ПодключитьВнешнююОбработку(ФайлОбработки);
	Контекст = КонтекстЯдра.ПолучитьОписаниеКонтекстаВыполнения(ФайлОбработки.ИмяБезРасширения);
	
	Возврат Контекст;
КонецФункции

&НаКлиенте
Процедура ПроверитьКорректностьФайла(Файл)
	Если Не Файл.Существует() Тогда
		ВызватьИсключение "Переданный файл не существует файл <" + Файл.ПолноеИмя + ">";
	КонецЕсли;
	Если Файл.ЭтоКаталог() Тогда
		ВызватьИсключение "Передан каталог вместо файла <" + Файл.ПолноеИмя + ">";
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ЗагрузитьФайлНаСервере(ПолныйПутьКОбработкеНаКлиенте)
	
	КонтекстЯдра = ПолучитьКонтекстЯдраНаСервере();
	
	ПостроительДереваТестов = КонтекстЯдра.СоздатьОбъектПлагина("ПостроительДереваТестов");	
	ФайлОбработки = Новый Файл(ПолныйПутьКОбработкеНаКлиенте);
	Контейнер = ЭтотОбъектНаСервере().ЗагрузитьФайл(ПостроительДереваТестов, ФайлОбработки, КонтекстЯдра);
	
	Возврат Контейнер;
КонецФункции

&НаКлиенте
Функция ЗагрузитьФайлНаКлиенте(ПостроительДереваТестов, ФайлОбработки, КонтекстЯдра)
	
	ЭтоФайлОтчета = (НРег(ФайлОбработки.Расширение) = ".erf");
	
	Если ЭтоФайлОтчета Тогда
		ФормаОбработки = ПолучитьФорму("ВнешнийОтчет." + ФайлОбработки.ИмяБезРасширения + ".Форма");
	Иначе
		ФормаОбработки = ПолучитьФорму("ВнешняяОбработка." + ФайлОбработки.ИмяБезРасширения + ".Форма");
	КонецЕсли;
	
	Попытка
		Контейнер = ЗагрузитьТестыВНовомФормате_НаКлиенте(ПостроительДереваТестов, ФормаОбработки, ФайлОбработки, КонтекстЯдра);
	Исключение
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		Если ЭтоНовыйФорматОбработки(ТекстОшибки) Тогда
			ВызватьИсключение;
		Иначе
			Контейнер = ЗагрузитьТестыВСтаромФормате_НаКлиенте(ПостроительДереваТестов, ФормаОбработки, ФайлОбработки);
		КонецЕсли;
	КонецПопытки;
	
	Возврат Контейнер;
КонецФункции

&НаКлиенте
Функция ЗагрузитьТестыВНовомФормате_НаКлиенте(ПостроительДереваТестов, ФормаОбработки, ФайлОбработки, КонтекстЯдра)
	ЗагружаемыйПуть = ФайлОбработки.ПолноеИмя;
	КэшПостроительДереваТестов = ПостроительДереваТестов;
	КонтейнерТестов = ПостроительДереваТестов.СоздатьКонтейнер(ПрефиксПутейСФормами() + ФайлОбработки.ИмяБезРасширения, ПостроительДереваТестов.Объект.ИконкиУзловДереваТестов.Форма);
	Попытка
		ФормаОбработки.ЗаполнитьНаборТестов(ЭтаФорма, КонтекстЯдра);
	Исключение
		Инфо = ИнформацияОбОшибке();
		Если Инфо.ИмяМодуля = "ВнешняяОбработка.ЗагрузчикФайла.Форма.Форма.Форма" И
			Инфо.Описание = "Слишком много фактических параметров" И
			Найти(Инфо.ИсходнаяСтрока, "ФормаОбработки.ЗаполнитьНаборТестов(ЭтаФорма, КонтекстЯдра);") > 0
			Тогда
				
				ФормаОбработки.ЗаполнитьНаборТестов(ЭтаФорма);
			Иначе
				ВызватьИсключение;
			КонецЕсли;
	КонецПопытки;
	Результат = КонтейнерТестов;
	КонтейнерТестов = Неопределено;
	ТекущаяГруппа = Неопределено;
	
	Возврат Результат;
КонецФункции

&НаКлиенте
Функция ЭтоНовыйФорматОбработки(Знач ТекстОшибки)
	ЭтоНовыйФорматОбработки = Не ЕстьОшибка_МетодОбъектаНеОбнаружен(ТекстОшибки, "ЗаполнитьНаборТестов");
	
	Возврат ЭтоНовыйФорматОбработки;
КонецФункции

&НаКлиенте
Функция ЗагрузитьТестыВСтаромФормате_НаКлиенте(ПостроительДереваТестов, ФормаОбработки, ФайлОбработки)
	Попытка
		СписокТестов = ФормаОбработки.ПолучитьСписокТестов();
	Исключение
		Описание = ОписаниеОшибки();
		Если Найти(Описание, "Недостаточно фактических параметров") > 0 Тогда
			ВызватьИсключение "Старый формат тестов в обработке тестов <"+ФайлОбработки.ПолноеИмя+">."+Символы.ПС+
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
	
	ИмяКонтейнера = ПрефиксПутейСФормами() + ФайлОбработки.ИмяБезРасширения;
	Путь = ПрефиксПутейСФормами() + ФайлОбработки.ПолноеИмя;
	Контейнер = ПолучитьКонтейнерДереваТестовПоСпискуТестовНаСервере(СписокТестов, ИмяКонтейнера, Путь, СлучайныйПорядокВыполнения);
	Контейнер.ИконкаУзла = ПостроительДереваТестов.Объект.ИконкиУзловДереваТестов.Форма;
	
	Возврат Контейнер;
КонецФункции

&НаСервере
Функция ПолучитьКонтейнерДереваТестовПоСпискуТестовНаСервере(СписокТестов, ИмяКонтейнера, Путь, СлучайныйПорядокВыполнения = Истина)
	
	КонтекстЯдра = ПолучитьКонтекстЯдраНаСервере();
	
	ПостроительДереваТестов = КонтекстЯдра.СоздатьОбъектПлагина("ПостроительДереваТестов");
	Контейнер = ЭтотОбъектНаСервере().ПолучитьКонтейнерДереваТестовПоСпискуТестов(ПостроительДереваТестов, СписокТестов, ИмяКонтейнера, Путь, СлучайныйПорядокВыполнения);
	
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
	ТекущаяГруппа = КэшПостроительДереваТестов.СоздатьКонтейнер(ИмяГруппы, КэшПостроительДереваТестов.Объект.ИконкиУзловДереваТестов.Группа);
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
	Элемент = КэшПостроительДереваТестов.СоздатьЭлемент(ПрефиксПутейСФормами() + ЗагружаемыйПуть, ИмяМетода, Представление);
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
		ИЛИ Найти(текстОшибки, "Object method not found (" + ИмяМетода + ")") > 0  Тогда
		Результат = Истина;
	КонецЕсли;
	
	Возврат Результат;
КонецФункции
// } Helpers

// Универсальная функция для проверки наличия 
// свойств у значения любого типа данных
// Переменные:
// 1. Переменная - переменная любого типа, 
// для которой необходимо проверить наличие свойства
// 2. ИмяСвойства - переменная типа "Строка", 
// содержащая искомое свойства
// 
&НаКлиентеНаСервереБезКонтекста
Функция ПеременнаяСодержитСвойство(Переменная, ИмяСвойства)
     // Инициализируем структуру для теста 
     // с ключом (значение переменной "ИмяСвойства") 
     // и значением произвольного GUID'а
     GUIDПроверка = Новый УникальныйИдентификатор;
     СтруктураПроверка = Новый Структура;
     СтруктураПроверка.Вставить(ИмяСвойства, GUIDПроверка);
     // Заполняем созданную структуру из переданного 
     // значения переменной
     ЗаполнитьЗначенияСвойств(СтруктураПроверка, Переменная);
     // Если значение для свойства структуры осталось 
     // NULL, то искомое свойство не найдено, 
     // и наоборот.
     Если СтруктураПроверка[ИмяСвойства] = GUIDПроверка Тогда
          Возврат Ложь;
     Иначе
          Возврат Истина;
     КонецЕсли;
КонецФункции

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
Процедура ВыбратьПутьИнтерактивноЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДиалогВыбораТеста = ДополнительныеПараметры.ДиалогВыбораТеста;
	Результат = ДополнительныеПараметры.Результат;
	КонтекстЯдра = ДополнительныеПараметры.КонтекстЯдра;
	
	Если (ВыбранныеФайлы <> Неопределено) Тогда
		Для каждого ПолноеИмяФайла Из ДиалогВыбораТеста.ВыбранныеФайлы Цикл
			Результат.ДобавитьСтроку(ПолноеИмяФайла);
		КонецЦикла;		
	КонецЕсли;
	Текст = Результат.ПолучитьТекст();
	
	Текст = Лев(Текст, СтрДлина(Текст) - 1);
	
	Описание = ОписаниеПлагина(КонтекстЯдра.Объект.ТипыПлагинов);
	КонтекстЯдра.ЗагрузитьТесты(Описание.Идентификатор, Текст);

КонецПроцедуры
// } Вспомогательные методы