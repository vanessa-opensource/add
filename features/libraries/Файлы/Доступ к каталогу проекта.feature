# language: ru

@IgnoreOnWeb

Функционал: Доступ к каталогу проекта
	Как Пользователь VB
 	Я хочу иметь доступ к каталогу проекта через переменные контекста
    Чтобы проще обращаться к файлам из каталога проекта

Сценарий: Соответствие шаблону
    Когда Я запоминаю каталог проекта в переменную "КаталогПроекта"
    Тогда переменная "КаталогПроекта" соответствует регулярному выражению "add|workspace"
