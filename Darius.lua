if myHero.charName ~= "Darius" then return end

require 'SOW'
require 'VPrediction'

local version = 0.1
local ts
local VP = nil
local QREADY = (myHero:CanUseSpell(_Q) == READY)
local WREADY = (myHero:CanUseSpell(_W) == READY)
local EREADY = (myHero:CanUseSpell(_E) == READY)
local RREADY = (myHero:CanUseSpell(_R) == READY)
local Qrange = 425
local Wrange = 145
local Erange = 540
local Rrange = 460
local Espeed = 1500
local QReady, WReady, EReady, RReady = false, false, false, false

function OnLoad()

  ts = TargetSelector(TARGET_LESS_CAST, 540)
  VP = VPrediction()
  
  Menu = scriptConfig("Darius by Tyler", "DariusCombo")
  Orbwalker = SOW(VP)
           
  Menu:addSubMenu("Darius - Orbwalker", "SOWorb")
  Orbwalker:LoadToMenu(Menu.SOWorb)
  
  Menu:addTS(ts)
  ts.name = "Focus"
     
  Menu:addSubMenu("[Darius - Combo]", "DariusCombo")
  Menu.DariusCombo:addParam("combo", "Combo", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("T"))
  Menu.DariusCombo:addParam("comboQ", "Use Q in combo", SCRIPT_PARAM_ONOFF, true)
  Menu.DariusCombo:addParam("comboW", "Use W in combo", SCRIPT_PARAM_ONOFF, true)
  Menu.DariusCombo:addParam("comboE", "Use E in combo", SCRIPT_PARAM_ONOFF, true)
  Menu.DariusCombo:addParam("comboR", "Use R in combo [if killable]", SCRIPT_PARAM_ONOFF, true)
  
  Menu:addSubMenu ("[Darius - Harass]", "Harass")
  Menu.Harass:addParam("autoQ", "Auto Q", SCRIPT_PARAM_ONOFF, true)
     
  Menu:addSubMenu("["..myHero.charName.." - Drawing]", "drawings")
  Menu.drawings:addParam("drawCircleE", "Draw E Range", SCRIPT_PARAM_ONOFF, true)
  Menu.drawings:addParam("drawCircleR", "Draw R Range", SCRIPT_PARAM_ONOFF, true)

  Menu.Ads:addParam("ks", "KS With Q", SCRIP_PARAM_ONOFF, true, string.byte("Y"))
  
  Menu:addSubMenu("["..myHero.charName.." - Additionals]", "Ads")
  Menu.Ads:addParam("AutoLevelspells", "Auto-Level Spells", SCRIPT_PARAM_ONOFF, false)
  Menu.Ads:addParam("Killsteal", "Killsteal with Q", SCRIPT_PARAM_ONOFF, false)
  
  PrintChat("Loaded Darius by Tyler - Version 0.1")

end

function OnTick()

  if myHero.dead then return end
  
  ts:update()
  Target = ts.target
  ts:SetPrediction(Espeed)
  Killsteal()

  if ValidTarget(ts.target, 425) and QREADY and Menu.Harass.autoQ then
    CastSpell(_Q)
  end
  
  if Menu.DariusCombo.combo then 
    combo() 
  end
end

function combo()

  if Menu.DariusCombo.comboQ then UseQ() end 
  if Menu.DariusCombo.comboW then UseW() end
  if Menu.DariusCombo.comboE then UseE() end
  if Menu.DariusCombo.comboR then UseR() end
  
end

function UseQ()

  if ValidTarget(ts.target, Qrange) and QREADY then
    CastSpell(_Q)
    
  end
end

function UseW()

  if ValidTarget(ts.target, Wrange) and WREADY then
    CastSpell(_W)
    
  end
end

function UseE()
  
  if ValidTarget(ts.target, Erange) and EREADY then
    CastSpell(_E, ts.target)

  end
end

function UseR()
  
  if ValidTarget(ts.target, rrange) and RREADY then
    rDmg = (RREADY and getDmg("R", ts.target, myHero) or 0)
    if enemy.health <= (rDmg) and GetDistance(ts.target) <= RRange and RREADY then
      CastSpell(_R, ts.target)
    end
  end
end

function Killsteal()

        for i, target in pairs(GetEnemyHeroes()) do
            qDmg = getDmg("Q", ts.target, myHero)
        
            if ValidTarget(ts.target, QRange) and QREADY and enemy.health < qDmg then
                CastSpell(_Q)
            end
        end
end

function OnDraw()

     if Menu.drawings.drawCircleE then 
         DrawCircle(myHero.x, myHero.y, myHero.z, Erange, 0x111111)
     end
  
     if Menu.drawings.drawCircleR then
        DrawCircle(myHero.x, myHero.y, myHero.z, Rrange, 0x111111)
     end
end
