--[[ Because Lillgoalie is gone for now, I've updated his Jarvan script and added more features.

  Most credit goes to him, not trying to steal any credit just love Jarvan and there's currently no good scripts, so
  I've made tJarvan. Enjoy!
  
  ]]

if myHero.charName ~= "JarvanIV" then return end

local version = 0.4
local AUTOUPDATE = true


local SCRIPT_NAME = "tJarvan"
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
ScriptName = "tJarvan"

-- Thank you to Roach and Bilbao for the support!
assert(load(Base64Decode("G0x1YVIAAQQEBAgAGZMNChoKAAAAAAAAAAAAAQIDAAAAJQAAAAgAAIAfAIAAAQAAAAQKAAAAVXBkYXRlV2ViAAEAAAACAAAADAAAAAQAETUAAAAGAUAAQUEAAB2BAAFGgUAAh8FAAp0BgABdgQAAjAHBAgFCAQBBggEAnUEAAhsAAAAXwAOAjMHBAgECAgBAAgABgUICAMACgAEBgwIARsNCAEcDwwaAA4AAwUMDAAGEAwBdgwACgcMDABaCAwSdQYABF4ADgIzBwQIBAgQAQAIAAYFCAgDAAoABAYMCAEbDQgBHA8MGgAOAAMFDAwABhAMAXYMAAoHDAwAWggMEnUGAAYwBxQIBQgUAnQGBAQgAgokIwAGJCICBiIyBxQKdQQABHwCAABcAAAAECAAAAHJlcXVpcmUABAcAAABzb2NrZXQABAcAAABhc3NlcnQABAQAAAB0Y3AABAgAAABjb25uZWN0AAQQAAAAYm9sLXRyYWNrZXIuY29tAAMAAAAAAABUQAQFAAAAc2VuZAAEGAAAAEdFVCAvcmVzdC9uZXdwbGF5ZXI/aWQ9AAQHAAAAJmh3aWQ9AAQNAAAAJnNjcmlwdE5hbWU9AAQHAAAAc3RyaW5nAAQFAAAAZ3N1YgAEDQAAAFteMC05QS1aYS16XQAEAQAAAAAEJQAAACBIVFRQLzEuMA0KSG9zdDogYm9sLXRyYWNrZXIuY29tDQoNCgAEGwAAAEdFVCAvcmVzdC9kZWxldGVwbGF5ZXI/aWQ9AAQCAAAAcwAEBwAAAHN0YXR1cwAECAAAAHBhcnRpYWwABAgAAAByZWNlaXZlAAQDAAAAKmEABAYAAABjbG9zZQAAAAAAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQA1AAAAAgAAAAIAAAACAAAAAgAAAAIAAAACAAAAAgAAAAMAAAADAAAAAwAAAAMAAAAEAAAABAAAAAUAAAAFAAAABQAAAAYAAAAGAAAABwAAAAcAAAAHAAAABwAAAAcAAAAHAAAABwAAAAgAAAAHAAAABQAAAAgAAAAJAAAACQAAAAkAAAAKAAAACgAAAAsAAAALAAAACwAAAAsAAAALAAAACwAAAAsAAAAMAAAACwAAAAkAAAAMAAAADAAAAAwAAAAMAAAADAAAAAwAAAAMAAAADAAAAAwAAAAGAAAAAgAAAGEAAAAAADUAAAACAAAAYgAAAAAANQAAAAIAAABjAAAAAAA1AAAAAgAAAGQAAAAAADUAAAADAAAAX2EAAwAAADUAAAADAAAAYWEABwAAADUAAAABAAAABQAAAF9FTlYAAQAAAAEAEAAAAEBvYmZ1c2NhdGVkLmx1YQADAAAADAAAAAIAAAAMAAAAAAAAAAEAAAAFAAAAX0VOVgA="), nil, "bt", _ENV))()
-------------------------------------------------

require 'SOW'
require 'VPrediction'
require 'Prodiction'

local VP = nil
local ts
local Menu
local levelSequence = {3, 1, 1, 2, 1, 4, 1, 3, 1, 3, 4, 3, 3, 2, 2, 4, 2}
local TMTSlot, RAHSlot = nil, nil
local TMTREADY, RAHREADY = false, false
local Qready, Wready, Eready, Rready = false, false, false, false

function OnLoad()
  ultActive = false
  EnemyMinions = minionManager(MINION_ENEMY, 700, myHero, MINION_SORT_MAXHEALTH_DEC)
  jungleMinions = minionManager(MINION_JUNGLE, 700, myHero, MINION_SORT_MAXHEALTH_DEC)
  Variables()
  UpdateWeb(true, ScriptName, id, HWID)
  ts = TargetSelector(TARGET_LESS_CAST, 900, DAMAGE_PHYSICAL)
  
  Prodict = ProdictManager.GetInstance()
  ProdictQ = Prodict:AddProdictionObject(_Q, Qrange, Qspeed, Qdelay, Qwidth)

  Menu = scriptConfig("tJarvan", "tJarvan")
  VP = VPrediction()
  Orbwalker = SOW(VP)
  
  Menu:addSubMenu("[tJarvan - Orbwalker]", "SOWorb")
  Orbwalker:LoadToMenu(Menu.SOWorb)

  Menu:addSubMenu("[tJarvan - Combo]", "Combo")
     Menu.Combo:addParam("combo", "Combo mode", SCRIPT_PARAM_ONKEYDOWN, false, 32)
     Menu.Combo:addParam("comboEQ", "Use Q+E and QE in Combo", SCRIPT_PARAM_ONOFF, true)
     Menu.Combo:addParam("comboSaveEQ", "Always save E+Q for EQ combo", SCRIPT_PARAM_ONOFF, false)
     Menu.Combo:addParam("comboW", "Use W in Combo", SCRIPT_PARAM_ONOFF, true)
     Menu.Combo:addParam("comboR", "Use R in Combo", SCRIPT_PARAM_ONOFF, true)
     Menu.Combo:addParam("RHealth", "Auto Use R at % Health of Enemy", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
     Menu.Combo:addParam("minR", "Auto Ultimate if can hit X enemies",  SCRIPT_PARAM_SLICE, 2, 0, 5, 0)

  Menu:addSubMenu("[tJarvan - Harass]", "Harass")
     Menu.Harass:addParam("harass", "Harass", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
     Menu.Harass:addParam("autoharass", "Auto-Harass", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("Y"))
     Menu.Harass:addParam("ahMana", "Auto-Harass if mana is over %", SCRIPT_PARAM_SLICE, 20, 0, 100, 0)
  
  Menu:addSubMenu("[tJarvan - Laneclear]", "LaneClear")
     Menu.LaneClear:addParam("laneClear", "Laneclear with spells", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("N"))
     Menu.LaneClear:addParam("laneclearQ", "Use Q in Laneclear", SCRIPT_PARAM_ONOFF, true)
     Menu.LaneClear:addParam("laneclearE", "Use E in Laneclear", SCRIPT_PARAM_ONOFF, true)
     Menu.LaneClear:addParam("lclrMana", "Use Spells if mana is over %", SCRIPT_PARAM_SLICE, 20, 0, 100, 0)
  
  Menu:addSubMenu("[tJarvan - JungleClear]", "JungleClear")
     Menu.JungleClear:addParam("jungleclear", "Jungleclear with spells", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("N"))
     Menu.JungleClear:addParam("jungleclearQ", "Use Q in Jungleclear", SCRIPT_PARAM_ONOFF, true)
     Menu.JungleClear:addParam("jungleclearE", "Use E in Jungleclear", SCRIPT_PARAM_ONOFF, true)
     Menu.JungleClear:addParam("jungleclearW", "Use W in Jungleclear", SCRIPT_PARAM_ONOFF, true)
     Menu.JungleClear:addParam("jungleclearMana", "Use Spells if mana is over %", SCRIPT_PARAM_SLICE, 20, 0, 100, 0)
     Menu.JungleClear:addParam("UseItem", "Use Items in Jungleclear", SCRIPT_PARAM_ONOFF, true)
  

  Menu:addSubMenu("[tJarvan - Additionals]", "Ads")
     Menu.Ads:addParam("EQcommand", "Key for EQ combo (Escape key)", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("S"))
     Menu.Ads:addParam("prediction", "Prodiction = ON VPred = OFF", SCRIPT_PARAM_ONOFF, true)
     Menu.Ads:addParam("autolevel", "Auto-Level spells (Jungle)", SCRIPT_PARAM_ONOFF, true)

  Menu:addSubMenu("[tJarvan - Drawings]", "drawings")
     Menu.drawings:addParam("drawCircleAA", "Draw AA Range", SCRIPT_PARAM_ONOFF, true)
     Menu.drawings:addParam("drawCircleEQ", "Draw EQ Range", SCRIPT_PARAM_ONOFF, true)
     Menu.drawings:addParam("drawCircleR", "Draw R Range", SCRIPT_PARAM_ONOFF, true)
     
  Menu:addSubMenu("[tJarvan - Target Selector]", "targetSelector")
     Menu.targetSelector:addTS(ts)
     ts.name = "Focus"

  Menu.Combo:permaShow("combo")
  
 print("<font color = \"#33CCCC\">tJarvan by</font> <font color = \"#fff8e7\">Teecolz Loaded.</font>")

end

function Variables()

  AARange = 175

  Qrange = 700
  Qwidth = 70 
  Qspeed = math.huge
  Qdelay = 0.5

  Wrange = 300
  Wwidth = 300 
  Wspeed = nil
  Wdelay = 0.5

  Erange = 830
  Ewidth = 75 
  Espeed = math.huge 
  Edelay = 0.5

  Rrange = 650
  Rwidth = 325 
  Rspeed = nil
  Rdelay = 0.5
end

function OnTick()
  if myHero.dead then return end
  EnemyMinions:update()
  jungleMinions:update()
  spell_check()
  ts:update()
  
  if Menu.Ads.autolevel then
    autoLevelSetSequence(levelSequence)
  end

  if Menu.Combo.combo then
    JarvanCombo()
  end

  if Menu.Ads.EQcommand then
    mousePosEQ()
  end

  if Menu.LaneClear.laneclearQ and Menu.LaneClear.laneClear then
    lclr()
  end
  
  if Menu.JungleClear.jungleclear then
      JungleClear()
  end

  if Menu.Harass.harass then
    useHarass()
  end

  if Menu.Harass.autoharass then
    useAutoHarass()
  end
  
  if UltActive then
    if CountEnemyHeroInRange(Rwidth) <= 1 then
      CastSpell(_R)
    end
  end
  
  killsteal()
  
  AutoUlt()
  
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

function useHarass()
  for i, target in pairs(GetEnemyHeroes()) do
        local CastPosition,  HitChance,  Position = VP:GetLineCastPosition(target, 0.5, 70, 700, 1000, myHero, false)
        if target ~= nil and Qready and ValidTarget(target) and HitChance >= 2 and GetDistance(CastPosition) < 700 then
            CastSpell(_Q, CastPosition.x, CastPosition.z)
        end
  end
end

function useAutoHarass()
  for i, target in pairs(GetEnemyHeroes()) do
        local CastPosition,  HitChance,  Position = VP:GetLineCastPosition(target, 0.5, 70, 700, 1000, myHero, false)
        if target ~= nil and Qready and ValidTarget(target) and HitChance >= 2 and GetDistance(CastPosition) < Qrange and ManaCheck(myHero, Menu.Harass.ahMana) == false then
            CastSpell(_Q, CastPosition.x, CastPosition.z)
        end
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

function lclr()
  if jungleMinion == nil then
    for i, minion in pairs(EnemyMinions.objects) do
      if minion ~= nil and ValidTarget(minion, 700) then
          local CastPosition,  HitChance,  Position = VP:GetLineCastPosition(minion, 0.5, 70, 700, 1000, myHero, false)
          if HitChance >= 2 and Qready and GetDistance(CastPosition) < 700 and ManaCheck(myHero, Menu.LaneClear.lclrMana) == false then
              CastSpell(_Q, CastPosition.x, CastPosition.z)
          end
              CastSpell(_E, minion.x, minion.z)
      end
    end
  end
end

function ManaCheck(unit, ManaValue)
  if unit.mana < (unit.maxMana * (ManaValue/100))
    then return true
  else
    return false
  end
end

function HealthCheck(unit, HealthValue)
  if unit.health < (unit.maxHealth * (HealthValue/100))
    then return true
  else
    return false
  end
end

function AutoUlt()
  for i, enemy in ipairs(GetEnemyHeroes()) do
      if enemy ~= nil and GetDistance(enemy) < Rrange and not ultActive then
        if CountEnemies(Rwidth, enemy) >= Menu.Combo.minR then
          CastSpell(_R, enemy)
        end
      end
  end
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

function JarvanCombo()
  if Menu.Combo.comboEQ then
     if not Menu.Ads.prediction then
          ComboEQ()
     else
          prodictionEQ()
     end
  end

  if Menu.Combo.comboW then
    ComboW()
  end
  
  if Menu.Combo.comboR then
    ComboR()
  end
end

function ComboR()
  local target = ts.target
  if Menu.Combo.combo then
    for i, target in pairs(GetEnemyHeroes()) do
      if target ~= nil and ValidTarget(target, Rrange) and not ultActive then
        if HealthCheck(myHero, Menu.Combo.RHealth) == false then
          CastSpell(_R, target)
        end
      end
    end
  end
end

function ComboW()
  if CountEnemyHeroInRange(280) >= 1 then
    CastSpell(_W)
  end
end

function ComboEQ()
  if Menu.Combo.combo then
      if Menu.Combo.comboSaveEQ then
        for i, target in pairs(GetEnemyHeroes()) do
              local CastPosition,  HitChance,  Position = VP:GetCircularCastPosition(target, 0.5, 70, 800, 1000)
              if target ~= nil and Qready and Eready and ValidTarget(target) and HitChance >= 2 and GetDistance(CastPosition) < 800 then
                  CastSpell(_E, CastPosition.x, CastPosition.z)
                  CastSpell(_Q, CastPosition.x, CastPosition.z)
              end
        end
      else
        for i, target in pairs(GetEnemyHeroes()) do
              local CastPosition,  HitChance,  Position = VP:GetCircularCastPosition(target, 0.5, 70, 800, 1000)
              if target ~= nil and ValidTarget(target) and HitChance >= 2 and GetDistance(CastPosition) < 800 then
                  CastSpell(_E, CastPosition.x, CastPosition.z)
                  CastSpell(_Q, CastPosition.x, CastPosition.z)
              end
        end
      end
  end
end

function prodictionEQ()
      if Menu.Combo.comboSaveEQ then
        for i, target in pairs(GetEnemyHeroes()) do
         local pos, info = Prodiction.GetPrediction(target, Qrange, Qspeed, Qdelay, Qwidth)
         if pos and Qready and Eready and ValidTarget(target) and GetDistance(pos) < 800 then
            CastSpell(_E, pos.x, pos.z)
            CastSpell(_Q, pos.x, pos.z)
         end
        end
      else
        for i, target in pairs(GetEnemyHeroes()) do
         local pos, info = Prodiction.GetPrediction(target, Qrange, Qspeed, Qdelay, Qwidth)
         if pos and ValidTarget(target) and GetDistance(pos) < 800 then
            CastSpell(_E, pos.x, pos.z)
            CastSpell(_Q, pos.x, pos.z)
         end
        end
      end
end

function mousePosEQ()
  if Eready and Qready then
    CastSpell(_E, mousePos.x, mousePos.z)
    CastSpell(_Q, mousePos.x, mousePos.z)
  end
    myHero:MoveTo(mousePos.x, mousePos.z)
end

function OnDraw()
  if myHero.dead then return end

  if Menu.drawings.drawCircleEQ then
    DrawCircle(myHero.x, myHero.y, myHero.z, 800, 0x111111)
  end
  
  if Menu.drawings.drawCircleAA then
    DrawCircle(myHero.x, myHero.y, myHero.z, 250, ARGB(255, 0, 255, 0))
  end

  if Menu.drawings.drawCircleR then
    DrawCircle(myHero.x, myHero.y, myHero.z, 650, 0x111111)
  end
end

-------------------------------------------------
-------------------------------------------------
--[JungleCLear]--
function JungleClear()
  for i, jungleMinion in pairs(jungleMinions.objects) do
    if jungleMinion ~= nil then
      if Eready and Qready and Menu.JungleClear.jungleclearQ and Menu.JungleClear.jungleclearE and ManaCheck(myHero, Menu.JungleClear.jungleclearMana) == false then
        if ValidTarget(jungleMinion, Erange) then
          CastSpell(_E, jungleMinion.x, jungleMinion.z)
          CastSpell(_Q, jungleMinion.x, jungleMinion.z)
        end
      else
        if Menu.JungleClear.jungleclearQ and ManaCheck(myHero, Menu.JungleClear.jungleclearMana) == false and ValidTarget(jungleMinion, Qrange) and Qready then
          CastSpell(_Q, jungleMinion.x, jungleMinion.z)
        end
  
        if Menu.JungleClear.jungleclearE and ManaCheck(myHero, Menu.JungleClear.jungleclearMana) == false and ValidTarget(jungleMinion, Erange) and Eready then
          CastSpell(_E, jungleMinion)
        end
      end
      if Menu.JungleClear.jungleclearW and ManaCheck(myHero, Menu.JungleClear.jungleclearMana) == false and ValidTarget(jungleMinion, Wrange) and Wready then
        CastSpell(_W)
      end
    end
  end
end

function OnCreateObj(obj)
    if obj.name:find("JarvanCataclysm_tar.troy") then
      ultActive = true
    end
end

function OnDeleteObj(obj)
    if obj.name:find("JarvanCataclysm_tar.troy") then
      ultActive = false
    end
end

function OnBugsplat()
  UpdateWeb(false, ScriptName, id, HWID)
end

function OnUnload()
  UpdateWeb(false, ScriptName, id, HWID)
end
