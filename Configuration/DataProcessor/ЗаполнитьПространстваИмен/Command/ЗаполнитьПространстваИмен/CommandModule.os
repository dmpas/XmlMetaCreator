﻿&НаСервере
Процедура ОбработкаНаСервере()
	
	Обработка = Обработки.ЗаполнитьПространстваИмен.Создать();
	Обработка.ЗаполнитьПространстваИмен();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОбработкаНаСервере();
	
КонецПроцедуры
