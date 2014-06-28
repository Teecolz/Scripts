if myHero.charName ~= "Leona" then return end

--[[Credit everyone else for Auto updater]]

local version = "0.3"
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

if myHero.charName ~= "Leona" then return end

require 'SOW'
require 'VPrediction'

local ts
local target = nil
local VP = nil
local Qrange, Qwidth, Qspeed, Qdelay = 215, 1, 7777, 0.01
local Wrange, Wwidth, Wspeed, Wdelay = 1, 500, 1, 3 
local Erange, Ewidth, Espeed, Edelay = 900, 85, 2000, 0.25
local Rrange, Rwidth, Rspeed, Rdelay = 1200, 315, math.huge, 0.5
local QREADY = (myHero:CanUseSpell(_Q) == READY)
local WREADY = (myHero:CanUseSpell(_W) == READY)
local EREADY = (myHero:CanUseSpell(_E) == READY)
local RREADY = (myHero:CanUseSpell(_R) == READY)
local abilitySequence = {3, 1, 2, 2, 2, 4, 2, 1, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3} 
local qOff, wOff, eOff, rOff = 0,0,0,0
  
local QReady, WReady, EReady, RReady = false, false, false, false

function OnLoad()
  ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1200, DAMAGE_MAGIC)
  VP = VPrediction()
  
  Menu = scriptConfig("Leona by Tyler", "LeonaCombo")
  Orbwalker = SOW(VP)
           
  Menu:addSubMenu("[Leona - Orbwalker]", "SOWorb")
  Orbwalker:LoadToMenu(Menu.SOWorb)
  
  Menu:addTS(ts)
  ts.name = "Focus"
     
  Menu:addSubMenu("[Leona - Combo]", "LeonaCombo")
  Menu.LeonaCombo:addParam("combo", "Combo mode", SCRIPT_PARAM_ONKEYDOWN, false, 32)
  Menu.LeonaCombo:addParam("comboQ", "Use Q in combo", SCRIPT_PARAM_ONOFF, true)
  Menu.LeonaCombo:addParam("comboW", "Use W in combo", SCRIPT_PARAM_ONOFF, true)
  Menu.LeonaCombo:addParam("comboE", "Use E in combo", SCRIPT_PARAM_ONOFF, true)
  Menu.LeonaCombo:addParam("comboR", "Use R in combo", SCRIPT_PARAM_ONOFF, false)
  Menu.LeonaCombo:addParam("autoult", "Auto Use Ultimate", SCRIPT_PARAM_ONOFF, false)
  Menu.LeonaCombo:addParam("minR", "Minimum Enemies to Cast R on", SCRIPT_PARAM_SLICE, 3, 1, 5, 0)
     
  Menu:addSubMenu("[Drawing]", "drawings")
  Menu.drawings:addParam("drawCircleE", "Draw E Range", SCRIPT_PARAM_ONOFF, true)
  Menu.drawings:addParam("drawCircleR", "Draw R Range", SCRIPT_PARAM_ONOFF, true)
  
  Menu:addSubMenu("[Additional Stuff]", "Ads")
  Menu.Ads:addParam("AutoLevelspells", "Auto Level Spells", SCRIPT_PARAM_ONOFF, true)
  
  
  PrintChat("Loaded Leona by Tyler")
end

function OnTick()
  ts:update()
  target = ts.target
  ts:SetPrediction(2000)
  
  if Menu.Ads.AutoLevelspells then 
    AutoLevel()
  end
  
  if Menu.LeonaCombo.combo then combo() end
  
  AutoUlt()
  
end
  
function OnDraw()

    if Menu.drawings.drawCircleE then
        DrawCircle(myHero.x, myHero.y, myHero.z, 875, 0x111111)
    end
  
    if Menu.drawings.drawCircleR then
        DrawCircle(myHero.x, myHero.y, myHero.z, 1200, 0x111111)
    end
end

function combo()

  if Menu.LeonaCombo.comboQ and QREADY then UseQ() end
  if Menu.LeonaCombo.comboW and WREADY then UseW() end
  if Menu.LeonaCombo.comboE and EREADY then UseE() end
  if Menu.LeonaCombo.comboR and RREADY then UseR() end
  
end

function UseQ()
  if target ~= nil and ValidTarget(target, 175) then
    CastSpell(_Q)
  end
end

function UseW()
  if target ~= nil and ValidTarget(target, 275) then
    CastSpell(_W)
  end
end

function UseE()
    if ValidTarget(target, 875) and EREADY then
        for i, target in pairs(GetEnemyHeroes()) do
         local CastPosition,  HitChance,  Position = VP:GetLineCastPosition(target, 875, 85, 2000, 0.25)
        if HitChance >= 2 and GetDistance(CastPosition) < 875 then
            CastSpell(_E, CastPosition.x, CastPosition.z)
            end
        end
    end
end

function UseR()

    if target ~= nil and ValidTarget(target, 1200) and RREADY then
      local CastPosition, Hitchance = VP:GetCircularAOECastPosition(target, .25, 300, 1200, 20)
      if CastPosition ~= nil and GetDistance(CastPosition) <= 1200 and Hitchance >= 2 and Menu.LeonaCombo.comboR then
        CastSpell(_R, CastPosition.x, CastPosition.z)
      end
    end
end

function AutoUlt()

  if target ~= nil and ValidTarget(1200) and Menu.LeonaCombo.autoult and RREADY then
    local CastPosition, nTargets = VP:GetCircularAOECastPosition(target, .25, 300, 1200, 20)
    if CastPosition ~= nil and GetDistance(CastPosition) <= 1200 and nTargets and nTargets >= Menu.LeonaCombo.minR then
          CastSpell(_R, CastPosition.x, CastPosition.z)
    end
  end
end

function AutoLevel()
    local qL, wL, eL, rL = player:GetSpellData(_Q).level + qOff, player:GetSpellData(_W).level + wOff, player:GetSpellData(_E).level + eOff, player:GetSpellData(_R).level + rOff
    if qL + wL + eL + rL < player.level then
        local spellSlot = { SPELL_1, SPELL_2, SPELL_3, SPELL_4, }
        local level = { 0, 0, 0, 0 }
        for i = 1, player.level, 1 do
            level[abilitySequence[i]] = level[abilitySequence[i]] + 1
        end
        for i, v in ipairs({ qL, wL, eL, rL }) do
        if v < level[i] then LevelSpell(spellSlot[i]) end
        end
    end
end
