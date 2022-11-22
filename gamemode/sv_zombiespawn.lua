AddCSLuaFile( "shared.lua" )

include( "shared.lua" )
include( "cl_hud.lua" )

local RoundNumber = 1
local ZombieDamage = 5
local ZombieHealth = 5
local MaxZombies = 10 
local Zombies = 0
local SpawnDelay = 5

timer.Create("ZombieSpawn", SpawnDelay, 0, function()
    local Spawns = ents.FindByClass("info_player_start")
    local Ran = math.random(#Spawns)
    local Zombie = ents.Create("npc_fastzombie")
    local Poison = ents.Create("npc_poisonzombie")
    local Zombine = ents.Create("npc_zombine")

    if (!IsValid(Zombie))  then return end
    if (!IsValid(Poison))  then return end
    if (!IsValid(Zombine))  then return end

    Zombie:SetPos(Spawns[Ran]:GetPos() + Vector(0, 0, math.random( 0, 25)))
    Zombie:Spawn()
    Zombie:PointAtEntity(Entity(1))
    Zombie:PointAtEntity(Entity(2))

    if(RoundNumber == 5) then
        SpawnDelay = 3
    end
    if(RoundNumber == 15) then
        SpawnDelay = 1.5
        Zombine:SetPos(Spawns[Ran]:GetPos() + Vector(0, 0, math.random( 0, 25)))
        Zombine:Spawn()
        Zombine:PointAtEntity(Entity(1))
        Zombine:PointAtEntity(Entity(2))
    end
    if(RoundNumber == 10) then 
        Poison:SetPos(Spawns[Ran]:GetPos() + Vector(0, 0, math.random( 0, 25)))
        Poison:Spawn()
        Poison:PointAtEntity(Entity(1))
        Poison:PointAtEntity(Entity(2))
    end
    
    Zombies = Zombies + 1
end)

hook.Add("Think", "CheckZombies", function()
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
            GetConVar("RoundNumberVar"):SetInt(RoundNumber)
            RunConsoleCommand("say", "Round " .. tostring(RoundNumber))
            timer.UnPause("ZombieSpawn")
        end
            
    end
end)
