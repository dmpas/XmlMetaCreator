﻿Функция ОбработатьПакет(Знач Пакет)
	
	Код = Пакет.URIПространстваИмен;
	
	Пространство = Справочники.ПространстваИмен.НайтиПоНаименованию(Код, Истина);
	Если Не ЗначениеЗаполнено(Пространство) Тогда 
		
		Объект = Справочники.ПространстваИмен.СоздатьЭлемент();
		Объект.Наименование = Код;
		Объект.Записать();
		
		Пространство = Объект.Ссылка;
		
	КонецЕсли;
	
	ОбрабатыватьТипы = Новый Массив;
	
	Для Каждого мТип Из Пакет Цикл
		
		ИмяТипа = мТип.Имя;
		Тип = Справочники.Типы.НайтиПоНаименованию(ИмяТипа, Истина, , Пространство);
		Если Не ЗначениеЗаполнено(Тип) Тогда
			
			Тип = Справочники.Типы.СоздатьЭлемент();
			Тип.Наименование = ИмяТипа;
			Тип.УстановитьНовыйКод();
			Тип.Владелец = Пространство; 
			
			Тип.Записать(); // Записываем тип для использования в других типах
			
			ОбрабатыватьТипы.Добавить(мТип);
			
		КонецЕсли;
		
	КонецЦикла;
		
	Для Каждого мТип Из ОбрабатыватьТипы Цикл
		
		ИмяТипа = мТип.Имя;
		Тип = Справочники.Типы.НайтиПоНаименованию(ИмяТипа, Истина, , Пространство);
		Если ЗначениеЗаполнено(Тип) Тогда
			
			Тип = Тип.ПолучитьОбъект();
			Тип.Наименование = ИмяТипа;
			Тип.УстановитьНовыйКод();
			Тип.Владелец = Пространство; 
			
			Тип.Записать(); // Записываем тип для использования в других типах
			
			Если ТипЗнч(мТип) = Тип("ТипЗначенияXDTO") Тогда
				
				Если мТип.Фасеты <> Неопределено Тогда
					
					Если мТип.Фасеты.Перечисления <> Неопределено Тогда
						
						Тип.Тип = Перечисления.ТипыТипов.Перечисление;
						
						// Это какое-то перечисление
						
						Для Каждого мФасет Из мТип.Фасеты.Перечисления Цикл
							
							НоваяСтрока = Тип.Элементы.Добавить();
							НоваяСтрока.Имя = мФасет.Значение;
							
						КонецЦикла;
						
					КонецЕсли;
					
				КонецЕсли;
				
			Иначе
				
				Тип.Тип = Перечисления.ТипыТипов.Объект;
				Для Каждого мСвойство Из мТип.Свойства Цикл
					
					ПакетТипаСвойства = СериализаторXDTO.Фабрика.Пакеты.Получить(мСвойство.Тип.URIПространстваИмен);
					ПространствоТипаСвойства = ОбработатьПакет(ПакетТипаСвойства);
					ТипСвойства = Справочники.Типы.НайтиПоНаименованию(мСвойство.Тип.Имя, Истина, , ПространствоТипаСвойства);
					
					НоваяСтрока = Тип.Свойства.Добавить();
					НоваяСтрока.Имя = мСвойство.Имя;
					НоваяСтрока.Тип = ТипСвойства;
					
				КонецЦикла;
				
			КонецЕсли;
			
			Тип.Записать();
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Пространство;
	
КонецФункции

Процедура ЗаполнитьПространстваИмен() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ Ссылка ИЗ Справочник.ПространстваИмен";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Объект = Выборка.Ссылка.ПолучитьОбъект();
		Если Объект <> Неопределено Тогда
			Объект.Удалить();
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого мПакет Из СериализаторXDTO.Фабрика.Пакеты Цикл
		
		Если мПакет.URIПространстваИмен = "http://v8.1c.ru/8.1/data/enterprise/current-config" Тогда
			Продолжить;
		КонецЕсли;
		
		ОбработатьПакет(мПакет);
		
	КонецЦикла;
	
КонецПроцедуры
