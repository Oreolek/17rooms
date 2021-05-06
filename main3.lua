--$Name:17 комнат$
require "parser/mp-ru"
require "fmt"
-- mp.errhints = false
game.dsc = false

function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

if file_exists('autotheme.lua') then
  require "autotheme"
end

local i = 1
while (i <= 17) do
  local f = 'room'..i
  if file_exists(f..'.lua') then
    include(f)
  end
  i = i + 1
end

mp.undo = 20
mp.score = 0 -- enable scoring
mp.maxscore = 47 -- enable scoring
--mp.detailed_inv = true
instead.notitle = false -- enable status
--instead.get_title = 3

mp.autohelp_limit=1
mp.compl_thresh=5
mp.togglehelp=false
mp.autocompl=false

room {
	nam = 'emptyroom';
	title = "Пустая комната";
	dsc = [[Это не ваша комната, её создаст другой автор.]];
	noparser = true;
}

function init()
	pl.word = -"ты/жр,2л"
	pl.room = 'intro_cutscene'
	pl.capacity = 100
 pl.description = "Ты умница и красавица в полном расцвете лет, и выглядишь, как и всегда, отлично. А зовут тебя Настя."	
end

if pl.test == nil then
  pl.test = function()
  end
end

cutscene {
	nam = 'intro_cutscene';
	text = {
		[[Ты очень любила тётю Агату, и будучи в Петербурге, собиралась её навестить. Однако тётка как сквозь землю провалилась - не отвечала ни на SMS, ни в Ватсапе, а телефон её был вне зоны доступа. Так что, недолго думая, ты решила наведаться в её поместье на окраине города.
		^^Впрочем, стоит рассказать читателю, кто такая тётя Агата, о которой ты так беспокоилась. Овдовев, и унаследовав огромное состояние, эта экцентричная женщина принялась коллекционировать в своём особняке различные древности, интересные вещи, изобретения, да и просто хлам (по крайней мере по твоему мнению), пытаясь раскрыть не то тайны масонов, не то древних культов, не то тайного мирового правительства... Словом дома у неё могло найтись что угодно.
		^^]]..fmt.b("17 комнат")..fmt.em("^Чтобы узнать подробнее об игре или авторах, введите ИНФО или АВТОРЫ.");
	};
	next_to = 'room1_kryltco'
}


Verb {
   "#RedCode",
   "красное море, сказать красное море",
   "RedCode"
}

mp.msg.RedCode = {}
function mp:RedCode()
    if here().nam == 'room11_kabinet' then
	  p(mp.msg.RedCode.RedCodeHint)
    else
          p(mp.msg.RedCode.RedCode)
    end
end
--"может"
mp.msg.RedCode.RedCode = "Ты говоришь \"КРАСНОЕ МОРЕ\". В комнате ничего не произошло. Может нужно сказать эти слова кому-то? Или чему-то?"
mp.msg.RedCode.RedCodeHint = "Ты говоришь \"КРАСНОЕ МОРЕ\". Ничего не происходит, но ты чувствуешь, что на верном пути. Возможно нужно сказать эти слова кому-то или чему-то конкретно в этой комнате?"


Verb {
   "#Xyzzy",
   "xyzzy",
   "Xyzzy"
}

mp.msg.Xyzzy = {}
function mp:Xyzzy()       
  p(mp.msg.Xyzzy.Xyzzy);
end
mp.msg.Xyzzy.Xyzzy = "Ты помнишь, что тётка упоминала это слово, но как она его использовала, ты не знаешь."


Verb {
   "#Score",
   "счёт,счет",
   "Score"
}

mp.msg.Score = {}
function mp:Score()       
  p("Ты набрала "..mp.score.." очков из "..mp.maxscore.." возможных.");
end

Verb {
   "#Authors",
   "автор, авторы",
   "Authors"
}

mp.msg.Authors = {}
function mp:Authors()       
  p( 		"Авторы: Khaelenmore, techniX, Enola, Артур Айвазян, yandexx, Cheshire, gloomy, qwerty, Irremann, Ajenta, Librarian Oak, Zlobot, Антон Ласточкин, blinovvi, "..fmt.st("crem")..[[, spline1986, Oreolek, Антон Артамонов, goraph
		^^Тестирование: Khaelenmore, techniX, Enola, Артур Айвазян, yandexx, Cheshire, gloomy, qwerty, Irremann, Ajenta, Librarian Oak, Zlobot, Антон Ласточкин, blinovvi, spline1986, Oreolek, Антон Артамонов, goraph, Гога, Yorodzuyi, Алик Гаджимурадов
		^^Спасибо Райану Видеру за то что когда-то он придумал Cragne Manor, technix за то что он подбросил нам идею написать коллективный парсер, Петру Косых за метапарсер и практически ежедневную техническую поддержку участников на протяжении всего этого марофона, spline1986 за прекрасную тему игры, форуму ifiction.ru и отдельно Олегусу, а также дискорд чату ifrus, дискорд и телеграмм каналам INSTEAD, и чату Мануций, Inc. за информационную поддержку.]]);

end

Verb {
   "#Info",
   "инфо, информация, аннотация, предисловие",
   "Info"
}

mp.msg.Info = {}
function mp:Info()       
  p("Основной идеей игры было написание коллективного русскоязычного парсера, где каждый автор писал свою комнату не зная что делают остальные. В связи с этим игроку рекомендуется относится к каждой комнате как к отдельной мини-игре, с несколько отличающимися правилами и соглашениями. Хотя у всей игры в целом есть свой общий метасюжет, который логически завершен и, позволим себе надеяться, непротиворечив.");
end

Verb {
   "#Cry",
   "заплакать, плакать, плачь, заплачь, сесть и заплакать, сесть и плакать, сядь и плачь, сядь и заплачь, обнять и заплакать, обнять и плакать, обними и плачь, обними и заплачь, плакаться, сесть и плакаться, обнять и плакаться, расплакаться, сесть и расплакаться, обнять и расплакаться, поплакаться, сесть и поплакаться, обнять и поплакаться, заплакаться, сесть и заплакаться, обнять и заплакаться",
   "Cry"
}

mp.msg.Cry = {}
function mp:Cry()       
  p("Что, совсем ничего не получается? Ты поплакала. Стало легче?");
end

