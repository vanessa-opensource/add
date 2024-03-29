﻿Перем СтатусыРезультатаТестирования;

Функция ОписаниеПлагина(КонтекстЯдра, ВозможныеТипыПлагинов) Экспорт
	Результат = Новый Структура;
	Результат.Вставить("Тип", ВозможныеТипыПлагинов.Утилита);
	Результат.Вставить("Идентификатор", "БазовыеУтверждения");
	Результат.Вставить("Представление", "Базовый набор утверждений");
	
	Возврат Новый ФиксированнаяСтруктура(Результат);
КонецФункции

Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
КонецПроцедуры

//{ МЕТОДЫ ДЛЯ ПРОВЕРКИ ЗНАЧЕНИЙ (assertions). 

Процедура Проверить(_Истина, ДопСообщениеОшибки = "") Экспорт
	Если Не _Истина Тогда
		СообщениеОшибки = "Переданный параметр ("+Формат(_Истина, "БЛ=ложь; БИ=истина")+") не является Истиной, а хотели, чтобы являлся." + ФорматДСО(ДопСообщениеОшибки);
		ВызватьОшибкуПроверки(СообщениеОшибки);
	КонецЕсли;
КонецПроцедуры

Процедура ПроверитьИстину(_Истина, ДопСообщениеОшибки = "") Экспорт
	Проверить(_Истина, ДопСообщениеОшибки);
КонецПроцедуры

Процедура ПроверитьЛожь(_Ложь, ДопСообщениеОшибки = "") Экспорт
	Если _Ложь Тогда
		СообщениеОшибки = "Переданный параметр ("+Формат(_Ложь, "БЛ=ложь; БИ=истина")+") не является Ложью, а хотели, чтобы являлся." + ФорматДСО(ДопСообщениеОшибки);
		ВызватьОшибкуПроверки(СообщениеОшибки);
	КонецЕсли;
КонецПроцедуры

Процедура ПроверитьДату(_Дата, _Период, ДопСообщениеОшибки = "") Экспорт
	Если _Дата < _Период.ДатаНачала или _Дата > _Период.ДатаОкончания Тогда
		представление = ПредставлениеПериода(_Период.ДатаНачала, _Период.ДатаОкончания, "ФП = Истина");
		СообщениеОшибки = "Переданный параметр ("+Формат(_Дата, "ДФ='dd.MM.yyyy HH:mm:ss'")+") не входит в период "+представление+", а хотели, чтобы являлся." + ФорматДСО(ДопСообщениеОшибки);
		ВызватьОшибкуПроверки(СообщениеОшибки);
	КонецЕсли;
КонецПроцедуры

Процедура ПроверитьРавенствоДатСТочностью2Секунды(_Дата, _Дата2, ДопСообщениеОшибки = "") Экспорт
	Если _Дата < _Дата2-2 или _Дата > _Дата2+2 Тогда
		СообщениеОшибки = "Переданная дата ("+Формат(_Дата, "ДФ='dd.MM.yyyy HH:mm:ss'")+") не равна дате ("+Формат(_Дата2, "ДФ='dd.MM.yyyy HH:mm:ss'")+") с точностью до 2-х секунд, а хотели, чтобы они равнялись." + ФорматДСО(ДопСообщениеОшибки);
		ВызватьОшибкуПроверки(СообщениеОшибки);
	КонецЕсли;
КонецПроцедуры

Процедура ПроверитьРавенство(_1, _2, ДопСообщениеОшибки = "") Экспорт
	Если _1 <> _2 Тогда
		СообщениеОшибки = "Сравниваемые значения ("+_1+"; "+_2+") не равны, а хотели, чтобы были равны." + ФорматДСО(ДопСообщениеОшибки);
		ВызватьОшибкуПроверки(СообщениеОшибки);
	КонецЕсли;
КонецПроцедуры

Процедура ПроверитьНеРавенство(_1, _2, ДопСообщениеОшибки = "") Экспорт
	Если _1 = _2 Тогда
		СообщениеОшибки = "Сравниваемые значения ("+_1+"; "+_2+") равны, а хотели, чтобы были не равны." + ФорматДСО(ДопСообщениеОшибки);
		ВызватьОшибкуПроверки(СообщениеОшибки);
	КонецЕсли;
КонецПроцедуры

Процедура ПроверитьБольше(_Больше, _Меньше, ДопСообщениеОшибки = "") Экспорт
	Если _Больше <= _Меньше Тогда
		СообщениеОшибки = "Первый параметр ("+_Больше+") меньше или равен второму ("+_Меньше+") а хотели, чтобы был больше." + ФорматДСО(ДопСообщениеОшибки);
		ВызватьОшибкуПроверки(СообщениеОшибки);
	КонецЕсли;
КонецПроцедуры

Процедура ПроверитьБольшеИлиРавно(_Больше, _Меньше, ДопСообщениеОшибки = "") Экспорт
	Если _Больше < _Меньше Тогда
		СообщениеОшибки = "Первый параметр ("+_Больше+") меньше второго ("+_Меньше+") а хотели, чтобы был больше или равен." + ФорматДСО(ДопСообщениеОшибки);
		ВызватьОшибкуПроверки(СообщениеОшибки);
	КонецЕсли;
КонецПроцедуры

Процедура ПроверитьМеньше(проверяемоеЗначение1, проверяемоеЗначение2, СообщениеОбОшибке = "") Экспорт
	Если проверяемоеЗначение1 >= проверяемоеЗначение2 Тогда
		СообщениеОшибки = "Значение <"+проверяемоеЗначение1+"> больше или равно, чем <"+проверяемоеЗначение2+">, а ожидалось меньше"+
				ФорматДСО(СообщениеОбОшибке);
		ВызватьОшибкуПроверки(СообщениеОшибки)
	КонецЕсли;
КонецПроцедуры

Процедура ПроверитьМеньшеИлиРавно(проверяемоеЗначение1, проверяемоеЗначение2, СообщениеОбОшибке = "") Экспорт
	Если проверяемоеЗначение1 > проверяемоеЗначение2 Тогда
		СообщениеОшибки = "Значение <"+проверяемоеЗначение1+"> больше, чем <"+проверяемоеЗначение2+">, а ожидалось меньше или равно"+
				ФорматДСО(СообщениеОбОшибке);
		ВызватьОшибкуПроверки(СообщениеОшибки)
	КонецЕсли; 
КонецПроцедуры

Процедура ПроверитьВыполнилось(Знач СтрокаАлгоритм, ПараметрыИлиДопСообщениеОшибки = Неопределено, Знач ДопСообщениеОшибки = "") Экспорт
	Перем Параметры;
	
	Если ТипЗнч(ПараметрыИлиДопСообщениеОшибки) = Тип("Строка") Тогда
		ДопСообщениеОшибки = ПараметрыИлиДопСообщениеОшибки;
	Иначе
		Параметры = ПараметрыИлиДопСообщениеОшибки;
	КонецЕсли;
	Попытка
		Выполнить(СтрокаАлгоритм);
	Исключение
		ПолученноеОписаниеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		СообщениеОшибки = "Хотели, чтобы алгоритм """+СтрокаАлгоритм+""" выполнился, а он упал с ошибкой """+ПолученноеОписаниеОшибки+"""." + ФорматДСО(ДопСообщениеОшибки);
		ВызватьОшибкуПроверки(СообщениеОшибки);
	КонецПопытки;
	
КонецПроцедуры

Процедура ПроверитьМетодВыполнился(Объект, Знач ИмяМетода, ПараметрыИлиДопСообщениеОшибки = Неопределено, Знач ДопСообщениеОшибки = "") Экспорт
	Перем Параметры;
	
	Если ТипЗнч(ПараметрыИлиДопСообщениеОшибки) = Тип("Строка") Тогда
		ДопСообщениеОшибки = ПараметрыИлиДопСообщениеОшибки;
	Иначе
		Параметры = ПараметрыИлиДопСообщениеОшибки;
		Если Параметры <> Неопределено Тогда
			ТипПараметра = ТипЗнч(Параметры);
			Если ТипПараметра <> Тип("Массив") Тогда
				ВызватьИсключение ("Ожидали, что вторым параметром будет передан массив параметров для метода <"+ИмяМетода+">, а получили другой объект с типом <"+ТипПараметра+">");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	ПараметрыСтрока = ПараметрыСтрокой(Параметры);
	
	СтрокаВыполнения = "Объект." + ИмяМетода + "(" + ПараметрыСтрока + ")";
	
	Попытка
		Выполнить(СтрокаВыполнения);
	Исключение
		ПолученноеОписаниеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		СообщениеОшибки = "Хотели, чтобы код """+СтрокаВыполнения+""" выполнился, а он упал с ошибкой """+ПолученноеОписаниеОшибки+"""." + ФорматДСО(ДопСообщениеОшибки);
		ВызватьОшибкуПроверки(СообщениеОшибки);
	КонецПопытки;
	
КонецПроцедуры

Функция ПараметрыСтрокой(Параметры)
	ПараметрыСтрока = "";
	Если ЗначениеЗаполнено(Параметры) Тогда
		Для Индекс = 0 По Параметры.ВГраница() Цикл 
			ПараметрыСтрока = ПараметрыСтрока + ", Параметры[" + Формат(Индекс, "ЧН=0; ЧГ=0") + "]";
		КонецЦикла;
	КонецЕсли;
	Возврат Сред(ПараметрыСтрока, 3);
КонецФункции

Процедура ПроверитьНеВыполнилось(Знач СтрокаАлгоритм, ПараметрыИлиОжидаемоеОписаниеОшибки, Знач ОжидаемоеОписаниеОшибкиИлиДопСообщениеОшибки = "", Знач ДопСообщениеОшибки = "") Экспорт
	Перем Параметры, ОжидаемоеОписаниеОшибки; 
	Если ТипЗнч(ПараметрыИлиОжидаемоеОписаниеОшибки) = Тип("Строка") Тогда
		ОжидаемоеОписаниеОшибки = ПараметрыИлиОжидаемоеОписаниеОшибки;
		ДопСообщениеОшибки = ОжидаемоеОписаниеОшибкиИлиДопСообщениеОшибки;
	Иначе
		Параметры = ПараметрыИлиОжидаемоеОписаниеОшибки;
		ОжидаемоеОписаниеОшибки = ОжидаемоеОписаниеОшибкиИлиДопСообщениеОшибки;
	КонецЕсли;
	Попытка
		Выполнить(СтрокаАлгоритм);
	Исключение
		ПолученноеОписаниеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		Если Найти(ПолученноеОписаниеОшибки, ОжидаемоеОписаниеОшибки) = 0 Тогда
			ВызватьОшибкуПроверки("Хотели, чтобы алгоритм """+СтрокаАлгоритм+""" упал с сообщением об ошибке """+ОжидаемоеОписаниеОшибки+""", а он упал с сообщением """+ПолученноеОписаниеОшибки+"""." + ФорматДСО(ДопСообщениеОшибки));
		КонецЕсли;
		Возврат;
	КонецПопытки;
	
	ВызватьОшибкуПроверки("Хотели, чтобы алгоритм """+СтрокаАлгоритм+""" упал, а он выполнился" + ФорматДСО(ДопСообщениеОшибки));
	
КонецПроцедуры

Процедура ПроверитьМетодНеВыполнился(Объект, ИмяМетода, ПараметрыИлиОжидаемоеОписаниеОшибки, Знач ОжидаемоеОписаниеОшибкиИлиДопСообщениеОшибки = "", Знач ДопСообщениеОшибки = "") Экспорт
	Перем Параметры, ОжидаемоеОписаниеОшибки; 
	
	Если ТипЗнч(ПараметрыИлиОжидаемоеОписаниеОшибки) = Тип("Строка") Тогда
		ОжидаемоеОписаниеОшибки = ПараметрыИлиОжидаемоеОписаниеОшибки;
		ДопСообщениеОшибки = ОжидаемоеОписаниеОшибкиИлиДопСообщениеОшибки;
	Иначе
		Параметры = ПараметрыИлиОжидаемоеОписаниеОшибки;
		Если Параметры <> Неопределено Тогда
			ТипПараметра = ТипЗнч(Параметры);
			Если ТипПараметра <> Тип("Массив") Тогда
				ВызватьИсключение ("Ожидали, что третьим параметром будет передан массив параметров для метода <"+ИмяМетода+">, а получили другой объект с типом <"+ТипПараметра+">");
			КонецЕсли;
		КонецЕсли;
		ОжидаемоеОписаниеОшибки = ОжидаемоеОписаниеОшибкиИлиДопСообщениеОшибки;
	КонецЕсли;
	
	ПараметрыСтрока = ПараметрыСтрокой(Параметры);
	
	СтрокаВыполнения = "Объект." + ИмяМетода + "(" + ПараметрыСтрока + ")";
	
	Попытка
		Выполнить(СтрокаВыполнения);
	Исключение
		ПолученноеОписаниеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		Если Найти(ПолученноеОписаниеОшибки, ОжидаемоеОписаниеОшибки) = 0 Тогда
			ВызватьОшибкуПроверки("Хотели, чтобы код """+СтрокаВыполнения+""" упал с сообщением об ошибке """+ОжидаемоеОписаниеОшибки+""", а он упал с сообщением """+ПолученноеОписаниеОшибки+"""." + ФорматДСО(ДопСообщениеОшибки));
		КонецЕсли;
		Возврат;
	КонецПопытки;
	
	ВызватьОшибкуПроверки("Хотели, чтобы код """+СтрокаВыполнения+""" упал, а он выполнился" + ФорматДСО(ДопСообщениеОшибки));
	
КонецПроцедуры

// проверка идет через ЗначениеЗаполнено, но мутабельные значение всегда считаем заполненными
Процедура ПроверитьЗаполненность(ПроверяемоеЗначение, ДопСообщениеОшибки = "") Экспорт
	Попытка
		фЗаполнено = ЗначениеЗаполнено(ПроверяемоеЗначение);
	Исключение
		Возврат;
	КонецПопытки;
	Если НЕ фЗаполнено Тогда
		ВызватьОшибкуПроверки("Значение ("+ПроверяемоеЗначение+") не заполнено, а ожидалась заполненность" + ФорматДСО(ДопСообщениеОшибки));
	КонецЕсли; 
КонецПроцедуры

Процедура ПроверитьНеЗаполненность(ПроверяемоеЗначение, ДопСообщениеОшибки = "") Экспорт
	СообщениеОшибки = "Значение ("+ПроверяемоеЗначение+") заполнено, а ожидалась незаполненность" + ФорматДСО(ДопСообщениеОшибки);
	Попытка
		фЗаполнено = ЗначениеЗаполнено(ПроверяемоеЗначение);
	Исключение
		ВызватьОшибкуПроверки(СообщениеОшибки);
	КонецПопытки;
	Если фЗаполнено Тогда
		ВызватьОшибкуПроверки(СообщениеОшибки);
	КонецЕсли; 
КонецПроцедуры

Процедура ПроверитьТип(значение, ТипИлиИмяТипа, ДопСообщениеОшибки = "") Экспорт
	Если ТипЗнч(ТипИлиИмяТипа) = Тип("Строка") Тогда
		искомыйТип = Тип(ТипИлиИмяТипа);
	ИначеЕсли ТипЗнч(ТипИлиИмяТипа) = Тип("Тип") Тогда
		искомыйТип = ТипИлиИмяТипа;
	Иначе
		ВызватьИсключение ("ПроверитьТип: Тип значения параметра ТипИлиИмяТипа должен быть <Тип> или <Строка>, а получили <"+ ТипЗнч(ТипИлиИмяТипа) + ">" + ФорматДСО(ДопСообщениеОшибки));
	КонецЕсли;
	Если ТипЗнч(значение) <> искомыйТип Тогда
		ВызватьОшибкуПроверки("Типом значения <"+значение+"> является <"+ТипЗнч(значение)+">, а ожидался тип <"+ТипИлиИмяТипа+">."+ФорматДСО(ДопСообщениеОшибки));
	КонецЕсли;
КонецПроцедуры

Процедура ПроверитьВхождение(строка, подстрокаПоиска, ДопСообщениеОшибки = "") Экспорт
	Если Найти(строка, подстрокаПоиска) = 0 Тогда
		ПредставлениеСтроки = "<"+строка+">";
		Если СтрДлина(строка) > 20 Тогда
			ПредставлениеСтроки = ПредставлениеСтроки + Символы.ПС;
		КонецЕсли;
		ПредставлениеПодСтроки = "<"+подстрокаПоиска+">";
		Если СтрДлина(подстрокаПоиска) > 20 Тогда
			ПредставлениеПодСтроки = ПредставлениеПодСтроки + Символы.ПС;
		КонецЕсли;
		СообщениеОшибки = "Искали в "+ПредставлениеСтроки+" подстроку "+ПредставлениеПодСтроки+", но не нашли." + ФорматДСО(ДопСообщениеОшибки);
		ВызватьОшибкуПроверки(СообщениеОшибки);
	КонецЕсли;
КонецПроцедуры

//Коллекция - Массив, Структура, Соответствие, ФиксированныйМассив, ФиксированнаяСтруктура, ФиксированноеСоответствие, СписокЗначений
Процедура ПроверитьВхождениеВКоллекцию(Элемент, Коллекция, ДопСообщениеОшибки = "") Экспорт
	Нашли = Неопределено;
	ТипКоллекции = ТипЗнч(Коллекция);
	Если ТипКоллекции = Тип("Массив") или ТипКоллекции = Тип("ФиксированныйМассив") Тогда
		Нашли = Коллекция.Найти(Элемент) <> Неопределено;
	ИначеЕсли ТипКоллекции = Тип("Структура") или ТипКоллекции = Тип("Соответствие") 
			или ТипКоллекции = Тип("ФиксированнаяСтруктура") или ТипКоллекции = Тип("ФиксированноеСоответствие") Тогда
		Для каждого КлючЗначение Из Коллекция Цикл
			Нашли = КлючЗначение.Значение = Элемент;
			Если Нашли Тогда
				Прервать;
			КонецЕсли;
		КонецЦикла;
	ИначеЕсли ТипКоллекции = Тип("СписокЗначений") Тогда
		Нашли = Коллекция.НайтиПоЗначению(Элемент) <> Неопределено;
	КонецЕсли;
	Если Нашли = Неопределено Тогда
		СообщениеОшибки = "Утверждение ""ПроверитьВхождениеВКоллекцию"" не умеет работать с типом коллекции <"+ТипКоллекции+">." + ФорматДСО(ДопСообщениеОшибки);
		ВызватьИсключение СообщениеОшибки;
	КонецЕсли;
	Если Не Нашли Тогда
		СообщениеОшибки = "Не нашли элемент <"+Элемент+"> в коллекции, а хотели, чтобы он был в коллекции." + ФорматДСО(ДопСообщениеОшибки);
		ВызватьОшибкуПроверки(СообщениеОшибки);
	КонецЕсли;
КонецПроцедуры

Процедура ПроверитьВалидностьЗапросаСКД(ТекстЗапроса, ДопСообщениеОшибки = "") Экспорт
	
	СхемаКомпоновкиДанных = Новый СхемаКомпоновкиДанных;
	
	ИсточникДанных 					  = СхемаКомпоновкиДанных.ИсточникиДанных.Добавить(); 
	ИсточникДанных.Имя                = "ИсточникДанных";
	ИсточникДанных.СтрокаСоединения   = "";
	ИсточникДанных.ТипИсточникаДанных = "Local";
	
	НаборДанных 							 = СхемаКомпоновкиДанных.НаборыДанных.Добавить(Тип("НаборДанныхЗапросСхемыКомпоновкиДанных"));
	НаборДанных.Имя            				 = "НаборДанных";
	НаборДанных.ИсточникДанных 				 = "ИсточникДанных";
	НаборДанных.АвтоЗаполнениеДоступныхПолей = Истина;
	НаборДанных.Запрос 						 = ТекстЗапроса;
	
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	Попытка
		КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	Исключение
		СообщениеОшибки = ОписаниеОшибки() + "." + ФорматДСО(ДопСообщениеОшибки);
		ВызватьОшибкуПроверки(СообщениеОшибки);
	КонецПопытки;
	
КонецПроцедуры // ПроверитьВалидностьЗапросаСКД()

Процедура ПроверитьНаличиеОбъектаИБ(ссылка, ДопСообщениеОшибки = "") Экспорт
	Если Не ЗначениеЗаполнено(ссылка) Тогда
		СообщениеОшибки = "Ожидали заполненность ссылки, а получили пустую ссылку." + ФорматДСО(ДопСообщениеОшибки);
		ВызватьОшибкуПроверки(СообщениеОшибки);
	КонецЕсли;
	лОбъект = ссылка.ПолучитьОбъект();
	Если лОбъект = Неопределено Тогда
		СообщениеОшибки = "Ожидали существование объекта в ИБ, а получили объект не найден <" + ссылка + "> ." + ФорматДСО(ДопСообщениеОшибки);
		ВызватьОшибкуПроверки(СообщениеОшибки);
	КонецЕсли;
КонецПроцедуры

// Проеряет равенство файлов
// Параметры:
//  ПутьФайла1, ПутьФайла2 - полные пути к фалйам
//  ПарамСравнениеФайлов - структура с ключами:
//                ИгнорироватьПустоеПространство
//                СпособСравнения
//                УчитыватьРазделителиСтрок
//                УчитыватьРегистр
//  ПоказатьРазличия - в случае ошибки появляется окно сравнеия (для отладки)
Процедура ПроверитьРавенствоФайлов(ПутьФайла1, ПутьФайла2, ДопСообщениеОшибки = "", ПарамСравнениеФайлов = Неопределено, ПоказатьРазличия = Ложь) Экспорт
#Если ТолстыйКлиентОбычноеПриложение или ТолстыйКлиентУправляемоеПриложение Тогда
	Если ПарамСравнениеФайлов = Неопределено Тогда
		ПарамСравнениеФайлов = Новый Структура;
	КонецЕсли;
	СравнениеФайлов = Новый СравнениеФайлов;
	СравнениеФайлов.ПервыйФайл = ПутьФайла1;
	СравнениеФайлов.ВторойФайл = ПутьФайла2;
	Если Не ПарамСравнениеФайлов.Свойство("СпособСравнения") Тогда
		Файл = Новый Файл(ПутьФайла1);
		ТипФайла = НРег(Файл.Расширение);
		ТекстовыеТипы = ".txt,.xml";
		Если ТипФайла = ".mxl" Тогда
			ПарамСравнениеФайлов.Вставить("СпособСравнения", СпособСравненияФайлов.ТабличныйДокумент);
		ИначеЕсли Найти(ТекстовыеТипы, ТипФайла) > 0 Тогда
			ПарамСравнениеФайлов.Вставить("СпособСравнения", СпособСравненияФайлов.ТекстовыйДокумент);
		КонецЕсли;
	КонецЕсли;
	ЗаполнитьЗначенияСвойств(СравнениеФайлов, ПарамСравнениеФайлов);
	ФайлыИдентичны = СравнениеФайлов.Сравнить();
	Если Не ФайлыИдентичны Тогда
		Если ПоказатьРазличия Тогда // для удобства отладки и расследования ошибок
			СравнениеФайлов.ПоказатьРазличия();
		КонецЕсли;
		СообщениеОшибки = "Ожидали идентичность файлов, а получили, что они различны." + ФорматДСО(ДопСообщениеОшибки);
		ВызватьОшибкуПроверки(СообщениеОшибки);
	КонецЕсли;
#Иначе 
	ВызватьИсключение "Утверждение ПроверитьРавенствоФайлов можно использовать только в толстом клиенте!";
#КонецЕсли
КонецПроцедуры
//}

Процедура ВызватьОшибкуПроверки(СообщениеОшибки)
	
	Префикс = "["+ СтатусыРезультатаТестирования.ОшибкаПроверки + "]";
	ВызватьИсключение Префикс + " " + СообщениеОшибки;
	
КонецПроцедуры

Функция ФорматДСО(ДопСообщениеОшибки)
	Если ДопСообщениеОшибки = "" Тогда
		Возврат "";
	КонецЕсли;
	
	Возврат Символы.ПС + ДопСообщениеОшибки;
КонецФункции

СтатусыРезультатаТестирования = Новый Структура;
СтатусыРезультатаТестирования.Вставить("ОшибкаПроверки", "Failed");
СтатусыРезультатаТестирования.Вставить("НеизвестнаяОшибка", "Broken");
СтатусыРезультатаТестирования.Вставить("ТестПропущен", "Pending");
СтатусыРезультатаТестирования = Новый ФиксированнаяСтруктура(СтатусыРезультатаТестирования);