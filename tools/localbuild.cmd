rmdir add-test /s /q
    @IF ERRORLEVEL 1 goto error

git clone https://github.com/silverbulleters/add add-test
    @IF ERRORLEVEL 1 goto error

pushd add-test

git checkout develop
    @IF ERRORLEVEL 1 goto error

opm run init file --buildFolderPath ./build
    @IF ERRORLEVEL 1 goto error

opm run initib file --buildFolderPath ./build --v8version 8.3.10
    @IF ERRORLEVEL 1 goto error

@REM 
opm run vanessa all --path ./features/Core/OpenForm --settings ./tools/JSON/VBParams8310UF.json
    @IF ERRORLEVEL 1 goto error
@REM opm run vanessa all --path ./features/Core --settings ./tools/JSON/VBParams8310UF.json
    @IF ERRORLEVEL 1 goto error
@REM opm run vanessa all --path ./features/libraries --settings ./tools/JSON/VBParams8310UF.json
    @IF ERRORLEVEL 1 goto error
@REM opm run vanessa all --path ./features/StepsGenerator --settings ./tools/JSON/VBParams8310UF.json
    @IF ERRORLEVEL 1 goto error
@REM opm run vanessa all --path ./features/StepsProgramming --settings ./tools/JSON/VBParams8310UF.json
    @IF ERRORLEVEL 1 goto error
@REM opm run vanessa all --path ./features/StepsRunner --settings ./tools/JSON/VBParams8310UF.json
    @IF ERRORLEVEL 1 goto error

@goto end

:error

@echo ОШИБКА!
@goto end

:end
