if myHero.charName ~= "Darius" then return end

--[AUTOUPDATER]--

local version = "1.6"
local AUTOUPDATE = true
local SCRIPT_NAME = "tDarius"
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

RequireI:Check()

if RequireI.downloadNeeded == true then return end

require 'SOW'
require 'VPrediction'

--------------------BoL Tracker-----------------------------
HWID = Base64Encode(tostring(os.getenv("PROCESSOR_IDENTIFIER")..os.getenv("USERNAME")..os.getenv("COMPUTERNAME")..os.getenv("PROCESSOR_LEVEL")..os.getenv("PROCESSOR_REVISION")))
-- DO NOT CHANGE. This is set to your proper ID.
id = 15
ScriptName = "tDarius"

-- Thank you to Roach and Bilbao for the support!
assert(load(Base64Decode("G0x1YVIAAQQEBAgAGZMNChoKAAAAAAAAAAAAAQIDAAAAJQAAAAgAAIAfAIAAAQAAAAQKAAAAVXBkYXRlV2ViAAEAAAACAAAADAAAAAQAETUAAAAGAUAAQUEAAB2BAAFGgUAAh8FAAp0BgABdgQAAjAHBAgFCAQBBggEAnUEAAhsAAAAXwAOAjMHBAgECAgBAAgABgUICAMACgAEBgwIARsNCAEcDwwaAA4AAwUMDAAGEAwBdgwACgcMDABaCAwSdQYABF4ADgIzBwQIBAgQAQAIAAYFCAgDAAoABAYMCAEbDQgBHA8MGgAOAAMFDAwABhAMAXYMAAoHDAwAWggMEnUGAAYwBxQIBQgUAnQGBAQgAgokIwAGJCICBiIyBxQKdQQABHwCAABcAAAAECAAAAHJlcXVpcmUABAcAAABzb2NrZXQABAcAAABhc3NlcnQABAQAAAB0Y3AABAgAAABjb25uZWN0AAQQAAAAYm9sLXRyYWNrZXIuY29tAAMAAAAAAABUQAQFAAAAc2VuZAAEGAAAAEdFVCAvcmVzdC9uZXdwbGF5ZXI/aWQ9AAQHAAAAJmh3aWQ9AAQNAAAAJnNjcmlwdE5hbWU9AAQHAAAAc3RyaW5nAAQFAAAAZ3N1YgAEDQAAAFteMC05QS1aYS16XQAEAQAAAAAEJQAAACBIVFRQLzEuMA0KSG9zdDogYm9sLXRyYWNrZXIuY29tDQoNCgAEGwAAAEdFVCAvcmVzdC9kZWxldGVwbGF5ZXI/aWQ9AAQCAAAAcwAEBwAAAHN0YXR1cwAECAAAAHBhcnRpYWwABAgAAAByZWNlaXZlAAQDAAAAKmEABAYAAABjbG9zZQAAAAAAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQA1AAAAAgAAAAIAAAACAAAAAgAAAAIAAAACAAAAAgAAAAMAAAADAAAAAwAAAAMAAAAEAAAABAAAAAUAAAAFAAAABQAAAAYAAAAGAAAABwAAAAcAAAAHAAAABwAAAAcAAAAHAAAABwAAAAgAAAAHAAAABQAAAAgAAAAJAAAACQAAAAkAAAAKAAAACgAAAAsAAAALAAAACwAAAAsAAAALAAAACwAAAAsAAAAMAAAACwAAAAkAAAAMAAAADAAAAAwAAAAMAAAADAAAAAwAAAAMAAAADAAAAAwAAAAGAAAAAgAAAGEAAAAAADUAAAACAAAAYgAAAAAANQAAAAIAAABjAAAAAAA1AAAAAgAAAGQAAAAAADUAAAADAAAAX2EAAwAAADUAAAADAAAAYWEABwAAADUAAAABAAAABQAAAF9FTlYAAQAAAAEAEAAAAEBvYmZ1c2NhdGVkLmx1YQADAAAADAAAAAIAAAAMAAAAAAAAAAEAAAAFAAAAX0VOVgA="), nil, "bt", _ENV))()
-------------------------------------------------

--[Other Stuff]--
local menu
local ts
local levelSequence = {1, 3, 1, 2, 1, 4, 1, 2, 1, 2, 4, 2, 3, 2, 3, 4, 3, 3}
local target
local enemyTable = {}


local TMTSlot, RAHSlot = nil, nil
local TMTREADY, RAHREADY = false, false
--[Spell Data]--
local Qready, Wready, Eready, Rready = false, false, false, false

--[Spell Range]--
local AARange = 125
local Qrange  = 425
local Wrange  = 210
local Erange  = 540
local Rrange  = 460

--[[Credit Ryuk]]--
champsToStun = {
                { charName = "Katarina",        spellName = "KatarinaR" ,                  important = 0},
                { charName = "Galio",           spellName = "GalioIdolOfDurand" ,          important = 0},
                { charName = "FiddleSticks",    spellName = "Crowstorm" ,                  important = 0},
                { charName = "FiddleSticks",    spellName = "DrainChannel" ,               important = 0},
                { charName = "Nunu",            spellName = "AbsoluteZero" ,               important = 0},
                { charName = "Shen",            spellName = "ShenStandUnited" ,            important = 0},
                { charName = "Urgot",           spellName = "UrgotSwap2" ,                 important = 0},
                { charName = "Malzahar",        spellName = "AlZaharNetherGrasp" ,         important = 0},
                { charName = "Karthus",         spellName = "FallenOne" ,                  important = 0},
                { charName = "Pantheon",        spellName = "PantheonRJump" ,              important = 0},
                { charName = "Pantheon",        spellName = "PantheonRFall",               important = 0},
                { charName = "Varus",           spellName = "VarusQ" ,                     important = 0},
                { charName = "Caitlyn",         spellName = "CaitlynAceintheHole" ,        important = 0},
                { charName = "MissFortune",     spellName = "MissFortuneBulletTime" ,      important = 0},
                { charName = "Warwick",         spellName = "InfiniteDuress" ,             important = 0}
}
-------------------------------------------------
-------------------------------------------------
--[OnLoad]--
function OnLoad()
  VP    = VPrediction()
  iSOW  = SOW(VP)
  Menu()
  Init()
  PrintChat("<font color=\"#78CCDB\"><b>" ..">> tDarius has been loaded")
  Loaded = true
  iSOW:RegisterAfterAttackCallback(Wreset)
  JungVariables()
  EnemyMinions = minionManager(MINION_ENEMY, 425, myHero, MINION_SORT_HEALTH_ASC)
  UpdateWeb(true, ScriptName, id, HWID)
  
  for i, enemy in pairs(GetEnemyHeroes()) do
    if enemy then 
      local a = {}
      a.object = enemy
      a.stack = 0
      table.insert(enemyTable, a)
    end
  end
end



function Init()
    ts = TargetSelector(TARGET_LESS_CAST, 540, DAMAGE_PHYSICAL)
end
  
function Menu()  
        menu = scriptConfig("tDarius: Main Menu", "Darius")

          menu:addSubMenu("tDarius: Orbwalk", "Orbwalk")
            iSOW:LoadToMenu(menu.Orbwalk)  
 
          menu:addSubMenu("tDarius: Combo", "combo")
            menu.combo:addParam("combokey", "Combo",    SCRIPT_PARAM_ONKEYDOWN, false, 32)
            menu.combo:addParam("useQ", "Use Q-Spell",  SCRIPT_PARAM_ONOFF, true)
            menu.combo:addSubMenu("Q Options", "qoptions")
            menu.combo.qoptions:addParam("qmax", "Only use Q at max damage", SCRIPT_PARAM_ONOFF, false)
            menu.combo.qoptions:addParam("packetsQ", "Use Packets for Q", SCRIPT_PARAM_ONOFF, true)
            menu.combo:addParam("useW", "Use W-Spell",  SCRIPT_PARAM_ONOFF, true)
            menu.combo:addParam("useE", "Use E-Spell",  SCRIPT_PARAM_ONOFF, true)
            menu.combo:addParam("minE", "Min E Range", SCRIPT_PARAM_SLICE, 0, 0, 300)
            menu.combo:addParam("useR", "Use R-Spell",  SCRIPT_PARAM_ONOFF, true)
            menu.combo:addParam("useITEM", "Use Items",  SCRIPT_PARAM_ONOFF, true)
            menu.combo:addParam("rBuffer", "R% to ult at",SCRIPT_PARAM_SLICE, 100, 0, 100, 2)
            menu.combo:addParam("packets", "Use Packets for Ult", SCRIPT_PARAM_ONOFF, true)

          menu:addSubMenu("tDarius: Harass", "harass")
            menu.harass:addParam("harasskey", "Harass", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
            menu.harass:addParam("useQ", "Use Q-Spell", SCRIPT_PARAM_ONOFF, true)
            menu.harass:addParam("autoQ", "Q Max Dmg Auto Harras", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("Y")) -- I suggest you to add an option to automagically disable this under turret ;) unless turret focus on another ally (or already on me) I'm not sure, but I think that requires packets though. check it please ;p
            menu.harass:addParam("mana", "Dont Harass if mana < %", SCRIPT_PARAM_SLICE, 0, 0, 100)
            
          menu:addSubMenu("tDarius: Lane Clear", "lane")
            menu.lane:addParam("lanekey", "Lane Clear", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("Z"))
            menu.lane:addParam("useQ", "Use Q-Spell", SCRIPT_PARAM_ONOFF, true)
            menu.lane:addParam("useW", "Use W-Spell", SCRIPT_PARAM_ONOFF, true)
            menu.lane:addParam("useITEM", "Use Items",  SCRIPT_PARAM_ONOFF, true)
            
          menu:addSubMenu("tDarius: Jungle Clear", "jungle")
            menu.jungle:addParam("junglekey", "Jungle Clear", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("Z"))
            menu.jungle:addParam("useQ", "Use Q-Spell", SCRIPT_PARAM_ONOFF, true)
            menu.jungle:addParam("useW", "Use W-Spell", SCRIPT_PARAM_ONOFF, true)
            menu.jungle:addParam("useITEM", "Use Items",  SCRIPT_PARAM_ONOFF, true)

          menu:addSubMenu("tDarius: Killsteal", "killsteal")
            menu.killsteal:addParam("killstealR", "Use R-Spell to Killsteal", SCRIPT_PARAM_ONOFF, true)
            menu.killsteal:addParam("killstealQ", "Use Q-Spell to Killsteal", SCRIPT_PARAM_ONOFF, true)

          menu:addSubMenu("tDarius: Drawings", "draw")
            menu.draw:addParam("drawAA", "Draw AA Range", SCRIPT_PARAM_ONOFF, true)
            menu.draw:addParam("drawQ", "Draw Q Range",   SCRIPT_PARAM_ONOFF, true)
            menu.draw:addParam("drawE", "Draw E Range",   SCRIPT_PARAM_ONOFF, true)
            menu.draw:addParam("drawR", "Draw R Range",   SCRIPT_PARAM_ONOFF, true)
            menu.draw:addParam("drawRD", "Draw Ult/Health damage",   SCRIPT_PARAM_ONOFF, true)
            menu.draw:addParam("drawP", "Draw Passive damage",   SCRIPT_PARAM_ONOFF, true)
            menu.draw:addParam("aftercombo", "Draw after Combo", SCRIPT_PARAM_ONOFF, true)
            menu.draw:addSubMenu("Killsteal", "killsteal")
              menu.draw.killsteal:addParam("RDraw", "Draw Enemys killed by R", SCRIPT_PARAM_ONOFF, true)

          menu:addSubMenu("tDarius: Extras", "extra")
            menu.extra:addParam("autolevel", "AutoLevel Spells (Requires F9)", SCRIPT_PARAM_ONOFF, false)
            menu.extra:addParam("interrupt", "Interrupt Important Spells with E", SCRIPT_PARAM_ONOFF, true)
            menu.extra:addParam("debug", "Debug", SCRIPT_PARAM_ONOFF, false)
            
          menu:addSubMenu("tDarius: Ult Blacklist", "ultb")
            for i, enemy in pairs(GetEnemyHeroes()) do
                  menu.ultb:addParam(enemy.charName, "Use ult on: "..enemy.charName, SCRIPT_PARAM_ONOFF, true)
            end
  

      menu.combo:permaShow("combokey")
      menu.harass:permaShow("harasskey")
      menu.harass:permaShow("autoQ")
end

-------------------------------------------------
-------------------------------------------------
--[OnTick]--
function OnTick()
  if myHero.dead then return end
  if Loaded then
    ts:update()
  end
  EnemyMinions:update()
  spell_check()
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
  if menu.lane.lanekey then
    LaneClear()
  end
  if menu.jungle.junglekey then
    JungleClear()
  end
  if menu.killsteal.killstealR and Rready then
    killstealR()
  end
  if menu.killsteal.killstealQ then
    killstealQ()
  end

  local target = ts.target
  if menu.harass.autoQ then
    if menu.harass.mana < (myHero.mana / myHero.maxMana) * 100 then
     if target and not UnitAtTower(target, 0) and Qready and GetDistance(target) < 405 and GetDistance(target) > 270 then
          if menu.combo.qoptions.packetsQ then
            Packet("S_CAST", {spellId = _Q}):send()
          else
            CastSpell(_Q)
          end
      end  
    end
  end
end

function spell_check()
  
  TMTSlot, RAHSlot = GetInventorySlotItem(3077), GetInventorySlotItem(3074)
  
  TMTREADY = (TMTSlot ~= nil and myHero:CanUseSpell(TMTSlot) == READY)
  RAHREADY = (RAHSlot ~= nil and myHero:CanUseSpell(RAHSlot) == READY)

  Qready = (myHero:CanUseSpell(_Q) == READY)
  Wready = (myHero:CanUseSpell(_W) == READY)
  Eready = (myHero:CanUseSpell(_E) == READY)
  Rready = (myHero:CanUseSpell(_R) == READY)
end

function blCheck(target)
  if target ~= nil and menu.ultb[target.charName] then
    return true
  else
    return false
  end
end

-------------------------------------------------
-------------------------------------------------
--[Combo]--
function Combo()
  local Enemies = GetEnemyHeroes
  local target  = ts.target

  if ts.target then
    if menu.combo.useITEM and TMTREADY and GetDistance(target) < 275 then CastSpell(TMTSlot) end
    if menu.combo.useITEM and RAHREADY and GetDistance(target) < 275 then CastSpell(RAHSlot) end
    if target and menu.combo.useQ and menu.combo.qoptions.qmax and Qready and GetDistance(target) < 425 and GetDistance(target) > 270 then
          if menu.combo.qoptions.packetsQ then
            Packet("S_CAST", {spellId = _Q}):send()
          else
            CastSpell(_Q)
          end
    elseif target and menu.combo.useQ and GetDistanceSqr(target) <= 180625 and Qready then
          if menu.combo.qoptions.packetsQ then
            Packet("S_CAST", {spellId = _Q}):send()
          else
            CastSpell(_Q)
          end
    end
    if menu.combo.useE and target and GetDistance(target) > menu.combo.minE and GetDistanceSqr(target) <= 291600 and Eready then 
      local AOECastPosition, MainTargetHitChance, nTargets = VP:GetLineAOECastPosition(target, 0.5, 225, Erange, 1500, myHero, false)
      if nTargets >= 1 and GetDistance(AOECastPosition) <= Erange and GetDistance(AOECastPosition) >= 250 then
        CastSpell(_E, AOECastPosition.x, AOECastPosition.z)
      end
    end
    if Rready and menu.combo.useR then
      if blCheck(target) then
        for i, enemy in pairs(enemyTable) do
           if enemy.object == target and GetDistance(target) < 460 then
              local multiplier = GetMultiplier(enemy.stack)
              local rDmg = multiplier * getDmg("R", target, myHero)
              if target.health <= rDmg*(menu.combo.rBuffer/100) then
                  if menu.combo.packets then
                    Packet("S_CAST", {spellId = _R, targetNetworkId = target.networkID}):send()
                    if menu.extra.debug then print("Casted with packet") end
                  else
                    if menu.extra.debug then print("Combo ult casted") end
                    CastSpell(_R, target)
                  end
              end
           end
          end
        end
    end
  end
end


function Wreset()
  if menu.combo.combokey and menu.combo.useW and Wready then
      SOW:resetAA() 
      CastSpell(_W)
  end
  if  menu.lane.lanekey and menu.lane.useW and Wready then
      SOW:resetAA()
      CastSpell(_W)
  end
  if menu.jungle.junglekey and menu.jungle.useW and Wready then
      SOW:resetAA()
      CastSpell(_W)
  end
end
-------------------------------------------------
-------------------------------------------------
--[Harass]--
function Harass()
  local Enemies = GetEnemyHeroes
  local target = ts.target
  if menu.harass.mana > (myHero.mana / myHero.maxMana) * 100 then return end

  if menu.harass.harasskey and target then
    if menu.harass.useQ and GetDistanceSqr(target) <= 180625 then
          if menu.combo.qoptions.packetsQ then
            Packet("S_CAST", {spellId = _Q}):send()
          else
            CastSpell(_Q)
          end
    end
  end
end

-------------------------------------------------
-------------------------------------------------
--[LaneClear]--
function LaneClear()
  if not GetJungleMob() then
    for i, minion in pairs(EnemyMinions.objects) do
  if minion and minion.valid and not minion.dead then
        if menu.lane.useQ and GetDistanceSqr(minion) <= 180625 then CastSpell(_Q) end
        if menu.lane.useITEM and TMTREADY and GetDistance(minion) < 275 then CastSpell(TMTSlot) end
        if menu.lane.useITEM and RAHREADY and GetDistance(minion) < 275 then CastSpell(RAHSlot) end
      end    
    end
  end
end

-------------------------------------------------
-------------------------------------------------
--[JungleCLear]--
function JungleClear()
    local JungleMob = GetJungleMob()
    if JungleMob ~= nil then
      if menu.jungle.useQ and GetDistanceSqr(JungleMob) <= 180625 then CastSpell(_Q) end
      if menu.jungle.useITEM and TMTREADY and GetDistance(JungleMob) < 275 then CastSpell(TMTSlot) end
      if menu.jungle.useITEM and RAHREADY and GetDistance(JungleMob) < 275 then CastSpell(RAHSlot) end
    end
end

function GetJungleMob()
  for _, Mob in pairs(JungleFocusMobs) do
    if ValidTarget(Mob, 425) then return Mob end
  end
  for _, Mob in pairs(JungleMobs) do
    if ValidTarget(Mob, 425) then return Mob end
  end
end

function OnCreateObj(obj)
  if obj.valid then
    if FocusJungleNames[obj.name] then
      JungleFocusMobs[#JungleFocusMobs+1] = obj
    elseif JungleMobNames[obj.name] then
      JungleMobs[#JungleMobs+1] = obj
    end
  end
end

function OnDeleteObj(obj)
  for i, Mob in pairs(JungleMobs) do
    if obj.name == Mob.name then
      table.remove(JungleMobs, i)
    end
  end
  for i, Mob in pairs(JungleFocusMobs) do
    if obj.name == Mob.name then
      table.remove(JungleFocusMobs, i)
    end
  end
end

function JungVariables()
  JungleMobs = {}
  JungleFocusMobs = {}
  JungleMobNames = { 
    ["Wolf8.1.2"]     = true,
    ["Wolf8.1.3"]     = true,
    ["YoungLizard7.1.2"]  = true,
    ["YoungLizard7.1.3"]  = true,
    ["LesserWraith9.1.3"] = true,
    ["LesserWraith9.1.2"] = true,
    ["LesserWraith9.1.4"] = true,
    ["YoungLizard10.1.2"] = true,
    ["YoungLizard10.1.3"] = true,
    ["SmallGolem11.1.1"]  = true,
    ["Wolf2.1.2"]     = true,
    ["Wolf2.1.3"]     = true,
    ["YoungLizard1.1.2"]  = true,
    ["YoungLizard1.1.3"]  = true,
    ["LesserWraith3.1.3"] = true,
    ["LesserWraith3.1.2"] = true,
    ["LesserWraith3.1.4"] = true,
    ["YoungLizard4.1.2"]  = true,
    ["YoungLizard4.1.3"]  = true,
    ["SmallGolem5.1.1"]   = true
  }
  
  FocusJungleNames = {
    ["Dragon6.1.1"]     = true,
    ["Worm12.1.1"]      = true,
    ["GiantWolf8.1.1"]    = true,
    ["AncientGolem7.1.1"] = true,
    ["Wraith9.1.1"]     = true,
    ["LizardElder10.1.1"] = true,
    ["Golem11.1.2"]     = true,
    ["GiantWolf2.1.1"]    = true,
    ["AncientGolem1.1.1"] = true,
    ["Wraith3.1.1"]     = true,
    ["LizardElder4.1.1"]  = true,
    ["Golem5.1.2"]      = true,
    ["GreatWraith13.1.1"] = true,
    ["GreatWraith14.1.1"] = true
  }
    
  for i = 0, objManager.maxObjects do
    local object = objManager:getObject(i)
    if object and object.valid and not object.dead then
      if FocusJungleNames[object.name] then
        JungleFocusMobs[#JungleFocusMobs+1] = object
      elseif JungleMobNames[object.name] then
        JungleMobs[#JungleMobs+1] = object
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
      if turret.team ~= myHero.team then
        if GetDistance(unit, turret) <= turret.range+offset then
          return true
        end
      end
    end
  end
  return false
end
-------------------------------------------------
-------------------------------------------------
--[KillSteal]--
function killstealR()
if menu.killsteal.killstealR then -- why even bother checking the rest and calculating dmg if killstealR is off ;)
  for i, enemy in pairs(enemyTable) do
     if GetDistance(enemy.object) < 460 then
          if blCheck(enemy.object) then
       local multiplier = GetMultiplier(enemy.stack)
       local rDmg = multiplier * getDmg("R", enemy.object, myHero)
       if enemy.object.health <= rDmg*(menu.combo.rBuffer/100) then
          if menu.combo.packets then
              Packet("S_CAST", {spellId = _R, targetNetworkId = enemy.networkID}):send()
              if menu.extra.debug then print("Casted with packet") end
          else
             if menu.extra.debug then print("Combo ult casted") end
             CastSpell(_R, enemy.object)
          end
       end
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
  draw_Range()
  draw_Range_aftercombo()
  killstealR_information()
end

function draw_Range()
  if menu.draw.drawAA then
    DrawCircle(myHero.x, myHero.y, myHero.z, AARange, ARGB(255,0,0,80))
  end
  if menu.draw.drawQ and Qready then
    DrawCircle(myHero.x, myHero.y, myHero.z, Qrange, ARGB(255,0,0,80))
  end
  if menu.draw.drawE and Eready then
    DrawCircle(myHero.x, myHero.y, myHero.z, Erange, ARGB(255,0,0,80))
  end
  if menu.draw.drawR and Rready then
    DrawCircle(myHero.x, myHero.y, myHero.z, Rrange, ARGB(255,0,0,80))
  end
end

function draw_Range_aftercombo()
  if menu.draw.drawQ and menu.draw.aftercombo and not Qready then
    DrawCircle(myHero.x, myHero.y, myHero.z, Qrange, ARGB(85,77,0,77))
  end
  if menu.draw.drawE and menu.draw.aftercombo and not Eready then
    DrawCircle(myHero.x, myHero.y, myHero.z, Erange, ARGB(85,77,0,77))
  end
  if menu.draw.drawR and menu.draw.aftercombo and not Rready then
    DrawCircle(myHero.x, myHero.y, myHero.z, Rrange, ARGB(85,77,0,77))
  end
end

function killstealR_information()
  local Enemies = GetEnemyHeroes()
  for i, enemy in pairs(enemyTable) do
    if not enemy.object.dead and enemy.object.visible then
      local pDmg = getDmg("P", enemy.object, myHero)
      local pDmgT = pDmg * enemy.stack
      local pDmgTint = math.floor(pDmgT)
      local Ehealth = math.floor(enemy.object.health)
      --local drawHealth = math.floor(rDmg / Ehealth)
      --local drawPHealth = math.floor(pDmgT / Ehealth)
      if pDmgT < enemy.object.health and menu.draw.drawP then
        DrawText3D("["..pDmgT.."/"..Ehealth.."] - passive", enemy.object.x, enemy.object.y, enemy.object.z, 20, RGB(0, 255, 0), 0)
      elseif menu.draw.drawP then
        DrawText3D("[DEAD]", enemy.object.x, enemy.object.y, enemy.object.z, 30, RGB(255, 0, 0), 0)
      end
      local multiplier = GetMultiplier(enemy.stack)
      local rDmg = math.floor(multiplier * getDmg("R", enemy.object, myHero))
      if enemy.object.health <= rDmg*(menu.combo.rBuffer/100) and menu.draw.killsteal.RDraw and Rready then
        DrawText3D("Press R to kill (Dunk)!", enemy.object.x, enemy.object.y, enemy.object.z-50, 30, RGB(255, 150, 0), 0)
        DrawCircle3D(enemy.object.x, enemy.object.y, enemy.object.z, 130, 1, RGB(255, 150, 0))
        DrawCircle3D(enemy.object.x, enemy.object.y, enemy.object.z, 150, 1, RGB(255, 150, 0))
        DrawCircle3D(enemy.object.x, enemy.object.y, enemy.object.z, 170, 1, RGB(255, 150, 0))
      elseif menu.draw.drawRD then
        DrawText3D("["..rDmg.."/"..Ehealth.."] - ult", enemy.object.x, enemy.object.y, enemy.object.z-50, 20, RGB(0, 255, 0), 0)
      end
    end
  end
end

function killstealQ()
  local Enemies = GetEnemyHeroes()

  for i, enemy in pairs(Enemies) do
      if ValidTarget(enemy, Qrange) and not enemy.dead and GetDistance(enemy) < Qrange then
        if (getDmg("Q", enemy,myHero)+getDmg("AD", enemy,myHero)) > enemy.health then
          if menu.combo.qoptions.packetsQ then
            Packet("S_CAST", {spellId = _Q}):send()
          else
            CastSpell(_Q)
          end
        end
      end
  end
end

function OnGainBuff(unit, buff)
  if unit and unit.team ~= myHero.team and buff.name == "dariushemo" then
    for i, enemy in pairs(enemyTable) do
      if enemy.object.name == unit.name then
        enemy.stack = 1
      end
    end
  end
  if menu.extra.debug then print(enemyTable) end
end

function OnLoseBuff(unit, buff)
  if buff.name == "dariushemo" then
    for i, enemy in pairs(enemyTable) do
      if enemy.object.name == unit.name then
        enemy.stack = 0
      end
    end
  end
end

function OnUpdateBuff(unit, buff)
  if buff.name == "dariushemo" then
    for i, enemy in pairs(enemyTable) do
      if enemy.object.name == unit.name then
        enemy.stack = buff.stack
      end
    end
  end
end

function GetMultiplier(stack)

  return 1 + stack/5
  
end

function OnProcessSpell(unit, spell)

  if menu.extra.interrupt then
    if unit.type == 'obj_AI_Hero' and unit.team == TEAM_ENEMY and GetDistance(unit) < Erange then
        local spellName = spell.name
      for i = 1, #champsToStun do
        if unit.charName == champsToStun[i].charName and spellName == champsToStun[i].spellName then
          if champsToStun[i].important == 0 then
            if Eready and GetDistanceSqr(unit) > Erange^2 then
              CastSpell(_E,unit.x,unit.z)
            end
          end
        end
      end
    end
  end
end

function UnitAtTower(unit,offset)
  for i, turret in pairs(GetTurrets()) do
    if turret ~= nil then
      if turret.team ~= myHero.team then
        if GetDistance(unit, turret) <= turret.range+offset then
          return true
        end
      end
    end
  end
  return false
end

function OnBugsplat()
  UpdateWeb(false, ScriptName, id, HWID)
end

function OnUnload()
  UpdateWeb(false, ScriptName, id, HWID)
end
