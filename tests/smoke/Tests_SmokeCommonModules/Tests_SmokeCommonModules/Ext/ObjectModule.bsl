Var CoreContext;
Var Assertions;

#Region ServiceInterface

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

// Loads tests to the test runner data processor.
//
// Parameters:
//  TestsSet         - ExternalDataProcessorObject.ЗагрузчикФайла - file loader data processor.
//  CoreContextParam - ExternalDataProcessorObject.xddTestRunner  - test runner data processor. 
// 
Procedure ЗаполнитьНаборТестов(TestsSet, CoreContextParam) Export

	If CurrentRunMode() = ClientRunMode.ManagedApplication Then
		Return;	
	EndIf;
	
    CoreContext = CoreContextParam;
    
    LoadSettings();
    LoadSubsystemTests(TestsSet, Settings.Subsystems); 
    LoadSmokeCommonModuleTests(TestsSet, Settings.Subsystems, 
        Settings.ExcludedCommonModules);
        
EndProcedure // ЗаполнитьНаборТестов()

#EndRegion // ServiceInterface

#Region TestCases

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
    ParentSubsystem = Metadata;
    For Each ParentName In SplitResult Do
        ParentSubsystem = ParentSubsystem.Subsystems.Find(ParentName);
        Assertions.ПроверитьТип(ParentSubsystem, "MetadataObject");
    EndDo;
    
EndProcedure // Fact_SubsystemExists()

// Tests whether client common module is set properly.
//
// Parameters:
//  CommonModuleName - String  - common module name.
//  Transaction      - Boolean - shows if transaction exist. 
//                      Default value: False.
//
Procedure Fact_ClientModule(CommonModuleName, Transaction = False) Export
    
    Module = Metadata.CommonModules.Find(CommonModuleName);
    
    Assertions.ПроверитьТип(Module, "MetadataObject");
     
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
		
		If Metadata.DefaultRunMode = ClientRunMode.OrdinaryApplication Then
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

// Tests whether global common module is set properly.
//
// Parameters:
//  CommonModuleName - String  - common module name.
//  Transaction      - Boolean - shows if transaction exist. 
//                      Default value: False.
//
Procedure Fact_GlobalModule(CommonModuleName, Transaction = False) Export
    
    Module = Metadata.CommonModules.Find(CommonModuleName);
    
    Assertions.ПроверитьТип(Module, "MetadataObject");
     
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
		
		If Metadata.DefaultRunMode = ClientRunMode.OrdinaryApplication Then		
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

// Tests whether server call common module is set properly.
//
// Parameters:
//  CommonModuleName - String  - common module name.
//  Transaction      - Boolean - shows if transaction exist. 
//                      Default value: False.
//
Procedure Fact_ServerCallModule(CommonModuleName, Transaction = False) Export
    
    Module = Metadata.CommonModules.Find(CommonModuleName);
    
    Assertions.ПроверитьТип(Module, "MetadataObject");
     
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
		
		If Metadata.DefaultRunMode = ClientRunMode.OrdinaryApplication Then		
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

// Tests whether server common module is set properly.
//
// Parameters:
//  CommonModuleName - String  - common module name.
//  Transaction      - Boolean - shows if transaction exist. 
//                      Default value: False.
//
Procedure Fact_ServerModule(CommonModuleName, Transaction = False) Export
    
    Module = Metadata.CommonModules.Find(CommonModuleName);
    
    Assertions.ПроверитьТип(Module, "MetadataObject");
     
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
		
		If Metadata.DefaultRunMode = ClientRunMode.OrdinaryApplication Then		
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

// Tests whether server common module with full access rights is set properly.
//
// Parameters:
//  CommonModuleName - String  - common module name.
//  Transaction      - Boolean - shows if transaction exist. 
//                      Default value: False.
//
Procedure Fact_FullAccessModule(CommonModuleName, Transaction = False) Export
    
    Module = Metadata.CommonModules.Find(CommonModuleName);
    
    Assertions.ПроверитьТип(Module, "MetadataObject");
     
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

// Tests whether client-server common module is set properly.
//
// Parameters:
//  CommonModuleName - String  - common module name.
//  Transaction      - Boolean - shows if transaction exist. 
//                      Default value: False.
//
Procedure Fact_ClientServerModule(CommonModuleName, Transaction = False) Export
    
    Module = Metadata.CommonModules.Find(CommonModuleName);
    
    Assertions.ПроверитьТип(Module, "MetadataObject");
     
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
		
		If Metadata.DefaultRunMode = ClientRunMode.OrdinaryApplication Then		
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

#Region Internal

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
Function _StrSplit(Val String, Val Separator, IncludeBlank = True) Export
    
    SplitResult = New Array;
    
    If IsBlankString(String) Then 
        If IncludeBlank Then
            SplitResult.Add(String);
        EndIf;
        Return SplitResult;
    EndIf;
        
    Position = Find(String, Separator);
    While Position > 0 Do
        Substring = Left(String, Position - 1);
        If IncludeBlank Or Not IsBlankString(Substring) Then
            SplitResult.Add(Substring);
        EndIf;
        String = Mid(String, Position + StrLen(Separator));
        Position = Find(String, Separator);
    EndDo;

    If IncludeBlank Or Not IsBlankString(String) Then
        SplitResult.Add(String);
    EndIf;

    Return SplitResult;
    
EndFunction // _StrSplit()

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
    Val Value9 = Undefined, Val Value10 = Undefined) Export
 
    Template = StrReplace(Template, "%1", String(Value1));
    Template = StrReplace(Template, "%2", String(Value2));
    Template = StrReplace(Template, "%3", String(Value3));
    Template = StrReplace(Template, "%4", String(Value4));
    Template = StrReplace(Template, "%5", String(Value5));
    Template = StrReplace(Template, "%6", String(Value6));
    Template = StrReplace(Template, "%7", String(Value7));
    Template = StrReplace(Template, "%8", String(Value8));
    Template = StrReplace(Template, "%9", String(Value9));
    Template = StrReplace(Template, "%10", String(Value10));

    Return Template;

EndFunction // _StrTemplate()

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
Function NewSmokeCommonModulesSettings() Export
    
    SmokeCommonModulesSettings = New Structure;
    SmokeCommonModulesSettings.Insert("Subsystems", New Array);
    SmokeCommonModulesSettings.Insert("ExcludedCommonModules", New Array);
    SmokeCommonModulesSettings.Subsystems.Add("*");
    Return SmokeCommonModulesSettings;
    
EndFunction // NewSmokeCommonModulesSettings()

Function ReturnValuesReuseDontUse(CommonModuleName) Export
	CommonModule = Metadata.CommonModules.Find(CommonModuleName);
	Return CommonModule.ReturnValuesReuse = Metadata.ObjectProperties.ReturnValuesReuse.DontUse;
EndFunction

Function DefaultRunMode() Export
	Return Metadata.DefaultRunMode; 
EndFunction

Function CommonModule(CommonModuleName) Export
	
	Result = New Structure;
	Result.Insert("Global", False);
	Result.Insert("ClientManagedApplication", False);
	Result.Insert("Server", False);
	Result.Insert("ExternalConnection", False);
	Result.Insert("ServerCall", False);
	Result.Insert("Privileged", False);
	
	FillPropertyValues(Result, Metadata.CommonModules.Find(CommonModuleName));
	
	Return Result;
	
EndFunction	

Function CommonModules() Export
	
	Result = New Array;
	
	For Each CommonModule In Metadata.CommonModules Do
		
		mCommonModule = New Structure;
		mCommonModule.Insert("Name", CommonModule.Name);
		mCommonModule.Insert("Comment", CommonModule.Comment);
		Result.Add(mCommonModule);
		
	EndDo;
	
	Return Result;
	
EndFunction

Function SubsystemContent(SubsystemName) Export
	
	Subsystem = Metadata.Subsystems.Find(SubsystemName);
	Result = New Array;
	
	For Each Item In Subsystem.Content Do
		mItem = New Structure;
		mItem.Insert("Name", Item.Name);
		mItem.Insert("FullName", Item.FullName());
		mItem.Insert("Comment", Item.Comment);
		Result.Add(mItem);
	EndDo;
	
	Return Result;
	
EndFunction

Function FindSubsystem(ParentSubsystemName, SubsystemName) Export
	
	If ParentSubsystemName = "Metadata" Or ParentSubsystemName = Undefined Then
		ParentSubsystem = Metadata;
	Else
		ParentSubsystem = Metadata.Subsystems.Find(ParentSubsystemName);
	EndIf;
	ParentSubsystem = ParentSubsystem.Subsystems.Find(SubsystemName);
	If ParentSubsystem <> Undefined Then
		Return ParentSubsystem.Name;
	Else
		Return Undefined;
	EndIf;	
	
EndFunction

#EndRegion // Internal

#Region ServiceProceduresAndFunctions

// Only for internal use.
//
Procedure Fact_ModuleReuseReturnValues(CommonModuleName, Module)
    
    If Find(CommonModuleName, "ReUse") <> 0
        Or Find(CommonModuleName, "Cached") <> 0 
        Or Find(CommonModuleName, "ПовтИсп") <> 0 Then
        
        Assertions.ПроверитьНеРавенство(Module.ReturnValuesReuse, 
            Metadata.ObjectProperties.ReturnValuesReuse.DontUse,
            CommonModuleName);
            
    Else

        Assertions.ПроверитьРавенство(Module.ReturnValuesReuse, 
            Metadata.ObjectProperties.ReturnValuesReuse.DontUse, 
            CommonModuleName);
        
    EndIf;
            
EndProcedure // Fact_ModuleReuseReturnValues() 

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

// Loads smoke tests settings. 
//
Procedure LoadSettings()
    
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
    
    Settings = New FixedStructure(Settings);
    
EndProcedure // LoadSettings()

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
            |ru='Общий модуль : %1 {%2} - проверка наименования общего модуля';
            |uk='Загальний модуль : %1 {%2}';
            |en_CA='Common module : %1 {%2} - checking name of common module'"), 
        CommonModule.Name, CommonModule.Comment));    
            
EndProcedure // AddSmokeCommonModuleTest()

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

// Only for internal use.
//
Procedure LoadSmokeCommonModuleTests(TestsSet, Subsystems, 
    ExcludedCommonModules)
    
    If Subsystems.Find("*") <> Undefined Then
        
        GroupCommonModulesNotExists = True;
        For Each CommonModule In Metadata.CommonModules Do
            
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
        ParentSubsystem = Metadata;
        Path = "";
        
        SplitResult = _StrSplit(SubsystemName, ".");
        For Each ParentName In SplitResult Do
            
            If ParentName = "*" Then
                OnlySubordinate = True;
                Break;
            EndIf;
            
            ParentSubsystem = ParentSubsystem.Subsystems.Find(ParentName);
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

// Only for internal use.
//
Procedure LoadSmokeCommonModuleTestsFromSubsystem(TestsSet, Subsystem, 
    SubsystemName, ExcludedCommonModules, GroupCommonModulesNotExists)

    CommonModules = Metadata.CommonModules;
    For Each Item In Subsystem.Content Do
        
        FullName = Item.FullName();
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

#EndRegion // ServiceProceduresAndFunctions