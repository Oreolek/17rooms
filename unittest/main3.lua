--$Name: Юнит-тест$
--$Version: 1.0$
--$Author:Александр Яковлев$

std.SOURCES_DIRS = { '..', '../parser' }
global 'GAMEDIR' ('..')

dofile '../main3.lua'
local i = 1
while (i <= 17) do
  include('../room'..i)
  i = i + 1
end
instead.noautosave = true

local lester = require 'lester'
local describe, it, expect = lester.describe, lester.it, lester.expect

function parse(text)
  return mp:parse(text)
end

function expect.attr(value, attribute)
  return value:has(attribute) ~= nil,
    'expected ' .. value.nam .. ' to be ' .. attribute,
    'expected ' .. value.nam .. ' to not be ' .. attribute
end

pl.test = function()
  rununittest(pl);
  rundebug(pl);
end;

rundebug = function(s)
  local all_levels = {};
  all_levels['nil'] = {};

  -- проверяем пары
  list_clothing:for_each(function(v)
    if v.paired_hot ~= nil or v.paired_cold ~= nil or v.paired_neutral ~= nil then
      expect.exist(v.mode)
      expect.attr(v, 'clothing')
    end
    if v.mode ~= nil then
      if v.level ~= nil and all_levels[v.level] == nil then
        all_levels[v.level] = {};
      end
      if v.level == nil then
        table.insert(all_levels['nil'], v.nam)
      else
        table.insert(all_levels[v.level], v.nam)
      end
      local mode = v.mode
      local back = 'paired_'..mode;
      if v.paired_hot == nil and v.paired_cold == nil and v.paired_neutral == nil then
        dprint(v.nam..' не меняется при превращениях')
      end
      -- Проверяем что все превращения обратимы
      if v.paired_hot ~= nil then
        local w = _(v.paired_hot)
        expect.exist(w)
        expect.equal(std.call(w, back), v.nam)
        if v.paired_cold == nil and mode ~= 'cold' then
          dprint(v.nam..' не имеет холодного аналога')
        end
        if v.paired_neutral == nil and mode ~= 'neutral' then
          dprint(v.nam..' не имеет нейтрального аналога')
        end
      end;
      if v.paired_cold ~= nil then
        local w = _(v.paired_cold)
        expect.exist(w)
        expect.equal(std.call(w, back), v.nam)
        if v.paired_hot == nil and mode ~= 'hot' then
          dprint(v.nam..' не имеет горячего аналога')
        end
        if v.paired_neutral == nil and mode ~= 'neutral' then
          dprint(v.nam..' не имеет нейтрального аналога')
        end
      end;
      if v.paired_neutral ~= nil then
        local w = _(v.paired_neutral)
        expect.exist(w)
        expect.equal(std.call(w, back), v.nam)
        if v.paired_hot == nil and mode ~= 'hot' then
          dprint(v.nam..' не имеет горячего аналога')
        end
        if v.paired_cold == nil and mode ~= 'cold' then
          dprint(v.nam..' не имеет холодного аналога')
        end
      end;
    end;
  end);

  for l, c in pairs(all_levels) do
    local length = #c
    dprint('Уровень '..l..' - '..length..' объектов: ')
    for i, a in pairs(c) do
      local weight = '';
      local b = _(a)
      if b.weight ~= nil and b.weight > 0 then
        weight = ' ('..b.weight..')'
      end
      dprint('\t'..a..weight)
    end
  end
end

rununittest = function(s)
  describe('игра', function()
    lester.before(function()
      expect.exist(std.game)
      expect.exist(std.game.__started)
    end)

    describe('room8 - одежда', function()
      lester.before(function()
        pl.move('room8_garderob');
      end);

      it('превращение', function()
        expect.attr(_('room8_clothes'), '~open')
        parse('открыть шкаф');
        expect.attr(_('room8_clothes'), 'open')
        expect.exist(here():srch('room8_shirt'))
        expect.not_exist(here():srch('room8_wintercoat'))
        expect.not_exist(here():srch('room8_lightwear'))
        expect.equal(here()._mode, 'neutral')
        parse('снять штаны')
        -- без учёта частей тела ответом будет "Сначала нужно снять пиджак"
        expect.attr(_('room8_formalcoat'), 'worn')
        expect.attr(_('room8_pants'), '~worn')
        parse('тянуть рычаг')
        expect.equal(here()._mode, 'cold')
        expect.not_exist(here():srch('room8_shirt'))
        expect.exist(here():srch('room8_wintercoat'))
        expect.not_exist(here():srch('room8_lightwear'))
        parse('тянуть рычаг')
        expect.equal(here()._mode, 'cold')
        expect.not_exist(here():srch('room8_shirt'))
        expect.exist(here():srch('room8_wintercoat'))
        expect.not_exist(here():srch('room8_lightwear'))
        parse('толкать рычаг')
        expect.equal(here()._mode, 'neutral')
        expect.exist(here():srch('room8_shirt'))
        expect.not_exist(here():srch('room8_wintercoat'))
        expect.not_exist(here():srch('room8_lightwear'))
        parse('толкать рычаг')
        expect.equal(here()._mode, 'hot')
        expect.not_exist(here():srch('room8_shirt'))
        expect.not_exist(here():srch('room8_wintercoat'))
        expect.exist(here():srch('room8_lightwear'))
        parse('надеть авоську')
        expect.not_exist(me():srch('room8_shirt'))
        expect.not_exist(me():srch('room8_wintercoat'))
        expect.not_exist(me():srch('room8_lightwear'))
        expect.exist(me():srch('room8_formalvest'))
        expect.attr(_('room8_formalvest'), 'worn')
        parse('снять жилет')
        expect.not_exist(me():srch('room8_shirt'))
        expect.not_exist(me():srch('room8_wintercoat'))
        expect.attr(_('room8_formalvest'), '~worn')
        parse('снять мини-блузку')
        expect.attr(_('room8_formalcoat'), '~worn')
        expect.attr(_('room8_blouse'), '~worn')
        parse('надеть авоську')
        expect.not_exist(me():srch('room8_shirt'))
        expect.not_exist(me():srch('room8_wintercoat'))
        expect.exist(me():srch('room8_lightwear'))
        expect.attr(_('room8_lightwear'), 'worn')
        parse('тянуть рычаг')
        expect.equal(here()._mode, 'neutral')
        expect.exist(me():srch('room8_shirt'))
        expect.not_exist(here():srch('room8_lightwear'))
        expect.not_exist(here():srch('room8_wintercoat'))
        expect.attr(_('room8_shirt'), 'worn')
        parse('снять рубашку')
        expect.exist(me():srch('room8_shirt'))
        parse('бросить рубашку')
        expect.not_exist(me():srch('room8_shirt'))
        expect.not_exist(me():srch('room8_wintercoat'))
        expect.not_exist(me():srch('room8_lightwear'))
        expect.equal(here()._mode, 'neutral')
        expect.exist(here():srch('room8_shirt'))
        expect.not_exist(here():srch('room8_lightwear'))
        expect.not_exist(here():srch('room8_wintercoat'))

        expect.attr(_('room8_cap'), '~animate')
        expect.attr(_('room8_baseballcap'), '~animate')
        expect.falsy(mp:animate(_('room8_baseballcap')))
        expect.equal(#_('room8_lock').obj, 0)
        put('room8_cap', 'room8_lock');
        parse('толкать рычаг');
        expect.exist(_('room8_lock'):srch('room8_baseballcap'))
        parse('взять бейсболку');
        expect.exist(me():srch('room8_baseballcap'))
      end);

      it('room8 - прохождение', function()
        room8_switch_temperature('cold');
        take('room8_wintercoat')
        parse('положить шубу на рычаг');
        expect.equal(here()._mode, 'hot')
        expect.exist(_('room8_control'):srch('room8_wintercoat'))

        -- проверяем что рычаг нельзя тянуть пока на нём шуба
        parse('тянуть рычаг');
        expect.equal(here()._mode, 'hot')

        expect.equal(#_('room8_lock').obj, 0)
        take('room8_wintercoat')
        expect.exist(me():srch('room8_wintercoat'))
        parse('положить шубу на замок')
        expect.equal(here()._mode, 'hot')
        expect.exist(here():srch('room8_lock'))
        expect.exist(here():srch('room8_garagedoor'))
        expect.attr(_('room8_garagedoor'), 'open')
        expect.attr(_('room8_garagedoor'), '~locked')
        move('room8_wintercoat', 'emptyroom');
      end);
    end);
  end);
end;
