﻿&НаКлиенте
Перем КонтекстЯдра;

// { Plugin interface

&НаКлиенте
Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
	КонтекстЯдра = КонтекстЯдраПараметр;
КонецПроцедуры

&НаКлиенте
Функция ОписаниеПлагина(КонтекстЯдра, ВозможныеТипыПлагинов) Экспорт
	Возврат ОписаниеПлагинаНаСервере(ВозможныеТипыПлагинов);
КонецФункции

&НаСервере
Функция ОписаниеПлагинаНаСервере(ВозможныеТипыПлагинов)
	КонтекстЯдраНаСервере = ВнешниеОбработки.Создать("xddTestRunner");
	Возврат ЭтотОбъектНаСервере().ОписаниеПлагина(КонтекстЯдраНаСервере, ВозможныеТипыПлагинов);
КонецФункции
// } Plugin interface

// { Helpers
&НаСервере
Функция ЭтотОбъектНаСервере()
	Возврат РеквизитФормыВЗначение("Объект");
КонецФункции
// } Helpers

&НаКлиенте
Процедура СформироватьФайл(КонтекстЯдра, Знач ПутьФайлаКодаВозврата, Знач РезультатыТестирования) Экспорт
	Объект.СостоянияТестов = КонтекстЯдра.Объект.СостоянияТестов;
	
	СформироватьФайлКодаВозврата(ПутьФайлаКодаВозврата, РезультатыТестирования);
КонецПроцедуры

&НаКлиенте
Процедура СформироватьФайлКодаВозврата(Знач ПутьФайлаКодаВозврата, Знач РезультатыТестирования)
	Попытка
		КодВозврата = 0;
		Если Не ЗначениеЗаполнено(РезультатыТестирования) 
			ИЛИ РезультатыТестирования.Состояние = Объект.СостоянияТестов.Сломан 
			Или РезультатыТестирования.Состояние = Объект.СостоянияТестов.НеизвестнаяОшибка Тогда
			
			КодВозврата = 1;
		КонецЕсли;
		
		Сообщение = "КодВозврата " + КодВозврата;
		ЗафиксироватьВЖурналеРегистрации("xUnitFor1C", Сообщение);

		ЗаписьJSON = Новый ЗаписьJSON;
		ЗаписьJSON.ОткрытьФайл(ПутьФайлаКодаВозврата);
		ЗаписьJSON.ЗаписатьЗначение(КодВозврата);
		ЗаписьJSON.Закрыть();
	Исключение
		Инфо = ИнформацияОбОшибке();
		ОписаниеОшибки = "Ошибка формирования файла статуса возврата при выполнении тестов в пакетном режиме
		|" + ПодробноеПредставлениеОшибки(Инфо);
		
		ЗафиксироватьОшибкуВЖурналеРегистрации("xUnitFor1C", ОписаниеОшибки);
		Сообщить(ОписаниеОшибки, СтатусСообщения.ОченьВажное);
	КонецПопытки;
КонецПроцедуры

&НаСервере
Процедура ЗафиксироватьВЖурналеРегистрации(Знач ИдентификаторГенератораОтчета, Знач Описание)
	ЗаписьЖурналаРегистрации(ИдентификаторГенератораОтчета, УровеньЖурналаРегистрации.Информация, , , Описание);
КонецПроцедуры

&НаСервере
Процедура ЗафиксироватьОшибкуВЖурналеРегистрации(Знач ИдентификаторГенератораОтчета, Знач ОписаниеОшибки)
	ЗаписьЖурналаРегистрации(ИдентификаторГенератораОтчета, УровеньЖурналаРегистрации.Ошибка, , , ОписаниеОшибки);
КонецПроцедуры
