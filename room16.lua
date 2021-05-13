room {
	nam = "room16_mystical";
	title = "Таинственная комната";
	firsttime = 1;
	state = 0;
	dsc = function(s)
		if s.state == 0 then
			if s.firsttime == 1 then
				p ("Комната выглядит таинственно: в углу стоит большой шкаф, в другом углу стоит пюпитр, в третьем углу находится небольшой постамент, а четвёртый угол вообще пустой! Из щели под потолком сочится тусклый свет, придающий комнате ещё больше таинственности.");
				s.firsttime = 0;
			else
				p ("По углам стоят большой шкаф, пюпитр и постамент, а под потолком узкая щель, таинственный свет плавно ниспадает на паркет, постеленный на полу.");
			end;
			mp:content(_'room16_parquet')
			if(_'room16_wardrobe':has "open") then mp:content(_'room16_wardrobe') end;
		else
			p ("Распахнутый шкаф стоит у стены напротив пюпитра. У ещё одной стены нервно прячется постамент, а у четвёртой стены стоишь ты.");
			if(_'room16_wall'.state == 2) then p('В стене виднеется небольшая дыра.'); end;
			if(_'room16_wall'.state == 3) then p('В стене просто огромная дыра!'); end;
			mp:content(_'room16_parquet')
		end;
	end;
	description = function(s)
		if s.state == 0 then
			if s.firsttime == 1 then
				p ("Комната выглядит таинственно: в углу стоит большой шкаф, в другом углу стоит пюпитр, в третьем углу находится небольшой постамент, а четвёртый угол вообще пустой! Из щели под потолком сочится тусклый свет, придающий комнате ещё больше таинственности.");
				s.firsttime = 0;
			else
				p ("По углам стоят большой шкаф, пюпитр и постамент, а под потолком узкая щель, таинственный свет плавно ниспадает на паркет, постеленный на полу.");
			end;
			mp:content(_'room16_parquet')
			if(_'room16_wardrobe':has "open") then mp:content(_'room16_wardrobe') end;
		else
			p ("Распахнутый шкаф стоит у стены напротив пюпитра, на котором сидит тётушка Агата и точит когти. У ещё одной стены нервно прячется постамент, а у четвёртой стены стоишь ты.");
			if(_'room16_wall'.state == 2) then p('В стене виднеется небольшая дыра.'); end;
			if(_'room16_wall'.state == 3) then p('В стене просто огромная дыра!'); end;
		end;
	end;
	e_to = 'room14_secondfloor';
	before_Listen = function()
		if(_'room16_wardrobe'.state >= 4) then
			p "Тишина."
		else
			p "Что-то подозрительно поскрипывает в шкафу.";
		end;
	end;
	before_Smell = function()
		if(_'room16_wardrobe'.state >= 4) then
			p "Пахнет вечностью."
		else
			p "Из шкафа идёт еле уловимый запах чего-то необычайного.";
		end;
	end;
	before_Exit = function(s)
		if(s.state == 0) then
			if(_'room16_wardrobe'.state == 1) then _'room16_wardrobe'.state = 0 end;
			_'room16_wardrobe':attr '~open'
			remove(_'room16_o',pl)
			remove(_'room16_x',pl)
			DaemonStop 'room16_AI'
			return false;
		else
			if(_'room16_wall'.state == 3) then
				_'room16_AI'.daemon_stage = 9
			else
				p('Выхода нет!')
			end;
		end;
	end;
	after_Drop = function(s, w)
		if(_'room16_wardrobe'.state < 4) then
			move(w, 'room16_parquet')
		else
			move(w, 'room16_wardrobe')		
		end;
		return false
	end;
	obj = { 'room16_wardrobe','room16_parquet','room16_bookstand','room16_pedestal','room16_slit' };
--	obj = { 'statuetka','book','dagger','room16_wardrobe','room16_parquet','room16_bookstand','room16_pedestal','room16_slit' };
	--obj = { 'room16_wardrobe','room16_parquet','room16_bookstand','room16_pedestal','room16_slit' };
}

obj {
	-"статуэтка, стержень";
	nam = "statuetka";
	description = "Статуэтка в виде цилиндрического стержня, вокруг которого обвивается змея.";
        score=false;
        after_Take = function(s)
          if not s.score then
            mp.score=mp.score+1;
          end;
          _'statuetka'.score=true;
          return false;
        end;
}
obj {
	-"таинственный кинжал, кинжал, рукоять";
	nam = "dagger";
	description = "Таинственный кинжал, на рукояти которого изображены глаза и язык змеи.";
}
obj {
	-"толстая книга,книга, обложка";
	nam = "book";
	state = 0;
	description = function(s)
		if (_'room16_bookstand'.state == 0) then
			p ("Толстая старая книга. Страницы как будто бы склеены: её невозможно открыть.")
		end;
		if (_'room16_bookstand'.state == 1) then
			if(_'room16_bookstand'.stateA == 0) then
				p ("Книга лежит на пюпитре. На её обложке изображена змея, обвивающая кинжал.")
			end;
			if(_'room16_bookstand'.stateA == 1) then
				p ("Книга лежит на пюпитре. Она отрыта. На развороте нарисован шкаф: одна половина на левой странице, одна половина на правой.")
				s.state = 1;
			end;
			if(_'room16_bookstand'.stateA == 2) then
				p ("Книга лежит на пюпитре. Она разрезана пополам между створок нарисованного шкафа.")
			end;
		end;
	end;
	before_Cut = function(s, w)
		if w == _'dagger' then
			if(_'room16_bookstand'.stateA == 1) then
				if(_'book'.state == 1) then
					p ("Ты вставляешь кинжал между створок нарисованного шкафа и режешь книгу пополам. Со стороны шкафа слышится треск.")
					_'room16_bookstand'.stateA = 2;
					mp.score=mp.score+1;
				else
					p ("Надо бы внимательно осмотреть книгу прежде, чем её испортить.")
				end;
			else
				if(_'room16_bookstand'.stateA == 2) then
					p ("Книга уже разрезана.")
				else
					p("Обложка книги слишком толстая: кинжал даже не может её поцарапать. Расковырять склеенные страницы книги тоже не удаётся.")
				end;
			end;
		else
			if w then
				p ("Книга прочная, как дерево!")
			else
				p ("Не совсем понятно, чем.")
			end;
		end;
	end;
        score=false;
        after_Take = function(s)
          if not s.score then
            mp.score=mp.score+1;
          end;
          _'book'.score=true;
          return false;
        end;
}

obj {
	-"крестик, крест";
	nam = "room16_x";
	title = "Крестик";
	before_Exam = function(s)
		if(_'room16_a1'.state == 1 or _'room16_a2'.state == 1 or _'room16_a3'.state == 1 or _'room16_b1'.state == 1 or _'room16_b2'.state == 1 or _'room16_b3'.state == 1 or _'room16_c1'.state == 1 or _'room16_c2'.state == 1 or _'room16_c3'.state == 1) then
			p 'Крестик как крестик.'
		else
			p 'Здесь нет крестиков.'
		end;
	end;
	before_Insert = function(s, w)
		if (w == _'room16_a1' or w == _'room16_a2' or w == _'room16_a3' or w == _'room16_b1' or w == _'room16_b2' or w == _'room16_b3' or w == _'room16_c1' or w == _'room16_c2' or w == _'room16_c3') then
			if(_'room16_wardrobe'.state >= 4) then
				if(_'room16_wardrobe'.turn == 0) then
					return false;
				else
					p 'Сейчас не твой ход!'
				end;
			else
				p('Ты играешь ноликами!')
			end;
		else
			p("Что??")
		end;
	end;
	before_Drop = function()
		p ('Надо бросать пить, а не крестики бросать.')
	end;
	before_Take = function()
		p ('Что-что?')
	end;
	before_PutOn = function(s, w)
		if (w == _'room16_a1' or w == _'room16_a2' or w == _'room16_a3' or w == _'room16_b1' or w == _'room16_b2' or w == _'room16_b3' or w == _'room16_c1' or w == _'room16_c2' or w == _'room16_c3') then
			if(_'room16_wardrobe'.state >= 4) then
				if(_'room16_wardrobe'.turn == 0) then
					return false;
				else
					p 'Сейчас не твой ход!'
				end;
			else
				p('Ты играешь ноликами!')
			end;
		else
			p("Что??")
		end;
	end;
}:attr 'concealed'

obj {
	-"нолик, ноль";
	nam = "room16_o";
	title = "Нолик";
	before_Exam = function(s)
		if(_'room16_a1'.state == 2 or _'room16_a2'.state == 2 or _'room16_a3'.state == 2 or _'room16_b1'.state == 2 or _'room16_b2'.state == 2 or _'room16_b3'.state == 2 or _'room16_c1'.state == 2 or _'room16_c2'.state == 2 or _'room16_c3'.state == 2) then
			p 'Нолик как нолик.'
		else
			p 'Здесь нет ноликов.'
		end;
	end;
	before_Insert = function(s, w)
		if (w == _'room16_a1' or w == _'room16_a2' or w == _'room16_a3' or w == _'room16_b1' or w == _'room16_b2' or w == _'room16_b3' or w == _'room16_c1' or w == _'room16_c2' or w == _'room16_c3') then
			if(_'room16_wardrobe'.state < 4) then
				return false;
			else
				p('Теперь ты играешь крестиками!')
			end;
		else
			p("Что??")
		end;
	end;
	before_Drop = function()
		p ('Надо бросать пить, а не нолики бросать.')
	end;
	before_Take = function()
		p ('Что-что?')
	end;
	before_PutOn = function(s, w)
		if (w == _'room16_a1' or w == _'room16_a2' or w == _'room16_a3' or w == _'room16_b1' or w == _'room16_b2' or w == _'room16_b3' or w == _'room16_c1' or w == _'room16_c2' or w == _'room16_c3') then
			if(_'room16_wardrobe'.state < 4) then
				return false;
			else
				p('Теперь ты играешь крестиками!')
			end;
		else
			p("Что??")
		end;
	end;
}:attr 'concealed'

obj {
	-"паркет, пол";
	nam = "room16_parquet";
	title = "Паркет";
	state = 0;
	description = function(s)
		if s.state == 0 then
			p ("Паркет на полу выглядит мрачно и таинственно. Одна занятная деталь: на фоне остальной старой мебели он выглядит новым и даже глянцеватым.")
			mp:content(s)
		end;
	end;
}:attr 'scenery, static, supporter'

obj {
	--"шкаф, дверцы";
	nam = "room16_wardrobe";
	word = function(s)
		if(s.state == 1 or s.state == 3) then
			return -"шкаф, дверцы, строки, столбцы, таблиц*"
		else
			return -"шкаф, дверцы"
		end;
	end;
	title = "Шкаф";
	state = 0;
	turn = 0;
	firsttime = 0;
	firsto = 0;
	description = function(s)
		if s.state == 0 then
			if(_'room16_bookstand'.stateA == 2) then
				p ("Большой и старый шкаф. Его дверцы неплотно закрыты.")
			else
				p ("Большой и старый шкаф. Его дверцы плотно закрыты.")
			end;
		end;
		if s.state == 1 then
			_'room16_AI':describe()
		end;
		if s.state == 2 then
			p ("Большой и старый шкаф. Его дверцы неплотно закрыты.")			
		end;
		if s.state == 3 then
			p ("Большой и старый шкаф, в котором пряталась тётушка Агата. Его дверцы распахнуты.")			
		end;
		if s.state >= 4 then
			p 'Откуда-то в шкаф проникает свет. На стенке шкафа расчерчена таблица 3 на 3.'
			_'room16_AI':describe()
		end;
	end;
	before_Open = function(s)
		if(_'room16_mystical'.state == 0) then
			if(s.state == 1) then
				p('Шкаф уже открыт.')
				_'room16_AI':describe()
			else
				if(s.state == 2) then
					walk 'room16_cutscene'
				else
					if(_'room16_bookstand'.stateA == 2) then
						put(_'room16_o',pl)
						put(_'room16_x',pl)
						s.state = 1
						s.turn = 0
						s:attr 'open'
						if(s.firsttime == 0) then
							if(_'room16_AI'.game == 0) then
								p ('Ты открываешь дверцы шкафа и видишь, что он пуст. На задней стенке шкафа расчерчена таинственная таблица 3 на 3, её строки подписаны буквами "А", "Б" и "В", а столбцы пронумерованы "1", "2" и "3". На центральном поле стоит крестик: кто-то выцарапал его прямо на стенке шкафа. "Похоже на игру," -- думаешь ты -- "Можно куда-нибудь поставить нолик."')
							else
								p ('Ты открываешь дверцы шкафа и видишь, что он пуст. Тем не менее, тебе кажется, что в нём кто-то есть, просто почему-то его (или её) пока не видно. Таинственно всё это. Кстати, на стенке шкафа всё ещё расчерчена таблица, и снова в ней только один крестик на поле Б2.')
							end;
							s.firsttime = 1
							_'room16_b2'.state = 1
						else 
							p ("Ты открываешь дверцы шкафа.")
							_'room16_AI':describe()
						end;
					else
						p ("На дверцах шкафа нет ручек, поэтому ты пытаешься просунуть пальцы в щель между дверок, но ничего не получается: дверцы наглухо закрыты.");
					end;
				end;
			end;
		else
			if(s.state == 3) then
				p('Шкаф уже открыт.')
				_'room16_AI':describe()
			else
				p('Ты пытаешься открыть дверцы шкафа, но они как будто куда-то пропали! Похоже, ты в ловушке.')
			end;
		end;
	end;
	before_Close = function(s)
		if(s.state ~= 3) then
			if(_'room16_wardrobe'.turn == 1) then _'room16_AI':calculate() end;
			s.state = 0
			return false
		else
			p('Не стоит тратить на это время!')
		end;
	end;
	after_Enter = function(s)
		p('Как только ты прячешься в шкаф, его двери сами собой захлопываются.')
		_'room16_AI'.daemon_stage = 10;
		_'room16_wardrobe':attr '~open'
		_'room16_wardrobe':attr '~openable'
		_'room16_wardrobe':attr 'light'
		_'room16_wardrobe'.state = 4
		_'room16_AI'.state = 0
		_'room16_AI'.win = 0
		_'room16_wardrobe'.turn = 0
		_'room16_a1'.state = 0
		_'room16_a2'.state = 0
		_'room16_a3'.state = 0
		_'room16_b1'.state = 0
		_'room16_b2'.state = 0
		_'room16_b3'.state = 0
		_'room16_c1'.state = 0
		_'room16_c2'.state = 0
		_'room16_c3'.state = 0
		move(_'room16_a1',_'room16_wardrobe')
		move(_'room16_a2',_'room16_wardrobe')
		move(_'room16_a3',_'room16_wardrobe')
		move(_'room16_b1',_'room16_wardrobe')
		move(_'room16_b2',_'room16_wardrobe')
		move(_'room16_b3',_'room16_wardrobe')
		move(_'room16_c1',_'room16_wardrobe')
		move(_'room16_c2',_'room16_wardrobe')
		move(_'room16_c3',_'room16_wardrobe')
		move(_'room16_x',pl)
		move(_'room16_o',pl)
		move(pl,'room16_wardrobe')
	end;
	inside_dsc = function(s)
		p 'Ты в шкафу.'
		_'room16_AI':describe()
	end;
	before_Exit = function(s)
		p('Ты пытаешься открыть дверцы шкафа, но они как будто куда-то пропали! Похоже, ты в ловушке.')
	end;
	obj = { 'room16_a1','room16_a2','room16_a3','room16_b1','room16_b2','room16_b3','room16_c1','room16_c2','room16_c3' };
}:attr 'scenery, static, closed, openable, container'

obj {
	-"постамент";
	nam = "room16_pedestal";
	title = "Постамент";
	state = 0;
	stateA = 0;
	description = function(s)
		if s.state == 0 then
			p ("Это загадочный постамент. Он выглядит совершенно бесполезным, но придаёт комнате таинственности.")
			mp:content(s)
		end;
		if s.state == 1 then
			if s.stateA == 0 then
				p ("Ты замечаешь, что на постаменте появился паз цилиндрической формы, в глубине которого нарисована змея, обвивающая кинжал.")
				s.stateA = 1
			else
				p ("Это загадочный постамент. В нём виден паз цилиндрической формы, в глубине которого нарисована змея, обвивающая кинжал.")
			end;
			mp:content(s)
		end;
		if s.state == 2 then
			p ("Это загадочный постамент. В пазу намертво сидит статуэтка в виде змеи, обвивающей кинжал.")
			mp:content(s)
		end;
	end;
	before_Receive = function(s, w)
		if s.state == 1 then
			if w == _'statuetka' then
				p ("Ты ставишь статуэтку в паз на постаменте, и она намертво входит внутрь. Слышится загадочный треск со стороны пюпитра.")
				move(w, s)
				s.state = 2
				_'room16_bookstand'.stateA = 1
				_'statuetka':attr 'scenery'
                                mp.score=mp.score+1;
			else
				p ("Ты кладешь ", w:noun'вн', " на постамент, но таинственная сила отталкивает ", w:noun'вн', " обратно.")
			end;
		else
			p ("Таинственная сила отталкивает ", w:noun'вн', " обратно.")
		end;
	end;
}:attr 'scenery, static, supporter'

obj {
	-"пюпитр";
	nam = "room16_bookstand";
	title = "Пюпитр";
	state = 0;
	stateA = 0;
	description = function(s)
		if(_'room16_mystical'.state == 0) then
			if s.state == 0 then
				p ("Это пюпитр, он выглядит загадочно.")
				mp:content(s)
			end;
			if s.state == 1 then
				if s.stateA == 0 then
					p ("Это пюпитр, нём лежит книга. На обложке книги изображена змея, обвивающая кинжал.")
				end;
				if s.stateA == 1 then
					p ("Это пюпитр, на нём лежит книга. Ты замечаешь, что она сама собой открылась.")
				end;
				if s.stateA == 2 then
					p ("Это пюпитр, на нём лежит разрезанная пополам книга.")
				end;
				mp:content(s)
			end;
		else
			p('На пюпитре лежит книга, а ещё там сидит тётушка Агата и точит когти.')
		end;
	end;
	before_Receive = function(s, w)
		if(_'room16_mystical'.state == 0) then
			if s.state == 0 then
				if w == _'book' then
					p ("Когда книга оказывается близко к поверхности пюпитра, неведомая сила вырывает её из твоих рук и присасывает к пюпитру. Кажется, книгу больше не получится взять. Пока ты обо всём этом думаешь, на обложке книги вырисовывается символ змеи, обвивающей кинжал. А ещё слышится какой-то скрип со стороны постамента.")
					move(w, s)
					s.state = 1
					_'room16_pedestal'.state = 1
					_'book':attr 'scenery'
                                        mp.score=mp.score+1;
				else
					p ("Ты кладешь ", w:noun'вн', " на пюпитр, но таинственная сила отталкивает ", w:noun'вн', " обратно.")
				end;
			else
				p ("На пюпитре уже лежит книга.")
			end;
		else
			p('Не стоит приближаться к нему, пока там сидит тётушка!')
		end;
	end;
}:attr 'scenery, static, supporter'

obj {
	-"щель";
	nam = "room16_slit";
	title = "Щель";
	state = 0;
	description = function(s)
		if s.state == 0 then
			p ("Узкая щель под потолком, сквозь которую проникает тусклый таинственный свет.")
		end;
	end;
}:attr 'scenery, static'

obj {
	-"поле А1, А1, поле а1, а1";
	nam = "room16_a1";
	title = "Поле А1";
	state = 0;
	description = function(s)
		if s.state == 0 then
			if(_'room16_wardrobe'.state >= 4) then
				p ("Поле А1 не заполнено. Сюда можно поставить крестик.")			
			else
				p ("Поле А1 не заполнено. Сюда можно поставить нолик.")
			end;
		end;
		if s.state == 1 then
			p ("На поле А1 стоит крестик.")
		end;
		if s.state == 2 then
			p ("На поле А1 стоит нолик.")
		end;
	end;
	before_Receive = function(s, w)
		if (w == _'room16_o') then
			if (_'room16_wardrobe'.turn == 0) then
				if (s.state == 0) then
					if (pl:have(_'dagger')) then
						p ('Остриём кинжала ты выцарапываешь нолик на поле А1.')
						s.state = 2
						_'room16_wardrobe'.turn = 1
						_'room16_AI'.state = _'room16_AI'.state + 1
						_'room16_AI':continue()
					else
						p ('Чтобы поставить нолик, нужен кинжал.')
					end;
				else
					p ('Это поле уже заполнено. Нельзя же играть не по правилам!')
				end;
			else
				p ('Ты уже поставила один нолик в этом ходу. Нельзя же играть не по правилам!')
			end;
		else
			if (w == _'room16_x' and _'room16_wardrobe'.state >= 4) then
				if (_'room16_wardrobe'.turn == 0) then
					if (s.state == 0) then
						if (pl:have(_'dagger')) then
							p ('Остриём кинжала ты выцарапываешь крестик на поле А1.')
							s.state = 1
							_'room16_wardrobe'.turn = 1
							_'room16_AI'.state = _'room16_AI'.state + 1
						else
							p ('Чтобы поставить крестик, нужен кинжал.')
						end;
					else
						p ('Это поле уже заполнено. Нельзя же играть не по правилам!')
					end;
				end;				
			else
				p ('Что??')
			end;
		end;
	end;
}:attr 'scenery, static, supporter'

obj {
	-"поле А2, А2, поле а2, а2";
	nam = "room16_a2";
	title = "Поле А2";
	state = 0;
	description = function(s)
		if s.state == 0 then
			p ("Поле А2 не заполнено. Сюда можно поставить нолик.")
		end;
		if s.state == 1 then
			p ("На поле А2 стоит крестик.")
		end;
		if s.state == 2 then
			p ("На поле А2 стоит нолик.")
		end;
	end;
	before_Receive = function(s, w)
		if (w == _'room16_o') then
			if (_'room16_wardrobe'.turn == 0) then
				if (s.state == 0) then
					if (pl:have(_'dagger')) then
						p ('Остриём кинжала ты выцарапываешь нолик на поле А2.')
						s.state = 2
						_'room16_wardrobe'.turn = 1
						_'room16_AI'.state = _'room16_AI'.state + 1
						_'room16_AI':continue()
					else
						p ('Чтобы поставить нолик, нужен кинжал.')
					end;
				else
					p ('Это поле уже заполнено. Нельзя же играть не по правилам!')
				end;
			else
				p ('Ты уже поставила один нолик в этом ходу. Нельзя же играть не по правилам!')
			end;
		else
			if (w == _'room16_x' and _'room16_wardrobe'.state >= 4) then
				if (_'room16_wardrobe'.turn == 0) then
					if (s.state == 0) then
						if (pl:have(_'dagger')) then
							p ('Остриём кинжала ты выцарапываешь крестик на поле А2.')
							s.state = 1
							_'room16_wardrobe'.turn = 1
							_'room16_AI'.state = _'room16_AI'.state + 1
						else
							p ('Чтобы поставить крестик, нужен кинжал.')
						end;
					else
						p ('Это поле уже заполнено. Нельзя же играть не по правилам!')
					end;
				end;				
			else
				p ('Что??')
			end;
		end;
	end;
}:attr 'scenery, static, supporter'

obj {
	-"поле А3, А3, поле а3, а3";
	nam = "room16_a3";
	title = "Поле А3";
	state = 0;
	description = function(s)
		if s.state == 0 then
			p ("Поле А3 не заполнено. Сюда можно поставить нолик.")
		end;
		if s.state == 1 then
			p ("На поле А3 стоит крестик.")
		end;
		if s.state == 2 then
			p ("На поле А3 стоит нолик.")
		end;
	end;
	before_Receive = function(s, w)
		if (w == _'room16_o') then
			if (_'room16_wardrobe'.turn == 0) then
				if (s.state == 0) then
					if (pl:have(_'dagger')) then
						p ('Остриём кинжала ты выцарапываешь нолик на поле А3.')
						s.state = 2
						_'room16_wardrobe'.turn = 1
						_'room16_AI'.state = _'room16_AI'.state + 1
						_'room16_AI':continue()
					else
						p ('Чтобы поставить нолик, нужен кинжал.')
					end;
				else
					p ('Это поле уже заполнено. Нельзя же играть не по правилам!')
				end;
			else
				p ('Ты уже поставила один нолик в этом ходу. Нельзя же играть не по правилам!')
			end;
		else
			if (w == _'room16_x' and _'room16_wardrobe'.state >= 4) then
				if (_'room16_wardrobe'.turn == 0) then
					if (s.state == 0) then
						if (pl:have(_'dagger')) then
							p ('Остриём кинжала ты выцарапываешь крестик на поле А3.')
							s.state = 1
							_'room16_wardrobe'.turn = 1
							_'room16_AI'.state = _'room16_AI'.state + 1
						else
							p ('Чтобы поставить крестик, нужен кинжал.')
						end;
					else
						p ('Это поле уже заполнено. Нельзя же играть не по правилам!')
					end;
				end;				
			else
				p ('Что??')
			end;
		end;
	end;
}:attr 'scenery, static, supporter'

obj {
	-"поле Б1, Б1, поле б1, б1";
	nam = "room16_b1";
	title = "Поле Б1";
	state = 0;
	description = function(s)
		if s.state == 0 then
			p ("Поле Б1 не заполнено. Сюда можно поставить нолик.")
		end;
		if s.state == 1 then
			p ("На поле Б1 стоит крестик.")
		end;
		if s.state == 2 then
			p ("На поле Б1 стоит нолик.")
		end;
	end;
	before_Receive = function(s, w)
		if (w == _'room16_o') then
			if (_'room16_wardrobe'.turn == 0) then
				if (s.state == 0) then
					if (pl:have(_'dagger')) then
						p ('Остриём кинжала ты выцарапываешь нолик на поле Б1.')
						s.state = 2
						_'room16_wardrobe'.turn = 1
						_'room16_AI'.state = _'room16_AI'.state + 1
						_'room16_AI':continue()
					else
						p ('Чтобы поставить нолик, нужен кинжал.')
					end;
				else
					p ('Это поле уже заполнено. Нельзя же играть не по правилам!')
				end;
			else
				p ('Ты уже поставила один нолик в этом ходу. Нельзя же играть не по правилам!')
			end;
		else
			if (w == _'room16_x' and _'room16_wardrobe'.state >= 4) then
				if (_'room16_wardrobe'.turn == 0) then
					if (s.state == 0) then
						if (pl:have(_'dagger')) then
							p ('Остриём кинжала ты выцарапываешь крестик на поле Б1.')
							s.state = 1
							_'room16_wardrobe'.turn = 1
							_'room16_AI'.state = _'room16_AI'.state + 1
						else
							p ('Чтобы поставить крестик, нужен кинжал.')
						end;
					else
						p ('Это поле уже заполнено. Нельзя же играть не по правилам!')
					end;
				end;				
			else
				p ('Что??')
			end;
		end;
	end;
}:attr 'scenery, static, supporter'

obj {
	-"поле Б2, Б2, поле б2, б2";
	nam = "room16_b2";
	title = "Поле Б2";
	state = 0;
	description = function(s)
		if s.state == 0 then
			p ("Поле Б2 не заполнено. Сюда можно поставить нолик.")
		end;
		if s.state == 1 then
			p ("На поле Б2 стоит крестик.")
		end;
		if s.state == 2 then
			p ("На поле Б2 стоит нолик.")
		end;
	end;
	before_Receive = function(s, w)
		if (w == _'room16_o') then
			if (_'room16_wardrobe'.turn == 0) then
				if (s.state == 0) then
					if (pl:have(_'dagger')) then
						p ('Остриём кинжала ты выцарапываешь нолик на поле Б2.')
						s.state = 2
						_'room16_wardrobe'.turn = 1
						_'room16_AI'.state = _'room16_AI'.state + 1
						_'room16_AI':continue()
					else
						p ('Чтобы поставить нолик, нужен кинжал.')
					end;
				else
					p ('Это поле уже заполнено. Нельзя же играть не по правилам!')
				end;
			else
				p ('Ты уже поставила один нолик в этом ходу. Нельзя же играть не по правилам!')
			end;
		else
			if (w == _'room16_x' and _'room16_wardrobe'.state >= 4) then
				if (_'room16_wardrobe'.turn == 0) then
					if (s.state == 0) then
						if (pl:have(_'dagger')) then
							p ('Остриём кинжала ты выцарапываешь крестик на поле Б2.')
							s.state = 1
							_'room16_wardrobe'.turn = 1
							_'room16_AI'.state = _'room16_AI'.state + 1
						else
							p ('Чтобы поставить крестик, нужен кинжал.')
						end;
					else
						p ('Это поле уже заполнено. Нельзя же играть не по правилам!')
					end;
				end;				
			else
				p ('Что??')
			end;
		end;
	end;
}:attr 'scenery, static, supporter'

obj {
	-"поле Б3, Б3, поле б3, б3";
	nam = "room16_b3";
	title = "Поле Б3";
	state = 0;
	description = function(s)
		if s.state == 0 then
			p ("Поле Б3 не заполнено. Сюда можно поставить нолик.")
		end;
		if s.state == 1 then
			p ("На поле Б3 стоит крестик.")
		end;
		if s.state == 2 then
			p ("На поле Б3 стоит нолик.")
		end;
	end;
	before_Receive = function(s, w)
		if (w == _'room16_o') then
			if (_'room16_wardrobe'.turn == 0) then
				if (s.state == 0) then
					if (pl:have(_'dagger')) then
						p ('Остриём кинжала ты выцарапываешь нолик на поле Б3.')
						s.state = 2
						_'room16_wardrobe'.turn = 1
						_'room16_AI'.state = _'room16_AI'.state + 1
						_'room16_AI':continue()
					else
						p ('Чтобы поставить нолик, нужен кинжал.')
					end;
				else
					p ('Это поле уже заполнено. Нельзя же играть не по правилам!')
				end;
			else
				p ('Ты уже поставила один нолик в этом ходу. Нельзя же играть не по правилам!')
			end;
		else
			if (w == _'room16_x' and _'room16_wardrobe'.state >= 4) then
				if (_'room16_wardrobe'.turn == 0) then
					if (s.state == 0) then
						if (pl:have(_'dagger')) then
							p ('Остриём кинжала ты выцарапываешь крестик на поле Б3.')
							s.state = 1
							_'room16_wardrobe'.turn = 1
							_'room16_AI'.state = _'room16_AI'.state + 1
						else
							p ('Чтобы поставить крестик, нужен кинжал.')
						end;
					else
						p ('Это поле уже заполнено. Нельзя же играть не по правилам!')
					end;
				end;				
			else
				p ('Что??')
			end;
		end;
	end;
}:attr 'scenery, static, supporter'

obj {
	-"поле В1, В1, поле в1, в1";
	nam = "room16_c1";
	title = "Поле В1";
	state = 0;
	description = function(s)
		if s.state == 0 then
			p ("Поле В1 не заполнено. Сюда можно поставить нолик.")
		end;
		if s.state == 1 then
			p ("На поле В1 стоит крестик.")
		end;
		if s.state == 2 then
			p ("На поле В1 стоит нолик.")
		end;
	end;
	before_Receive = function(s, w)
		if (w == _'room16_o') then
			if (_'room16_wardrobe'.turn == 0) then
				if (s.state == 0) then
					if (pl:have(_'dagger')) then
						p ('Остриём кинжала ты выцарапываешь нолик на поле В1.')
						s.state = 2
						_'room16_wardrobe'.turn = 1
						_'room16_AI'.state = _'room16_AI'.state + 1
						_'room16_AI':continue()
					else
						p ('Чтобы поставить нолик, нужен кинжал.')
					end;
				else
					p ('Это поле уже заполнено. Нельзя же играть не по правилам!')
				end;
			else
				p ('Ты уже поставила один нолик в этом ходу. Нельзя же играть не по правилам!')
			end;
		else
			if (w == _'room16_x' and _'room16_wardrobe'.state >= 4) then
				if (_'room16_wardrobe'.turn == 0) then
					if (s.state == 0) then
						if (pl:have(_'dagger')) then
							p ('Остриём кинжала ты выцарапываешь крестик на поле В1.')
							s.state = 1
							_'room16_wardrobe'.turn = 1
							_'room16_AI'.state = _'room16_AI'.state + 1
						else
							p ('Чтобы поставить крестик, нужен кинжал.')
						end;
					else
						p ('Это поле уже заполнено. Нельзя же играть не по правилам!')
					end;
				end;				
			else
				p ('Что??')
			end;
		end;
	end;
}:attr 'scenery, static, supporter'

obj {
	-"поле В2, В2, поле в2, в2";
	nam = "room16_c2";
	title = "Поле В2";
	state = 0;
	description = function(s)
		if s.state == 0 then
			p ("Поле В2 не заполнено. Сюда можно поставить нолик.")
		end;
		if s.state == 1 then
			p ("На поле В2 стоит крестик.")
		end;
		if s.state == 2 then
			p ("На поле В2 стоит нолик.")
		end;
	end;
	before_Receive = function(s, w)
		if (w == _'room16_o') then
			if (_'room16_wardrobe'.turn == 0) then
				if (s.state == 0) then
					if (pl:have(_'dagger')) then
						p ('Остриём кинжала ты выцарапываешь нолик на поле В2.')
						s.state = 2
						_'room16_wardrobe'.turn = 1
						_'room16_AI'.state = _'room16_AI'.state + 1
						_'room16_AI':continue()
					else
						p ('Чтобы поставить нолик, нужен кинжал.')
					end;
				else
					p ('Это поле уже заполнено. Нельзя же играть не по правилам!')
				end;
			else
				p ('Ты уже поставила один нолик в этом ходу. Нельзя же играть не по правилам!')
			end;
		else
			if (w == _'room16_x' and _'room16_wardrobe'.state >= 4) then
				if (_'room16_wardrobe'.turn == 0) then
					if (s.state == 0) then
						if (pl:have(_'dagger')) then
							p ('Остриём кинжала ты выцарапываешь крестик на поле В2.')
							s.state = 1
							_'room16_wardrobe'.turn = 1
							_'room16_AI'.state = _'room16_AI'.state + 1
						else
							p ('Чтобы поставить крестик, нужен кинжал.')
						end;
					else
						p ('Это поле уже заполнено. Нельзя же играть не по правилам!')
					end;
				end;				
			else
				p ('Что??')
			end;
		end;
	end;
}:attr 'scenery, static, supporter'

obj {
	-"поле В3, В3, поле в3, в3";
	nam = "room16_c3";
	title = "Поле В3";
	state = 0;
	description = function(s)
		if s.state == 0 then
			p ("Поле В3 не заполнено. Сюда можно поставить нолик.")
		end;
		if s.state == 1 then
			p ("На поле В3 стоит крестик.")
		end;
		if s.state == 2 then
			p ("На поле В3 стоит нолик.")
		end;
	end;
	before_Receive = function(s, w)
		if (w == _'room16_o') then
			if (_'room16_wardrobe'.turn == 0) then
				if (s.state == 0) then
					if (pl:have(_'dagger')) then
						p ('Остриём кинжала ты выцарапываешь нолик на поле В3.')
						s.state = 2
						_'room16_wardrobe'.turn = 1
						_'room16_AI'.state = _'room16_AI'.state + 1
						_'room16_AI':continue()
					else
						p ('Чтобы поставить нолик, нужен кинжал.')
					end;
				else
					p ('Это поле уже заполнено. Нельзя же играть не по правилам!')
				end;
			else
				p ('Ты уже поставила один нолик в этом ходу. Нельзя же играть не по правилам!')
			end;
		else
			if (w == _'room16_x' and _'room16_wardrobe'.state >= 4) then
				if (_'room16_wardrobe'.turn == 0) then
					if (s.state == 0) then
						if (pl:have(_'dagger')) then
							p ('Остриём кинжала ты выцарапываешь крестик на поле В3.')
							s.state = 1
							_'room16_wardrobe'.turn = 1
							_'room16_AI'.state = _'room16_AI'.state + 1
						else
							p ('Чтобы поставить крестик, нужен кинжал.')
						end;
					else
						p ('Это поле уже заполнено. Нельзя же играть не по правилам!')
					end;
				end;				
			else
				p ('Что??')
			end;
		end;
	end;
}:attr 'scenery, static, supporter'

obj {
	-"ИИ комнаты 16";
	nam = "room16_AI";
	title = "ИИ комнаты 16";
	state = 0;
	game = 0;
	win = 0;
	daemon_stage = 0;
	describe = function()
		if(_'room16_a1'.state == 1) then
			p('На поле А1 стоит крестик.')
		end;
		if(_'room16_a1'.state == 2) then
			p('На поле А1 стоит нолик.')
		end;
		if(_'room16_a2'.state == 1) then
			p('На поле А2 стоит крестик.')
		end;
		if(_'room16_a2'.state == 2) then
			p('На поле А2 стоит нолик.')
		end;
		if(_'room16_a3'.state == 1) then
			p('На поле А3 стоит крестик.')
		end;
		if(_'room16_a3'.state == 2) then
			p('На поле А3 стоит нолик.')
		end;
		if(_'room16_b1'.state == 1) then
			p('На поле Б1 стоит крестик.')
		end;
		if(_'room16_b1'.state == 2) then
			p('На поле Б1 стоит нолик.')
		end;
		if(_'room16_b2'.state == 1) then
			p('На поле Б2 стоит крестик.')
		end;
		if(_'room16_b2'.state == 2) then
			p('На поле Б2 стоит нолик.')
		end;
		if(_'room16_b3'.state == 1) then
			p('На поле Б3 стоит крестик.')
		end;
		if(_'room16_b3'.state == 2) then
			p('На поле Б3 стоит нолик.')
		end;
		if(_'room16_c1'.state == 1) then
			p('На поле В1 стоит крестик.')
		end;
		if(_'room16_c1'.state == 2) then
			p('На поле В1 стоит нолик.')
		end;
		if(_'room16_c2'.state == 1) then
			p('На поле В2 стоит крестик.')
		end;
		if(_'room16_c2'.state == 2) then
			p('На поле В2 стоит нолик.')
		end;
		if(_'room16_c3'.state == 1) then
			p('На поле В3 стоит крестик.')
		end;
		if(_'room16_c3'.state == 2) then
			p('На поле В3 стоит нолик.')
		end;
		if(_'room16_a1'.state == 1 and _'room16_a2'.state == 1 and _'room16_a3'.state == 1) then _'room16_AI'.win = 1; end;
		if(_'room16_a1'.state == 1 and _'room16_b1'.state == 1 and _'room16_c1'.state == 1) then _'room16_AI'.win = 1; end;
		if(_'room16_a3'.state == 1 and _'room16_b3'.state == 1 and _'room16_c3'.state == 1) then _'room16_AI'.win = 1; end;
		if(_'room16_c1'.state == 1 and _'room16_c2'.state == 1 and _'room16_c3'.state == 1) then _'room16_AI'.win = 1; end;
		if(_'room16_b1'.state == 1 and _'room16_b2'.state == 1 and _'room16_b3'.state == 1) then _'room16_AI'.win = 1; end;
		if(_'room16_a2'.state == 1 and _'room16_b2'.state == 1 and _'room16_c2'.state == 1) then _'room16_AI'.win = 1; end;
		if(_'room16_a1'.state == 1 and _'room16_b2'.state == 1 and _'room16_c3'.state == 1) then _'room16_AI'.win = 1; end;
		if(_'room16_a3'.state == 1 and _'room16_b2'.state == 1 and _'room16_c1'.state == 1) then _'room16_AI'.win = 1; end;
		if(_'room16_a1'.state == 2 and _'room16_a2'.state == 2 and _'room16_a3'.state == 2) then _'room16_AI'.win = 2; end;
		if(_'room16_a1'.state == 2 and _'room16_b1'.state == 2 and _'room16_c1'.state == 2) then _'room16_AI'.win = 2; end;
		if(_'room16_a3'.state == 2 and _'room16_b3'.state == 2 and _'room16_c3'.state == 2) then _'room16_AI'.win = 2; end;
		if(_'room16_c1'.state == 2 and _'room16_c2'.state == 2 and _'room16_c3'.state == 2) then _'room16_AI'.win = 2; end;
		if(_'room16_b1'.state == 2 and _'room16_b2'.state == 2 and _'room16_b3'.state == 2) then _'room16_AI'.win = 2; end;
		if(_'room16_a2'.state == 2 and _'room16_b2'.state == 2 and _'room16_c2'.state == 2) then _'room16_AI'.win = 2; end;
		if(_'room16_a1'.state == 2 and _'room16_b2'.state == 2 and _'room16_c3'.state == 2) then _'room16_AI'.win = 2; end;
		if(_'room16_a3'.state == 2 and _'room16_b2'.state == 2 and _'room16_c1'.state == 2) then _'room16_AI'.win = 2; end;
		if(_'room16_wardrobe'.state < 4) then
			if(_'room16_AI'.win == 1) then
				p('Три крестика соединены линией: кажется, ты проиграла. Вдруг таинственная сила отбрасывает тебя от шкафа, а его дверцы захлопываются.')
				_'room16_wardrobe'.state = 0;
				_'room16_AI'.state = 0;
				_'room16_wardrobe':attr '~open';
				_'room16_a1'.state = 0;
				_'room16_a2'.state = 0;
				_'room16_a3'.state = 0;
				_'room16_b1'.state = 0;
				_'room16_b2'.state = 1;
				_'room16_b3'.state = 0;
				_'room16_c1'.state = 0;
				_'room16_c2'.state = 0;
				_'room16_c3'.state = 0;
				_'room16_AI'.win = 0;
			end;
			--if(_'room16_a1'.state ~= 0 and _'room16_a2'.state ~= 0 and _'room16_a3'.state ~= 0 and _'room16_b1'.state ~= 0 and _'room16_b2'.state ~= 0 and _'room16_b3'.state ~= 0 and _'room16_c1'.state ~= 0 and _'room16_c2'.state ~= 0 and _'room16_c3'.state ~= 0) then
			if(_'room16_AI'.state == 4) then
				p('Все поля исцарапаны, но никто не победил. Вдруг шкаф начинает трястись, и таинственная сила отбрасывает тебя в другой конец комнаты. Шкаф захлопывается.')
				if(_'room16_AI'.game == 0) then _'room16_wardrobe'.firsttime = 0; end;
				_'room16_AI'.game = 1;
				_'room16_wardrobe'.state = 0;
				_'room16_AI'.state = 0;
				_'room16_wardrobe':attr '~open';
				_'room16_a1'.state = 0;
				_'room16_a2'.state = 0;
				_'room16_a3'.state = 0;
				_'room16_b1'.state = 0;
				_'room16_b2'.state = 1;
				_'room16_b3'.state = 0;
				_'room16_c1'.state = 0;
				_'room16_c2'.state = 0;
				_'room16_c3'.state = 0;
			end;
		else
			if(_'room16_AI'.win == 1) then
				p('Три крестика соединены линией: ты выиграла. Не совсем, правда, понятно, у кого. Стоит тебе об этом подумать, как все крестики и нолики исчезают, оставляя таблицу пустой.')
				_'room16_AI'.state = 0;
				_'room16_a1'.state = 0;
				_'room16_a2'.state = 0;
				_'room16_a3'.state = 0;
				_'room16_b1'.state = 0;
				_'room16_b2'.state = 0;
				_'room16_b3'.state = 0;
				_'room16_c1'.state = 0;
				_'room16_c2'.state = 0;
				_'room16_c3'.state = 0;
				_'room16_wardrobe'.turn = 0;
				_'room16_AI'.win = 0;
			end;
			if(_'room16_AI'.win == 2) then
				p('Три нолика соединены линией: кто бы ни был твоим воображаемым противником, ты проиграла. Стоит тебе об этом подумать, как все крестики и нолики исчезают, оставляя таблицу пустой.')
				_'room16_AI'.state = 0;
				_'room16_a1'.state = 0;
				_'room16_a2'.state = 0;
				_'room16_a3'.state = 0;
				_'room16_b1'.state = 0;
				_'room16_b2'.state = 0;
				_'room16_b3'.state = 0;
				_'room16_c1'.state = 0;
				_'room16_c2'.state = 0;
				_'room16_c3'.state = 0;
				_'room16_wardrobe'.turn = 0;
				_'room16_AI'.win = 0;
			end;
			if(_'room16_a1'.state ~= 0 and _'room16_a2'.state ~= 0 and _'room16_a3'.state ~= 0 and _'room16_b1'.state ~= 0 and _'room16_b2'.state ~= 0 and _'room16_b3'.state ~= 0 and _'room16_c1'.state ~= 0 and _'room16_c2'.state ~= 0 and _'room16_c3'.state ~= 0) then
				p('Все поля заполнены, но никто не победил. Кто бы ни был твоим воображаемым противником, у вас ничья. Стоит тебе об этом подумать, как все крестики и нолики исчезают, оставляя таблицу пустой.')
				_'room16_AI'.state = 0;
				_'room16_a1'.state = 0;
				_'room16_a2'.state = 0;
				_'room16_a3'.state = 0;
				_'room16_b1'.state = 0;
				_'room16_b2'.state = 0;
				_'room16_b3'.state = 0;
				_'room16_c1'.state = 0;
				_'room16_c2'.state = 0;
				_'room16_c3'.state = 0;
				_'room16_wardrobe'.turn = 0;
				_'room16_AI'.win = 0;			
			end;
		end;
	end;
	checkwin = function()
		if(_'room16_a1'.state == 1 and _'room16_a2'.state == 1 and _'room16_a3'.state == 1) then _'room16_AI'.win = 1; end;
		if(_'room16_a1'.state == 1 and _'room16_b1'.state == 1 and _'room16_c1'.state == 1) then _'room16_AI'.win = 1; end;
		if(_'room16_a3'.state == 1 and _'room16_b3'.state == 1 and _'room16_c3'.state == 1) then _'room16_AI'.win = 1; end;
		if(_'room16_c1'.state == 1 and _'room16_c2'.state == 1 and _'room16_c3'.state == 1) then _'room16_AI'.win = 1; end;
		if(_'room16_b1'.state == 1 and _'room16_b2'.state == 1 and _'room16_b3'.state == 1) then _'room16_AI'.win = 1; end;
		if(_'room16_a2'.state == 1 and _'room16_b2'.state == 1 and _'room16_c2'.state == 1) then _'room16_AI'.win = 1; end;
		if(_'room16_a1'.state == 1 and _'room16_b2'.state == 1 and _'room16_c3'.state == 1) then _'room16_AI'.win = 1; end;
		if(_'room16_a3'.state == 1 and _'room16_b2'.state == 1 and _'room16_c1'.state == 1) then _'room16_AI'.win = 1; end;
		if(_'room16_a1'.state == 2 and _'room16_a2'.state == 2 and _'room16_a3'.state == 2) then _'room16_AI'.win = 2; end;
		if(_'room16_a1'.state == 2 and _'room16_b1'.state == 2 and _'room16_c1'.state == 2) then _'room16_AI'.win = 2; end;
		if(_'room16_a3'.state == 2 and _'room16_b3'.state == 2 and _'room16_c3'.state == 2) then _'room16_AI'.win = 2; end;
		if(_'room16_c1'.state == 2 and _'room16_c2'.state == 2 and _'room16_c3'.state == 2) then _'room16_AI'.win = 2; end;
		if(_'room16_b1'.state == 2 and _'room16_b2'.state == 2 and _'room16_b3'.state == 2) then _'room16_AI'.win = 2; end;
		if(_'room16_a2'.state == 2 and _'room16_b2'.state == 2 and _'room16_c2'.state == 2) then _'room16_AI'.win = 2; end;
		if(_'room16_a1'.state == 2 and _'room16_b2'.state == 2 and _'room16_c3'.state == 2) then _'room16_AI'.win = 2; end;
		if(_'room16_a3'.state == 2 and _'room16_b2'.state == 2 and _'room16_c1'.state == 2) then _'room16_AI'.win = 2; end;
		if(_'room16_wardrobe'.state < 4) then
			if(_'room16_AI'.win == 1) then
				p('Три крестика соединены линией: кажется, ты проиграла. Вдруг таинственная сила отбрасывает тебя от шкафа, а его дверцы захлопываются.')
				_'room16_wardrobe'.state = 0;
				_'room16_AI'.state = 0;
				_'room16_wardrobe':attr '~open';
				_'room16_a1'.state = 0;
				_'room16_a2'.state = 0;
				_'room16_a3'.state = 0;
				_'room16_b1'.state = 0;
				_'room16_b2'.state = 1;
				_'room16_b3'.state = 0;
				_'room16_c1'.state = 0;
				_'room16_c2'.state = 0;
				_'room16_c3'.state = 0;
				_'room16_AI'.win = 0;
			end;
			--if(_'room16_a1'.state ~= 0 and _'room16_a2'.state ~= 0 and _'room16_a3'.state ~= 0 and _'room16_b1'.state ~= 0 and _'room16_b2'.state ~= 0 and _'room16_b3'.state ~= 0 and _'room16_c1'.state ~= 0 and _'room16_c2'.state ~= 0 and _'room16_c3'.state ~= 0) then
			if(_'room16_AI'.state == 4) then
				p('Все поля исцарапаны, но никто не победил. Вдруг шкаф начинает трястись, и таинственная сила отбрасывает тебя в другой конец комнаты. Шкаф захлопывается.')
				if(_'room16_AI'.game == 0) then _'room16_wardrobe'.firsttime = 0; end;
				_'room16_AI'.game = 1;
				_'room16_wardrobe'.state = 0;
				_'room16_AI'.state = 0;
				_'room16_wardrobe':attr '~open';
				_'room16_a1'.state = 0;
				_'room16_a2'.state = 0;
				_'room16_a3'.state = 0;
				_'room16_b1'.state = 0;
				_'room16_b2'.state = 1;
				_'room16_b3'.state = 0;
				_'room16_c1'.state = 0;
				_'room16_c2'.state = 0;
				_'room16_c3'.state = 0;
			end;
		else
			if(_'room16_AI'.win == 1) then
				p('Три крестика соединены линией: ты выиграла. Не совсем, правда, понятно, у кого. Стоит тебе об этом подумать, как все крестики и нолики исчезают, оставляя таблицу пустой.')
				_'room16_AI'.state = 0;
				_'room16_a1'.state = 0;
				_'room16_a2'.state = 0;
				_'room16_a3'.state = 0;
				_'room16_b1'.state = 0;
				_'room16_b2'.state = 0;
				_'room16_b3'.state = 0;
				_'room16_c1'.state = 0;
				_'room16_c2'.state = 0;
				_'room16_c3'.state = 0;
				_'room16_wardrobe'.turn = 0;
				_'room16_AI'.win = 0;
			end;
			if(_'room16_AI'.win == 2) then
				p('Три нолика соединены линией: кто бы ни был твоим воображаемым противником, ты проиграла. Стоит тебе об этом подумать, как все крестики и нолики исчезают, оставляя таблицу пустой.')
				_'room16_AI'.state = 0;
				_'room16_a1'.state = 0;
				_'room16_a2'.state = 0;
				_'room16_a3'.state = 0;
				_'room16_b1'.state = 0;
				_'room16_b2'.state = 0;
				_'room16_b3'.state = 0;
				_'room16_c1'.state = 0;
				_'room16_c2'.state = 0;
				_'room16_c3'.state = 0;
				_'room16_wardrobe'.turn = 0;
				_'room16_AI'.win = 0;
			end;
			if(_'room16_a1'.state ~= 0 and _'room16_a2'.state ~= 0 and _'room16_a3'.state ~= 0 and _'room16_b1'.state ~= 0 and _'room16_b2'.state ~= 0 and _'room16_b3'.state ~= 0 and _'room16_c1'.state ~= 0 and _'room16_c2'.state ~= 0 and _'room16_c3'.state ~= 0) then
				p('Все поля заполнены, но никто не победил. Кто бы ни был твоим воображаемым противником, у вас ничья. Стоит тебе об этом подумать, как все крестики и нолики исчезают, оставляя таблицу пустой.')
				_'room16_AI'.state = 0;
				_'room16_a1'.state = 0;
				_'room16_a2'.state = 0;
				_'room16_a3'.state = 0;
				_'room16_b1'.state = 0;
				_'room16_b2'.state = 0;
				_'room16_b3'.state = 0;
				_'room16_c1'.state = 0;
				_'room16_c2'.state = 0;
				_'room16_c3'.state = 0;
				_'room16_wardrobe'.turn = 0;
				_'room16_AI'.win = 0;			
			end;
		end;
	end;
	continue = function()
		if(_'room16_a1'.state == 2 and _'room16_a2'.state == 2 and _'room16_a3'.state == 2) then _'room16_AI'.win = 2; end;
		if(_'room16_a1'.state == 2 and _'room16_b1'.state == 2 and _'room16_c1'.state == 2) then _'room16_AI'.win = 2; end;
		if(_'room16_a3'.state == 2 and _'room16_b3'.state == 2 and _'room16_c3'.state == 2) then _'room16_AI'.win = 2; end;
		if(_'room16_c1'.state == 2 and _'room16_c2'.state == 2 and _'room16_c3'.state == 2) then _'room16_AI'.win = 2; end;
		if(_'room16_AI'.win == 2) then
			p ('Ты победно соединяешь три нолика одной кривой линией (так уж получается, когда царапаешь кинжалами шкафы), и вдруг какая-то таинственная сила отталкивает тебя от шкафа с такой силой, что кинжал остаётся в шкафу. Дверцы шкафа захлопываются.')
			move(_'dagger',_'room16_wardrobe')
			_'room16_AI'.game = 2;
			_'room16_wardrobe'.state = 2;
			_'room16_AI'.state = 0;
			_'room16_wardrobe':attr '~open';
			remove(_'room16_o',pl)
			remove(_'room16_x',pl)
			remove(_'room16_a1',_'room16_wardrobe')
			remove(_'room16_a2',_'room16_wardrobe')
			remove(_'room16_a3',_'room16_wardrobe')
			remove(_'room16_b1',_'room16_wardrobe')
			remove(_'room16_b2',_'room16_wardrobe')
			remove(_'room16_b3',_'room16_wardrobe')
			remove(_'room16_c1',_'room16_wardrobe')
			remove(_'room16_c2',_'room16_wardrobe')
			remove(_'room16_c3',_'room16_wardrobe')
		else
			if(_'room16_wardrobe'.firsto == 1) then
				p('Ты поняла принцип игры и скорее закрываешь шкаф.')
				_'room16_wardrobe':before_Close(_'room16_wardrobe')
				_'room16_wardrobe':attr '~open'
			else
				_'room16_wardrobe'.firsto = 1;
			end;
		end;
	end;
	calculate = function()
		if(_'room16_AI'.state == 1) then
			if(_'room16_a1'.state == 2) then _'room16_b3'.state = 1 end;
			if(_'room16_a2'.state == 2) then _'room16_b3'.state = 1 end;
			if(_'room16_a3'.state == 2) then _'room16_b1'.state = 1 end;
			if(_'room16_b1'.state == 2) then _'room16_a2'.state = 1 end;
			if(_'room16_b3'.state == 2) then _'room16_a2'.state = 1 end;
			if(_'room16_c1'.state == 2) then _'room16_a2'.state = 1 end;
			if(_'room16_c2'.state == 2) then _'room16_b3'.state = 1 end;
			if(_'room16_c3'.state == 2) then _'room16_a2'.state = 1 end;
		end;
		if(_'room16_AI'.state == 2) then
			if(_'room16_b3'.state == 1) then
				if(_'room16_b1'.state == 2) then
					if(_'room16_a1'.state == 2) then _'room16_c1'.state = 1 end;
					if(_'room16_a2'.state == 2) then _'room16_a3'.state = 1 end;
					if(_'room16_c2'.state == 2) then _'room16_a3'.state = 1 end;
				else
					_'room16_b1'.state = 1
				end;
			end;
			if(_'room16_a2'.state == 1) then
				if(_'room16_c2'.state == 2) then
					if(_'room16_b1'.state == 2) then _'room16_a3'.state = 1 end;
					if(_'room16_b3'.state == 2) then _'room16_a3'.state = 1 end;
					if(_'room16_c1'.state == 2) then _'room16_c3'.state = 1 end;
					if(_'room16_c3'.state == 2) then _'room16_c1'.state = 1 end;
				else
					_'room16_c2'.state = 1
				end;
			end;
			if(_'room16_b1'.state == 1) then
				if(_'room16_b3'.state == 2) then
					_'room16_c3'.state = 1
				else
					_'room16_b3'.state = 1
				end;
			end;
		end;
		if(_'room16_AI'.state == 3) then
			if(_'room16_a3'.state == 1) then
				if(_'room16_a2'.state == 1) then
					if(_'room16_a1'.state == 2) then
						_'room16_c1'.state = 1
					else
						_'room16_a1'.state = 1
					end;
				end;
				if(_'room16_b3'.state == 1) then
					if(_'room16_c1'.state == 2) then
						_'room16_c3'.state = 1
					else
						_'room16_c1'.state = 1
					end;
				end;				
			end;
			if(_'room16_c3'.state == 1) then
				if(_'room16_a1'.state == 2) then
					if(_'room16_a2'.state == 1) then
						if(_'room16_AI'.game == 0) then
							_'room16_b1'.state = 1
						else
							_'room16_a3'.state = 1
						end;
					end;
					if(_'room16_b1'.state == 1) then
						if(_'room16_AI'.game == 0) then
							_'room16_a2'.state = 1
						else
							_'room16_c1'.state = 1
						end;
					end;
				else
					_'room16_a1'.state = 1
				end;
			end;
			if(_'room16_c1'.state == 1) then
				if(_'room16_a3'.state == 2) then
					if(_'room16_a2'.state == 1) then
						if(_'room16_AI'.game == 0) then
							_'room16_b3'.state = 1
						else
							_'room16_a1'.state = 1
						end;
					end;
					if(_'room16_b3'.state == 1) then
						if(_'room16_AI'.game == 0) then
							_'room16_a2'.state = 1
						else
							_'room16_c3'.state = 1
						end;
					end;
				else
					_'room16_a3'.state = 1
				end;
			end;
		end;
		if(_'room16_AI'.state == 4) then
			if(_'room16_a1'.state == 0) then _'room16_a1'.state = 1 end;
			if(_'room16_a2'.state == 0) then _'room16_a2'.state = 1 end;
			if(_'room16_a3'.state == 0) then _'room16_a3'.state = 1 end;
			if(_'room16_b1'.state == 0) then _'room16_b1'.state = 1 end;
			if(_'room16_b3'.state == 0) then _'room16_b3'.state = 1 end;
			if(_'room16_c1'.state == 0) then _'room16_c1'.state = 1 end;
			if(_'room16_c2'.state == 0) then _'room16_c2'.state = 1 end;
			if(_'room16_c3'.state == 0) then _'room16_c3'.state = 1 end;
		end;
	end;
	finish = function()
		_'room16_mystical'.state = 1
		_'room16_wardrobe'.state = 3
		_'room16_wardrobe':attr 'open'
		_'room16_wardrobe':attr 'enterable'
		move(_'room16_witch',_'room16_mystical')
		move(_'room16_wall',_'room16_mystical')
		move(_'room16_walls',_'room16_mystical')
		DaemonStart 'room16_AI'
	end;
	aiturn = function()
		_'room16_AI':checkwin()
		if(_'room16_wardrobe'.turn == 1) then
			_'room16_wardrobe'.turn = 0
			if(_'room16_b2'.state == 0) then
				p 'Ты замечешь, что на поле Б2 появляется нацарапанный нолик.'
				_'room16_b2'.state = 2;
			else
				if(_'room16_a3'.state == 0) then
					p 'Ты замечешь, что на поле A3 появляется нацарапанный нолик.'
					_'room16_a3'.state = 2;
				else
					if(_'room16_c3'.state == 0) then
						p 'Ты замечешь, что на поле В3 появляется нацарапанный нолик.'
						_'room16_c3'.state = 2;
					else
						if(_'room16_c1'.state == 0) then
							p 'Ты замечешь, что на поле В2 появляется нацарапанный нолик.'
							_'room16_c1'.state = 2;
						else
							if(_'room16_a1'.state == 0) then
								p 'Ты замечешь, что на поле А1 появляется нацарапанный нолик.'
								_'room16_a1'.state = 2;
							else
								if(_'room16_b3'.state == 0) then
									p 'Ты замечешь, что на поле Б3 появляется нацарапанный нолик.'
									_'room16_b3'.state = 2;
								else
									if(_'room16_c2'.state == 0) then
										p 'Ты замечешь, что на поле В2 появляется нацарапанный нолик.'
										_'room16_c2'.state = 2;
									else
										if(_'room16_b1'.state == 0) then
											p 'Ты замечешь, что на поле Б1 появляется нацарапанный нолик.'
											_'room16_b1'.state = 2;
										else
											if(_'room16_a2'.state == 0) then
												p 'Ты замечешь, что на поле А2 появляется нацарапанный нолик.'
												_'room16_a2'.state = 2;
											end;
										end;
									end;
								end;
							end;
						end;
					end;
				end;
			end;
		end;
		_'room16_AI':checkwin()
	end;
	daemon = function(s)
		if(_'room16_AI'.daemon_stage == 0) then
			p (' -- Я вот думаю, на лоскутки тебя порезать или на кусочки разорвать. А, прислужница госмашины?')		
		end;
		if(_'room16_AI'.daemon_stage == 1) then
			p (' -- Сейчас, наточу когти, разберусь с тобой. Ты пока подумай, жизнь вспомни.')		
		end;
		if(_'room16_AI'.daemon_stage == 2) then
			p (' -- Тут, конечно, нужны кусачки.')
		end;
		if(_'room16_AI'.daemon_stage == 3) then
			p (' -- Заусенец проклятый! Вот и ты, Настенька, как заусенец у меня в пальце сейчас: и жалко, и противно!')		
		end;
		if(_'room16_AI'.daemon_stage == 4) then
			p (' -- Ну ладно, готово.')		
		end;
		if(_'room16_AI'.daemon_stage == 5) then
			DaemonStop 'room16_AI';
			walk 'room16_cutsceneB'
		end;
		if(_'room16_AI'.daemon_stage == 6) then
			DaemonStop 'room16_AI';
			walk 'room16_cutsceneC'
		end;
		if(_'room16_AI'.daemon_stage == 7) then
			DaemonStop 'room16_AI';
			walk 'room16_cutsceneD'
		end;
		if(_'room16_AI'.daemon_stage == 8) then
			DaemonStop 'room16_AI';
			walk 'room16_cutsceneE'
		end;
		if(_'room16_AI'.daemon_stage == 9) then
			DaemonStop 'room16_AI';
			walk 'room16_cutsceneF'
		end;
		if(_'room16_AI'.daemon_stage == 10) then
			p (' -- Ха-ха-ха! Глупышка, ты попалась в ловушку! Теперь ты навеки будешь заточена в этом шкафу.')
		end;
		if(_'room16_AI'.daemon_stage == 11) then
			p (' -- Там даже не ловит мобильник, детка!')
		end;
		if(_'room16_AI'.daemon_stage == 12) then
			p (' -- Кстати, я заколдовала шкаф так, что в нём нельзя ни повеситься, ни зарезаться, вообще никак нельзя самоубиться! Ты даже со скуки умереть на сможешь!')
		end;
		if(_'room16_AI'.daemon_stage == 13) then
			p (' -- А что: считай, я подарила тебе бессмертие.')
		end;
		if(_'room16_AI'.daemon_stage == 14) then
			p (' -- Помолись там, что ли. А нет, забыла. Это тоже нельзя.')
		end;
		if(_'room16_AI'.daemon_stage == 15) then
			p (' -- Ладно-ладно. Мне пора принять ванну. Пока-пока, племяшка!')
		end;
		if(_'room16_AI'.daemon_stage == 16) then
			p ('Какое-то время ты слышишь звуки шагов, а потом они стихают. Похоже, ты здесь надолго.')
		end;
		if(_'room16_AI'.daemon_stage == 17) then
			p ('Кто-то мог бы сказать, что ты нашла концовку №4/4. Но ты, конечно, можешь с этим не согласиться и играть дальше.')
		end;
		if(_'room16_AI'.daemon_stage == 20) then
			--DaemonStop 'room16_AI'		
		end;
		if(_'room16_AI'.daemon_stage > 20) then
			_'room16_AI':aiturn()
		end;
		_'room16_AI'.daemon_stage = _'room16_AI'.daemon_stage + 1
	end;
}:attr 'scenery, static'

cutscene {
	nam = 'room16_cutscene';
	text = {
		"Ты открываешь шкаф -- а там вместо крестиков-ноликов сидит какая-то старуха.";
		"Она поднимает на тебя глаза и пытается эффектно сдуть немытую прядь волос себе на лоб.";
		"Не выходит: прилипло.";
		" -- Не думала, что вы прознаете про мои тайные симпатии к крестикам-ноликам, буржуи недобитые! -- бормочет старуха.";
		"Она медленно поднимается на кривые ноги, как в фильмах ужасов.";
		" -- Я понаставила замков, вырубила вайфай, утопила телефон, провела оккультные ритуалы, исчезла в шкафу -- а государственная машина всё равно меня выцарапала, подумать только.";
		"Старуха со скрипом распрямляет засохшую спину, и ты узнаёшь в её физиономии лицо тетушки Агаты, только какое-то немытое.";
	};
	next_to = 'room16_dialogue'
}

dlg {
	nam = 'room16_dialogue';
	phr = {
		[[-- Настюха, ты что ли? -- прозревает тётя Агата.]];
		{
			'Ну конечно!',
			function() walk 'room16_dialogueA'; end;
		},
		{
			'Что с тобой, тётушка?',
			function() walk 'room16_dialogueB'; end;
		},
	};
}

dlg {
	nam = 'room16_dialogueA';
	phr = {
		[[-- Значит, приставы завербовали и тебя. Но знаешь, что я тебе скажу?]],
		{
			'Какие ещё приставы?',
			function() p [[-- Не перебивай старших! Да, я не платила за коммуналку уже десять лет, и да, я принимала ванну два раза в день, и да, я майнила биткоины, ну и что!]]; walk 'room16_cutsceneA'; end;
		},
		{
			'Меня никто не вербовал!',
			function() p [[-- Не перебивай старших! Да, я не платила за коммуналку уже десять лет, и да, я принимала ванну два раза в день, и да, я майнила биткоины, ну и что!]]; walk 'room16_cutsceneA'; end;
		},
	};
}

dlg {
	nam = 'room16_dialogueB';
	phr = {
		[[-- Значит, приставы завербовали и тебя. Но знаешь, что я тебе скажу?]],
		{
			'Какие ещё приставы?',
			function() p [[-- Не перебивай старших! Да, я не платила за коммуналку уже десять лет, и да, я принимала ванну два раза в день, и да, я майнила биткоины, ну и что!]]; walk 'room16_cutsceneA'; end;
		},
		{
			'Меня никто не вербовал!',
			function() p [[-- Не перебивай старших! Да, я не платила за коммуналку уже десять лет, и да, я принимала ванну два раза в день, и да, я майнила биткоины, ну и что!]]; walk 'room16_cutsceneA'; end;
		},
		{
			'Тётушка Агата! Это Настя, ты что?',
			function() p [[-- Не перебивай старших! Да, я не платила за коммуналку уже десять лет, и да, я принимала ванну два раза в день, и да, я майнила биткоины, ну и что!]]; walk 'room16_cutsceneA'; end;
		},
	};
}

cutscene {
	nam = 'room16_cutsceneA';
	text = {
		"В глазах тётушки нет ничего, кроме слепой ярости по отношению к судебным приставам, и эта ярость направлена на тебя.";
		" -- Никто не должен был найти меня, девчонка! -- она выковыривается из шкафа, растопырив длинные когти.";
		" -- Абракадабра! Фу ты, пх'нглуи, мглв'нафх, алохомора, пламя Удуна, мать его! -- она кричит что-то невразумительное, и выход из комнаты исчезает.";
		"Тётка выпрыгивает из шкафа и, как птица, приземляется на пюпитр.";
		"Надо что-то делать. У тебя мало времени.";
	};
	next_to = function() _'room16_AI':finish(); mp.score=mp.score+1; walk 'room16_mystical'; end;
}

cutscene {
	nam = 'room16_cutsceneB';
	text = {
		"Одним махом тётя Агата прыгает на тебя, сбивая с ног.";
		"Она вонзает свои когти тебе в живот, а клыками впивается в шею.";
		"Ты даже не успеваешь пожалеть о том, что приехала в дом к своей тетё.";
	};
	next_to = 'room16_happyend';
}

cutscene {
	nam = 'room16_cutsceneC';
	text = {
		"Ты подбегаешь к тёте и пытаешься сбить её с пюпитра, но она оказывается ловчее, и одним махом прыгает на тебя, сбивая с ног.";
		"Она вонзает свои когти тебе в живот, а клыками впивается в шею.";
		"Ты даже не успеваешь пожалеть о том, что приехала в дом к своей тетё.";
	};
	next_to = 'room16_happyend';
}

cutscene {
	nam = 'room16_cutsceneD';
	text = {
		"Как сумасшедшая, ты бежишь на тётю с твёрдным намерением её зарезать.";
		"Увы, она не дура, и одним махом прыгает на тебя, сбивая с ног.";
		"Она вонзает свои когти тебе в живот, а клыками впивается в шею.";
		"Ты даже не успеваешь пожалеть о том, что приехала в дом к своей тетё.";
	};
	next_to = 'room16_happyend';
}

cutscene {
	nam = 'room16_cutsceneE';
	text = {
		"Ты берёшь кинжал за лезвие, как это делают циркачи.";
		"Тётя всё ковыряет свои когти и даже не замечает, как ты прицеливаешься.";
		"Один бросок -- и кинжал по самую рукоять уходит куда-то в тёткины лохмотья, а она падает на паркетный пол замертво.";
		" -- Какой-то нелепый конец, -- думаешь ты вслух.";
		"Теперь придётся выбираться из комнаты, у которой нет двери.";
		"Твой взгляд падает на щель под потолком.";
		"Закатный луч падает на тебя в ответ.";
	};
	next_to = 'room16_badend';
}

cutscene {
	nam = 'room16_cutsceneF';
	text = {
		"Ты выходишь из комнаты, войдя в четвёртую стену, которую сама же и разрушила.";
		"Тётя Агата осталась в своём особняке, приходить в себя.";
		"Может быть, она даже продаст пару биткоинов и заплатит за коммунальные услуги.";
		"А может, она спрячется ещё лучше, расставит ловушки и будет дожидаться судебных приставов при оружии.";
		"Тебе понравилась игра?";
		"Нет, не надо отвечать мне. Напиши на форуме ifiction.ru или на дискорд-сервере ifrus.";
		"Ну всё, пока.";
	};
	next_to = 'room16_theend';
}

obj {
	-"тётушка,тётушка,тётка,тётя,Агата,тётушка Агата*";
	nam = 'room16_witch';
	dsc = 'Тётушка сидит на пюпитре и точит когти.';
	description = 'Тётушка Агата одета в какие-то лохмотья. Она точит когти, скалит зубы, хлюпает носом, сверкает глазами и время от времени шевелит ушами.';
	before_ThrownAt = function(s,w)
		if(w == _'dagger') then
			_'room16_AI'.daemon_stage = 8
		else
			p 'Ты серьёзно?'	
		end;
	end;
	before_Attack = function(s)
		if(pl:have(_'dagger')) then
			_'room16_AI'.daemon_stage = 7
		else
			_'room16_AI'.daemon_stage = 6		
		end;
	end;	
	before_Push = function(s)
		_'room16_AI'.daemon_stage = 6
	end;	
	before_Cut = function(s,w)
		if(w == _'dagger') then
			_'room16_AI'.daemon_stage = 7
		else
			p 'Ты серьёзно?'
		end;
	end;	
	before_Tear = function(s)
		if(pl:have(_'dagger')) then
			_'room16_AI'.daemon_stage = 7
		else
			_'room16_AI'.daemon_stage = 6		
		end;
	end;	
	before_Talk = function(s)
		p('Разговаривать с тётей, когда она в таком состоянии, бессмысленно.')
	end;	
	before_Tell = function(s)
		p('Разговаривать с тётей, когда она в таком состоянии, бессмысленно.')
	end;	
	before_Ask = function(s)
		p('Разговаривать с тётей, когда она в таком состоянии, бессмысленно.')
	end;	
	before_AskFor = function(s)
		p('Разговаривать с тётей, когда она в таком состоянии, бессмысленно.')
	end;	
	before_AskTo = function(s)
		p('Разговаривать с тётей, когда она в таком состоянии, бессмысленно.')
	end;	
	before_Answer = function(s)
		p('Разговаривать с тётей, когда она в таком состоянии, бессмысленно.')
	end;
	obj = {
		obj {
			-"глаза,глаз*";
			description = [[Глаза цвета моря!]];
		};
		obj {
			-"нос";
			description = [[Прелестный носик!]];
		};
		obj {
			-"когти,коготь*";
			description = [[Когти тётушки длинные и кривые, потому что их не стригли уже много лет.]];
		};
		obj {
			-"зубы,зуб*";
			description = [[Зубов у тётушки много, но они все жёлтые. Потому что она их не чистила уже очень давно.]];
		};
		obj {
			-"уши,ухо*";
			description = [[Почему у неё такие большие уши?]];
		};
		obj {
			-"лохмотья*";
			description = [[Когда-то это было что-то приличное, но теперь...]];
		};
	}
}:attr 'animate'

obj {
	-"стены";
	nam = 'room16_walls';
	state = 0;
	description = 'Стены как стены. Нельзя сказать, что какая-то стена выделяется относительно остальных. Или можно?';
}:attr 'static, scenery'

obj {
	-"четвёртая стена";
	nam = 'room16_wall';
	state = 0;
	description = 'Ты стоишь как раз рядом с ней.';
	before_Attack = function(s)
		if(pl:have(_'dagger')) then
			if(s.state == 3) then
				p 'Тебе незачем тратить время: просто входи в стену!'
			end;
			if(s.state == 2) then
				p 'Ты расковыриваешь огромную дыру: четвёртая стена разрушена!'
				s:attr 'enterable'
				s:attr 'open'
                                mp.score=mp.score+1;
				s.state = 3
			end;
			if(s.state == 1) then
				p 'Ты продолжаешь рушить стену, и в ней уже образовалась дырка размером с твою голову. Ты могла бы попробовать сбежать, но всё, кроме головы, будет торчать на виду у тёти Агаты.'
                                mp.score=mp.score+1;
				s.state = 2
			end;
			if(s.state == 0) then
				p 'Ты нервно ковыряешь стену кинжалом, пока тётка точит когти и не смотрит на тебя. Постепенно, стена начинает рушиться.'
                                mp.score=mp.score+1;
				s.state = 1
			end;
		else
			p 'Рушить четвёртую стену голыми руками не получится.'
		end;
	end;
	before_Enter = function(s)
		if(s.state == 3) then
			_'room16_AI'.daemon_stage = 9
		else
			p 'Сначала надо разрушить четвёртую стену!'
		end;
	end;
}:attr 'static, scenery'

room {
	-"конец";
	nam = 'room16_happyend';
	title = "Конец";
	dsc = 'Вот и сказочке конец. Ты же сохранила игру, Настенька? (Концовка №3/4)';
	noparser = true;
}

room {
	-"конец";
	nam = 'room16_badend';
	title = "Конец";
	dsc = 'Вот и сказочке конец. Может, надо было обойтись без крови? Ты же сохранила игру, Настенька? (Концовка №2/4)';
	noparser = true;
}

room {
	-"конец";
	nam = 'room16_theend';
	title = "Конец";
	dsc = 'Вот и сказочке конец, а кто слушал -- молодец! (Концовка №1/4)';
	noparser = true;
}
