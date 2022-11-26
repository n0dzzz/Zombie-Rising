util.AddNetworkString("BeginSpectate")
util.AddNetworkString("EndGame")

include("shared.lua")

local EndGameVar = true

net.Receive("BeginSpectate", function(len,ply)
    local SpecEnt = net.ReadEntity()
    if IsValid(SpecEnt) then
        ply:Spectate(OBS_MODE_FIXED)
        ply:SpectateEntity(SpecEnt)
    end
end)

net.Receive("EndGame",function(len,ply)
    if EndGameVar then
        EndGameVar = false
        for k,v in pairs(player.GetAll()) do
            v:PrintMessage( HUD_PRINTCENTER, "Game over. You made it to round ".. tostring(v:GetNWInt("RoundNumberVar")))
        end
        timer.Simple(3, function()
            RunConsoleCommand("changelevel", game.GetMap())
        end)
    end
end)
