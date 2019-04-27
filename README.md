<a id="markdown-vanessa-add--add-" name="vanessa-add--add-"></a>
# Vanessa Automation Driven Development

| Сообщество продукта | Качество проекта | Статус сборки | Текущий релиз |
|--------------------|------------------|---------------|---------------|
| [![Открытый форум проекта](https://img.shields.io/discourse/https/xdd.silverbulleters.org/users.svg)](https://xdd.silverbulleters.org/c/razrabotka/xdrivendevelopment) |  [![Профиль качества](https://opensonar.silverbulleters.org/api/project_badges/measure?project=add&metric=alert_status)](https://opensonar.silverbulleters.org/dashboard?id=add) |  <Новый сервер CI>   | [![](https://img.shields.io/github/release/silverbulleters/add.svg)](https://github.com/silverbulleters/add)   |


<!-- TOC insertAnchor:true -->

- [Vanessa-ADD ( ADD )](#vanessa-add--add-)
    - [Введение](#введение)
    - [Справка и полезные ссылки](#справка-и-полезные-ссылки)
    - [Установка](#установка)
    - [Обсуждения, задачи, сообщения об ошибках](#обсуждения)
    - [Сравнение с другими инструментами](#сравнение-с-другими-инструментами)
    - [Помощь проекту](#how-to-help)
    - [Лицензии](#лицензии)

<!-- /TOC -->

<a id="markdown-введение" name="введение"></a>
## Введение

Продукт Vanessa-ADD (Vanessa Automation Driven Development) `(далее ADD)` представляет собой набор инструментов для проверки качества решений на платформе 1С:Предприятие.

Vanessa-ADD is a set of testing tools for [1C:Enterprise 8 platform](http://v8.1c.ru) - Tests/behavior (TDD & BDD) for 1С:Enterprise.

> Миссия продукта - повышение качества разработки.

Продукт позволяет проверять поведение различных систем на базе платформы 1С (в режимах совместимости не ниже 8.2.13)  и проверяет/гарантирует качество функциональности системы и ее составных частей на всем протяжении жизненного цикла системы.

> Основной сценарий использования - реализация концепций TDD/BDD/CI в проектах на базе 1С

Возможности:

+ готовые универсальные "дымовые тесты" различных видов
+ различные виды тестирования (модульного/юнит, приемочного, сценарного для 1С 8.3, интеграционного, TDD)
+ проверка поведения (BDD/Gherkin)
+ формирование автодокументации в формате Html или Markdown или в виде видео-инструкций.

Vanessa-ADD является наследником 2-х продуктов - [xUnitFor1C](https://github.com/xDrivenDevelopment/xUnitFor1C) и [Vanessa-Behavior](https://github.com/silverbulleters/vanessa-behavior). Совместимость с VB 1.Х и xUnitFor1C 4.Х гарантирована (за исключением функциональности циклов и условий в add)

<a id="markdown-справка-и-полезные-ссылки" name="справка-и-полезные-ссылки"></a>
## Справка и полезные ссылки

Обязательно ознакомьтесь с:

+ **Документацией по продукту** [doc/README.md](./doc/README.md)

+ часто задаваемыми вопросами [FAQ.md](./F.A.Q.MD)
+ руководством контрибьютора [CONTRIBUTING.md](./.github/CONTRIBUTING.md)
+ известными проблемами [KNOWN-PROBLEMS.md](./doc/KNOWN-PROBLEMS.md)

<a id="markdown-установка" name="установка"></a>
## Установка

Порядок установки ADD:

Автоматическая установка (через установщик пакетов OneScript ):

+ Выполнить `opm install add`
+ После выполнения пакет будет установлен в каталог <УстановленныйOneScript>/lib/add

Автоматическая установка (при установке пакета vanessa-runner через установщик пакетов OneScript ):

+ Выполнить `opm install vanessa-runner`
+ После выполнения пакет будет установлен в каталог <УстановленныйOneScript>/lib/add

Ручная установка:

+ Перейти в [раздел релизы](https://github.com/silverbulleters/add/releases)
+ Скачать архив `add-x.x.x.zip` с последним стабильным релизом - прямая ссылка [Releases](https://github.com/silverbulleters/add/releases/latest)
+ Распаковать указанный архив в нужную папку.

## Ночная сборка ветки **develop**:

Продукт помимо основного стабильного релиза, выпускается "ночная сборка" продукта с новым, но еще не стабильным функционалом. Артефакты сборки доступны на сервере сборок в двух форматах:

1. [7z](http://ci.silverbulleters.org/job/ADD%20test/job/develop/lastSuccessfulBuild/artifact/add.7z) - `unzip -o ./add.7z`
2. [tar.gz](http://ci.silverbulleters.org/job/ADD%20test/job/develop/lastSuccessfulBuild/artifact/add.tar.gz) - `tar xfv ./add.tar.gz`

## Запросы функциональности, задачи, сообщения об ошибках:

Пожелания к использованию можно фиксировать в виде [Github Issues](https://github.com/silverbulleters/add/issues/new/choose)

Обсуждения категоризируются на 3 вида

* [Сообщение об ошибке](https://github.com/silverbulleters/add/issues/new?template=bug_report.md)
* [Запрос новой функциональности](https://github.com/silverbulleters/add/issues/new?template=feature_request.md)
* [Запрос поддержки](https://github.com/silverbulleters/add/issues/new?template=help_request)

Для удобства использования для каждой категории создан специальный шаблон, доступные для редактирования в каталоге [Шаблоны обсуждений](./.github/ISSUE_TEMPLATE/)

<a id="markdown-сравнение-с-другими-инструментами" name="сравнение-с-другими-инструментами"></a>
## Сравнение с другими инструментами тестирования

Продукт подразумевает следования трем ключевым принципам

* соответствение концепции BDD - "кодирование сценариев поведения до проектирования" в части приемочных тестов (приемо-сдаточных сценариев)
* соответствие концепции TDD - "тестирование до кода" в части модульных тестов (юнит-тестов)
* соответствие концепции "всё есть код" в части любых тестов и необходимых для этого данных

Остальные продукты в зоне "Качество 1С решений" исповедуют другие принципы, поэтому бессмысленно сравнивать функциональность разных продуктов, если они реализованы просто для разных целей.

<a id="markdown-how-to-help" name="how-to-help"></a>
## Как помочь проекту

Продукт развивается при помощи связанных с ним коммерческих проектов и при помощи независимых разработчиков использующих продукт в собственных целях и в своих компаниях

* за счет средств компании Серебряная Пуля при реализации трёх категорий услуг
  * реализация проектов [Имплементация инженерных практик](http://silverbulleters.org/implementacia) и [Тестирование ИТ решений](http://silverbulleters.org/testirovanie)
  * услуги корпоративная поддержка [OpenSource инструментария](https://silverbulleters.org/consult)
  * продажи книг "Тестирование 1С решений - пособие разработчика" и "Пособие релиз инженера 1С"

* сообществом независимых разработчиков через концепцию краудсорсинга при помощи
  * [руководства контрибьютора](./.github/CONTRIBUTING.md)
  * [технологию ответвления](https://github.com/silverbulleters/add/network/members) и [отправки запросов на слияния](https://github.com/silverbulleters/add/pulls)

Поэтому:

* Если вы желаете помочь проекту финансово - вы можете приобрести указанные книги и заказать указанные проекты [на сайте компании](https://silverbulleters.org/)
* Если вы желаете поучаствовать в доработке и развитии ознакомьтесь с руководством контрибьютора (участника проекта)

<a id="markdown-лицензии" name="лицензии"></a>
## Лицензии и права

+ основная лицензия исходного кода продукта - Mozilla Public Licence 2.0
+ лицензии стороннего кода - BSDv3, Apache License, Freeware, etc - подробные разъяснения лицензий на исходный код продукта и его документации в том числе содержатся внутри файлов исходного кода

> Для НЕ знакомых с открытыми лицензиями информация о разрешениях и запретах каждой конкретной лицензии содержится на сайте https://choosealicense.com/licenses/ - в каждой конкретной лицензии имеются 3 секции: "Permissions (Права которые вы имеете)", "Conditions (Условия с которыми вы соглашаетсь)" и Limitations (Ограничения которые на вас накладываются). При использовании продукта, материалов исходного кода обработок 1С, скриптов или документации крайне желательно ознакомится с указанным сайтом для исключения противоречий.

----------

Данная документация распространяется под открытой лицензией <br /><a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">Creative Commons Attribution-ShareAlike 4.0 International License</a>.<br />
<a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" /></a>
