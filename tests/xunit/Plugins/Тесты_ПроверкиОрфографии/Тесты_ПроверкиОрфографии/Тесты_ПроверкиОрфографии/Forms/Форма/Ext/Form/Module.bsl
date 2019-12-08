﻿&НаКлиенте
Перем КонтекстЯдра;
&НаКлиенте
Перем Ожидаем;
&НаКлиенте
Перем Утверждения;

// { интерфейс тестирования

&НаКлиенте
Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
	КонтекстЯдра = КонтекстЯдраПараметр;
	Утверждения = КонтекстЯдра.Плагин("БазовыеУтверждения");
	Ожидаем = КонтекстЯдра.Плагин("УтвержденияBDD");
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьНаборТестов(НаборТестов) Экспорт
	
	НаборТестов.НачатьГруппу("Применение разных параметров", Ложь);
	
		Тест = НаборТестов.Добавить("ТестДолжен_ПроверитьОрфографиюПропуститьЦифры", , "Пропустить слова с цифрами");
		Тест.Параметры.Добавить("а1б2в3 - здесь нет ошибки");
		
		Тест = НаборТестов.Добавить("ТестДолжен_ПроверитьОрфографиюПропуститьУРЛ", , "Пропустить url и подобное");
		Тест.Параметры.Добавить("Спасибо www.yandex.ru за сервис");
		
		Тест = НаборТестов.Добавить("ТестДолжен_ПроверитьОрфографиюНайтиДублиСлов", , "Найти дубли слов");
		Тест.Параметры.Добавить("Ищи ищи повторение слов");
		
		// Тест =  НаборТестов.Добавить("ТестДолжен_ПроверитьОрфографиюПрописныеБуквы", , "Пропустить проверку прописных"); Отключен, так как сервис временно не проверяет прописные
		// Тест.Параметры.Добавить("тюмень столица всех деревень");
	
	
КонецПроцедуры

// } интерфейс тестирования

// { блок юнит-тестов - сами тесты

&НаКлиенте
Процедура ТестДолжен_ПроверитьОрфографиюПропуститьЦифры(ТекстНаПроверку) Экспорт
	
	ПроверкаОрфографии = КонтекстЯдра.Плагин("ПроверкаОрфографии");
	ПроверкаОрфографии.ПропускатьСловаСЦифрами(Истина);
	
	Результат = ПроверкаОрфографии.ВыполнитьПроверкуТекста(ТекстНаПроверку);
	
	Ожидаем.Что(Результат, "Ошибок быть не должно").ИмеетТип("Массив").ИмеетДлину(0);
	
КонецПроцедуры

&НаКлиенте
Процедура ТестДолжен_ПроверитьОрфографиюПропуститьУРЛ(ТекстНаПроверку) Экспорт
	
	ПроверкаОрфографии = КонтекстЯдра.Плагин("ПроверкаОрфографии");
	ПроверкаОрфографии.ПропускатьУРЛ(Истина);
	
	Результат = ПроверкаОрфографии.ВыполнитьПроверкуТекста(ТекстНаПроверку);
	
	Ожидаем.Что(Результат, "Ошибок быть не должно").ИмеетТип("Массив").ИмеетДлину(0);
	
КонецПроцедуры

&НаКлиенте
Процедура ТестДолжен_ПроверитьОрфографиюНайтиДублиСлов(ТекстНаПроверку) Экспорт
	
	ПроверкаОрфографии = КонтекстЯдра.Плагин("ПроверкаОрфографии");
	ПроверкаОрфографии.ПропускатьДублированиеСлов(Ложь);
	
	Результат = ПроверкаОрфографии.ВыполнитьПроверкуТекста(ТекстНаПроверку);
	
	Ожидаем.Что(Результат, "Должны быть ошибки").ИмеетТип("Массив").ИмеетДлину(1);
	
КонецПроцедуры

&НаКлиенте
Процедура ТестДолжен_ПроверитьОрфографиюПрописныеБуквы(ТекстНаПроверку) Экспорт
	
	ПроверкаОрфографии = КонтекстЯдра.Плагин("ПроверкаОрфографии");
	ПроверкаОрфографии.ПропускатьПрописные(Истина);
	
	Результат = ПроверкаОрфографии.ВыполнитьПроверкуТекста(ТекстНаПроверку);
	
	Ожидаем.Что(Результат, "Ошибок быть не должно").ИмеетТип("Массив").ИмеетДлину(0);
	
КонецПроцедуры

// } блок юнит-тестов - сами тесты
