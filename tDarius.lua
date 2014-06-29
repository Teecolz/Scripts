if myHero.charName ~= "Darius" then return end

--[[Credit everyone else for Auto updater]]

local version = "1.0"
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

if myHero.charName ~= "Darius" then return end

require 'SOW'
require 'VPrediction'

  PrintChat("Loaded tDarius by Teecolz")

local ts
local VP = nil
local enemyTable = {}
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
local qOff, wOff, eOff, rOff = 0,0,0,0
local abilitySequence = {1, 3, 1, 2, 1, 4, 1, 2, 1, 2, 4, 2, 3, 2, 3, 4, 3, 3} 

function OnLoad()

  ts = TargetSelector(TARGET_LESS_CAST, 2000)
  VP = VPrediction()
  
  Menu = scriptConfig("tDarius by Teecolz", "DariusCombo")
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
     
  Menu:addSubMenu("[Darius - Drawing]", "drawings")
  Menu.drawings:addParam("drawCircleE", "Draw E Range", SCRIPT_PARAM_ONOFF, true)
  Menu.drawings:addParam("drawCircleR", "Draw R Range", SCRIPT_PARAM_ONOFF, true)
  
  Menu:addSubMenu("[Darius - Additionals]", "Ads")
  Menu.Ads:addParam("AutoLevelspells", "Auto-Level Spells", SCRIPT_PARAM_ONOFF, false)
  Menu.Ads:addParam("Killsteal", "Killsteal with Q", SCRIPT_PARAM_ONOFF, false)
  
  Menu:addParam("Version: 0.1", "version")
  Menu:addParam("Author: Teecolz", "author")
  
  for i=0, heroManager.iCount, 1 do
        local enemy = heroManager:GetHero(i)
        if enemy and enemy.team ~= myHero.team then
                enemy.stack = 0
                table.insert(enemyTable, enemy)
        end
  end
end

function OnTick()

  if myHero.dead then return end
  
  ts:update()
  target = ts.target
  Killsteal()
  AutoQ()
  
  if Menu.Ads.AutoLevelspells then 
    AutoLevel()
  end
  
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

  if target ~= nil and ValidTarget(target, Qrange) and QREADY then
    CastSpell(_Q)
  end
end

function UseW()

  if target ~= nil and ValidTarget(target, 500) and WREADY then
    CastSpell(_W)
  end
end

function UseE()
  
  if ValidTarget(target, 540) and EREADY then
    CastSpell(_E, target.x, target.z)
  end
end

function UseR()

   for i=1, heroManager.iCount do
      local target = heroManager:GetHero(i)
      local multiplier = 1
      if GetDistance(target) < 550 then
        for i, enemy in pairs(enemyTable) do
            if enemy.name == target.name then
                multiplier = GetMultiplier(enemy.stack)
            end
        end
      end

      local rDmg = multiplier * getDmg("R", target, myHero)
      if RREADY and target.health <= rDmg and GetDistance(target) <= 460 then
        CastSpell(_R, target)
      end
   end
  
end

function Killsteal()

        for i=1, heroManager.iCount do
            local target = heroManager:GetHero(i)
            qDmg = getDmg("Q", target, myHero) or 0
        
            if ValidTarget(target) and GetDistance(target) <= 425 and QREADY and target.health <= qDmg then
                CastSpell(_Q)
            end
        end
end

function getKillText(target)
     if target then
       qDmg = getDmg("Q", target, myHero) or 0
       wDmg = getDmg("W", target, myHero) or 0
       eDmg = getDmg("E", target, myHero) or 0
       rDmg = getDmg("R", target, myHero) or 0

        if eDmg > target.health then
          return "E Killable"
        end

        if qDmg > target.health then
         return "Q Killable"
        end

       if qDmg + wDmg + eDmg + rDmg > target.health then
          return "Combo Killable"
       end 

       if qDmg + eDmg < target.health then
         return "Harass"
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

--[[ Credit Trees & Fuggi]]
function GetMultiplier(stacks)

  return 1 + stacks/5
 
end

function OnGainBuff(unit, buff)
  if unit and unit.team ~= myHero.team and buff.name == "dariushemo" then
      for i, enemy in pairs(enemyTable) do
          if enemy.name == unit.name then
              enemy.stack = 1
          end
      end
  end
end

function OnLoseBuff(unit, buff)
  if buff.name == "dariushemo" then
   for i, enemy in pairs(enemyTable) do
          if enemy.name == unit.name then
              enemy.stack = 0
          end
   end
  end
end

function OnUpdateBuff(unit, buff)
  if buff.name == "dariushemo" then
    for i, enemy in pairs(enemyTable) do
         if enemy.name == unit.name then
              enemy.stack = buff.stack
         end
    end
  end
end
-- [[End Credit Trees & Fuggi]]

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
