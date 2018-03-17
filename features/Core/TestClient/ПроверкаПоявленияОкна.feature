﻿# language: ru

@IgnoreOn82Builds
@IgnoreOnOFBuilds

@tree


Функционал: Проверка появления окна

Как Разработчик я хочу
Чтобы у меня была возможность проверить появление окна
Для того чтобы я мог увязвть логику выполнения сценария

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий

	
Сценарий: Проверка появления окна
	Когда В панели разделов я выбираю "Основная"
	И     В панели функций я выбираю "Справочник1"
	Тогда открылось окно "Справочник1"
	И     я нажимаю на кнопку "Создать"
	Если появилось окно с заголовком "Справочник1 (создание)*" Тогда 
		И     в поле с именем "Наименование" я ввожу текст "111"
		И     в поле "Реквизит строка" я ввожу текст "222"
	И     элемент формы с именем "Наименование" стал равен "111"	
	
	Если появилось окно с заголовком "Справочник1 (нет окна)*" Тогда 
		И     в поле с именем "Наименование" я ввожу текст "333"
	И     элемент формы с именем "Наименование" стал равен "111"
	И     я нажимаю на кнопку "Записать и закрыть"	
	