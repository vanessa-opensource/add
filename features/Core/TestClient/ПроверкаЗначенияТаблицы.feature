﻿# language: ru

@IgnoreOn82Builds
@IgnoreOnOFBuilds


@tree


Функционал: Проверка значения таблицы

	Как Разработчик я хочу
	Чтобы я мог проверить значение таблицы TestClient
	Для того чтобы я мог использовать это в своих сценариях



Контекст: 
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий
	

Сценарий: Проверка равенства таблицы макету
	Когда В панели разделов я выбираю "Основная"
	И     В панели функций я выбираю "Справочник1"
	Тогда открылось окно "Справочник1"
	И     я нажимаю на кнопку "Создать"
	Тогда открылось окно "Справочник1 (создание)"
	И     в таблице "ТабличнаяЧасть1" я нажимаю на кнопку "Добавить"
	И     в таблице "ТабличнаяЧасть1" в поле "Реквизит число" я ввожу текст "1,00"
	И     в таблице "ТабличнаяЧасть1" я активизирую поле "Реквизит строка"
	И     в таблице "ТабличнаяЧасть1" в поле "Реквизит строка" я ввожу текст "Стр1"
	И     в таблице "ТабличнаяЧасть1" я завершаю редактирование строки
	И     в таблице "ТабличнаяЧасть1" я нажимаю на кнопку "Добавить"
	И     в таблице "ТабличнаяЧасть1" в поле "Реквизит число" я ввожу текст "2,00"
	И     в таблице "ТабличнаяЧасть1" я активизирую поле "Реквизит строка"
	И     в таблице "ТабличнаяЧасть1" в поле "Реквизит строка" я ввожу текст "Стр2"
	И     в таблице "ТабличнаяЧасть1" я завершаю редактирование строки
	
	И таблица "ТабличнаяЧасть1" стала равной макету "ТабДок"
	И таблица "ТабличнаяЧасть1" равна макету "ТабДокШаблон" по шаблону
	И     в поле с именем "Наименование" я ввожу текст "Проверка равенства таблицы макету"
	И     я нажимаю на кнопку "Записать и закрыть"

