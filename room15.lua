-- Доступное пространство имён для объектов - все имена объектов должны начинаться с "room15_" или "bedroom_"
-- Все описания можно менять
-- Задача: Игрок должен найти в локации предмет statuetka
-- Спальня находится на втором этаже
room {
	nam = "room15_bedroom";
	book_read = false;
	title = "Спальня";
	dsc = function(s)
		if pl:where()^'room15_void' then
			return "Тебя окружает пустота. Через окно ты видишь просторную спальню. ";
		else
			return "Просторная комната с единственным окном. Выход из комнаты находится на западе. ";
		end;
	end;
	w_to = 'room14_secondfloor';
	awake = false;
	complete = false;

	lampon = false;

	["before_Push,Pull,Turn,SwitchOn,SwitchOff,Take,Insert,Remove,Eat,Taste,Drink,Rub,Touch,Kiss,Open,Close"] = function(s, w)
		if pl:where()^'room15_bedroom' or w == nil or w:where() == nil or pl:where()^'room15_bed' and w^'room15_lamp' or pl:where()^'room15_void' and w:where()^'room15_void' then
			return false;
		else
			pr 'Отсюда это сделать не получится. ';
		end;
	end;

	before_Drop = function(s, w)
		if pl:where()^'room15_void' then
			pr 'Тебе это не кажется хорошей идеей. ';
			return;
		end;
		return false;
	end;

	["after_Push,Pull,Turn"] = 'Это так не работает. ';
	before_Walk = function(s, w)
		if pl:where()^'room15_bedroom' then
			if not w^'@w_to' or s.awake then
				return false;
			else
				pr 'За порогом ты не видишь ничего, кроме пустоты. Ты не решаешься сделать шаг. Уж не {$fmt em|спишь} ли ты?';
			end;
		else
			pr 'Отсюда не получится. ';
		end;
	end;
	after_Listen = function(s, w)
		if w ~= nil then
			return false;
		end;
		if _'room15_tv':has('on') then
			pr(_'room15_tv':sound());
		else
			pr "Негромкое тикание часов отчетливо слышно в тишине. ";
			if not s.awake then
				pr "Из-под кровати доносятся непонятные звуки. ";
			end;
		end;
	end;
	after_Smell = function(s, w)
		if w ~= nil then
			return false;
		end;
		if w == nil then
			return "Пахнет свежевыглаженным постельным бельем. ";
		else
			return false;
		end;
	end;
	before_Open = function(s, w)
		if w ~= nil then
			return false;
		end;
		if not pl:where()^'room15_bedroom' and not have(w) then
			return 'Придется встать с кровати. ';
		else
			return false;
		end;
	end;
	before_Exam = function(s, o)
		if o^'@w_to' then
			pr 'За порогом ты не видишь ничего, кроме пустоты. Уж не {$fmt em|спишь} ли ты?'
		else
			return false;
		end;
	end;
	after_Wait = function(s)
		if s.awake then
			return "Проходит немного времени. Не происходит ничего не обычного. ";
		else
			return "Проходит немного времени. Кажется, рисунок на обоях слегка изменился. ";
		end;
	end;
	after_Dig = function(s, w)
		if w == nil then
			return "Тебе слишком дорог твой маникюр, чтобы делать это руками. ";
		end;
		return false;
	end;
	after_Jump = "Пол жалобно поскрипывает после твоего приземления. ";
	after_Think = function(s)
		if s.awake and not s.complete then
			pr "Думать вредно -- голова болит. Лучше {$fmt em|поспать}. ";
		else
			pr "Думать вредно -- голова болит. Лучше поесть. ";
		end;
	end;
	before_Sing = function(s)
		if not s.awake and _'room15_tv':has('on') then
			pr 'Твой голос сливается с голосами из телевизора и оттого ужасающее пение становится еще более жутким. ';
		end;
		return false;
	end;
	after_Sleep = function(s)
		if pl:where()^'room15_bed' then
			_'room15_spider':disable();
			if s.complete then
				pr 'Прошлый сон все еще слишком свеж в твоей памяти, чтобы погружаться в новый. ';
			elseif _'room15_curtain':has('open') then
				pr 'Свет из окна не дает тебе заснуть. ';
			elseif _'room15_tv':has('luminous') then
				pr 'Телевизор не дает тебе заснуть. ';
			elseif s.awake then
				s.awake = false;
				s.lampon = _'room15_lamp':has('light');
				remove('room15_sky', 'room15_bedroom');
				put('room15_void', 'room15_bedroom');
				pr 'Ты быстро погружаешься в сон. Через какое-то время ты просыпаешься от ощущения, что в комнате что-то не так. ';
				pl:need_scene(true);
			else
				pr('Ты долго ворочаешься, но никак не можешь уснуть. тебе кажется, что кто-то есть под кроватью! ');
			end;
		else
			pr "Лучше делать это в кровати. ";
		end;
	end;
	after_Wake = function(s)
		if s.awake then
			return false;
		end;
		s.awake = true;
		walk('room15_bed');

		-- Восстанавливаем состояние комнаты как было -- вне сна все равно трогать ничего нельзя.
		_'room15_window'.rope = false;
		_'room15_curtain':attr('~open');
		_'room15_window':attr('~open');
		local cabinet = lookup('#room15_in_cabinet', 'room15_cabinet');
		cabinet:attr('~open');

		if s.lampon then
			_'room15_lamp':attr('on,light');
		else
			_'room15_lamp':attr('~on,~light');
		end;
		_'room15_tv':attr('~on,~luminous');
		_'room15_rope':attr('~static');
		_'room15_void':disable();
		_'room15_spider':disable();
		remove('room15_book', where('room15_book'));
		remove('room15_linen', where('room15_linen'));
		remove('room15_void', 'room15_bedroom');
		remove('room15_shreds', where('room15_shreds'));
		remove('room15_rope', where('room15_rope'));
		remove('room15_book', where('room15_book'));

		if not s.complete then
			remove('statuetka', where('statuetka'));
			put('statuetka', 'room15_void');
			pr 'Осознав, что спишь, ты довольно быстро просыпаешься. Однако, ты чувствуешь, что готова провалиться обратно в {$fmt em|сон}. ';
		end;

		put('room15_linen', cabinet);
		put('room15_book', cabinet);
		put('room15_sky', 'room15_bedroom');

		pl:need_scene(true);
	end;
	after_Yes = 'Борода. ';
	after_No = 'Бородатый дед. ';
	obj = { 'room15_walls', 'room15_curtain', 'room15_window', 'room15_bed', 'room15_spider','room15_table', 'room15_lamp', 'room15_cabinet', 'room15_void' };
}: attr('~light')

obj {
	-"небо на обоях,небо|стены/жр|обои|панели|облака";
	nam = 'room15_walls';
	dsc = 'Стены обиты панелями снизу, а сверху оклеены обоями с облачками. ';
	before_Exam = function(s)
		if _'room15_bedroom'.awake then
			return 'Нижняя часть стен обита деревянными панелями, верхняя же оклеена обоями, на которых изображено голубое небо с облаками. ';
		else
			return 'Нижняя часть стен обита деревянными панелями, верхняя же оклеена обоями, на которых изображено голубое небо с облаками. Тебе кажется, что облака медленно движутся вдоль стен. ';
		end;
	end;
	before_Smell = 'Стены ничем не пахнут. ';
	["before_Taste,Eat"] = 'Ты предпочла бы съесть что-нибудь... Более съедобное. ';
	before_Touch = 'Ты не испытываешь никаких необычных ощущений. ';
	["before_Push,Pull,Turn,Rub,Tear,Tie,Cut,Attack,Kiss"] = 'Вот придешь к себе домой -- там делай со своими стенами все, что захочешь. ';
	["before_Talk,Tell,Answer"] = 'Стены молчат в ответ. ';
	["before_Ask,AskFor,AskTo"] = 'Бесполезно. Стены не отвечают на твои слова. ';
	before_Blow = function(s)
		if _'room15_bedroom'.awake then
			pr 'Ты дуешь на стены. Ничего не происходит. ';
		else
			pr 'Ты дуешь на стены и облака разбегаются в стороны от потока воздуха. ';
		end;
	end;
	before_Take = 'Халк крушить! Халк ломать! Халк надорвался... ';
}: attr('static');

obj {
	-"занавески|занавеска|шторы";
	nam = 'room15_curtain';
	description = function(s)
		if s:has('open') then
			pr 'Тяжелые занавески из плотной ткани темно-серого цвета. Сейчас они раздвинуты. ';
		else
			pr 'Тяжелые занавески из плотной ткани темно-серого цвета. Сейчас они закрыты. ';
		end;
	end;
	after_Open = function(s)
		if _'room15_bedroom'.awake then
			s:attr('light');
			enable('room15_sky');
			pr 'Ты открываешь занавески. Яркий свет ослепляет тебя после полумрака комнаты. ';
		else
			enable('room15_void');
			pr 'Ты открываешь занавески. За окном ты видишь непроглядную пустоту. ';
			mp:content(_'room15_void');
		end;
	end;
	before_Close = function(s)
		if s:has('~open') then
			return false;
		end;
		if _'room15_window':has('open') then
			pr 'Створки окна мешают закрыть занавески. ';
		else
			s:attr('~light,~open');
			disable('room15_void');
			disable('room15_sky');
			pr 'Ты закрываешь занавески. ';
		end;
	end;
	before_Smell = 'Занавески пахнут пылью. ';
	before_Taste = 'Ткань безвкусная. ';
	before_Eat = function(s)
		if _'room15_bedroom'.awake then
			pr 'Тетушке не понравится, если ты съешь занавески. ';
		else
			pr 'Жуется, конечно, приятно, но съесть целую занавеску? Ну уж нет. ';
		end;
	end;
	before_Touch = 'Плотная ткань немного жесткая, но довольно приятная на ощупь. ';
	["before_Push,Pull,Turn,Rub,Tear,Tie,Cut,Attack,Kiss"] = 'Остановись! Занавески ни в чем не виноваты! ';
	["before_Talk,Tell,Answer"] = 'Занавески ничем не выдают заинтересованности в разговоре с тобой. ';
	["before_Ask,AskFor,AskTo"] = 'Увы, занавески отказываются исполнять твою просьбу. Объяснить свой отказ они тоже не изволят. ';
	before_Blow = 'Ты дуешь на занавески, но тяжелая ткань почти не шевелится. ';
	before_Take = 'Занавески тебе не понадобятся. ';
}: attr('concealed,openable,luminous,static');

obj {
	-"окно";
	nam = 'room15_window';
	rope = false;
	dsc = function(s)
		if _'room15_curtain':has('open') then
			if _'room15_bedroom'.awake then
				pr 'За окном ты видишь голубое небо. ';
			else
				if not pl:where()^'room15_void' then
					pr 'За окном ты видишь непроглядную пустоту. ';
					mp:content(_'room15_void');
				end;
			end;
		else
			pr 'Окно закрыто плотными занавесками. ';
		end;
	end;
	description = function(s)
		if _'room15_curtain':has('open') then
			if _'room15_bedroom'.awake then
				pr 'За окном ты видишь голубое небо. ';
			else
				pr 'За окном ничего нет. Совсем ничего. Одна пустота. ';
				if s:has('open') then
					pr 'Окно открыто. '
				end;
				mp:content(_'room15_void');
				if s.rope then
					pr 'К подоконнику прикреплена веревка из обрывков простыней. ';
				end;
			end;
		else
			pr 'Окно закрыто занавесками. ';
		end;
	end;
	before_Open = function(s)
		if not _'room15_curtain':has('open') then
		 	pr '{$fmt em|(сначала открыть занавески)}^';
			mp:subaction('Open', _'room15_curtain');
		end;

		if not s:has('open') then
			pr 'Ты открываешь окно. ';
			if _'room15_bedroom'.awake then
				pr 'В комнату врывается порыв свежего прохладного воздуха. ';
			end;
			s:attr('open');
		else
			return false;
		end;
	end;
	before_Close = function(s)
		if s.rope then
			pr 'Веревка мешает закрыть окно. ';
			return
		end;
		return false;
	end;
	before_Smell = 'Окно ничем не пахнет. ';
	before_Taste = 'Дерево ты еще могла бы погрызть, но краска вряд ли скажется положительно на твоем желудке. А уж стекло -- и подавно. ';
	before_Eat = 'Дерево ты еще могла бы погрызть, но краска вряд ли скажется положительно на твоем желудке. А уж стекло -- и подавно. ';
	before_Touch = 'Окно гладкое на ощупь. ';
	["before_Push,Pull,Turn,Rub,Tear,Tie,Cut,Attack,Kiss"] = 'Ты решаешь не портить окно в доме тётушки. ';
	["before_Talk,Tell,Answer,Ask,AskFor,AskTo"] = 'Окно игнорирует тебя. ';
	before_Blow = 'Окно запотевает от твоего дыхания. ';
	before_Take = 'Халк крушить! Халк ломать! Халк надорвался... ';
	before_Enter = function(s)
		if _'room15_curtain':has('~open') then
			pr 'Сначала стоит открыть занавески. ';
			return;
		end;

		if pl:where()^'room15_void' then
			mp:xaction('Exit', _'room15_void');
		else
			mp:xaction('Enter', _'room15_void');
		end;
	end;
	before_Receive = function(s)
		if _'room15_curtain':has('~open') then
			pr 'Сначала стоит открыть занавески. ';
			return;
		end;
		mp:xaction('Receive', _'room15_void');
	end;
}: attr('openable,static,container,luminous');

obj {
	-"кровать";
	nam = 'room15_bed';
	title = 'В кровати';
	dsc = 'У стены стоит большая кровать. ';
	description = function(s)
		pr 'Большая кровать, застеленная покрывалом. ';
		mp:content(s);
	end;
	inside_dsc = 'Ты лежишь на большой кровати. ';
	after_Enter = 'Ты ложишься на кровать. ';
	before_LookUnder = function(s)
		if mp:thedark() then
			pr 'Ничего не видно. ';
			return;
		elseif pl:where()^'room15_bedroom' then
			enable('room15_spider');
			if _'room15_bedroom'.awake then
				pr 'Под кроватью живет паучок. ';
			else
				pr 'Из-под кровати на тебя своими восемью глазищами смотрит огромный паук. ';
			end;
			return;
		elseif pl:where()^'room15_bed' then
			pr 'Сначала придется слезть с кровати. ';
			return;
		elseif pl:where()^'room15_void' then
			pr 'Отсюда ничего не видно. ';
			return;
		end;
		return false;
	end;
	before_Smell = 'Пахнет тканью, деревом и пылью. ';
	before_Taste = 'Ты аккуратно кусаешь угол кровати. На вкус как дерево. ';
	before_Eat = 'Долго рассматривая кровать, ты так и не решила, с чего начать ее есть. ';
	["before_Touch,Rub"] = function(s)
		if _'room15_bedroom'.awake and not _'room15_bedroom'.complete then
			pr 'Постель мягкая и приятная на ощупь. Так и тянет {$fmt em|спать}. ';
		else
			pr 'Постель мягкая и приятная на ощупь. Так и тянет спать. ';
		end;
	end;
	["before_Tear,Tie,Cut,Attack"] = 'Почему тебе так нравится все ломать? ';
	before_Kiss = 'Кровать не реагирует на твое проявление чувств. ';
	["before_Talk,Tell,Answer,Ask,AskFor,AskTo"] = 'Кровать не отвечает на твои потуги заговорить. ';
	before_Blow = 'Ты подула на кровать, но ничего не изменилось. ';
	before_Take = 'Кровать слишком тяжелая. ';
	obj = {
		'room15_bedspread'
	};
}: attr('enterable,supporter,static,luminous');

obj {
	-"покрывало";
	nam = 'room15_bedspread';
	description = 'Мягкое бархатное покрывало лежит на кровати. ';
	before_Take = 'Что ты задумала?';
	before_Smell = 'Пахнет тканью и пылью. ';
	before_Tear = 'Тётя Агата будет очень недовольна, если ты это сделаешь. ';
	before_Tie = 'Ты не понимаешь, для чего тебе это. ';
	["before_Taste,Eat"] = 'Ты пытаешься отгрызть уголок покрывала, но у тебя ничего не получается. Тебе остается лишь надеяться, что тетушка не заметит погрызенное покрывало. ';
	["before_Rub,Touch"] = 'Покрывало гладкое и мягкое. ';
	before_Cut = 'Ты не думаешь, что это хорошая идея. ';
	before_Attack = 'Ты со всей силы бьешь покрывало. Оно мягкое, все стерпит. ';
	before_Blow = 'Ты дуешь на ткань. ';
	["before_Talk,Tell,Answer,Ask,AskFor,AskTo"] = "Покрывалу очень интересно, правда. Продолжай. ";
	before_Kiss = "Покрывалу, должно быть, очень приятно. Но оно никак не реагирует. ";
}:attr('concealed');

obj {
	-"паук,паучок";
	nam = 'room15_spider';
	description = function(s)
		if _'room15_bedroom'.awake then
			pr 'Маленький безобидный паучок мирно плетёт свою маленькую безобидную паутинку. ';
		else
			pr 'Огромный голодный паук! Как только он уместился там?! ';
		end;
	end;
	before_Take = function(s)
		if _'room15_bedroom'.awake then
			pr 'Паучок никуда с тобой не пойдет. ';
		else
			pr 'Паук хищно шипит, открыв пасть и желание притрагиваться к нему резко пропадает. ';
		end;
	end;
	["before_Smell,Taste,Eat"] = 'Тебе почему-то очень не хочется это делать. ';
	["before_Push,Pull,Turn,Rub,Touch,Tear,Tie,Cut"] = function(s)
		if _'room15_bedroom'.awake then
			return 'Ты опасаешься раздавить паучка и решаешь ничего не предпринимать. ';
		else
			return 'Паук щелкает пастью, и ты поспешно отдергиваешь руки. ';
		end;
	end;
	["before_Talk,Tell,Answer"] = function(s)
		if _'room15_bedroom'.awake then
			pr 'Паучок молча слушает тебя. ';
		else
			pr 'Паук молча выслушивает тебя, а потом делает резкий выпад в твою сторону. Ты еле успеваешь отпрыгнуть, а паук возвращается на свое место. ';
		end;
	end;
	["before_Ask,AskFor,AskTo"] = function(s)
		if _'room15_bedroom'.awake then
			pr 'Паучок не хочет тебе помогать. ';
		else
			pr 'Паук молча выслушивает тебя, а потом делает резкий выпад в твою сторону. Ты еле успеваешь отпрыгнуть, а паук возвращается на свое место. Ты понимаешь, что он не станет делать то, что тебе нужно. ';
		end;
	end;
	before_Attack = function(s)
		if _'room15_bedroom'.awake then
			return 'Разве можно так поступать с маленьким безобидным паучком?! ';
		else
			return 'Не стоит лезть на рожон. ';
		end;
	end;
	before_Blow = function(s)
		if _'room15_bedroom'.awake then
			return 'Ты опасаешься навредить паучку и решаешь этого не делать. ';
		else
			return 'Ты опасаешься разозлить паука и решаешь этого не делать. ';
		end;
	end;
	life_Show = function(s, w)
		print('FUG');
		if _'room15_bedroom'.awake then
			return 'Паучок старательно делает вид, что ему интересно. ';
		else
			return 'Паук недовольно шипит на ' .. w:noun('вн') .. '.';
		end;
	end;
	before_Kiss = 'Чего?!';
	before_Listen = function(s)
		if _'room15_bedroom'.awake then
			return false;
		else
			return 'Паук шипит, щелкает пастью и скрежещет своими лапами по полу. ';
		end;
	end;
}: attr('static,animate'): disable();

obj {
	-"стол,столик|столешница";
	nam = 'room15_table';
	dsc = function(s)
		pr 'Рядом с ней расположен маленький столик. ';
		mp:content(s);
	end;
	description = function(s)
		pr 'Небольшой круглый столик с дубовой столешницей. ';
		mp:content(s);
	end;
	obj = {
		'room15_clock';
		'room15_vase';
	};
	before_Take = 'Ты слишком опасаешься уронить предметы, стоящие на столе, чтобы сделать это. ';
	before_Smell = 'Стол слабо пахнет деревом. ';
	["before_Taste,Eat"] = 'Ты не в настроении грызть дерево. ';
	before_Rub = 'Ты зачем-то протираешь ладонью стол. Пыли на поверхности почти нет. ';
	before_Touch = "Стол гладкий и приятный на ощупь";
	["before_Tear,Tie,Cut"] = "Как ты себе это представляешь?";
	["before_Talk,Tell,Answer,Ask,AskFor,AskTo"] = "Ты в своем уме, с мебелью разговаривать?";
	before_Attack = "Тётушка расстроится, если я сломаю ее столик. ";
	before_Blow = "Ты дуешь на стол. Ничего не происходит. ";
	before_Kiss = 'Стол никак не реагирует, а ты чего ждала?';
}:attr('supporter,static');

obj {
	-"часы|стрелка/жр,но|стрелки/жр,но,мн";
	dsc = 'На краешке стола стоят часы. ';
	nam = 'room15_clock';
	description = 'Старинные бронзовые часы с позолотой показывают примерно полчетвертого. Секундная стрелка размеренно движется по кругу. ';
	["before_Take,Push,Pull,Turn,Rub,Touch,Attack,Kiss"] = 'Ты не решаешься трогать столь редкую и дорогую вещь. ';
	before_Smell = 'Часы пахнут стариной. ';
	["before_Taste,Eat"] = 'Это не пойдет на пользу твоим зубам. ';
	["before_Tear,Tie,Cut"] = "Нет. Просто нет. ";
	["before_Talk,Tell,Answer,Ask,AskFor,AskTo"] = "Часы выслушивают тебя и продолжают медленно отсчитывать секунды. ";
	before_Blow = "Ты дуешь на стол. Ничего не происходит. ";
	before_Listen = 'Тикание часов отчетливо слышно в тишине. ';
}: attr('static');

obj {
	-"ваза|цветы,тюльпаны|цветок,тюльпан";
	nam = 'room15_vase';
	dsc = 'В центре стола стоит ваза с цветами. ';
	description = 'Хрустальная ваза. В вазе стоят несколько благоухающих тюльпанов. ';
	before_Take = 'Цветам и здесь хорошо. Не надо их трогать. ';
	before_Smell = 'Ты вдыхаешь восхитительный аромат тюльпанов. Тётя Агата очень любит эти цветы. ';
	["before_Taste,Eat"] = 'Ты вспоминаешь как однажды в детстве съела несколько горьких, неприятных на вкус лепестков и решаешь не повторять этот опыт. До сих пор удивляешься, как что-то настолько невкусное может так приятно пахнуть. ';
	["before_Push,Pull,Turn,Rub,Touch,Attack,Tear,Tie,Cut,Blow"] = 'Ты даже боишься себе представить, что будет, если ты разобьешь вазу. ';
	["before_Talk,Tell,Answer,Ask,AskFor,AskTo"] = "Цветы остаются безучастными к твоим мольбам. ";
	before_Kiss = "Может, лучше не надо?";
}: attr('static');

obj {
	-"настенная лампа,лампа|светильник|ночник";
	nam = 'room15_lamp';
	dsc = function(s)
		if s:has('on') then
			pr 'На стене над кроватью висит зажженная лампа. ';
		else
			pr 'На стене над кроватью висит лампа. ';
		end;
	end;
	description = 'Настенный светильник со светло-бежевым абажуром. ';
	before_Take = 'Лампе и здесь хорошо. ';
	before_Smell = 'Лампа ничем не пахнет. Странно. ';
	["before_Taste,Eat"] = 'Ты долго раздумываешь над вкусовыми качествами пластиковых абажуров и стеклянных ламп, и в итоге решаешь не пробовать ни то ни другое. ';
	before_Touch = function(s)
		if s:has('light') then
			pr 'Лампа слишком горячая!';
		else
			pr 'Светильник теплый на ощупь. '
		end;
	end;
	["before_Push,Pull,Turn,Rub,Attack,Tear,Tie,Cut"] = 'Да сколько можно все вокруг ломать? ';
	before_Blow = 'Ты дуешь на светильник. ';
	["before_Talk,Tell,Answer,Ask,AskFor,AskTo"] = "Ваза остается безучастной к твоим мольбам. ";
	before_Kiss = "Может, лучше не надо?";
	before_SwitchOn = function(s)
		s:attr('light');
		return false;
	end;
	before_SwitchOff = function(s)
		s:attr('~light');
		return false;
	end;
}: attr('static,on,light,switchable,luminous');

obj {
	-"тумбочка,тумба|ящик|ящики";
	dsc = function(s)
		pr 'У стены напротив кровати стоит массивная тумбочка. ';
		mp:content(s);
	end;
	nam = 'room15_cabinet';
	before_Receive = function(s, w)
		if mp.xevent == 'Insert' then
            if _'#room15_in_cabinet':hasnt'open' then
                p "Тумбочка закрыта."
                return
            end
            move(w, '#room15_in_cabinet')
            p ("Ты кладешь ", w:noun'вн', " в тумбочку.")
        elseif mp.xevent == 'PutOn' then
            move(w, '#room15_at_cabinet')
            p ("Ты кладешь ", w:noun'вн', " на тумбочку.")
        else
            return false
        end
    end;
    before_Open = function(s)
    	if _'room15_bedroom'.awake then
    		pr 'Там нет ничего интересного. ';
		else
		   	return mp:xaction('Open', _'#room15_in_cabinet');
	   	end;
    end;
    before_Close = function(s)
    	return mp:xaction('Close', _'#room15_in_cabinet');
    end;
	description = function(s)
		pr 'Внушительных размеров тумбочка с ящиками. ';
		mp:content(s);
	end;
	obj = {
		obj {
            -"тумбочка";
            nam = '#room15_in_cabinet';
            dsc = function(s)
                mp:content(s)
            end;
			obj = {
				'room15_linen';
				'room15_book';
			};
        }: attr('container,openable,static');
		obj {
            -"тумбочка";
            nam = '#room15_at_cabinet';
            dsc = function(s)
                mp:content(s)
            end;
			obj = {
				'room15_tv';
			};
        }: attr('supporter,static');
	};

	before_Take = 'Тумбочка слишком тяжелая. ';
	before_Smell = 'Тумбочка пахнет мебелью. ';
	["before_Taste,Eat"] = 'Обойдя тумбочку со всех сторон, ты так и не понимаешь, с какой стороны ее можно удобно укусить. ';
	["before_Push,Pull,Turn"] = 'Тумбочка слишком тяжелая. ';
	["before_Rub,Touch,Attack,Tear,Tie,Cut"] = 'Тебя бабушка не учила не ломать вещи когда ты в гостях? ';
	before_Blow = 'Ты сдуваешь пыль с тумбочки. ';
	["before_Talk,Tell,Answer,Ask,AskFor,AskTo"] = "Тумбочке не интересно тебя слушать. ";
	before_Kiss = "Тумбочке приятно. Нет, правда. ";
}: attr('container,transparent,open,static');

obj {
	-"простыня,простынь";
	nam = 'room15_linen';
	description = 'Чистая простыня. Она кажется достаточно прочной, чтобы выдержать твой вес. ';
	before_Take = function(s)
		if _'room15_book':disabled() then
			_'room15_book':enable();
			pr 'Под простынёй лежит книга!';
		end;

		return false;
	end;
	tearApart = function(s)
		remove('room15_linen', where('room15_linen'));
		mp.score=mp.score+1
		take('room15_shreds');
		pr 'Ты разрываешь простыню, теперь у тебя есть обрывки ткани. ';
		if _'room15_book':disabled() then
			_'room15_book':enable();
			pr 'Под простынёй лежит книга!';
		end;
	end;
	before_Smell = 'Пахнет чистой постелью. ';
	before_Tear = function(s)
		if s.awake then
			pr 'Тётя Агата будет очень недовольна, если ты это сделаешь. ';
		else
			s:tearApart();
		end;
	end;
	before_Tie = function(s, w)
		if s.awake then
			pr 'Ты не понимаешь, для чего тебе это. ';
		elseif w == nil or w^'room15_window' then
			pr 'Так ничего не получится. Она слишком короткая и чересчур толстая. ';
		elseif w^'statuetka' then
			pr 'Статуэтка слишком далеко. '
		else
			pr 'Ты не понимаешь, для чего тебе это. ';
		end;
	end;
	["before_Taste,Eat"] = 'Ты отгрызаешь уголок простыни, надеясь, что тётушка не заметит этого. Ткань приятно жуется и почти безвкусная. ';
	["before_Rub,Touch"] = 'Простыня шершавая, но очень приятная на ощупь. ';
	before_Cut = function(s, w)
		if s.awake then
			pr 'Тётя Агата будет очень недовольна, если ты это сделаешь. ';
		else
			if w == nil then
				return 'Твои руки недостаточно острые. ';
			elseif w^'dagger' then
				s:tearApart();
			else
				return 'Простыня не режется. Возможно стоит резать ее чем-то другим. ';
			end;
		end;
	end;
	before_Attack = 'Ты со всей силы бьешь простыню. Она мягкая, все стерпит. ';
	before_Blow = 'Ты дуешь на ткань. ';
	["before_Talk,Tell,Answer,Ask,AskFor,AskTo"] = "Простыне очень интересно, правда. Продолжай. ";
	before_Kiss = "Простыня никак не реагируют. ";
};

obj {
	-"обрывки простыни,обрывки ткани,обрывки|простыня|ткань";
	nam = 'room15_shreds';
	description = 'Прочные и длинные полосы из простыней. ';
	before_Tie = function(s, w)
		if w == nil then
			remove('room15_shreds', where('room15_linen'));
			take('room15_rope');
			mp.score=mp.score+1
			pr 'Ты связываешь обрывки между собой. Получается достаточно прочная веревка. ';
		elseif w^'room15_window' then
			pr 'Ты сомневаешься, что их длины будет достаточно. ';
		else
			return false;
		end;
	end;
	before_Smell = 'Обрывки ткани все еще пахнут чистыми простынями ';
	["before_Taste,Eat"] = 'Ты сгрызаешь немного ткани. Ткань легко жуется и почти безвкусная. ';
	["before_Push,Pull,Turn"] = 'Это так не работает. ';
	["before_Rub,Touch"] = 'Простыня шершавая, но очень приятная на ощупь. ';
	["before_Attack"] = 'В этом уже нет никакого смысла. ';
	["before_Tear,Cut"] = 'Ткань уже достаточно рваная. ';
	before_Blow = 'Ты дуешь на ткань. ';
	["before_Talk,Tell,Answer,Ask,AskFor,AskTo"] = "Сперва изодрала в клочья, а теперь заговорить пытаешься? ";
	before_Kiss = "Нет, простыни тебя не простят. Даже так. ";
}

obj {
	-"веревка|простыня|обрывки простыни,обрывки ткани,обрывки|ткань";
	nam = 'room15_rope';
	description = 'Веревка связанная из обрывков простыней. Достаточно прочная, чтобы выдержать тебя. ';
	before_Tie = function(s, o)
		if o~=nil then
			if o^'room15_window' then
				if _'room15_window':has('open') then
					remove('room15_rope', me());
					s:attr('static');
					if _'room15_window'.rope==false then
					   mp.score=mp.score+1;
					end;
					_'room15_window'.rope = true;
					put('room15_rope', 'room15_window');
					pr 'Ты прикрепляешь веревку к окну. Теперь ты можешь {$fmt em|войти в пустоту}. ';
				else
					pr 'Сначала придется открыть окно. ';
				end;
			else
				pr 'Сюда это крепить незачем. ';
			end;
		else
			pr 'Это надо {$fmt em|куда-то} прикрепить. ';
		end;
	end;
	before_Smell = 'Обрывки ткани все еще пахнут чистыми простынями ';
	["before_Taste,Eat"] = 'Ты сгрызаешь немного ткани. Ткань легко жуется и почти безвкусная. ';
	["before_Push,Pull,Turn"] = 'Это так не работает. ';
	["before_Rub,Touch"] = 'Простыня шершавая, но очень приятная на ощупь. ';
	["before_Attack"] = 'В этом уже нет никакого смысла. ';
	["before_Tear,Cut"] = 'Ткань уже достаточно рваная. ';
	before_Blow = 'Ты дуешь на ткань. ';
	["before_Talk,Tell,Answer,Ask,AskFor,AskTo"] = "Сперва изодрала в клочья, а теперь заговорить пытаешься? ";
	before_Kiss = "Нет, простыни тебя не простят. Даже так. ";
	before_Take = function(s)
		if s:has('static') then
			pr 'Ты долго возишься, но так и не можешь отвязать веревку. Зато теперь ты точно уверена, что она не отвяжется сама. ';
			return;
		end;
		return false;
	end;
}

obj {
	-"узорчатая книга,книга,книжка,обложка|переплет|узоры на переплете,узоры";
	nam = 'room15_book';
	description = '"Все и ничто" С. Оминус. Книга очень старая, потрепанная. Переплет украшен позолоченными узорами, местами истершимися от времени -- должно быть очень ценная и редкая. Странно, что тётушка не оставила ее среди других книг, а спрятала здесь. Ты бегло пролистываешь страницы. Какая-то оккультная чушь про пустоту, окружающую наш мир. ';
	after_Consult = function(s, o)
		if _'room15_bedroom'.aspleep and (o:find("пусто") or o:find("ничем") or o:find("ничт") or o:find("ничём")) then
			pr [[
			В книге подробно описан способ открытия портала в пустоту. Все что для этого необходимо -- любой проем, закрытый прозрачным материалом. После завершения ритуала прозрачный материал можно убрать. Далее на много страниц описывается ритуал открытия портала и способы взаимодействия с пустотой. ]];
		else
			pr 'Тебе некогда читать всякую муть. ';
		end;
	end;

	before_Smell = 'Пахнет старой книгой. ';
	["before_Taste,Eat"] = 'Вряд ли это все еще вкусно. ';
	["before_Rub"] = 'Хм, узоры не стираются. ';
	["before_Touch"] = 'Ты проводишь пальцем по гладкому переплету. ';

	["before_Attack,Tear,Tie,Cut"] = 'Вандализм -- это нормально. Но только в своем собственном жилище. ';
	before_Blow = 'Ты сдуваешь пыль со страниц. ';
	["before_Talk,Tell,Answer,Ask,AskFor,AskTo"] = "Ты побаиваешься изливать душу старой зловещей книге. ";
	before_Kiss = "Вот эту книгу?! Ты серьезно? ";
}:disable();

obj {
	-"телевизор,телек,телик,экран|тв/мр";
	nam = 'room15_tv';
	dsc = function(s)
		if s:has('on') then
			pr 'На тумбочке стоит включенный телевизор. ';
		else
			pr 'На тумбочке стоит телевизор. ';
		end;
	end;
	description = function(s)
		pr 'Старинный телевизор в идеальном состоянии. ';
		if s:has('on') then
			if not s.awake then
				pr(s:sound());
			end;

			pr(s:vision());
		end;
	end;
	["before_Take,Pull,Push"] = 'Он слишком тяжелый. ';
	after_SwitchOn = function(s)
		s:attr('luminous');
		if s.awake then
			pr('Ты включаешь телевизор. ' .. s:vision());
		else
			pr('Ты включаешь телевизор. '  .. s:sound() .. s:vision());
		end;
	end;
	after_SwitchOff = function(s)
		s:attr('~luminous');
		if s.awake then
			pr 'Ты выключаешь телевизор. ';
		else
			pr 'Ты выключаешь телевизор. Странные звуки прекращаются. ';
		end;
	end;
	sound = function(s)
		if s.awake then
			return 'По телевизору идет какой-то фильм про гангстеров. ';
		else
			return 'Сквозь помехи ты слышишь шум ветра и тихий вкрадчивый шепот. Среди прочих, многократно повторяется слово "{$fmt em|окно}". ';
		end;
	end;
	vision = function(s)
		if _'room15_bedroom'.awake then
			return 'На экране идет какой-то фильм про гангстеров. ';
		elseif _'room15_curtain':has('open') then
			if pl:where()^'room15_void' then

				return 'На экране с трудом различимо окно, через которое видна какая-то комната очень похожая на спальню тетушки. ';
			else
				return 'На экране с трудом различимо окно, через которое видна какая-то комната. Да там же ты! ';
			end;
		else
			return 'На экране с трудом различимо какое-то окно, закрытое шторами. ';
		end;
	end;

	before_Smell = 'Пахнет старой электроникой. ';
	["before_Taste,Eat"] = 'Вряд ли это вкусно. ';
	["before_Rub,Touch"] = function(s)
		if s:has('on') then
			pr 'Экран гладкий и приятный на ощупь. Ты чувствуешь легкое покалывание в пальцах от наэлектризованного кинескопа. ';
		else
			pr 'Экран гладкий и приятный на ощупь. ';
		end;
	end;
	["before_Attack,Tear,Tie,Cut"] = 'Это же антикварный телевизор! Как ты можешь с ним так поступить? ';
	before_Blow = 'Ты сдуваешь пыль с экрана. ';
	["before_Talk,Tell,Answer,Ask,AskFor,AskTo"] = function(s)
		if s:has('on') then
			if s.awake then
				local phrs = {
					'Из телевизора доносится: "И что дальше?"';
					'Из телевизора доносится: "Что мне с этого будет?"';
					'Из телевизора доносится: "Может мне будет проще тебя подстрелить?"';
					'Из телевизора доносится: "Сходи проспись, Винни!"';
				};
				pr(phrs[rnd(#phrs)]);
			else
				pr 'Зловещий шепот с экрана продолжается. ';
			end;
		else
			pr 'Телевизор молчит в ответ. ';
		end;
	end;
	before_Kiss = "Что если тебя током ударит? ";
	before_Take = 'Не трогай, уронишь!';
}: attr('switchable,static,on');

obj {
	-"пустота,тьма,темнота|ничто,ничто за окном|ничего,ничего за окном";
	nam = 'room15_void';
	title = 'В пустоте';
	before_Enter = function(s)
		if _'room15_window':has('~open') then
			pr 'Ты не можешь пройти через закрытое окно. ';
			return;
		end;
		if _'room15_window'.rope then
			walk('room15_void');
			pr 'Держась за веревку, ты аккуратно погружаешься в ничто. Гравитация здесь отсутствует и ты повисаешь в пустоте. ';
		else
			pr 'Ты не решаешься шагнуть в пустоту. Тебе нужно будет как-то вернуться. ';
		end;
	end;
	before_Receive = 'Тебе это не кажется хорошей идеей. ';
	before_LetGo = function(s, o)
		if pl:where()^'room15_void' then
			return false;
		elseif _'room15_window':has('open') then
			pr(o:Noun'им' .. ' слишком далеко. Руками не дотянуться. ');
		else
			pr('Сначала придется открыть окно. ');
		end;
	end;
	after_LetGo = function(s, o)
		if o^'statuetka' and have('statuetka') then
			_'room15_bedroom'.complete = true;
			pr('Едва схватив ' .. _'statuetka':noun'вн' .. ', ты ощущаешь, что начинаешь падать. Веревка выскальзывает из твоей руки и ты просыпаешься от сильного удара. Ты лежишь на кровати, крепко сжимая в руке '.. _'statuetka':noun'вн' .. '. ');
			mp:subaction('Wake');
			return
		end;
		return false;
	end;
	before_Exam = function(s)
		pr 'Там пусто. ';

		mp:content(s);
	end;
	obj = {
		'statuetka';
	};
	before_Take = 'Как ты себе это представляешь? ';
}: attr('container,enterable,transparent,open,static,concealed,luminous'): disable();

obj {
	-"небо за окном,небо|свет";
	nam = 'room15_sky';
	description = 'Чистое голубое небо. Ни облачка. ';
	before_Any = function(s, event)
		if event == 'Exam' then
			return false;
		end;
		pr 'Небо слишком далеко. ';
	end;
}: attr('concealed,static,luminous'):disable();

-- Менять нельзя!!!! Это не ваш предмет!!! Вы не знаете как он выглядит, его придумает другой автор!!!
--obj {
--	-"статуетка";
--	nam = "statuetka";
--	description = "Статуетка.";
--}
