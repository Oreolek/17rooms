-- Доступное пространство имён для объектов - все имена объектов должны начинаться с "room14_" или "secondfloor_" 
-- Все описания можно менять
-- Задача: Игрок должен найти в локации предмет bonekey, а также открыть проход на восток в спальню предметом circlekey и на запад в таинственную комнату предметом piramidekey, изначально проходы должны быть перекрыты
-- Игрок может придти в локацию как с одним и обоими ключами, так и без них, и иметь возможность спустится вниз или поднятся наверх

	--e_to = 'room15_bedroom';
	--w_to = 'room16_mystical';

obj {

	-"пирамидальный ключ, ключ|пирамидка, пирамидка с письменами, письмена";
	nam = "piramidekey";
	description = "Пирамидальный ключ. Небольшая деревянная треугольная пирамидка. С древними письменами на ней.";
	inv = "пирамидальный ключ";
--	found_in = {'room14_secondfloor'}
        score=false;
        after_Take = function(s)
          if not s.score then
            mp.score=mp.score+1;
          end;
          _'piramidekey'.score=true;
          return false;
        end;

}

obj {
	-"круглый ключ, ключ|ригельный ключ";
	nam = "circlekey";
	description = "Круглый ключ. Толстый стальной ригельный. Сантиметров шестнадцать в длину. Увесистый.";
	inv = "круглый ключ";
--	found_in = {'room14_secondfloor'};
found_in = { 'room17_keyhole' };
        score=false;
        after_Take = function(s)
          if not s.score then
            mp.score=mp.score+1;
          end;
          _'circlekey'.score=true;
          return false;
        end;
}



room {
	-"коридор/мр|комната/жр|второй этаж, этаж";
	nam = "room14_secondfloor";
	title = "Второй этаж. Коридор.";
	dsc = function(s) 
		_'room14_secondfloor'.scope:add("room14_floor");
		pr"В одном конце широкого коридора лестница,"
		if _"room14_plan".seen == true or _"room17_cherdak":visited() then
			pr" ведущая на чердак.";
		else
			pr" ведущая наверх.";
		end
		pr" Рядом с лестницей стоит стальная напольная вешалка"
		if _"room14_dress".worn == true then
			pr", на которой висит моя одежда. ";
		else
			pr", на которой висит вечернее платье. ";
		end
		p[[В противоположной конце — лестница, ведущая вниз, в зал. Справа по коридору]];
		if _"room14_platform".door == true then
			p[[проход]];
			if _"room14_plan".seen == true or _'room16_mystical':visited() then
				p"в таинственную комнату. C правой стороны от прохода висит картина.";
			else
				p"на запад. C правой стороны от прохода висит картина.";
			end
		else
			p[[деревянная дверь, ведущая]]
			if _"room14_plan".seen == true or _'room16_mystical':visited() then
				p"в таинственную комнату. C правой стороны от двери висит картина.";
			else
				p"на запад. C правой стороны от двери висит картина."
			end
		end
		if _"room14_drawer".moving == false then
			pr[[Под картиной находится громоздкий комод. На комоде стоит стеклянная витрина. ]];
		end
		pr[[Слева по коридору посреди стены большое двухметровое зеркало. ]];
		if _"room14_hole".door == true and _"room14_door1".seen == true then
			pr" Справа от него проход";
			if _"room14_plan".seen == true or _"room15_bedroom":visited() then
				pr" в спальню ";
			else
				pr" на восток ";
			end
			p"и стальная дверь, скрывшаяся в стене.";
		elseif _"room14_door1".seen == true then
			pr"Справа от него стальная дверь, скрывшаяся в стене. ";
		end
		p[[Справа от зеркала — женский манекен.]];
		if _"room14_carpet".moving == true then
			p[[На полу лежит свёрнутый роскошный персидский ковёр.]];
			if _"room14_drawer".moving == true then
				p"На пластине в центре пола стоит комод. На комоде стоит стеклянная витрина.";
			else
				p"В центре пола находится пластина.";
			end
		else
			if _"room14_drawer".moving == true then
				p[[На полу лежит роскошный персидский ковёр, на котором стоит комод. На комоде стоит стеклянная витрина.]];
			else
				p[[На полу лежит роскошный персидский ковёр.]];
			end
		end
		if _"room14_glove".seen == false then
			p"Кажется, из-под ковра что-то торчит.";
		else 
			p"Из-под ковра торчит перчатка горничной.";
		end
			p[[Недалеко от зеркала на стене]];
		if _"room14_plan".seen == false then
			p 'какая-то схема.';
		else
			p 'план комнаты.^ На востоке, судя по схеме, должна быть спальня. А на западе — таинственная комната. Внизу на первом этаже — зал. А лестница в конце коридора ведёт наверх, на чердак.';
		end

	end;
	before_Attack = function(s)
		p"Ты не собираешься ничего ломать в доме тёти. Конечно, ты немного ей завидуешь, но не настолько.";
	end;
	before_Walk = function(s, ev)
		if _"room14_dress".worn then
			return "Ты не можешь разгуливать по дому в чужом платье. Тем более, в таком неудобном.";
		elseif ev == _'@e_to' and _"room14_hole".door ~= true then
			p"Этот путь не доступен.";
		elseif ev == _'@w_to' and _"room14_platform".door ~= true then
			p"Этот путь не доступен";
		elseif  pl:have(_"room14_box1") or pl:have(_"room14_box2") then
			p"Ты думаешь, что тебе совершенно незачем таскать с собой ящик комода.";
		elseif pl:have(_"room14_report") then
			p"Ты думаешь, что тебе совершенно незачем таскать с собой папку с бумагами.";
		else
			return false
		end
	end;
	before_Take = function (s, w)
	if w == _'@all' then
		p"Тут слишком много всего. Нужно выбрать что-то одно.";
	else 
		return false
	end
	end;
	e_to = '';
	w_to = '';
	compass_look = function(s,dir)
			p 'Не стоит заглядываться по сторонам, лучше сосредоточиться на том что происходит в комнате.';
	end;

	d_to = 'room10_zal';
	u_to = 'room17_cherdak';
	before_Listen = "Ничего не слышно.";
	scope = { };
	

}: with {'room14_wardrobe', 'room14_door', 'room14_carpet', 'room14_plan', 'room14_stairs', 'room14_ladder', 'room14_dress', 
'room14_cloth', 'room14_mirror', 'room14_dummy', 'room14_picture', 'room14_drawer', 'room14_showcase', 'room14_walls','room14_ceiling'}





-- Менять нельзя!!!! Это не ваш предмет!!! Вы не знаете как он выглядит, его придумает другой автор!!!
--obj {
--	-"костяной ключ,ключ";
--	nam = "bonekey";
--	description = "Костяной ключ";
--	found_in = { 'room14_box1' };
--}




--Декорации

obj {
	-"лестница наверх, лестница ведущая наверх, лестница";
	nam = "room14_stairs";
	Exam = function(s)
		if _"room14_plan".seen == true or _"room17_cherdak":visited() then
			p"Лестница, ведущая наверх, на чердак.";	
		else
			p"Лестница, ведущая наверх.";
		end
	end;
}:attr 'scenery'

obj {
	-"лестница вниз, лестница ведущая вниз, лестница";
	nam = "room14_ladder";
	Exam = function(s)
		if _"room14_plan".seen == true or _'room10_zal':visited() then
			p"Лестница, ведущая вниз, в зал.";
		else
			p"Лестница, ведущая вниз.";
			
		end
	end;
}:attr 'scenery'



--"вешалка"
obj {
	-"вешалка, стальная вешалка, напольная вешалка";
	nam = "room14_wardrobe";
	description = "Стальная напольная вешалка, ножки которой надёжно прикручены к полу.";
	scope = {};
	before_Exam = function(s)
		_"room14_wardrobe".scope:add("room14_wardrobe1");
	return false
	end;
}:attr 'scenery'

obj {
	-"ножки, ножки вешалки";
	nam = "room14_wardrobe1";
	description = "Ножки cтальной напольной вешалки, надёжно прикрученные к полу.";
}:attr 'scenery'

--"дверь"
obj {
	-"деревянная дверь, дверь";
	nam = "room14_door";
	description = "Массивная деревянная дверь. Что удивительно: нет ни дверной ручки, ни замочной скважины.";
	['before_Walk,Enter'] = function(s)
		p"Деревянная дверь заперта. В неё невозможно войти."
	end
}:attr 'scenery'

obj {
	-"стальная дверь, дверь";
	nam = "room14_door1";
	seen = false;
	description = "Прямоугольный лист металла, встроенный в стену. Нет ни дверной ручки, ни петель, ни замочной скважины. Лишь форма напоминает, что это массивная стальная дверь.";
	before_Exam = function(s)
		if _"room14_hole".door == true then
			p"Стальная дверь полностью скрылась в стене."
		else
			return false
		end
	end;
	['before_Walk,Enter'] = function(s)
	if _"room14_hole".door == true then
		p"Стальная дверь полностью скрылась в стене. В неё невозможно войти."
	else
		p"Стальная дверь заперта. В неё невозможно войти."
	end
	end;

}:attr 'scenery'


obj {
	-"схема, схема комнаты|план,план комнаты";
	nam = "room14_plan";
	seen = false;
	scope = { };

	before_Exam = function(s)
		_"room14_plan".scope:add("room14_paper");
		_"room14_plan".scope:add("room14_glass");
		_"room14_plan".scope:add("room14_ink");

		if _"room14_plan".seen then
			p [[Пожелтевший листок бумаги с планом комнаты.  На востоке — спальня. А на западе — таинственная комната. 
			Внизу на первом этаже — зал. А лестница в конце коридора ведёт наверх, на чердак.]];
		else
			_"room14_plan".seen = true;
			
	
			p [[Присмотревшись к пожелтевшему от времени листку бумаги, закреплённому в рамке за стеклом, ты заметила, что грубоватые штрихи выцветших чернил, на самом деле не что иное, как
			план комнаты!^ 
			Что странно: на востоке, судя по схеме, должна быть спальня. А на западе — таинственная комната. 
			Внизу на первом этаже — зал. А лестница в конце коридора ведёт наверх, на чердак.]];
		end
	end;
	
}:attr 'scenery'

obj {
	-"бумага|лист, листок, листок бумаги";
	nam = "room14_paper";
	description = "Кроме изображённой на нём схемы листок бумаги более ничем не примечателен.";
	Exam = function(s)	
		if _"room14_plan".seen ~= true then
			return false
	   	else
			p"Кроме изображённой на нём схемы листок бумаги более ничем не примечателен.";
		end
	end;


	}:attr"scenery"
obj {
	-"стекло";
	nam = "room14_glass";
	description = "Обычное прозрачное стекло, за которым находится план комнаты.";

}:attr"scenery"

obj {
	-"грубоватые штрихи, штрихи, старые штрихи, полустёртые штрихи, старые полустёртые штрихи| выцветшие чернила, чернила, синие чернила";
	nam = "room14_ink";
	description = "Старые полустёртые штрихи, нанесённые синими чернилами. Ничего интересного.";
}:attr"scenery"






																--	СПАЛЬНЯ

obj {
	-"картина";
	nam = "room14_picture";
	description = "Портрет молодой тёти Агаты и её мужа. Обнявшись, они стоят в комнате рядом с зеркалом. Тетя Агата в платье, а её муж в строгом фраке. Кажется, они выглядят счастливыми. Наверное, портрет был сделан вскоре после их свадьбы.";
	seen = false;
	before_Exam = function(s)
		_"room14_picture".seen = true;
		return false
	end;
}:attr"scenery"



-- Одежда
obj {
	-"платье|вечернее платье";
	nam = "room14_dress";
	--description = "Тёмно-синее лаконичное вечернее платье прямого покроя с отдельными кружевными элементами на рукавах и глубоким вырезом. Идеально подчеркнёт женственные формы, которых у тебя нет.";
	worn = false;

	before_Exam = function(s)
		if _"room14_picture".seen == true then
			p[[Тёмно-синее лаконичное вечернее платье прямого покроя с отдельными кружевными элементами на рукавах и глубоким вырезом. Идеально подчеркнёт женственные формы, которых у тебя нет. 
			Кажется, оно чем-то напоминает платье с картины.]];
		else
			p"Тёмно-синее лаконичное вечернее платье прямого покроя с отдельными кружевными элементами на рукавах и глубоким вырезом. Идеально подчеркнёт женственные формы, которых у тебя нет.";
		end
	end;
	--, w:noun'вн'
	before_Wear = function(s,w)
	--		if w ~= "" then
--				p("Судя по размерам, платье для этого не предназначено.");
--		
	--		else
			p"Ты разделась и повесила свою одежду на вешалку. А затем осторожно взяв вечернее платье надела его.";
			_"room14_dress".worn = true;
	--		end

	end;

	before_Take = function(s)
			if _"room14_dress".worn == true then
				p"Ты и так одета в него.";
			else
				p"Тебе совершенно незачем таскать с собой по особняку вечернее платье.";
			end
	end;
	before_Disrobe = function(s)
			p"Отвернувшись от зеркала и встав лицом к стене, ты сняла вечернее платье. А затем повесила его на вешалку и переоделась в свою одежду.";
			_"room14_dress".worn = false;

	end;

}:attr'concealed, clothing'

obj {
	-"одежда|своя одежда|моя одежда";
	nam = "room14_cloth";
	description = "Моя ничем не примечательная одежда.";
	before_Wear = function(s,w)
		if _"room14_dress".worn == false then
			p"Ты и так одета в неё.";
		else
			p"Отвернувшись от зеркала и встав лицом к стене, ты сняла вечернее платье. А затем повесила его на вешалку и переоделась в свою одежду.";
			_"room14_dress".worn = false;
		end

	end;
	before_Take = function(s)
		if _"room14_dress".worn == false then
			p"Ты и так одета в неё.";
		else
			p"Тебе совершенно незачем таскать с собой по особняку свою одежду.";
		end
	end;
	before_Disrobe = function(s)
			p"Ты уже не в том возрасте, чтобы ходить голой по лестницам.";
	end;
	}:attr'scenery'


-- зеркало
obj {
	-"зеркало";
	nam = "room14_mirror";
	scope = {};
	before_Exam = function(s)
		_"room14_mirror".scope:add("room14_button");
		_"room14_mirror".scope:add("room14_frame");
		_"room14_mirror".scope:add("room14_stones");
		if _"room14_door1".seen ~= true then
			p"Старинное декоративное зеркало во всю стену с деревянной рамой, инкрустированной драгоценными камнями. В одном из узоров на раме зеркала ты увидела небольшую коричневую кнопку, которую не было видно издали.";
		else
			p"Старинное декоративное зеркало во всю стену с рамой, инкрустированной драгоценными камнями. В одном из узоров на раме зеркала ты увидела небольшую коричневую кнопку, которую не было видно издали.";
			if _"room14_plan".seen == true or _"room15_bedroom":visited() then
				pr"Справа от зеркала стальная дверь, ведущая в спальню.";
			else
				pr"Справа от зеркала стальная дверь.";
			end
		end			
	end;
}:attr'scenery'

obj {
	-"рама зеркала, рама| узоры, узор";
	nam = "room14_frame";
	description = "Деревянная резная рама зеркала, богато украшенная драгоценными камнями и узорными завитушками.";
}:attr'scenery'

obj {
	-"драгоценные камни, камни | алмазы, алмаз | рубины, рубин | сапфиры, сапфир | изумруды, изумруд";
	nam = "room14_stones";
	description = [[Чего тут только нет: алмазы, рубины, изумруды, сапфиры. Тётя получила по-настоящему большое наследство от мужа.]];
}:attr'scenery'

--кнопка
obj {
	-"кнопка, коричневая кнопка, пластиковая кнопка, небольшая кнопка, небольшая коричневая пластиковая кнопка";
	nam = "room14_button";
	scope = {};
	description = "Небольшая коричневая пластиковая кнопка, справа от зеркала.";	
	before_Push = function(s)
		if _"room14_dress".worn == false then
			p"Ты встала перед зеркалом и нажала на кнопку. Раздался тихий щелчок, но ничего не произошло.";
		elseif _"room14_dress".worn == true and _"room14_door1".seen ~= true then
			_"room14_door1".seen = true;
			p[[Ты встала в вечернем платье перед зеркалом и нажала на кнопку. Раздался тихий щелчок, наконец, со скрипом зеркало отодвинулось влево. В стене на месте, где раньше было зеркало, ты увидела стальную дверь. 
			И потом откуда-то справа послышался странный шорох, который, впрочем, быстро прекратился.]];
			_"room14_secondfloor".obj:add("room14_door1");
			mp.score=mp.score+1;
		else
			p"Ты встала перед зеркалом и нажала на кнопку. Раздался тихий щелчок, но ничего не произошло.";
		end
	end;	

}:attr'scenery'


--Манекен
obj {
	-"манекен/но, женский манекен, манекен девушки, манекен женщины";
	nam = "room14_dummy";
	description = "Высокий манекен с внешностью красивой обнажённой девушки, чем-то отдалённо напоминающей тётю в молодости. Руки скрещены на груди, ноги сдвинуты и крепко стоят на стальной подставке.";
	scope = {};
	before_Exam = function(s)
		_"room14_dummy".scope:add("room14_hands");
		_"room14_dummy".scope:add("room14_chest");
		_"room14_dummy".scope:add("room14_rack");
		_"room14_dummy".scope:add("room14_legs");
		p [[Высокий манекен с внешностью красивой обнажённой девушки, чем-то отдалённо напоминающей тётю в молодости. ]]; 
		if _"room14_door1".seen ~= true then
			pr[[Руки скрещены на груди, ноги сдвинуты и крепко стоят на стальной подставке.]];
		else
			pr[[Руки манекена, совсем не прикрывают обнажённую грудь. Ноги манекена раздвинуты в стороны.]];
		_"room14_secondfloor".obj:add("room14_hole");
		end
		end;
}:attr'scenery, ~animate'


obj {
	-"руки| руки манекена | тонкие руки";
	nam = "room14_hands";
	before_Exam = function(s)
			if _"room14_door1".seen ~= true then
				p[[Руки манекена, скрещенные на груди.]];
			else
				p[[Тонкие руки манекена, совсем не прикрывающие обнажённую грудь.]];
			end
			end;
}:attr'scenery'

obj {
	-"грудь| груди | грудь манекена| грудь девушки| груди манекена| груди девушки";
	nam = "room14_chest";
	description = [[Женская грудь второго размера правильной формы.]];
}:attr'scenery'
obj {
	-"подставка манекена | подставка | стальная подставка";
	nam = "room14_rack";
	description = [[Стальная подставка, на которой твёрдо стоит манекен. Судя по всему, она надёжно прикреплена к полу и её не сдвинуть с места.]];
}:attr'scenery'
obj {
	-"ноги| ноги манекена | нога | нога манекена";
	nam = "room14_legs";
	before_Exam = function(s)
		if _"room14_door1".seen ~= true then
			p[[Плотно сдвинутые ноги манекена.]];
		elseif _"room14_hole".door == true then
			p[[Ноги манекена, раздвинутые в стороны. Между ног манекена вставлен круглый ригельный ключ.]];
		else
			p[[Ноги манекена, раздвинутые в стороны. Между ног манекена, вместо ожидаемого зрелища, ты увидела скрытое ранее круглое отверстие, напоминающее замочную скважину.]];
		_"room14_secondfloor".obj:add("room14_hole");
		end
		end;
}:attr'scenery'

--замок стальной двери
obj {
	-"отверстие | круглое отверстие | замочная скважина | скважина | отверстие манекена";
	nam = "room14_hole";
	description = [[Круглое отверстие между ног манекена, напоминающее замочную скважину.]];
	door = false;
	before_Exam = function(s)
		if _"room14_hole".door == true then
			p"Круглый ригельный ключ намертво застрял между ног манекена.";
		else 
			return false;
		end
	end;
	before_Receive  = function(s, w)
		if mp.xevent == 'Insert' and w == _"circlekey" then
			p[[Ты медленно вставляешь круглый ключ в отверстие между ног манекена. Кажется, он идеально подходит. Вставив до упора, ты дважды его поворачиваешь. 
			Раздаётся лязг, и стальная дверь вдвигается в стену, открывая проход на восток. Но ключ намертво застрял в замочной скважине.]];
			pl.obj:del("circlekey");
			_"circlekey":attr'scenery';
			_"circlekey".description = "Ригельный ключ, намертво застрявший между ног манекена.";
			_"room14_hole".door = true;
			_"room14_secondfloor".e_to = 'room15_bedroom';
			mp.score=mp.score+1;
			return false
		else
			p("Ты попробовала вставить ", w:noun'вн', " в круглое отверстие. Но ", w:noun'вн', " совершенно не подходит. Иногда размер и форма имеют значение.");
		end
	end;
	after_Receive  = function(s, w)
		_'room14_hole':attr'~container, ~open';
	end;
}:attr'scenery, container, open'


												--ТАИНСТВЕННАЯ КОМНАТА

--"ковёр"
obj {
	-"ковёр, роскошный ковёр, персидский ковёр, роскошный персидский ковёр";
	nam = "room14_carpet";
	description = "Роскошный персидский ковёр с длинным ворсом, занимающий половину коридора. Мягкий, полностью заглушающий шаги, в отличии от паркета.";
	moving = false;
	scope = {};
	['before_Take,Push,Pull,Turn'] = function(s)
		if _"room14_drawer".moving == true then
			p"Ковёр невозможно сдвинуть, пока на нём стоит тяжёлый комод";
		else
			if _"room14_carpet".moving == false then
				p"Попробовав поднять ковёр, ты поняла, что он слишком тяжёлый, чтобы переместить его, но, откинув край ковра, ты увидела на полу посреди коридора квадратную пластину. А рядом с пластиной — грязную перчатку горничной.";
				_"room14_carpet".scope:add("room14_glove");
				_"room14_carpet".moving = true;
				_"room14_glove".seen = true;
				_"room14_secondfloor".scope:add("room14_plate");
				_"room14_secondfloor".obj:add("room14_plate");
			else
				p"Ковёр слишком тяжёлый, чтобы его перемещать, поэтому ты просто расправила край ковра на полу. Теперь ничто здесь не напоминает о твоих похождениях.";
				_"room14_carpet".moving = false;
			end
		end
	end;
	['before_Walk,Enter'] = function(s)
		p"Это бессмысленно. Ты и так стоишь на ковре на полу.";
	end;
	--before_Receive = function(s, w)
	--	if _"room14_carpet".moving == true then
--			p"Ковёр сейчас свёрнут и на него нельзя ничего положить.";
--		else
	--		p"Абсолютно бессмысленно класть что-то на ковёр.";
	--	end
--	end;
	after_Receive = function(s, w)
		move(w, _"room14_secondfloor");
		return false
	end;
}:attr 'scenery,supporter,enterable' 

obj {
	-"перчатка, перчатка горничной, грязная перчатка";
	nam = "room14_glove";
	seen = false;
	before_Any = function(s)
		if _"room14_carpet".moving == false then
			return p"Но перчатка сейчас под ковром.";
		else 
			return false
		end
	end;
	before_Exam = function(s)
		p"Длинная атласная перчатка, судя по всему, из костюма горничной. Когда-то была чёрной, но теперь вся покрыта пылью и какими-то белыми пятнами. У тёти разве была горничная?";
	end;
	before_Smell = function(s)
		p"Какой-то странный мускусный запах.";
	end;
	['before_Take,Push,Pull,Turn,Insert,Wear,Touch,Rub,Kiss,Eat,Taste,Tear'] = function(s)
		p"Перчатка настолько грязная, что даже трогать противно.";
	end;

}:attr'scenery' 

obj {
	-"комод, громоздкий комод, деревянный комод, громоздкий деревянный комод, комод тёмно-каштанового цвета";
	nam = "room14_drawer";
	description = "Громоздкий квадратный деревянный комод тёмно-каштанового цвета с двумя ящиками: верхним и нижним. На комоде стоит стеклянная витрина.";
	scope = {};
	
	moving = false;
	before_Exam = function(s)

		_'room14_drawer':attr'open'
		
		if _"room14_box1".stable and _"room14_box2".stable then
			p"Громоздкий квадратный деревянный комод тёмно-каштанового цвета с двумя ящиками: верхним и нижним. На комоде стоит стеклянная витрина.";
		elseif _"room14_box1".stable == false and _"room14_box2".stable == false then
			p"Громоздкий пустой квадратный деревянный комод тёмно-каштанового цвета без ящиков. На комоде стоит стеклянная витрина.";
		elseif _"room14_box1".stable == false then
			p"Громоздкий квадратный деревянный комод тёмно-каштанового цвета с одним нижним ящиком. На комоде стоит стеклянная витрина.";
		elseif _"room14_box2".stable == false then
			p"Громоздкий деревянный комод тёмно-каштанового цвета с одним верхним ящиком. На комоде стоит стеклянная витрина.";
		end
	end;
	before_Receive = function(s, w)
		if w == _"room14_box1" or w == _"room14_box2" then
			return false
		else
			p("Ты подумала, что логичнее было бы положить ", w:noun'вн', " в ящик, а не в комод.");
		end
	end;
	before_Take = function(s)
		p"Комод слишком большой и тяжёлый.";
	end;
	['before_Push,Pull,'] = function(s, ev)
		if _"room14_box1".stable or _"room14_box2".stable then
			p"Комод слишком тяжёлый, чтобы его двигать. Если бы можно было его как-то облегчить.";
		else 
			if _"room14_carpet".moving == false then
				if _"room14_drawer".moving == false then
					p"С трудом ты передвинула комод на середину ковра.";
					_"room14_drawer".moving = true;
				else
					p"С трудом ты передвинула комод с ковра обратно на место под картиной.";
					_"room14_drawer".moving = false;
				end
			elseif _"room14_carpet".moving == true then
				if _"room14_plate":empty() then
				if _"room14_drawer".moving == false then
					p"С трудом ты передвинула комод на пластину в центре пола.";
					_"room14_drawer".moving = true;
					move(_"room14_drawer", _"room14_plate");
					_'room14_drawer':attr'~concealed';
				else
					p"С трудом ты передвинула комод с пластины обратно на место под картиной.";
					_"room14_drawer".moving = false;
					move(_"room14_drawer", _"room14_secondfloor");
					_'room14_drawer':attr'concealed';
				end
				else
					p"На пластине уже что-то лежит, поэтому туда комод не передвинуть.";
				end
			end
		end
	end;
	before_Open = function(s)
			p"Что именно в комоде ты хочешь открыть?";
	end;
	['before_Walk,Enter'] = function(s)
		p"Ты уже не в том возрасте, чтобы лазать по чужим комодам.";
	end;

	--obj = { 'room14_box1', 'room14_box2' };
	
}:attr'concealed, container'

obj {
	-"верхний ящик комода, верхний ящик, ящик комода, ящик";
	nam = "room14_box1";
	description = function(s)
		_"room14_box1":attr'open';
		p"Верхний ящик комода.";
		content(_"room14_box1", true);
		--return false
	end;
	stable = true;
	found_in = "room14_drawer";
	before_Take = function (s,w)
	if pl:have(_"room14_box1") or pl:have(_"room14_box2") then
		return p"Ящики слишком тяжёлые, чтобы носить их вместе.";
	else
		_"room14_box1".stable = false;
		return false		
	end
	end;
	before_Pull = function(s)
	 	move(_"room14_box1", _"room14_secondfloor");
	 	_"room14_box1".stable = false;
	 	return p"Ты вытащила верхний ящик комода и положила на пол.";
	end;
	['before_Insert,Push'] = function(s)
		if _"room14_box1".stable == true then
			p"Но верхний ящик и так в комоде.";
		else
			move(_"room14_box1", _"room14_drawer");
			_"room14_box1".stable = true;
			return p"Ты вставила верхний ящик обратно в комод.";
		end
	end;
	before_Open = function(s)
		_"room14_box1":attr'open';
		if _"room14_box1".stable then
			p"Ты открыла верхний ящик комода.";
			content(_"room14_box1", true);
		else
			content(_"room14_box1", true);
		end
	end;
--	found_in = "room14_drawer";
}:attr'container'


obj {
	-"нижний ящик комода, нижний ящик, ящик комода, ящик";
	nam = "room14_box2";
	description = function(s)
		_"room14_box2":attr'open';
		p"Нижний ящик комода.";
		content(_"room14_box2", true);
		--return false
	end;
	stable = true;
	found_in = "room14_drawer";

	before_Take = function (s,w)
	if pl:have(_"room14_box1") or pl:have(_"room14_box2") then	
		return p"Ящики слишком тяжёлые, чтобы носить их вместе.";
	else
		_"room14_box2".stable = false;
		return false	
	end
	end;
	before_Pull = function(s)
	 	move(_"room14_box2", _"room14_secondfloor");
	 	_"room14_box2".stable = false;
	 	return p"Ты вытащила нижний ящик комода и положила на пол.";
	end;
	['before_Insert,Push'] = function(s)
		if _"room14_box2".stable == true then
			p"Но нижний ящик и так в комоде.";
		else
			move(_"room14_box2", _"room14_drawer");
			_"room14_box2".stable = true;
			return p"Ты вставила нижний ящик обратно в комод.";
		end
	end;
	before_Open = function(s)
		_"room14_box2":attr'open';
		if _"room14_box2".stable then
			p"Ты открыла нижний ящик комода.";
			content(_"room14_box2", true);
		else
			content(_"room14_box2", true);
		end
	end;

}:attr'container'



--- Декорации
obj {
	-"пол";
	nam = "room14_floor";
	description = function(s)
		p"Тёмный паркетный пол.";
	return false
	end;
	scope = {};

	['before_Walk,Enter'] = function(s)
		p"Это бессмысленно. Ты и так на полу.";
	end;
	after_Receive = function(s, w)
		move(w, _"room14_secondfloor");
		return false
	end;
	before_Remove = function(s, w)
		pl.obj:add(w);
	end;
}:attr'enterable, supporter,transparent'

obj {
	-"витрина, стеклянная витрина";
	nam = "room14_showcase";
	description = function(s)
	if _"room14_report".seen then
		p[[Стеклянная витрина, за которой находится пистолет с позолоченной рукояткой. Возможно, это и есть беретта, упоминавшаяся в отчёте?]];
	else
		p[[Стеклянная витрина, за которой находится пистолет с позолоченной рукояткой.]];
	end
	end;

	before_Exam = function(s)
		_"room14_secondfloor".obj:add("room14_gun");
		return false
	end;
}:attr'scenery'

obj {
	-"пистолет|беретта/жр,но|позолоченная рукоятка, рукоятка";
	nam = "room14_gun";
	description = function(s)
	if _"room14_report".seen then
		p"Пистолет с позолоченной рукояткой. Возможно, это и есть беретта, упоминавшаяся в отчёте?";
	else
		p"Пистолет с позолоченной рукояткой. Ты никогда особо не любила оружие и не разбиралась в нём.";
	end
	end;
}:attr'scenery'


obj {
 	-"стена, стены|штукатурка, бордовая штукатурка, венецианская штукатурка, бордовая венецианская штукатурка";
 	nam = "room14_walls";
 	description = "Стены, отделанные бордовой венецианской штукатуркой, имитирующей узоры яшмы. Безумно дорого. Такое ты видела только в модном журнале в статье о дворцах венецианских дожей. Сколько же денег получила тётя после смерти мужа?";
}:attr'scenery'

obj {
	-"пластина, напольная пластина";
	nam = "room14_plate";
	description = function(s)
	if _"room14_plate":empty() then
			p"Напольная деревянная квадратная пластина. На ней изображена какая-то девушка с весами, на которых стоят пустые бокалы.";
			mp:content(s);
	else
		p"Напольная деревянная квадратная пластина. На ней изображена какая-то девушка с весами, на которых стоят пустые бокалы.";
		mp:content(s);
		p"Сейчас пластина нажата.";
	end
	end;
	dsc = function(s)
		p(description);
		content(s);
	end;
--	before_Receive = function(s,w) 
	--	p("Ты положила ", w:noun"вн", " на пластину.");
	--	return false
--	end;
	before_Any = function(s)
		if _"room14_carpet".moving == false then
			return p"Но пластина сейчас под ковром.";
		else 
			return false
		end
	end;

	['before_Enter,Walk'] = function(s)
		if _"room14_drawer".moving == false then
			p"Ты встала на пластину. Пластина нажалась, но ничего больше не произошло. Возможно, здесь нужен другой вес. ^Ты сошла с пластины.";
		else
			p"На пластину невозможно встать, всю её поверхность занял комод.";
		end
	end;
	before_Push = function(s)
		p"Ты нажала на квадратную пластину, но ничего не произошло. Судя по всему, пластина реагирует на вес предметов.";
	end;
	--before_Receive = function(s)
	--	if _"room14_plate":empty() == false then
	--		p("Но на пластине уже находится ", mp:content(_"room14_plate"), ".");
	--	else
	--		return false
	--	end
	--end;
	each_turn = function(s)
		if _'room14_drawer':inside'room14_plate' and _"room14_box1".stable == true and _"room14_box2".stable == true and _"room14_box1":empty() and _"room14_box2":empty() and 
			_"room14_platform".seen == false then
			_"room14_secondfloor".obj:add(_"room14_platform");
			_"room14_platform".seen = true;
			p"Внезапно раздался щелчок, и пластина нажалась. Похоже, вес предметов оказался подходящим. Из стены рядом с деревянной дверью выдвинулась небольшая платформа.";
		end
	end;
	capacity = 1;
}:attr'supporter,scenery,enterable,transparent'

obj {
	-"платформа|деревянная платформа|углубление";
	nam = "room14_platform";
	description = "Небольшая толстая деревянная платформа в центре которой есть треугольное углубление.";
	seen = false;
	door = false;
	after_Receive = function(s, w)
		if w == _"piramidekey" then
			p[[Как только ты положила пирамидальный ключ на платформу, он бесшумно исчез внутри неё. 
			А сама платформа тут же скрылась в стене, а вслед за ней в стену вдвинулась деревянная дверь, обнажив проход]];
			if _"room14_plan".seen == true or _'room16_mystical':visited() then
				p"в таинственную комнату.";
			else
				p"на запад.";
			end

			_"room14_platform":attr'scenery';
			_"room14_platform".description = "Деревянная платформа полностью скрылась в стене вместе с пирамидальным ключом."
			if not _"piramidekey":has('scenery') then
			   mp.score=mp.score+1;
			end
			_"piramidekey":attr'scenery';
			_"piramidekey".description = "Пирамидальный ключ исчез в стене вместе с платформой.";
			_"room14_door".description = "Массивная деревянная дверь полностью скрылась в стене, не оставив ни следа."
			_"room14_platform".door = true;
			_"room14_secondfloor".w_to = 'room16_mystical';
		else 
			return false
		end
	end;
}:attr'scenery,supporter'


obj {
	-"потолок, высокий потолок";
	nam = "room14_ceiling";
	description = "Высокий потолок, отделанный дорогой бордовой венецианской штукатуркой.";
}:attr'scenery'

obj {
	-"толстая папка с бумагами,папка с бумагами, папка|бумаги|отчёт,отчет|документ|документы|газетные вырезки,вырезки|заметки";
	nam = "room14_report";
	seen = false;
	keyword = "";
	description = "Большая папка с бумагами, документами и газетными вырезками.";
	before_Exam = function(s)
		
		p"Большая папка с бумагами, документами и газетными вырезками. Просмотрев бумаги, ты поняла, что они посвящены какому-то преступлению.";
	end;
	topic = {'муж', 'жертв',
		'преступлен', 
		'агат','тети','тетю','тете','тетя','тёт',
		'перчатк','горничн','самоубий','убийц', 
		'пистолет', 'оруд', 'оруж','рукоят',
		'убийств', 'улик',
		'себе','себя', 
		'свидетел',
		'наследств','наследн','завещ','богат', 
		'тимо йокинен', 
		'особняк', 'ковё',"ковр", "плать"};

	['before_Consult,Search'] = function(s, w)
	if w == nil then
		p"Большая папка с бумагами, документами и газетными вырезками. Просмотрев бумаги, ты поняла, что они посвящены какому-то преступлению. Возможно, надо поискать что-то в документах.";
		return
	else
	local found
	for x, y in ipairs(s.topic) do
		if w:find(y) then
			found = x;
			break
		end
	end
	if found == nil then
		p"Большая папка с бумагами, документами и газетными вырезками. Просмотрев бумаги, ты поняла, что они посвящены какому-то преступлению. Возможно, надо поискать в документах что-то другое.";
		return
	end
	if found == 1 or found == 2 or found == 27 then
		p"Ты поискала в документах упоминания мужа тёти и обнаружила, что его звали Тимо Йокинен, и он был миллиардером из Финляндии. ";
	elseif found == 31 then
		p"Ты нашла свадебное фото: вместо традиционного белого тётя была на свадьбе в вечернем платье.";
	elseif found == 29 or found == 30 then
		p[[Согласно квитанции в документах роскошный персидский ковёр был приобретён у некоего мистера Черепнакольского за весьма приличную сумму.]];
	elseif found == 3 then
		p"Ты почитала документы в папке и поняла, что они посвящены убийству мужа тёти Агаты и самоубийству их горничной.";
	elseif found >= 4 and found <= 9 or found == 22 or found == 31 then
		p"Согласно папке, преступление произошло спустя несколько лет после свадьбы тёти. Судя по свидетельствам тёти, убийца вечером проникла в их спальню и попыталась застрелить тётю. Но вместо неё погиб муж, пытаясь отобрать пистолет убийцы. После чего убийца покончила с собой на пороге комнаты. О внебрачной связи своего мужа тётя узнала только после того, как на пороге их спальни появилась горничная.";
	elseif found == 10 then
		p'Ты нашла в документах следующее: "...никаких следов выстрела на руках горничной не осталось, поскольку она была в длинных атласных перчатках..."';
	elseif found == 11 or found == 12 or found == 13 then
		p"Судя по отчёту, горничную Веронику наняли сразу после свадьбы для того, чтобы вести хозяйство большого особняка. Мотивом преступления стала ревность, которую убийца испытывала к жене своего любовника. После неудачной попытки убийства, находясь в состоянии аффекта от смерти любовника, она покончила с собой.";
	elseif found >= 14 and found <= 17 then
		_"room14_report".seen = true;
	--	_"room14_gun".word:add("беретта/жр,но")
		p"Пролистав папку ты обнаружила, что орудием преступления являлся пистолет Beretta 92FS, с позолоченной рукояткой, который принадлежал жертве и хранился в его кабинете.";
	elseif found == 19 then
		p'В бумагах написано: "...cледов борьбы не обнаружено. На потерпшей обнаружена кровь мужа. На убийце нет никаких следов, кроме следов от выстрела в сердце при самоубийстве..."';
	elseif found == 20 or found == 21 then
		p"Ты нашла краткие заметки ручкой в блокноте из которых следовало, что тётя собиралась подарить особняк тебе.";
	elseif found >= 23 and found <= 26 then
		p"Тётя оказалась единственной наследницей своего мужа, упомянутой в завещании, и получила гигантское состояние, в том числе особняк.";
	elseif found == 28 then
		p[[Вот что нашлось в заметках: "...cтаринный фамильный особняк семейства Йокиненов был построен в девятнадцатом веке, представляет собой настоящее чудо инженерной мысли. Состоит из восемнадцати комнат. 
		В особняке предусмотрено можноство тайных секретных проходов и комнат. После современной реставрации особняка он оснащён по последнему слову техники. Тётя Агата получила особняк по завещанию от мужа."]];

	else
		p"Ты почитала документы в папке, но не нашла ничего подходящего.";
	end
	end
	end;

	found_in = { 'room14_box2' };
}




