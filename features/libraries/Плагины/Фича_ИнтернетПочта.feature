#language: ru

@Ignore

Функциональность: Взаимодействие с GreenMail http://www.icegreen.com/greenmail/
Как Тестировщик
Я хочу проверить корректность отправки и получения электронных писем

Контекст:
    Допустим Я выполняю команду "java" с параметрами "-Dgreenmail.setup.smtps -Dgreenmail.setup.imaps -Dgreenmail.auth.disabled -Dgreenmail.verbose -jar greenmail-standalone-1.5.9.jar"

Сценарий: Настройка почтового ящика
    Допустим пользователь SMTP 'user@localhost'
    Затем я очищаю ящик 'INBOX' от сообщений

Сценарий: Создание папки на сервере IMAP
    Допустим пользователь IMAP 'user@localhost'
    Когда я создаю ящик 'SENT'
    Тогда я очищаю ящик 'SENT' от сообщений

Сценарий: Отправка и получение электронных писем
    Допустим Я отправляю письмо от имени 'user@localhost' по адресу 'user@localhost' с темой 'X-Mailer check'
    Тогда в ящике 'INBOX' есть сообщения
    И сообщения от 'user@localhost'
    И темой сообщения 'X-Mailer check'
    И заголовком сообщения 'X-Mailer: 1C:Enterprise 8.3'
    Затем я отключаюсь от почтового сервера
