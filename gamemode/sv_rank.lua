AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )

include( "shared.lua" )

hook.Add("PlayerInitialSpawn", "InitSpawn", function(ply)

    if (ply:GetPData("PlayerRank") == nil) then
		ply:SetNWInt("PlayerRank", 1)
	else
		ply:SetNWInt("PlayerRank", tonumber(ply:GetPData("PlayerRank")))
	end
	
	if (ply:GetPData("PlayerRankProgress") == nil) then
		ply:SetNWInt("PlayerRankProgress", 0)
	else
		ply:SetNWInt("PlayerRankProgress", tonumber(ply:GetPData("PlayerRankProgress")))
    end
    
    if (ply:GetPData("PlayerPrestige") == nil) then
		ply:SetNWInt("PlayerPrestige", 0)
	else
		ply:SetNWInt("PlayerPrestige", tonumber(ply:GetPData("PlayerPrestige")))
    end

end)

hook.Add("PlayerSpawn", "InitSpawn", function(ply)

    CheckLevel(ply)

    if (ply:GetNWInt("PlayerRank") <= 0) then
       ply:SetNWInt("PlayerRank", 1)
    end

end)

hook.Add("OnNPCKilled", "NPCKill", function(npc, attacker, inflictor)

    if(attacker:GetNWInt("PlayerPrestige") >= 5) then
        attacker:SetNWInt("PlayerRankProgress", attacker:GetNWInt("PlayerRankProgress") + 10000)
    else 
        attacker:SetNWInt("PlayerRankProgress", attacker:GetNWInt("PlayerRankProgress") + 5000)
    end

    CheckLevel(attacker)

end)

hook.Add("PlayerDeath", "PlayerKill", function(victim, inflictor, attacker)

    if (victim != attacker) then

        attacker:SetNWInt("PlayerRankProgress", attacker:GetNWInt("PlayerRankProgress") + 500)
    
        CheckLevel(attacker)
        
    end

end)

hook.Add("PlayerDisconnected", "PlayerDC", function(ply)
    
    ply:SetPData("PlayerRank", ply:GetNWInt("PlayerRank"))
	ply:SetPData("PlayerRankProgress", ply:GetNWInt("PlayerRankProgress"))
    ply:SetPData("PlayerPrestige", ply:GetNWInt("PlayerPrestige"))

end)

hook.Add("ShutDown", "ServerShutDown", function()

    for k, v in pairs(player.GetAll()) do
		v:SetPData("PlayerRank", v:GetNWInt("PlayerRank"))
		v:SetPData("PlayerRankProgress", v:GetNWInt("PlayerRankProgress"))
        v:SetPData("PlayerPrestige", v:GetNWInt("PlayerPrestige"))
	end

end)

function CheckLevel(ply)

    ply:SetNWInt("MaxPlayerRankProgress", 2500 * ply:GetNWInt("PlayerRank") )

    if (ply:GetNWInt("PlayerRankProgress") >= ply:GetNWInt("MaxPlayerRankProgress")) then
        ply:SetNWInt("PlayerRank", ply:GetNWInt("PlayerRank") + 1)
        ply:SetNWInt("PlayerRankProgress", ply:GetNWInt("PlayerRankProgress") - ply:GetNWInt("MaxPlayerRankProgress"))
        sound.Play("garrysmod/save_load1.wav", ply:GetPos(), 75, 100, 50)
    end

    -- run prestige shit here

end