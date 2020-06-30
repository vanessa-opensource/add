﻿# language: ru

@IgnoreOnWeb

Функционал: Содание fixtures по макету обработки привязанной к фиче
	Как Разработчик
	Я Хочу чтобы чтобы я мог создавать fixtures по макетам, которые находятся в обработке привязанной к фиче
	Чтобы я мог создавать fixtures без программирования


Сценарий: Загрузка данных из макета

	Когда Я удаляю все элементы Справочника "Справочник1"
	И     Я загружаю макет "Макет"
	Тогда В базе появился хотя бы один элемент справочника "Справочник1"

Сценарий: Загрузка данных из макета и помещение загруженных данных в контекст

	Когда Я удаляю все элементы Справочника "Справочник1"
	И     Я загружаю макет "Макет" и сохраняю данные из макета в переменную "ДанныеИзМакета"
	Тогда В базе появился хотя бы один элемент справочника "Справочник1"
	И выражение внутреннего языка "ЗначениеЗаполнено(Контекст.ДанныеИзМакета.Элемент1)" Истинно

Сценарий: Загрузка данных из макета и отдельное помещение загруженных данных в контекст

	Когда Я удаляю все элементы Справочника "Справочник1"
	# И     Я загружаю макет "Макет" и сохраняю данные из макета в переменную "ДанныеИзМакета"
	И я загружаю макет "Макет" с переменными:
	| Элемент1 |
	Тогда В базе появился хотя бы один элемент справочника "Справочник1"
	И выражение внутреннего языка "ЗначениеЗаполнено(Контекст.Элемент1)" Истинно
	И выражение внутреннего языка "Контекст.Элемент1 = Контекст.ДанныеИзМакета.Элемент1" Истинно

Сценарий: Загрузка данных из макета и отдельное помещение загруженных данных в контекст с переименованием переменных

	Когда Я удаляю все элементы Справочника "Справочник1"
	# И     Я загружаю макет "Макет" и сохраняю данные из макета в переменную "ДанныеИзМакета"
	И я загружаю макет "Макет" с переменными:
	| Элемент1 | Элемент12345 |
	Тогда В базе появился хотя бы один элемент справочника "Справочник1"
	И выражение внутреннего языка "ЗначениеЗаполнено(Контекст.Элемент12345)" Истинно
	И выражение внутреннего языка "Контекст.Элемент12345 = Контекст.ДанныеИзМакета.Элемент1" Истинно

Сценарий: Создание fixtures

	Когда Я удаляю все элементы Справочника "Справочник1"
	И     Я создаю fixtures по макету "Макет"
	Тогда В базе появился хотя бы один элемент справочника "Справочник1"

Сценарий: Создание Пользователей ИБ через fixtures
	Когда В базе отсутствует пользователь ИБ "ТестовыйПользователь"
	И Я создаю fixtures по макету "ПользовательИБ"
	Тогда В базе существует пользователь ИБ "ТестовыйПользователь"
	И Я удаляю пользователя ИБ "ТестовыйПользователь"

Сценарий: Создание fixtures по макету MXL из каталога проекта

	Когда Я удаляю все элементы Справочника "Справочник1"
	И     Я создаю fixtures по макету "spec\fixtures\ЗагрузкаОдногоЭлементаСправочника1.mxl"
	Тогда В базе появился хотя бы один элемент справочника "Справочник1"

Сценарий: Создание fixtures по макету JSON из каталога проекта

	Когда Я удаляю все элементы Справочника "Справочник1"
	И     Я создаю fixtures по макету "spec\fixtures\ЗагрузкаОдногоЭлементаСправочника1.json"
	Тогда В базе появился хотя бы один элемент справочника "Справочник1"

Сценарий: Нельзя выполнить шаг "И я загружаю макет", если макета не существует в каталоге проекта - негативный сценарий

	Когда проверяю шаги на исключение:
	| И     Я загружаю макет "Несуществующий макет" |
