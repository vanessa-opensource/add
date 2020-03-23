# language: ru

@IgnoreOnCIMainBuild
@ExportScenarios


Функционал: Запуск Vanessa-ADD интерактивно в режиме TestClient
	Как Разработчик
	Я Хочу чтобы я мог открыть обработку Vanessa-ADD интерактивно
	Чтобы я мог потом в ней запускать feature файлы


Сценарий: Я запускаю Vanessa-ADD интерактивно в режиме TestClient

	# Когда Я нажимаю на кнопку диалога выбора файлов
	# И в открывшемся окне я указываю путь к обработке bddRunner.epf
	Когда Я открываю VanessaADD в режиме TestClient без всяких настроек формы