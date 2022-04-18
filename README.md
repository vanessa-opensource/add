﻿<a id="markdown-vanessa-automation-driven-development" name="vanessa-automation-driven-development"></a>
# Vanessa Automation Driven Development

[![telegram](https://img.shields.io/badge/telegram-chat-green.svg)](https://t.me/vanessa_opensource_chat)
[![Release](https://img.shields.io/github/release/vanessa-opensource/add.svg?style=flat)](https://github.com/vanessa-opensource/add/releases/latest)
[![GitHub Releases](https://img.shields.io/github/downloads/vanessa-opensource/add/latest/total?style=flat-square)](https://github.com/vanessa-opensource/add/releases)
[![GitHub All Releases](https://img.shields.io/github/downloads/vanessa-opensource/add/total?style=flat-square)](https://github.com/vanessa-opensource/add/releases)

<!-- TOC insertAnchor:true -->

- [Vanessa Automation Driven Development](#vanessa-automation-driven-development)
    - [Введение](#введение)
    - [Справка и полезные ссылки](#справка-и-полезные-ссылки)
    - [Установка](#установка)
    - [Ночная сборка ветки **develop**:](#ночная-сборка-ветки-develop)
    - [Запросы функциональности, задачи, сообщения об ошибках:](#запросы-функциональности-задачи-сообщения-об-ошибках)
    - [Сравнение с другими инструментами тестирования](#сравнение-с-другими-инструментами-тестирования)
    - [Как помочь проекту](#как-помочь-проекту)
    - [Лицензии и права](#лицензии-и-права)

<!-- /TOC -->

<a id="markdown-введение" name="введение"></a>
## Введение

Продукт Vanessa-ADD (Vanessa Automation Driven Development) `(далее Vanessa-ADD)` представляет собой набор инструментов для проверки качества решений на платформе 1С:Предприятие.

Vanessa-ADD is a set of testing tools for [1C:Enterprise 8 platform](http://v8.1c.ru) - Tests/behavior (TDD & BDD) for 1С:Enterprise.

> Миссия продукта - повышение качества разработки.

Продукт позволяет проверять поведение различных систем на базе платформы 1С (в режимах совместимости не ниже 8.2.13)  и проверяет/гарантирует качество функциональности системы и ее составных частей на всем протяжении жизненного цикла системы.

> Основной сценарий использования - реализация концепций TDD/BDD/CI в проектах на базе 1С

Возможности:

+ готовые универсальные "дымовые тесты" различных видов
+ различные виды тестирования (модульного/юнит, приемочного, сценарного для 1С 8.3, интеграционного, TDD)
+ проверка поведения (BDD/Gherkin)
+ формирование автодокументации в формате Html или Markdown или в виде видео-инструкций.

Vanessa-ADD является наследником 2-х продуктов - [xUnitFor1C](https://github.com/xDrivenDevelopment/xUnitFor1C) и [Vanessa-Behavior](https://github.com/vanessa-opensource/vanessa-behavior). Совместимость с VB 1.Х и xUnitFor1C 4.Х гарантирована (за исключением функциональности циклов и условий в Vanessa-ADD)

<a id="markdown-справка-и-полезные-ссылки" name="справка-и-полезные-ссылки"></a>
## Справка и полезные ссылки

Обязательно ознакомьтесь с:

+ **Документацией по продукту** [doc/README.md](./doc/README.md)

+ часто задаваемыми вопросами [FAQ.md](./F.A.Q.MD)
+ руководством контрибьютора [CONTRIBUTING.md](./.github/CONTRIBUTING.md)
+ известными проблемами [KNOWN-PROBLEMS.md](./doc/KNOWN-PROBLEMS.md)

<a id="markdown-установка" name="установка"></a>
## Установка

Порядок установки Vanessa-ADD:

Автоматическая установка (через установщик пакетов OneScript ):

+ Выполнить `opm install add`
+ После выполнения пакет будет установлен в каталог <УстановленныйOneScript>/lib/add

Автоматическая установка (при установке пакета vanessa-runner через установщик пакетов OneScript ):

+ Выполнить `opm install vanessa-runner`
+ После выполнения пакет будет установлен в каталог <УстановленныйOneScript>/lib/vanessa-runner

Ручная установка:

+ Перейти в [раздел релизы](https://github.com/vanessa-opensource/add/releases)
+ Скачать архив `add-x.x.x.zip` с последним стабильным релизом - прямая ссылка [Releases](https://github.com/vanessa-opensource/add/releases/latest)
+ Распаковать указанный архив в нужную папку.

<a id="markdown-ночная-сборка-ветки-develop" name="ночная-сборка-ветки-develop"></a>
## Ночная сборка ветки **develop**:

Продукт помимо основного стабильного релиза, выпускается "ночная сборка" продукта с новым, но еще не стабильным функционалом. Артефакты сборки доступны по запросу.

<a id="markdown-запросы-функциональности-задачи-сообщения-об-ошибках" name="запросы-функциональности-задачи-сообщения-об-ошибках"></a>
## Запросы функциональности, задачи, сообщения об ошибках:

Пожелания к использованию можно фиксировать в виде [Github Issues](https://github.com/vanessa-opensource/add/issues/new/choose)

Обсуждения категоризируются на 3 вида

* [Сообщение об ошибке](https://github.com/vanessa-opensource/add/issues/new?template=bug_report.md)
* [Запрос новой функциональности](https://github.com/vanessa-opensource/add/issues/new?template=feature_request.md)
* [Запрос поддержки](https://github.com/vanessa-opensource/add/issues/new?template=help_request)

Для удобства использования для каждой категории создан специальный шаблон, доступные для редактирования в каталоге [Шаблоны обсуждений](./.github/ISSUE_TEMPLATE/)

<a id="markdown-сравнение-с-другими-инструментами-тестирования" name="сравнение-с-другими-инструментами-тестирования"></a>
## Сравнение с другими инструментами тестирования

Продукт подразумевает следования трем ключевым принципам

* соответствение концепции BDD - "кодирование сценариев поведения до проектирования" в части приемочных тестов (приемо-сдаточных сценариев)
* соответствие концепции TDD - "тестирование до кода" в части модульных тестов (юнит-тестов)
* соответствие концепции "всё есть код" в части любых тестов и необходимых для этого данных

Остальные продукты в зоне "Качество 1С решений" исповедуют другие принципы, поэтому бессмысленно сравнивать функциональность разных продуктов, если они реализованы просто для разных целей.

<a id="markdown-как-помочь-проекту" name="как-помочь-проекту"></a>
## Как помочь проекту

Продукт развивается при помощи независимых разработчиков, использующих продукт в собственных целях и в своих компаниях

* сообществом независимых разработчиков через концепцию краудсорсинга при помощи
  * [руководства контрибьютора](./.github/CONTRIBUTING.md)
  * [технологию ответвления](https://github.com/vanessa-opensource/add/network/members) и [отправки запросов на слияния](https://github.com/vanessa-opensource/add/pulls)

Поэтому:

* Если вы желаете поучаствовать в доработке и развитии, ознакомьтесь с руководством контрибьютора (участника проекта)

<a id="markdown-лицензии-и-права" name="лицензии-и-права"></a>
## Лицензии и права

+ основная лицензия исходного кода продукта - Mozilla Public Licence 2.0
+ лицензии стороннего кода - BSDv3, Apache License, Freeware, etc - подробные разъяснения лицензий на исходный код продукта и его документации, в том числе содержатся внутри файлов исходного кода

> Для НЕ знакомых с открытыми лицензиями информация о разрешениях и запретах каждой конкретной лицензии содержится на сайте https://choosealicense.com/licenses/ - в каждой конкретной лицензии имеются 3 секции: "Permissions (Права которые вы имеете)", "Conditions (Условия с которыми вы соглашаетсь)" и Limitations (Ограничения которые на вас накладываются). При использовании продукта, материалов исходного кода обработок 1С, скриптов или документации крайне желательно ознакомится с указанным сайтом для исключения противоречий.

----------

Данная документация распространяется под открытой лицензией <br /><a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">Creative Commons Attribution-ShareAlike 4.0 International License</a>.<br />
<a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" /></a>
