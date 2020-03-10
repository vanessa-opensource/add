﻿
# language: ru

@IgnoreOnCIMainBuild
@Proposal
@GitHub:#701

Функционал: Поддержка проекта внешних обработок в EDT
	Как разработчик
 	Я хочу разрабатывать тесты на EDT с учетом ее специфики
   	Чтобы гарантировать качество решения

Контекст:
 	Дано: Я создаю временный каталог и сохраняю его в контекст
	И Я устанавливаю временный каталог как рабочий каталог
	И Каталог "c:/_Repository/PashaMakadd/features/Drafts/step_definitions/bin" существует
	И Файл "ПоддержкаПроектаВнешнихОбработокEDT.epf" внутри каталога "c:/_Repository/PashaMakadd/features/Drafts/step_definitions/bin" существует

Сценарий: Загрузка макета и выполнение шага
	Когда Я загружаю макет "Тест"
	Тогда Выполняю тестовый шаг проекта внешних обработок EDT

