# language: ru

@IgnoreOn82Builds
@IgnoreOnOFBuilds
@IgnoreOnWeb



Функционал: Проверка работы сценария на другом языке, когда изменен порядок параметров

Как пользователь
Я хочу чтобы я мог получить таблицу перевода на экране
Чтобы я мог сделать перевод шагов на любой язык




Сценарий: Проверка таблицы перевода

	Когда Я подключаю клиент тестирования с параметрами:
		| 'Имя подключения' | 'Порт' | 'Строка соединения'  | 'Логин' | 'Пароль' |  'Дополнительные параметры строки запуска'  |
		| 'TestEN'          | '1538' | ''                   | ''      | ''       |  '/TestManager'                                      |

	Когда Я открываю VanessaADD в режиме TestClient со стандартной библиотекой

	И     из выпадающего списка "Язык генератора Gherkin" я выбираю "English"

	Когда В поле с именем "КаталогФичСлужебный" я указываю путь к служебной фиче "СлужебнаяФичаEN1"
И В открытой форме я перехожу к закладке с заголовком "Сервис"
	И в поле "Таймаут запуска TestClient" я ввожу текст "20"
	И В открытой форме я перехожу к закладке с заголовком "Запуск сценариев"
	И     Я нажимаю на кнопку перезагрузить сценарии в Vanessa-ADD TestClient
	И     Я нажимаю на кнопку выполнить сценарии в Vanessa-ADD TestClient

	Тогда таблица формы с именем "ДеревоТестов" стала равной:
		| 'Статус'  | 'Наименование'                                                         |
		| ''        | 'СлужебнаяФичаEN1.feature'                                             |
		| ''        | 'СлужебнаяФичаEN1'                                                     |
		| ''        | 'Контекст'                                                             |
		| ''        | 'Given I launch TestClient opening script or connect the existing one' |
		| 'Success' | 'Given I open new TestClient session or connect the existing one'      |
		| 'Success' | 'And I close all client application windows'                           |
		| 'Success' | 'Create record in spr1'                                                |
		| 'Success' | 'And In the command interface I select "Основная" "Справочник1"'       |
		| 'Success' | 'Then "Справочник1" window is opened'                                  |
		| 'Success' | 'And I click the button named "ФормаСоздать"'                          |
		| 'Success' | 'Then "Справочник1 (создание)" window is opened'                       |
		| 'Success' | 'And I input "111" text in the field named "Наименование"'             |
		| 'Success' | 'And I click "Записать и закрыть" button'                       |
		| 'Success' | 'Close TestClient'                                                     |
		| 'Success' | 'And I close TestClient session'                                 |

Сценарий: Закрытие слубеного сеанса TestEN
	И я закрываю TestClient "TestEN"
