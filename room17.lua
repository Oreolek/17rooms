-- Доступное пространство имён для объектов - все имена объектов должны начинаться с "room17_" или "cherdak_"
-- Все описания можно менять
-- Задача: Это изначально тёмная комната. Игрок может придти как с источником света, так и без него. Задача - найти предмет circlekey
room {
	nam = "room17_cherdak";
	title = "Чердак";
	lock_down = false;
	cornice_seen = false;
	door_seen = false;
	dsc = "Почти нет пыли. Уютно, хоть и пустовато.";
	dark_dsc = "Здесь темно, единственный выход вниз.";
	d_to = function(s)
		if not (have("room17_canvas") or have("room17_box") or have("room17_letter") or have("room17_mask")) then
			return 'room14_secondfloor';
		else
			pn [[По какой-то причине ты оказалась тут снова. Чудеса!]];
			return "room17_cherdak"
		end;
	end;
-------
	before_Walk  = function (s,w)
		if w ^ '@d_to' then
			if s.lock_down then
				pn [[Странное дело - пути вниз теперь нет.]];
				return true;
			else
				return false;
			end;
		else
			return false;
		end;
	end;
-------
	before_Listen = "Ничего не слышно.";
	before_Smell = "Ничем не пахнет.";
	obj = {"room17_woodtable",
			"room17_door",
			"room17_walls",
			"room17_wall",
	 };
--};
}: attr '~light'


obj {
	-"стол,деревянный стол";
	nam = "room17_woodtable";
	before_Exam  = function(s)
		if not (_"room17_box":inside("room17_woodtable")) and _"room17_mask":has'worn' then
			p "На столешнице видна надпись «Поставь на меня».^Странно. Раньше вроде не было её.";
		else
			p "Деревянный, немного пыльный стол";
		end;
		return true;
	end;
	description = "Деревянный стол.";
}:attr 'supporter,static'

obj {
	-"коробка";
	nam = "room17_box";
	before_Exam  = function(s)
		if _"room17_mask":has'worn' then
			pn "На коробке видна надпись «Наполни меня».^Странно. Раньше вроде не было её.";
		else
			pn "Похоже, что самая обычная коробка.";
		end;
		if s:has "open" then
			content(s);
		end;
		return true;
	end;
	description = "Картонная коробка.";
	found_in = { 'room17_woodtable' }
}:attr 'container,openable'

obj {
	-"маска";
	nam = "room17_mask";
	description = "Театральная маска с длинным носом.";
	before_Wear = function(s)
		enable("room17_wall");
		--disable '@d_to'
		here().lock_down = true;

		if here().cornice_seen then
			enable("room17_cornice");
		end;

		if here().door_seen then
			enable("room17_door");
		end;

		mp:clear();
		return false;
	end;
	after_Wear = function(s)
		pn [[Ты надеваешь маску.]];
		p [[^Обстановка комнаты изменилась.]];
		return true;
	end;
	before_Disrobe = function(s)
		return false;
	end;
	after_Disrobe = function(s)
			--enable '@d_to'
		here().lock_down = false;
		pn [[Ты снимаешь маску.]];
		p [[^Обстановка комнаты изменилась.]];
		mp:clear();

		here().cornice_seen = not _'room17_cornice':disabled();
		here().door_seen = not _'room17_door':disabled();

		disable("room17_wall");
		disable("room17_cornice");
		disable("room17_door");
		return true;
	end;
	found_in = { 'room17_box' }
}:attr 'clothing'

obj {
	-"холст";
	nam = "room17_canvas";
	get_from_carnise = false;
	description = "Холст.";
	before_Take = function (s, w)
		if parent (s) == _"room17_cornice" then
			s.get_from_carnise = true;
			enable("room17_door");
			return false;
		else
			return false;
		end;
	end;
	after_Take = function (s, w)
		if s.get_from_carnise then
			pn [[Ты берёшь холст. ^]];
			pn [[Позади холста обнаружилась маленькая дверца.]];
			s.get_from_carnise = false;
			return true;
		else
			return false
		end;
	end;
	before_Tear = function (s, w)
		if parent (s) == _"room17_cornice" then
		s.get_from_carnise = true;
			enable("room17_door");
			return false;
		end;
	end;
	after_Tear= function (s, w)
		if s.get_from_carnise then
			pn [[Ты срываешь холст с карниза.^]];
			p [[Позади холста обнаружилась маленькая дверца.]];
			take(s);
			s.get_from_carnise = false;
			return true;
		else
			return false
		end;
	end;
	after_Exam = function(s)
		p [[На холсте нарисован очаг. В очаге горит огонь. На огне стоит котелок.^В котелке кипит баранья похлёбка с чесноком. Над котелком вьётся дым.]];
	end;
	after_PutOn = function(s, w)
		if not w ^ 'room17_cornice' then
			s.get_from_carnise = false;
			return false;
		else
			p [[Ты вешаешь холст на карниз.]];
			disable("room17_door");
			return true;
		end;
	end;
	found_in = { 'room17_cornice' };
}:disable():attr 'clothing'

obj {
	-"дверца";
	nam = "room17_door";
	description = function(s)
		p "Маленькая дверца.";
		return false;
--		mp:content(s);
	end;
	before_Unlock = function(s, w)
		p [[Не получается.]]
	end;
	before_Open = function(s, w)
		p [[Заперто.]]
	end;
	obj = {
		obj {
            -"замочная скважина,скважина";
			nam = "room17_keyhole";
            description = function(s)
				p [[Замочная скважина с латунной накладкой.]];
				return false;
			end;
        }:attr 'container, static, transparent, open';
		obj {
            -"латунная накладка,накладка";
			nam = "room17_platter";
            description = function(s)
				p [[Декоративная латунная накладка.]];
				return false;
			end;
        }:attr 'static,scenery';
	};
}:disable():attr 'container,static, open'

obj {
	-"записка,лист бумаги";
	nam = "room17_letter";
	description = "Записка.";
	after_Exam = function(s)
		if _"room17_mask":has'worn' then
			p [[«Эта дурацкая дверца раздражает. Три часа на неё пялюсь, не могу отсюда выбраться. Завешу её чем-нибудь.»^
				Похоже на почерк тёти Агаты.
				«Это невыносимо. Дурацкая дверца просто исчезла. Теперь ни дверцы, ни другого выхода. Сижу и таращусь на пустую стену.
				Лучше повесить холст обратно на карниз.»^
				Вторая строка писалась гораздо позже первой.^Буквы  крупнее и почерк неровный, но это всё ещё её почерк.]];
		else
			p [[«Дорогая Агата, возвращаю тебе эту забавную безделицу.^Признаться, я так и не смог разобраться  в её предназначении.
			^Наш общий знакомый, граф А., темнит и насвистывает какую-то глупую песенку про болото.
			^Возможно, в этом  есть  какой-то смысл. Возможно я упускаю из виду что-то лежащее на поверхности.
			^Представь себе, он  сказал мне с изрядной фамильярностью — "Джемс, вы слишком серьёзно к этому относитесь!" и показал "нос".
			^При удобном случае постарайся его разговорить.
			^Навеки твой. J. McP.»
			^Твёрдый мужской почерк. Интересно, кто такие граф А. и таинственный тётушкин «Навеки твой J. McP.»?]];
		end;
	end;
	found_in = { 'room17_box' };
}

obj {
	-"стены,стенки/мн";
	nam = "room17_walls";
	description = function(s)
		if _"room17_mask":has'worn' then
			p "Одна из стен привлекает ваше внимание.";
		else
			p "Пустые стены.";
		end;
	end;
}:attr 'static'

obj {
	-"стена,стенка/ед";
	nam = "room17_wall";
	before_Exam  = function(s)
		enable("room17_cornice");
		return false;
	end;
	description  = function(s)
		p [[Гладкая стена.]];
		return false;
	end;
}:disable():attr 'scenery, supporter'

obj {
	-"карниз,старый бронзовый карниз";
	nam = "room17_cornice";
	before_Exam  = function(s)
		enable("room17_canvas");
		return false;
	end;
	description = function(s)
		p "Обычный, немного потёртый бронзовый карниз, ";
		if parent 'room17_canvas' == s then
			p "с которого свисает обтрёпанный по краям холст.";
		else
			p "привинченный к стене.";
		end;
	end;
	found_in = { 'room17_wall' }
}:disable():attr 'static, supporter'

-- Менять нельзя!!!! Это не ваш предмет!!! Вы не знаете как он выглядит, его придумает другой автор!!!
--obj {
--	-"круглый ключ,ключ";
--	nam = "circlekey";
--	description = "Круглый ключ.";
--	found_in = { 'room17_keyhole' }
--}
--[[Изменить объект маски  - добавить включение и выключение объектов. Так же написать обработчики для следующих элементов паззла.
дополнить обработчики холста , разобраться с сорвать холст]]


Verb { "повес/ить",
	"{noun}/вн,held на {noun}/вн,supporter : PutOn",
	"~ на {noun}/вн,supporter {noun}/вн,held : PutOn reverse",
}
