if myHero.charName ~= "DrMundo" then return end

require 'VPrediction'
require 'Prodiction'
require 'SOW'

local version = 1.1
local AUTOUPDATE = true


local SCRIPT_NAME = "tMundo"
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
ScriptName = "tMundo"

-- Thank you to Roach and Bilbao for the support!
assert(load(Base64Decode("G0x1YVIAAQQEBAgAGZMNChoKAAAAAAAAAAAAAQIDAAAAJQAAAAgAAIAfAIAAAQAAAAQKAAAAVXBkYXRlV2ViAAEAAAACAAAADAAAAAQAETUAAAAGAUAAQUEAAB2BAAFGgUAAh8FAAp0BgABdgQAAjAHBAgFCAQBBggEAnUEAAhsAAAAXwAOAjMHBAgECAgBAAgABgUICAMACgAEBgwIARsNCAEcDwwaAA4AAwUMDAAGEAwBdgwACgcMDABaCAwSdQYABF4ADgIzBwQIBAgQAQAIAAYFCAgDAAoABAYMCAEbDQgBHA8MGgAOAAMFDAwABhAMAXYMAAoHDAwAWggMEnUGAAYwBxQIBQgUAnQGBAQgAgokIwAGJCICBiIyBxQKdQQABHwCAABcAAAAECAAAAHJlcXVpcmUABAcAAABzb2NrZXQABAcAAABhc3NlcnQABAQAAAB0Y3AABAgAAABjb25uZWN0AAQQAAAAYm9sLXRyYWNrZXIuY29tAAMAAAAAAABUQAQFAAAAc2VuZAAEGAAAAEdFVCAvcmVzdC9uZXdwbGF5ZXI/aWQ9AAQHAAAAJmh3aWQ9AAQNAAAAJnNjcmlwdE5hbWU9AAQHAAAAc3RyaW5nAAQFAAAAZ3N1YgAEDQAAAFteMC05QS1aYS16XQAEAQAAAAAEJQAAACBIVFRQLzEuMA0KSG9zdDogYm9sLXRyYWNrZXIuY29tDQoNCgAEGwAAAEdFVCAvcmVzdC9kZWxldGVwbGF5ZXI/aWQ9AAQCAAAAcwAEBwAAAHN0YXR1cwAECAAAAHBhcnRpYWwABAgAAAByZWNlaXZlAAQDAAAAKmEABAYAAABjbG9zZQAAAAAAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQA1AAAAAgAAAAIAAAACAAAAAgAAAAIAAAACAAAAAgAAAAMAAAADAAAAAwAAAAMAAAAEAAAABAAAAAUAAAAFAAAABQAAAAYAAAAGAAAABwAAAAcAAAAHAAAABwAAAAcAAAAHAAAABwAAAAgAAAAHAAAABQAAAAgAAAAJAAAACQAAAAkAAAAKAAAACgAAAAsAAAALAAAACwAAAAsAAAALAAAACwAAAAsAAAAMAAAACwAAAAkAAAAMAAAADAAAAAwAAAAMAAAADAAAAAwAAAAMAAAADAAAAAwAAAAGAAAAAgAAAGEAAAAAADUAAAACAAAAYgAAAAAANQAAAAIAAABjAAAAAAA1AAAAAgAAAGQAAAAAADUAAAADAAAAX2EAAwAAADUAAAADAAAAYWEABwAAADUAAAABAAAABQAAAF9FTlYAAQAAAAEAEAAAAEBvYmZ1c2NhdGVkLmx1YQADAAAADAAAAAIAAAAMAAAAAAAAAAEAAAAFAAAAX0VOVgA="), nil, "bt", _ENV))()
-------------------------------------------------

local ts
local target
local menu
local levelSequence = {1,3,1,2,1,4,1,2,1,2,4,2,2,3,3,4,3,3}
local VP = nil
local Qrange, Wrange, Erange, Rrange = 1000, 320, 225, 0
local Qready, Wready, Eready, Rready = false
local WActive = false

function OnLoad()
    --UpdateWeb(true, ScriptName, id, HWID)
    jungleMinions = minionManager(MINION_JUNGLE, Qrange, myHero, MINION_SORT_MAXHEALTH_DEC)
    EnemyMinions = minionManager(MINION_ENEMY, Qrange, myHero, MINION_SORT_MAXHEALTH_DEC)
    print("<font color=\"#78CCDB\"><b>" ..">> tMundo has been loaded")
    
    ts = TargetSelector(TARGET_NEAR_MOUSE, 1000, DAMAGE_PHYSICAL)
    
    menu = scriptConfig("tMundo", "tMundo")
    VP = VPrediction()
    iSOW = SOW(VP)
    
    menu:addSubMenu("tMundo: Orbwalk", "Orbwalk")
      iSOW:LoadToMenu(menu.Orbwalk) 
    
    menu:addSubMenu("tMundo: Combo", "Combo")
      menu.Combo:addParam("combo", "Combo mode", SCRIPT_PARAM_ONKEYDOWN, false, 32)
      menu.Combo:addParam("useQ", "Use Q-Spell", SCRIPT_PARAM_ONOFF, true)
      menu.Combo:addParam("useW", "Use W-Spell", SCRIPT_PARAM_ONOFF, true)
      menu.Combo:addParam("useE", "Use E-Spell", SCRIPT_PARAM_ONOFF, true)
    
    menu:addSubMenu("tMundo: Harass", "Harass")
      menu.Harass:addParam("harass", "Harass", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
      menu.Harass:addParam("autoharass", "Auto Harass", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("Y"))
      menu.Harass:addParam("percenthp", "Don't Auto Harass lower than % HP", SCRIPT_PARAM_SLICE, 30, 0, 100, 0)
    
    menu:addSubMenu("tMundo: Lane Clear", "lane")
      menu.lane:addParam("lanekey", "Lane Clear", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("N"))
      menu.lane:addParam("useQ", "Use Q-Spell", SCRIPT_PARAM_ONOFF, true)
      menu.lane:addParam("useW", "Use W-Spell", SCRIPT_PARAM_ONOFF, true)
      menu.lane:addParam("useE", "Use E-Spell", SCRIPT_PARAM_ONOFF, true)
    
    menu:addSubMenu("tMundo: Jungle Clear", "jungle")
      menu.jungle:addParam("junglekey", "Lane Clear", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("N"))
      menu.jungle:addParam("useQ", "Use Q-Spell", SCRIPT_PARAM_ONOFF, true)
      menu.jungle:addParam("useW", "Use W-Spell", SCRIPT_PARAM_ONOFF, true)
      menu.jungle:addParam("useE", "Use E-Spell", SCRIPT_PARAM_ONOFF, true)
    
    menu:addSubMenu("tMundo: Extra Stuff", "extra")
      menu.extra:addParam("KS", "Killsteal using Q", SCRIPT_PARAM_ONOFF, true)
      menu.extra:addParam("Qrange", "Q Range Slider", SCRIPT_PARAM_SLICE, 1000, 1, 1000, 0)
      menu.extra:addParam("lifesave", "Life saving Ultimate", SCRIPT_PARAM_ONOFF, true)
      menu.extra:addParam("percenthp", "Life Saving Ult %", SCRIPT_PARAM_SLICE, 20, 0, 100, 0)
      menu.extra:addParam("autolevel", "AutoLevel Spells", SCRIPT_PARAM_ONOFF, false)
      menu.extra:addParam("prediction", "Prodiction = ON, VPrediction = OFF", SCRIPT_PARAM_ONOFF, false)
      menu.extra:addParam("skin", "Skin", SCRIPT_PARAM_LIST, 8, { "Toxic", "Mr. Mundoverse", "Corporate", "Mundo","Executioner", "Rageborn", "TPA", "Classic" })
    
    menu:addSubMenu("tMundo: Drawing", "drawings")
      menu.drawings:addParam("drawCircleAA", "Draw AA Range", SCRIPT_PARAM_ONOFF, true)
      menu.drawings:addParam("drawCircleQ", "Draw Q Range", SCRIPT_PARAM_ONOFF, true)
      
    menu:addSubMenu("tMundo: TS", "targetSelector")
      menu.targetSelector:addTS(ts)

end

function OnTick()
    ts:update()
    target = ts.target
    EnemyMinions:update()
    jungleMinions:update()
    SkinHack()
    
    if menu.extra.autolevel then
        autoLevelSetSequence(levelSequence)
    end
    
    if menu.extra.lifesave then
        LifeSave()
    end
    
    if menu.extra.KS then
        Killsteal()
    end
    
    if menu.Combo.combo then
        Combo()
    end
    
    if menu.Harass.harass then
        Harass()
    end
    
    if menu.jungle.junglekey then
        JungleClear()
    end
    
    if menu.lane.lanekey then
        LaneClear()
    end
    
    if menu.Harass.autoharass and not menu.Combo.combo then
        AutoHarass()
    end
    
    --[[if not menu.Combo.combo and not menu.lane.lanekey and not menu.jungle.junglekey then
      if WActive and Wready and CountEnemyHeroInRange(600) == 0 then 
        CastSpell(_W)
      end
    end]]
    
    --[[if menu.lane.lanekey and WActive then
      for i, minion in pairs(EnemyMinions.objects) do
        if GetDistance(minion) > 600 or minion == nil then
          CastSpell(_W)
        end
      end
    end
    
    if menu.jungle.junglekey and WActive then
      for i, jungleMinion in pairs(jungleMinions.objects) do
        if GetDistance(jungleMinion) > 600 or jungleMinion == nil then
          CastSpell(_W)
        end
      end
    end]]
    
    if WActive and Wready then
      if not menu.lane.lanekey and not menu.jungle.junglekey and CountEnemies(600, myHero) == 0 then
        CastSpell(_W)
      end
    end

    Qready = (myHero:CanUseSpell(_Q) == READY)
    Wready = (myHero:CanUseSpell(_W) == READY)
    Eready = (myHero:CanUseSpell(_E) == READY)
    Rready = (myHero:CanUseSpell(_R) == READY)
end

function Killsteal()
    for i, enemy in pairs (GetEnemyHeroes()) do
        if Qready and ValidTarget(enemy, Qrange, true) and enemy.health < getDmg("Q",enemy,myHero) + 30 then
            if menu.extra.prediction then
                local pos, info = Prodiction.GetPrediction(target, menu.extra.Qrange, 1500, 0.5, 75)
                if pos and info.hitchance >= 2 and GetDistance(pos) < Qrange then
                    CastSpell(_Q, pos.x, pos.z)
                end
            else
                local CastPosition, HitChance, Position = VP:GetLineCastPosition(target, 0.5, 75, menu.extra.Qrange, 1500, myHero, true)
                if GetDistance(CastPosition) < Qrange and HitChance >= 2 then
                    CastSpell(_Q, CastPosition.x, CastPosition.z)
                end
            end
        end
    end
end

function Harass()
    if ValidTarget(target, Qrange) and Qready then
        for i, target in pairs(GetEnemyHeroes()) do
            if menu.extra.prediction then
                local pos, info = Prodiction.GetPrediction(target, menu.extra.Qrange, 1500, 0.5, 75)
                if pos and info.hitchance >= 2 and GetDistance(pos) < Qrange then
                    CastSpell(_Q, pos.x, pos.z)
                end
            else
                local CastPosition, HitChance, Position = VP:GetLineCastPosition(target, 0.5, 75, menu.extra.Qrange, 1500, myHero, true)
                if GetDistance(CastPosition) < Qrange and HitChance >= 2 then
                    CastSpell(_Q, CastPosition.x, CastPosition.z)
                end
            end
        end
    end
end

function AutoHarass()
    if ValidTarget(target, Qrange) and Qready then
      if myHero.health < (myHero.maxHealth*(menu.Harass.percenthp*0.01)) then return end
        for i, target in pairs(GetEnemyHeroes()) do
            if menu.extra.prediction then
                local pos, info = Prodiction.GetPrediction(target, menu.extra.Qrange, 1500, 0.5, 75)
                if pos and info.hitchance >= 2 and GetDistance(pos) < Qrange then
                    CastSpell(_Q, pos.x, pos.z)
                end
            else
                local CastPosition, HitChance, Position = VP:GetLineCastPosition(target, 0.5, 75, menu.extra.Qrange, 1500, myHero, true)
                if GetDistance(CastPosition) < Qrange and HitChance >= 2 then
                    CastSpell(_Q, CastPosition.x, CastPosition.z)
                end
            end
        end
    end
end

function Combo()
    if ValidTarget(target, Qrange) and Qready and menu.Combo.useQ then
        for i, target in pairs(GetEnemyHeroes()) do
            if menu.extra.prediction then
                local pos, info = Prodiction.GetPrediction(target, menu.extra.Qrange, 1500, 0.5, 75)
                if pos and info.hitchance >= 2 and GetDistance(pos) < Qrange then
                    CastSpell(_Q, pos.x, pos.z)
                end
            else
                local CastPosition, HitChance, Position = VP:GetLineCastPosition(target, 0.5, 75, menu.extra.Qrange, 1500, myHero, true)
                if GetDistance(CastPosition) < Qrange and HitChance >= 2 then
                    CastSpell(_Q, CastPosition.x, CastPosition.z)
                end
            end
        end
    end
    
    if menu.Combo.useW and not WActive and Wready and CountEnemies(Wrange, myHero) >= 1 then
        CastSpell(_W)
    --[[elseif WActive and CountEnemies(650, myHero) == 0 then
        CastSpell(_W)]]
    end
    
    if menu.Combo.useE and CountEnemies(ERange, myHero) >= 1 and Eready then
        CastSpell(_E)
    end
end

function LaneClear()
    if jungleMinion == nil then
        for i, minion in ipairs(EnemyMinions.objects) do
            if minion ~= nil then
                if GetDistance(minion) < Qrange and menu.lane.useQ then
                    if menu.extra.prediction then
                        local pos, info = Prodiction.GetPrediction(minion, menu.extra.Qrange, 1500, 0.5, 75)
                        if pos and info.hitchance ~= 0 and GetDistance(pos) < menu.extra.Qrange then
                            CastSpell(_Q, pos.x, pos.z)
                        end
                    else
                        local CastPosition, HitChance, Position = VP:GetLineCastPosition(minion, 0.5, 75, menu.extra.Qrange, 1500, myHero, true)
                        if GetDistance(CastPosition) < Qrange and HitChance >= 2 then
                            CastSpell(_Q, CastPosition.x, CastPosition.z)
                        end
                    end
                end
                if menu.lane.useW and GetDistance(minion) < Wrange and not WActive and Wready then
                    CastSpell(_W)
                end
                if menu.jungle.useE and Eready and GetDistance(minion) < Erange then CastSpell(_E) end 
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


function JungleClear()
    for i, jungleMinion in pairs(jungleMinions.objects) do
        if jungleMinion ~= nil then
            if GetDistance(jungleMinion) < Qrange and menu.jungle.useQ then
                if menu.extra.prediction then
                    local pos, info = Prodiction.GetPrediction(jungleMinion, menu.extra.Qrange, 1500, 0.5, 75, true)
                    if pos and info.hitchance >= 2 and GetDistance(pos) < Qrange then
                        CastSpell(_Q, pos.x, pos.z)
                    end
                else
                    local CastPosition, HitChance, Position = VP:GetLineCastPosition(jungleMinion, 0.5, 75, menu.extra.Qrange, 1500, myHero, true)
                    if GetDistance(CastPosition) < Qrange and HitChance >= 2 then
                        CastSpell(_Q, CastPosition.x, CastPosition.z)
                    end
                end
            end
            if menu.jungle.useW and GetDistance(jungleMinion) < Wrange and not WActive and Wready then
                CastSpell(_W)
            end
            if menu.jungle.useE and Eready and GetDistance(jungleMinion) < Erange then CastSpell(_E) end 
        end
    end
end

function OnGainBuff(myHero, buff)
    if buff.name == "BurningAgony" then
        WActive = true
        --print('WOn')
    end
end

function OnLoseBuff(myHero, buff)
    if buff.name == "BurningAgony" then
        WActive = false
        --print('WOff')
    end
end

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


function LifeSave()
    if myHero.health < (myHero.maxHealth*(menu.extra.percenthp*0.01)) and CountEnemyHeroInRange(900) ~= 0 then
        if Rready then
            CastSpell(_R)
        end
    end
end

function OnDraw()
  if myHero.dead then return end
  
  if menu.drawings.drawCircleAA then
    DrawCircle(myHero.x, myHero.y, myHero.z, 125, ARGB(255, 0, 255, 0))
  end

  if menu.drawings.drawCircleQ then
    DrawCircle(myHero.x, myHero.y, myHero.z, menu.extra.Qrange, 0x111111)
  end
end

function OnBugsplat()
    --UpdateWeb(false, ScriptName, id, HWID)
end

function OnUnload()
    --UpdateWeb(false, ScriptName, id, HWID)
end

function SkinHack()
if not VIP_USER then return end
  if menu.extra.skin ~= lastSkin then
    lastSkin = menu.extra.skin
    GenModelPacket("DrMundo", menu.extra.skin)
  end
end

function GenModelPacket(champ, skinId)
  p = CLoLPacket(0x97)
  p:EncodeF(myHero.networkID)
  p.pos = 1
  t1 = p:Decode1()
  t2 = p:Decode1()
  t3 = p:Decode1()
  t4 = p:Decode1()
  p:Encode1(t1)
  p:Encode1(t2)
  p:Encode1(t3)
  p:Encode1(bit32.band(t4,0xB))
  p:Encode1(1)--hardcode 1 bitfield
  p:Encode4(skinId)
  for i = 1, #champ do
    p:Encode1(string.byte(champ:sub(i,i)))
  end
  for i = #champ + 1, 64 do
    p:Encode1(0)
  end
  p:Hide()
  RecvPacket(p)
end
