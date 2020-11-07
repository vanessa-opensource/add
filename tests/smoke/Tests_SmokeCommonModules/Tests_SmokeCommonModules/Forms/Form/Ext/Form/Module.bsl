&AtClient
Var CoreContext;
&AtClient
Var Assertions;

#Region ServiceInterface

&AtClient
// Connects and loads plugins needed for this test data processor.
//
// Parameters:
//  CoreContextParam - ExternalDataProcessorObject.xddTestRunner - test runner data processor. 
// 
Procedure Инициализация(CoreContextParam) Export
    
    CoreContext = CoreContextParam;
    Assertions = CoreContext.Плагин("БазовыеУтверждения");
    
    LoadSettings();
    
EndProcedure // Инициализация()

&AtClient
// Loads tests to the test runner data processor.
//
// Parameters:
//  TestsSet         - ExternalDataProcessorObject.ЗагрузчикФайла - file loader data processor.
//  CoreContextParam - ExternalDataProcessorObject.xddTestRunner  - test runner data processor. 
// 
Procedure ЗаполнитьНаборТестов(TestsSet, CoreContextParam) Export
	
	If CurrentRunMode() = ClientRunMode.OrdinaryApplication Then
		Return;	
	EndIf;
	
    CoreContext = CoreContextParam;
    
    LoadSettings();
    LoadSubsystemTests(TestsSet, Object.Settings.Subsystems); 
    LoadSmokeCommonModuleTests(TestsSet, Object.Settings.Subsystems, Object.Settings.ExcludedCommonModules);
        
EndProcedure // ЗаполнитьНаборТестов()

#EndRegion // ServiceInterface

#Region TestCases

&AtClient
// Tests whether subsystem is installed.
//
// Parameters:
//  SubsystemName  - String  - subsystem name.
//  Transaction    - Boolean - shows if transaction exist. 
//                      Default value: False.
//  SubsystemOwner - String  - subsystem owner name.
//                      Default value: Undefined.
//
Procedure Fact_SubsystemExists(SubsystemName, Transaction = False) Export
    
	SplitResult = _StrSplit(SubsystemName, ".");    
	ParentSubsystemName = "etadata";
	For Each ParentName In SplitResult Do
	    ParentSubsystem = FindSubsystem(ParentSubsystem, ParentName);
		Assertions.ПроверитьИстину(ParentSubsystem <> Undefined, _StrTemplate(
        NStr("ru='Не удалось найти подсистему {%1}'"),
        SubsystemName));
	EndDo;
    
EndProcedure // Fact_SubsystemExists()

&AtClient
// Tests whether client common module is set properly.
//
// Parameters:
//  CommonModuleName - String  - common module name.
//  Transaction      - Boolean - shows if transaction exist. 
//                      Default value: False.
//
Procedure Fact_ClientModule(CommonModuleName, Transaction = False) Export
    
    Module = CommonModule(CommonModuleName);
     
    Assertions.ПроверитьЛожь(Module.Global, _StrTemplate( 
        NStr("en='Participation in global context creation {%1}';
            |ru='Участие в формировании глобального контекста {%1}';
            |uk='Участь у формуванні глобального контексту {%1}';
            |en_CA='Participation in global context creation {%1}'"),
        CommonModuleName));

    Assertions.ПроверитьИстину(Module.ClientManagedApplication, _StrTemplate(
        NStr("en='Use of managed application in the client {%1}';
            |ru='Использование в клиенте управляемого приложения {%1}';
            |uk='Використання в клієнті керованого додатку {%1}';
            |en_CA='Use of managed application in the client {%1}'"),
        CommonModuleName));
    
    Assertions.ПроверитьЛожь(Module.Server, _StrTemplate(
        NStr("en='Run on server in client/server mode {%1}';
            |ru='Выполнение на сервере в клиент-серверном варианте {%1}';
            |uk='Виконання на сервері в клієнт-серверному варіанті {%1}';
            |en_CA='Run on server in client/server mode {%1}'"),
        CommonModuleName));
    
    Assertions.ПроверитьЛожь(Module.ExternalConnection, _StrTemplate(
        NStr("en='Use in external connection {%1}';
            |ru='Использование во внешнем соединении {%1}';
            |uk='Використання в зовнішньому з''єднанні {%1}';
            |en_CA='Use in external connection {%1}'"),
        CommonModuleName));
		
		If DefaultRunMode() = ClientRunMode.OrdinaryApplication Then
			Assertions.ПроверитьИстину(Module.ClientOrdinaryApplication, _StrTemplate(
			NStr("en='Use of ordinary application in the client {%1}';
			|ru='Использование в клиенте обычного приложения {%1}';
			|uk='Використання в клієнті звичайного додатку {%1}';
			|en_CA='Use of ordinary application in the client {%1}'"),
			CommonModuleName));			
		EndIf; 
	    
    Assertions.ПроверитьЛожь(Module.ServerCall, _StrTemplate(
        NStr("en='Allows server call {%1}';
            |ru='Разрешает вызов сервера {%1}';
            |uk='Дозволяє виклик сервера {%1}';
            |en_CA='Allows server call {%1}'"),
        CommonModuleName));
        
    Fact_FullAccessRightsGranted(CommonModuleName, Module);
    Fact_ModuleReuseReturnValues(CommonModuleName, Module);
    
EndProcedure // Fact_ClientModule()

&AtClient
// Tests whether global common module is set properly.
//
// Parameters:
//  CommonModuleName - String  - common module name.
//  Transaction      - Boolean - shows if transaction exist. 
//                      Default value: False.
//
Procedure Fact_GlobalModule(CommonModuleName, Transaction = False) Export
    
    Module = CommonModule(CommonModuleName);
     
    Assertions.ПроверитьИстину(Module.Global, _StrTemplate( 
        NStr("en='Participation in global context creation {%1}';
            |ru='Участие в формировании глобального контекста {%1}';
            |uk='Участь у формуванні глобального контексту {%1}';
            |en_CA='Participation in global context creation {%1}'"),
        CommonModuleName));

    Assertions.ПроверитьИстину(Module.ClientManagedApplication, _StrTemplate(
        NStr("en='Use of managed application in the client {%1}';
            |ru='Использование в клиенте управляемого приложения {%1}';
            |uk='Використання в клієнті керованого додатку {%1}';
            |en_CA='Use of managed application in the client {%1}'"),
        CommonModuleName));
    
    Assertions.ПроверитьЛожь(Module.Server, _StrTemplate(
        NStr("en='Run on server in client/server mode {%1}';
            |ru='Выполнение на сервере в клиент-серверном варианте {%1}';
            |uk='Виконання на сервері в клієнт-серверному варіанті {%1}';
            |en_CA='Run on server in client/server mode {%1}'"),
        CommonModuleName));
    
    Assertions.ПроверитьЛожь(Module.ExternalConnection, _StrTemplate(
        NStr("en='Use in external connection {%1}';
            |ru='Использование во внешнем соединении {%1}';
            |uk='Використання в зовнішньому з''єднанні {%1}';
            |en_CA='Use in external connection {%1}'"),
        CommonModuleName));
		
		If DefaultRunMode() = ClientRunMode.OrdinaryApplication Then		
			Assertions.ПроверитьИстину(Module.ClientOrdinaryApplication, _StrTemplate(
			NStr("en='Use of ordinary application in the client {%1}';
			|ru='Использование в клиенте обычного приложения {%1}';
			|uk='Використання в клієнті звичайного додатку {%1}';
			|en_CA='Use of ordinary application in the client {%1}'"),
			CommonModuleName));
		EndIf;
	
    Assertions.ПроверитьЛожь(Module.ServerCall, _StrTemplate(
        NStr("en='Allows server call {%1}';
            |ru='Разрешает вызов сервера {%1}';
            |uk='Дозволяє виклик сервера {%1}';
            |en_CA='Allows server call {%1}'"),
        CommonModuleName));
        
    Fact_FullAccessRightsGranted(CommonModuleName, Module);
    Fact_ModuleReuseReturnValues(CommonModuleName, Module);
    
EndProcedure // Fact_GlobalModule()

&AtClient
// Tests whether server call common module is set properly.
//
// Parameters:
//  CommonModuleName - String  - common module name.
//  Transaction      - Boolean - shows if transaction exist. 
//                      Default value: False.
//
Procedure Fact_ServerCallModule(CommonModuleName, Transaction = False) Export
    
    Module = CommonModule(CommonModuleName);
     
    Assertions.ПроверитьЛожь(Module.Global, _StrTemplate(
        NStr("en='Participation in global context creation {%1}';
            |ru='Участие в формировании глобального контекста {%1}';
            |uk='Участь у формуванні глобального контексту {%1}';
            |en_CA='Participation in global context creation {%1}'"),
        CommonModuleName));

    Assertions.ПроверитьЛожь(Module.ClientManagedApplication, _StrTemplate(
        NStr("en='Use of managed application in the client {%1}';
            |ru='Использование в клиенте управляемого приложения {%1}';
            |uk='Використання в клієнті керованого додатку {%1}';
            |en_CA='Use of managed application in the client {%1}'"),
        CommonModuleName));
    
    Assertions.ПроверитьИстину(Module.Server, _StrTemplate(
        NStr("en='Run on server in client/server mode {%1}';
            |ru='Выполнение на сервере в клиент-серверном варианте {%1}';
            |uk='Виконання на сервері в клієнт-серверному варіанті {%1}';
            |en_CA='Run on server in client/server mode {%1}'"),
        CommonModuleName));
    
    Assertions.ПроверитьЛожь(Module.ExternalConnection, _StrTemplate(
        NStr("en='Use in external connection {%1}';
            |ru='Использование во внешнем соединении {%1}';
            |uk='Використання в зовнішньому з''єднанні {%1}';
            |en_CA='Use in external connection {%1}'"),
        CommonModuleName));
		
		If DefaultRunMode() = ClientRunMode.OrdinaryApplication Then		
			Assertions.ПроверитьЛожь(Module.ClientOrdinaryApplication, _StrTemplate(
			NStr("en='Use of ordinary application in the client {%1}';
			|ru='Использование в клиенте обычного приложения {%1}';
			|uk='Використання в клієнті звичайного додатку {%1}';
			|en_CA='Use of ordinary application in the client {%1}'"),
			CommonModuleName));
		EndIf;
	
    Assertions.ПроверитьИстину(Module.ServerCall, _StrTemplate(
        NStr("en='Allows server call {%1}';
            |ru='Разрешает вызов сервера {%1}';
            |uk='Дозволяє виклик сервера {%1}';
            |en_CA='Allows server call {%1}'"),
        CommonModuleName));
    
    Fact_FullAccessRightsGranted(CommonModuleName, Module);
    Fact_ModuleReuseReturnValues(CommonModuleName, Module);
    
EndProcedure // Fact_ServerCallModule()

&AtClient
// Tests whether server common module is set properly.
//
// Parameters:
//  CommonModuleName - String  - common module name.
//  Transaction      - Boolean - shows if transaction exist. 
//                      Default value: False.
//
Procedure Fact_ServerModule(CommonModuleName, Transaction = False) Export
    
    Module = CommonModule(CommonModuleName);
     
    Assertions.ПроверитьЛожь(Module.Global, _StrTemplate(
        NStr("en='Participation in global context creation {%1}';
            |ru='Участие в формировании глобального контекста {%1}';
            |uk='Участь у формуванні глобального контексту {%1}';
            |en_CA='Participation in global context creation {%1}'"),
        CommonModuleName));

    Assertions.ПроверитьЛожь(Module.ClientManagedApplication, _StrTemplate(
        NStr("en='Use of managed application in the client {%1}';
            |ru='Использование в клиенте управляемого приложения {%1}';
            |uk='Використання в клієнті керованого додатку {%1}';
            |en_CA='Use of managed application in the client {%1}'"),
        CommonModuleName));
    
    Assertions.ПроверитьИстину(Module.Server, _StrTemplate(
        NStr("en='Run on server in client/server mode {%1}';
            |ru='Выполнение на сервере в клиент-серверном варианте {%1}';
            |uk='Виконання на сервері в клієнт-серверному варіанті {%1}';
            |en_CA='Run on server in client/server mode {%1}'"),
        CommonModuleName));
    
    Assertions.ПроверитьИстину(Module.ExternalConnection, _StrTemplate(
        NStr("en='Use in external connection {%1}';
            |ru='Использование во внешнем соединении {%1}';
            |uk='Використання в зовнішньому з''єднанні {%1}';
            |en_CA='Use in external connection {%1}'"),
        CommonModuleName));
		
		If DefaultRunMode() = ClientRunMode.OrdinaryApplication Then		
			Assertions.ПроверитьИстину(Module.ClientOrdinaryApplication, _StrTemplate(
			NStr("en='Use of ordinary application in the client {%1}';
			|ru='Использование в клиенте обычного приложения {%1}';
			|uk='Використання в клієнті звичайного додатку {%1}';
			|en_CA='Use of ordinary application in the client {%1}'"),
			CommonModuleName));
		EndIf;
	
    Assertions.ПроверитьЛожь(Module.ServerCall, _StrTemplate(
        NStr("en='Allows server call {%1}';
            |ru='Разрешает вызов сервера {%1}';
            |uk='Дозволяє виклик сервера {%1}';
            |en_CA='Allows server call {%1}'"),
        CommonModuleName));
    
    Fact_FullAccessRightsGranted(CommonModuleName, Module);
    Fact_ModuleReuseReturnValues(CommonModuleName, Module);
    
EndProcedure // Fact_ServerModule()

&AtClient
// Tests whether server common module with full access rights is set properly.
//
// Parameters:
//  CommonModuleName - String  - common module name.
//  Transaction      - Boolean - shows if transaction exist. 
//                      Default value: False.
//
Procedure Fact_FullAccessModule(CommonModuleName, Transaction = False) Export
    
    Module = CommonModule(CommonModuleName);
     
    Assertions.ПроверитьЛожь(Module.Global, _StrTemplate(
        NStr("en='Participation in global context creation {%1}';
            |ru='Участие в формировании глобального контекста {%1}';
            |uk='Участь у формуванні глобального контексту {%1}';
            |en_CA='Participation in global context creation {%1}'"),
        CommonModuleName));

    Assertions.ПроверитьЛожь(Module.ClientManagedApplication, _StrTemplate(
        NStr("en='Use of managed application in the client {%1}';
            |ru='Использование в клиенте управляемого приложения {%1}';
            |uk='Використання в клієнті керованого додатку {%1}';
            |en_CA='Use of managed application in the client {%1}'"),
        CommonModuleName));
    
    Assertions.ПроверитьИстину(Module.Server, _StrTemplate(
        NStr("en='Run on server in client/server mode {%1}';
            |ru='Выполнение на сервере в клиент-серверном варианте {%1}';
            |uk='Виконання на сервері в клієнт-серверному варіанті {%1}';
            |en_CA='Run on server in client/server mode {%1}'"),
        CommonModuleName));
    
    Assertions.ПроверитьЛожь(Module.ExternalConnection, _StrTemplate(
        NStr("en='Use in external connection {%1}';
            |ru='Использование во внешнем соединении {%1}';
            |uk='Використання в зовнішньому з''єднанні {%1}';
            |en_CA='Use in external connection {%1}'"),
        CommonModuleName));
    
    Assertions.ПроверитьЛожь(Module.ClientOrdinaryApplication, _StrTemplate(
        NStr("en='Use of ordinary application in the client {%1}';
            |ru='Использование в клиенте обычного приложения {%1}';
            |uk='Використання в клієнті звичайного додатку {%1}';
            |en_CA='Use of ordinary application in the client {%1}'"),
        CommonModuleName));

    Assertions.ПроверитьЛожь(Module.ServerCall, _StrTemplate(
        NStr("en='Allows server call {%1}';
            |ru='Разрешает вызов сервера {%1}';
            |uk='Дозволяє виклик сервера {%1}';
            |en_CA='Allows server call {%1}'"),
        CommonModuleName));
    
    Fact_FullAccessRightsGranted(CommonModuleName, Module);
    Fact_ModuleReuseReturnValues(CommonModuleName, Module);
    
EndProcedure // Fact_FullAccessModule()

&AtClient
// Tests whether client-server common module is set properly.
//
// Parameters:
//  CommonModuleName - String  - common module name.
//  Transaction      - Boolean - shows if transaction exist. 
//                      Default value: False.
//
Procedure Fact_ClientServerModule(CommonModuleName, Transaction = False) Export
    
    Module = CommonModule(CommonModuleName);
         
    Assertions.ПроверитьЛожь(Module.Global, _StrTemplate(
        NStr("en='Participation in global context creation {%1}';
            |ru='Участие в формировании глобального контекста {%1}';
            |uk='Участь у формуванні глобального контексту {%1}';
            |en_CA='Participation in global context creation {%1}'"),
        CommonModuleName));

    Assertions.ПроверитьИстину(Module.ClientManagedApplication, _StrTemplate( 
        NStr("en='Use of managed application in the client {%1}';
            |ru='Использование в клиенте управляемого приложения {%1}';
            |uk='Використання в клієнті керованого додатку {%1}';
            |en_CA='Use of managed application in the client {%1}'"),
        CommonModuleName));
        
    Assertions.ПроверитьИстину(Module.Server, _StrTemplate(
        NStr("en='Run on server in client/server mode {%1}';
            |ru='Выполнение на сервере в клиент-серверном варианте {%1}';
            |uk='Виконання на сервері в клієнт-серверному варіанті {%1}';
            |en_CA='Run on server in client/server mode {%1}'"),
        CommonModuleName));
        
    Assertions.ПроверитьИстину(Module.ExternalConnection, _StrTemplate(
        NStr("en='Use in external connection {%1}';
            |ru='Использование во внешнем соединении {%1}';
            |uk='Використання в зовнішньому з''єднанні {%1}';
            |en_CA='Use in external connection {%1}'"),
        CommonModuleName));
		
		If DefaultRunMode() = ClientRunMode.OrdinaryApplication Then		
			Assertions.ПроверитьИстину(Module.ClientOrdinaryApplication, _StrTemplate(
			NStr("en='Use of ordinary application in the client {%1}';
			|ru='Использование в клиенте обычного приложения {%1}';
			|uk='Використання в клієнті звичайного додатку {%1}';
			|en_CA='Use of ordinary application in the client {%1}'"),
			CommonModuleName));
		EndIf;
	
    Assertions.ПроверитьЛожь(Module.ServerCall, _StrTemplate(
        NStr("en='Allows server call {%1}';
            |ru='Разрешает вызов сервера {%1}';
            |uk='Дозволяє виклик сервера {%1}';
            |en_CA='Allows server call {%1}'"),
        CommonModuleName));   
        
    Fact_FullAccessRightsGranted(CommonModuleName, Module);
    Fact_ModuleReuseReturnValues(CommonModuleName, Module);
    
EndProcedure // Fact_ClientServerModule()

#EndRegion // TestCases

#Region ServiceProceduresAndFunctions

&AtClient
// Only for internal use.
//
Procedure Fact_ModuleReuseReturnValues(CommonModuleName, Module)
    
    If Find(CommonModuleName, "ReUse") <> 0
        Or Find(CommonModuleName, "Cached") <> 0 
        Or Find(CommonModuleName, "ПовтИсп") <> 0 Then
        
        Assertions.ПроверитьНеРавенство(
			ReturnValuesReuseDontUse(CommonModuleName), 
            True,
            CommonModuleName);
            
    Else

        Assertions.ПроверитьРавенство(
			ReturnValuesReuseDontUse(CommonModuleName), 
            True, 
            CommonModuleName);
        
    EndIf;
            
EndProcedure // Fact_ModuleReuseReturnValues() 

&AtClient
// Only for internal use.
//
Procedure Fact_FullAccessRightsGranted(CommonModuleName, Module)
    
    If Find(CommonModuleName, "FullAccess") <> 0
        Or Find(CommonModuleName, "ПолныеПрава") <> 0 Then
        
        Assertions.ПроверитьИстину(Module.Privileged, _StrTemplate(
            NStr("en='Full access rights granted {%1}';
                |ru='Предоставляются полные права доступа {%1}';
                |uk='Надаються повні права доступу {%1}';
                |en_CA='Full access rights granted {%1}'"),
            CommonModuleName));
            
    Else

         Assertions.ПроверитьЛожь(Module.Privileged, _StrTemplate(
            NStr("en='Full access rights granted {%1}';
                |ru='Предоставляются полные права доступа {%1}';
                |uk='Надаються повні права доступу {%1}';
                |en_CA='Full access rights granted {%1}'"),
            CommonModuleName));
            
    EndIf;
    
EndProcedure // Fact_FullAccessRightsGranted()

&AtClient
// Loads smoke tests settings. 
//
Procedure LoadSettings()
	
	If ValueIsFilled(Object.Settings) Then
		Return;
	EndIf;
	
    SettingsPath = "SmokeCommonModules";
    SettingsPlugin = CoreContext.Плагин("Настройки");
    SettingsPlugin.Инициализация(CoreContext);
    
    Settings = SettingsPlugin.ПолучитьНастройку(SettingsPath);
    If TypeOf(Settings) <> Type("Structure") Then
        Settings = NewSmokeCommonModulesSettings();
    EndIf;
    
    If Not Settings.Property("Subsystems") Then
        Settings.Insert("Subsystems", New Array);
        Settings.Subsystems.Add("*");
    EndIf;
    
    If Not Settings.Property("ExcludedCommonModules") Then
        Settings.Insert("ExcludedCommonModules", New Array);    
    EndIf;
    
    Object.Settings = New FixedStructure(Settings);
    
EndProcedure // LoadSettings()

&AtClient
// Only for internal use.
//
Procedure AddSmokeCommonModuleTest(TestsSet, CommonModule)
    
    NameToAnalyze = CommonModule.Name;
    NameToAnalyze = StrReplace(NameToAnalyze, "Cached", "");
    NameToAnalyze = StrReplace(NameToAnalyze, "Overridable", "");
    NameToAnalyze = StrReplace(NameToAnalyze, "ReUse", "");
    NameToAnalyze = StrReplace(NameToAnalyze, "Переопределяемый", "");
    NameToAnalyze = StrReplace(NameToAnalyze, "ПовтИсп", "");
    SuffixPart = Right(NameToAnalyze, 6); 
    
    TestParameters = TestsSet.ПараметрыТеста(CommonModule.Name, False);
    If Find(CommonModule.Name, "ServerCall") <> 0
        Or Find(CommonModule.Name, "ВызовСервера") <> 0 Then
        
        TestName = "Fact_ServerCallModule";
        
    ElsIf Find(CommonModule.Name, "ClientServer") <> 0
        Or Find(CommonModule.Name, "КлиентСервер") <> 0 Then
        
        TestName = "Fact_ClientServerModule";
        
    ElsIf Find(CommonModule.Name, "Global") <> 0 
        Or Find(CommonModule.Name, "Глобальный") <> 0 Then
        
        TestName = "Fact_GlobalModule";
        
    ElsIf SuffixPart = "Client"
        Or SuffixPart = "Клиент" Then
        
        TestName = "Fact_ClientModule";
        
    ElsIf Find(CommonModule.Name, "ПолныеПрава") <> 0
        Or Find(CommonModule.Name, "FullAccess") <> 0 Then
        
        TestName = "Fact_FullAccessModule";
        
    Else
        
        TestName = "Fact_ServerModule";
        
    EndIf;
        
    TestsSet.Добавить(TestName, TestParameters, _StrTemplate(
        NStr("en='Common module : %1 {%2} - checking name of common module';
            |ru='Общий модуль : %1 {%2}';
            |uk='Загальний модуль : %1 {%2}';
            |en_CA='Common module : %1 {%2} - checking name of common module'"), 
        CommonModule.Name, CommonModule.Comment));    
            
EndProcedure // AddSmokeCommonModuleTest()

&AtClient
// Loads subsystem tests if settings is set.
//
// Parameters:
//  TestsSet - ExternalDataProcessorObject.ЗагрузчикФайла - file loader data processor. 
//
Procedure LoadSubsystemTests(TestsSet, Subsystems)
        
    GroupSubsystemsNotExists = True;    
    For Each SubsystemName In Subsystems Do
        
        If Find(SubsystemName, "*") = 0 Then
            
            If GroupSubsystemsNotExists Then
                
                GroupSubsystemsNotExists = False;
                TestsSet.НачатьГруппу(
                    NStr("en='Subsystems'; 
                        |ru='Подсистемы';
                        |uk='Підсистеми';
                        |en_CA='Subsystems'"), 
                    True);
            EndIf;     
                
            TestParameters = TestsSet.ПараметрыТеста(SubsystemName, False);
            TestsSet.Добавить("Fact_SubsystemExists", TestParameters, 
                _StrTemplate(NStr("en='Subsystem : %1 installed';
                        |ru='Подсистема : %1 установлена';
                        |uk='Підсистема : %1 встановлена';
                        |en_CA='Subsystem : %1 installed'"), 
                    SubsystemName));
            
        EndIf;
        
    EndDo;
        
EndProcedure // LoadSubsystemTests()

&AtClient
// Only for internal use.
//
Procedure LoadSmokeCommonModuleTests(TestsSet, Subsystems, 
    ExcludedCommonModules)
    
    If Subsystems.Find("*") <> Undefined Then
        
        GroupCommonModulesNotExists = True;
        For Each CommonModule In CommonModules() Do
            
            If ExcludedCommonModules.Find(CommonModule.Name) <> Undefined Then
                Continue;
            EndIf;
            
            If GroupCommonModulesNotExists Then
                
                GroupCommonModulesNotExists = False;
                TestsSet.НачатьГруппу(NStr("en='Common modules'; 
                        |ru='Общие модули';
                        |uk='Загальні модулі';
                        |en_CA='Common modules'")); 
                
            EndIf;
            
            AddSmokeCommonModuleTest(TestsSet, CommonModule); 
            
        EndDo;
        
        Return;
        
    EndIf;
    
    PathTemplate = "%1%2.";
    FullPathTemplate = "%1*";
    For Each SubsystemName In Subsystems Do
        
        OnlySubordinate = False;
        AlreadyProcessed = False;
		ParentSubsystemName = "Metadata";
        Path = "";
        
        SplitResult = _StrSplit(SubsystemName, ".");
        For Each ParentName In SplitResult Do
            
            If ParentName = "*" Then
                OnlySubordinate = True;
                Break;
            EndIf;
            
            ParentSubsystem = FindSubsystem(ParentSubsystemName, ParentName);
            If ParentSubsystem = Undefined Then
                Break;
            EndIf;
            
            If Subsystems.Find(_StrTemplate(FullPathTemplate, Path)) <> Undefined Then
                AlreadyProcessed = True;
                Break;
            EndIf;
            
            Path = _StrTemplate(PathTemplate, Path, ParentName);
            
        EndDo;
        
        If ParentSubsystem = Undefined Or AlreadyProcessed Then
            Continue;
        EndIf;
        
        GroupCommonModulesNotExists = True;
        If OnlySubordinate Then
            RecursivelyLoadSmokeCommonModuleTestsFromSubsystem(TestsSet, 
                ParentSubsystem, 
                SubsystemName, 
                ExcludedCommonModules, 
                GroupCommonModulesNotExists);            
        Else
            LoadSmokeCommonModuleTestsFromSubsystem(TestsSet, 
                ParentSubsystem,
                SubsystemName, 
                ExcludedCommonModules, 
                GroupCommonModulesNotExists);    
        EndIf;
        
    EndDo;
         
EndProcedure // LoadSmokeCommonModuleTests()

&AtClient
// Only for internal use.
//
Procedure LoadSmokeCommonModuleTestsFromSubsystem(TestsSet, Subsystem, 
    SubsystemName, ExcludedCommonModules, GroupCommonModulesNotExists)

    CommonModules = CommonModules();
    For Each Item In SubsystemContent(SubsystemName) Do
        
        FullName = Item.FullName;
        If Find(FullName, "CommonModule") <> 0
            Or Find(FullName, "ОбщийМодуль") <> 0 Then    
            
            If ExcludedCommonModules.Find(Item.Name) <> Undefined Then
                Continue;
            EndIf;
            
            If GroupCommonModulesNotExists Then
             
                GroupCommonModulesNotExists = False;
                TestsSet.НачатьГруппу(_StrTemplate(
                    NStr("en='Subsystem : %1 : CommonModules'; 
                        |ru='Подсистема : %1 : ОбщиеМодули';
                        |uk='Підсистема : %1 : ЗагальніМодулі';
                        |en_CA='Subsystem : %1 : CommonModules'"),
                    SubsystemName));
                    
            EndIf;

            AddSmokeCommonModuleTest(TestsSet, Item);   
            
        EndIf;    
            
    EndDo;
        
EndProcedure // LoadSmokeCommonModuleTestsFromSubsystem()

&AtClient
// Only for internal use.
//
Procedure RecursivelyLoadSmokeCommonModuleTestsFromSubsystem(TestsSet, 
    ParentSubsystem, SubsystemName, ExcludedCommonModules, GroupCommonModulesNotExists)
    
    For Each Subsystem In ParentSubsystem.Subsystems Do
        
        LoadSmokeCommonModuleTestsFromSubsystem(TestsSet, 
            Subsystem, 
            SubsystemName, 
            ExcludedCommonModules, 
            GroupCommonModulesNotExists);
            
        RecursivelyLoadSmokeCommonModuleTestsFromSubsystem(TestsSet, 
            Subsystem,
            SubsystemName, 
            ExcludedCommonModules, 
            GroupCommonModulesNotExists);      
            
    EndDo;
        
EndProcedure // RecursivelyLoadSmokeCommonModuleTestsFromSubsystem()

&AtServer
// Splits a string into parts according using the specified delimiter.
//
// Parameters:
//  String       - String  - string to be splitted. 
//  Separator    - String  - character string where every character is 
//                           an individual delimiter.
//  IncludeBlank - Boolean - shows if it is required to include the empty 
//                           strings which can result from a separation of 
//                           a source string while calculating the result.
//                      Default value: True.
//
// Returns:
//  Array - array with strings resulting from splitting of the source string.
//      * ArrayItem - String - part of string.
//
Function _StrSplit(Val String, Val Separator, IncludeBlank = True)
    Return Object()._StrSplit(String, Separator, IncludeBlank); 
EndFunction // _StrSplit()

&AtServer
// Inserts parameters into string by number.
//
// Parameters:
//  Template    – String – a string containing the substitution markers of type:
//                         "%1..%N". The markers are numbered starting with 0.
//  Value<1-10> - String - parameters containing arbitrary values possessing 
//                         string presentations which should be presented in a 
//                         template. 
// Returns:
//  String – template string with filled parameters.
//
Function _StrTemplate(Val Template, Val Value1, Val Value2 = Undefined, 
    Val Value3 = Undefined, Val Value4 = Undefined, Val Value5 = Undefined, 
    Val Value6 = Undefined, Val Value7 = Undefined, Val Value8 = Undefined, 
    Val Value9 = Undefined, Val Value10 = Undefined) 
	
	Return Object()._StrTemplate(Template, Value1, Value2, 
							    Value3, Value4, Value5, 
							    Value6, Value7, Value8, 
							    Value9, Value10);
								
EndFunction // _StrTemplate()

&AtServer
// Retuns basic smoke common modules settings.
//
// Returns:
//  Structure - basic smoke common modules settings.
//      * Subsystems - Array - subsystem names collection for which it's needed 
//                             to run smoke common modules tests. 
//                             If not set, smoke tests run without any restrictions.
//          ** ArrayItem - String - subsystem name.
//      * ExcludedCommonModules - Array - excluded common modules from smoke tests.
//          ** ArrayItem - String - common module name.
//
Function NewSmokeCommonModulesSettings()
	Return Object().NewSmokeCommonModulesSettings();
EndFunction // NewSmokeCommonModulesSettings()

&AtServer
Function ReturnValuesReuseDontUse(CommonModuleName)
	Return Object().ReturnValuesReuseDontUse(CommonModuleName);
EndFunction

&AtServer
Function DefaultRunMode()
	Return Object().DefaultRunMode(); 
EndFunction

&AtServer
Function CommonModule(CommonModuleName)
	Return Object().CommonModule(CommonModuleName) ;
EndFunction	

&AtServer
Function CommonModules()
	Return Object().CommonModules();	
EndFunction

&AtServer
Function SubsystemContent(SubsystemName)
	Return Object().SubsystemContent(SubsystemName);	
EndFunction

&AtServer
Function FindSubsystem(ParentSubsystemName, SubsystemName)
	Return Object().FindSubsystem(ParentSubsystemName, SubsystemName);	
EndFunction

&AtServer
Function Object()
	Return FormAttributeToValue("Object");	
EndFunction

#EndRegion // ServiceProceduresAndFunctions