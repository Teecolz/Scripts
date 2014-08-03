if myHero.charName ~= "Nocturne" then return end

local version = 1.0
local AUTOUPDATE = true


local SCRIPT_NAME = "tNocturne"
local SOURCELIB_URL = "https://raw.github.com/TheRealSource/public/master/common/SourceLib.lua"
local SOURCELIB_PATH = LIB_PATH.."SourceLib.lua"
if FileExist(SOURCELIB_PATH) then
  require("SourceLib")
else
  DOWNLOADING_SOURCELIB = true
  DownloadFile(SOURCELIB_URL, SOURCELIB_PATH, function() print("Required libraries downloaded successfully, please reload") end)
end

if DOWNLOADING_SOURCELIB then print("Downloading required libraries, please wait...") return end

if AUTOUPDATE then
  SourceUpdater(SCRIPT_NAME, version, "raw.github.com", "/teecolz/Scripts/master/"..SCRIPT_NAME..".lua", SCRIPT_PATH .. GetCurrentEnv().FILE_NAME, "/teecolz/Scripts/master/"..SCRIPT_NAME..".version"):CheckUpdate()
end

local RequireI = Require("SourceLib")
RequireI:Add("vPrediction", "https://raw.github.com/Hellsing/BoL/master/common/VPrediction.lua")
RequireI:Add("SOW", "https://raw.github.com/Hellsing/BoL/master/common/SOW.lua")
RequireI:Add("Prodiction", "https://bitbucket.org/Klokje/public-klokjes-bol-scripts/raw/ec830facccefb3b52212dba5696c08697c3c2854/Test/Prodiction/Prodiction.lua")

RequireI:Check()

if RequireI.downloadNeeded == true then return end

require 'SOW'
require 'VPrediction'
require 'Prodiction'
-------------------------------------------------
-------------------------------------------------

local menu
local ts
local levelSequence = {1,2,3,1,1,4,1,3,1,3,4,3,3,2,2,4,2,2}
local target
local Prodict
local ProdictQ

local Qready, Wready, Eready, Rready = false


-------------------------------------------------
-------------------------------------------------
--[OnLoad]--
function OnLoad()
  VP    = VPrediction()
  iSOW  = SOW(VP)
  Variables()
  Init()
  Menu()
  PrintChat("<font color=\"#78CCDB\"><b>" ..">> tNocturne has been loaded")
  Loaded = true
  
  EnemyMinions = minionManager(MINION_ENEMY, Qrange, myHero, MINION_SORT_MAXHEALTH_DEC)
  jungleMinions = minionManager(MINION_JUNGLE, Qrange, myHero, MINION_SORT_MAXHEALTH_DEC)
  
    if VIP_USER then
        Prodict = ProdictManager.GetInstance()
        ProdictQ = Prodict:AddProdictionObject(_Q, Qrange, Qspeed, Qdelay, Qwidth)
    end
end

function Variables()

  AARange = 125

  Qrange = 1125
  Qwidth = 60 
  Qspeed = 1600
  Qdelay = 0.5

  Wrange = nil
  Wwidth = nil 
  Wspeed = 500
  Wdelay = 0.5

  Erange = 500
  Ewidth = nil 
  Espeed = nil 
  Edelay = 0.5

  Rrange = 2000
  Rwidth = nil 
  Rspeed = 500 
  Rdelay = 0.5
end

function Init()
    ts = TargetSelector(TARGET_LESS_CAST, Qrange, DAMAGE_PHYSICAL)
  end
  
function Menu()  
        menu = scriptConfig("tNocturne: Main Menu", "tNocturne")

          menu:addSubMenu("tNocturne: Combo", "combo")
            menu.combo:addParam("combokey", "Combo",    SCRIPT_PARAM_ONKEYDOWN, false, 32)
            menu.combo:addParam("useQ", "Use Q-Spell",  SCRIPT_PARAM_ONOFF, true)
            menu.combo:addParam("useE", "Use E-Spell",  SCRIPT_PARAM_ONOFF, true)

          menu:addSubMenu("tNocturne: Harass", "harass")
            menu.harass:addParam("harasskey", "Harass", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
            menu.harass:addParam("useQ", "Use Q-Spell", SCRIPT_PARAM_ONOFF, true)
            menu.harass:addParam("mana", "Dont Harass if mana < %", SCRIPT_PARAM_SLICE, 0, 0, 100)
            
          menu:addSubMenu("tNocturne: Lane Clear", "lane")
            menu.lane:addParam("lanekey", "Lane Clear", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("Z"))
            menu.lane:addParam("useQ", "Use Q-Spell", SCRIPT_PARAM_ONOFF, true)
            menu.lane:addParam("useE", "Use E-Spell", SCRIPT_PARAM_ONOFF, false)
            
          menu:addSubMenu("tNocturne: Jungle Clear", "jungle")
            menu.jungle:addParam("junglekey", "Jungle Clear", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("Z"))
            menu.jungle:addParam("useQ", "Use Q-Spell", SCRIPT_PARAM_ONOFF, true)
            menu.jungle:addParam("useE", "Use E-Spell", SCRIPT_PARAM_ONOFF, false)

          menu:addSubMenu("tNocturne: Killsteal", "killsteal")
            menu.killsteal:addParam("killstealQ", "Use Q-Spell to Killsteal", SCRIPT_PARAM_ONOFF, true)
            
          menu:addSubMenu("tNocturne: Drawings", "draw")
            menu.draw:addParam("drawAA", "Draw AA Range", SCRIPT_PARAM_ONOFF, false)
            menu.draw:addParam("drawQ", "Draw Q Range",   SCRIPT_PARAM_ONOFF, true)
            menu.draw:addParam("drawE", "Draw E Range",   SCRIPT_PARAM_ONOFF, true)
            menu.draw:addParam("drawR", "Draw R Range",   SCRIPT_PARAM_ONOFF, true)

          menu:addSubMenu("tNocturne: Extras", "extra")
            menu.extra:addParam("autolevel", "AutoLevel Spells", SCRIPT_PARAM_ONOFF, false)
            menu.extra:addParam("autoE", "Auto E them under Turrets", SCRIPT_PARAM_ONOFF, false)
            
         menu:addSubMenu("tNocturne: SOW", "SOWorb")
            iSOW:LoadToMenu(menu.SOWorb)
            
          menu:addSubMenu("tNocturne: Target Selector", "targetSelector")
            menu.targetSelector:addTS(ts)
              ts.name = "Focus"

      menu.combo:permaShow("combokey")
end

-------------------------------------------------
-------------------------------------------------
--[OnTick]--
function OnTick()
  if myHero.dead then return end
  if Loaded then
    ts:update()
  end
  spell_check()
  if menu.extra.autolevel then
    autoLevelSetSequence(levelSequence)
  end
  EnemyMinions:update()
  jungleMinions:update()
  iSOW:EnableAttacks()
  target = ts.target

  if menu.combo.combokey then
    Combo()
  end
  if menu.extra.autoE then
    TurretStun()
  end
  if menu.harass.harasskey then
    Harass()
  end
  if menu.lane.lanekey then
    LaneClear()
  end
  if menu.jungle.junglekey then
    JungleClear()
  end
  
  if menu.killsteal.killstealQ then
    killsteal()
  end

end

function spell_check()
  
  Qready = (myHero:CanUseSpell(_Q) == READY)
  Wready = (myHero:CanUseSpell(_W) == READY)
  Eready = (myHero:CanUseSpell(_E) == READY)
  Rready = (myHero:CanUseSpell(_R) == READY)

end
-------------------------------------------------
-------------------------------------------------
--[Combo]--
function Combo()

  if menu.combo.useQ then
    UseQ()
  end
  
  if menu.combo.useE then
    UseE()
  end

end

function UseQ()
  if target and not target.dead then
    if Qready and GetDistanceSqr(target) <= Qrange^2 then
       local pos, info = Prodiction.GetPrediction(target, Qrange, Qspeed, Qdelay, Qwidth)
       if pos and info.hitchance > 1 then
          CastSpell(_Q, pos.x, pos.z)
       end
    end
  end
end

function UseE()
  if target then
    if Eready and GetDistanceSqr(target) <= Erange^2 then
      CastSpell(_E, target)
    end
  end
end

function Harass()

  if menu.harass.useQ and ManaCheck(myHero, menu.harass.mana) == false then
    UseQ()
  end
  
end

function ManaCheck(unit, ManaValue)
  if unit.mana < (unit.maxMana * (ManaValue/100))
    then return true
  else
    return false
  end
end

function killsteal()
  for i, enemy in ipairs (GetEnemyHeroes()) do
    qDmg = getDmg("Q", enemy, myHero)
    local pos, info = Prodiction.GetPrediction(enemy, Qrange, Qspeed, Qdelay, Qwidth)
    if Qready and enemy ~= nil and ValidTarget(enemy, Qrange) and enemy.health < qDmg then
        CastSpell(_Q, pos.x, pos.z)
    end
  end
end

-------------------------------------------------
-------------------------------------------------
--[Tower Stuff]--
function UnitAtTower(unit,offset)
  for i, turret in pairs(GetTurrets()) do
    if turret ~= nil then
      if turret.team == myHero.team then
        if GetDistance(unit, turret) <= turret.range+offset then
          return true
        end
      end
    end
  end
  return false
end

function TurretStun()
  for _, enemy in ipairs(GetEnemyHeroes()) do
    if UnitAtTower(enemy, 0) and GetDistance(enemy) < Erange then
      if enemy ~= nil and Eready then
        CastSpell(_E, enemy)
      end
    end
  end
end

-------------------------------------------------
-------------------------------------------------
--[Clear]--
function LaneClear()
  if jungleMinion == nil then
    for i, minion in pairs(EnemyMinions.objects) do
      if minion ~= nil then
          if Qready and menu.lane.useQ and GetDistance(minion) <= Qrange then
            CastSpell(_Q, minion.x, minion.z)
          end
          if Eready and menu.lane.useE and GetDistance(minion) <= Erange then
            CastSpell(_E, minion)
          end
      end
    end
  end
end


function JungleClear()
  for i, jungleMinion in pairs(jungleMinions.objects) do
    if jungleMinion ~= nil then
        if GetDistance(jungleMinion) <= Qrange then
          if Qready and menu.jungle.useQ then
            CastSpell(_Q, jungleMinion.x, jungleMinion.z)
          end
          if Eready and menu.jungle.useE and GetDistance(jungleMinion) <= Erange then
            CastSpell(_E, jungleMinion)
          end
        end
    end
  end
end
-------------------------------------------------
-------------------------------------------------
--[OnDraw]--
function OnDraw()
  if myHero.dead then return end
  if menu.draw.drawAA then
    DrawCircle(myHero.x, myHero.y, myHero.z, AARange, ARGB(255,100,0,50))
  end
  if menu.draw.drawQ and Qready then
    DrawCircle(myHero.x, myHero.y, myHero.z, Qrange, ARGB(255,100,0,50))
  end
  if menu.draw.drawE and Eready then
    DrawCircle(myHero.x, myHero.y, myHero.z, Erange, ARGB(255,100,0,50))
  end
  if menu.draw.drawR and Rready then
    DrawCircle(myHero.x, myHero.y, myHero.z, Rrange, ARGB(255,100,0,50))
  end
end
