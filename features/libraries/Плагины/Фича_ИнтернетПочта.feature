#language: ru

@Ignore

Функциональность: Получение и работа с GreenMail http://www.icegreen.com/greenmail/
Как Тестировщик
Я хочу проверить корректность отправки и получения электронных писем

Контекст:
    Допустим Я выполняю команду "java" с параметрами "-Dgreenmail.setup.smtps -Dgreenmail.setup.imaps -Dgreenmail.auth.disabled -Dgreenmail.verbose -jar greenmail-standalone-1.5.9.jar"

Сценарий: Настройка почтового ящика
    Допустим пользователь SMTP 'user@localhost'
    И пользователь IMAP 'user@localhost'
    Когда я создаю ящик 'SENT'
    Тогда я очищаю ящик 'SENT' от сообщений

Сценарий: Отправка электронных писем
    Допустим Я отправляю письмо от имени 'user@localhost' по адресу 'user@localhost' с темой 'test'
    Тогда в ящике 'INBOX' есть сообщения
    И сообщения от 'user@localhost'
    И темой сообщения 'test'
