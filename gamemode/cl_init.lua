include( "shared.lua" )

-------------------------- Setup

print("[ " .. util.DateStamp() .. " ] " .. "Zombie Surival Game Started on map " .. game.GetMap())

timer.Create("Annoucments", 200, 1, function()

    print( "Welcome to Zombie Surival still in Development" )

end)

------------------------- Start Funcs 