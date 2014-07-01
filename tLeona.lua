if myHero.charName ~= "Leona" then return end

--[[AUTOUPDATER]]--

local version = "1.1"
local author = "Teecolz"
local scriptName = "tLeona"
local AUTOUPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/Teecolz/Scripts/master/tLeona.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH.."tLeona.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function AutoupdaterMsg(msg) print("<font color='#5F9EA0'><b>[".. scriptName .."] </font><font color='#cffffffff'> "..msg..".</font>") end
if AUTOUPDATE then
  local ServerData = GetWebResult(UPDATE_HOST, "/Teecolz/Scripts/master/tLeona.version")
  if ServerData then
    ServerVersion = type(tonumber(ServerData)) == "number" and tonumber(ServerData) or nil
    if ServerVersion then
      if tonumber(version) < ServerVersion then
        AutoupdaterMsg("New version available"..ServerVersion)
        AutoupdaterMsg("Updating, please don't press F9")
        DelayAction(function() DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () AutoupdaterMsg("Successfully updated. ("..version.." => "..ServerVersion.."), press F9 twice to load the updated version.") end) end, 3)
      else
        AutoupdaterMsg("You have got the latest version ("..ServerVersion..")")
      end
    end
  else
    AutoupdaterMsg("Error downloading version info")
  end
end

--[[STUFF]]--

require 'SOW'
require 'VPrediction'

local ts
local menu
local target
local Qrange, Qwidth, Qspeed, Qdelay = 215, 1, 7777, 0.01
local Wrange, Wwidth, Wspeed, Wdelay = 275, 500, 1, 3 
local Erange, Ewidth, Espeed, Edelay = 900, 85, 2000, 0.25
local Rrange, Rwidth, Rspeed, Rdelay = 1200, 315, math.huge, 0.5
local QREADY = (myHero:CanUseSpell(_Q) == READY)
local WREADY = (myHero:CanUseSpell(_W) == READY)
local EREADY = (myHero:CanUseSpell(_E) == READY)
local RREADY = (myHero:CanUseSpell(_R) == READY)
local levelSequence = {3, 1, 2, 2, 2, 4, 2, 1, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3} 
local qOff, wOff, eOff, rOff = 0,0,0,0
local QReady, WReady, EReady, RReady = false, false, false, false

--[[ONLOAD]]
function OnLoad()
  VP = VPrediction()
  iSOW = SOW(VP)
  Menu()
  Init()
  PrintChat("<font color=\"#78CCDB\"><b>" ..">> tLeona has been loaded")
  Loaded = true
end

function Init()
  --[TargetSelector]--
  if RREADY then
    ts = TargetSelector(TARGET_LESS_CAST, 1200, DAMAGE_MAGIC)
    ts.name = "Leona"
  else
    ts = TargetSelector(TARGET_LESS_CAST, 875, DAMAGE_MAGIC)
    ts.name = "Leona"
  end
end

function Menu() 
  menu = scriptConfig("tLeona: Main Menu", "Darius")
  
  menu:addSubMenu("tLeona: Orbwalk", "Orbwalk")
  iSOW:LoadToMenu(menu.Orbwalk) 
  
  menu:addSubMenu("tLeona: Combo", "combo")
  menu.combo:addParam("combokey", "Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
  menu.combo:addParam("useQ", "Use Q-Spell", SCRIPT_PARAM_ONOFF, true)
  menu.combo:addParam("useW", "Use W-Spell", SCRIPT_PARAM_ONOFF, true)
  menu.combo:addParam("useE", "Use E-Spell", SCRIPT_PARAM_ONOFF, true)
  menu.combo:addParam("useR", "Use R-Spell", SCRIPT_PARAM_ONOFF, true)
  menu.combo:addParam("autoult", "Auto Use Ultimate", SCRIPT_PARAM_ONOFF, false)
  menu.combo:addParam("minR", "Minimum Enemies to Auto Ult", SCRIPT_PARAM_SLICE, 3, 1, 5, 0)
  
  menu:addSubMenu("tLeona: Harass", "harass")
  menu.harass:addParam("harasskey", "Harass", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
  menu.harass:addParam("useQ", "Use Q-Spell", SCRIPT_PARAM_ONOFF, true)
  
  menu:addSubMenu("tLeona: Drawings", "draw")
  menu.draw:addParam("drawE", "Draw E Range", SCRIPT_PARAM_ONOFF, true)
  menu.draw:addParam("drawR", "Draw R Range", SCRIPT_PARAM_ONOFF, true)
  
  menu:addSubMenu("tLeona: Extras", "extra")
  menu.extra:addParam("autolevel", "AutoLevel Spells", SCRIPT_PARAM_ONOFF, false)
  menu.extra:addParam("debug", "Debug", SCRIPT_PARAM_ONOFF, false)
  
  --[PermaShow]--
  menu.combo:permaShow("combokey")
  menu.harass:permaShow("harasskey")
end

--[OnTick]--
function OnTick()
  if myHero.dead then return end
  if Loaded then
    ts:update()
  end
  target = ts.target
  if menu.extra.autolevel then
    autoLevelSetSequence(levelSequence)
  end
  iSOW:EnableAttacks()
  
  if menu.combo.combokey then
    Combo()
  end
  if menu.harass.harasskey then
    Harass()
  end
  if menu.combo.autoult and RREADY then
    AutoUlt()
  end
  Init()
end

function Combo()
  if QREADY and menu.combo.useQ then UseQ() end
  if WREADY and menu.combo.useW then UseW() end
  if EREADY and menu.combo.useE then UseE() end
  if RREADY and menu.combo.useR then UseR() end
end

function UseQ()
  if target and GetDistance(target) <= 155 then
    CastSpell(_Q)
  end
end

function UseW()
  if target and GetDistance(target) <= Wrange then
    CastSpell(_W)
  end
end

function UseE()
  if target and GetDistanceSqr(target) <= 765625 then
    for i, target in pairs(GetEnemyHeroes()) do
      local CastPosition, HitChance, Position = VP:GetLineCastPosition(target, 875, 85, 2000, 0.25, myHero, false)
      if HitChance > 1 and GetDistance(CastPosition) <= 875 then
        CastSpell(_E, CastPosition.x, CastPosition.z)
      end
    end
  end
end

function UseR()
  
  for i, enemy in pairs(GetEnemyHeroes()) do
    if enemy and GetDistanceSqr(enemy) <= 1440000 then
      local AOECastPosition, MainTargetHitChance, nTargets = VP:GetCircularAOECastPosition(enemy, 0.25, 300, 1200, 20, myHero, false)
      if GetDistance(AOECastPosition) <= 1200 and MainTargetHitChance > 1 then
        CastSpell(_R, AOECastPosition.x, AOECastPosition.z)
      end
    end
  end
end

function AutoUlt()
  
  for i, enemy in pairs(GetEnemyHeroes()) do
    if enemy and GetDistanceSqr(enemy) <= 1440000 then
      local AOECastPosition, MainTargetHitChance, nTargets = VP:GetCircularAOECastPosition(target, 0.25, 300, 1200, 20, myHero, false)
      if GetDistance(AOECastPosition) <= 1200 and nTargets >= menu.combo.minR and MainTargetHitChance > 1 then
          CastSpell(_R, AOECastPosition.x, AOECastPosition.z)
      end
    end
  end
end

function OnDraw()

    if menu.draw.drawE then
        DrawCircle(myHero.x, myHero.y, myHero.z, 875, 0x111111)
    end
  
    if menu.draw.drawR then
        DrawCircle(myHero.x, myHero.y, myHero.z, 1200, 0x111111)
    end
    
    --[[if target.health < target.maxhealth/2 then
        DrawText3D("Go in Jordan. Probably"), enemy.x, enemy.y, enemy.z, 15, RGB(255, 150, 0), 0)
    end]]
end
