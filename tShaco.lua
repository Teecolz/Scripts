if myHero.charName ~= "Shaco" then return end

require "VPrediction"
require "SOW"

local showLocationsInRange = 3000
local showClose = true
local showCloseRange = 800
local drawboxSpots = false
local menu
local levelSequence = {2,1,3,3,3,4,3,2,3,1,4,2,2,2,1,4,1,1}


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

  	VP    = VPrediction()
  	iSOW  = SOW(VP)
  	ts = TargetSelector(TARGET_LOW_HP,625,DAMAGE_MAGIC and DAMAGE_PHYSICAL,false)

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
			menu.Options:addParam("DrawCircles", "Draw Spell Ranges", SCRIPT_PARAM_ONOFF, true)
			menu.Options:addParam("AutoBox", "Auto Place Boxes at Buffs", SCRIPT_PARAM_ONOFF, true)
			menu.Options:addParam("autolevel", "Autolevel Spells", SCRIPT_PARAM_ONOFF, true)

		menu:permaShow("Combo")
		menu:permaShow("Harass")

        menu:addSubMenu("tShaco: Target Selector", "targetSelector")
          menu.targetSelector:addTS(ts)

		print("tShaco successfully loaded")
end

function OnTick()
	if myHero.dead then return end
		ts:update() 
		Spellcheck()
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
		if menu.Options.AutoBox then
			if GetGameTimer() >= 59 then
				AutoBox()
			end
		end
		if menu.Options.autolevel then autoLevelSetSequence(levelSequence) end
end

function getHitBoxRadius(target)
		return GetDistance(target.minBBox, target.maxBBox)/2
end

function UseItems(target)
		if target == nil then return end
		for _,item in pairs(items) do
				item.slot = GetInventorySlotItem(item.id)
				if item.slot ~= nil then
						if item.reqTarget and GetDistance(target) < item.range then
								CastSpell(item.slot, target)
						elseif not item.reqTarget then
								if (GetDistance(target) - getHitBoxRadius(myHero) - getHitBoxRadius(target)) < 50 then
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
end

function OnDeleteObj(object)
		if object ~= nil and object.name:find("Jester_Copy") then
				clone = nil
		end
end

function OnDraw()
		if not myHero.dead and menu.Options.DrawCircles then
				DrawCircle(myHero.x, myHero.y, myHero.z, 625, ARGB(255, 0, 0, 80)) --E
				DrawCircle(myHero.x, myHero.y, myHero.z, 500, ARGB(255, 0, 0, 80))  --Q
				DrawCircle(myHero.x, myHero.y, myHero.z, 425, ARGB(255, 0, 0, 80))  --W
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
		if GetDistance(myHero, boxSpot) < 600 and Wready then
			if GetGameTimer() >= 60 and GetGameTimer() <= 120 then
				CastSpell(_W, boxSpot.x, boxSpot.z)
			end
		end
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
