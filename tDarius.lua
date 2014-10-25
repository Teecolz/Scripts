if myHero.charName ~= "Darius" then return end

local version = "2.0"
local AUTOUPDATE = true
local SCRIPT_NAME = "tDarius"
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
RequireI:Add("SxOrbwalk", "https://raw.githubusercontent.com/Superx321/BoL/master/common/SxOrbWalk.lua")

RequireI:Check()

if RequireI.downloadNeeded == true then return end

require 'SxOrbwalk'
require 'VPrediction'


local menu
local ts
local levelSequence = {1, 3, 1, 2, 1, 4, 1, 2, 1, 2, 4, 2, 3, 2, 3, 4, 3, 3}
local target
local enemyTable = {}
local TMTSlot, RAHSlot = nil, nil
local TMTREADY, RAHREADY = false, false
local Qready, Wready, Eready, Rready = false, false, false, false
local AARange = 125
local Qrange = 400 --425
local Wrange = 210
local Erange = 540
local Rrange = 460

--[[Credit Ryuk]]--
champsToStun = {
	{ charName = "Katarina", spellName = "KatarinaR" , important = 0},
	{ charName = "Galio", spellName = "GalioIdolOfDurand" , important = 0},
	{ charName = "FiddleSticks", spellName = "Crowstorm" , important = 0},
	{ charName = "FiddleSticks", spellName = "DrainChannel" , important = 0},
	{ charName = "Nunu", spellName = "AbsoluteZero" , important = 0},
	{ charName = "Shen", spellName = "ShenStandUnited" , important = 0},
	{ charName = "Urgot", spellName = "UrgotSwap2" , important = 0},
	{ charName = "Malzahar", spellName = "AlZaharNetherGrasp" , important = 0},
	{ charName = "Karthus", spellName = "FallenOne" , important = 0},
	{ charName = "Pantheon", spellName = "PantheonRJump" , important = 0},
	{ charName = "Pantheon", spellName = "PantheonRFall", important = 0},
	{ charName = "Varus", spellName = "VarusQ" , important = 0},
	{ charName = "Caitlyn", spellName = "CaitlynAceintheHole" , important = 0},
	{ charName = "MissFortune", spellName = "MissFortuneBulletTime" , important = 0},
	{ charName = "Warwick", spellName = "InfiniteDuress" , important = 0}
}
-------------------------------------------------

function OnLoad()
	VP = VPrediction()
	SxO = SxOrbWalk(VP)
	Init()
	Menu()
	print("<font color=\"#78CCDB\"><b>" ..">> tDarius 2.0 loaded successfully")
	Loaded = true
	SxO:RegisterAfterAttackCallback(Wreset)
	JungVariables()
	EnemyMinions = minionManager(MINION_ENEMY, 425, myHero, MINION_SORT_HEALTH_ASC)
	
	_G.oldDrawCircle = rawget(_G, 'DrawCircle')
	_G.DrawCircle = DrawCircle2
	
	for i, enemy in pairs(GetEnemyHeroes()) do
		if enemy then 
			local a = {}
			a.object = enemy
			a.stack = 0
			table.insert(enemyTable, a)
		end
	end
	
	PrintFloatText(myHero, 11, "tDarius 2 Loaded Successfully")
end



function Init()
	
	ts = TargetSelector(TARGET_LOW_HP, 540, DAMAGE_PHYSICAL)
	SpellI = { name = "SummonerDot",			range = 600,			ready = false, dmg = 0,					variable = nil		}
	
end

function Menu() 
	menu = scriptConfig("tDarius: Main Menu", "Darius")
	
	menu:addSubMenu("tDarius: SxOrbwalk", "Orbwalk")
	SxO:LoadToMenu(menu.Orbwalk) 
	
	menu:addSubMenu("tDarius: Combo", "combo")
	menu.combo:addParam("combokey", "Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
	menu.combo:addParam("useQ", "Use Q-Spell", SCRIPT_PARAM_ONOFF, true)
	menu.combo:addSubMenu("Q Options", "qoptions")
	menu.combo.qoptions:addParam("qmax", "Only use Q at max damage", SCRIPT_PARAM_ONOFF, false)
	menu.combo.qoptions:addParam("packetsQ", "Use Packets for Q", SCRIPT_PARAM_ONOFF, false)
	menu.combo:addParam("useW", "Use W-Spell", SCRIPT_PARAM_ONOFF, true)
	menu.combo:addParam("useE", "Use E-Spell", SCRIPT_PARAM_ONOFF, true)
	menu.combo:addSubMenu("E Options", "eoptions")
	menu.combo.eoptions:addParam("minE", "Min E Range", SCRIPT_PARAM_SLICE, 0, 0, 300)
	menu.combo:addParam("useR", "Use R-Spell", SCRIPT_PARAM_ONOFF, true)
	menu.combo:addSubMenu("R Options", "roptions")
	menu.combo.roptions:addParam("rBuffer", "R% to ult at",SCRIPT_PARAM_SLICE, 100, 0, 100, 2)
	menu.combo.roptions:addParam("packets", "Use Packets for Ult", SCRIPT_PARAM_ONOFF, false)
	menu.combo:addParam("useITEM", "Use Items in Combo", SCRIPT_PARAM_ONOFF, true)
	
	menu:addSubMenu("tDarius: Harass", "harass")
	menu.harass:addParam("harasskey", "Harass", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
	menu.harass:addParam("useQ", "Use Q-Spell", SCRIPT_PARAM_ONOFF, true)
	menu.harass:addParam("useE", "Use E-Spell", SCRIPT_PARAM_ONOFF, true)
	menu.harass:addParam("autoQ", "Q Max Dmg Auto Harras", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("Y"))
	menu.harass:addParam("mana", "Dont Auto Q Harass if mana < %", SCRIPT_PARAM_SLICE, 0, 0, 100)
	
	menu:addSubMenu("tDarius: Lane Clear", "lane")
	menu.lane:addParam("lanekey", "Lane Clear", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("Z"))
	menu.lane:addParam("useQ", "Use Q-Spell", SCRIPT_PARAM_ONOFF, true)
	menu.lane:addParam("useW", "Use W-Spell", SCRIPT_PARAM_ONOFF, true)
	menu.lane:addParam("useITEM", "Use Items", SCRIPT_PARAM_ONOFF, true)
	
	menu:addSubMenu("tDarius: Jungle Clear", "jungle")
	menu.jungle:addParam("junglekey", "Jungle Clear", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("Z"))
	menu.jungle:addParam("useQ", "Use Q-Spell", SCRIPT_PARAM_ONOFF, true)
	menu.jungle:addParam("useW", "Use W-Spell", SCRIPT_PARAM_ONOFF, true)
	menu.jungle:addParam("useITEM", "Use Items", SCRIPT_PARAM_ONOFF, true)
	
	menu:addSubMenu("tDarius: Killsteal", "killsteal")
	menu.killsteal:addParam("killstealR", "Use R-Spell to Killsteal", SCRIPT_PARAM_ONOFF, true)
	menu.killsteal:addParam("killstealQ", "Use Q-Spell to Killsteal", SCRIPT_PARAM_ONOFF, true)
	menu.killsteal:addParam("autoIgnite", "Auto Ignite", SCRIPT_PARAM_ONOFF, true)
	
	menu:addSubMenu("tDarius: Drawings", "draw")
	menu.draw:addParam("drawAA", "Draw AA Range", SCRIPT_PARAM_ONOFF, true)
	menu.draw:addParam("drawQ", "Draw Q Range", SCRIPT_PARAM_ONOFF, true)
	menu.draw:addParam("drawE", "Draw E Range", SCRIPT_PARAM_ONOFF, true)
	menu.draw:addParam("drawR", "Draw R Range", SCRIPT_PARAM_ONOFF, true)
	menu.draw:addParam("drawRD", "Draw Ult/Health damage", SCRIPT_PARAM_ONOFF, true)
	menu.draw:addParam("drawP", "Draw Passive damage", SCRIPT_PARAM_ONOFF, true)
	menu.draw:addParam("aftercombo", "Draw after Combo", SCRIPT_PARAM_ONOFF, true)
	menu.draw:addSubMenu("Killsteal", "killsteal")
	menu.draw.killsteal:addParam("RDraw", "Draw Enemys killed by R", SCRIPT_PARAM_ONOFF, true)
	
	menu.draw:addSubMenu("tDarius: LagFreeCircles", "LFC")
	menu.draw.LFC:addParam("LagFree", "Activate Lag Free Circles", SCRIPT_PARAM_ONOFF, false)
	menu.draw.LFC:addParam("CL", "Length before Snapping", SCRIPT_PARAM_SLICE, 350, 75, 2000, 0)
	menu.draw.LFC:addParam("CLinfo", "Higher length = Lower FPS Drops", SCRIPT_PARAM_INFO, "")
	
	menu:addSubMenu("tDarius: Extras", "extra")
	menu.extra:addParam("autolevel", "AutoLevel Spells (Requires F9)", SCRIPT_PARAM_ONOFF, false)
	menu.extra:addParam("interrupt", "Interrupt Important Spells with E", SCRIPT_PARAM_ONOFF, true)
	menu.extra:addParam("debug", "Debug", SCRIPT_PARAM_ONOFF, false)
	
	menu:addSubMenu("tDarius: Ult Blacklist", "ultb")
	for i, enemy in pairs(GetEnemyHeroes()) do
		menu.ultb:addParam(enemy.charName, "Use ult on: "..enemy.charName, SCRIPT_PARAM_ONOFF, true)
	end
	
	menu:addParam("ver", "Version", SCRIPT_PARAM_INFO, tostring(version))
	menu:addParam("author", "Author", SCRIPT_PARAM_INFO, "Teecolz")
	
	
	menu.combo:permaShow("combokey")
	menu.harass:permaShow("harasskey")
	menu.harass:permaShow("autoQ")
end

function OnTick()
	if myHero.dead then return end
	
	ts:update()
	EnemyMinions:update()
	spellCheck()
	
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
	if menu.jungle.junglekey then
		JungleClear()
	end
	if menu.killsteal.killstealR and Rready then
		killstealR()
	end
	if menu.killsteal.killstealQ then
		killstealQ()
	end
	
	target = ts.target
	
	if menu.harass.autoQ and not menu.combo.combokey and not menu.harass.harasskey and Qready then
		AutoQ()
	end
	
end

function AutoQ()
	if menu.harass.mana < (myHero.mana / myHero.maxMana) * 100 then
		for i, enemy in pairs(GetEnemyHeroes()) do
			if not UnitAtTower(enemy, 0) then
				if enemy ~= nil and not enemy.dead and GetDistance(enemy) < 405 and GetDistance(enemy) > 270 then
					if menu.combo.qoptions.packetsQ then
						Packet("S_CAST", {spellId = _Q, targetNetworkId = enemy.networkID}):send()
						if menu.extra.debug then print("Paacket AutoQ") end
					else
						CastSpell(_Q)
						if menu.extra.debug then print("Reg AutoQ") end
					end
				end
			end
		end
	end
	
end

function spellCheck()
	
	TMTSlot, RAHSlot = GetInventorySlotItem(3077), GetInventorySlotItem(3074)
	
	TMTREADY = (TMTSlot ~= nil and myHero:CanUseSpell(TMTSlot) == READY)
	RAHREADY = (RAHSlot ~= nil and myHero:CanUseSpell(RAHSlot) == READY)
	
	Qready = (myHero:CanUseSpell(_Q) == READY)
	Wready = (myHero:CanUseSpell(_W) == READY)
	Eready = (myHero:CanUseSpell(_E) == READY)
	Rready = (myHero:CanUseSpell(_R) == READY)
	
	if myHero:GetSpellData(SUMMONER_1).name:find(SpellI.name) then
		SpellI.variable = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find(SpellI.name) then
		SpellI.variable = SUMMONER_2
	end
	SpellI.ready = (SpellI.variable ~= nil and myHero:CanUseSpell(SpellI.variable) == READY)
end

function blCheck(target)
	if target ~= nil and menu.ultb[target.charName] then
		return true
	else
		return false
	end
end

function Combo()
	
	if ValidTarget(target, 600) then
		--if menu.extra.debug then DrawText3D("Target in 600 range", myHero.x, myHero.z) end
		if menu.combo.useE and Eready then
			UseE()
		end 
		if menu.combo.useQ and Qready then
			UseQ()
		end
		if menu.combo.useR and Rready then
			UseR()
		end
		if menu.combo.useITEM and TMTREADY and GetDistance(target) < 275 then CastSpell(TMTSlot) end
		if menu.combo.useITEM and RAHREADY and GetDistance(target) < 275 then CastSpell(RAHSlot) end
	end
	
end

function UseE()
	if target and GetDistance(target) > menu.combo.eoptions.minE and GetDistanceSqr(target) <= 291600 then 
		local AOECastPosition, MainTargetHitChance, nTargets = VP:GetLineAOECastPosition(target, 0.5, 225, Erange, 1500, myHero, false)
		if nTargets >= 1 and GetDistance(AOECastPosition) <= Erange and GetDistance(AOECastPosition) >= menu.combo.eoptions.minE then
			CastSpell(_E, AOECastPosition.x, AOECastPosition.z)
		end
	end
end

function UseQ()
	if menu.combo.qoptions.qmax then
		if GetDistance(target) > 270 and GetDistance(target) < Qrange then
			if menu.combo.qoptions.packetsQ then
				Packet("S_CAST", {spellId = _Q, targetNetworkId = target.networkID}):send()
				if menu.extra.debug then print("Combo PacketQ") end
			else
				CastSpell(_Q)
				if menu.extra.debug then print("Combo RegQ") end
			end
		end
	else
		if GetDistance(target) < Qrange then
			if menu.combo.qoptions.packetsQ then
				Packet("S_CAST", {spellId = _Q, targetNetworkId = target.networkID}):send()
				if menu.extra.debug then print("Combo PacketQ") end
			else
				CastSpell(_Q)
				if menu.extra.debug then print("Combo RegQ") end
			end
		end
	end
end

function UseR()
	if blCheck(target) then
		for i, enemy in ipairs(enemyTable) do
			if enemy.object == target and GetDistance(target) < Rrange then
				local multiplier = GetMultiplier(enemy.stack)
				local rDmg = multiplier * getDmg("R", target, myHero)
				if target.health < rDmg*(menu.combo.roptions.rBuffer/100) and not target.dead then
					if not (TargetHaveBuff("JudicatorIntervention", target) or TargetHaveBuff("Undying Rage", target)) then
						if menu.combo.roptions.packets then
							Packet("S_CAST", {spellId = _R, targetNetworkId = target.networkID}):send()
							if menu.extra.debug then print("Casted with packet") end
						else
							CastSpell(_R, target)
							if menu.extra.debug then print("Combo ult casted") end
						end
					end
				end
			end
		end
	end
end


function Wreset()
	if menu.combo.combokey and menu.combo.useW and Wready then
		--SxO:ResetSpell() 
		CastSpell(_W)
	end
	if menu.lane.lanekey and menu.lane.useW and Wready then
		--SxO:ResetSpell()
		CastSpell(_W)
	end
	if menu.jungle.junglekey and menu.jungle.useW and Wready then
		--SxO:ResetSpell()
		CastSpell(_W)
	end
end

function Harass()
	if ValidTarget(target, Erange) then
		if menu.harass.useE and Eready then
			UseE()
		end
		if menu.harass.useQ and Qready then
			UseQ()
		end
	end
end

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
		["Wolf8.1.2"] = true,
		["Wolf8.1.3"] = true,
		["YoungLizard7.1.2"] = true,
		["YoungLizard7.1.3"] = true,
		["LesserWraith9.1.3"] = true,
		["LesserWraith9.1.2"] = true,
		["LesserWraith9.1.4"] = true,
		["YoungLizard10.1.2"] = true,
		["YoungLizard10.1.3"] = true,
		["SmallGolem11.1.1"] = true,
		["Wolf2.1.2"] = true,
		["Wolf2.1.3"] = true,
		["YoungLizard1.1.2"] = true,
		["YoungLizard1.1.3"] = true,
		["LesserWraith3.1.3"] = true,
		["LesserWraith3.1.2"] = true,
		["LesserWraith3.1.4"] = true,
		["YoungLizard4.1.2"] = true,
		["YoungLizard4.1.3"] = true,
		["SmallGolem5.1.1"] = true
	}
	
	FocusJungleNames = {
		["Dragon6.1.1"] = true,
		["Worm12.1.1"] = true,
		["GiantWolf8.1.1"] = true,
		["AncientGolem7.1.1"] = true,
		["Wraith9.1.1"] = true,
		["LizardElder10.1.1"] = true,
		["Golem11.1.2"] = true,
		["GiantWolf2.1.1"] = true,
		["AncientGolem1.1.1"] = true,
		["Wraith3.1.1"] = true,
		["LizardElder4.1.1"] = true,
		["Golem5.1.2"] = true,
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

function killstealR()
	if menu.killsteal.killstealR then
		for i, enemy in ipairs(enemyTable) do
			if Rready and GetDistance(enemy.object) < 460 then
				if blCheck(enemy.object) then
					local multiplier = GetMultiplier(enemy.stack)
					local rDmg = multiplier * getDmg("R", enemy.object, myHero)
					local swag = enemy.object
					if swag.health <= rDmg*(menu.combo.roptions.rBuffer/100) and not swag.dead then
						if not (TargetHaveBuff("JudicatorIntervention", swag) or TargetHaveBuff("Undying Rage", swag)) then
							if menu.combo.roptions.packets then
								Packet("S_CAST", {spellId = _R, targetNetworkId = swag.networkID}):send()
								if menu.extra.debug then print("Killsteal R Casted with packet") end
							else
								CastSpell(_R, swag)
								if menu.extra.debug then print("Killsteal Reg ult casted") end
							end
						end
					end
				end
			end
		end
	end
end

function AutoIgnite(unit)
	SpellI.dmg = (SpellI.ready and getDmg("IGNITE", unit, myHero)) or 0
	if unit.health < SpellI.dmg and GetDistanceSqr(unit) <= SpellI.range * SpellI.range then
		if SpellI.ready then
			CastSpell(SpellI.variable, unit)
		end
	end
end

---------------------------------------------------------------------
--- Lag Free Circles ------------------------------------------------
---------------------------------------------------------------------
function LFCfunc()
	if not menu.draw.LFC.LagFree then _G.DrawCircle = _G.oldDrawCircle end
	if menu.draw.LFC.LagFree then _G.DrawCircle = DrawCircle2 end
end

function DrawCircleNextLvl(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(8,round(180/math.deg((math.asin((chordlength/(2*radius)))))))
	quality = 2 * math.pi / quality
	radius = radius*.92
	--[[randcol = math.random(0,255)
	color = ARGB(randcol, randcol, randcol, 0)]]
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
		DrawCircleNextLvl(x, y, z, radius, 1, color, menu.draw.LFC.CL) 
	end
end


function OnDraw()
	if myHero.dead then return end
	draw_Range()
	draw_Range_aftercombo()
	killstealR_information()
end

function draw_Range()
	if menu.draw.drawAA then
		DrawCircle(myHero.x, myHero.y, myHero.z, AARange, ARGB(255,0,0,80))
	end
	if menu.draw.drawQ and Qready then
		DrawCircle(myHero.x, myHero.y, myHero.z, Qrange, ARGB(255,0,0,80))
	end
	if menu.draw.drawE and Eready then
		DrawCircle(myHero.x, myHero.y, myHero.z, Erange, ARGB(255,0,0,80))
	end
	if menu.draw.drawR and Rready then
		DrawCircle(myHero.x, myHero.y, myHero.z, Rrange, ARGB(255,0,0,80))
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
	for i, enemy in pairs(enemyTable) do
		if not enemy.object.dead and enemy.object.visible then
			local pDmg = getDmg("P", enemy.object, myHero)
			local pDmgT = pDmg * enemy.stack
			local pDmgTint = math.floor(pDmgT)
			local Ehealth = math.floor(enemy.object.health)
			--local drawHealth = math.floor(rDmg / Ehealth)
			--local drawPHealth = math.floor(pDmgT / Ehealth)
			if pDmgT < enemy.object.health and menu.draw.drawP then
				DrawText3D("["..pDmgT.."/"..Ehealth.."] - passive", enemy.object.x, enemy.object.y, enemy.object.z, 20, RGB(0, 255, 0), 0)
			elseif menu.draw.drawP then
				DrawText3D("[DEAD]", enemy.object.x, enemy.object.y, enemy.object.z, 30, RGB(255, 0, 0), 0)
			end
			local multiplier = GetMultiplier(enemy.stack)
			local rDmg = math.floor(multiplier * getDmg("R", enemy.object, myHero))
			if enemy.object.health <= rDmg*(menu.combo.roptions.rBuffer/100) and menu.draw.killsteal.RDraw and Rready then
				DrawText3D("Press R to kill (Dunk)!", enemy.object.x, enemy.object.y, enemy.object.z-50, 30, RGB(255, 150, 0), 0)
				DrawCircle3D(enemy.object.x, enemy.object.y, enemy.object.z, 130, 1, RGB(255, 150, 0))
				DrawCircle3D(enemy.object.x, enemy.object.y, enemy.object.z, 150, 1, RGB(255, 150, 0))
				DrawCircle3D(enemy.object.x, enemy.object.y, enemy.object.z, 170, 1, RGB(255, 150, 0))
			elseif menu.draw.drawRD then
				DrawText3D("["..rDmg.."/"..Ehealth.."] - ult", enemy.object.x, enemy.object.y, enemy.object.z-50, 20, RGB(0, 255, 0), 0)
			end
		end
	end
end

function killstealQ()
	local Enemies = GetEnemyHeroes()
	for i, enemy in pairs(Enemies) do
		if ValidTarget(enemy, Qrange) and not enemy.dead and GetDistance(enemy) < Qrange then
			if (getDmg("Q", enemy,myHero)+getDmg("AD", enemy,myHero)) > enemy.health and Qready then
				if menu.combo.qoptions.packetsQ then
					Packet("S_CAST", {spellId = _Q}):send()
				else
					CastSpell(_Q)
				end
			end
			
			if menu.killsteal.autoIgnite then
				AutoIgnite(enemy)
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
	--if menu.extra.debug then print(enemyTable) end
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

function OnProcessSpell(unit, spell)
	if menu.extra.interrupt then
		if unit.type == 'obj_AI_Hero' and unit.team == TEAM_ENEMY and GetDistance(unit) < Erange then
			local spellName = spell.name
			for i = 1, #champsToStun do
				if unit.charName == champsToStun[i].charName and spellName == champsToStun[i].spellName then
					if champsToStun[i].important == 0 then
						if Eready and GetDistanceSqr(unit) > Erange^2 then
							CastSpell(_E,unit.x,unit.z)
						end
					end
				end
			end
		end
	end
end

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
