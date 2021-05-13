require "snapshots"
mp.auto_animate = false

global {
  list_clothing = std.list {};
}

game : dict {
  ["блузка/рд"] = 'блузки';
  ["блузка/вн"] = 'блузку';
  ["блуза/вн"] = 'блузу';
  ["блуза/рд"] = 'блузы';
  ["оторочка/рд"] = 'оторочки';
  ["оторочка/вн"] = 'оторочку';
  ["труселя/рд"] = 'труселей';
  ["труселя/вн"] = 'труселя';
  ["штаны/вн"] = 'штаны';
  ["термоштаны/вн"] = 'термоштаны';
  ["штаны/рд"] = 'штанов';
  ["термоштаны/рд"] = 'термоштанов';
  ["леггинсы/рд"] = 'леггинсов';
  ["легинсы/рд"] = 'легинсов';
  ["леггинсы/вн"] = 'леггинсы';
  ["легинсы/вн"] = 'легинсы';
  ["твидовый/рд"] = 'твидового';
  ["твидовый/вн"] = 'твидовый';
}

-- Синонимы из Cloak of Darkness. Не знаю почему это не стандарт.
Verb {
  '#PutOn8',
  'повес/ить',
  '~ {noun}/вн,held на {noun}/вн,2,scene: PutOn',
  '~ на {noun}/вн,2,scene {noun}/вн,held: PutOn reverse',
  '~ {noun}/вн,held в {noun}/вн,2,scene: Insert',
}
Verb {
  '#PutOn8_2',
  'остав/ить',
  '~ {noun}/вн,held на {noun}/пр,2,scene: PutOn',
}

-- Доступное пространство имён для объектов - все имена объектов должны начинаться с "room8_" или "garderob_" 
-- Все описания можно менять
-- Задача: Игрок должен получить доступ на запад с помощью предмета thooskey. Изначально он должен быть закрыт. Игрок может придти в комнату как с этим предметом, так и без него

function room8_switch_temperature(temp, forced)
  local oldtemp = _('room8_garderob')._mode
  -- TODO: очень тяжёлый цикл, надо как-то оптимизировать
  list_clothing:for_each(function(v)
    if (forced and v:where() ~= nil and v:where().nam == 'room8_control') then
      return
    end
    if (
      v.mode ~= nil
      and v:where() ~= nil
      and v:where().nam ~= 'emptyroom'
    ) then
      local newobject = nil
      if temp == 'hot' and v.paired_hot ~= nil then
        newobject = _(v.paired_hot)
      end
      if temp == 'cold' and v.paired_cold ~= nil then
        newobject = _(v.paired_cold)
      end
      if temp == 'neutral' and v.paired_neutral ~= nil then
        newobject = _(v.paired_neutral)
      end
      if newobject ~= nil then
        -- dprint('Меняем местами '..v.nam ..' и '..newobject.nam)
        move(newobject, v:where());
        if (v:has('worn')) then
          newobject:attr('worn')
        else
          newobject:attr('~worn')
        end
        -- ЭТА СТРОКА ТРЕБУЕТ КОМНАТУ emptyroom В ФИНАЛЬНОЙ ИГРЕ
        move(v, _('emptyroom'));
      end
    end
  end)
  _('room8_garderob')._mode = temp
  if temp == 'cold' then
    return 'В комнате становится холодно. Мороз захватывает вещи и выворачивает их. Твоя одежда покрывается мехом. Гардероб готов к зиме.'
  end
  if temp == 'hot' then
    return 'В комнате становится жарко. Жара берёт каждую вещь и выжимает её для того, чтобы подготовить гардероб к летнему дню.'
  end
  if temp == 'neutral' then
    return 'Комната возвращается в свою скучную неопределённо тёплую атмосферу.'
  end
end

room {
	nam = "room8_garderob";
	title = "Гардеробная комната";
	dsc = function(s)
    if s:once() then
      snapshots:write('entersroom');
    end
    local description = '';
    if s.hot() then
      description = [[Жарко. ]];
    end
    local clothes = ''
    if _('room8_lock').obj[1] ~= nil then
      clothes = clothes .. 'На замке двери висит '.._('room8_lock').obj[1]:noun('им')..'.';
    end
    if _('room8_control').obj[2] ~= nil then
      clothes = clothes .. 'На рычаге висит '.._('room8_control').obj[2]:noun('им')..'.';
    end
    return description..[[
      Ты стоишь в маленьком повороте прихожей, между шкафом с одеждой и пустой стеной, украшенной ярким плакатом. Рядом с плакатом находится серый рычаг с фигурной рукояткой. Комната продолжает прихожую (на западе) и упирается в дверь гаража (на востоке). Возле стены стоит пьедестал с надписью «Машина времени».
    ]]..clothes;
  end;
	e_to = function()
    if _('room8_garagedoor'):has('locked') then
      p 'Дверь закрыта на электронный замок.';
      return;
    end;
    return 'room9_garazh';
  end;
	w_to = 'room3_hall';
  _mode = 'neutral';
  hot = function()
    return here()._mode == 'hot'
  end;
  cold = function()
    return here()._mode == 'cold'
  end;
  temperature = function(temp)
    if (temp ~= 'hot' and temp ~= 'cold' and temp ~= 'neutral') then
      return
    end
    return room8_switch_temperature(temp, false)
  end;
	before_Listen = function(s)
    if s.cold() then
      return "Здесь тихо, и ты слышишь только своё замерзающее дыхание.";
    elseif s.hot() then
      return "Быстро разогретые крючки шкафа тихо шипят. Молчание.";
    else
      return "Тишина.";
    end
  end;
	before_Smell = " не пахнет.";
}

obj {
  -"вешалка|вешалки/мн";
	nam = "room8_hanger";
  found_in = 'room8_clothes';
  description = 'Здесь нет вешалок, одежда висит на крючках.';
}: attr 'concealed,static';

obj {
  -"рукоятка,рукоятка рычага/жр,но|монстр/мн,од";
  nam = 'room8_control_end';
  found_in = 'room8_control';
  description = 'Изогнутый декоративный крюк на конце рычага изображает язык милого монстра. За эту рукоятку удобно хвататься.';
  before_Receive = 'Рукоятка это часть рычага. Нужно вешать вещи на рычаг.'
}: attr 'concealed,static,~animate';

obj {
  -"единорог/мр,од|единороги/мр,од,мн|фигура/жр,но|фигуры/мн,жр,но";
  nam = 'room8_clothes_details';
  found_in = 'room8_garderob';
  description = 'Сцены из жизни какой-то девушки с мечом, которая захватывает волшебную страну единорогов, находит там какого-то пучеглазого монстра и уезжает с ним в большой дом, который подозрительно напоминает дом твоей тёти. Хм.';
}: attr 'concealed,static';

obj {
	-"рычаг,кондиционер";
	nam = "room8_control";
  found_in = 'room8_garderob';
	description = function(self)
    local r = 'Это тяжёлый вертикальный рычаг с рукояткой в виде изогнутого крюка'
    if here().cold() then
      r = r .. ', который поднят в сторону надписи "ШЕРСТЬ". Его можно '..fmt.b('толкнуть')..' вниз, в нейтральное положение.'
    elseif here().hot() then
      r = r .. ', который опущен в сторону надписи "ПЕСОК". Его можно '..fmt.b('потянуть')..' вверх, в нейтральное положение.'
    else
      r = r .. ', который выставлен между надписей "ШЕРСТЬ" и "ПЕСОК". Его можно '..fmt.b('потянуть')..' вверх или '..fmt.b('толкнуть')..' вниз.'
    end
    pn(r)
    if self.obj[2] ~= nil then
      pn ('На рычаге висит '..self.obj[2]:noun('им')..'.')
    end;
    return true
  end;
  after_Receive = function(self, thing)
    local weight = 0
    if thing.weight ~= nil then
      weight = thing.weight
    end
    if weight == 0 then
      return ('Рычаг, конечно, не рассчитан на одежду, но '..thing:noun('им')..' для него — не проблема.');
    end
    if weight == 1 then
      return ('Рычаг издаёт короткий скрип, но в остальном не замечает, что на нём висит '..thing:noun('им')..'.');
    end
    if weight == 2 then
      return ('Рычаг скрипит, но выдерживает вес '..thing:noun('рд')..'.');
    end
    if weight > 2 then
      return 'Рычаг со скрипом падает под тяжестью одежды в нижнее положение. '..room8_switch_temperature('hot', true)
    end
  end;
  before_Pull = function(self)
    if here().hot() and self.obj[2] ~= nil and self.obj[2].weight ~= nil and self.obj[2].weight > 2 then
      return 'Тяжёлая одежда на рычаге не даёт поднять его.'
    end;
    if here().cold() then
      return 'Это крайнее положение.'
    end
    if here().hot() then
      return here().temperature('neutral')
    end
    return here().temperature('cold')
  end;
  before_Push = function()
    if here().hot() then
      return 'Это крайнее положение.'
    end
    if here().cold() then
      return here().temperature('neutral')
    end;
    return here().temperature('hot')
  end;
  capacity = 2;
}: attr 'static,supporter,scenery';

obj {
  -"дверь";
  nam = 'room8_garagedoor';
  found_in = 'room8_garderob';
  with_key = 'thooskey';
  after_Unlock = function(s)
    _('thooskey'):disable();
    mp.score=mp.score+1;
    return 'Ключ застревает в замке, но дверь всё-таки открывается.';
  end;
  description = function(s)
    if s:has('locked') then
      return "Закрытая дверь, на которой мигает электронный замок.";
    end
    return "Дверь в гараж, распахнутая настежь. Можно идти на запад.";
  end;
  when_open = 'Дверь в гараж открыта.';
}: attr 'scenery,openable,lockable,locked';

obj {
  -"замок,электронный замок";
  nam = 'room8_lock';
  before_Burn = function(self, thing)
    if not (thing ^ 'matches' or thing ^ 'kitchen_lighter' or thing ^ 'kerosin' or thing ^ 'lamp') then
      return 'Во-первых, '..thing:noun('им')..' ты не подожжёшь. Во-вторых, пожар скорее сожжёт весь дом, чем замок на этой двери.';
    end
    return 'Стальной корпус от этого не разогреется, а костёр скорее сожжёт дом, чем отдельный электронный замок. Плохая идея.';
  end;
  before_Unlock = function(self, thing)
    return 'Жаль, но электронный замок не открывается '..thing:noun('тв')..'. Хотя в двери ты замечаешь замочную скважину. Попробуй отпереть саму дверь.';
  end;
  found_in = 'room8_garderob';
  before_Attack = 'Антивандальная защита замка состоит в том, что у него нет отверстий, а стальной корпус нельзя пробить.';
  before_Touch = function(s)
    if here().hot() then
      return "Замок обжигающе горяч на ощупь.";
    elseif here().cold() then
      return "Осторожно, так и примёрзнуть пальцем можно. Он же ледяной.";
    end;
    return "Металл как металл.";
  end;
  capacity = 1;
  after_Receive = function(self, thing)
    local is_boiling = here().hot() and thing.mode == 'cold';
    if is_boiling then
      pn ('Из-под '..thing:noun('рд')..' доносится резкий писк, затем что-то начинает шипеть и ты видишь струйку дыма. Дверь распахивается настежь.');
      _('room8_garagedoor'):attr('open');
      _('room8_garagedoor'):attr('~locked');
      if not self:has('broken') then
        mp.score=mp.score+1;
      end;
      self:attr('broken')
      return true;
    end;
    return false;
  end;
  description = function(s)
    local description = 'Электронный замок со стальным корпусом и гордой наклейкой «Модель "Невзломайка" с антивандальной защитой. Проверено в режиме от минус сорока до сорока градусов.» Это маленькая коробка с двумя лампочками.';
    if s:has('broken') then
      description = description .. ' Внутри замка что-то перегрелось и расплавилось. Он безнадёжно сломан.'
    else
      description = description .. ' Сейчас горит красная лампочка с надписью "Требуется ключ-карта".';
      if here().hot() then
        description = description .. " Воздух вокруг замка заметно нагрет, а лампочка немного мигает.";
      elseif here().cold() then
        description = description .. " Наклейка покрылась коркой льда.";
      end;
    end
    pn(description);
    return false;
  end;
}: attr 'scenery,supporter,transparent';

clothing = Class {
  check_inventory = function(level, nam, part)
    local c = nil; -- одежда того же уровня
    local j = nil; -- одежда более высокого уровня
		me():inventory():for_each(function(v)
      if not v:has('clothing') then
        return
      end
      if not v:has('worn') then
        return
      end
      local newlevel = v.getlevel(v)
      local newpart = v.getpart(v)
      if (
        newlevel == level
        and v.nam ~= nam
        and newpart == part
      ) then
        c = v
      elseif newlevel > level and newpart == part then
        j = v
        level = newlevel
      end
    end)
    return {c, j, level};
  end;

  getlevel = function(self)
    if self == nil then
      dprint('В функцию getlevel передан null')
      return 0
    end
    local level = self.level;
    if level == nil then
      level = 0
    end;
    return level;
  end;

  getpart = function(self)
    if self == nil then
      dprint('В функцию getlevel передан null')
      return 0
    end
    local part = self.part;
    if part == nil then
      part = 'top';
    end;
    return part;
  end;


  each_turn = function(s)
    if here().nam == 'room8_garderob' or not have(s) or not s:has('worn') then
      s:attr'~concealed'
    else
      s:attr'concealed'
    end
  end;

  before_Any = function(s)
    if here().nam == 'room14_secondfloor' then
      return "Это не то место, где тебе это понадобится.";
    else
      return false;
    end
  end;


  -- Проверка надевания: нельзя надеть майку на шубу
  -- Проверка снятия: нельзя снять майку перед шубой
  ['before_Wear,Disrobe'] = function(self)
    local level = self.getlevel(self);
    local part = self.getpart(self)
    local retval = self.check_inventory(level, self.nam, part);
    local c = retval[1];
    local j = retval[2];
    level = retval[3];

    if (j ~= nil) then
      return 'Сначала нужно снять '..j:noun('вн')..'.';
    end;

    if (mp.event == 'Wear' and c ~= nil) then
      return 'Ты не можешь одновременно носить '..c:noun('вн') .. ' и '..self:noun('вн')..'.';
    end


  if (mp.event == 'Disrobe') then
    if here().nam == 'room8_garderob' then
     return false;
    else
     return 'Ну не здесь же!';
    end;
  end;


    return false;
  end;
}: attr 'clothing';

-- Да, ты можешь писать "открыть крючок" потому что это синоним шкафа.
-- Но то, что крючки не смоделированы, должно намекать на их несущественность.
obj {
  -"шкаф,гардероб/мр,но|крючки/мн,но|крючок/мр,но|одежда/жр,но";
  nam = 'room8_clothes';
  before_Receive = function(self, thing)
    if not thing:has('clothing') then
      return 'Это — шкаф только для одежды.';
    end;
    return false;
  end;
  after_Receive = function(self, thing)
    return('Ты находишь свободный крючок и вешаешь '..thing:noun('вн')..' в шкаф.');
  end;
  found_in = 'room8_garderob';
  description = function(self)
    local dsc = 'Старинный платяной шкаф с резными фигурами на дверцах.';
    if self:has 'open' and #self.obj > 3 then
      dsc = dsc .. ' Плотно забит одеждой.';
    end
    pn(dsc);
    return false;
  end;
}: attr 'container,openable,static,scenery';

--[[
не участвуют в системе одежды, невозможно снять: туфли, нижнее бельё
level = 0: шарф, головной платок
level = 1: штаны
level = 2: рубашка, майка
level = 3: пиджак, куртка
level = 4: шуба
--]]

clothing {
  -"синяя кепка,кепка/жр,но";
  nam = 'room8_cap';
  level = 0;
  part = 'head';
  mode = 'neutral';
  paired_hot = 'room8_baseballcap';
  paired_cold = 'room8_ushanka';
  description = 'Старая синяя кепка с греческой буквой «альфа».';
}

clothing {
  -"чёрная ушанка,ушанка/жр,но";
  nam = 'room8_ushanka';
  part = 'head';
  level = 0;
  weight = 0;
  mode = 'cold';
  paired_hot = 'room8_baseballcap';
  paired_neutral = 'room8_cap';
  description = 'Чёрная тёплая ушанка с жёлтым геральдическим львом на лбу.';
}

-- я не знаю почему но auto_animate считает ЭТО живым
clothing {
  -"белая бейсболка,бейсболка/жр,но";
  nam = 'room8_baseballcap';
  part = 'head';
  level = 0;
  mode = 'hot';
  paired_neutral = 'room8_cap';
  paired_cold = 'room8_ushanka';
  description = 'Новенькая белая бейсболка.';
}: dict {
  ['бейсболка/вн'] = 'бейсболку';
  ['белая бейсболка/вн'] = 'белую бейсболку';
  ['бейсболка/дт'] = 'бейсболке';
  ['белая бейсболка/дт'] = 'белой бейсболке';
}: attr '~animate';

-- Сюжетная проблема: так как мы моделируем одежду до уровней,
-- героиня должна быть во что-то одета изначально.
-- Придётся давать ей вещи в самом начале игры.
clothing {
  -"бра/ср|бюстгальтер,лифчик/мр";
  nam = 'room8_underwear_top';
  description = 'Твоё нижнее бельё.';
  part = 'top';
  before_Disrobe = function()
    return 'Да ни за что.';
  end;
  each_turn = function(s) end
}: attr 'worn,concealed';

clothing {
  -"трусы,трусики,труселя/ср,мч|белье,бельё/ср";
  nam = 'room8_underwear_bottom';
  part = 'bottom';
  description = 'Твоё нижнее бельё.';
  before_Disrobe = function()
    return 'Да ни за что.';
  end;
  each_turn = function(s) end
}: attr 'worn,concealed';

clothing {
  -"туфли/жр,мч|туфля/жр";
  nam = 'room8_shoes';
  part = 'feet';
  description = 'Чёрные блестящие туфли на каблуке.';
  before_Disrobe = function()
    return 'Да ни за что.';
  end;
  each_turn = function(s) end
}: attr 'worn,concealed';

clothing {
  -"штаны/ср,мч,мн";
  nam = 'room8_pants';
  part = 'bottom';
  mode = 'neutral';
  description = 'Чёрные формальные штаны.';
  paired_hot = 'room8_shorts';
  paired_cold = 'room8_winterpants';
  level = 1;
}: attr 'worn';

clothing {
  -"шорты/ср,мч,мн";
  nam = 'room8_shorts';
  part = 'bottom';
  mode = 'hot';
  paired_neutral = 'room8_pants';
  paired_cold = 'room8_winterpants';
  description = 'Короткие серые шорты.';
  level = 1;
}

clothing {
  -"зимние штаны,штаны,щтаны/ср,мч,мн";
  nam = 'room8_winterpants';
  part = 'bottom';
  mode = 'cold';
  paired_neutral = 'room8_pants';
  paired_hot = 'room8_shorts';
  weight = 3;
  description = 'Зимние утеплённые штаны. Очень тяжёлые.';
  level = 1;
}

clothing {
  -"белая блузка,блузка,белая блуза,блуза/жр";
  nam = 'room8_blouse';
  part = 'top';
  description = 'Белая блузка с принтом картины Малевича на груди.';
  mode = 'neutral';
  level = 2;
  weight = 1;
  paired_cold = 'room8_winterblouse';
  paired_hot = 'room8_shortblouse';
}: attr 'worn';

clothing {
  -"вязаная блуза,шерстяная блуза,блуза/жр";
  nam = 'room8_winterblouse';
  part = 'top';
  description = 'Белая вязаная блузка.';
  mode = 'cold';
  paired_neutral = 'room8_blouse';
  paired_hot = 'room8_shortblouse';
  level = 2;
  weight = 2;
}

clothing {
  -"блузка,мини-блузка,мини-блуза,блуза/жр";
  nam = 'room8_shortblouse';
  part = 'top';
  description = 'Белая мини-блузка. Может быть, даже мини-мини.';
  mode = 'hot';
  paired_neutral = 'room8_blouse';
  paired_cold = 'room8_winterblouse';
  level = 2;
  weight = 1;
}

clothing {
  -"жилет/мр";
  nam = 'room8_formalvest';
  description = 'Чёрный короткий жилет.';
  level = 3;
  weight = 1;
  part = 'top';
  mode = 'hot';
  paired_neutral = 'room8_formalcoat';
  paired_cold = 'room8_winter_formalсoat';
}

clothing {
  -"твидовый пиджак,пиджак/мр,но";
  nam = 'room8_winter_formalсoat';
  description = 'Чёрный твидовый пиджак. Очень тёплый.';
  level = 3;
  weight = 1;
  part = 'top';
  mode = 'cold';
  paired_neutral = 'room8_formalcoat';
  paired_hot = 'room8_formalvest';
}

clothing {
  -"чёрный пиджак,черный пиджак,пиджак/мр,но";
  nam = 'room8_formalcoat';
  paired_hot = 'room8_formalvest';
  paired_cold = 'room8_winter_formalсoat';
  description = 'Чёрный женский пиджак. Выглядит очень профессионально.';
  level = 3;
  weight = 2;
  part = 'top';
  mode = 'neutral';
}: attr 'worn';
take('room8_underwear_bottom');
take('room8_shoes');
take('room8_pants');
take('room8_blouse');
take('room8_formalcoat');
take('room8_underwear_top');

clothing {
  -"леггинсы,легинсы/ср,мн";
  nam = 'room8_leggins';
  part = 'bottom';
  level = 1;
  mode = 'hot';
  paired_cold = 'room8_thermo';
  paired_neutral = 'room8_sport';
  description = 'Белые спортивные леггинсы из быстро сохнущей ткани.';
}

clothing {
  -"спортивные штаны,спортивки/ср,мн";
  nam = 'room8_sport';
  part = 'bottom';
  level = 1;
  mode = 'neutral';
  found_in = 'room8_clothes';
  paired_hot = 'room8_leggins';
  paired_cold = 'room8_thermo';
  description = 'Спортивные облегающие штаны с полосками.';
}


clothing {
  -"термоштаны/ср,мн";
  nam = 'room8_thermo';
  part = 'bottom';
  level = 1;
  mode = 'cold';
  paired_hot = 'room8_leggins';
  paired_neutral = 'room8_sport';
  description = 'Белые тёплые леггинсы для очень холодной погоды.';
}

clothing {
  -"халат/мр";
  nam = 'room8_robe';
  level = 2;
  weight = 2;
  part = 'top';
  mode = 'cold';
  paired_neutral = 'room8_tshirt';
  paired_hot = 'room8_sportshirt';
  description = 'Махровый тёплый клетчатый халат, в котором всегда тепло и мягко.';
}

clothing {
  -"майка/жр";
  nam = 'room8_tshirt';
  part = 'top';
  mode = 'neutral';
  level = 1;
  paired_cold = 'room8_robe';
  paired_hot = 'room8_sportshirt';
  description = 'Лёгкая белая майка, на спине нарисованы крестики-нолики.';
}

clothing {
  -"футболка/жр";
  nam = 'room8_sportshirt';
  mode = 'hot';
  part = 'top';
  level = 1;
  paired_cold = 'room8_robe';
  paired_neutral = 'room8_tshirt';
  description = 'Спортивная полосатая футболка с короткими рукавами. На спине нарисован номер 7.';
}

clothing {
  -"шуба/жр|мутон/мр";
  nam = 'room8_wintercoat';
  part = 'top';
  level = 4;
  weight = 3;
  mode = 'cold';
  paired_hot = 'room8_overcoat';
  paired_neutral = 'room8_raincoat';
  description = 'Меховая мутоновая шуба. Не совсем подходящая одежда для отапливаемых помещений. У меха какой-то странный зелёный оттенок.';
}

clothing {
  -"дождевик/мр";
  nam = 'room8_raincoat';
  part = 'top';
  paired_cold = 'room8_wintercoat';
  paired_hot = 'room8_overcoat';
  found_in = 'room8_clothes';
  level = 4;
  weight = 2;
  mode = 'neutral';
  description = 'Яркий синий непромокаемый дождевик.';
}

clothing {
  -"накидка/мр";
  nam = 'room8_overcoat';
  part = 'top';
  paired_cold = 'room8_wintercoat';
  paired_neutral = 'room8_raincoat';
  level = 4;
  weight = 0;
  mode = 'hot';
  description = 'Лёгкая цветная полупрозрачная накидка.';
}

clothing {
  -"тёплая рубашка/жр,но";
  nam = 'room8_warmshirt';
  part = 'top';
  level = 2;
  mode = 'cold';
  paired_hot = 'room8_lightwear';
  paired_neutral = 'room8_shirt';
  description = 'Утеплённая салатовая рубашка с длинными рукавами.';
}

clothing {
  -"рубашка/жр";
  nam = 'room8_shirt';
  part = 'top';
  level = 2;
  found_in = 'room8_clothes';
  paired_hot = 'room8_lightwear';
  paired_cold = 'room8_warmshirt';
  mode = 'neutral';
  description = 'Женская салатовая рубашка с длинными рукавами.';
}

clothing {
  -"лёгкая рубашка,рубашка/жр,но";
  nam = 'room8_lightwear';
  part = 'top';
  level = 2;
  mode = 'hot';
  paired_cold = 'room8_warmshirt';
  paired_neutral = 'room8_shirt';
  description = "Чёрная рубашка с длинными рукавами с большими дырами для вентиляции. Очень большими дырами.";
}

clothing {
  -"шарф/мр";
  nam = 'room8_winterscarf';
  part = 'head';
  level = 0;
  mode = 'cold';
  paired_neutral = 'room8_shawl';
  paired_hot = 'room8_kerchief';
  description = 'Шерстяной клетчатый шарф с надписью «ЭНИГМА».'
}

clothing {
  -"шаль/жр";
  nam = 'room8_shawl';
  found_in = 'room8_clothes';
  part = 'head';
  level = 0;
  weight = 1;
  mode = 'neutral';
  paired_cold = 'room8_winterscarf';
  paired_hot = 'room8_kerchief';
  description = 'Клетчатая шаль с витыми узорами по краям.';
}

clothing {
  -"платок/мр";
  nam = 'room8_kerchief';
  part = 'head';
  level = 0;
  mode = 'hot';
  paired_cold = 'room8_winterscarf';
  paired_neutral = 'room8_shawl';
  description = 'Лёгкий прозрачный платок для головы.';
}

clothing {
  -"майка-свитер, майка, свитер/мр";
  nam = 'room8_sweatershirt';
  part = 'top';
  weight = 2;
  level = 3;
  mode = 'hot';
  paired_cold = 'room8_duckdown_jacket';
  paired_neutral = 'room8_puffyvest';
  description = 'Синяя майка, стилизованная под свитер. На ней даже напечатаны ниточки.';
}

clothing {
  -"тёплый жилет,жилет/мр";
  nam = 'room8_puffyvest';
  part = 'top';
  weight = 2;
  level = 3;
  mode = 'neutral';
  paired_cold = 'room8_duckdown_jacket';
  paired_hot = 'room8_sweatershirt';
  description = 'Синий пуховой жилет с короткими рукавами.';
}

clothing {
  -"пуховик/мр";
  nam = 'room8_duckdown_jacket';
  part = 'top';
  weight = 3;
  level = 3;
  paired_hot = 'room8_sweatershirt';
  paired_neutral = 'room8_puffyvest';
  mode = 'cold';
  description = 'Синий длинный пуховик для сорокаградусных морозов. В нём ты будешь выглядеть синим колобком. А если найти поясок, то колбаской.'
}

obj {
  -"машина времени,машина/жр,но|пьедестал,переключатель/мр,но|кнопка/жр,но";
  nam = 'room8_timemachine';
  found_in = 'room8_garderob';
  description = 'Маленький пьедестал с надписью «Машина времени однонаправленная». На пьедестале находится переключатель, который указывает на положение «ВЫКЛ».';
  after_SwitchOn = function()
    pn "Реальность немного расплывается… а затем собирается воедино.";
    -- Метапарсер для команды UNDO занимает дефолтный слот снапшотов,
    -- так что нам надо использовать свой слот
    snapshots:restore('entersroom');
  end;
  after_Push = function()
    pn "Реальность немного расплывается… а затем собирается воедино.";
    snapshots:restore('entersroom');
  end;
}: attr 'switchable,static,scenery';

obj {
  -"плакат,постер,комикс/мр,но";
  nam = 'room8_poster';
  found_in = 'room8_garderob';
  description = [[
    Цветной комикс: человек заходит в магазин одежды.^
    — Я ищу что-нибудь, что кричало бы «Тяжёлый металл!»^
    — Мы положили в каждый карман вот этого пуховика по гантеле. Надевать для примерки будете?
  ]];
}: attr 'static,scenery';

obj {
  -"прихожая/жр,но|поворот/ср,но";
  nam = 'room8_out_e';
  found_in = 'room8_garderob';
  description = 'Отсюда видна часть прихожей.';
}: attr 'static,concealed';

obj {
  -"карман/мр,но|карманы/мн,мр,но";
  nam = 'room8_out_pockets';
  description = 'Карманы пусты, в них нет ничего интересного.';
}: attr 'static,concealed';
take('room8_out_pockets');

obj {
  -"стены/мн,жр,но|обои/мн,ср,но|стена/жр,но";
  nam = 'room8_out_wallsw';
  found_in = 'room8_garderob';
  description = 'Обычные стены с бежевыми обоями. На одной из стен висит постер.';
}: attr 'scenery,~animate';

obj {
  -"пол,линолеум/мр,но";
  nam = 'room8_out_floor';
  found_in = 'room8_garderob';
  description = 'Непримечательный тёмно-коричневый линолеум.';
}: attr 'scenery,~animate';

obj {
  -"потолок/мр,но";
  nam = 'room8_out_ceiling';
  found_in = 'room8_garderob';
  description = 'Белый натяжной потолок со встроенными светильниками.';
}: attr 'scenery,~animate';

obj {
  -"светильник/мр,но|светильники/мр,мн,но|лампочка/жр,но|лампочки/мн,жр,но";
  nam = 'room8_out_ceilinglight';
  found_in = 'room8_garderob';
  description = 'Обычные лампочки в потолке освещают комнату мягким белым светом.';
}: attr 'scenery,~animate,light';

clothing {
  -"юбка/жр";
  nam = 'room8_skirt';
  part = 'bottom';
  weight = 1;
  level = 1;
  found_in = 'room8_clothes';
  mode = 'neutral';
  description = 'Красная длинная юбка в зелёный горошек.';
  paired_hot = 'room8_miniskirt';
  paired_cold = 'room8_coldskirt';
}

clothing {
  -"миниюбка,мини-юбка,юбка,мини/жр";
  nam = 'room8_miniskirt';
  part = 'bottom';
  weight = 0;
  paired_neutral = 'room8_skirt';
  paired_cold = 'room8_coldskirt';
  level = 1;
  mode = 'hot';
  description = 'Красная мини-юбка с зелёными полосами по бокам.'
}: dict {
  ['миниюбка/рд'] = 'миниюбки';
  ['миниюбка/вн'] = 'миниюбку';
  ['мини-юбка/рд'] = 'мини-юбки';
  ['мини-юбка/вн'] = 'мини-юбку';
  ['мини/вн'] = 'мини';
  ['мини/рд'] = 'мини';
}

clothing {
  -"вязаная юбка,юбка/жр";
  nam = 'room8_coldskirt';
  part = 'bottom';
  weight = 2;
  paired_neutral = 'room8_skirt';
  paired_hot = 'room8_miniskirt';
  level = 1;
  mode = 'cold';
  description = 'Длинная вязаная бордовая юбка с фигурной вышивкой по краям.';
}

clothing {
  -"парадное платье,платье/жр";
  nam = 'room8_parade_dress';
  part = 'top';
  description = 'Это огромное бордовое парадное платье с рюшами, несколькими внутренними юбками и длинным шлейфом.';
  mode = 'neutral';
  found_in = 'room8_clothes';
  paired_hot = 'room8_eveningdress';
  paired_cold = 'room8_colddress';
  level = 2;
  -- подлянка для игрока: платье достаточно тяжёлое, чтобы его перенести в тёплый режим, но там оно бесполезно
  weight = 3;
}

clothing {
  -"вечернее платье,платье/жр";
  nam = 'room8_eveningdress';
  part = 'top';
  description = 'Длинное синее вечернее платье из лёгко проветриваемой ткани.';
  mode = 'hot';
  paired_neutral = 'room8_parade_dress';
  paired_cold = 'room8_colddress';
  level = 2;
  weight = 1;
}

clothing {
  -"тёплое платье,меховое платье,платье,оторочка/жр";
  nam = 'room8_colddress';
  part = 'top';
  description = 'Это красное вечернее утеплённое платье с меховой оторочкой.';
  mode = 'cold';
  paired_neutral = 'room8_parade_dress';
  paired_hot = 'room8_eveningdress';
  level = 2;
  weight = 1;
}

clothing {
  -"куртка/жр";
  nam = 'room8_jacket';
  found_in = 'room8_clothes';
  part = 'top';
  level = 3;
  mode = 'neutral';
  paired_cold = 'room8_hoody';
  paired_hot = 'room8_top';
  description = 'Кожаная куртка с нашивкой «ПИНГВИН». Хороша в пасмурный день.';
}

clothing {
  -"топ,верх/мр";
  nam = 'room8_top';
  part = 'top';
  level = 1;
  mode = 'hot';
  paired_neutral = 'room8_jacket';
  paired_cold = 'room8_hoody';
  description = 'Белый спортивный верх (топ) из быстро сохнущей ткани.';
}

clothing {
  -"толстовка/жр";
  nam = 'room8_hoody';
  part = 'top';
  level = 3;
  paired_neutral = 'room8_jacket';
  paired_hot = 'room8_top';
  mode = 'cold';
  description = 'Серая спортивная толстовка с длинными рукавами.';
}

std.for_each_obj(function(v)
  if (v.check_inventory ~= nil and v.getlevel ~= nil) then
    list_clothing:add(v)
  end
end)
