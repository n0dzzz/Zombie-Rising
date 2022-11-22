AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_hud.lua" )

include( "shared.lua" )

timer.Create("Zombie Spawn", 2, 1, function()

    local Spawns = ents.FindByClass("info_player_start")
    local Ran = math.random(#Spawns)
    local Zombie = ents.Create("npc_zombie")

    if (!IsValid(Zombie))  then return end

    Zombie:SetPos(Spawns[Ran]:GetPos() + Vector(0, 0, math.random( 0, 200)))
    Zombie:Spawn()

    print("spawn zombie")
end)