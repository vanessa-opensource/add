@echo allure.bat must be in the PATH
call allure generate .\build\ServiceBases\allurereport
call allure report open
