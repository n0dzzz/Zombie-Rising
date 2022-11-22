AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_hud.lua" )

include( "shared.lua" )

local RoundNumber = 1
local ZombieDamage = 5
local ZombieHealth = 5
local MaxZombies = 5 
local Zombies = 0

timer.Create("ZombieSpawn", 5, 0, function()
    local Spawns = ents.FindByClass("info_player_start")
    local Ran = math.random(#Spawns)
    local Zombie = ents.Create("npc_zombie")
    local FastZombie = ents.Create("npc_fastzombie")
    
    if (!IsValid(Zombie))  then return end
    if (!IsValid(FastZombie))  then return end

    Zombie:SetPos(Spawns[Ran]:GetPos() + Vector(0, 0, math.random( 0, 50)))
    Zombie:Spawn()

    if(RoundNumber == 10) then 
        FastZombie:SetPos(Spawns[Ran]:GetPos() + Vector(0, 0, math.random( 0, 50)))
        FastZombie:Spawn()
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
            MaxZombies = 5 * RoundNumber 
            print(RoundNumber)  
            timer.UnPause("ZombieSpawn")
        end
            
    end
end)
