# Требования к выпуску релизов

Перед выпуском релиза нужно выполнить операции по следующему чек-листу:

- Изменить номер версии в строке `ВерсияПакета = "Х.Х.Х";` в файле [packagedef](./packagedef)
- Изменить номер версии в методе `ПолучитьВерсиюОбработки()` [модуля обработки](./epf/bddRunner/bddRunner/Ext/ObjectModule.bsl) `bddRunner.epf`
- Изменить номер версии в методе `Версия()` [модуля обработки](./epf/xddTestRunner/xddTestRunner/Ext/ObjectModule.bsl) `xddTestRunner.epf`
- Изменить номер версии в методе `Версия()` [модуля обработки](./Plugins/СериализаторMXL/СериализаторMXL/Ext/ObjectModule.bsl) `Plugins/СериализаторMXL.epf`
- Изменить номер версии в метаданных конфигураций для 8.2 и 8.3 из каталога `lib/CF`
  * в 2-х местах - версия конфигурация и синоним конфигурации
  * `<Synonym>` и `<Version>`
  * [bdd 83](./lib/CF/83/Configuration.xml)
  * [bdd 83 NoSync](./lib/CF/83NoSync/Configuration.xml)
  * [xdd 83](./lib/CF/83xdd/Configuration.xml)
  * [xdd 83 NoSync](./lib/CF/83xddNoSync/Configuration.xml)
- изменить версию в расширениях - `<Version></Version>`
  - [ВыполнениеСерверногоКодаВТестах_VanessaADD](lib\cfe\ВыполнениеСерверногоКодаВТестах_VanessaADD\Configuration.xml)
  - [ОткрытиеВнешнихФайлов](lib\cfe\ОткрытиеВнешнихФайлов\Configuration.xml)
  - [МокТестирование](lib\cfe\МокТестирование\Configuration.xml)
  - [ТестМоков](lib\cfe\ТестМоков\Configuration.xml)
- убедиться, что изменено 12 файлов
- Выполнить разборку всех файлов на исходники
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
