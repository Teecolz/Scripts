if myHero.charName ~= "Aatrox" then return end

local version = 1.01
local AUTOUPDATE = false


local SCRIPT_NAME = "tAatrox"
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

--------------------BoL Tracker-----------------------------
HWID = Base64Encode(tostring(os.getenv("PROCESSOR_IDENTIFIER")..os.getenv("USERNAME")..os.getenv("COMPUTERNAME")..os.getenv("PROCESSOR_LEVEL")..os.getenv("PROCESSOR_REVISION")))
-- DO NOT CHANGE. This is set to your proper ID.
id = 15
ScriptName = "tAatrox"

-- Thank you to Roach and Bilbao for the support!
assert(load(Base64Decode("G0x1YVIAAQQEBAgAGZMNChoKAAAAAAAAAAAAAQIDAAAAJQAAAAgAAIAfAIAAAQAAAAQKAAAAVXBkYXRlV2ViAAEAAAACAAAADAAAAAQAETUAAAAGAUAAQUEAAB2BAAFGgUAAh8FAAp0BgABdgQAAjAHBAgFCAQBBggEAnUEAAhsAAAAXwAOAjMHBAgECAgBAAgABgUICAMACgAEBgwIARsNCAEcDwwaAA4AAwUMDAAGEAwBdgwACgcMDABaCAwSdQYABF4ADgIzBwQIBAgQAQAIAAYFCAgDAAoABAYMCAEbDQgBHA8MGgAOAAMFDAwABhAMAXYMAAoHDAwAWggMEnUGAAYwBxQIBQgUAnQGBAQgAgokIwAGJCICBiIyBxQKdQQABHwCAABcAAAAECAAAAHJlcXVpcmUABAcAAABzb2NrZXQABAcAAABhc3NlcnQABAQAAAB0Y3AABAgAAABjb25uZWN0AAQQAAAAYm9sLXRyYWNrZXIuY29tAAMAAAAAAABUQAQFAAAAc2VuZAAEGAAAAEdFVCAvcmVzdC9uZXdwbGF5ZXI/aWQ9AAQHAAAAJmh3aWQ9AAQNAAAAJnNjcmlwdE5hbWU9AAQHAAAAc3RyaW5nAAQFAAAAZ3N1YgAEDQAAAFteMC05QS1aYS16XQAEAQAAAAAEJQAAACBIVFRQLzEuMA0KSG9zdDogYm9sLXRyYWNrZXIuY29tDQoNCgAEGwAAAEdFVCAvcmVzdC9kZWxldGVwbGF5ZXI/aWQ9AAQCAAAAcwAEBwAAAHN0YXR1cwAECAAAAHBhcnRpYWwABAgAAAByZWNlaXZlAAQDAAAAKmEABAYAAABjbG9zZQAAAAAAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQA1AAAAAgAAAAIAAAACAAAAAgAAAAIAAAACAAAAAgAAAAMAAAADAAAAAwAAAAMAAAAEAAAABAAAAAUAAAAFAAAABQAAAAYAAAAGAAAABwAAAAcAAAAHAAAABwAAAAcAAAAHAAAABwAAAAgAAAAHAAAABQAAAAgAAAAJAAAACQAAAAkAAAAKAAAACgAAAAsAAAALAAAACwAAAAsAAAALAAAACwAAAAsAAAAMAAAACwAAAAkAAAAMAAAADAAAAAwAAAAMAAAADAAAAAwAAAAMAAAADAAAAAwAAAAGAAAAAgAAAGEAAAAAADUAAAACAAAAYgAAAAAANQAAAAIAAABjAAAAAAA1AAAAAgAAAGQAAAAAADUAAAADAAAAX2EAAwAAADUAAAADAAAAYWEABwAAADUAAAABAAAABQAAAF9FTlYAAQAAAAEAEAAAAEBvYmZ1c2NhdGVkLmx1YQADAAAADAAAAAIAAAAMAAAAAAAAAAEAAAAFAAAAX0VOVgA="), nil, "bt", _ENV))()
-------------------------------------------------

require 'SOW'
require 'VPrediction'
require 'Prodiction'

StunList = {
                { charName = "Katarina",        spellName = "KatarinaR" ,                  important = 0},
                { charName = "Galio",           spellName = "GalioIdolOfDurand" ,          important = 0},
                { charName = "FiddleSticks",    spellName = "Crowstorm" ,                  important = 1},
                { charName = "FiddleSticks",    spellName = "DrainChannel" ,               important = 1},
                { charName = "Nunu",            spellName = "AbsoluteZero" ,               important = 0},
                { charName = "Shen",            spellName = "ShenStandUnited" ,            important = 0},
                { charName = "Urgot",           spellName = "UrgotSwap2" ,                 important = 0},
                { charName = "Malzahar",        spellName = "AlZaharNetherGrasp" ,         important = 0},
                { charName = "Karthus",         spellName = "FallenOne" ,                  important = 0},
                { charName = "Pantheon",        spellName = "PantheonRJump" ,              important = 0},
                { charName = "Pantheon",        spellName = "PantheonRFall",               important = 0},
                { charName = "Varus",           spellName = "VarusQ" ,                     important = 1},
                { charName = "Caitlyn",         spellName = "CaitlynAceintheHole" ,        important = 1},
                { charName = "MissFortune",     spellName = "MissFortuneBulletTime" ,      important = 1},
                { charName = "Warwick",         spellName = "InfiniteDuress" ,             important = 0}
}
-------------------------------------------------
-------------------------------------------------
local menu
local ts
local levelSequence = {3,2,2,1,3,4,3,3,3,2,4,2,1,1,1,4,2,1}
local target
local enemyTable = {}

local Prodict
local ProdictE, ProdictQ


local TMTSlot, RAHSlot = nil, nil
local TMTREADY, RAHREADY = false, false
local Qready, Wready, Eready, Rready = false, false, false, false


-------------------------------------------------
-------------------------------------------------
--[OnLoad]--
function OnLoad()
  VP    = VPrediction()
  iSOW  = SOW(VP)
  Variables()
  Init()
  Menu()
  PrintChat("<font color=\"#78CCDB\"><b>" ..">> tAatrox has been loaded")
  Loaded = true
  EnemyMinions = minionManager(MINION_ENEMY, Erange, myHero, MINION_SORT_MAXHEALTH_DEC)
  jungleMinions = minionManager(MINION_JUNGLE, Erange, myHero, MINION_SORT_MAXHEALTH_DEC)
  UpdateWeb(true, ScriptName, id, HWID)
  
  
  Prodict = ProdictManager.GetInstance()
  ProdictQ = Prodict:AddProdictionObject(_Q, Qrange, Qspeed, Qdelay, Qwidth)
  ProdictE = Prodict:AddProdictionObject(_E, Erange, Espeed, Edelay, Ewidth)
end

function Variables()

  AARange = 125

  Qrange = 650
  Qwidth = 0 
  Qspeed = 20
  Qdelay = 0.5

  Erange = 1000
  Ewidth = 150
  Espeed = 1200
  Edelay = 0.5

  Rrange = 550
  Rwidth = 550 
  Rspeed = nil
  Rdelay = nil
end


function Init()
    ts = TargetSelector(TARGET_LESS_CAST, Qrange, DAMAGE_PHYSICAL)
  end
  
function Menu()  
        menu = scriptConfig("tAatrox: Main Menu", "tAatrox")

          menu:addSubMenu("tAatrox: Orbwalk", "Orbwalk")
            iSOW:LoadToMenu(menu.Orbwalk)  
 
          menu:addSubMenu("tAatrox: Combo", "combo")
            menu.combo:addParam("combokey", "Combo",    SCRIPT_PARAM_ONKEYDOWN, false, 32)
            menu.combo:addParam("useQ", "Use Q-Spell",  SCRIPT_PARAM_ONOFF, true)
            menu.combo:addParam("useW", "Use W-Spell",  SCRIPT_PARAM_ONOFF, true)
            menu.combo:addParam("minW", "Toggle W at % Health", SCRIPT_PARAM_SLICE, 50, 0, 100, -1)
            menu.combo:addParam("maxW", "Max HP % to Toggle W", SCRIPT_PARAM_SLICE, 80, 0, 100, -1)
            menu.combo:addParam("useE", "Use E-Spell",  SCRIPT_PARAM_ONOFF, true)
            menu.combo:addParam("useR", "Use R-Spell",  SCRIPT_PARAM_ONOFF, true)
            menu.combo:addParam("minR", "Minimum Enemies to use R",  SCRIPT_PARAM_SLICE, 2, 0, 5, 0)
            menu.combo:addParam("items", "Use Items in combo",  SCRIPT_PARAM_ONOFF, true)

          menu:addSubMenu("tAatrox: Harass", "harass")
            menu.harass:addParam("harasskey", "Harass", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))

            
          menu:addSubMenu("tAatrox: Lane Clear", "lane")
            menu.lane:addParam("lanekey", "Lane Clear", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("N"))
            menu.lane:addParam("laneclearE", "Use E in LaneClear", SCRIPT_PARAM_ONOFF, true)
            

            
          menu:addSubMenu("tAatrox: Jungle Clear", "jungle")
            menu.jungle:addParam("junglekey", "Jungle Clear", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("N"))
            menu.jungle:addParam("jungleclearE", "Use E in Jungleclear", SCRIPT_PARAM_ONOFF, true)

          menu:addSubMenu("tAatrox: Killsteal", "killsteal")
            menu.killsteal:addParam("ks", "Use Smart Killsteal", SCRIPT_PARAM_ONOFF, true)


          menu:addSubMenu("tAatrox: Drawings", "draw")
            menu.draw:addParam("drawAA", "Draw AA Range", SCRIPT_PARAM_ONOFF, true)
            menu.draw:addParam("drawQ", "Draw Q Range",   SCRIPT_PARAM_ONOFF, true)
            menu.draw:addParam("drawE", "Draw E Range",   SCRIPT_PARAM_ONOFF, true)
            menu.draw:addParam("drawR", "Draw R Range",   SCRIPT_PARAM_ONOFF, true)


          menu:addSubMenu("tAatrox: Extras", "extra")
            menu.extra:addParam("autolevel", "AutoLevel Spells", SCRIPT_PARAM_ONOFF, false)
            menu.extra:addParam("autoQ", "Auto Q enemy under Turrets", SCRIPT_PARAM_ONOFF, false)
            menu.extra:addParam("knockup", "Auto Interrupt Spells w/ Q", SCRIPT_PARAM_ONOFF, false)
            menu.extra:addParam("smartW", "Use Smart W Logic", SCRIPT_PARAM_ONOFF, true)
            menu.extra:addParam("debug", "Debug", SCRIPT_PARAM_ONOFF, false)
         
          menu:addSubMenu("tAatrox: Escape", "escape")
            menu.escape:addParam("escapekey", "Escape", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("S"))
            
          menu:addSubMenu("tAatrox: Target Selector", "targetSelector")
            menu.targetSelector:addTS(ts)
            ts.name = "Focus"

      menu.combo:permaShow("combokey")
      menu.harass:permaShow("harasskey")
end

-------------------------------------------------
-------------------------------------------------
--[OnTick]--
function OnTick()
  if myHero.dead then return end
  ts:update()
  EnemyMinions:update()
  jungleMinions:update()
  spell_check()
  if menu.extra.autolevel then
    autoLevelSetSequence(levelSequence)
  end
  iSOW:EnableAttacks()
  target = ts.target
  
  if menu.combo.combokey then
    Combo()
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
  if menu.killsteal.ks then
    killsteal()
  end

  if menu.extra.autoQ then
    TurretJump()
  end
  if menu.combo.combokey and ValidTarget(target) then
    ItemManager(target)
  end
  if menu.escape.escapekey then
    escape()
  end
  
  SmartW()

end

function spell_check()
  
  Qready = (myHero:CanUseSpell(_Q) == READY)
  Wready = (myHero:CanUseSpell(_W) == READY)
  Eready = (myHero:CanUseSpell(_E) == READY)
  Rready = (myHero:CanUseSpell(_R) == READY)

  tiamatSlot = GetInventorySlotItem(3077)                                       
  hydraSlot = GetInventorySlotItem(3074)                                     
  youmuuSlot = GetInventorySlotItem(3142)                                      
  bilgeSlot = GetInventorySlotItem(3144)                                        
  bladeSlot = GetInventorySlotItem(3153)                              
  potSlot = GetInventorySlotItem(2003)  

  tiamatReady = (tiamatSlot ~= nil and myHero:CanUseSpell(tiamatSlot) == READY)                     
  hydraReady = (hydraSlot ~= nil and myHero:CanUseSpell(hydraSlot) == READY)                     
  youmuuReady = (youmuuSlot ~= nil and myHero:CanUseSpell(youmuuSlot) == READY)                  
  bilgeReady = (bilgeSlot ~= nil and myHero:CanUseSpell(bilgeSlot) == READY)                     
  bladeReady = (bladeSlot ~= nil and myHero:CanUseSpell(bladeSlot)  == READY)
end

-------------------------------------------------
-------------------------------------------------
--[Combo]--
function Combo()

  if Qready and menu.combo.useQ then
    UseQ()
  end
  
  if Eready and menu.combo.useE then
    UseE()
  end
  
  if menu.combo.useW then
    UseW()
  end
  
  if Rready and menu.combo.useR then
    UseR()
  end

end

function UseQ()
  for i, target in pairs(GetEnemyHeroes()) do
         local pos, info = Prodiction.GetCircularAOEPrediction(target, Qrange, Qspeed, Qdelay, Qwidth)
         if pos and GetDistance(pos) < Qrange and info.hitchance >= 1 then
              CastSpell(_Q, pos.x, pos.z)       
         end
  end

end

function UseE()
  for i, target in pairs(GetEnemyHeroes()) do
         local pos, info = Prodiction.GetLineAOEPrediction(target, Erange, Espeed, Edelay, Ewidth)
         if pos and info.hitchance >= 1 then
              if target ~= nil and Eready and GetDistance(pos) < Erange then
                  CastSpell(_E, pos.x, pos.z)
              end
         end
  end
end

function UseW()

  if Wready and myHero.health < myHero.maxHealth * (menu.combo.minW / 100) then
    if isWOn() then
      CastSpell(_W)
    end
  end

  if Wready and myHero.health > myHero.maxHealth * (menu.combo.maxW / 100) then
    if not isWOn() then
      CastSpell(_W)
    end
  end 

end

function SmartW()
  if menu.extra.smartW then
    if target == nil and myHero.health < (myHero.maxHealth * (95 / 100)) then
      if isWOn() then
        CastSpell(_W)     
      end
    else
      UseW()
    end
  end
end


function UseR()
  
  if CountEnemies(550, myHero) >= menu.combo.minR then
    CastSpell(_R)
  end
  
  --[[if menu.combo.useR1 then
    if target and target.health / target.maxHealth < 0.7 and Rready and GetDistance(target) < 500 then
      CastSpell(_R)
    end
  end]]
  
end

function CountEnemies(range, unit)
    local Enemies = 0
    for _, enemy in ipairs(GetEnemyHeroes()) do
        if ValidTarget(enemy) and GetDistance(enemy, unit) < (range or math.huge) then
            Enemies = Enemies + 1
        end
    end
    return Enemies
end

function ItemManager(target)
  if target then
    -- Tiamat
    if tiamatReady and GetDistance(target) <= 185 then 
      CastSpell(tiamatSlot, target) 
    end

    -- Ravenous Hydra
    if hydraReady and GetDistance(target) <= 185 then 
      CastSpell(hydraSlot, target) 
    end

    -- Bilgewater Cutlass
    if bilgeReady and GetDistance(target) <= 450 then 
      CastSpell(bilgeSlot, target)      
    end

    -- Blade of the Ruined King
    if bladeReady and GetDistance(target) <= 450 then 
      CastSpell(bladeSlot, target) 
    end

    -- Youomuu's Ghostblade
    if youmuuReady and GetDistance(target) <= 150 then 
      CastSpell(youmuuSlot) 
    end
  end
end
-------------------------------------------------
-------------------------------------------------
--[Harass]--
function Harass()

  if target and Eready then 
    UseE()
  end

end

-------------------------------------------------
-------------------------------------------------
--[Clear]--
function LaneClear()
  if jungleMinion == nil then
    for i, minion in pairs(EnemyMinions.objects) do
      if minion ~= nil and ValidTarget(minion, Erange) then
          CastSpell(_E, minion.x, minion.z)
      end
    end
  end
end


function JungleClear()
  for i, jungleMinion in pairs(jungleMinions.objects) do
    if jungleMinion ~= nil then
        if GetDistance(jungleMinion) < 600 then
          if Eready and menu.jungle.jungleclearE then
            CastSpell(_E, jungleMinion.x, jungleMinion.z)
          end
        end
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

function TurretJump()
  for _, enemy in ipairs(GetEnemyHeroes()) do
    if UnitAtTower(enemy, 0) and GetDistanceSqr(enemy) <= Qrange^2 then
      CastSpell(_Q, enemy)
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
  if menu.draw.drawW and Wready then
    DrawCircle(myHero.x, myHero.y, myHero.z, Wrange, ARGB(255,100,0,50))
  end
  if menu.draw.drawE and Eready then
    DrawCircle(myHero.x, myHero.y, myHero.z, Erange, ARGB(255,100,0,50))
  end
  if menu.draw.drawR and Rready then
    DrawCircle(myHero.x, myHero.y, myHero.z, Rrange, ARGB(255,100,0,50))
  end
end

function OnProcessSpell(unit, spell)
  if menu.extra.gapClose and Qready then
    if unit.team ~= myHero.team then
      local spellName = spell.name
      if DashList[unit.charName] and spellName == DashList[unit.charName].spell and GetDistance(unit) < 700 then
        if spell.target ~= nil and spell.target.name == myHero.name or DashList[unit.charName].spell == 'blindmonkqtwo' then
          local AOECastPosition, HitChance, Position = VP:GetCircularAOECastPosition(unit, Qdelay, Qwidth, Qrange, Qspeed, myHero)
          if GetDistance(AOECastPosition) < Qrange then
              CastSpell(_Q, AOECastPosition.x, AOECastPosition.z)
          end
        end
      end
    end
  end
  if menu.extra.knockup then
    if unit.team ~= myHero.team and GetDistance(unit) < Qrange then
      local spellName = spell.name
      for i = 1, #StunList do
        if unit.charName == StunList[i].charName and spellName == StunList[i].spellName then
          local AOECastPosition, HitChance, Position = VP:GetCircularAOECastPosition(unit, Qdelay, Qwidth, Qrange, Qspeed, myHero) 
          if GetDistance(AOECastPosition) < Qrange then
              CastSpell(_Q, AOECastPosition.x, AOECastPosition.z)
          end
        end
      end
    end 
  end
end

function isWOn()
  if myHero:GetSpellData(_W).name == "aatroxw2" then
    return true
  else
    return false
  end
end

function escape()
    myHero:MoveTo(mousePos.x, mousePos.z)  
      if Qready then
         CastSpell(_Q, mousePos.x, mousePos.z)
      end
      if ValidTarget(target, Erange) then
        UseE()
      end
end

function killsteal()
  for i, enemy in ipairs (GetEnemyHeroes()) do
    qDmg = getDmg("Q", enemy, myHero)
    eDmg = getDmg("E", enemy, myHero)
      if enemy.health < eDmg and GetDistance(enemy) < Erange then
         local pos, info = Prodiction.GetLineAOEPrediction(enemy, Erange, Espeed, Edelay, Ewidth)
         if pos and info.hitchance >= 1 then
              if enemy ~= nil and Eready and GetDistance(pos) < Erange then
                  CastSpell(_E, pos.x, pos.z)
              end
         end
      elseif enemy.health < qDmg and GetDistance(enemy) < Qrange then
         local pos, info = Prodiction.GetCircularAOEPrediction(enemy, Qrange, Qspeed, Qdelay, Qwidth)
         if pos and GetDistance(pos) < Qrange and info.hitchance >= 1 then
             if Qready and enemy ~= nil and enemy.health < qDmg and CountEnemies(500, pos) < 2 then
                  CastSpell(_Q, pos.x, pos.z)      
             end 
         end
      end
  end
end

function OnBugsplat()
  UpdateWeb(false, ScriptName, id, HWID)
end

function OnUnload()
  UpdateWeb(false, ScriptName, id, HWID)
end


--[[function OnGainBuff()
        if unit.isMe then
                if buff.name == "aatroxpower" then
                        AatroxPower = true
                end
        end
        if unit.isMe then
                if buff.name == "aatroxwlife" then
                        AatroxLife = true
                end
        end
end

function OnLoseBuff()
        if unit.isMe then
                if buff.name == "aatroxwlife" then
                        AatroxLife = false
                end
        end
        if unit.isMe then
                if buff.name == "aatroxpower" then
                        AatroxPower = false
                end
        end
end]]
