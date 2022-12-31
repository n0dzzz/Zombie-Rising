util.AddNetworkString("RoundChange")
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )
include( "cl_hud.lua" )

local RoundNumber = 1
local ZombieDamage = 5
local ZombieHealth = 5
local MaxZombies = 10 
local Zombies = 0
local SpawnDelay = 2

timer.Create("ZombieSpawn", SpawnDelay, 0, function()
    local Spawns = ents.FindByClass("info_player_start")
    local Ran = math.random(#Spawns)
    local Zombie = ents.Create("npc_vj_zs_zombie")
    if (!IsValid(Zombie))  then return end

    if(RoundNumber >= 15) then
        local Zombine = ents.Create("npc_vj_zs_zombine")

        SpawnDelay = 1.5
        Zombine:SetPos(Spawns[Ran]:GetPos() + Vector(0, math.random( 900, 1000), 0))
        Zombine:Spawn()
        Zombie:SetPos(Spawns[Ran]:GetPos() + Vector(0, math.random( 50, 75), 0))
        Zombie:Spawn()  
    end
    if(RoundNumber >= 10) then 
        local Poison = ents.Create("npc_vj_zs_poisonzombie")

        Poison:SetPos(Spawns[Ran]:GetPos() + Vector(0, math.random( 400, 450), 0))
        Poison:Spawn()
        Zombie:SetPos(Spawns[Ran]:GetPos() + Vector(0, math.random( 50, 75), 0))
        Zombie:Spawn()  
    end
    if(RoundNumber >= 5) then 
        local FastZombie = ents.Create("npc_vj_zs_fastzombie")

        FastZombie:SetPos(Spawns[Ran]:GetPos() + Vector(0, math.random( 500, 800), 0))
        FastZombie:Spawn()
        Zombie:SetPos(Spawns[Ran]:GetPos() + Vector(0, math.random( 50, 75), 0))
        Zombie:Spawn()  
    end
    if (RoundNumber < 5) then
        Zombie:SetPos(Spawns[Ran]:GetPos() + Vector(0, math.random( 125, 175), 0))
        Zombie:Spawn()  
    end
    
    Zombies = Zombies + 1
end)

timer.Create("RoundIncrease", 75, 0, function()

    for k,v in pairs(player.GetAll()) do
        RoundNumber = RoundNumber + 1
        v:SetNWInt("RoundNumberVar", RoundNumber)
    end

    for k,v in pairs(player.GetAll()) do
        if !v:Alive() then
            v:Spawn()
        end
    end

    net.Start("RoundChange")
        net.WriteInt(RoundNumber,32)
    net.Broadcast()

end)