if myHero.charName ~= "Darius" then return end


require 'SOW'
require 'VPrediction'

--[AUTOUPDATER]--

local version = "1.2"
local author = "Teecolz"
local scriptName = "tDarius"
local AUTOUPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/Teecolz/Scripts/master/tDarius.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH.."tDarius.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH


function AutoupdaterMsg(msg) print("<font color='#5F9EA0'><b>[".. scriptName .."] </font><font color='#cffffffff'> "..msg..".</font>") end
if AUTOUPDATE then
  local ServerData = GetWebResult(UPDATE_HOST, "/Teecolz/Scripts/master/tDarius.version")
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

-------------------------------------------------
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
  --[TargetSelector]--
    ts      = TargetSelector(TARGET_LESS_CAST, 540, DAMAGE_PHYSICAL)
    ts.name = "Darius"
  end
  
function Menu()  
        menu = scriptConfig("tDarius: Main Menu", "Darius")

          menu:addSubMenu("tDarius: Orbwalk", "Orbwalk")
            iSOW:LoadToMenu(menu.Orbwalk)  
 
          menu:addSubMenu("tDarius: Combo", "combo")
            menu.combo:addParam("combokey", "Combo",    SCRIPT_PARAM_ONKEYDOWN, false, 32)
            menu.combo:addParam("useQ", "Use Q-Spell",  SCRIPT_PARAM_ONOFF, true)
            menu.combo:addParam("useW", "Use W-Spell",  SCRIPT_PARAM_ONOFF, true)
            menu.combo:addParam("useE", "Use E-Spell",  SCRIPT_PARAM_ONOFF, true)
            menu.combo:addParam("useR", "Use R-Spell",  SCRIPT_PARAM_ONOFF, true)
            menu.combo:addParam("useITEM", "Use Items",  SCRIPT_PARAM_ONOFF, true)

          menu:addSubMenu("tDarius: Harass", "harass")
            menu.harass:addParam("harasskey", "Harass", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
            menu.harass:addParam("useQ", "Use Q-Spell", SCRIPT_PARAM_ONOFF, true)
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
            menu.draw:addParam("aftercombo", "Draw after Combo", SCRIPT_PARAM_ONOFF, true)
          menu.draw:addSubMenu("Killsteal", "killsteal")
            menu.draw.killsteal:addParam("RDraw", "Draw Enemys killed by R", SCRIPT_PARAM_ONOFF, true)

          menu:addSubMenu("tDarius: Extras", "extra")
            menu.extra:addParam("autolevel", "AutoLevel Spells", SCRIPT_PARAM_ONOFF, false)
            menu.extra:addParam("debug", "Debug", SCRIPT_PARAM_ONOFF, false)

      --[PermaShow]--
      menu.combo:permaShow("combokey")
      menu.harass:permaShow("harasskey")
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
  if menu.killsteal.killstealR then
    killstealR()
  end
  if menu.killsteal.killstealQ then
    killstealQ()
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

-------------------------------------------------
-------------------------------------------------
--[Combo]--
function Combo()
  local Enemies = GetEnemyHeroes
  local target  = ts.target

  if menu.combo.combokey and ts.target then
    if menu.combo.useITEM and TMTREADY and GetDistance(target) < 275 then CastSpell(TMTSlot) end
    if menu.combo.useITEM and RAHREADY and GetDistance(target) < 275 then CastSpell(RAHSlot) end
    if target and menu.combo.useQ and GetDistanceSqr(target) <= 180625 and Qready then
      CastSpell(_Q)
    end
    if target and menu.combo.useE and GetDistanceSqr(target) <= 291600 and Eready then
      local AOECastPosition, MainTargetHitChance, nTargets = VP:GetLineAOECastPosition(target, 0.5, 225, Erange, 1500, myHero, false)
      if nTargets >= 1 and GetDistance(AOECastPosition) <= Erange then
        CastSpell(_E, target.x, target.z)
      end
    end
    if RReady and menu.combo.useR then
      for i, enemy in pairs(enemyTable) do
        if enemy.object == target and GetDistance(target) < 460 then
          local multiplier = GetMultiplier(enemy.stack)
          local rDmg = multiplier * getDmg("R", target, myHero)
          if target.health <= rDmg then
            CastSpell(_R, target)
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
      CastSpell(_Q)
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
  local target = ts.target
  local Enemies = GetEnemyHeroes()
  
    for i, enemy in pairs(Enemies) do
      if ValidTarget(enemy, Rrange) and not enemy.dead and GetDistance(enemy) < Rrange then
        if (getDmg("R", enemy,myHero)+getDmg("AD",enemy,myHero)) > enemy.health and
          menu.killsteal.killstealR then
            CastSpell(_R, target)
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

  if Rready then
    for i, enemy in pairs(Enemies) do
      if ValidTarget(enemy, 2000) and not enemy.dead and GetDistance(enemy) < 3000 then
        if (getDmg("R", enemy,myHero)+getDmg("AD",enemy,myHero)) > enemy.health and
          menu.draw.killsteal.RDraw then
          DrawText3D("Press R to kill (Dunk)!", enemy.x, enemy.y, enemy.z, 15, RGB(255, 150, 0), 0)
          DrawCircle3D(enemy.x, enemy.y, enemy.z, 130, 1, RGB(255, 150, 0))
          DrawCircle3D(enemy.x, enemy.y, enemy.z, 150, 1, RGB(255, 150, 0))
          DrawCircle3D(enemy.x, enemy.y, enemy.z, 170, 1, RGB(255, 150, 0))
        end
      end
    end
  end
end

function killstealQ()
  local Enemies = GetEnemyHeroes()

  for i, enemy in pairs(Enemies) do
      if ValidTarget(enemy, Qrange) and not enemy.dead and GetDistance(enemy) < Qrange then
        if (getDmg("Q", enemy,myHero)+getDmg("AD", enemy,myHero)) > enemy.health then
            CastSpell(_Q)
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
