# Настройка своего jenkins для запуска

## Необходимый набор программ


Должно быть установлено:
* java jdk
* git и находится в переменной PATH
* [v8unpack][v8unpack] и находится в переменной PATH
* [oscript][oscript] и находится в переменной PATH
* платформа 1С 8.3.10
* утилита [nircmd][nircmd] и находится в переменной PATH
* [allure][allure] или [allure 2.0 beta][allurebeta], в переменной PATH должен находится каталог ./bin

[oscript]: http://oscript.io/downloads
[nircmd]: http://www.nirsoft.net/utils/nircmd.html "ссылка внизу страницы"
[v8unpack]: https://github.com/dmpas/v8unpack#build
[allure]: https://github.com/allure-framework/allure-core/releases/latest
[allurebeta]: https://bintray.com/qameta/generic/allure2/2.0-BETA5#files/io/qameta/allure/allure/2.0-BETA5

## Установка Jenkins

### linux

* docker: https://github.com/jenkinsci/docker/blob/master/README.md
* стандартным пакетным менеджером: https://wiki.jenkins-ci.org/display/JENKINS/Installing+Jenkins+on+Red+Hat+distributions

### windows

* https://jenkins.io/download/
* установка через war:
    * качаем jenkins.war
    * определяем где будет папка со всеми настройками (надо делать бэкап), так называемая ```JENKINS_HOME```
    * создаем bat файл для запуска jenkins, в данном примере jenkins будет на порту 8484, ```JENKINS_HOME = d:\work\jenkins\home```
    ```
    java -DJENKINS_HOME=d:\work\jenkins\home -jar jenkins.war  --httpPort=8484 -Dfile.encoding=UTF-8
    ```

## Настройка Jenkins

На вновь установленном Jenkins необходимо установить определенные плагины. Что-бы их руками не искать, для этого необходимо взять запустить файлы из директории ./init.groovy.d
В частности необходимо открыть "Настроить Jenkins/Managment Jenkins", выбрать "Консоль сценариев" и последовательно вставить туда содержимое файлов.
Переход по быстрому "http://localhost:port/script/"

* 0.init-plugins.groovy: производит установку плагинов по списку
* 1.allure_crs.groovy: установка настроек для корректного отображения Allure отчета.

Что-бы каждый раз не заботиться об установки настроек allure, можно файл 1.allure_crs.groovy скопировать в ```JENKINS_HOME/init.groovy.d```, тогда при каждом перезапуске Jenkins будут устанавливаться правильные настройки и не будет необходимости запускать данный скрипт вручную и не баловаться с указанием кавычек при передаче параметров запуска jenkins. Если папки ```init.groovy.d``` ее необходимо создать и перезапустить jenkins.


## Создание node

* Необходимо перейти в "Настройки jenkins" -> "Управление средами сборки" или по адресу http://localhost:8484/computer/
* Создать новый узел:
    * Название узла произвольное
    * Выбрать "Permanent Agent" и "Ок"
* В настройках агента необходимо указать:
    * Количество процессов-исполнителей: обычно больше 1
    * Корень удаленной ФС: для windows чем короче будет путь, тем лучше, обычно указываю C:\s\
    * Метки: slave
    * Способ запуска: Launch agent via Java Web Start
    * "SAVE"
* В списке нод, открываем вновь созданную ноду и видим команду для запуска в разделе ```Run from agent command line:```
    команда буде выглядеть примерно так ```java -jar slave.jar -jnlpUrl http://localhost:8484/computer/test/slave-agent.jnlp -secret 404de7b92b55b9663571bb91a4ca7110e147697b052cae99a0eada47a12fe70f```
    Необходимо клацнуть на ссылку на слове slave.jar и скачать данный файл (пример ссылки прямой http://localhost:8484/jnlpJars/slave.jar)

* Для linux создаем sh файл с примером как указан в web
* Для windows создаем bat с такой же строкой, только с добавлением UTF-8 в параметрах ```java -Dfile.encoding=UTF-8 -jar slave.jar -jnlpUrl http://localhost:8484/computer/test/slave-agent.jnlp -secret 404de7b92b55b9663571bb91a4ca7110e147697b052cae99a0eada47a12fe70f ```

Для автоматизации задачи настройки сборочной ноды подготовлено несколько сценариев (ролей) для системы управления конфигурациями [Ansible](http://docs.ansible.com/ansible/latest/index.html). Подробнее см. [ansible](../ansible/README.md)

## Создание задачи для запуска тестов

* Запускаем "Создать Item" или ссылку "http://localhost:8484/view/all/newJob"
* Имя произвольное, например vanessa-dev
* Тип выбираем "Pipeline", "Ok"
* Переходим в раздел "Pipeline"
    * В Definition выбираем "Pipeline script from SCM"
    * SCM выбираем "GIT"
    * Repository URL: путь к разрабатываемому проекту (может как http так и d:\git\Vanessa-ADD-new)
    * Branch Specifier (blank for 'any'): меняем на необходимую ветку */develop или */feature/mynewfeature
    * "Сохранить"

**Запускаем вновь созданную задачу**
