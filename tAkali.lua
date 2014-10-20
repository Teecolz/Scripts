-- Continuation of Akali by Jarvis101


if myHero.charName ~= "Akali" then return end


local version = "1.0"
local AUTOUPDATE = false


local SCRIPT_NAME = "tAkali"
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

require "SOW"
require "VPrediction"

function OnLoad()
	VP = VPrediction()
	SOWi = SOW(VP)
	SOWi:RegisterAfterAttackCallback(AutoAttackRese)
	_G.oldDrawCircle = rawget(_G, 'DrawCircle')
	_G.DrawCircle = DrawCircle2
	Menu()
	init()
	print("<font color='#aaff34'>tAkali -- Loaded Successfully</font>")
end

function Menu()
	Menu = scriptConfig("tAkali", "tAkali")
	
	Menu:addParam("ver", "Version", SCRIPT_PARAM_INFO, tostring(version))
	
	Menu:addSubMenu("tAkali - Combo Settings", "combo")
	Menu.combo:addParam("CuseIgnite","Use Ignite if killable", SCRIPT_PARAM_ONOFF, true)
	Menu.combo:addParam("CuseQ","Use Q in Combo", SCRIPT_PARAM_ONOFF, true)
	Menu.combo:addParam("CuseW","Use W in Combo", SCRIPT_PARAM_ONOFF, true)
	Menu.combo:addParam("CuseE","Use E in Combo", SCRIPT_PARAM_ONOFF, true)
	Menu.combo:addParam("CuseR","Use R in Combo", SCRIPT_PARAM_ONOFF, true)
	Menu.combo:addParam("CuseRchase","only use R to chase", SCRIPT_PARAM_ONOFF, true)
	Menu.combo:addParam("CuseRchaseHP","if enemy is below % HP", SCRIPT_PARAM_SLICE, 50, 0, 101, 0)
	Menu.combo:addParam("CuseRchaseDistance","Minimum Distance to chase", SCRIPT_PARAM_SLICE, 350, 0, 800, 0)
	
	Menu:addSubMenu("tAkali - Harass Settings", "harass")
	Menu.harass:addParam("useQ","Use Q in Harass", SCRIPT_PARAM_ONOFF, true)
	Menu.harass:addParam("useE","Use E in Harass", SCRIPT_PARAM_ONOFF, true)
	Menu.harass:addParam("useQFarm","Use Q to farm", SCRIPT_PARAM_ONOFF, true)
	Menu.harass:addParam("useEFarm","Use E to farm", SCRIPT_PARAM_ONOFF, true)
	
	Menu:addSubMenu("tAkali - Lane Clear Settings", "lane")
	Menu.lane:addParam("LCuseQ","Use Q to farm", SCRIPT_PARAM_ONOFF, true)
	Menu.lane:addParam("LCuseE","Use E to farm", SCRIPT_PARAM_ONOFF, true)
	Menu.lane:addParam("LCuseAA","AutoAttack", SCRIPT_PARAM_ONOFF, true)
	Menu.lane:addParam("LCmMove","Move to Mouse", SCRIPT_PARAM_ONOFF, true)
	
	Menu:addSubMenu("tAkali - Skill Settings", "skill")
	Menu.skill:addParam("Qblock","Block Q use if target is marked", SCRIPT_PARAM_ONOFF, true)
	Menu.skill:addParam("useEonlyifQ","Only use E on Q marked targets", SCRIPT_PARAM_ONOFF, true)
	Menu.skill:addParam("packets", "Use Packets to cast Spells", SCRIPT_PARAM_ONOFF, true)
	
	Menu:addSubMenu("tAkali - Kill Steal", "KS")
	Menu.KS:addParam("Q","Use Q", SCRIPT_PARAM_ONOFF, true)
	Menu.KS:addParam("E","Use E", SCRIPT_PARAM_ONOFF, true)
	Menu.KS:addParam("R","Use R", SCRIPT_PARAM_ONOFF, true)
	
	Menu:addParam("Combo","Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
	Menu:addParam("Harass","Harass", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
	Menu:addParam("LaneClear","LaneClear", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("N"))
	Menu:addParam("Flee","Flee", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("S"))
	
	Menu:addSubMenu("tAkali - Item Settings", "item")
	Menu.item:addParam("iCombo", "Use Items in Combo", SCRIPT_PARAM_ONOFF, true)
	Menu.item:addParam("smartdfg", "Use smart DFG", SCRIPT_PARAM_ONOFF, false)
	Menu.item:addParam("null", "Use DFG if it reduces #", SCRIPT_PARAM_ONOFF, true)
	Menu.item:addParam("DFGnComboControl", "of Combos to kill to (0 is ks)", SCRIPT_PARAM_SLICE, 2, 0, 3, 0)
	
	Menu:addSubMenu("tAkali - Draw Settings", "draw")
	Menu.draw:addParam("drawQ", "Draw Q radius", SCRIPT_PARAM_ONOFF, true)
	Menu.draw:addParam("drawE", "Draw E radius", SCRIPT_PARAM_ONOFF, true)
	Menu.draw:addParam("drawWcd", "W count down", SCRIPT_PARAM_ONOFF, true)
	Menu.draw:addParam("drawR", "Draw R radius", SCRIPT_PARAM_ONOFF, true)
	Menu.draw:addParam("drawTar", "Draw red circle on target", SCRIPT_PARAM_ONOFF, true)
	Menu.draw:addParam("drawKill", "Draw Killable", SCRIPT_PARAM_ONOFF, true)

	Menu.draw:addSubMenu("LagFreeCircles: ", "LFC")
	Menu.draw.LFC:addParam("LagFree", "Activate Lag Free Circles", SCRIPT_PARAM_ONOFF, false)
	Menu.draw.LFC:addParam("CL", "Length before Snapping", SCRIPT_PARAM_SLICE, 350, 75, 2000, 0)
	Menu.draw.LFC:addParam("CLinfo", "Higher length = Lower FPS Drops", SCRIPT_PARAM_INFO, "")
	
	Menu:permaShow("Combo")
    Menu:permaShow("LaneClear")
    Menu:permaShow("Harass")
	Menu:permaShow("Flee")
	
	Menu:addSubMenu("tAkali - Orbwalker", "SOWiorb")	
	SOWi:LoadToMenu(Menu.SOWiorb)
end

function checkItems()
    Omen = GetInventorySlotItem(3143)
    BilgeWaterCutlass = GetInventorySlotItem(3144)
	HexTech = GetInventorySlotItem(3146)
    OmenR = (Omen ~= nil and myHero:CanUseSpell(Omen))
	HexTechR = (HexTech ~= nil and myHero:CanUseSpell(HexTech))
    BilgeWaterCutlassR = (BilgeWaterCutlass ~= nil and myHero:CanUseSpell(BilgeWaterCutlass))
	Lich = GetInventorySlotItem(3100)
	LichR = (Lich ~= nil and myHero:CanUseSpell(Lich) == READY)
	DFG = GetInventorySlotItem(3128)
	DFGR = (DFG ~= nil and myHero:CanUseSpell(DFG) == READY)
end

function init()
	ts = TargetSelector(TARGET_NEAR_MOUSE, 1300, DAMAGE_PHYSICAL)	
	ts.name = "Akali"
	Menu:addTS(ts)
	AttackDistance = 125
	lastAttack = 0
	enemyMinions = minionManager(MINION_ENEMY, 800, myHero)
	jungleMinions = minionManager(MINION_JUNGLE, 800, myHero)
	if myHero:GetSpellData(SUMMONER_1).name:find("SummonerDot") then 
		ignite = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find("SummonerDot") then 
		ignite = SUMMONER_2
	else 
		ignite = nil
	end
	haveBuff = false
	minionAtkVal = 0
	AAwind = 0
	AAanim = 0
	Wpos = nil
end

function getAAdmg(targ)
	local Mdmg = getDmg("P", targ, myHero)
	local Admg = getDmg("AD", targ, myHero)
	local returnval = Mdmg + Admg
	return returnval
end

---------------------------------------------------------------------
--- Lag Free Circles ------------------------------------------------
---------------------------------------------------------------------
function LFCfunc()
	if not Menu.draw.LFC.LagFree then _G.DrawCircle = _G.oldDrawCircle end
	if Menu.draw.LFC.LagFree then _G.DrawCircle = DrawCircle2 end
end

function DrawCircleNextLvl(x, y, z, radius, width, color, chordlength)
    radius = radius or 300
	quality = math.max(8,round(180/math.deg((math.asin((chordlength/(2*radius)))))))
	quality = 2 * math.pi / quality
	radius = radius*.92
    local points = {}
    for theta = 0, 2 * math.pi + quality, quality do
        local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
        points[#points + 1] = D3DXVECTOR2(c.x, c.y)
    end
    DrawLines2(points, width or 1, color or 4294967295)
end

function round(num) 
 if num >= 0 then return math.floor(num+.5) else return math.ceil(num-.5) end
end

function DrawCircle2(x, y, z, radius, color)
    local vPos1 = Vector(x, y, z)
    local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
    local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
    local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
    if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y }) then
        DrawCircleNextLvl(x, y, z, radius, 1, color, Menu.draw.LFC.CL) 
    end
end

function OnDraw()
	if Menu.draw.drawQ then
		DrawCircle(myHero.x, myHero.y, myHero.z, 600, ARGB(214,1,33,0))
	end
	if Menu.draw.drawE then
		DrawCircle(myHero.x, myHero.y, myHero.z, 325, ARGB(214,1,33,0))
	end
	if Menu.draw.drawR then
		DrawCircle(myHero.x, myHero.y, myHero.z, 800, ARGB(214,1,33,0))
	end
	if Menu.draw.drawKill then
		for i=1, heroManager.iCount, 1 do
			local champ = heroManager:GetHero(i)
			if ValidTarget(champ) and champ.team ~= myHero.team then
				DrawText3D(analyzeCombat(champ), champ.x, champ.y, champ.z, 20, RGB(255, 255, 255), true)
			end
		end
	end
	if Menu.draw.drawTar and Target ~= nil then 
		DrawCircle(Target.x, Target.y, Target.z, 50, ARGB(214, 214, 1,33))
	end
	if Menu.draw.drawWcd and Wcd ~= nil then
		DrawText3D(Wcount(), Wpos.x, Wpos.y, Wpos.z, 30, RGB(255,255,255), true)
	end
end

-----------

function Wcount()
	return tostring(math.ceil(Wcd - os.clock()))
end

function OnTick()
	--Combo
	QReady = (myHero:CanUseSpell(_Q) == READY)
	WReady = (myHero:CanUseSpell(_W) == READY)
	EReady = (myHero:CanUseSpell(_E) == READY)
	RReady = (myHero:CanUseSpell(_R) == READY)
	IReady = (ignite ~= nil and myHero:CanUseSpell(ignite) == READY)
	ts:update()
	enemyMinions:update()
	checkItems() --thanks fuggi--
	Target = ts.target
	AttackDistance = 150
	KS()
	if Menu.Combo then
		Combo(Target)
	end
	if Menu.Harass then
		Harass(Target)
	end
	if Menu.LaneClear then
		LaneClear()
	end
	if Menu.Flee then
		Flee()
	end
end

function OnCreateObj(obj)
	if obj.isMe and (obj.name == "purplehands_buf.troy" or obj.name == "enrage_buf.troy") then
		haveBuff = true
	end
	if obj.name == "akali_smoke_bomb_tar_team_green.troy" then
		Wpos = obj
		Wcd = os.clock() + 8
	end
end

function OnDeleteObj(obj)
	if obj.isMe and (obj.name == "purplehands_buf.troy" or obj.name == "enrage_buf.troy") then
		haveBuff = false
	end
	if obj.name == "akali_smoke_bomb_tar_team_green.troy" then
		Wcd = nil
		Wpos = nil
	end
end

function OnProcessSpell(obj, spell)
	if obj.isMe and spell.name:lower():find("attack") then
		AAwind = spell.windUpTime
		AAanim = spell.animationTime
	end
end

function Flee()
	local mPos = getNearestMinion(mousePos)
	if RReady and mPos ~= nil and GetDistance(mPos, mousePos) < GetDistance(mousePos) then
		useR(mPos) 
	else 
		local MousePos = Vector(mousePos.x, mousePos.y, mousePos.z)
        local Position = myHero + (Vector(MousePos) - myHero):normalized()*300
        myHero:MoveTo(Position.x, Position.z)
	end
end

function getNearestMinion(unit)
	local closestMinion = nil
	local nearestDistance = 0

		enemyMinions:update()
		jungleMinions:update()
		for index, minion in pairs(enemyMinions.objects) do
			if minion ~= nil and minion.valid and string.find(minion.name,"Minion_") == 1 and minion.team ~= player.team and minion.dead == false then
				if GetDistance(minion) <= 800 then
					if nearestDistance < GetDistance(unit, minion) then
						nearestDistance = GetDistance(minion)
						closestMinion = minion
					end
				end
			end
		end
		for index, minion in pairs(jungleMinions.objects) do
			if minion ~= nil and minion.valid and minion.dead == false then
				if GetDistance(minion) <= 800 then
                    if nearestDistance < GetDistance(unit, minion) then
						nearestDistance = GetDistance(minion)
						closestMinion = minion
					end
				end
			end
		end
		for i = 1, heroManager.iCount, 1 do
			local minion = heroManager:getHero(i)
			if ValidTarget(minion, 800) then
				if GetDistance(minion) <= 800 then
                    if nearestDistance < GetDistance(unit, minion) then
						nearestDistance = GetDistance(minion)
						closestMinion = minion
					end
				end
			end
		end
	return closestMinion
end

function Combo(targ)
	if targ ~= nil then
		if Menu.item.iCombo and DFGR and GetDistance(targ) < 500 then
			useDFG(targ)
		end
		if Menu.item.iCombo and HexTechR and GetDistance(targ) < 500 then
			CastSpell(HexTech, targ)
		end
		if Menu.item.iCombo and OmenR and GetDistance(targ) < 500 then
			CastSpell(Omen, targ)
		end
		if Menu.item.iCombo and BilgeWaterCutlassR and GetDistance(targ) < 500 then
			CastSpell(BilgeWaterCutlass, targ)
		end
		if Menu.combo.CuseIgnite and IReady and GetDistance(targ) < 600 and targ.health <= (50 + (20 * myHero.level))then
			CastSpell(ignite, targ)
		end
		if Menu.combo.CuseQ and QReady then
			checkQ(targ)
		end
		if Menu.combo.CuseE and EReady then
			checkE(targ)
		end
		if Menu.combo.CuseR and RReady then
			
			if Menu.combo.CuseRchase then
				if ((Target.health/Target.maxHealth)*100) < Menu.combo.CuseRchaseHP and GetDistance(Target) > Menu.combo.CuseRchaseDistance and GetDistance(Target, myHero) < 800 then
					useR(targ)
				end
			else
				useR(targ)
			end
		end
		if Menu.combo.CuseW and WReady then
			useW(targ)
		end
	end
end

function Harass(targ)
	if Target ~= nil then
		if Menu.harass.useQ and QReady then
			if QReady and AttackDistance < 600 then
				AttackDistance = 600
			end
			useQ(targ)
		end
		if Menu.harass.useE and EReady then
			checkE(targ)
		end
	end
	if Menu.harass.useEFarm or Menu.harass.useQFarm then
		
		local tar = nil
		local minRange = 1000
		local isEable = false
		enemyMinions:update()
		if Menu.harass.useEFarm then
			enemyMinions.range = 320
		end
		if Menu.harass.useQFarm then
			enemyMinions.range = 600
		end
		for i, minion in pairs(enemyMinions.objects) do
			if minion ~= nil then
				minRange = GetDistance(minion)
				if minion.health < getDmg("E", minion, myHero) and minRange < 315 and minRange > 175 and Menu.harass.useEFarm then
					tar = minion
					minionAtkVal = 2
					isEable = true
					break
				elseif  minion.health < getDmg("Q", minion, myHero) and minRange < 600 and minRange > 315 and Menu.harass.useQFarm and not isEable then
					tar = minion
					minionAtkVal = 3
					break
				else
					tar = nil
				end
			end
		end
		if tar ~= nil then
			if Menu.harass.useQFarm and QReady and minionAtkVal == 3 then
				if GetDistance(tar) < 600 then
					useQ(tar)
				end
			end
			if Menu.harass.useEFarm and EReady and minionAtkVal == 2 then
				if GetDistance(tar) < 300 then
				useE(tar)
				end
			end
		end
	end
end


function LaneClear()
	local mosthp = 0
	local leasthp = 10000
	local tar = nil
	local Admg = 0
	enemyMinions:update()
	jungleMinions:update()
	for i, minion in pairs(enemyMinions.objects) do
		if minion ~= nil then
			if minion.health < leasthp then
				tar = minion
				leasthp = minion.health
			end
		end
	end
	for i, minion in pairs(jungleMinions.objects) do
		if minion ~= nil then
			if minion.health > mosthp then
				tar = minion
				mosthp = minion.health
			end
		end
	end
	if tar ~= nil then
		if Menu.lane.LCuseQ and QReady then
			useQ(tar)
		end
		if Menu.lane.LCuseE and EReady then
			useE(tar)
		end
	end
end

function useQ(targ)
	if Menu.skill.packets and GetDistance(targ, myHero) < 600 then
		Packet("S_CAST", {spellId = _Q, targetNetworkId = targ.networkID}):send()
	else
		if GetDistance(targ, myHero) < 600 then
			CastSpell(_Q, targ)
		end
	end
end

function useE(targ)
	if Menu.skill.packets and GetDistance(targ, myHer0) < 325 then
		 Packet("S_CAST", {spellId = _E}):send()
	else
	if GetDistance(targ, myHero) < 325 then
		CastSpell(_E)
	end
	end
end

function useR(targ)
	if Menu.skill.packets and GetDistance(targ, myHero) < 800 then
		Packet("S_CAST", {spellId = _R, targetNetworkId = targ.networkID}):send()
	end
	if GetDistance(targ, myHero) < 800 then
		CastSpell(_R, targ)
	end
end

function useW(targ)
	if targ == nil then targ = myHero end
	if Menu.skill.packets and GetDistance(targ, myHero) < 700 then
		Packet("S_CAST", {spellId = _Q, toX = targ.x, toY = targ.z, fromX = targ.x, fromY = targ.z}):send()
	end
	if GetDistance(targ, myHero) < 700 then
		CastSpell(_W, targ)
	end
end

function useDFG(targ)
	if Menu.item.smartdfg then
		local Qdmg = getDmg("Q", targ, myHero, 3)
		local Edmg = getDmg("E", targ, myHero)
		local Rdmg = getDmg("R", targ, myHero)
		local AAdmg = getDmg("AD", targ, myHero)
		local Lichdmg = (Lich and getDmg("LICHBANE", targ, myHero) or 0)
		local HexTechdmg = (HexTech and getDmg("HXG", targ, myHero) or 0)
		local Blgdmg = (BilgeWaterCutlass and getDmg("BWC", targ, myHero) or 0)
		local dfgdmg = (DFG and getDmg("DFG", targ, myHero) or 0)
		local Cdmg = Qdmg + Edmg + Rdmg + AAdmg
		
		if targ.health > Cdmg*Menu.item.DFGnComboControl + HexTechdmg + Blgdmg + Lichdmg and targ.health - dfgdmg < ((Cdmg*Menu.item.DFGnComboControl)- Cdmg) + ((HexTechdmg + Blgdmg + Lichdmg + Cdmg)*1.2) then
			CastSpell(DFG, targ)
		end
	else
		local dfgdmg = (DFG and getDmg("DFG", targ, myHero) or 0)
		if targ.health > dfgdmg then
			CastSpell(DFG, targ)
		end
	end
end

-- Full credit to Jarvis101 
function analyzeCombat(targ)
	local Qdmg = getDmg("Q", targ, myHero, 3)
	local Edmg = getDmg("E", targ, myHero)
	local Rdmg = getDmg("R", targ, myHero)
	local AAdmg = getDmg("AD", targ, myHero)
	local Cdmg = Qdmg + Edmg + Rdmg + AAdmg
	local Lichdmg = (Lich and getDmg("LICHBANE", targ, myHero) or 0)
	local HexTechdmg = (HexTech and getDmg("HXG", targ, myHero) or 0)
	local Blgdmg = (BilgeWaterCutlass and getDmg("BWC", targ, myHero) or 0)
	local rTxt = ""
	
	if not LichR and not HexTechR and not BilgeWaterCutlassR then
		if (targ.health < Rdmg and RReady) or (targ.health < Qdmg and QReady) then
			rTxt = "MURDER HIM!"
		elseif targ.health < Qdmg + Edmg and QReady and RReady then
			rTxt = "Q + E"
		elseif targ.health < Cdmg and QReady and EReady and RReady then
			rTxt = "Combo Him!"
		elseif targ.health < Cdmg*2 and QReady and EReady and RReady then
			rTxt = "Combo x2"
		elseif targ.health < Cdmg*3 and QReady and EReady and RReady then
			rTxt = "Combo x3"
		else
			rTxt = "Harassable"
		end
	elseif not LichR and BilgeWaterCutlassR then
		if targ.health < Rdmg and RReady then
			rTxt = "Ult Him!"
		elseif targ.health < Qdmg + Edmg and QReady and EReady then
			rTxt = "Q + E"
		elseif targ.health < Cdmg + Blgdmg and QReady and EReady and RReady then
			rTxt = "Combo Him!"
		elseif targ.health < Cdmg*2 + Blgdmg and QReady and EReady and RReady then
			rTxt = "Combo x2"
		elseif targ.health < Cdmg*3 + Blgdmg and QReady and EReady and RReady then
			rTxt = "Combo x3"
		else
			rTxt = "Harassable"
		end
	elseif not LichR and HexTechR then
		if targ.health < Rdmg and RReady then
			rTxt = "Ult Him!"
		elseif targ.health < Qdmg + Edmg and QReady and EReady then
			rTxt = "Q + E"
		elseif targ.health < Cdmg + HexTechdmg and QReady and EReady and RReady then
			rTxt = "Combo Him!"
		elseif targ.health < Cdmg*2 + HexTechdmg and QReady and EReady and RReady then
			rTxt = "Combo x2"
		elseif targ.health < Cdmg*3 + HexTechdmg and QReady and EReady and RReady then
			rTxt = "Combo x3"
		else
			rTxt = "Harassable"
		end
	elseif LichR and not HexTechR then
		if targ.health < Rdmg and RReady then
			rTxt = "Ult Him!"
		elseif targ.health < Qdmg + Edmg and QReady and EReady then
			rTxt = "Q + E"
		elseif targ.health < Cdmg + Lichdmg and QReady and EReady and RReady then
			rTxt = "Combo Him!"
		elseif targ.health < Cdmg*2 + Lichdmg and QReady and EReady and RReady then
			rTxt = "Combo x2"
		elseif targ.health < Cdmg*3 + Lichdmg and QReady and EReady and RReady then
			rTxt = "Combo x3"
		else
			rTxt = "Harassable"
		end
	elseif LichR and HexTechR then
		if targ.health < Rdmg and RReady then
			rTxt = "Ult Him!"
		elseif targ.health < Qdmg + Edmg and QReady and EReady then
			rTxt = "Q + E"
		elseif targ.health < Cdmg + Lichdmg + HexTechdmg and QReady and EReady and RReady then
			rTxt = "Combo Him!"
		elseif targ.health < Cdmg*2 + Lichdmg + HexTechdmg and QReady and EReady and RReady then
			rTxt = "Combo x2"
		elseif targ.health < Cdmg*3 + Lichdmg + HexTechdmg and QReady and EReady and RReady then
			rTxt = "Combo x3"
		else
			rTxt = "Harassable"
		end
	else
		rTxt = "Harrassable(error)"
	end
	return rTxt
end

-------------------------

function checkQ(targ)
	if targ ~= nil then
		if GetDistance(targ, myHero) < 600 then
			if not TargetHaveBuff("AkaliMota", targ) and Menu.skill.Qblock then
				useQ(targ)
			end
			if not TargetHaveBuff("AkaliMota", targ) and targ.health < getDmg("Q", targ, myHero) and Menu.skill.Qblock then
				useQ(targ)
			end
			if not Menu.skill.Qblock then
				useQ(targ)
			end
		end
	end
end

function checkE(targ)
	if GetDistance(targ, myHero) > 325 then return false end
	if Menu.skill.useEonlyifQ and TargetHaveBuff("AkaliMota", targ) then
		useE(targ)
	end
	if Menu.skill.useEonlyifQ and targ.health < getDmg("E",targ,myHero) then
		useE(targ)
	end
	if not Menu.skill.useEonlyifQ then
		useE(targ)
	end
end

function KS()
	for i=1, heroManager.iCount, 1 do
		local champ = heroManager:GetHero(i)
		if champ.team ~= myHero.team and ValidTarget(champ) then
			if Menu.KS.Q and QReady and GetDistance(champ, myHero) < 600 and champ.health < getDmg("Q",champ,myHero) then useQ(champ) end
			if Menu.KS.E and EReady and GetDistance(champ, myHero) < 325 and champ.health < getDmg("E",champ,myHero) then useE(champ) end
			if Menu.KS.R and RReady and GetDistance(champ, myHero) < 800 and champ.health < getDmg("R",champ,myHero) then useR(champ) end
		end
	end
end
