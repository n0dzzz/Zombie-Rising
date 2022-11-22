AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_hud.lua" )

include( "shared.lua" )

CreateConVar("RoundNumber", 1)
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
    local FastZombie = ents.Create("npc_fastzombie")
    
    if (!IsValid(Zombie))  then return end
    if (!IsValid(FastZombie))  then return end

    Zombie:SetPos(Spawns[Ran]:GetPos() + Vector(0, 0, math.random( 0, 50)))
    Zombie:Spawn()

    if(RoundNumber == 5) then
        SpawnDelay = 3
    end
    if(RoundNumber == 15) then
        SpawnDelay = 1.5
    end
    if(RoundNumber == 10) then 
        FastZombie:SetPos(Spawns[Ran]:GetPos() + Vector(0, 0, math.random( 0, 25)))
        FastZombie:Spawn()
        FastZombie:PointAtEntity(Entity(1))
        FastZombie:PointAtEntity(Entity(2))
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
            GetConVar("RoundNumber"):SetInt(RoundNumber)
            print(RoundNumber)  
            timer.UnPause("ZombieSpawn")
        end
            
    end
end)
