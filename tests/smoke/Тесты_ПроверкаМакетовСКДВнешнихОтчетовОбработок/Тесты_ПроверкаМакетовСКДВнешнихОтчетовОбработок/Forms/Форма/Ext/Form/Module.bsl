﻿#Область ОписаниеПеременных

&НаКлиенте
Перем КонтекстЯдра;
&НаКлиенте
Перем Утверждения;
&НаКлиенте
Перем СтроковыеУтилиты;
&НаКлиенте
Перем КаталогиВнешнихОбработок;
&НаКлиенте
Перем КаталогиВнешнихОтчетов;
&НаКлиенте
Перем ИсключенияИзПроверок;
&НаКлиенте
Перем ВыводитьИсключения;

#КонецОбласти

#Область ИнтерфейсТестирования

&НаКлиенте
Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
	
	КонтекстЯдра = КонтекстЯдраПараметр;
	Утверждения = КонтекстЯдра.Плагин("БазовыеУтверждения");
	СтроковыеУтилиты = КонтекстЯдра.Плагин("СтроковыеУтилиты");
	
	Настройки(КонтекстЯдра, ИмяТеста());
		
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьНаборТестов(НаборТестов, КонтекстЯдраПараметр) Экспорт
	
	Инициализация(КонтекстЯдраПараметр);
	
	Если Не ВыполнятьТест(КонтекстЯдра) Тогда
		Возврат;
	КонецЕсли;
	
	Пояснение = НСтр("ru = 'Проверка макета СКД внешнего отчета/обработки'");
	
	Для Каждого КаталогВнешнихОтчетов Из КаталогиВнешнихОтчетов Цикл
		
		ИмяПроцедуры = "ТестДолжен_ПроверитьМакетСКДВнешнегоОтчета";
		Макеты = МакетыВнешнегоОбъекта("ВнешниеОтчеты", КаталогВнешнихОтчетов, "*.erf", ИмяПроцедуры);
		
		Если Не ВыводитьИсключения Тогда
			МассивТестов = УбратьИсключения(Макеты);
		Иначе
			МассивТестов = Макеты;
		КонецЕсли;
		
		Если МассивТестов.Количество() Тогда
			ИмяГруппы = СтроковыеУтилиты.ПодставитьПараметрыВСтроку("Внешние отчеты [%1]", КаталогВнешнихОтчетов);
			НаборТестов.НачатьГруппу(ИмяГруппы, Истина);
			Для Каждого Тест Из МассивТестов Цикл 
				ИмяТеста = СтроковыеУтилиты.ПодставитьПараметрыВСтроку("%1 [%2]: %3", Тест.ПолноеИмя, Тест.ИмяМакета, Пояснение);
				НаборТестов.Добавить(Тест.ИмяПроцедуры, Тест.Параметры, ИмяТеста);	
			КонецЦикла;			
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого КаталогВнешнихОбработок Из КаталогиВнешнихОбработок Цикл
		
		ИмяПроцедуры = "ТестДолжен_ПроверитьМакетСКДВнешнейОбработки";
		Макеты = МакетыВнешнегоОбъекта("ВнешниеОбработки", КаталогВнешнихОбработок, "*.epf", ИмяПроцедуры);
		
		Если Не ВыводитьИсключения Тогда
			МассивТестов = УбратьИсключения(Макеты);
		Иначе
			МассивТестов = Макеты;
		КонецЕсли;
		
		Если МассивТестов.Количество() Тогда
			ИмяГруппы = СтроковыеУтилиты.ПодставитьПараметрыВСтроку("Внешние Обработки [%1]", КаталогВнешнихОбработок);
			НаборТестов.НачатьГруппу(ИмяГруппы, Истина);
			Для Каждого Тест Из МассивТестов Цикл 
				ИмяТеста = СтроковыеУтилиты.ПодставитьПараметрыВСтроку("%1 [%2]: %3", Тест.ПолноеИмя, Тест.ИмяМакета, Пояснение);
				НаборТестов.Добавить(Тест.ИмяПроцедуры, Тест.Параметры, ИмяТеста);	
			КонецЦикла;			
		КонецЕсли;
		
	КонецЦикла;
			
КонецПроцедуры

#КонецОбласти

#Область РаботаСНастройками

&НаКлиенте
Процедура Настройки(КонтекстЯдра, Знач ПутьНастройки)

	Если ЗначениеЗаполнено(Объект.Настройки) Тогда
		Возврат;
	КонецЕсли;
	
	КаталогиВнешнихОбработок = Новый Массив;
	КаталогиВнешнихОтчетов = Новый Массив;
	ИсключенияИзПроверок = Новый Соответствие;
	ВыводитьИсключения = Истина;
	ПлагинНастроек = КонтекстЯдра.Плагин("Настройки");
	Объект.Настройки = ПлагинНастроек.ПолучитьНастройкиТеста(ПутьНастройки);
	Настройки = Объект.Настройки;
	
	Если Не ЗначениеЗаполнено(Объект.Настройки) Тогда
		Объект.Настройки = Новый Структура(ПутьНастройки, Неопределено);
		Возврат;
	КонецЕсли;
		
	Если Настройки.Свойство("КаталогиВнешнихОтчетов") Тогда
		КаталогиВнешнихОтчетов = ОбработатьОтносительныеПути(Настройки.КаталогиВнешнихОтчетов);	
	КонецЕсли;
	
	Если Настройки.Свойство("КаталогиВнешнихОбработок") Тогда
		КаталогиВнешнихОбработок = ОбработатьОтносительныеПути(Настройки.КаталогиВнешнихОбработок);
	КонецЕсли;
	
	Если Настройки.Свойство("ВыводитьИсключения") Тогда
		ВыводитьИсключения = Настройки.ВыводитьИсключения;
	КонецЕсли;
	
	Если Настройки.Свойство("ИсключенияИзПроверок") Тогда
		ИсключенияИзПроверок(Настройки);
	КонецЕсли;
			
КонецПроцедуры

&НаКлиенте
Процедура ИсключенияИзПроверок(Настройки)

	Для Каждого ИсключенияИзПроверокПоОбъектам Из Настройки.ИсключенияИзпроверок Цикл
		Для Каждого ИсключениеИзПроверок Из ИсключенияИзПроверокПоОбъектам.Значение Цикл
			ИсключенияИзПроверок.Вставить(ВРег(ИсключениеИзПроверок), Истина); 	
		КонецЦикла;
	КонецЦикла;	

КонецПроцедуры

#КонецОбласти

#Область Тесты

&НаКлиенте
Процедура ТестДолжен_ПроверитьМакетСКДВнешнегоОтчета(ИмяОтчета, ПолноеИмяОтчета, ИмяМакета) Экспорт
	
	ПропускатьТест = ПропускатьТест(ПолноеИмяОтчета);
	ДвоичныеДанные = Новый ДвоичныеДанные(ПолноеИмяОтчета);
	Адрес = ПоместитьВоВременноеХранилище(ДвоичныеДанные, ЭтотОбъект.УникальныйИдентификатор);
	
	Результат = ПроверитьМакетСКД("ВнешниеОтчеты", Адрес, ИмяМакета);
	Если Не Результат.ОтчетПодключен И ПропускатьТест.Пропустить Тогда
		Утверждения.ПропуститьТест(Результат.ТекстОшибки);
	Иначе
		Утверждения.Проверить(Результат.ОтчетПодключен, Результат.ТекстОшибки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТестДолжен_ПроверитьМакетСКДВнешнейОбработки(ИмяОбработки, ПолноеИмяОбработки, ИмяМакета) Экспорт
	
	ПропускатьТест = ПропускатьТест(ПолноеИмяОбработки);
	ДвоичныеДанные = Новый ДвоичныеДанные(ПолноеИмяОбработки);
	Адрес = ПоместитьВоВременноеХранилище(ДвоичныеДанные, ЭтотОбъект.УникальныйИдентификатор);
	
	Результат = ПроверитьМакетСКД("ВнешниеОбработки", Адрес, ИмяМакета);
	Если Не Результат.ОтчетПодключен И ПропускатьТест.Пропустить Тогда
		Утверждения.ПропуститьТест(Результат.ТекстОшибки);
	Иначе
		Утверждения.Проверить(Результат.ОтчетПодключен, Результат.ТекстОшибки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТестДолжен_ОбработатьОшибкуЗагрузкиОбъекта(ПолноеИмяОбъекта, ТекстОшибки) Экспорт
	
	ШаблонСообщения = НСтр("ru = 'Ошибка загрузки объекта ""%1"":
							|%2'");
	ТекстСообщения = СтроковыеУтилиты.ПодставитьПараметрыВСтроку(ШаблонСообщения, ПолноеИмяОбъекта, ТекстОшибки);
	ПропускатьТест = ПропускатьТест(ПолноеИмяОбъекта);
	
	Если ПропускатьТест.Пропустить Тогда
		Утверждения.ПропуститьТест(ТекстСообщения);
	Иначе
		Утверждения.Проверить(Ложь, ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьМакетСКД(ИмяМенеджера, Адрес, ИмяМакета)
	
	Менеджер = Вычислить(ИмяМенеджера);
	Результат = Новый Структура;
	Результат.Вставить("ТекстОшибки", "");
	Результат.Вставить("ОтчетПодключен", Ложь);
	
	Попытка
		ИмяФайла = ВременныйФайлОбработкиОтчета(Адрес);
		ВнешнийОбъект = Менеджер.Создать(ИмяФайла);	
		Результат.ОтчетПодключен = Истина;
		УдалитьФайлы(ИмяФайла);
	Исключение
		УдалитьФайлы(ИмяФайла);
		Результат.ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		Возврат Результат;
	КонецПопытки;
	
	СхемаКомпоновкиДанных = ВнешнийОбъект.ПолучитьМакет(СокрЛП(ИмяМакета));		
	КомпоновщикНастроекКомпоновкиДанных = Новый КомпоновщикНастроекКомпоновкиДанных;
	ИсточникДоступныхНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных);
    КомпоновщикНастроекКомпоновкиДанных.Инициализировать(ИсточникДоступныхНастроек);
	
	Возврат Результат;

КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ПропускатьТест(ПолноеИмяОбъекта)

	Результат = Новый Структура;
	Результат.Вставить("ТекстСообщения", "");
	Результат.Вставить("Пропустить", Ложь);
	
	Если ИсключенИзПроверок(ВРег(ПолноеИмяОбъекта)) Тогда
		ШаблонСообщения = НСтр("ru = 'Объект ""%1"" исключен из проверки.'");
		Результат.ТекстСообщения = СтроковыеУтилиты.ПодставитьПараметрыВСтроку(ШаблонСообщения, ПолноеИмяОбъекта);
		Результат.Пропустить = Истина;
		Возврат Результат;
	КонецЕсли;
		
	Возврат Результат;

КонецФункции 

&НаКлиенте
Функция ИсключенИзПроверок(ПолноеИмяОбъекта)
	
	Результат = ИсключенияИзПроверок.Получить(ВРег(ПолноеИмяОбъекта)) <> Неопределено;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Функция УбратьИсключения(МассивТестов)

	Результат = Новый Массив;
	
	Для Каждого Тест Из МассивТестов Цикл
		Если Не ИсключенИзПроверок(Тест.ПолноеИмя) Тогда
			Результат.Добавить(Тест);
		КонецЕсли;	
	КонецЦикла;
	
	Возврат Результат;

КонецФункции

&НаКлиенте
Функция МакетыВнешнегоОбъекта(ИмяМенеджера, Каталог, Маска, ИмяПроцедуры)
	
	Результат = Новый Массив();
	Файлы = НайтиФайлы(Каталог, Маска, Истина);
	Если Не Файлы.Количество() Тогда
		ШаблонСообщения = НСтр("ru = '%1: Не удалось найти файлы в каталоге ""%2""'");
		ТекстСообщения = СтроковыеУтилиты.ПодставитьПараметрыВСтроку(ШаблонСообщения, ИмяТеста(), Каталог);
		КонтекстЯдра.ВывестиСообщение(ТекстСообщения);
		Возврат Результат;
	КонецЕсли;
	
	Для Каждого Файл Из Файлы Цикл 
		
		ДвоичныеДанные = Новый ДвоичныеДанные(Файл.ПолноеИмя);
		Адрес = ПоместитьВоВременноеХранилище(ДвоичныеДанные, ЭтотОбъект.УникальныйИдентификатор);
		
		мПараметры = Новый Структура;
		мПараметры.Вставить("Адрес", Адрес);
		мПараметры.Вставить("ИмяМенеджера", ИмяМенеджера);
		мПараметры.Вставить("ИмяФайла", Файл.Имя);
		мПараметры.Вставить("ПолноеИмя", Файл.ПолноеИмя);
		мПараметры.Вставить("ИмяПроцедуры", ИмяПроцедуры);
		
		Макеты = МакетыВнешнегоОбъектаСервер(мПараметры);
		
		Для Каждого Макет Из Макеты Цикл
			Результат.Добавить(Макет);
		КонецЦикла;
		
	КонецЦикла;			

	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция МакетыВнешнегоОбъектаСервер(Параметры)
	
	Результат = Новый Массив();
	Менеджер = Вычислить(Параметры.ИмяМенеджера);
	
	Попытка
		ИмяВременногоФайла = ВременныйФайлОбработкиОтчета(Параметры.Адрес);
		МетаданныеФайла = Менеджер.Создать(ИмяВременногоФайла).Метаданные();
		УдалитьФайлы(ИмяВременногоФайла);
	Исключение
		
		УдалитьФайлы(ИмяВременногоФайла);
		ТекстОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		
		ПараметрыТеста = Новый Массив;
		ПараметрыТеста.Добавить(Параметры.ПолноеИмя);
		ПараметрыТеста.Добавить(ТекстОшибки);
		
		СтруктураТеста = Новый Структура;
		СтруктураТеста.Вставить("ИмяФайла", Параметры.ИмяФайла);
		СтруктураТеста.Вставить("ПолноеИмя", Параметры.ПолноеИмя);
		СтруктураТеста.Вставить("ИмяМакета", "");
		СтруктураТеста.Вставить("ИмяПроцедуры", "ТестДолжен_ОбработатьОшибкуЗагрузкиОбъекта");
		СтруктураТеста.Вставить("Параметры", ПараметрыТеста);
		
		Результат.Добавить(СтруктураТеста);
		Возврат Результат;
		
	КонецПопытки;
	
	Для Каждого Макет Из МетаданныеФайла.Макеты Цикл
		
		Если Макет.ТипМакета <> Метаданные.СвойстваОбъектов.ТипМакета.СхемаКомпоновкиДанных Тогда
			Продолжить;
		КонецЕсли;
		
		ПараметрыТеста = Новый Массив;
		ПараметрыТеста.Добавить(Параметры.ИмяФайла);
		ПараметрыТеста.Добавить(Параметры.ПолноеИмя);
		ПараметрыТеста.Добавить(Макет.Имя);
		
		СтруктураТеста = Новый Структура;
		СтруктураТеста.Вставить("ИмяФайла", Параметры.ИмяФайла);
		СтруктураТеста.Вставить("ПолноеИмя", Параметры.ПолноеИмя);
		СтруктураТеста.Вставить("ИмяМакета", Макет.Имя);
		СтруктураТеста.Вставить("ИмяПроцедуры", Параметры.ИмяПроцедуры);
		СтруктураТеста.Вставить("Параметры", ПараметрыТеста);
		Результат.Добавить(СтруктураТеста);
		
	КонецЦикла;
	
	Возврат Результат;
			
КонецФункции

&НаСервереБезКонтекста
Функция ВременныйФайлОбработкиОтчета(Адрес)
	
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(Адрес);
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла();
	ДвоичныеДанные.Записать(ИмяВременногоФайла);		
	
	Возврат ИмяВременногоФайла;

КонецФункции

&НаКлиенте
Функция ОбработатьОтносительныеПути(Знач ОтносительныеПути)

	Результат = Новый Массив;
	
	Для Каждого ОтносительныйПуть Из ОтносительныеПути Цикл
		
		Если Лев(ОтносительныйПуть, 1) = "." И ЗначениеЗаполнено(КонтекстЯдра.Объект.КаталогПроекта) Тогда
			ОтносительныйПуть = СтроковыеУтилиты.ПодставитьПараметрыВСтроку(
									"%1%2", 
									КонтекстЯдра.Объект.КаталогПроекта, 
									Сред(ОтносительныйПуть, 2));
		КонецЕсли;
		
		ОтносительныйПуть = СтрЗаменить(ОтносительныйПуть, "\\", "\");
		
		Если Результат.Найти(ОтносительныйПуть) = Неопределено Тогда
			Результат.Добавить(ОтносительныйПуть);
		КонецЕсли;
	
	КонецЦикла;
	
	Возврат Результат;

КонецФункции 

&НаКлиенте
Функция ИмяТеста()
	
	Если Не ЗначениеЗаполнено(Объект.ИмяТеста) Тогда
		Объект.ИмяТеста = ИмяТестаНаСервере();
	КонецЕсли;
	
	Возврат Объект.ИмяТеста;
	
КонецФункции

&НаСервере
Функция ИмяТестаНаСервере()
	Возврат РеквизитФормыВЗначение("Объект").Метаданные().Имя;
КонецФункции

&НаКлиенте
Функция ВыполнятьТест(КонтекстЯдра)
	
	ВыполнятьТест = Ложь;
	Настройки(КонтекстЯдра, ИмяТеста());
	Настройки = Объект.Настройки;
	
	Если Не ЗначениеЗаполнено(Настройки) Тогда
		Возврат ВыполнятьТест;
	КонецЕсли;
		
	Если ТипЗнч(Настройки) = Тип("Структура") И Настройки.Свойство("Используется") Тогда
		ВыполнятьТест = Настройки.Используется;	
	КонецЕсли;
	
	Возврат ВыполнятьТест;

КонецФункции

&НаСервереБезКонтекста
Процедура ЗаписатьИнформациюВЖурналРегистрации(Знач Комментарий)
	ЗаписьЖурналаРегистрации(ИмяСобытия(), УровеньЖурналаРегистрации.Информация,,, Комментарий);
КонецПроцедуры
  
&НаСервереБезКонтекста
Процедура ЗаписатьПредупреждениеВЖурналРегистрацииСервер(Комментарий)
	ЗаписьЖурналаРегистрации(ИмяСобытия(), УровеньЖурналаРегистрации.Предупреждение, , , Комментарий);
КонецПроцедуры
	
&НаСервереБезКонтекста
Процедура ЗаписатьОшибкуВЖурналРегистрации(Комментарий)
	ЗаписьЖурналаРегистрации(ИмяСобытия(), УровеньЖурналаРегистрации.Ошибка, , , Комментарий);
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИмяСобытия()
	Возврат "VanessaADD.Дымовые.Тесты_ПроверкаМакетовСКДВнешнихОтчетовОбработок"; // по аналогии с другими тестами
КонецФункции
#КонецОбласти