util.AddNetworkString("RoundChange")
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )
include( "cl_hud.lua" )

local RoundNumber = 1
local ZombieDamage = 5
local ZombieHealth = 5
local MaxZombies = 10 
local Zombies = 0
local SpawnDelay = 3

timer.Create("ZombieSpawn", SpawnDelay, 0, function()
    local Spawns = ents.FindByClass("info_player_start")
    local Ran = math.random(#Spawns)
    local Zombie = ents.Create("npc_vj_zs_zombie")

    if (!IsValid(Zombie))  then return end

    Zombie:SetPos(Spawns[Ran]:GetPos() + Vector(0, 0, math.random( 0, 25)))
    Zombie:Spawn()    

    if(RoundNumber >= 15) then
        local Zombine = ents.Create("npc_vj_zs_zombine")

        SpawnDelay = 1.5
        Zombine:SetPos(Spawns[Ran]:GetPos() + Vector(0, 0, math.random( 0, 25)))
        Zombine:Spawn()
        -- Zombine:PointAtEntity(Entity(1))
        -- Zombine:PointAtEntity(Entity(2))
    end
    if(RoundNumber >= 10) then 
        local Poison = ents.Create("npc_vj_zs_poisonzombie")
        Poison:SetPos(Spawns[Ran]:GetPos() + Vector(0, 0, math.random( 100, 125)))
        Poison:Spawn()
        -- Poison:PointAtEntity(Entity(1))
        -- Poison:PointAtEntity(Entity(2))
    end
    
    Zombies = Zombies + 1
end)

hook.Add("Think", "CheckZombies", function()
    for k,v in pairs(player.GetAll()) do
        if v:GetNWInt("RoundNumberVar") != RoundNumber then
            v:SetNWInt("RoundNumberVar",RoundNumber)
        end
    end

    if (Zombies == MaxZombies) then  
        timer.Pause("ZombieSpawn")        
        local ZombieLeft = 0
        for k,v in pairs(ents.GetAll()) do
            if v:GetClass() == "npc_zombie" then 
                ZombieLeft = ZombieLeft + 1
            end
        end
        if ZombieLeft == 0 then
            Zombies = 0
            RoundNumber = RoundNumber + 1
            for k,v in pairs(player.GetAll()) do
                if !v:Alive() then
                    v:Spawn()
                end
            end

            net.Start("RoundChange")
                net.WriteInt(RoundNumber,32)
            net.Broadcast()
            timer.UnPause("ZombieSpawn")
        end
            
    end
end)
