include( "shared.lua" )

AddCSLuaFile( "cl_hud.lua" )

include( "cl_hud.lua" )

-------------------------- Setup

print("[ " .. util.DateStamp() .. " ] " .. "Level Up Game Started on map " .. game.GetMap())

timer.Create("Annoucments", 200, 1, function()

    print( "Welcome to Level Up still in Development" )

end)

------------------------- Start Funcs 