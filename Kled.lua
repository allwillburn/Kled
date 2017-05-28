local ver = "0.01"


if FileExist(COMMON_PATH.."MixLib.lua") then
 require('MixLib')
else
 PrintChat("MixLib not found. Please wait for download.")
 DownloadFileAsync("https://raw.githubusercontent.com/VTNEETS/NEET-Scripts/master/MixLib.lua", COMMON_PATH.."MixLib.lua", function() PrintChat("Downloaded MixLib. Please 2x F6!") return end)
end


if GetObjectName(GetMyHero()) ~= "Kled" then return end

require("OpenPredict")
require("DamageLib")



local KledQ = {delay = 0.22, range = 800, width = 70, speed = 1750}

function AutoUpdate(data)
    if tonumber(data) > tonumber(ver) then
        PrintChat('<font color = "#00FFFF">New version found! ' .. data)
        PrintChat('<font color = "#00FFFF">Downloading update, please wait...')
        DownloadFileAsync('https://raw.githubusercontent.com/allwillburn/Kled/master/Kled.lua', SCRIPT_PATH .. 'Kled.lua', function() PrintChat('<font color = "#00FFFF">Update Complete, please 2x F6!') return end)
    else
        PrintChat('<font color = "#00FFFF">No Kled updates found!')
    end
end

GetWebResultAsync("https://raw.githubusercontent.com/allwillburn/Kled/master/Kled.version", AutoUpdate)


GetLevelPoints = function(unit) return GetLevel(unit) - (GetCastLevel(unit,0)+GetCastLevel(unit,1)+GetCastLevel(unit,2)+GetCastLevel(unit,3)) end
local SetDCP, SkinChanger = 0

local KledMenu = Menu("Kled", "Kled")

KledMenu:SubMenu("Combo", "Combo")

KledMenu.Combo:Boolean("Q", "Use Q in combo", true)
KledMenu.Combo:Slider("Qpred", "Q Hit Chance", 3,0,10,1)
KledMenu.Combo:Boolean("W", "Use W in combo", true)
KledMenu.Combo:Boolean("E", "Use E in combo", true)
KledMenu.Combo:Boolean("R", "Use R in combo", true)
KledMenu.Combo:Slider("RX", "Enemies Around to Cast R",3,1,5,1)
KledMenu.Combo:Boolean("Cutlass", "Use Cutlass", true)
KledMenu.Combo:Boolean("Tiamat", "Use Tiamat", true)
KledMenu.Combo:Boolean("BOTRK", "Use BOTRK", true)
KledMenu.Combo:Boolean("RHydra", "Use RHydra", true)
KledMenu.Combo:Boolean("YGB", "Use GhostBlade", true)
KledMenu.Combo:Boolean("Gunblade", "Use Gunblade", true)
KledMenu.Combo:Boolean("Randuins", "Use Randuins", true)


KledMenu:SubMenu("AutoMode", "AutoMode")
KledMenu.AutoMode:Boolean("Level", "Auto level spells", false)
KledMenu.AutoMode:Boolean("Ghost", "Auto Ghost", false)
KledMenu.AutoMode:Boolean("Q", "Auto Q", false)
KledMenu.AutoMode:Slider("Qpred", "Q Hit Chance", 3,0,10,1)
KledMenu.AutoMode:Boolean("W", "Auto W", false)
KledMenu.AutoMode:Boolean("E", "Auto E", false)
KledMenu.AutoMode:Boolean("R", "Auto R", false)

KledMenu:SubMenu("LaneClear", "LaneClear")
KledMenu.LaneClear:Boolean("Q", "Use Q", true)
KledMenu.LaneClear:Boolean("W", "Use W", true)
KledMenu.LaneClear:Boolean("E", "Use E", true)
KledMenu.LaneClear:Boolean("RHydra", "Use RHydra", true)
KledMenu.LaneClear:Boolean("Tiamat", "Use Tiamat", true)

KledMenu:SubMenu("Harass", "Harass")
KledMenu.Harass:Boolean("Q", "Use Q", true)
KledMenu.Harass:Slider("Qpred", "Q Hit Chance", 3,0,10,1)
KledMenu.Harass:Boolean("W", "Use W", true)

KledMenu:SubMenu("KillSteal", "KillSteal")
KledMenu.KillSteal:Boolean("Q", "KS w Q", true)
KledMenu.KillSteal:Slider("Qpred", "Q Hit Chance", 3,0,10,1)
KledMenu.KillSteal:Boolean("R", "KS w R", true)


KledMenu:SubMenu("AutoIgnite", "AutoIgnite")
KledMenu.AutoIgnite:Boolean("Ignite", "Ignite if killable", true)

KledMenu:SubMenu("Drawings", "Drawings")
KledMenu.Drawings:Boolean("DQ", "Draw Q Range", true)

KledMenu:SubMenu("SkinChanger", "SkinChanger")
KledMenu.SkinChanger:Boolean("Skin", "UseSkinChanger", true)
KledMenu.SkinChanger:Slider("SelectedSkin", "Select A Skin:", 1, 0, 6, 1, function(SetDCP) HeroSkinChanger(myHero, SetDCP)  end, true)

OnTick(function (myHero)
	local target = GetCurrentTarget()
        local YGB = GetItemSlot(myHero, 3142)
	local RHydra = GetItemSlot(myHero, 3074)
	local Tiamat = GetItemSlot(myHero, 3077)
        local Gunblade = GetItemSlot(myHero, 3146)
        local BOTRK = GetItemSlot(myHero, 3153)
        local Cutlass = GetItemSlot(myHero, 3144)
        local Randuins = GetItemSlot(myHero, 3143)
	local KledQ = {delay = 0.22, range = 800, width = 70, speed = 1750}

	--AUTO LEVEL UP
	if KledMenu.AutoMode.Level:Value() then

			spellorder = {_E, _W, _Q, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E}
			if GetLevelPoints(myHero) > 0 then
				LevelSpell(spellorder[GetLevel(myHero) + 1 - GetLevelPoints(myHero)])
			end
	end
        
        --Harass
          if Mix:Mode() == "Harass" then
            if KledMenu.Harass.Q:Value() and Ready(_Q) and ValidTarget(target, 800) then
				 local QPred = GetPrediction(target,KledQ)
                       if QPred.hitChance > (KledMenu.Harass.Qpred:Value() * 0.1) and not QPred:mCollision(1) then
                                 CastSkillShot(_Q,QPred.castPos)
                       end
                 end	

            if KledMenu.Harass.W:Value() and Ready(_W) and ValidTarget(target, 700) then
				CastSpell(_W)
            end     
          end

	--COMBO
	  if Mix:Mode() == "Combo" then
            if KledMenu.Combo.YGB:Value() and YGB > 0 and Ready(YGB) and ValidTarget(target, 700) then
			CastSpell(YGB)
            end

            if KledMenu.Combo.Randuins:Value() and Randuins > 0 and Ready(Randuins) and ValidTarget(target, 550) then
			CastSpell(Randuins)
            end

            if KledMenu.Combo.BOTRK:Value() and BOTRK > 0 and Ready(BOTRK) and ValidTarget(target, 550) then
			 CastTargetSpell(target, BOTRK)
            end

            if KledMenu.Combo.Cutlass:Value() and Cutlass > 0 and Ready(Cutlass) and ValidTarget(target, 700) then
			 CastTargetSpell(target, Cutlass)
            end

	    if KledMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 800) then
                local QPred = GetPrediction(target,KledQ)
                       if QPred.hitChance > (KledMenu.Combo.Qpred:Value() * 0.1) and not QPred:mCollision(1) then
                                 CastSkillShot(_Q,QPred.castPos)
                       end
                 end		
			
            if KledMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 550) then
			 CastSkillShot(_E, target)
	    end
            
            if KledMenu.Combo.Tiamat:Value() and Tiamat > 0 and Ready(Tiamat) and ValidTarget(target, 350) then
			CastSpell(Tiamat)
            end

            if KledMenu.Combo.Gunblade:Value() and Gunblade > 0 and Ready(Gunblade) and ValidTarget(target, 700) then
			CastTargetSpell(target, Gunblade)
            end

            if KledMenu.Combo.RHydra:Value() and RHydra > 0 and Ready(RHydra) and ValidTarget(target, 400) then
			CastSpell(RHydra)
            end

	    if KledMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, 550) then
			CastSpell(_W)
	    end
	    
	    
            if KledMenu.Combo.R:Value() and Ready(_R) and ValidTarget(target, GetCastRange(myHero,_R)) and (EnemiesAround(myHeroPos(), GetCastRange(myHero,_R)) >= KledMenu.Combo.RX:Value()) then
			CastSkillShot(_R, target.pos) 
            end

          end

         --AUTO IGNITE
	for _, enemy in pairs(GetEnemyHeroes()) do
		
		if GetCastName(myHero, SUMMONER_1) == 'SummonerDot' then
			 Ignite = SUMMONER_1
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end

		elseif GetCastName(myHero, SUMMONER_2) == 'SummonerDot' then
			 Ignite = SUMMONER_2
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end
		end

	end

        for _, enemy in pairs(GetEnemyHeroes()) do
                
                if IsReady(_Q) and ValidTarget(enemy, 800) and KledMenu.KillSteal.Q:Value() and GetHP(enemy) < getdmg("Q",enemy) then
		         local QPred = GetPrediction(target,KledQ)
                       if QPred.hitChance > (KledMenu.KillSteal.Qpred:Value() * 0.1) and not QPred:mCollision(1) then
                                 CastSkillShot(_Q,QPred.castPos)
                       end
                 end	

                if IsReady(_R) and ValidTarget(enemy, 450) and KledMenu.KillSteal.R:Value() and GetHP(enemy) < getdmg("R",enemy) then
		                      CastSpell(_R)
  
                end
      end

      if Mix:Mode() == "LaneClear" then
      	  for _,closeminion in pairs(minionManager.objects) do
	        if KledMenu.LaneClear.Q:Value() and Ready(_Q) and ValidTarget(closeminion, 800) then
	        	CastSkillShot(_Q, target)
                end

                if KledMenu.LaneClear.W:Value() and Ready(_W) and ValidTarget(closeminion, 900) then
	        	CastSpell(_W)
	        end

                if KledMenu.LaneClear.E:Value() and Ready(_E) and ValidTarget(closeminion, 900) then
	        	CastSkillShot(_E, target)
	        end

                if KledMenu.LaneClear.Tiamat:Value() and ValidTarget(closeminion, 350) then
			CastSpell(Tiamat)
		end
	
		if KledMenu.LaneClear.RHydra:Value() and ValidTarget(closeminion, 400) then
                        CastTargetSpell(closeminion, RHydra)
      	        end
          end
      end
        --AutoMode
        if KledMenu.AutoMode.Q:Value() then        
          if Ready(_Q) and ValidTarget(target, 800) then
		      local QPred = GetPrediction(target,KledQ)
                       if QPred.hitChance > (KledMenu.AutoMode.Qpred:Value() * 0.1) and not QPred:mCollision(1) then
                                 CastSkillShot(_Q,QPred.castPos)
                       end
                 end	
          
        end 
        if KledMenu.AutoMode.W:Value() then        
          if Ready(_W)  then
	  	      CastSpell(_W)
          end
        end
        if KledMenu.AutoMode.E:Value() then        
	  if Ready(_E) and ValidTarget(target, 900) then
		      CastSkillShot(_E, target)
	  end
        end
        if KledMenu.AutoMode.R:Value() then        
	  if Ready(_R) and ValidTarget(target, 450) then
		      CastSkillShot(_R, target.pos)
	  end
        end
                
	--AUTO GHOST
	if KledMenu.AutoMode.Ghost:Value() then
		if GetCastName(myHero, SUMMONER_1) == "SummonerHaste" and Ready(SUMMONER_1) then
			CastSpell(SUMMONER_1)
		elseif GetCastName(myHero, SUMMONER_2) == "SummonerHaste" and Ready(SUMMONER_2) then
			CastSpell(Summoner_2)
		end
	end
end)

OnDraw(function (myHero)
        
         if KledMenu.Drawings.DQ:Value() then
		DrawCircle(GetOrigin(myHero), 800, 0, 250, GoS.Black)
	end

end)


OnProcessSpell(function(unit, spell)
	local target = GetCurrentTarget()        
       
        
        if unit.isMe and spell.name:lower():find("itemtiamatcleave") then
		Mix:ResetAA()
	end	
               
        if unit.isMe and spell.name:lower():find("itemravenoushydracrescent") then
		Mix:ResetAA()
	end

end) 


local function SkinChanger()
	if KledMenu.SkinChanger.UseSkinChanger:Value() then
		if SetDCP >= 0  and SetDCP ~= GlobalSkin then
			HeroSkinChanger(myHero, SetDCP)
			GlobalSkin = SetDCP
		end
        end
end


print('<font color = "#01DF01"><b>Kled</b> <font color = "#01DF01">by <font color = "#01DF01"><b>Allwillburn</b> <font color = "#01DF01">Loaded!')





