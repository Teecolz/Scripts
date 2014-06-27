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
  
local QReady, WReady, EReady, RReady = false, false, false, false

local MyBasicRange = 7

function OnLoad()
  ts = TargetSelector(TARGET_LESS_CAST, 1200)
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
  Menu.LeonaCombo:addParam("comboR", "Use R in combo [Not functional yet]", SCRIPT_PARAM_ONOFF, false)
     
  Menu:addSubMenu("[Drawing]", "drawings")
  Menu.drawings:addParam("drawCircleE", "Draw E Range", SCRIPT_PARAM_ONOFF, true)
  Menu.drawings:addParam("drawCircleR", "Draw R Range", SCRIPT_PARAM_ONOFF, true)
  
  PrintChat("Loaded Leona by Tyler")
end

function OnTick()
  ts:update()
  Target = ts.target
  ts:SetPrediction(Espeed)
    
  if myHero.dead then return end
  
  if Menu.LeonaCombo.combo then combo() end
end
  
--[[function OnDraw()
  if not myHero.dead then
      if Menu.draw.drawE and EREADY then
          DrawCircle(myHero.x, myHero.y, myHero.z, Erange, 0x111111)
      end
      if Menu.draw.drawR and RREADY then
          DrawCircle(myHero.x, myHero.y, myHero.z, Rrange, 0x111111)
      end
  end
end]]
function OnDraw()

    if Menu.drawings.drawCircleE then
        DrawCircle(myHero.x, myHero.y, myHero.z, 875, 0x111111)
    end
  
    if Menu.drawings.drawCircleR then
        DrawCircle(myHero.x, myHero.y, myHero.z, 1200, 0x111111)
    end
end

function combo()
  if Menu.LeonaCombo.comboQ then UseQ() end
  if Menu.LeonaCombo.comboW then UseW() end
  if Menu.LeonaCombo.comboE then UseE() end
  
end

function UseQ()
  if ts.target ~=nil and ValidTarget(ts.target, 175) then
    CastSpell(_Q)
  end
end

function UseW()
  if ts.target ~=nil and ValidTarget(ts.target, 275) then
    CastSpell(_W)
  end
end

function UseE()
    if ts.target ~=nil and ValidTarget(ts.target, 875) and EREADY then
        for i, target in pairs(GetEnemyHeroes()) do
      local CastPosition,  HitChance,  Position = VP:GetLineCastPosition(ts.target, 900, 85, 2000, 0.25, myHero, true)
        if HitChance >= 2 and GetDistance(CastPosition) < 875 then
            CastSpell(_E, CastPosition.x, CastPosition.z)
            end
        end
    end
end
  
  --[[if ts.target ~= nil then distancetstarget = GetDistance(ts.target) end
  
  if EREADY and Menu.LeonaCombo.comboE and ts.target ~= nil and ValidTarget(ts.target, 875) then
    CastSpell(_E, ts.nextPosition.x, ts.nextPosition.z)
  end]]
    
  --[[if ts.target ~= nil and ValidTarget(ts.target, 875) and Menu.LeonaCombo.comboE then
    local CastPosition,  HitChance,  Position = VP:GetLineCastPosition(ts.target, erange, ewidth, espeed, edelay, myHero, true)
    if GetDistance(ts.target) <= erange and myHero:CanUseSpell(_E) == READY then 
      CastSpell(_E, CastPosition.x, CastPosition.z)
    end]]
    
  --[[end
  
  if WREADY and Menu.LeonaCombo.comboW and ts.target ~= nil and ValidTarget(ts.target, 400) then
     CastSpell(_W)
  end 
  
  if ts.target ~= nil and ValidTarget(ts.target, 175) then
    if QREADY then
      CastSpell(_Q)
    end
  end
end]]

--[[ could also try this: 
  if Menu.Draw.W and WREADY then DrawCircle(myHero.x,myHero.y,myHero.z,Tryndamere.W["range"],0x00FFFF) end
  if Menu.Draw.E and EREADY then DrawCircle(myHero.x,myHero.y,myHero.z,Tryndamere.E["range"],0x00FFFF) end
end

    ]]

