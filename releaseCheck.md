# Требования к выпуску релизов

Перед выпуском релиза нужно выполнить операции по следующему чек-листу:

- Выполнить разборку всех файлов на исходники
- Изменить номер версии в строке `ВерсияПакета = "Х.Х.Х";` в файле [packagedef](./packagedef)
- Изменить номер версии в методе `ПолучитьВерсиюОбработки()` [модуля обработки](./epf/bddRunner/bddRunner/Ext/ObjectModule.bsl) `bddRunner.epf`
- Изменить номер версии в методе `Версия()` [модуля обработки](./epf/xddTestRunner/xddTestRunner/Ext/ObjectModule.bsl) `xddTestRunner.epf`
- Изменить номер версии в методе `Версия()` [модуля обработки](./Plugins/СериализаторMXL/СериализаторMXL/Ext/ObjectModule.bsl) `Plugins/СериализаторMXL.epf`
- Изменить номер версии в метаданных конфигураций для 8.2 и 8.3 из каталога `lib/CF`
  - выполнить команды для заполнения поля `<Version>` в xml-исходниках
    - `vrunner set-version --src lib/cf --new-version X.Y.Z`
    - `vrunner set-version --src lib/cfe --new-version X.Y.Z`
  * далее поменять версию в синониме конфигурации, в поле `<Synonym>`
  * [bdd 83](./lib/CF/83/Configuration.xml)
  * [bdd 83 NoSync](./lib/CF/83NoSync/Configuration.xml)
  * [xdd 83](./lib/CF/83xdd/Configuration.xml)
  * [xdd 83 NoSync](./lib/CF/83xddNoSync/Configuration.xml)
- убедиться, что изменено минимум 12 файлов
- Выполнить commit и push для своих изменений
- Выполнить все тесты из папки `tests`. Ошибок быть не должно.
- Выполнить все фичи из папки `features/libraries`. Ошибок быть не должно.
- Дождаться завершения сборки на CI
- Описать все изменения версии в файле [history.md](doc/history.md)
- Убедиться, что в задачах/issues на Гитхабе для нового релиза/milestone не осталось невыполненных задач.
- Если все-таки есть незавершенные задачи, их нужно перенести из нового релиза/milestone в следующий релиз.
- Выполнить коммит с установкой тега нового релиза
- Выполнить пуш в origin
  - ветки master и develop
- Выполнить пуш в oscript-library
  - ветки master и develop
- Опубликовать файл `add.ospx` в хабе пакетов через `opm push`
