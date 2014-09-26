if myHero.charName ~= "Malzahar" then return end

local version = "1.1"
local AUTOUPDATE = true
local SCRIPT_NAME = "tMalzahar"
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
id = 15
ScriptName = "tMalzahar"

-- Thank you to Roach and Bilbao for the support!
assert(load(Base64Decode("G0x1YVIAAQQEBAgAGZMNChoKAAAAAAAAAAAAAQIDAAAAJQAAAAgAAIAfAIAAAQAAAAQKAAAAVXBkYXRlV2ViAAEAAAACAAAADAAAAAQAETUAAAAGAUAAQUEAAB2BAAFGgUAAh8FAAp0BgABdgQAAjAHBAgFCAQBBggEAnUEAAhsAAAAXwAOAjMHBAgECAgBAAgABgUICAMACgAEBgwIARsNCAEcDwwaAA4AAwUMDAAGEAwBdgwACgcMDABaCAwSdQYABF4ADgIzBwQIBAgQAQAIAAYFCAgDAAoABAYMCAEbDQgBHA8MGgAOAAMFDAwABhAMAXYMAAoHDAwAWggMEnUGAAYwBxQIBQgUAnQGBAQgAgokIwAGJCICBiIyBxQKdQQABHwCAABcAAAAECAAAAHJlcXVpcmUABAcAAABzb2NrZXQABAcAAABhc3NlcnQABAQAAAB0Y3AABAgAAABjb25uZWN0AAQQAAAAYm9sLXRyYWNrZXIuY29tAAMAAAAAAABUQAQFAAAAc2VuZAAEGAAAAEdFVCAvcmVzdC9uZXdwbGF5ZXI/aWQ9AAQHAAAAJmh3aWQ9AAQNAAAAJnNjcmlwdE5hbWU9AAQHAAAAc3RyaW5nAAQFAAAAZ3N1YgAEDQAAAFteMC05QS1aYS16XQAEAQAAAAAEJQAAACBIVFRQLzEuMA0KSG9zdDogYm9sLXRyYWNrZXIuY29tDQoNCgAEGwAAAEdFVCAvcmVzdC9kZWxldGVwbGF5ZXI/aWQ9AAQCAAAAcwAEBwAAAHN0YXR1cwAECAAAAHBhcnRpYWwABAgAAAByZWNlaXZlAAQDAAAAKmEABAYAAABjbG9zZQAAAAAAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQA1AAAAAgAAAAIAAAACAAAAAgAAAAIAAAACAAAAAgAAAAMAAAADAAAAAwAAAAMAAAAEAAAABAAAAAUAAAAFAAAABQAAAAYAAAAGAAAABwAAAAcAAAAHAAAABwAAAAcAAAAHAAAABwAAAAgAAAAHAAAABQAAAAgAAAAJAAAACQAAAAkAAAAKAAAACgAAAAsAAAALAAAACwAAAAsAAAALAAAACwAAAAsAAAAMAAAACwAAAAkAAAAMAAAADAAAAAwAAAAMAAAADAAAAAwAAAAMAAAADAAAAAwAAAAGAAAAAgAAAGEAAAAAADUAAAACAAAAYgAAAAAANQAAAAIAAABjAAAAAAA1AAAAAgAAAGQAAAAAADUAAAADAAAAX2EAAwAAADUAAAADAAAAYWEABwAAADUAAAABAAAABQAAAF9FTlYAAQAAAAEAEAAAAEBvYmZ1c2NhdGVkLmx1YQADAAAADAAAAAIAAAAMAAAAAAAAAAEAAAAFAAAAX0VOVgA="), nil, "bt", _ENV))()
-------------------------------------------------

require 'SOW'
require 'VPrediction'
require 'Prodiction'

local menu
local ts
local target
local levelSequence = {1,3,3,2,3,4,3,1,3,1,4,1,1,2,2,4,2,2}
local Qready, Wready, Eready, Rready = false, false, false, false
local UltOn = false
local MinionHasE = false


function OnLoad()
  VP = VPrediction()
  iSOW = SOW(VP)
  Menu()
  print("<font color=\"#78CCDB\"><b>" ..">> tMalzahar has been loaded!")
  Loaded = true
  Variables()
  EnemyMinions = minionManager(MINION_ENEMY, 800, myHero, MINION_SORT_HEALTH_ASC)
  ts = TargetSelector(TARGET_LESS_CAST, 850, DAMAGE_MAGIC)
  UpdateWeb(true, ScriptName, id, HWID)

end

function Variables()

  AARange = 550

  Qrange = 850  --really 900
  Qwidth = 110
  Qspeed = math.huge
  Qdelay = 0.5

  Wrange = 800
  Wwidth = 250 
  Wspeed = math.huge
  Wdelay = 0.5

  Erange = 650
  Ewidth = nil
  Espeed = math.huge 
  Edelay = 0.5

  Rrange = 700
  Rwidth = nil 
  Rspeed = math.huge
  Rdelay = 0.5
end

function Menu()  
          menu = scriptConfig("tMalzahar: Main Menu", "tMalzahar")

          menu:addSubMenu("tMalzahar: Orbwalk", "Orbwalk")
            iSOW:LoadToMenu(menu.Orbwalk)  
 
          menu:addSubMenu("tMalzahar: Combo", "combo")
            menu.combo:addParam("combokey", "Combo",    SCRIPT_PARAM_ONKEYDOWN, false, 32)
            menu.combo:addParam("useQ", "Use Q-Spell",  SCRIPT_PARAM_ONOFF, true)
            menu.combo:addParam("useW", "Use W-Spell",  SCRIPT_PARAM_ONOFF, true)
            menu.combo:addParam("useE", "Use E-Spell",  SCRIPT_PARAM_ONOFF, true)
            menu.combo:addParam("useR", "Use R-Spell",  SCRIPT_PARAM_ONOFF, true)
            
         menu:addSubMenu("tMalzahar: Farm", "farm")
            menu.farm:addParam("farmkey", "Farm", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("A"))
            menu.farm:addParam("useE", "Use E-Spell", SCRIPT_PARAM_ONOFF, true)
            menu.farm:addParam("mana", "Don't Use E if mana < %", SCRIPT_PARAM_SLICE, 0, 0, 100)

          menu:addSubMenu("tMalzahar: Harass", "harass")
            menu.harass:addParam("harasskey", "Harass", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
            menu.harass:addParam("useQ", "Use Q-Spell", SCRIPT_PARAM_ONOFF, true)
            menu.harass:addParam("useW", "Use W-Spell", SCRIPT_PARAM_ONOFF, false)
            menu.harass:addParam("useE", "Use E-Spell", SCRIPT_PARAM_ONOFF, false)
            menu.harass:addParam("mana", "Don't Harass if mana < %", SCRIPT_PARAM_SLICE, 0, 0, 100)
            
          menu:addSubMenu("tMalzahar: Lane Clear", "lane")
            menu.lane:addParam("lanekey", "Lane Clear", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("N"))
            menu.lane:addParam("useQ", "Use Q-Spell", SCRIPT_PARAM_ONOFF, true)
            menu.lane:addParam("useW", "Use W-Spell", SCRIPT_PARAM_ONOFF, true)
            menu.lane:addParam("useE", "Use E-Spell", SCRIPT_PARAM_ONOFF, true)
            menu.lane:addParam("mana", "Don't Use Spells if mana < %", SCRIPT_PARAM_SLICE, 0, 0, 100)
            
          --[[menu:addSubMenu("tMalzahar: Jungle Clear", "jungle")
            menu.jungle:addParam("junglekey", "Jungle Clear", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("N"))
            menu.jungle:addParam("useQ", "Use Q-Spell", SCRIPT_PARAM_ONOFF, true)
            menu.jungle:addParam("useW", "Use W-Spell", SCRIPT_PARAM_ONOFF, true)
            menu.jungle:addParam("useE", "Use E-Spell", SCRIPT_PARAM_ONOFF, true)]]

          menu:addSubMenu("tMalzahar: Killsteal", "killsteal")
            menu.killsteal:addParam("killstealE", "Use E-Spell to Killsteal", SCRIPT_PARAM_ONOFF, true)
            menu.killsteal:addParam("killstealQ", "Use Q-Spell to Killsteal", SCRIPT_PARAM_ONOFF, true)
            menu.killsteal:addParam("killstealR", "Use R-Spell to Killsteal", SCRIPT_PARAM_ONOFF, false)

          menu:addSubMenu("tMalzahar: Drawings", "draw")
            menu.draw:addParam("drawAA", "Draw AA Range", SCRIPT_PARAM_ONOFF, true)
            menu.draw:addParam("drawQ", "Draw Q Range",   SCRIPT_PARAM_ONOFF, true)
            menu.draw:addParam("drawW", "Draw W Range",   SCRIPT_PARAM_ONOFF, true)
            menu.draw:addParam("drawE", "Draw E Range",   SCRIPT_PARAM_ONOFF, true)
            menu.draw:addParam("drawR", "Draw R Range",   SCRIPT_PARAM_ONOFF, true)

          menu:addSubMenu("tMalzahar: Extras", "extra")
            menu.extra:addParam("autolevel", "AutoLevel Spells", SCRIPT_PARAM_ONOFF, false)
            menu.extra:addParam("prediction", "Prodiction = ON VPred = OFF", SCRIPT_PARAM_ONOFF, true)
            menu.extra:addParam("Qrange", "Q Range Slider", SCRIPT_PARAM_SLICE, 900, 1, 900, 0)
            menu.extra:addParam("debug", "Debug", SCRIPT_PARAM_ONOFF, false)
            menu.extra:addParam("skin", "Skin", SCRIPT_PARAM_LIST, 5, { "Vizier", "Shadow Prince", "Djinn", "Overlord","Classic" })
            
          menu:addSubMenu("tMalzahar: Ult Blacklist", "ultb")
            for i, enemy in pairs(GetEnemyHeroes()) do
                  menu.ultb:addParam(enemy.charName, "Use ult on: "..enemy.charName, SCRIPT_PARAM_ONOFF, true)
            end

          menu.combo:permaShow("combokey")
          menu.harass:permaShow("harasskey")
         
end

function OnTick()
  if myHero.dead then return end

    ts:update()
    SkinHack()

  EnemyMinions:update()
  spell_check()
  target = ts.target
  if menu.extra.autolevel then
    autoLevelSetSequence(levelSequence)
  end
  if menu.combo.combokey then
    Combo()
  end
  if menu.harass.harasskey then
    Harass()
  end
  if menu.lane.lanekey then
    LaneClear()
  end
  --[[if menu.jungle.junglekey then
    JungleClear()
  end]]
  if menu.farm.farmkey and menu.farm.useE then
    Farm()
  end
  if UltOn and ((GetLatency() / 2000) + os.clock()) - LastUlt > 2.6 then 
    UltOn = false 
    if menu.extra.debug then print("UltOff") end
  end
  --[[if not Rready and UltOn then 
    UltOn = false
    if menu.extra.debug then print("UltOff") end
  end]]
  
  DmgCheck()

  KS()
  
  if UltOn and _G.AutoCarry and _G.AutoCarry.MyHero then
    _G.AutoCarry.MyHero:AttacksEnabled(false)
    _G.AutoCarry.MyHero:MovementEnabled(false)
  elseif _G.AutoCarry and _G.AutoCarry.MyHero then
    _G.AutoCarry.MyHero:AttacksEnabled(true) 
    _G.AutoCarry.MyHero:MovementEnabled(true)
  end
  
  if UltOn then
    iSOW:DisableAttacks()
    iSOW.Move = false
    --myHero:HoldPosition()
  else
    iSOW:EnableAttacks()
    iSOW.Move = true
  end
end

function spell_check()
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

function Combo()
  if target == nil then return end
  if UltOn then return end
    
    if Wready and menu.combo.useW then CastW() end
    
    if Qready and menu.combo.useQ then CastQ() end
    
    if Eready and menu.combo.useE then CastE() end
    
    if Rready and menu.combo.useR then CastR() end
    
end

function CastQ()
  for i, enemy in ipairs(GetEnemyHeroes()) do
    if GetDistance(enemy) < menu.extra.Qrange and not UltOn then
      if menu.extra.prediction then
           --local pos, info = Prodiction.GetLineAOEPrediction(enemy, Qrange, Qspeed, (Qdelay + 200)/1600, Qwidth)
           local pos, info = Prodiction.GetLineAOEPrediction(enemy, menu.extra.Qrange, Qspeed, Qdelay, Qwidth)
           if pos and info.hitchance >= 3 and GetDistance(pos) < menu.extra.Qrange then
              CastSpell(_Q, pos.x, pos.z)
           end
      else
           --local AOECastPosition, MainTargetHitChance, nTargets = VP:GetLineAOECastPosition(enemy, Qdelay, Qradius, Qrange, Qspeed)
           local CastPosition, HitChance, nTargets = VP:GetCircularCastPosition(enemy, Qdelay, Qradius, menu.extra.Qrange, Qspeed, myHero, false)
           if GetDistance(CastPosition) < Qrange and HitChance >= 3 then
           	  if menu.extra.debug then print('Tried to Cast Q VPRED') end
              CastSpell(_Q, CastPosition.x, CastPosition.z)
              if menu.extra.debug then print('Casted Q VPRED') end
           end
      end
    end
  end
end

function CastW()
  if GetDistance(target) < Wrange then
    if menu.extra.prediction then
         local pos, info = Prodiction.GetCircularAOEPrediction(target, Wrange, Wspeed, Wdelay, Wwidth)
         if pos and info.hitchance >= 2 and GetDistance(pos) < Wrange and not UltOn then
            CastSpell(_W, pos.x, pos.z)
         end
    else
         local AOECastPosition, MainTargetHitChance, nTargets = VP:GetCircularAOECastPosition(target, Wdelay, Wradius, Wrange, Wspeed, myHero)
         if GetDistance(AOECastPosition) < Wrange and MainTargetHitChance >= 2 and nTargets >= 1 then
         	if menu.extra.debug then print('Tried to Cast W VPRED') end
          	CastSpell(_W, AOECastPosition.x, AOECastPosition.z)
          	if menu.extra.debug then print('Casted W VPRED') end
         end
    end
  end 
end

function CastE()
      if GetDistance(target) < Erange and not UltOn then 
        CastSpell(_E, target)
      end
end

function CastR()
  if not UltOn then
    for i, enemy in ipairs(GetEnemyHeroes()) do
      if GetDistance(enemy) < Rrange and blCheck(enemy) then
        local rDmg = getDmg("R", enemy, myHero)
        if menu.extra.debug then print(tostring(rDmg)) end
        --[[local AP = getDmg("AD", target, myHero)
        local FullRDamage = (rDmg + (AP*1.2))]]
        if enemy.health < rDmg and enemy.health > 50 then
          CastSpell(_R, enemy)
        end
      end
    end
  end
end

function KS()
  if UltOn then return end
  for i, enemy in pairs(GetEnemyHeroes()) do
  	local rDmg = getDmg("R", enemy, myHero)
  	local qDmg = getDmg("Q", enemy, myHero)
	if enemy.health < eDmg then
		if Eready and GetDistance(enemy) < Erange and menu.killsteal.killstealE then
	    	CastSpell(_E, enemy)
	    end
    elseif enemy.health < qDmg then
      if GetDistance(enemy) < Qrange and Qready and menu.killsteal.killstealQ then
         local pos, info = Prodiction.GeLineAOEPrediction(enemy, Qrange, Qspeed, Qdelay, Qwidth)
         if pos and info.hitchance >= 2 and GetDistance(pos) <= Qrange then
            CastSpell(_Q, pos.x, pos.z)
         end
      end
    elseif enemy.health < rDmg and blCheck(enemy) and menu.killsteal.killstealR and Rready and GetDistance(enemy) < Rrange then
    	CastSpell(_R, enemy)
    end
  end
end

function Harass()

  if menu.harass.mana > (myHero.mana / myHero.maxMana) * 100 then return end
  
  if menu.harass.useQ then
    CastQ()
  end
  
  if menu.harass.useW then
    CastW()
  end
  
  if menu.harass.useE then
    CastE()
  end
end

function Farm()
  if menu.farm.mana > (myHero.mana / myHero.maxMana) * 100 then return end

  for i, minion in pairs(EnemyMinions.objects) do
    if minion ~= nil then
      if minion.health < minion.maxHealth/2 and GetDistance(minion) < Erange and not MinionHasE then
        CastSpell(_E, minion)
      end
    end
  end

end

function DmgCheck()
  for i, enemy in pairs(GetEnemyHeroes()) do
    qDmg = getDmg("Q", enemy, myHero)
    wDmg = getDmg("W", enemy, myHero)
    eDmg = getDmg("E", enemy, myHero)
  end
end

function LaneClear()
  if menu.lane.mana > (myHero.mana / myHero.maxMana) * 100 then return end
  
    for i, minion in pairs(EnemyMinions.objects) do
      if minion ~= nil then
        if menu.lane.useQ and GetDistanceSqr(minion) <= 180625 then CastSpell(_Q, minion.x, minion.z) end
        if menu.lane.useW and GetDistance(minion) <= Wrange then CastSpell(_W, minion.x, minion.z) end
        if menu.lane.useE and GetDistance(minion) <= Erange and minion.health < minion.maxHealth/2 and not MinionHasE then CastSpell(_E, minion) end
      end    
    end
end

--[[function JungleClear()

    for i, minion in pairs(EnemyMinions.objects) do
      if minion ~= nil then
        if menu.lane.useQ and GetDistanceSqr(minion) <= 180625 then CastSpell(_Q, minion.x, minion.z) end
        if menu.lane.useW and GetDistance(minion) <= Wrange then CastSpell(_W, minion.x, minion.z) end
        if menu.lane.useE and GetDistance(minion) <= Erange and minion.health < minion.maxHealth/2 and not MinionHasE then CastSpell(_E, minion) end
      end    
    end

end]]

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

function OnDraw()
  if myHero.dead then return end
  draw_Range()
end

function draw_Range()
  if menu.draw.drawAA then
    DrawCircle(myHero.x, myHero.y, myHero.z, AARange, ARGB(255,100,0,50))
  end
  if menu.draw.drawE and Eready then
    DrawCircle(myHero.x, myHero.y, myHero.z, Erange, ARGB(255,100,0,50))
  end
  if menu.draw.drawQ and Qready then
    DrawCircle(myHero.x, myHero.y, myHero.z, menu.extra.Qrange, ARGB(255,100,0,50))
  end
  if menu.draw.drawW and Wready then
    DrawCircle(myHero.x, myHero.y, myHero.z, Wrange, ARGB(255,100,0,50))
  end
  if menu.draw.drawR and Rready then
    DrawCircle(myHero.x, myHero.y, myHero.z, Rrange, ARGB(255,100,0,50))
  end
end

function OnGainBuff(unit, buff)
  --[[if unit and unit.team ~= myHero.team and buff and buff.name == "AlZaharNetherGrasp" then
    UltOn = true
    LastUlt = os.clock()
    if menu.extra.debug then print('Ulton') end
  end]]
  if unit and unit == EnemyMinions.objects and buff.name == "AlZaharMaleficVisions" then
    MinionHasE = true
  end
end

function OnLoseBuff(unit, buff)
  if unit and buff and buff.name == "AlZaharNetherGrasp" then
    UltOn = false
    if menu.extra.debug then print('Ultoff') end
  end
  if unit and unit == EnemyMinions.objects and buff.name == "AlZaharMaleficVisions" then
    MinionHasE = false
  end
end

--[[function OnCreateObj(obj) 
  if obj.name == "AlzaharNetherGrasp_tar.troy" then
    UltOn = true
  end
end

function OnDeleteObj(obj)
  if obj.name == "AlzaharNetherGrasp_tar.troy" then
    UltOn = false
  end
end]]

--[[function CancelMovement(p)
  if UltOn then
    local packet = Packet(p)
    p:Block()
  end
end]]

function OnSendPacket(packet)
  local packet = Packet(packet)
  if UltOn then
      packet:block()
      if menu.extra.debug then print("Blocked Packetz") end
  else
    if packet:get('name') == 'S_CAST' and packet:get('sourceNetworkId') == myHero.networkID and packet:get('spellId') == 3 then
      UltOn = true
      LastUlt = os.clock()
      if menu.extra.debug then print("UltOn") end
    end
  end
end

function OnBugsplat()
  UpdateWeb(false, ScriptName, id, HWID)
end

function OnUnload()
  UpdateWeb(false, ScriptName, id, HWID)
end


function SkinHack()
if not VIP_USER then return end
  if menu.extra.skin ~= lastSkin then
    lastSkin = menu.extra.skin
    GenModelPacket("Malzahar", menu.extra.skin)
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
