-- Доступное пространство имён для объектов - все имена объектов должны начинаться с "room9_" или "garazh_" 
-- Все описания можно менять
-- Задача: Игрок должен найти в локации предмет kerosin

room {
	nam = "room9_room9_nil";
}


obj {
	-"рука";
	nam = "room9_no_рука";
        description = "";
        before_Exam = function(s)
          if here().room9_var == 4 then p [[В тиски зажата грубо отпиленная рука.]]; here().room9_var = 5; 
          else p [[В тиски зажата грубо отпиленная рука.]]; end;
        end;
        found_in = 'room9_room9_nil'; 
        before_Take = function(s)
          p [[Тебе не нужна ещё одна рука, у тебя уже есть две.]]
       end;
}:attr 'scenery'

obj {
	-"нога";
	nam = "room9_no_нога";
        description = "";
        before_Exam = function(s)
          if here().room9_var == 6 then p [[В тиски зажата грубо отпиленная нога.]]; here().room9_var = 7; 
          else p [[В тиски зажата грубо отпиленная нога.]]; end;
        end;
        found_in = 'room9_room9_nil'; 
        before_Take = function(s)
          p [[Тебе не нужна ещё одна нога, у тебя уже есть две.]]
       end;
}:attr 'scenery'

obj {
	-"гвоздь | метка";
       nam = "room9_no_гвоздь";
       description = "";
       found_in = 'room9_room9_nil'; 
       before_Exam = function(s)
          if here().room9_var == 10 then p [[В твой хобот вбит меченый гвоздь.]];
          else p [[На гвоздь нанесена метка инспектора По, что, впрочем, не имеет значения.]]; end;
       end;
       before_Take = function(s)
          if here().room9_var == 10
          then
            mp.score=mp.score+1;
            p [[Ты с трудом вытащила большой гвоздь из хобота. Хобот сдулся, посерел и рассыпался в пыль.]]
            move("room9_no_хобот", "room9_room9_nil")
            here().room9_var = 11
          end;
          return false;
       end;
}

obj {
	-"хобот";
	nam = "room9_no_хобот";
        description = "";
        found_in = 'room9_room9_nil'; 
        before_Exam = function(s)
          if here().room9_var == 10 then p [[Хобот небрежно прибит к полу большим гвоздём.]];
          else p [[Слонячий такой хобот.]]; end;
        end;
        before_Take = function(s)
          if here().room9_var < 10
          then
            p [[Ты двумя руками стащила хобот с верстака. Внезапно в гараж ворвался инспектор По и вонзил в твой хобот меченый гвоздь. Теперь хобот прибит к полу.]]
            move("room9_no_гвоздь", "room9_garazh")
            move("room9_no_инспектор", "room9_garazh")
            here().room9_var = 10
          else 
            p [[Ты не можешь взять хобот, потому что он прибит к полу большим гвоздём.]]
          end;
       end;
}


-- люк заперт на замок; замок можно открыть гвоздём, при этом гвоздь теряется
-- не настоящий подвал, а всего-лишь небольшая ямка
--в ямке - пальцы мертвеца(это такой гриб) и керосин



obj {
	-"инспектор | По | гость";
	nam = "room9_no_инспектор";
        description = "Инспектор По - он внезапный и пугающий гость, он вонзил в твой хобот меченый гвоздь!";
        found_in = 'room9_room9_nil'; 
}:attr 'scenery'

----------------------------------------
-----------------------


room {
	nam = "room9_garazh";
	title = "Гараж";
	dsc = "На западе - гардероб.";
	w_to = function()
	  if have('room9_o1') then
	    p "Не думаю что тебе понадобиться всё. Лучше оставить всё в гараже.";
	    return;
          end;
          if here().room9_var < 10 then
            p [[Ты вышла из этого жуткого гаража в гардеробную комнату.]];
          else 
            move("room9_no_гвоздь", "room9_garazh")
            p [[Инспектор закричал: "Ты можешь идти куда хочешь, но мой гвоздь останется здесь!"]];
          end;
          move(pl,'room8_garderob');
        end;

        e_to = function()
          if here().room9_var < 3
            then p [[Прежде чем идти, хорошо бы всё осмотреть.]];
            else 
              p [[Возможно, ты сходишь с ума, но тебе кажется, что в гараже что-то изменилось. ]];
          end
          if here().room9_var == 3
            then here().room9_var = 4 -- ничего взято, всё осмотрено, появилась рука
            move("room9_no_рука", "room9_garazh")
          end;
          if here().room9_var == 5
            then here().room9_var = 6 -- ничего взято, всё осмотрено, появилась нога
            move("room9_no_нога", "room9_garazh")
            move("room9_no_рука", "room9_room9_nil")
          end;
          if here().room9_var == 7
            then here().room9_var = 8 -- ничего взято, всё осмотрено, появился хобот
            move("room9_no_хобот", "room9_garazh")
            move("room9_no_нога", "room9_room9_nil")
          end;
        end;

        n_to = function()
          if here().room9_var < 3
            then p [[Прежде чем идти, хорошо бы всё осмотреть.]];
            else 
              p [[Возможно, ты сходишь с ума, но тебе кажется, что в гараже что-то изменилось. ]];
          end
          if here().room9_var == 3
            then here().room9_var = 4 -- ничего взято, всё осмотрено, появилась рука
            move("room9_no_рука", "room9_garazh")
          end;
          if here().room9_var == 5
            then here().room9_var = 6 -- ничего взято, всё осмотрено, появилась нога
            move("room9_no_нога", "room9_garazh")
            move("room9_no_рука", "room9_room9_nil")
          end;
          if here().room9_var == 7
            then here().room9_var = 8 -- ничего взято, всё осмотрено, появился хобот
            move("room9_no_хобот", "room9_garazh")
            move("room9_no_нога", "room9_room9_nil")
          end;
        end;

        s_to = function()
          if here().room9_var < 3
            then p [[Прежде чем идти, хорошо бы всё осмотреть.]];
            else 
              p [[Возможно, ты сходишь с ума, но тебе кажется, что в гараже что-то изменилось. ]];
          end
          if here().room9_var == 3
            then here().room9_var = 4 -- ничего взято, всё осмотрено, появилась рука
            move("room9_no_рука", "room9_garazh")
          end;
          if here().room9_var == 5
            then here().room9_var = 6 -- ничего взято, всё осмотрено, появилась нога
            move("room9_no_нога", "room9_garazh")
            move("room9_no_рука", "room9_room9_nil")
          end;
          if here().room9_var == 7
            then here().room9_var = 8 -- ничего взято, всё осмотрено, появился хобот
            move("room9_no_хобот", "room9_garazh")
            move("room9_no_нога", "room9_room9_nil")
          end;
        end;

	before_Listen = "Ты слышишь гулкий ритмичный звук - то ли это живые мертвецы стучат, то ли это стук твоего сердца.";
	before_Smell = "Дело пахнет керосином.";
	obj = { 'room9_o1', 'room9_o2'};
        room9_var = 1; -- ничего не взято; всё не осмотрено; и тыды
}

-- объекты для взаимодействия:

obj  {
	-"всё";
	nam = "room9_o1";
        description = '';
        before_Exam = function(s)
          if here().room9_var == 1
            then p [[Прежде, чем всё осмотреть, подумай - тебе ничего не мешает?]];
            else p [[Как ты можешь видеть, в этом гараже всё есть. И есть даже выходы на все четыре стороны, хоть ты их и не видишь.]];
          end;
          if here().room9_var == 2
            then here().room9_var = 3 -- ничего взято, всё осмотрено
          end;
          return false;
        end;
}

obj  {
	-"ничего";
	nam = "room9_o2";
	description = "Здесь ничего, а так же странный звук и странный запах. Очень странное ничего.";
        after_Take = function(s)
          here().room9_var = 2 -- ничего взято
          move("room9_no_помеха", "room9_room9_nil")
          move(s, "room9_room9_nil")
          return false
       end;
}

-- объекты сцены:


obj {
	-"дело";
	nam = "room9_no_дело";
        description = "Всё что тебе нужно здесь, это керосин.";
        found_in = 'room9_garazh'; 
}:attr 'scenery'

obj {
	-"помеха | препятствие";
	nam = "room9_no_помеха";
        description = "Да вроде, ничего не мешает. Или, всё же, мешает?";
        found_in = 'room9_garazh'; 
}:attr 'scenery'


obj {
	-"бензопила, рисунок";
	nam = "room9_no_бензопила";
        description = "На северной стене ты видишь искусно нарисованную бензопилу. Увы, это всего-лишь рисунок на стене.";
        found_in = 'room9_garazh'; 
}:attr 'scenery'

obj  {
	-"верстак, стол";
	nam = "room9_no_верстак";
	description = "";
        after_Exam = function(s)
          if here().room9_var < 4 or here().room9_var > 9 then p [[Верстак - это просто деревянный рабочий стол, с закреплёнными на нём стальными тисками.]];
          else p [[Верстак - это просто деревянный рабочий стол, с закреплёнными на нём стальными тисками. В тисках что-то есть.]] end;
          return false;
        end;
        found_in = 'room9_garazh'; 
}:attr 'scenery'

obj {
	-"гараж, стену| стены";
	nam = "room9_no_гараж";
        description = "Старый пыльный гараж. На севере - бензопила, на юге - книги, на востоке - верстак, в полу - люк, на западе - выход.";
        found_in = 'room9_garazh'; 
}:attr 'scenery'

obj  {
	-"звук | стук | ритм | смех | хохот";
	nam = "room9_no_звук";
	description = "Осмотреть звук? Оригинально.";
        found_in = 'room9_garazh'; 
}:attr 'scenery'

obj  {
	-"запах";
	nam = "room9_no_запах";
	description = "Осмотреть запах? Оригинально.";
        found_in = 'room9_garazh'; 
}:attr 'scenery'

obj {
	-"книга|книги";
	nam = "room9_no_книга";
        description = 'Пыльный шкаф с книгами расположился у южной стены.';
        before_Take = function(s)
          p [[Не успела ты прикоснуться к книгам, как они разлетелись по гаражу, а на стене шкафа стала видна грубо выцарапанная надпись: "МЫ ДО ТЕБЯ ДОБЕРЁМСЯ!" - и раньше, чем ты успела хотя бы моргнуть, книги вернулись обратно в шкаф.]]
       end;
        found_in = 'room9_garazh'; 
}:attr 'scenery'

obj {
	-"мертвец | мертвецы";
	nam = "room9_no_мертвец";
        description = 'Зловещие мертвецы могут внезапно напасть в любой момент. Но прямо сейчас ты их не видишь.';
        found_in = 'room9_garazh'; 
}:attr 'scenery'

obj {
	-"надпись";
	nam = "room9_no_надпись";
        description = 'Сейчас надпись не видна за книгами.';
        found_in = 'room9_garazh'; 
}:attr 'scenery'

obj  {
	-"пол";
	nam = "room9_no_пол";
	description = "Пол гаража покрыт странными бурыми пятнами и глубокими царапинами. В полу есть люк.";
        found_in = 'room9_garazh'; 
}:attr 'scenery'

obj  {
	-"пыль | пятна | царапины | пятно | царапина";
	nam = "room9_no_пыль";
	description = "Повсюду подозрительные пятна, странные царапины и та самая зловещая пыль, которая скапливается там, куда не заглядывают живые люди.";
        found_in = 'room9_garazh'; 
}:attr 'scenery'

obj  {
	-"сердце, внутренности";
	nam = "room9_no_сердце";
	description = "Твоё сердце часто бьётся, но, к счастью, оно всё ещё внутри и осмотреть его не получится.";
        found_in = 'room9_garazh'; 
}:attr 'scenery'

obj  {
	-"тиски";
	nam = "room9_no_тиски";
	description = "";
        after_Exam = function(s)
          if here().room9_var < 4 then p [[На верстаке закреплены стальные тиски.]]; end
          if here().room9_var == 5 then p [[В стальных тисках зажата отпиленная рука.]]; end
          if here().room9_var == 4 then p [[В стальных тисках зажата отпиленная рука.]]; here().room9_var = 5; end
          if here().room9_var == 7 then p [[В стальных тисках зажата отпиленная нога.]]; end
          if here().room9_var == 6 then p [[В стальных тисках зажата отпиленная нога.]]; here().room9_var = 7; end
          if here().room9_var == 9 then p [[В тисках зажат хобот.]]; end
          if here().room9_var == 8 then p [[В тисках зажат хобот.]]; here().room9_var = 9; end
          if here().room9_var > 9 then p [[На верстаке закреплены стальные тиски.]]; end
          return false;
        end;
        found_in = 'room9_garazh'; 
}:attr 'scenery'

obj {
	-"шкаф";
	nam = "room9_no_шкаф";
        description = "У южной стены находится старый пыльный шкаф с книгами.";
        found_in = 'room9_garazh'; 
}:attr 'scenery'

obj {
	-"гриб | грибы | палец | пальцы | колония";
	nam = "room9_no_гриб";
        dsc = "Пальцы мертвеца тянутся к тебе из подпола.";
        description = "Под полом разрослась колония грибов Пальцы Мертвеца.";
        found_in = 'room9_no_люк'; 
        before_Take = function(s)
          p [[Эти грибы тебе без надобности.]]
	end
}

-----------------------------------------

-- люк, подвал, подпол, погреб

obj {
	-"замок | люк | цепь | цепи | ямка | яма | подвал | подпол | погреб";
	nam = "room9_no_люк";
	score = false;
        when_closed = function()
          if here().room9_var < 12 then p[[В деревянном полу гаража находится деревянный люк в погреб. Сейчас люк скован цепями и заперт на висячий замок. Возможно, подвал не пуст: в нём могут копошиться зловещие мертвецы.]]
          else p[[В деревянном полу гаража находится деревянный люк в погреб. Сейчас люк неплотно прикрыт. Возможно, подвал не пуст: в нём могут копошиться зловещие мертвецы.]] 
          end;
        end;
        after_Unlock = function(s, w)
          here().room9_var = 12;
          if not s.score then
            mp.score=mp.score+1;
          end;
          _'room9_no_люк'.score=true;
          p[[Ты отперла замок гвоздём и сняла цепи с люка.]];          
        end;
        when_open = "Замок отперт, цепи сброшены, люк открыт. Под люком оказалась небольшая ямка, в которой видны Пальцы Мертвеца.";
        with_key = "room9_no_гвоздь";
        found_in = 'room9_garazh'; 
}:attr 'static, container, openable, lockable, closed, locked'


obj {
	-"стороны | выходы";
	nam = "room9_no_стороны";
        description = "Четыре стороны - это север, запад, юг и восток. Гардероб - на западе.";
        found_in = 'room9_garazh'; 
}:attr 'scenery'

obj {
	-"гардероб";
	nam = "room9_no_гардероб";
        description = "Гардероб - на западе.";
        found_in = 'room9_garazh'; 
}:attr 'scenery'


-- Менять нельзя!!!! Это не ваш предмет!!! Вы не знаете как он выглядит, его придумает другой автор!!!

obj {
	-"керосин|бутылочка";
	nam = "kerosin";
	description = "Керосин для лампы. На бутылочке так и написано.";
        found_in = 'room9_no_люк'; 
        before_Drink = "Ты не станешь это пить!";
        before_Smell = "Пахнет керосином.";
        before_Read = "\"Керосин для лампы.\" - написано на бутылочке.";
        before_Burn = "Лучше не надо, ничем хорошим это не закончится.";
        score=false;
        after_Take = function(s)
          if not s.score then
            mp.score=mp.score+1;
          end;
          _'kerosin'.score=true;
          return false;
        end;
}

