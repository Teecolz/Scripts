if myHero.charName ~= "Braum" then return end

local version = "1.0"
local AUTOUPDATE = true
local SCRIPT_NAME = "tBraum"
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
require 'Prodiction'

Champions = {
		["Lux"] = {charName = "Lux", skillshots = {
			["LuxLightBinding"] = {name = "Light Binding", spellName = "LuxLightBinding", castDelay = 250, projectileName = "LuxLightBinding_mis.troy", projectileSpeed = 1200, range = 1300, radius = 80, type = "line", fuckedUp = false, blockable = true, danger = 1},
			["LuxLightStrikeKugel"] = {name = "LuxLightStrikeKugel", spellName = "LuxLightStrikeKugel", castDelay = 250, projectileName = "LuxLightstrike_mis.troy", projectileSpeed = 1400, range = 1100, radius = 275, type = "circular", fuckedUp = false, blockable = true, danger = 0},
			["LuxMaliceCannon"] = {name = "Lux Malice Cannon", spellName = "LuxMaliceCannon", castDelay = 1375, projectileName = "Enrageweapon_buf_02.troy", projectileSpeed = math.huge, range = 3500, radius = 190, type = "line", fuckedUp = false, blockable = true, danger = 1},
	}},
	
		["Braum"] = {charName = "Braum", skillshots = {
			["Winters Bite"] = {name = "WintersBite", spellName = "BraumQMissile", castDelay = 0, projectileName = "Braum_Base_Q_mis.troy", projectileSpeed = 1700, range = 1000, radius = 100, type = "line", fuckedUp = false, blockable = true, danger = 1},
			["Glacial Fissure"] = {name = "GlacialFissure", spellName = "BraumRWrapper", castDelay = 510, projectileName = "Braum_Base_R_mis.troy", projectileSpeed = 1438, range = 1250, radius = 100, type = "line", fuckedUp = false, blockable = true, danger = 1}, 
	}},	
	
		["Nidalee"] = {charName = "Nidalee", skillshots = {
			["JavelinToss"] = {name = "Javelin Toss", spellName = "JavelinToss", castDelay = 125, projectileName = "nidalee_javelinToss_mis.troy", projectileSpeed = 1300, range = 1500, radius = 60, type = "line", fuckedUp = false, blockable = true, danger = 1}
	}},
		["Rengar"] = {charName = "Rengar", skillshots = {
			["RengarEFinalMAX"] = {name = "RengarEFinalMAX", spellName = "RengarEFinalMAX", castDelay = 250, projectileName = "Rengar_Base_E_Max_Mis.troy", projectileSpeed = 1500, range = 1000, radius = 60, type = "line", fuckedUp = false, blockable = true, danger = 1}
	}},	
		["Sion"] = {charName = "Sion", skillshots = {
			["CrypticGaze"] = {name = "CrypticGaze", spellName = "CrypticGaze",blockable=true, danger = 0, range=625},
	}},	
	
	
		["Nunu"] = {charName = "Nunu", skillshots = {
			["IceBlast"] = {name = "IceBlast", spellName="IceBlast", blockable=true, danger = 1, range=550},
	}},	
	
		["Akali"] = {charName = "Akali", skillshots = {
			["AkaliMota"] = {name = "AkaliMota", spellName = "AkaliMota", castDelay = 125, projectileName = "AkaliMota_mis.troy", projectileSpeed = 1300, range = 1500, radius = 60, type = "line", fuckedUp = false, blockable = true, danger = 1}
	}},
		["Kennen"] = {charName = "Kennen", skillshots = {
			["KennenShurikenHurlMissile1"] = {name = "Thundering Shuriken", spellName = "KennenShurikenHurlMissile1", castDelay = 180, projectileName = "kennen_ts_mis.troy", projectileSpeed = 1700, range = 1050, radius = 50, type = "line", fuckedUp = false, blockable = true, danger = 0}--could be 4 if you have 2 marks
	}},
		["Amumu"] = {charName = "Amumu", skillshots = {
			["BandageToss"] = {name = "BandageToss", spellName = "BandageToss", castDelay = 260, projectileName = "Bandage_beam.troy", projectileSpeed = 2000, range = 1100, radius = 80, type = "line", evasiondanger = true, fuckedUp = false, blockable = true, danger = 1}
	}},
		["LeeSin"] = {charName = "LeeSin", skillshots = {
			["BlindMonkQOne"] = {name = "Sonic Wave", spellName = "BlindMonkQOne", castDelay = 218, projectileName = "blindMonk_Q_mis_01.troy", projectileSpeed = 1844, range = 1100, radius = 60+10, type = "line", fuckedUp = false, blockable = true, danger = 1} --if he hit this he will slow you
	}},
		["Morgana"] = {charName = "Morgana", skillshots = {
			["DarkBindingMissile"] = {name = "DarkBinding", spellName = "DarkBindingMissile", castDelay = 250, projectileName = "DarkBinding_mis.troy", projectileSpeed = 1200, range = 1300, radius = 90, type = "line", fuckedUp = false, blockable = true, danger = 1},		
			["TormentedSoil"] = {name = "Tormented Soil", spellName = "TormentedSoil", castDelay = 250, projectileName = "", projectileSpeed = 1200, range = 900, radius = 300, type = "circular", blockable = false, danger = 1},
	}},
		["Ezreal"] = {charName = "Ezreal", skillshots = {
			["EzrealMysticShot"] = {name = "EzrealMysticShot", spellName = "EzrealMysticShot", castDelay = 250, projectileName = "Ezreal_mysticshot_mis.troy", projectileSpeed = 2000, range = 1200, radius = 80, type = "line", fuckedUp = false, blockable = true, danger = 0},
			["EzrealEssenceFlux"] = {name = "EzrealEssenceFlux", spellName = "EzrealEssenceFlux", castDelay = 250, projectileName = "Ezreal_essenceflux_mis.troy", projectileSpeed = 1500, range = 1050, radius = 80, type = "line", fuckedUp = false, blockable = true, danger = 0},
			["EzrealMysticShotPulse"] = {name = "EzrealMysticShotPulse", spellName = "EzrealMysticShotPulse", castDelay = 250, projectileName = "Ezreal_mysticshot_mis.troy", projectileSpeed = 2000, range = 1200, radius = 80, type = "line", fuckedUp = false, blockable = true, danger = 0},
			["EzrealTrueshotBarrage"] = {name = "EzrealTrueshotBarrage", spellName = "EzrealTrueshotBarrage", castDelay = 1000, projectileName = "Ezreal_TrueShot_mis.troy", projectileSpeed = 2000, range = 20000, radius = 160, type = "line", fuckedUp = true, blockable = true, danger = 0},
	}},
		["Ahri"] = {charName = "Ahri", skillshots = {
			["AhriOrbofDeception"] = {name = "Orb of Deception", spellName = "AhriOrbofDeception", castDelay = 250, projectileName = "Ahri_Orb_mis.troy", projectileSpeed = 1750, range = 900, radius = 100, type = "line", fuckedUp = false, blockable = true, danger = 0},
			["AhriSeduce"] = {name = "Charm", spellName = "AhriSeduce", castDelay = 250, projectileName = "Ahri_Charm_mis.troy", projectileSpeed = 1600, range = 1000, radius = 60, type = "line", fuckedUp = false, blockable = true, danger = 1}
	}},
		["Olaf"] = {charName = "Olaf", skillshots = {
			["OlafAxeThrowCast"] = {name = "OlafAxeThrowCast", spellName = "OlafAxeThrowCast", castDelay = 265, projectileName = "olaf_axe_mis.troy", projectileSpeed = 1600, range = 1000, radius = 90, type = "line", fuckedUp = false, blockable = true, danger = 1}
	}},
		["Leona"] = {charName = "Leona", skillshots = { -- Q+ R+
			["LeonaZenithBlade"] = {name = "Zenith Blade", spellName = "LeonaZenithBlade", castDelay = 250, projectileName = "Leona_ZenithBlade_mis.troy", projectileSpeed = 2000, range = 900, radius = 100, type = "line", fuckedUp = false, blockable = true, danger = 1},
			["LeonaSolarFlare"] = {name = "Leona Solar Flare", spellName = "LeonaSolarFlare", castDelay = 250, projectileName = "Leona_SolarFlare_cas.troy", projectileSpeed = 650+350, range = 1200, radius = 300, type = "circular", fuckedUp = false, blockable = true, danger = 1}
	}},
		["Karthus"] = {charName = "Karthus", skillshots = {
			["LayWaste"] = {name = "Lay Waste", spellName = "LayWaste", castDelay = 250, projectileName = "LayWaste_point.troy", projectileSpeed = 1750, range = 875, radius = 140, type = "circular", blockable = false, danger = 0}
	}},
		["Chogath"] = {charName = "Chogath", skillshots = {
			["Rupture"] = {name = "Rupture", spellName = "Rupture", castDelay = 0, projectileName = "rupture_cas_01_red_team.troy", projectileSpeed = 950, range = 950, radius = 250, type = "circular", blockable = false, danger = 1}
	}},
		["Blitzcrank"] = {charName = "Blitzcrank", skillshots = {
			["RocketGrabMissile"] = {name = "Rocket Grab", spellName = "RocketGrabMissile", castDelay = 250, projectileName = "FistGrab_mis.troy", projectileSpeed = 1800, range = 1050, radius = 70, type = "line", fuckedUp = false, blockable = true, danger = 1}
	}},
		["Anivia"] = {charName = "Anivia", skillshots = {
			["FlashFrostSpell"] = {name = "Flash Frost", spellName = "FlashFrostSpell", castDelay = 250, projectileName = "cryo_FlashFrost_mis.troy", projectileSpeed = 850, range = 1100, radius = 110, type = "line", fuckedUp = false, blockable = true, danger = 1},
			["FrostBite"] = {name = "FrostBite", spellName = "FrostBite", castDelay = 250, projectileName = "cryo_FrostBite_mis.troy", projectileSpeed = 1200, range = 1100, radius = 110, type = "line", fuckedUp = false, blockable = true, danger = 1},
	}},
		["Annie"] = {charName = "Annie", skillshots = {
			["Disintegrate"] = {name = "Disintegrate", spellName = "Disintegrate", castDelay = 250, projectileName = "Disintegrate.troy", projectileSpeed = 1500, range = 875, radius = 140, fuckedUp = false, blockable = true, danger = 0}
	}},
		["Katarina"] = {charName = "Katarina", skillshots = {
			["KatarinaR"] = {name = "Death Lotus", spellName = "KatarinaR", range = 550, fuckedUp = true, blockable = true, danger = 1},
			["KatarinaQ"] = {name = "Bouncing Blades", spellName = "KatarinaQ", range = 675, fuckedUp = false, blockable = true, danger = 1},
	}}, 
		["Zyra"] = {charName = "Zyra", skillshots = {
			-- ["Deadly Bloom"] = {name = "Deadly Bloom", spellName = "ZyraQFissure", castDelay = 250, projectileName = "zyra_Q_cas.troy", projectileSpeed = 1400, range = 825, radius = 220, type = "circular", fuckedUp = false, blockable = true, danger = 0},
			["ZyraGraspingRoots"] = {name = "ZyraGraspingRoots", spellName = "ZyraGraspingRoots", castDelay = 230, projectileName = "Zyra_Dummy_Controller.troy", projectileSpeed = 1150, range = 1150, radius = 70, type = "line", fuckedUp = false, blockable = true, danger = 1},
			["zyrapassivedeathmanager"] = {name = "Zyra Passive", spellName = "zyrapassivedeathmanager", castDelay = 500, projectileName = "zyra_passive_plant_mis.troy", projectileSpeed = 2000, range = 1474, radius = 60, type = "line", fuckedUp = false, blockable = true, danger = 0},
	}},
		["Gragas"] = {charName = "Gragas", skillshots = {
			["Barrel Roll"] = {name = "Barrel Roll", spellName = "GragasBarrelRoll", castDelay = 250, projectileName = "gragas_barrelroll_mis.troy", projectileSpeed = 1000, range = 1115, radius = 180, type = "circular", fuckedUp = false, blockable = true, danger = 0},
			["Barrel Roll Missile"] = {name = "Barrel Roll Missile", spellName = "GragasBarrelRollMissile", castDelay = 0, projectileName = "gragas_barrelroll_mis.troy", projectileSpeed = 1000, range = 1115, radius = 180, type = "circular", fuckedUp = false, blockable = true, danger = 0},
	}},
		["Gragas"] = {charName = "Gragas", skillshots = {
			["GragasExplosiveCask"] = {name = "Gragas Ult", spellName="GragasExplosiveCask", blockable=true, danger = 0, range=1050},
			["GragasBarrelRoll"] = {name = "GragasBarrelRoll", spellName="GragasBarrelRoll", blockable=true, danger = 0, range=950}
	}},
		["Nautilus"] = {charName = "Nautilus", skillshots = {
			["NautilusAnchorDrag"] = {name = "Dredge Line", spellName = "NautilusAnchorDrag", castDelay = 250, projectileName = "Nautilus_Q_mis.troy", projectileSpeed = 2000, range = 1080, radius = 80, type = "line", fuckedUp = false, blockable = true, danger = 1},
	}},
		--[[["Urgot"] = {charName = "Urgot", skillshots = {
			["Acid Hunter"] = {name = "Acid Hunter", spellName = "UrgotHeatseekingLineMissile", castDelay = 175, projectileName = "UrgotLineMissile_mis.troy", projectileSpeed = 1600, range = 1000, radius = 60, type = "line", fuckedUp = false, blockable = true, danger = 0},
			["Plasma Grenade"] = {name = "Plasma Grenade", spellName = "UrgotPlasmaGrenade", castDelay = 250, projectileName = "UrgotPlasmaGrenade_mis.troy", projectileSpeed = 1750, range = 900, radius = 250, type = "circular", fuckedUp = false, blockable = true, danger = 1},
	}},]]--
		["Caitlyn"] = {charName = "Caitlyn", skillshots = {
			["CaitlynPiltoverPeacemaker"] = {name = "Piltover Peacemaker", spellName = "CaitlynPiltoverPeacemaker", castDelay = 625, projectileName = "caitlyn_Q_mis.troy", projectileSpeed = 2200, range = 1300, radius = 90, type = "line", fuckedUp = false, blockable = true, danger = 0},
			["CaitlynEntrapment"] = {name = "Caitlyn Entrapment", spellName = "CaitlynEntrapment", castDelay = 150, projectileName = "caitlyn_entrapment_mis.troy", projectileSpeed = 2000, range = 950, radius = 80, type = "line", fuckedUp = false, blockable = true, danger = 1},
			["CaitlynHeadshotMissile"] = {name = "Ace in the Hole", spellName = "CaitlynHeadshotMissile", range = 3000, fuckedUp = true, blockable = true, danger = 1, projectileName = "caitlyn_ult_mis.troy"},
	}},
		["DrMundo"] = {charName = "DrMundo", skillshots = {
			["InfectedCleaverMissile"] = {name = "Infected Cleaver", spellName = "InfectedCleaverMissile", castDelay = 250, projectileName = "dr_mundo_infected_cleaver_mis.troy", projectileSpeed = 2000, range = 1050, radius = 75, type = "line", fuckedUp = false, blockable = true, danger = 1},
	}},
		["Brand"] = {charName = "Brand", skillshots = { -- Q+ W+
			["BrandBlaze"] = {name = "BrandBlaze", spellName = "BrandBlaze", castDelay = 250, projectileName = "BrandBlaze_mis.troy", projectileSpeed = 1600, range = 1100, radius = 80, type = "line", fuckedUp = false, blockable = true, danger = 1},
			["BrandWildfire"] = {name = "BrandWildfire", spellName = "BrandWildfire", castDelay = 250, projectileName = "BrandWildfire_mis.troy", projectileSpeed = 1000, range = 1100, radius = 250, type = "circular", fuckedUp = false, blockable = true, danger = 0}
	}},
		["Corki"] = {charName = "Corki", skillshots = {
			["MissileBarrage"] = {name = "Missile Barrage", spellName = "MissileBarrage", castDelay = 250, projectileName = "corki_MissleBarrage_mis.troy", projectileSpeed = 2000, range = 1300, radius = 40, type = "line", fuckedUp = false, blockable = true, danger = 0},
	}},
		["TwistedFate"] = {charName = "TwistedFate", skillshots = {
			["WildCards"] = {name = "Loaded Dice", spellName = "WildCards", castDelay = 250, projectileName = "Roulette_mis.troy", projectileSpeed = 1000, range = 1450, radius = 40, type = "line", fuckedUp = false, blockable = true, danger = 0},
	}},
		["Swain"] = {charName = "Swain", skillshots = {
			["SwainShadowGrasp"] = {name = "Nevermove", spellName = "SwainShadowGrasp", castDelay = 250, projectileName = "swain_shadowGrasp_transform.troy", projectileSpeed = 1000, range = 900, radius = 180, type = "circular", fuckedUp = false, blockable = true, danger = 1},
			["SwainTorment"] = {name = "SwainTorment", spellName = "SwainTorment", castDelay = 250, projectileName = "swain_torment_mis.troy", projectileSpeed = 1000, range = 900, radius = 180, type = "circular", fuckedUp = false, blockable = true, danger = 1}
	}},
		["Cassiopeia"] = {charName = "Cassiopeia", skillshots = {
			["CassiopeiaNoxiousBlast"] = {name = "Noxious Blast", spellName = "CassiopeiaNoxiousBlast", castDelay = 250, projectileName = "CassNoxiousSnakePlane_green.troy", projectileSpeed = 500, range = 850, radius = 130, type = "circular", blockable = false, danger = 0},
	}},
		["Sivir"] = {charName = "Sivir", skillshots = { --hard to measure speed
			["SivirQ"] = {name = "Boomerang Blade", spellName = "SivirQ", castDelay = 250, projectileName = "Sivir_Base_Q_mis.troy", projectileSpeed = 1350, range = 1175, radius = 101, type = "line", fuckedUp = false, blockable = true, danger = 0},
	}},
		["Ashe"] = {charName = "Ashe", skillshots = {
			["EnchantedCrystalArrow"] = {name = "Enchanted Arrow", spellName = "EnchantedCrystalArrow", castDelay = 250, projectileName = "EnchantedCrystalArrow_mis.troy", projectileSpeed = 1600, range = 25000, radius = 130, type = "line", fuckedUp = true, blockable = true, danger = 1},
			["Volley"] = {name = "Volley", spellName = "Volley", range = 1200, fuckedUp = false, blockable = true, danger = 1},
	}},
		["KogMaw"] = {charName = "KogMaw", skillshots = {
			["KogMawQMis"] = {name = "KogMawQMis", spellName = "KogMawQMis", castDelay = 0, projectileName = "KogMawSpit_mis.troy", projectileSpeed = 1650, range = 1000, radius = 80, type = "line", fuckedUp = false, blockable = true, danger = 1},
			["KogMawVoidOozeMissile"] = {name = "KogMawVoidOozeMissile", spellName = "KogMawVoidOozeMissile", castDelay = 250, projectileName = "KogMawVoidOozeMissile_mis.troy", projectileSpeed = 1433, range = 1280, radius = 150, type = "line", fuckedUp = false, blockable = true, danger = 1},			
			["KogMawLivingArtillery"] = {name = "Living Artillery", spellName = "KogMawLivingArtillery", castDelay = 250, projectileName = "KogMawLivingArtillery_mis.troy", projectileSpeed = 1050, range = 2200, radius = 225, type = "circular", blockable = false, danger = 0},
	}},
		["Khazix"] = {charName = "Khazix", skillshots = {
			["KhazixW"] = {name = "KhazixW", spellName = "KhazixW", castDelay = 250, projectileName = "Khazix_W_mis_enhanced.troy", projectileSpeed = 1700, range = 1025, radius = 70, type = "line", fuckedUp = false, blockable = true, danger = 0},
			--["khazixwlong"] = {name = "khazixwlong", spellName = "khazixwlong", castDelay = 250, projectileName = "Khazix_W_mis_enhanced.troy", projectileSpeed = 1700, range = 1025, radius = 70, type = "line", fuckedUp = false, blockable = true, danger = 0},
	}},
		["Zed"] = {charName = "Zed", skillshots = {
			["ZedShuriken"] = {name = "ZedShuriken", spellName = "ZedShuriken", castDelay = 250, projectileName = "Zed_Q_Mis.troy", projectileSpeed = 1700, range = 925, radius = 50, type = "line", fuckedUp = false, blockable = true, danger = 0},
			--["ZedShuriken2"] = {name = "ZedShuriken2", spellName = "ZedShuriken!", castDelay = 250, projectileName = "Zed_Q2_Mis.troy", projectileSpeed = 1700, range = 925, radius = 50, type = "line", fuckedUp = false, blockable = true, danger = 0},
	}},
		["Leblanc"] = {charName = "Leblanc", skillshots = {
			["LeblancChaosOrb"] = {name = "Ethereal LeblancChaosOrb", spellName = "LeblancChaosOrb", castDelay = 250, projectileName = "Leblanc_ChaosOrb_mis.troy", projectileSpeed = 1600, range = 960, radius = 70, fuckedUp = false, blockable = true, danger = 1},
			["LeblancChaosOrbM"] = {name = "Ethereal LeblancChaosOrbM", spellName = "LeblancChaosOrbM", castDelay = 250, projectileName = "Leblanc_ChaosOrb_mis_ult.troy", projectileSpeed = 1600, range = 960, radius = 70, fuckedUp = false, blockable = true, danger = 1},
			["LeblancSoulShackle"] = {name = "Ethereal Chains", spellName = "LeblancSoulShackle", castDelay = 250, projectileName = "leBlanc_shackle_mis.troy", projectileSpeed = 1600, range = 960, radius = 70, type = "line", fuckedUp = false, blockable = true, danger = 1},
			["LeblancSoulShackleM"] = {name = "Ethereal Chains R", spellName = "LeblancSoulShackleM", castDelay = 250, projectileName = "leBlanc_shackle_mis_ult.troy", projectileSpeed = 1600, range = 960, radius = 70, type = "line", fuckedUp = false, blockable = true, danger = 1},
			["LeblancMimic"] = {name = "LeblancMimic", spellName="LeblancMimic", blockable="true", danger = 0, range=650}
	}},
		["Draven"] = {charName = "Draven", skillshots = {
			["DravenDoubleShot"] = {name = "Stand Aside", spellName = "DravenDoubleShot", castDelay = 250, projectileName = "Draven_E_mis.troy", projectileSpeed = 1400, range = 1100, radius = 130, type = "line", fuckedUp = false, blockable = true, danger = 1},
			["DravenRCast"] = {name = "DravenR", spellName = "DravenRCast", castDelay = 500, projectileName = "Draven_R_mis!.troy", projectileSpeed = 2000, range = 25000, radius = 160, type = "line", fuckedUp = false, blockable = true, danger = 0},
	}},
		["Elise"] = {charName = "Elise", skillshots = {
			["EliseHumanE"] = {name = "Cocoon", spellName = "EliseHumanE", castDelay = 250, projectileName = "Elise_human_E_mis.troy", projectileSpeed = 1450, range = 1100, radius = 70, type = "line", fuckedUp = false, blockable = true, danger = 1}
	}},
		["Lulu"] = {charName = "Lulu", skillshots = {
			["LuluQ"] = {name = "LuluQ", spellName = "LuluQ", castDelay = 250, projectileName = "Lulu_Q_Mis.troy", projectileSpeed = 1450, range = 1000, radius = 50, type = "line", fuckedUp = false, blockable = true, danger = 1}
	}},
		["Thresh"] = {charName = "Thresh", skillshots = {
			["ThreshQ"] = {name = "ThreshQ", spellName = "ThreshQ", castDelay = 500, projectileName = "Thresh_Q_whip_beam.troy", projectileSpeed = 1900, range = 1100, radius = 65, type = "line", fuckedUp = false, blockable = true, danger = 1} -- 60 real radius
	}},
		["Shen"] = {charName = "Shen", skillshots = {
			["ShenShadowDash"] = {name = "ShadowDash", spellName = "ShenShadowDash", castDelay = 0, projectileName = "shen_shadowDash_mis.troy", projectileSpeed = 3000, range = 575, radius = 50, type = "line", blockable = false, danger = 1}
	}},
		["Quinn"] = {charName = "Quinn", skillshots = {
			["QuinnQ"] = {name = "QuinnQ", spellName = "QuinnQ", castDelay = 250, projectileName = "Quinn_Q_missile.troy", projectileSpeed = 1550, range = 1050, radius = 80, type = "line", fuckedUp = false, blockable = true, danger = 0}
	}},
		["Veigar"] = {charName = "Veigar", skillshots = {
			["VeigarPrimordialBurst"] = {name = "VeigarPrimordialBurst", spellName="VeigarPrimordialBurst", projectileName = "permission_Shadowbolt_mis.troy", fuckedUp = false, blockable= true, danger = 0, range = 650},
			["VeigarBalefulStrike"] = {name = "VeigarBalefulStrike", spellName="VeigarBalefulStrike", projectileName = "permission__mana_flare_mis.troy.troy", fuckedUp = false, blockable= true, danger = 0, range=650}
	}},
		["Veigar"] = {charName = "Veigar", skillshots = {
			["VeigarDarkMatter"] = {name = "VeigarDarkMatter", spellName = "VeigarDarkMatter", castDelay = 250, projectileName = "!", projectileSpeed = 900, range = 900, radius = 225, type = "circular", fuckedUp = false, blockable = true, danger = 0}
	}},
	
		["Diana"] = {charName = "Diana", skillshots = {
			["DianaArc"] = {name = "DianaArc", spellName = "DianaArc", castDelay = 250, projectileName = "Diana_Q_trail.troy", projectileSpeed = 1600, range = 1000, radius = 195, type="circular", fuckedUp = false, blockable = true, danger = 0},
	}},
		["Jayce"] = {charName = "Jayce", skillshots = {
			["jayceshockblast"] = {name = "jayceshockblast", spellName = "jayceshockblast!", castDelay = 250, projectileName = "JayceOrbLightning.troy", projectileSpeed = 1450, range = 1050, radius = 70, type = "line", fuckedUp = false, blockable = true, danger = 0},
			["Q2"] = {name = "Q2", spellName = "JayceShockBlast", castDelay = 250, projectileName = "JayceOrbLightningCharged.troy", projectileSpeed = 2350, range = 1600, radius = 70, type = "line", fuckedUp = false, blockable = true, danger = 0},
	}},
		["Nami"] = {charName = "Nami", skillshots = {
			["NamiQ"] = {name = "NamiQ", spellName = "NamiQ", castDelay = 250, projectileName = "Nami_Q_mis.troy", projectileSpeed = 800, range = 850, radius = 225, type="circular", fuckedUp = false, blockable = true, danger = 1},
			["NamiRMissile"] = {name = "NamiRMissile", spellName = "NamiRMissile", castDelay = 484, projectileName = "Nami_R_Mis.troy", projectileSpeed = 846, range = 2735, radius = 210, type = "line", fuckedUp = true, blockable = true, danger = 1},
	}},
		["Fizz"] = {charName = "Fizz", skillshots = {
			["FizzMarinerDoom"] = {name = "Fizz ULT", spellName = "FizzMarinerDoom", castDelay = 250, projectileName = "Fizz_UltimateMissile.troy", projectileSpeed = 1350, range = 1275, radius = 80, type = "line", fuckedUp = false, blockable = true, danger = 1},
	}},
		["Varus"] = {charName = "Varus", skillshots = {
			["VarusQ"] = {name = "Varus Q Missile", spellName = "VarusQ", castDelay = 0, projectileName = "VarusQ_mis.troy", projectileSpeed = 1900, range = 1600, radius = 70, type = "line", fuckedUp = false, blockable = true, danger = 0},
			["VarusE"] = {name = "Varus E", spellName = "VarusE", castDelay = 250, projectileName = "VarusEMissileLong.troy", projectileSpeed = 1500, range = 925, radius = 275, type = "circular", fuckedUp = false, blockable = true, danger = 1},
			["VarusR"] = {name = "VarusR", spellName = "VarusR", castDelay = 250, projectileName = "VarusRMissile.troy", projectileSpeed = 1950, range = 1250, radius = 100, type = "line", fuckedUp = false, blockable = true, danger = 1},
	}},
		["Karma"] = {charName = "Karma", skillshots = {
			["KarmaQ"] = {name = "KarmaQ", spellName = "KarmaQ", castDelay = 250, projectileName = "TEMP_KarmaQMis.troy", projectileSpeed = 1700, range = 1050, radius = 90, type = "line", fuckedUp = false, blockable = true, danger = 1},
	}},
		["Aatrox"] = {charName = "Aatrox", skillshots = {--Radius starts from 150 and scales down, so I recommend putting half of it, because you won't dodge pointblank skillshots.
			["AatroxE"] = {name = "Blade of Torment", spellName = "AatroxE", castDelay = 250, projectileName = "AatroxBladeofTorment_mis.troy", projectileSpeed = 1200, range = 1075, radius = 75, type = "line", fuckedUp = false, blockable = true, danger = 1},
			["AatroxQ"] = {name = "AatroxQ", spellName = "AatroxQ", castDelay = 250, projectileName = "AatroxQ.troy", projectileSpeed = 450, range = 650, radius = 145, type = "circular", fuckedUp = false, blockable = true, danger = 1},
	}},
		["Xerath"] = {charName = "Xerath", skillshots = {
			["XerathArcanopulse"] = {name = "Xerath Arcanopulse", spellName = "XerathArcanopulse", castDelay = 1375, projectileName = "Xerath_Beam_cas.troy", projectileSpeed = math.huge, range = 1025, radius = 100, type = "line", fuckedUp = false, blockable = true, danger = 0},
			["xeratharcanopulseextended"] = {name = "Xerath Arcanopulse Extended", spellName = "xeratharcanopulseextended", castDelay = 1375, projectileName = "Xerath_Beam_cas.troy", projectileSpeed = math.huge, range = 1625, radius = 100, type = "line", fuckedUp = false, blockable = true, danger = 0},
			["xeratharcanebarragewrapper"] = {name = "xeratharcanebarragewrapper", spellName = "xeratharcanebarragewrapper", castDelay = 250, projectileName = "Xerath_E_cas_green.troy", projectileSpeed = 300, range = 1100, radius = 265, type = "circular", fuckedUp = false, blockable = true, danger = 0},
			["xeratharcanebarragewrapperext"] = {name = "xeratharcanebarragewrapperext", spellName = "xeratharcanebarragewrapperext", castDelay = 250, projectileName = "Xerath_E_cas_green.troy", projectileSpeed = 300, range = 1600, radius = 265, type = "circular", fuckedUp = false, blockable = true, danger = 0}
	}},
		["Xerath"] = {charName = "Xerath", skillshots = {
			["XerathMageSpearMissile"] = {name = "XerathMageSpearMissile", spellName = "XerathMageSpearMissile",castDelay = 0, projectileName = "Xerath_Base_E_mis.troy", projectileSpeed = 1200, range = 1300, radius = 80, type = "line", fuckedUp = false, blockable = true, danger = 1},
			["xerathlocuspulse"] = {name = "xerathlocuspulse", spellName = "xerathlocuspulse",castDelay = 0, projectileName = "Xerath_Base_R_mis.troy", projectileSpeed = 1200, range = 5600, radius = 80, type = "line", fuckedUp = false, blockable = true, danger = 1},
	}},
		["Velkoz"] = {charName = "Velkoz", skillshots = {
			["VelkozQMissile"] = {name = "VelkozQMissile", spellName = "VelkozQMissile", castDelay = 250, projectileName = "Velkoz_Base_Q_mis.troy", projectileSpeed = 1300, range = 1100, radius = 80, type = "line", fuckedUp = false, blockable = true, danger = 1},
			["velkozqsplitactivate"] = {name = "velkozqsplitactivate", spellName = "velkozqsplitactivate", castDelay = 250, projectileName = "Velkoz_Base_Q_Split_mis.troy", projectileSpeed = 1300, range = 1100, radius = 80, type = "line", fuckedUp = false, blockable = true, danger = 1},		
			["VelkozW"] = {name = "VelkozW", spellName = "VelkozW", castDelay = 250, projectileName = "Velkoz_Base_W_Turret.troy", projectileSpeed = 1600, range = 1100, radius = 80, type = "line", fuckedUp = false, blockable = true, danger = 1},
			["velkozqsplitactivate"] = {name = "velkozqsplitactivate", spellName = "velkozqsplitactivate", castDelay = 250, projectileName = "Velkoz_Base_Q_Split_mis.troy", projectileSpeed = 1300, range = 1100, radius = 80, type = "line", fuckedUp = false, blockable = true, danger = 1},		
			["VelkozR"] = {name = "VelkozR", spellName = "VelkozR", castDelay = 250, projectileName = "FountainHeal.troy", projectileSpeed = 1300, range = 1100, radius = 80, type = "line", fuckedUp = false, blockable = true, danger = 1},
			["VelkozR"] = {name = "VelkozR", spellName = "VelkozR", castDelay = 250, projectileName = "Velkoz_Base_R_beam.troy", projectileSpeed = 1300, range = 1100, radius = 80, type = "line", fuckedUp = false, blockable = true, danger = 1},
			["VelkozR"] = {name = "VelkozR", spellName = "VelkozR", castDelay = 250, projectileName = "Velkoz_Base_R_Lens.troy", projectileSpeed = 1300, range = 1100, radius = 80, type = "line", fuckedUp = false, blockable = true, danger = 1},
	}},	
		["Graves"] = {charName = "Graves", skillshots = {
			["GravesClusterShot"] = {name = "Light Binding", spellName = "GravesClusterShot", castDelay = 250, projectileName = "LuxLightBinding_mis.troy", projectileSpeed = 1200, range = 1300, radius = 80, type = "line", fuckedUp = false, blockable = true, danger = 1},
			["GravesChargeShot"] = {name = "LuxLightStrikeKugel", spellName = "GravesChargeShot", castDelay = 250, projectileName = "LuxLightstrike_mis.troy", projectileSpeed = 1400, range = 1100, radius = 275, type = "line", fuckedUp = false, blockable = true, danger = 1},
			
	}},	
	
	
		["Lucian"] = {charName = "Lucian", skillshots = {
			["LucianQ"] = {name = "LucianQ", spellName = "LucianQ", castDelay = 350, projectileName = "Lucian_Q_laser.troy", projectileSpeed = math.huge, range = 570*2, radius = 65, type = "line", fuckedUp = false, blockable = true, danger = 0},
			["LucianW"] = {name = "LucianW", spellName = "LucianW", castDelay = 300, projectileName = "Lucian_W_mis.troy", projectileSpeed = 1600, range = 1000, radius = 80, type = "line", fuckedUp = false, blockable = true, danger = 0},
	}},
		["Rumble"] = {charName = "Rumble", skillshots = {
			["RumbleGrenade"] = {name = "RumbleGrenade", spellName = "RumbleGrenade", castDelay = 250, projectileName = "rumble_taze_mis.troy", projectileSpeed = 2000, range = 950, radius = 90, type = "line", fuckedUp = false, blockable = true, danger = 1},
	}},
		["Nocturne"] = {charName = "Nocturne", skillshots = {
			["NocturneDuskbringer"] = {name = "NocturneDuskbringer", spellName = "NocturneDuskbringer", castDelay = 250, projectileName = "NocturneDuskbringer_mis.troy", projectileSpeed = 1400, range = 1125, radius = 60, type = "line", fuckedUp = false, blockable = true, danger = 0},
	}},
		["MissFortune"] = {charName = "MissFortune", skillshots = {
			["MissFortuneScattershot"] = {name = "Scattershot", spellName = "MissFortuneScattershot", castDelay = 250, projectileName = "", projectileSpeed = 1400, range = 800, radius = 200, type = "circular", blockable = false, danger = 0},
			["MissFortuneBulletTime"] = {name = "Bullettime", spellName = "MissFortuneBulletTime", castDelay = 250, projectileName = "", projectileSpeed = 1400, range = 1400, radius = 200, type = "line", fuckedUp = false, blockable = true, danger = 0}
	}},
		["Orianna"] = {charName = "Orianna", skillshots = {
			--["OrianaIzunaCommand"] = {name = "OrianaIzunaCommand", spellName = "OrianaIzunaCommand!", castDelay = 250, projectileName = "Oriana_Ghost_mis.troy", projectileSpeed = 1200, range = 2000, radius = 80, type = "line", fuckedUp = false, blockable = true, danger = 0},
	}},
		["Ziggs"] = {charName = "Ziggs", skillshots = { -- Q changed to line in 1.10
			["ZiggsQ"] = {name = "ZiggsQ", spellName = "ZiggsQ", castDelay = 1500, projectileName = "ZiggsQ.troy", projectileSpeed = math.huge, range = 1500, radius = 100, type = "line", fuckedUp = false, blockable = true, danger = 0},
			["ZiggsW"] = {name = "ZiggsW", spellName = "ZiggsW", castDelay = 250, projectileName = "ZiggsW_mis.troy", projectileSpeed = math.huge, range = 1500, radius = 100, type = "line", fuckedUp = false, blockable = true, danger = 0},
			["ZiggsE"] = {name = "ZiggsE", spellName = "ZiggsE", castDelay = 250, projectileName = "ZiggsEMine.troy", projectileSpeed = math.huge, range = 1500, radius = 100, type = "line", fuckedUp = false, blockable = true, danger = 0},
			["ZiggsR"] = {name = "ZiggsR", spellName = "ZiggsR", projectileName = "ZiggsR_Mis_Nuke.troy", range = 1500, fuckedUp = true, blockable = true, danger = 0}
	}},
		["Galio"] = {charName = "Galio", skillshots = {
			["GalioResoluteSmite"] = {name = "GalioResoluteSmite", spellName = "GalioResoluteSmite", castDelay = 250, projectileName = "galio_concussiveBlast_mis.troy", projectileSpeed = 850, range = 2000, radius = 200, type = "circular", fuckedUp = false, blockable = true, danger = 1},
	}},
		["Yasuo"] = {charName = "Yasuo", skillshots = {
			["yasuoq3w"] = {name = "Steel Tempest", spellName = "yasuoq3w", castDelay = 300, projectileName = "Yasuo_Q_wind_mis.troy", projectileSpeed = 1200, range = 900, radius = 375, type = "line", fuckedUp = false, blockable = true, danger = 1},
	}},
		["Kassadin"] = {charName = "Kassadin", skillshots = {
			["NullLance"] = {name = "Null Sphere", spellName = "NullLance", castDelay = 300, projectileName = "Null_Lance_mis.troy", projectileSpeed = 1400, range = 650, radius = 1, type = "line", fuckedUp = false, blockable = true, danger = 1},
	}},
		["Jinx"] = {charName = "Jinx", skillshots = { -- R speed and delay increased
			["JinxWMissile"] = {name = "Zap", spellName = "JinxWMissile", castDelay = 600, projectileName = "Jinx_W_mis.troy", projectileSpeed = 3300, range = 1450, radius = 70, type = "line", fuckedUp = false, blockable = true, danger = 1},
			["JinxRWrapper"] = {name = "Super Mega Death Rocket", spellName = "JinxRWrapper", castDelay = 600+900, projectileName = "Jinx_R_Mis.troy", projectileSpeed = 2500, range = 20000, radius = 120, type = "line", fuckedUp = false, blockable = true, danger = 0}
	}},
		["Taric"] = {charName = "Taric", skillshots = {
			["Dazzle"] = {name = "Dazzle", spellName="Dazzle", blockable=true, danger = 0, range=625},
	}},
		["FiddleSticks"] = {charName = "FiddleSticks", skillshots = {
			["FiddlesticksDarkWind"] = {name = "DarkWind", spellName="FiddlesticksDarkWind", blockable=true, danger = 0, range=750},
	}}, 
		["Syndra"] = {charName = "Syndra", skillshots = { -- Q added in 1.10
			["SyndraQ"] = {name = "Q", spellName = "SyndraQ", castDelay = 250, projectileName = "Syndra_Q_cas.troy", projectileSpeed = 500, range = 800, radius = 175, type = "circular", blockable = false, danger = 0},
			["SyndraR"] = {name = "SyndraR", spellName="SyndraR", blockable=true, danger = 0, range=675}
	}},
		["Kayle"] = {charName = "Kayle", skillshots = {
			["JudicatorReckoning"] = {name = "JudicatorReckoning", spellName="JudicatorReckoning", castDelay = 100, projectileName = "Reckoning_mis.troy", projectileSpeed = 1500, range = 875, fuckedUp = false, blockable=true, danger = 1, range=650},
	}},
		["Heimerdinger"] = {charName = "Heimerdinger", skillshots = {
			["HeimerdingerW"] = {name = "HeimerdingerW", spellName = "HeimerdingerW", castDelay = 250, projectileName = "Heimerdinger_Base_w_Mis.troy", projectileSpeed = 1846, range = 1230, radius = 80, type = "line", blockable = true, danger = 0},
			["HeimerdingerW"] = {name = "HeimerdingerW", spellName = "HeimerdingerW", castDelay = 260, projectileName = "Heimerdinger_Base_W_Mis_Ult.troy", projectileSpeed = 1846, range = 1230, radius = 80, type = "line", blockable = true, danger = 0},		
			["Storm Grenade"] = {name = "Storm Grenade", spellName = "Storm Grenade", castDelay = 250, projectileName = "Heimerdinger_Base_E_Mis.troy", projectileSpeed = 2500, range = 970, radius = 80, type = "circular", blockable = true, danger = 1},
			["Storm Grenade"] = {name = "Storm Grenade", spellName = "Storm Grenade", castDelay = 250, projectileName = "Heimerdinger_Base_E_Mis_Ult.troy", projectileSpeed = 2500, range = 970, radius = 80, type = "circular", blockable = true, danger = 1},		
	}}, 
		["Annie"] = {charName = "Annie", skillshots = {
			["Disintegrate"] = {name = "Disintegrate", spellName = "Disintegrate", castDelay = 250, projectileName = "Disintegrate.troy", projectileSpeed = 1500, range = 875, radius = 140, fuckedUp = false, blockable = true, danger = 1}
	}},
		["Janna"] = {charName = "Janna", skillshots = {
			["HowlingGale"] = {name = "HowlingGale", spellName = "HowlingGale", castDelay = 250, projectileName = "HowlingGale_mis.troy", projectileSpeed = 1200, range = 1500, radius = 140, fuckedUp = false, blockable = true, danger = 1}
	}},
		["Lissandra"] = {charName = "Lissandra", skillshots = {
			["LissandraQMissile"] = {name = "LissandraQMissile", spellName = "LissandraQMissile", castDelay = 250, projectileName = "Lissandra_Q_mis.troy", projectileSpeed = 2160, range = 1300, radius = 80, type = "line", fuckedUp = false, blockable = true, danger = 1},
			["LissandraEMissile"] = {name = "LissandraEMissile", spellName = "LissandraEMissile", castDelay = 250, projectileName = "Lissandra_E_mis.troy", projectileSpeed = 850, range = 1000, radius = 275, type = "line", fuckedUp = false, blockable = true, danger = 1},
			["LissandraW"] = {name = "LissandraW", spellName = "LissandraW", castDelay = 10, projectileName = "Zyra_Dummy_Controller.troy", projectileSpeed = 3850, range = 430, radius = 275, type = "line", fuckedUp = false, blockable = true, danger = 1},
			
	}},	
	
		["Riven"] = {charName = "Riven", skillshots = {
			["rivenizunablade"] = {name = "rivenizunablade", spellName = "rivenizunablade", castDelay = 234, projectileName = "Riven_Base_R_Mis_Middle.troy", projectileSpeed = 2210, range = 1000, radius = 180, type = "line", fuckedUp = false, blockable = true, danger = 1}
	}},		
	
		["Pantheon"] = {charName = "Pantheon", skillshots = {
			["Pantheon_Throw"] = {name = "Pantheon_Throw", spellName = "Pantheon_Throw", castDelay = 250, projectileName = "pantheon_spear_mis.troy", projectileSpeed = 1500, range = 1500, radius = 140, fuckedUp = false, blockable = true, danger = 1}
	}},
	
		["Sejuani"] = {charName = "Sejuani", skillshots = {
			["SejuaniGlacialPrisonCast"] = {name = "SejuaniGlacialPrisonCast", spellName = "SejuaniGlacialPrisonCast", castDelay = 249, projectileName = "Sejuani_R_mis.troy", projectileSpeed = 1628, range = 1100, radius = 250, type = "line", fuckedUp = false, blockable = true, danger = 1}
	}},	
		["Ryze"] = {charName = "Ryze", skillshots = {
			["Overload"] = {name = "Overload", spellName = "Overload", castDelay = 250, projectileName = "Overload_mis.troy", projectileSpeed = 1500, range = 1500, radius = 140, fuckedUp = false, blockable = true, danger = 1},
			["SpellFlux"] = {name = "SpellFlux", spellName = "SpellFlux", castDelay = 250, projectileName = "SpellFlux_mis.troy", projectileSpeed = 1500, range = 1500, radius = 140, fuckedUp = false, blockable = true, danger = 1}
	}},
		["Malphite"] = {charName = "Malphite", skillshots = {
			["SeismicShard"] = {name = "SeismicShard", spellName = "SeismicShard", castDelay = 250, projectileName = "SeismicShard_mis.troy", projectileSpeed = 1500, range = 1500, radius = 140, fuckedUp = false, blockable = true, danger = 1}
	}},
		["Sona"] = {charName = "Sona", skillshots = {
			["SonaHymnofValor"] = {name = "SonaHymnofValor", spellName = "SonaHymnofValor", castDelay = 250, projectileName = "SonaHymnofValor_beam.troy", projectileSpeed = 1500, range = 1500, radius = 140, fuckedUp = false, blockable = true, danger = 1},
			["SonaCrescendo"] = {name = "SonaCrescendo", spellName = "SonaCrescendo", castDelay = 250, projectileName = "SonaCrescendo_mis.troy", projectileSpeed = 1500, range = 1500, radius = 500, fuckedUp = false, blockable = true, danger = 1}
	}},
		["Teemo"] = {charName = "Teemo", skillshots = {
			["BlindingDart"] = {name = "BlindingDart", spellName = "BlindingDart", castDelay = 250, projectileName = "BlindShot_mis.troy", projectileSpeed = 1500, range = 680, radius = 450, fuckedUp = false, blockable = true, danger = 1}
	}},
		["Vayne"] = {charName = "Vayne", skillshots = {
			["VayneCondemn"] = {name = "VayneCondemn", spellName = "VayneCondemn", castDelay = 250, projectileName = "vayne_E_mis.troy", projectileSpeed = 1200, range = 550, radius = 450, fuckedUp = false, blockable = true, danger = 1}
	}},
}

local qRange = 1000
local qWidth = 120 -- Increase if Q is hitting creep with collision ON.
local qSpeed = 1700
local qDelay = 0
local wRange = 700
local wWidth = 120 
local eRange = 1200
local eWidth = 120
local rRange = 1250
local rWidth = 100
local rSpeed = 1438
local rDelay = 510
local menu
local ts
local levelSequence = {1,3,2,1,1,4,1,3,1,3,4,3,2,3,2,4,2,2}

function OnLoad()
	VP = VPrediction()
	SxO = SxOrbWalk(VP)
	_G.oldDrawCircle = rawget(_G, 'DrawCircle')
	_G.DrawCircle = DrawCircle2
	init()
	menu()
	print("<font color='#aaff34'>tBraum -- Loaded Successfully</font>")
end

function init()		
	enemyMinions = minionManager(MINION_ENEMY, 1000, myHero)
	jungleMinions = minionManager(MINION_JUNGLE, 1000, myHero)
	allyMinions = minionManager(MINION_ALLY, 1000, myHero)
	
	if myHero:GetSpellData(SUMMONER_1).name:find("SummonerDot") then 
		ignite = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find("SummonerDot") then 
		ignite = SUMMONER_2
	else 
		ignite = nil
	end
end

function menu() 
	menu = scriptConfig("tBraum: Main Menu", "Braum")
	ts = TargetSelector(TARGET_LESS_CAST, 1300, DAMAGE_PHYSICAL)
	
	menu:addSubMenu("tBraum: SxOrbwalk", "Orbwalk")
	SxO:LoadToMenu(menu.Orbwalk) 
	
	menu:addSubMenu("tBraum: Spells + Combo", "combo")
	menu.combo:addParam("combokey", "Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
	menu.combo:addSubMenu("Q Settings", "qSettings")
	menu.combo.qSettings:addParam("useQ", "Use Q in Combo", SCRIPT_PARAM_ONOFF, true)
	menu.combo:addSubMenu("W Settings", "wSettings")
	menu.combo.wSettings:addParam("wClose", "Cast W to Closest Ally", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("S"))
	menu.combo.wSettings:addParam("saveAlly", "Use W to Save Low Allies", SCRIPT_PARAM_ONOFF, true)
	menu.combo.wSettings:addParam("evadeee", "Use Evadeee Integration", SCRIPT_PARAM_ONOFF, false)
	menu.combo:addSubMenu("R Settings", "rSettings")
	menu.combo.rSettings:addParam("useR", "Use R in Combo", SCRIPT_PARAM_ONOFF, true)
	menu.combo.rSettings:addParam("targets", "Minimum Enemies to Auto R", SCRIPT_PARAM_SLICE, 2, 0, 5, 0)
	menu.combo.rSettings:addParam("hitchance", "R Hitchance", SCRIPT_PARAM_SLICE, 2, 0, 3, 0)
	--menu.combo:addParam("useQ", "Use Q-Spell", SCRIPT_PARAM_ONOFF, true)
	--menu.combo:addParam("useW", "Use W-Spell", SCRIPT_PARAM_ONOFF, true)
	--menu.combo:addParam("useR", "Use R-Spell", SCRIPT_PARAM_ONOFF, true)
	
	menu:addSubMenu("tBraum: Harass", "harass")
	menu.harass:addParam("harasskey", "Harass", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
	menu.harass:addParam("useQ", "Use Q in Harass", SCRIPT_PARAM_ONOFF, true)
	menu.harass:addParam("autoQ", "Q Auto Harass", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("Y"))
	menu.harass:addParam("mana", "Dont Auto Q Harass if mana < %", SCRIPT_PARAM_SLICE, 0, 0, 100)
	
	menu:addSubMenu("tBraum: Blockable Skillshots", "block")
	menu.block:addParam("autoE", "Auto E to Block Spells", SCRIPT_PARAM_ONOFF, true)
	
	for i = 1, heroManager.iCount,1 do
		local hero = heroManager:getHero(i)
		if hero.team ~= player.team then
			if Champions[hero.charName] ~= nil then
				for index, skillshot in pairs(Champions[hero.charName].skillshots) do
					if skillshot.blockable == true then
						menu.block:addParam(skillshot.spellName, hero.charName .. " - " .. skillshot.name, SCRIPT_PARAM_ONOFF, true)
					end
				end
			end
		end
	end	
	
	menu:addSubMenu("tBraum: Killsteal", "killsteal")
	menu.killsteal:addParam("killstealQ", "Use Q-Spell to Killsteal", SCRIPT_PARAM_ONOFF, true)
	menu.killsteal:addParam("autoIgnite", "Auto Ignite", SCRIPT_PARAM_ONOFF, true)
	
	menu:addSubMenu("tBraum: Drawings", "draw")
	menu.draw:addParam("drawQ", "Draw Q Range", SCRIPT_PARAM_ONOFF, true)
	menu.draw:addParam("drawW", "Draw W Range", SCRIPT_PARAM_ONOFF, true)
	menu.draw:addParam("drawR", "Draw R Range", SCRIPT_PARAM_ONOFF, true)
	
	menu.draw:addSubMenu("tBraum: LagFreeCircles", "LFC")
	menu.draw.LFC:addParam("LagFree", "Activate Lag Free Circles", SCRIPT_PARAM_ONOFF, false)
	menu.draw.LFC:addParam("CL", "Length before Snapping", SCRIPT_PARAM_SLICE, 350, 75, 2000, 0)
	menu.draw.LFC:addParam("CLinfo", "Higher length = Lower FPS Drops", SCRIPT_PARAM_INFO, "")
	
	menu:addSubMenu("tBraum: Extras", "extra")
	menu.extra:addParam("autolevel", "AutoLevel Spells (Requires F9)", SCRIPT_PARAM_ONOFF, false)
	--menu.extra:addParam("interrupt", "Interrupt Important Spells with R", SCRIPT_PARAM_ONOFF, true)
	menu.extra:addParam("packets", "Use Packets to Cast Spells", SCRIPT_PARAM_ONOFF, false)
	menu.extra:addParam("prediction", "Prodiction = ON, VPred = Off", SCRIPT_PARAM_ONOFF, false)
	menu.extra:addParam("debug", "Debug", SCRIPT_PARAM_ONOFF, false)

	menu:addTS(ts)
	ts.name = "Braum"
	
	menu:addParam("ver", "Version", SCRIPT_PARAM_INFO, tostring(version))
	menu:addParam("author", "Author", SCRIPT_PARAM_INFO, "Teecolz")
	
	menu.combo:permaShow("combokey")
	menu.harass:permaShow("harasskey")
	menu.harass:permaShow("autoQ")
end

function OnTick()
	QReady = (myHero:CanUseSpell(_Q) == READY)
	WReady = (myHero:CanUseSpell(_W) == READY)
	EReady = (myHero:CanUseSpell(_E) == READY)
	RReady = (myHero:CanUseSpell(_R) == READY)
	IReady = (ignite ~= nil and myHero:CanUseSpell(ignite) == READY)

	ts:update()
	target = ts.target
	
	if menu.combo.combokey then
		Combo()
	end
	if menu.harass.harasskey then
		Harass()
	end

	if menu.combo.wSettings.wClose then
		WClosestAlly()
	end
	
	if menu.killsteal.killstealQ or menu.killsteal.autoIgnite then
		if QReady or IReady then
			KS()
		end
	end

	if menu.combo.wSettings.saveAlly and WReady then
		SaveAlly()
	end

	if menu.extra.autolevel then
		autoLevelSetSequence(levelSequence)
	end
	
	--[[if menu.LaneClear then
	LaneClear()
end
if menu.Flee then
	Flee()
end]]
	
	if menu.harass.autoQ and QReady then
		for i, enemy in pairs(GetEnemyHeroes()) do
			if GetDistance(enemy) < qRange then
				AutoQ()
			end
		end
	end
end

function Combo()
	
	--if ValidTarget(target) then
		if menu.combo.qSettings.useQ and QReady then
			UseQ()
		end

		if menu.combo.rSettings.useR and RReady then
			UseR()
		end
	--end
	
end

function AutoQ()
	
	if menu.harass.mana < (myHero.mana / myHero.maxMana) * 100 then
		UseQ()
	end
	
end

function UseQ()
	if menu.extra.prediction then
		for i, enemy in pairs(GetEnemyHeroes()) do
			local pos, info = Prodiction.GetPrediction(enemy, qRange, qSpeed, qDelay, qWidth)
			if pos and enemy ~= nil and ValidTarget(enemy) and GetDistance(pos) < qRange and info.hitchance > 1 and not qminionCollision(pos, qWidth, qRange) then
				if menu.extra.packets then
					Packet("S_CAST", {spellId = _Q, toX = pos.x, toY = pos.z, fromX = pos.x, fromY = pos.z}):send()
				else
					CastSpell(_Q, pos.x, pos.z)
				end
			end
		end
	else
		for i, enemy in pairs(GetEnemyHeroes()) do
			local CastPosition, HitChance, CastPosition = VP:GetLineCastPosition(enemy, qDelay, qWidth, qRange, qSpeed, myHero, true)
			if enemy ~= nil and ValidTarget(enemy) and HitChance > 1 and GetDistance(CastPosition) < qRange and not qminionCollision(CastPosition, qWidth, qRange) then
				if menu.extra.packets then
					Packet("S_CAST", {spellId = _Q, toX = CastPosition.x, toY = CastPosition.z, fromX = CastPosition.x, fromY = CastPosition.z}):send()
				else
					CastSpell(_Q, CastPosition.x, CastPosition.z)
				end
			end
		end
	end
end

function WClosestAlly()
	
	for i, ally in pairs(GetAllyHeroes()) do
		if GetDistance(ally) < wRange then
			CastSpell(_W, ally)
		end
	end
	
	myHero:MoveTo(mousePos.x, mousePos.z)
	
end

function SaveAlly()

	for i, ally in pairs(GetAllyHeroes()) do
		if GetDistance(ally) < wRange then
			if 30 > (ally.health / ally.maxHealth) * 100 and ValidTarget(target, 1000) then
				if menu.extra.debug then print("Going to Help "..ally.charName) end
				if WReady and GetDistance(ally) < wRange then
					CastSpell(_W, ally)
					CastSpell(_E, target.x, target.z)
					if menu.extra.debug then print("Helping Ally") end
					--myHero:MoveTo(ally.x, ally.z)
				end
			end
		end
	end

end

function UseR()
	
	--[[if menu.extra.prediction then
	for i, enemy in pairs(GetEnemyHeroes()) do
		local pos, info = Prodiction.GetPrediction(enemy, rRange, rSpeed, rDelay, rWidth)
		if pos and enemy ~= nil and ValidTarget(enemy) and GetDistance(pos) < rRange and info.hitchance > 1 then
			if menu.extra.packets then
				Packet("S_CAST", {spellId = _Q, toX = pos.x, toY = pos.z, fromX = pos.x, fromY = pos.z}):send()
			else
				CastSpell(_Q, pos.x, pos.z)
			end
		end
	end
else]]
	for i, enemy in pairs(GetEnemyHeroes()) do
		local AOECastPosition, MainTargetHitChance, nTargets = VP:GetLineAOECastPosition(enemy, rDelay, rWidth, rRange, rSpeed, myHero, false)
		if enemy ~= nil and ValidTarget(enemy) then
			if nTargets >= menu.combo.rSettings.targets and MainTargetHitChance >= menu.combo.rSettings.hitchance and GetDistance(AOECastPosition) < rRange then
				if menu.extra.packets then
					Packet("S_CAST", {spellId = _R, toX = AOECastPosition.x, toY = AOECastPosition.z, fromX = AOECastPosition.x, fromY = AOECastPosition.z}):send()
					if menu.extra.debug then print("Tried to Cast R Packet") end
				else
					CastSpell(_R, AOECastPosition.x, AOECastPosition.z)
					if menu.extra.debug then print("Tried to Cast R Reg") end
				end
			end
		end
	end
	--end
	
end

function Harass()
	
	for i, enemy in pairs(GetEnemyHeroes()) do
		if enemy ~= nil and not enemy.dead and GetDistance(enemy) < qRange then
			if menu.harass.useQ then 
				UseQ()
			end
		end
	end
	
end

function KS()
	
	for i, enemy in pairs(GetEnemyHeroes()) do
		local qDmg = getDmg("Q", enemy, myHero)
		local iDmg = getDmg("IGNITE", enemy, myHero)
		if QReady and GetDistance(enemy) < qRange and menu.killsteal.killstealQ then
			if enemy.health < qDmg then
				UseQ()
			end
		elseif IReady and GetDistance(enemy) < 600 and menu.killsteal.autoIgnite then
			if enemy.health < iDmg then
				CastSpell(ignite, enemy)
			end
		end
	end
	
end

function qminionCollision(CastPosition, width, range)
	for _, minionObjectE in pairs(enemyMinions.objects) do
		if CastPosition ~= nil and player:GetDistance(minionObjectE) < range then
			ex = player.x
			ez = player.z
			tx = CastPosition.x
			tz = CastPosition.z
			dx = ex - tx
			dz = ez - tz
			if dx ~= 0 then
				m = dz/dx
				c = ez - m*ex
			end
			mx = minionObjectE.x
			mz = minionObjectE.z
			distanc = (math.abs(mz - m*mx - c))/(math.sqrt(m*m+1))
			if distanc < width and math.sqrt((tx - ex)*(tx - ex) + (tz - ez)*(tz - ez)) > math.sqrt((tx - mx)*(tx - mx) + (tz - mz)*(tz - mz)) then
				return true
			end
		end
	end
	return false
end

function OnProcessSpell(object,spellProc)
	if object.isMe and spellProc.name:lower():find("recall") then
		--PrintChat(spellProc.name)
	end 
	
	if myHero.dead then return end
	
	if menu.block.autoE then 
		if object.team ~= player.team and string.find(spellProc.name, "Basic") == nil then
			if Champions[object.charName] ~= nil then
				skillshot = Champions[object.charName].skillshots[spellProc.name]
				if skillshot ~= nil and skillshot.blockable == true and not skillshot.fuckedUp then
					range = skillshot.range
					if menu.extra.debug then print("Found some E blockage") end
					if not spellProc.startPos then
						spellProc.startPos.x = object.x
						spellProc.startPos.z = object.z 
					end 
					if menu.extra.debug then print("Found some E blockage [2]") end
					if GetDistance(spellProc.startPos) <= range then
						if menu.extra.debug then print("Found some E blockage [3]") end
						if GetDistance(spellProc.endPos) <= eRange then
							if menu.extra.debug then print("Found some E blockage [4]") end
							if EReady and menu.block[spellProc.name] then
								if menu.extra.debug then print("E BLOCK") end
								CastSpell(_E, object.x, object.z)
							end
						end
					end
				end
				if skillshot ~= nil and skillshot.fuckedUp then 
					if fuckedUpObject == nil then
						fuckedUpSpell = skillshot 
						fuckedUpObject = object
					end
				end
			end
		end	
	end
	--[[
	if Config.dodge then
		if object.team ~= player.team and not player.dead and string.find(spellProc.name, "Basic") == nil then
			if Champions[object.charName] ~= nil then
				skillshot = Champions[object.charName].skillshots[spellProc.name]
				if skillshot ~= nil then
					if skillshot.type == "circular" and GetDistance(spellProc.endPos) <= skillshot.radius then
						dodge(skillshot)
					end
				end
			end
		end
	end
	]]
end

function fuckedUpSpells()
	if fuckedUpSpell.spellName == "KatarinaR" and fuckedUpObject.charName == "Katarina" then
		local object = fuckedUpObject
		if GetDistance(fuckedUpObject)-eRange < fuckedUpSpell.range then
			if EReady and menu.block[fuckedUpSpell.spellName] then
				fuckedUpSpell = nil
				fuckedUpObject = nil
				CastSpell(_E, object.x, object.z)
			end 
		end 
	elseif fuckedUpParticle ~= nil and GetDistance(fuckedUpParticle) < eRange and (fuckedUpSpell.spellName == "EzrealTrueshotBarrage" or fuckedUpSpell.spellName == "EnchantedCrystalArrow" or fuckedUpSpell.spellName == "ZiggsR" or fuckedUpSpell.spellName == "CaitlynHeadshotMissile") then 
		if EReady and menu.block[fuckedUpSpell.spellName] and fuckedUpParticle.x > 0 and fuckedUpParticle.z > 0 then
			fuckedUpSpell = nil
			fuckedUpObject = nil
			object = fuckedUpParticle
			--print("FUP: "..fuckedUpParticle.x .."/"..fuckedUpParticle.z.." MH:"..myHero.x..""..myHero.z)
			fuckedUpParticle = nil 
			CastSpell(_E, object.x, object.z)
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
	if menu.draw.drawQ then
		DrawCircle(myHero.x, myHero.y, myHero.z, qRange, ARGB(214,1,33,0))
	end
	if menu.draw.drawW then
		DrawCircle(myHero.x, myHero.y, myHero.z, wRange, ARGB(214,1,33,0))
	end
	if menu.draw.drawR then
		DrawCircle(myHero.x, myHero.y, myHero.z, rRange, ARGB(214,1,33,0))
	end
end
