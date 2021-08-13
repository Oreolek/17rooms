-- Доступное пространство имён для объектов - все имена объектов должны начинаться с "room4_" или "kladovka_"
-- Все описания можно менять
-- Задача: Игрок должен открыть люк в пол предметом bonekey, он может придти в локацию как с ним, так и без него

global { song = 0 }

Verb {
   "#play",
   "игр/ать,поигр/ать",
   "Play",
   "на {noun}/пр,held : Play",
}

mp.msg.Play = {}
function mp:Play(w)
    if not w then
        p "На чём ты хочешь играть?";
        return;
    end
    if mp:check_touch() then
        return
    end
    if mp:check_held(w) then
        return
    end
    p(mp.msg.Play.PLAY)
end
--"может"
mp.msg.Play.PLAY = "{#Me/им} не {#word/может,#me} играть на {#first/пр}."

room {
   nam = "room4_kladovka";
   title = "Кладовка";
   transported = false,
   dsc = function(s)
	  if from() ^ "room4_ostrov" and s:once() then
		 return "Я увидела своё отражение, стоящее в кладовке. Затем мир покачнулся, и я снова оказалась в тесной комнате."
	  else
		 return "Тесная неинтересная комната. К западу кухня, на востоке прихожая."
	  end
   end;
   onenter = function(s)
	  if not s.transported then
		 s.transported = true
		 move(me(), "room4_ostrov");
		 place("room4_dolphin", "room4_mirror")
		 place("room4_crab", "room4_mirror")
		 place("room4_frog", "room4_mirror")
	  end
   end;
   w_to = "room6_kitchen";
   e_to = function(s)
		if s:once() then
		  p 'Ты толкнула дверь и оказалась в прихожей. Оказывается здесь есть проход! Теперь ходить между помещениями будет куда удобней!';
                end;
                _'room3_hall'.west = 1;
		return 'room3_hall';
   end;
   d_to = function(s)
	  if _"room4_hatch":has "open" then
		 return "room5_podval"
	  elseif _"room4_hatch":has "locked" then
		 p "Люк заперт."
	  else
		 p "Люк закрыт."
	  end
   end;
   before_Listen = "Ничего не слышно.";
   before_Smell = "Ничем не пахнет.";
   obj = {
	  nam = "room4_bonekey",
	  obj {
		 -- Упростил. Зеркало это один объект, находящийся в двух комнатах сразу.
			-"зеркало|стекло";
		 nam = "room4_mirror";
		 seen = false,
		 dsc = function(s)
			-- Проверяем откуда мы на зеркало смотрим (из кладовки или с острова) и выводим подходящее описание
			if here() ^ "room4_kladovka" then
			   return "На стене висит старинное зеркало.";
			else
			   return "Прямо в воздухе висит старинное зеркало.";
			end
		 end;
		 description = function(s)
			-- Та же фигня, что и в dsc
			if here() ^ "room4_kladovka" then
			   return [[Большое зеркало в старинной бронзовой раме, представляющей собой осьминога, растопырившего щупальца.]];
			else
			   return [[Большое зеркало в бронзовой раме по краю которой располагаются чеканные фигурки: змеи, краба и дельфина.]];
			end
		 end;
		 before_Search = function(s)
			-- s:once() возвращает true только один раз. Так что при первом осмотре попадаем на остров, а потом не попадаем
			if not s.seen then
			   if where("room4_sapfir") ^ "room4_dolphin" and where("room4_rybin") ^ "room4_crab" and where("room4_izymryd") ^ "room4_frog" then
				  s.seen = true
				  move(me(), "room4_kladovka")
				  mp.score=mp.score+1
			   else
				  --"посмотреть"
				  return "Моё отражение в зеркале выглядит как обычно. Ничего странного не происходит."
			   end
			else
			   return "Меня закрутило, завертело и втянуло прямо в зеркало. Я снова оказалась в кладовке. Ну и чудеса..."
			end
		 end;
		 -- Добавим описаний. Парсер же
		 before_Take = "Слишком большое и тяжёлое. Невозможно сдвинуть.";
		 before_Smell = "Пахнет морем. Странно, но так и есть.";
		 before_Taste = "Это не съедобно.";
		 before_Touch = "Гладкое и прохладное.";
	  }: attr "static",
	  -- Для парсера модельку лучше поподробнее :)
	  -- Я бы ещё источник света добавил для красоты %)
	  obj {
			-"стена|стены";
		 description = "Стены покрыты пыльной штукатуркой.";
		 before_Take = "Взять стены? Как?";
		 before_Smell = "Пахнет пылью.";
		 -- {#word...} это ещё одна магия метапарсера. Позволяет автоматически выводить глагол в нужной форме.
		 -- В основном применяется в библиотеках. Если не нравится, вписуй хардкод :)
		 before_Taste = "{#Me/им} не {#word/хотеть,#me,нст} пробовать стены на вкус.";
		 before_Touch = "Шершавые и пыльные стены.";
	  }:attr "scenery",
	  obj {
			-"пол";
		 -- По аналогии со стенами
		 description = "Каменный пол. Здесь явно не заморачивались с ремонтом.";
		 before_Take = "Взять пол невозможно";
		 before_Smell = "Пахнет пылью.";
		 before_Taste = "{#Me/им} не {#word/хотеть,#me,нст} пробовать камни пола на вкус.";
		 before_Touch = "Прохладный, слегка неровный камень.";
	  }:attr "scenery",
	  obj {
			-"потолок";
		 description = "Потолок покрыт голубой краской.";
		 before_Take = "Взять потолок невозможно";
		 before_Smell = "Не могу допрыгнуть, чтобы понюхать.";
		 before_Taste = "Не дотянусь.";
		 before_Touch = "Увы, не дотянусь.";
	  }:attr "scenery",
   };
}

door {
	  -"люк";
   nam = "room4_hatch";
   when_locked = "В полу виден закрытый люк.";
   when_open = "В полу находится открытый люк.";
   with_key = "bonekey";
   door_to = function(s)
	  if here() ^ "room4_kladovka" then
		 -- Горафу надо сказать, что сюда нужно вписнуть комнату как в d_to кладовки
		 return "room5_podval"
	  else
		 return "room4_kladovka"
	  end
   end;
   found_in = {
	  "room4_kladovka",
	  -- Горафу надо сказать, что сюда нужно вписнуть комнату как в d_to кладовки
--	  "room5_podval",
   };
   after_Unlock = function(s)
     remove('bonekey');
     mp.score=mp.score+1;
     p "Ты отпираешь люк вниз, избавляясь от костяного ключа.";
   end;
}:attr "openable,lockable,locked,static"

function mermaid_sing()
   local songs = {
	  [[Юные девы в царстве подводном^
	    Живут наслаждаясь, не зная забот.^
		Песни поют о народе свободном.^
		В тёмных глубинах ведут хоровод.]],
	  [[Юные девы в царстве подводном^
	    Жемчугом любят себя украшать,^
		Что перламутром богат бесподобным,^
		И под луной может нежно мерцать.]],
	  [[Юные девы из царства подводного^
	    Мужчин завлекают песней любви.^
		Чарами голоса - дара природного,^
		Страсти огонь разжигают в крови.]],
	  [[Юные девы из царства подводного^
	    Губят ночною порой корабли.^
		Из-за желанья познать, неуёмного,^
		Секреты и тайны верхней земли.]],
   }
	song = song + 1
		if song > #songs then
			song = 1
	end
	return "Раздаётся завораживающая песня русалки:^"..songs[song]
end

room {
   nam = "room4_ostrov";
   title = "За зеркалом";
   dsc = function(s)
	  if s:once() then
		 -- Сообщение при первом посещении комнаты
		 -- {#Me/падеж} вписует ГГ в соответствие с pl.word (задаётся в init() в main3.lua)
		 return "Всего лишь мельком я увидела своё отражение в старинном зеркале, и меня завертело, закружило, ослепило... Проморгавшись, я поняла, что оказалась совсем в другом месте."
	  else
		 -- При последующих осмотрах/посещениях
		 return "Маленький остров, представляющий собой цветочную поляну, окружённую водой."
	  end
   end;
   obj = {
	  "room4_mirror",
	  obj {
			-"цветы|розы/но";
		 nam = "room4_flowers";
		 dsc = "Весь остров в цветах.";
		 description = [[Прекрасные алые розы.]];
		 ["before_Take,Tear"] = function(s)
			if not have "room4_flower" then
				take "room4_flower"
				--"сорвать"
				return "{#Me/им} {#word/сорвать,#me,прш} цветок."
			else
				return "Мне не нужен ещё один цветок."
			end
		end;
		before_Give = function(s, w)
			return _"room4_flower".before_Give(_"room4_flower", w)
		end;
	  }: attr "static",
	  obj {
			-"флейта|дудка|дудочка|дуда";
		 nam = "room4_fluet";
		 dsc = "В траве лежит флейта.";
		 description = [[Изящная флейта, искусно вырезанная из слоновой кости.]];
		 -- Следующую строку с комментарием не удаляй. Она добавляет слово "брать" в словарь игры
		 --"брать"
		 Show = function(s, w)
		 	if w ^ "room4_mermaid" then
				return "Русалка смеётся, и делает жест, будто играет на флейте."
			end;
			return false;
		 end;
		 after_Take = "{#Me/им} {#word/брать,#me,нст} флейту.";
		 before_Smell = "Пахнет цветами.";
		 --"хотеть"
		 before_Taste = "{#Me/им} не {#word/хотеть,#me,нст} пробовать флейту на вкус.";
		 before_Touch = "Гладкая и приятная на ощупь.";
		 ["Blow,Use,Play"] = function(s)
			if s:once() then
                           mp.score=mp.score+1
			   enable "room4_mermaid"
			   return "На переливы флейты из воды вынырнула настоящая русалка."
			else
			   return mermaid_sing();
			end
		 end;
	  },
	  obj {
			-"цветок|роза/но";
		 nam = "room4_flower";
		 dsc = false,
		 donated = false,
		 description = "Прекрасная алая роза.";
		 Tear = function(s)
			if have(s) then
--			if s.once then
			   -- Объясняем, что больше одного цветка не нужно или что-то такое
			   return "Мне больше не нужны цветы. Да и жаль рвать такую красоту."
			else
			   take(s)
			   return "Я сорвала цветок."
			end
		 end;
		 Show = function(s, w)
		 	if w ^ "room4_mermaid" then
				return "Русалка радостно кивает, и показывает на свои волосы."
			end;

			return false;
		 end;
		 before_Give = function(s, w)
			if w ^ "room4_mermaid" then
			   if not s.donated then
			          mp.score=mp.score+1
				  s.donated = true
				  place(s, here())
				  take "room4_sapfir"
				  take "room4_rybin"
				  take "room4_izymryd"
				  enable "room4_gems"
				  p "Я даю русалке цветок. Она мило краснеет и забирает розу, тут же украшая ею свои волосы. Взамен она протягивает мне три драгоценных камня: изумруд, сапфир и рубин. Я с благодарностью принимаю их."
			   else
				  return "Русалке больше не нужны цветы."
			   end
			else
			   return "Кому-кому?"
			end
		 end;
	  },
	  -- Тоже моделька для антуражу. См. стены в кладовке :)
	  obj {
			-"небо";
			description = "Ясное синее небо, ни облачка.";
			before_Take = "Взять небо? Как это возможно?";
			before_Smell = "Пахнет ветром и морем.";
			before_Taste = "Не дотянусь.";
			before_Touch = "Жаль, не дотянусь.";
	  }:attr "scenery",
	  obj {
		 -"солнце";
		description = "Яркое солнце, аж глазам больно на него смотреть.";
		before_Take = "Жаль нельзя запихнуть его в карман. Было бы здорово иметь своё карманное солнце.";
		before_Smell = "Отсюда я не могу понять, чем пахнет солнце.";
		before_Taste = "Не дотянусь.";
		before_Touch = "Жаль, не дотянусь.";
	  }:attr "scenery",
	  obj {
			-"земля";
			description = "Земля заросла цветами. Присмотревшись, я замечаю среди кустов роз человеческие кости.";
			before_Take = "Мне не нужен здешний дёрн.";
			before_Smell = "Пахнет цветами и травой.";
			before_Taste = "Не хочу даже пробовать.";
			before_Touch = "Немного влажная, будто не так давно шёл дождь. Или был прилив, мхм...";
	  }:attr "scenery",
	  obj {
			-"трава";
			description = "Земля заросла цветами. Присмотревшись, я замечаю в траве человеческие кости.";
			before_Take = "Мне не нужна трава.";
			before_Smell = "Пахнет цветами и травой.";
			before_Taste = "Не хочу даже пробовать.";
			before_Touch = "Немного влажная, будто не так давно шёл дождь.";
	  }:attr "scenery",
	  obj {
			-"человеческие кости|кости|человеческие останки|останки";
			description = "Множество человеческих костей. Да это могильник!";
			before_Take = "Фу, я не буду к этому прикасаться.";
			before_Smell = "Я не буду это нюхать!";
			before_Taste = "Не хочу даже пробовать.";
			before_Touch = "Ни за что к этому не прикоснусь.";
	  }:attr "scenery",
	  obj {
			-"море|вода ";
			description = "Синее море, абсолютно прозрачное на мелководье. Красота неописуемая.";
			before_Take = "Мне некуда налить воды.";
			before_Smell = "Пахнет свежестью и морскими водорослями.";
			before_Taste = "На вкус вода солёная, ничего особенного, да и жажду этим не утолишь.";
			before_Touch = "Вода ледяная, бррр... Странно, при такой-то жаре.";
	  }:attr "scenery",
	  obj {
			-"рама";
			description = "Бронзовая старинная рама. Украшена фигурками змеи, краба и дельфина.";
			before_Take = "Невозможно оторвать раму от зеркала.";
			before_Smell = "Пахнет металлом.";
			before_Taste = "На вкус, как металл.";
			before_Touch = "Прохладный металл.";
	  }:attr "scenery",
	  obj {
			-"драгоценные камни|камни|драгоценный камень|камень";
			nam = "room4_gems";
		description = function(s)
			if have "room4_izymryd" or have "room4_rybin" or have "room4_sapfir" then
				return "Красивые драгоценные камни, что дала мне русалка."
			else
				return false
			end
		end;
		Show = function(s, w)
			return "Русалка кивает, и показывает пальчиком на висящее в воздухе зеркало."
		end;
		before_Take = "Они уже у меня.";
		before_Smell = "Пахнет красотой.";
		before_Taste = "На вкус, как стекло.";
		before_Touch = "Прохладные с идеальной огранкой.";
	  }:attr "scenery":disable(),
	  obj {
			-"русалка|ресницы|глаза|волосы|грудь";
		 nam = "room4_mermaid";
		 description = "Прекрасная русалка с длинными русыми волосами и большими томными глазами, обрамлёнными длинными пушистыми ресницами. Грудь прикрыта большими раковинами, скрепленными жемчугом. Морская дева по пояс высунулась из воды, и с интересом вас рассматривает.";
		 ["Talk,Listen"] = function(s)
			return [[Я пытаюсь поговорить с русалкой, но в ответ она лишь поёт:^
					ПрОклятое зеркало старого капитана^
					Затягивает всех, смотрящихся в стекло,^
					На остров одинокий средь злого океана,^
					Что стал могилой жуткой однажды для него.^
					Тот капитан - колдун, ловушку душ поставил,^
					Со Смертью заключив ужасный договор^
					За тысячу людей, что в бездну он отправил^
					Воскреснет вновь пират, продолжит свой террор.]];
		 end;
		 life_Give = function(s, w)
			-- Очередная магия метапарсера для генерации фраз
			--"нужен"
			   local things = {
				[[Русалка брезгливо скривила губки. ]],
				[[Русалка недовольно шлёпнула хвостом по воде, обдав меня дождём солёных брызг. ]],
				[[Русалка отрицательно покачала головой. ]],
				}
			local r = rnd(#things)
			return things[r].."Ей не {#word/нужен,#second} {#second}."
		 end;
		 Kiss = "Русалка уклонилась от прикосновений, смущённо хихикнула и погрозила мне пальчиком.";
		 -- Методы возвращают объекты. Так что их можно "стакать" :)
	  }:attr "static,animate":disable(),
   };
}

obj {
	  -"сапфир";
   nam = "room4_sapfir";
   found_in = "emptyroom";
   description = [[Синий полупрозрачный драгоценный камень.]];
   before_Insert = function(s, w)
	  if not w ^ "room4_dolphin" then
		 return "Камень никак не хочет держаться в углублении."
	  end
	  place(s, w)
	  --"вставить"
	    return "{#Me/им} вставляешь сапфир в углубление."
      end;
	Show = function(s, w)
		return "Русалка кивает, и показывает пальчиком на висящее в воздухе зеркало."
	end;
}: attr "scenery"

obj {
	  -"рубин";
   nam = "room4_rybin";
   found_in = "emptyroom";
   description = [[Сияющий красный драгоценный камень.]];
   before_Insert = function(s, w)
	  if not w ^ "room4_crab" then
		 return "Камень слишком большой и не влезает в углубление."
	  end
	  place(s, w)
	  return "{#Me/им} вставляешь рубин в углубление."
   end;
	Show = function(s, w)
		return "Русалка кивает, и показывает пальчиком на висящее в воздухе зеркало."
	end;
}: attr "scenery"

obj {
	  -"изумруд";
   nam = "room4_izymryd";
   found_in = "emptyroom";
   description = [[Зелёный блестящий драгоценный камень.]];
   before_Insert = function(s, w)
	  if not w ^ "room4_frog" then
		 return "Камень не подходит по форме к этому углублению."
	  end
	  place(s, w)
	  return "{#Me/им} вставляешь изумруд в углубление."
   end;
	Show = function(s, w)
		return "Русалка кивает, и показывает пальчиком на висящее в воздухе зеркало."
	end;
}: attr "scenery"

obj {
   -- Уточнение /но сообщает парсеру, что дельфин у нас неодушевлённый
	  -"отверстие в фигурке дельфина/но|углубление в фигурке дельфин/но|дельфин/но";
   nam = "room4_dolphin";
   description = function(s)
	if where "room4_sapfir" ^ "room4_dolphin" then
		return "Бронзовая фигурка дельфина с переливающимся сапфиром во лбу."
	else
		return "Бронзовая фигурка дельфина с маленьким углублением во лбу."
	end
   end;
   -- При передаче объекта в объект у объекта-приёмника вызываются методы *_Recieve
   before_LetIn = function(s, w)
	  --"подходит"
	  return "{#Second/им} не {#word/подходит,#second} по форме."
   end;
}:attr "static,container,transparent"

obj {
	  -"отверстие в фигурке краба/но|углубление в фигурке краба/но|краб/но|углубление/но";
   nam = "room4_crab";
   description = function(s)
	if where "room4_rybin" ^ "room4_crab" then
		return "Бронзовая фигурка краба с сияющим рубином в середине панцыря."
	else
		return "Бронзовая фигурка краба с маленьким углублением в середине панцыря."
	end
   end;
   before_LetIn = function(s, w)
	  --"подходит"
	  return "{#Second/им} не {#word/подходит,#second} по форме."
   end;
}:attr "static,container,transparent"

obj {
	  -"отверстие в фигурке змеи/но|углубление в фигурке змеи/но|змея/но";
   nam = "room4_frog";
   description = function(s)
	if where "room4_izymryd" ^ "room4_frog" then
		return "Бронзовая змея, с похожим на каплю блестящего яда, изумрудом во рту."
	else
		return "Бронзовая змея с маленьким углублением во рту."
	end
   end;
   before_LetIn = function(s, w)
	  --"подходит"
	  return "{#Second/им} не {#word/подходит,#second} по форме."
   end;
}:attr "static,container,transparent"
--
--
--

obj {
	  -"костяной ключ,ключ";
   nam = "bonekey";
   description = "Костяной ключ.";
	found_in = { 'room14_box1' };
        score=false;
        after_Take = function(s)
          if not s.score then
            mp.score=mp.score+1;
          end;
          _'bonekey'.score=true;
          return false;
        end;
}

game.hint_verbs = { "#Exam", "#Walk", "#Take", "#Drop" }
