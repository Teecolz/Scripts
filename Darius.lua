----- Credit everyone else for updater -----

local version = "0.1"

local autoupdateenabled = true
local UPDATE_SCRIPT_NAME = "Darius - By Teecolz"
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/Teecolz/Scripts/master/Darius.lua"
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

local ServerData
if autoupdateenabled then
  GetAsyncWebResult(UPDATE_HOST, UPDATE_PATH, function(d) ServerData = d end)
  function update()
    if ServerData ~= nil then
      local ServerVersion
      local send, tmp, sstart = nil, string.find(ServerData, "local version = \"")
      if sstart then
        send, tmp = string.find(ServerData, "\"", sstart+1)
      end
      if send then
        ServerVersion = string.sub(ServerData, sstart+1, send-1)
      end

      if ServerVersion ~= nil and tonumber(ServerVersion) ~= nil and tonumber(ServerVersion) > tonumber(version) then
        DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () print("<font color=\"#FF0000\"><b>"..UPDATE_SCRIPT_NAME..":</b> successfully updated. ("..version.." => "..ServerVersion.."). Press F9 Twice to Re-load.</font>") end)     
      elseif ServerVersion then
        print("<font color=\"#FF0000\"><b>"..UPDATE_SCRIPT_NAME..":</b> You have got the latest version: <u><b>"..ServerVersion.."</b></u></font>")
      end   
      ServerData = nil
    end
  end
  AddTickCallback(update)
end

--------------------

if myHero.charName ~= "Darius" then return end

require 'SOW'
require 'VPrediction'

  PrintChat("Loaded Darius by Tyler - Version 0.1")

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

  ts = TargetSelector(TARGET_LESS_CAST, 2000)
  VP = VPrediction()
  
  Menu = scriptConfig("Darius by Tyler", "DariusCombo")
  Orbwalker = SOW(VP)
           
  Menu:addSubMenu("[Darius - Orbwalker]", "SOWorb")
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
  
  Menu:addSubMenu("Version: 0.1", "version")
  Menu:addSubMenu("Author: Teecolz", "author")

end

function OnTick()

  if myHero.dead then return end
  
  ts:update()
  target = ts.target
  Killsteal()
  AutoQ()
  
  if Menu.DariusCombo.combo then 
    combo() 
  end
end

function AutoQ()

  if ValidTarget(target, 425) and QREADY and Menu.Harass.autoQ then
    CastSpell(_Q)
  end
end

function combo()

  if Menu.DariusCombo.comboQ then UseQ() end 
  if Menu.DariusCombo.comboW then UseW() end
  if Menu.DariusCombo.comboE then UseE() end
  if Menu.DariusCombo.comboR then UseR() end
  
end

function UseQ()

  if ValidTarget(target, Qrange) and QREADY then
    CastSpell(_Q)
    
  end
end

function UseW()

  if ValidTarget(target, Wrange) and WREADY then
    CastSpell(_W)
    
  end
end

function UseE()
  
  if ValidTarget(target, Erange) and EREADY then
    CastSpell(_E, target)

  end
end

function UseR()
  
  if ValidTarget(target, rrange) and RREADY then
    rDmg = (RREADY and getDmg("R", target, myHero) or 0)
    if target.health <= (rDmg) and GetDistance(target) <= RRange and RREADY then
      CastSpell(_R, target)
    end
  end
end

function Killsteal()

        for i=1, heroManager.iCount do
            local target = heroManager:GetHero(i)
            qDmg = getDmg("Q", target, myHero) or 0
        
            if ValidTarget(target, QRange) and QREADY and target.health <= qDmg then
                CastSpell(_Q)
            end
        end
end

function getKillText(target)
     if target then
       qDMG = getDmg("Q", target, myHero) or 0
       wDMG = getDmg("W", target, myHero) or 0
       eDMG = getDmg("E", target, myHero) or 0
       rDMG = getDmg("R", target, myHero) or 0

        if eDMG > target.health then
          return "E Killable"
        end

        if qDMG > target.health then
         return "Q Killable"
        end

       if qDMG + wDMG + eDMG + rDMG > target.health then
          return "Combo Killable"
       end 

       if qDMG + eDMG < target.health then
         return "Harass"
       end

     end
end

function OnDraw()

     if ValidTarget(target) then
         DrawText3D(getKillText(target), target.x, target.y , target.z, 20, ARGB(255, 255, 255, 0), true)
     end
     
     if Menu.drawings.drawCircleE then 
         DrawCircle(myHero.x, myHero.y, myHero.z, Erange, 0x111111)
     end
  
     if Menu.drawings.drawCircleR then
        DrawCircle(myHero.x, myHero.y, myHero.z, Rrange, 0x111111)
     end
end
