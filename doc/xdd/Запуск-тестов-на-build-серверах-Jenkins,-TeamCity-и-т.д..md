Позволяет выгружать результаты тестов в формате junit 

Для запуска из TeamCity можно использовать такую команду 
```
chcp 1251

"C:\Program Files (x86)\1cv8\8.3.7.1845\bin\1cv8.exe" /DisableStartupMessages 
/Execute "%teamcity.build.checkoutDir%\xddTestRunner.epf" /F "tempdb" /N "Admin" /P1 
/C "xddRun ЗагрузчикКаталога ""%teamcity.build.checkoutDir%\Tests"";
xddReport ГенераторОтчетаJUnitXML ""%teamcity.build.checkoutDir%\report_ordinary.xml"";
xddShutdown;"
```

Готовый файл шаблона для TeamCity [XUnitFor1C_v4_TeamCity](https://github.com/xDrivenDevelopment/xUnitFor1C/releases/download/4.0.0.4/XUnitFor1C_v4_TeamCity.zip)

Для запуска из jenkins можно использовать такую команду 
```
chcp 1251

"C:\Program Files (x86)\1cv8\8.3.7.1845\bin\1cv8.exe" ENTERPRISE /F"%WORKSPACE%\testib" 
/DisableStartupMessages 
/Execute "%WORKSPACE%\xddTestRunner.epf" /N "Admin" /P1 
/C "xddRun ЗагрузчикКаталога ""%WORKSPACE%\Tests"";
xddReport ГенераторОтчетаJUnitXML ""%WORKSPACE%\report_ordinary.xml"";xddShutdown;"
```

Более подробно смотрите [Вики.Запуск тестов из командной строки](https://github.com/xDrivenDevelopment/xUnitFor1C/wiki/%D0%97%D0%B0%D0%BF%D1%83%D1%81%D0%BA-%D1%82%D0%B5%D1%81%D1%82%D0%BE%D0%B2-%D0%B8%D0%B7-%D0%BA%D0%BE%D0%BC%D0%B0%D0%BD%D0%B4%D0%BD%D0%BE%D0%B9-%D1%81%D1%82%D1%80%D0%BE%D0%BA%D0%B8-%D0%B8-%D0%BF%D0%BE%D0%BB%D1%83%D1%87%D0%B5%D0%BD%D0%B8%D0%B5-%D1%84%D0%B0%D0%B9%D0%BB%D0%BE%D0%B2-%D1%80%D0%B5%D0%B7%D1%83%D0%BB%D1%8C%D1%82%D0%B0%D1%82%D0%BE%D0%B2)