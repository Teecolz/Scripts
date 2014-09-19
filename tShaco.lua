if myHero.charName ~= "Shaco" then return end

local version = 1.0
local AUTOUPDATE = true


local SCRIPT_NAME = "tShaco"
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

--------------------BoL Tracker-----------------------------
HWID = Base64Encode(tostring(os.getenv("PROCESSOR_IDENTIFIER")..os.getenv("USERNAME")..os.getenv("COMPUTERNAME")..os.getenv("PROCESSOR_LEVEL")..os.getenv("PROCESSOR_REVISION")))
-- DO NOT CHANGE. This is set to your proper ID.
id = 15
ScriptName = "tShaco"

-- Thank you to Roach and Bilbao for the support!
assert(load(Base64Decode("G0x1YVIAAQQEBAgAGZMNChoKAAAAAAAAAAAAAQIDAAAAJQAAAAgAAIAfAIAAAQAAAAQKAAAAVXBkYXRlV2ViAAEAAAACAAAADAAAAAQAETUAAAAGAUAAQUEAAB2BAAFGgUAAh8FAAp0BgABdgQAAjAHBAgFCAQBBggEAnUEAAhsAAAAXwAOAjMHBAgECAgBAAgABgUICAMACgAEBgwIARsNCAEcDwwaAA4AAwUMDAAGEAwBdgwACgcMDABaCAwSdQYABF4ADgIzBwQIBAgQAQAIAAYFCAgDAAoABAYMCAEbDQgBHA8MGgAOAAMFDAwABhAMAXYMAAoHDAwAWggMEnUGAAYwBxQIBQgUAnQGBAQgAgokIwAGJCICBiIyBxQKdQQABHwCAABcAAAAECAAAAHJlcXVpcmUABAcAAABzb2NrZXQABAcAAABhc3NlcnQABAQAAAB0Y3AABAgAAABjb25uZWN0AAQQAAAAYm9sLXRyYWNrZXIuY29tAAMAAAAAAABUQAQFAAAAc2VuZAAEGAAAAEdFVCAvcmVzdC9uZXdwbGF5ZXI/aWQ9AAQHAAAAJmh3aWQ9AAQNAAAAJnNjcmlwdE5hbWU9AAQHAAAAc3RyaW5nAAQFAAAAZ3N1YgAEDQAAAFteMC05QS1aYS16XQAEAQAAAAAEJQAAACBIVFRQLzEuMA0KSG9zdDogYm9sLXRyYWNrZXIuY29tDQoNCgAEGwAAAEdFVCAvcmVzdC9kZWxldGVwbGF5ZXI/aWQ9AAQCAAAAcwAEBwAAAHN0YXR1cwAECAAAAHBhcnRpYWwABAgAAAByZWNlaXZlAAQDAAAAKmEABAYAAABjbG9zZQAAAAAAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQA1AAAAAgAAAAIAAAACAAAAAgAAAAIAAAACAAAAAgAAAAMAAAADAAAAAwAAAAMAAAAEAAAABAAAAAUAAAAFAAAABQAAAAYAAAAGAAAABwAAAAcAAAAHAAAABwAAAAcAAAAHAAAABwAAAAgAAAAHAAAABQAAAAgAAAAJAAAACQAAAAkAAAAKAAAACgAAAAsAAAALAAAACwAAAAsAAAALAAAACwAAAAsAAAAMAAAACwAAAAkAAAAMAAAADAAAAAwAAAAMAAAADAAAAAwAAAAMAAAADAAAAAwAAAAGAAAAAgAAAGEAAAAAADUAAAACAAAAYgAAAAAANQAAAAIAAABjAAAAAAA1AAAAAgAAAGQAAAAAADUAAAADAAAAX2EAAwAAADUAAAADAAAAYWEABwAAADUAAAABAAAABQAAAF9FTlYAAQAAAAEAEAAAAEBvYmZ1c2NhdGVkLmx1YQADAAAADAAAAAIAAAAMAAAAAAAAAAEAAAAFAAAAX0VOVgA="), nil, "bt", _ENV))()
-------------------------------------------------

require "VPrediction"
require "SOW"

local showLocationsInRange = 3000
local showClose = true
local showCloseRange = 800
local drawboxSpots = false
local menu
local levelSequence = {2,1,3,3,3,4,3,2,3,1,4,2,2,2,1,4,1,1}
local TMTSlot, RAHSlot = nil, nil
local TMTREADY, RAHREADY = false, false


local items =
{
		BRK = {id=3153, range = 500, reqTarget = true, slot = nil },
		BWC = {id=3144, range = 400, reqTarget = true, slot = nil },
		DFG = {id=3128, range = 750, reqTarget = true, slot = nil },
		HGB = {id=3146, range = 400, reqTarget = true, slot = nil },
		RSH = {id=3074, range = 350, reqTarget = false, slot = nil},
		STD = {id=3131, range = 350, reqTarget = false, slot = nil},
		TMT = {id=3077, range = 350, reqTarget = false, slot = nil},
		YGB = {id=3142, range = 350, reqTarget = false, slot = nil}
}

boxSpots = {
		--Blue Team
		
		{ x = 3529.24, y = 54.65, z = 7700.50}, -- Blue Camp
		{ x = 6397.00, y = 51.67, z = 5065.00}, -- Wraith Camp
		{ x = 3388.47, y = 55.61, z = 6168.49}, -- Wolf Camp
		{ x = 7586.97, y = 57.00, z = 3828.58}, -- Red Camp
		{ x = 7445.00, y = 55.60, z = 3365.00}, -- Red Camp(Bush, E little minion closest to bush)
		{ x = 8055.41, y = 54.28, z = 2671.30}, -- Golem Camp
		
		--Purple Team
		
		{ x = 10520.72, y = 54.87, z = 6927.20}, -- Blue Camp
		{ x = 7645.00, y = 55.20, z = 9413.00 }, -- Wraith Camp
		{ x = 10580.53, y = 65.54, z = 7958.30}, -- Wolf Camp
		{ x = 6431.00, y = 54.63, z = 10535.00}, -- Red Camp
		{ x = 6597.55, y = 54.63, z = 11117.78}, -- Red Camp(Bush, E little minion closest to bush)
		{ x = 6143.00, y = 39.55, z = 11777.00} -- Golem Camp
}

function OnLoad()
		
		VP = VPrediction()
		iSOW = SOW(VP)
		ts = TargetSelector(TARGET_LOW_HP,625,DAMAGE_MAGIC and DAMAGE_PHYSICAL,false)
		EnemyMinions = minionManager(MINION_ENEMY, 425, myHero, MINION_SORT_HEALTH_ASC)
		JungVariables()
		
		
		menu = scriptConfig("tShaco", "tShaco")
		
		menu:addSubMenu("tShaco: Orbwalk", "Orbwalk")
		iSOW:LoadToMenu(menu.Orbwalk) 
		
		menu:addParam("Combo", "Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
		menu:addParam("Harass", "Harass", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("T"))
		menu:addParam("Escape", "Stealth Recall", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("S"))
		
		menu:addSubMenu("tShaco: Options", "Options")
		menu.Options:addParam("Ulti", "Use Clone in Combo", SCRIPT_PARAM_ONOFF, false)
		menu.Options:addParam("Qcombo", "Use Q in Combo", SCRIPT_PARAM_ONOFF, true)
		menu.Options:addParam("KS", "Killsteal with E", SCRIPT_PARAM_ONOFF, true)
		--menu.Options:addParam("DrawCircles", "Draw Spell Ranges", SCRIPT_PARAM_ONOFF, true)
		menu.Options:addParam("AutoBox", "Auto Place Boxes at Buffs", SCRIPT_PARAM_ONOFF, true)
		menu.Options:addParam("autolevel", "Autolevel Spells", SCRIPT_PARAM_ONOFF, true)
		
		menu:addSubMenu("tShaco: Lane Clear", "lane")
		menu.lane:addParam("lanekey", "Lane Clear", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("N"))
		menu.lane:addParam("useE", "Use E-Spell", SCRIPT_PARAM_ONOFF, true)
		menu.lane:addParam("useW", "Use W-Spell", SCRIPT_PARAM_ONOFF, true)
		menu.lane:addParam("useITEM", "Use Items", SCRIPT_PARAM_ONOFF, true)
		
		menu:addSubMenu("tShaco: Jungle Clear", "jungle")
		menu.jungle:addParam("junglekey", "Jungle Clear", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("N"))
		menu.jungle:addParam("useE", "Use E-Spell", SCRIPT_PARAM_ONOFF, true)
		menu.jungle:addParam("useW", "Use W-Spell", SCRIPT_PARAM_ONOFF, true)
		menu.jungle:addParam("useITEM", "Use Items", SCRIPT_PARAM_ONOFF, true)
		
		menu:addSubMenu("tShaco: Drawings", "draw")
		menu.draw:addParam("drawAA", "Draw AA Range", SCRIPT_PARAM_ONOFF, true)
		menu.draw:addParam("drawQ", "Draw Q Range", SCRIPT_PARAM_ONOFF, true)
		menu.draw:addParam("drawW", "Draw W Range", SCRIPT_PARAM_ONOFF, true)
		menu.draw:addParam("drawE", "Draw E Range", SCRIPT_PARAM_ONOFF, true)
		
		menu:permaShow("Combo")
		menu:permaShow("Harass")
		menu.Options:permaShow("AutoBox")
		
		menu:addSubMenu("tShaco: Target Selector", "targetSelector")
		menu.targetSelector:addTS(ts)
		
		print("<font color=\"#78CCDB\"><b>" ..">> tShaco successfully loaded ;)")
		
		UpdateWeb(true, ScriptName, id, HWID)
		
end

function OnTick()
		if myHero.dead then return end
		ts:update() 
		Spellcheck()
		EnemyMinions:update()
		if menu.Options.KS then KS() end
		if clone ~= nil and lastCPosUpdate < GetTickCount() - 1000 then
				lastCX = clone.x
				lastCZ = clone.z
		end
		if menu.Combo then
				Combo()
				if menu.Options.Ulti and ValidTarget(ts.target) and Rready then
						CastR()
				end
		end
		if menu.Escape then
				CastSpell(_Q, mousePos.x, mousePos.z)
				CastSpell(RECALL)
		end 
		if menu.Harass then
				Harass()
		end
		if menu.lane.lanekey then
				LaneClear()
		end
		if menu.jungle.junglekey then
				JungleClear()
		end
		if menu.Options.AutoBox then
				AutoBox()
		end
		if menu.Options.autolevel then autoLevelSetSequence(levelSequence) end
end

--[[function getHitBoxRadius(target)
return GetDistance(target.minBBox, target.maxBBox)/2
end]]

function UseItems(target)
		if target == nil then return end
		for _,item in pairs(items) do
				item.slot = GetInventorySlotItem(item.id)
				if item.slot ~= nil then
						if item.reqTarget and GetDistance(target) < item.range then
								CastSpell(item.slot, target)
						elseif not item.reqTarget then
								if GetDistance(target) < 275 then
										CastSpell(item.slot)
								end
						end
				end
		end
end

function KS()
		for i, enemy in pairs(GetEnemyHeroes()) do
				if ValidTarget(enemy, 625) and not enemy.dead and GetDistance(enemy) < 625 then
						eDmg = getDmg("E", enemy, myHero)
						if enemy.health < eDmg*1.2 then
								CastSpell(_E, enemy)
						end
				end
		end
end


function Spellcheck()
		
		Qready = (myHero:CanUseSpell(_Q) == READY)
		Wready = (myHero:CanUseSpell(_W) == READY)
		Eready = (myHero:CanUseSpell(_E) == READY)
		Rready = (myHero:CanUseSpell(_R) == READY)
		
		TMTSlot, RAHSlot = GetInventorySlotItem(3077), GetInventorySlotItem(3074)
		
		TMTREADY = (TMTSlot ~= nil and myHero:CanUseSpell(TMTSlot) == READY)
		RAHREADY = (RAHSlot ~= nil and myHero:CanUseSpell(RAHSlot) == READY)
		
end

function CastR()
		if clone == nil then CastSpell(_R)
				if clone ~= nil and GetDistance(clone, ts.target) > 350 then
						CastSpell(_R, ts.target) 
				end
		end
end

function Combo()
		
		target = ts.target
		
		if ValidTarget(target) and Qready and menu.Options.Qcombo then
				CastSpell(_Q, ts.nextPosition.x, ts.nextPosition.z)
		end
		if ValidTarget(target, 625) then
				myHero:Attack(target)
		end
		if ValidTarget(target, 625) then
				UseItems(target)
		end
		if ValidTarget(target, 425) and Wready then
				CastSpell(_W, target.x, target.z)
		end
		if ValidTarget(target, 625) then
				CastSpell(_E, target)
		end 
end

function Harass()
		if ValidTarget(ts.target, 625) and Eready then
				CastSpell(_E, ts.target)
		end
		if ValidTarget(ts.taget) and Qready then
				CastSpell(_Q, ts.nextPosition.x, ts.nextPosition.z)
				myHero:Attack(ts.target)
		end
end

function OnCreateObj(object)
		if object ~= nil and object.name:find("Jester_Copy") then
				clone = object
				lastCX = clone.x
				lastCZ = clone.z
				lastClone = GetTickCount()
				lastCPosUpdate = GetTickCount()
		end
		if object.valid then
				if FocusJungleNames[object.name] then
						JungleFocusMobs[#JungleFocusMobs+1] = object
				elseif JungleMobNames[object.name] then
						JungleMobs[#JungleMobs+1] = object
				end
		end
end

function OnDeleteObj(object)
		if object ~= nil and object.name:find("Jester_Copy") then
				clone = nil
		end
		for i, Mob in pairs(JungleMobs) do
				if object.name == Mob.name then
						table.remove(JungleMobs, i)
				end
		end
		for i, Mob in pairs(JungleFocusMobs) do
				if object.name == Mob.name then
						table.remove(JungleFocusMobs, i)
				end
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

function OnDraw()
		if not myHero.dead then
				if menu.draw.drawAA then
						DrawCircle(myHero.x, myHero.y, myHero.z, 125, ARGB(255,0,0,80))
				end
				if menu.draw.drawQ and Qready then
						DrawCircle(myHero.x, myHero.y, myHero.z, 400, ARGB(255,0,0,80))
				end
				if menu.draw.drawW and Wready then
						DrawCircle(myHero.x, myHero.y, myHero.z, 425, ARGB(255,0,0,80))
				end
				if menu.draw.drawE and Eready then
						DrawCircle(myHero.x, myHero.y, myHero.z, 625, ARGB(255,0,0,80))
				end
				if ValidTarget(ts.target) then
						target = ts.target
						DrawCircle(target.x, target.y, target.z, 100, 0x00FF000)
				end
				if clone ~= nil then
						DrawCircle(clone.x, clone.y, clone.z, 100, 0xFF00FF00)
						local Time = tostring(math.floor((18000-(GetTickCount()-lastClone))/1000,1))
						local objectX, objectY, onScreen = get2DFrom3D(clone.x, clone.y, clone.z)
						DrawText(Time,15,objectX,objectY-100, 0xFF00FF00)
				end
		end
		if drawboxSpots then
				for x,boxSpot in pairs(boxSpots) do
						if GetDistance(boxSpot) < showLocationsInRange then
								local boxColour = 0xFFFFFF
								if GetDistance(boxSpot, mousePos) <= 250 then
										boxColour = 0x00FF000
										drawCircles(boxSpot.x, boxSpot.y, boxSpot.z, boxColour)
								end
						end
				end
		elseif showClose then
				for x,boxSpot in pairs(boxSpots) do
						if GetDistance(boxSpot) <= showCloseRange then
								local boxColour = 0xFFFFFF
								drawCircles(boxSpot.x, boxSpot.y, boxSpot.z, boxColour)
								if GetDistance(boxSpot, mousePos) <= 250 then
										boxColour = 0x00FF000
										drawCircles(boxSpot.x, boxSpot.y, boxSpot.z, boxColour)
								end
						end
				end
		end
end

function AutoBox()
		for i, boxSpot in pairs(boxSpots) do
				if GetDistance(boxSpot, myHero) < 800 and Wready then
						--[[local minutes = 1
						local seconds = 0
						seconds = seconds + (minutes * 60)]]
						if GetGameTimer() >= 100 and GetGameTimer() <= 160 then
								CastSpell(_W, boxSpot.x, boxSpot.z)
						end
				end
		end
end

function LaneClear()
		if not GetJungleMob() then
				for i, minion in ipairs(EnemyMinions.objects) do
						if minion and not minion.dead then
								if menu.lane.useW and Wready and GetDistanceSqr(minion) <= 180625 then CastSpell(_W, minion.x, minion.z) end
								if menu.lane.useE and Eready and GetDistanceSqr(minion) <= 390625 then CastSpell(_E, minion) end
								if menu.lane.useITEM and TMTREADY and GetDistance(minion) < 275 then CastSpell(TMTSlot) end
								if menu.lane.useITEM and RAHREADY and GetDistance(minion) < 275 then CastSpell(RAHSlot) end
						end 
				end
		end
end

function JungleClear()
		local JungleMob = GetJungleMob()
		if JungleMob ~= nil then
				if menu.jungle.useW and Wready and GetDistanceSqr(JungleMob) <= 180625 then CastSpell(_W, JungleMob.x, JungleMob.z) end
				if menu.jungle.useE and Eready and GetDistanceSqr(JungleMob) <= 390625 then CastSpell(_E, JungleMob) end
				if menu.jungle.useITEM and TMTREADY and GetDistance(JungleMob) < 275 then CastSpell(TMTSlot) end
				if menu.jungle.useITEM and RAHREADY and GetDistance(JungleMob) < 275 then CastSpell(RAHSlot) end
		end
end

function drawCircles(x,y,z,colour)
		for i=0,5,1 do
				DrawCircle(x, y, z, 28+i, colour)
		end
		DrawCircle(x, y, z, 250, colour)
end

function OnWndMsg(msg,key)
		if msg == KEY_DOWN and key == string.byte("W") then
				if Wready then
						drawboxSpots = true
				end
				for i, boxSpot in pairs(boxSpots) do
						if GetDistance(boxSpot, mousePos) <= 250 then
								CastSpell(_W, boxSpot.x, boxSpot.z)
						end
				end
		elseif msg == WM_RBUTTONDOWN and drawboxSpots then
				drawboxSpots = false
		end 
end

function OnBugsplat()
		UpdateWeb(false, ScriptName, id, HWID)
end

function OnUnload()
		UpdateWeb(false, ScriptName, id, HWID)
end
