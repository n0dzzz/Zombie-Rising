include( "shared.lua" )
include( "cl_hud.lua" )
include( "cl_weaponbox.lua" )

-------------------------- Setup

print("[ " .. util.DateStamp() .. " ] " .. "Zombie Surival Game Started on map " .. game.GetMap())

timer.Create("Annoucments", 200, 1, function()

    print( "Welcome to Zombie Surival still in Development" )

end)

hook.Add( "OnPlayerChat", "HelloCommand", function( ply, strText, bTeam, bDead ) 
    if ( ply != LocalPlayer() ) then return end
 
   strText = string.lower( strText )
 
   if ( strText == "!prestige" ) then 
    ply:ChatPrint("Prestige Perks")
    ply:ChatPrint("--------------")
    ply:ChatPrint("Prestige 1: Spawn With 25 Armor")
    ply:ChatPrint("Prestige 3: Glock Starting Weapon")
    ply:ChatPrint("Prestige 5: Double XP")
    ply:ChatPrint("Prestige 7: Spawn With 50 Armor")
    ply:ChatPrint("Prestige 10: Double Money")
    ply:ChatPrint("Prestige 13: Spawn With AK-47")
    ply:ChatPrint("Prestige 15: Double Max Health")
    ply:ChatPrint("Prestige 17:Spawn With 75 Armor")
    ply:ChatPrint("Prestige 20: Mini Gun Unlock")
    return true
   end
 end )

 hook.Add("PostDrawOpaqueRenderables", "example", function()

    if (!LocalPlayer():GetEyeTrace().Entity:IsPlayer()) then return end

	local offset = Vector( 0, 0, 85 )
	local ang = LocalPlayer():EyeAngles()
	local pos = LocalPlayer():GetEyeTrace().Entity:GetPos() + offset + ang:Up()
 
	ang:RotateAroundAxis( ang:Forward(), 90 )
	ang:RotateAroundAxis( ang:Right(), 90 )
 
	cam.Start3D2D( pos, Angle( 0, ang.y, 90 ), 0.25 )
        surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawRect( -40, 2, 100, 50 )

        surface.SetDrawColor( 255, 44, 44, 255 )
		surface.DrawOutlinedRect( -40, 2, 100, 50 )


		draw.DrawText( LocalPlayer():GetEyeTrace().Entity:GetName(), "DermaDefault", 12, 5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
        draw.DrawText( "Rank: " .. LocalPlayer():GetEyeTrace().Entity:GetNWInt("PlayerRank"), "DermaDefault", 12, 20, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
        draw.DrawText( "Prestige: " .. LocalPlayer():GetEyeTrace().Entity:GetNWInt("PlayerPrestige"), "DermaDefault", 12, 35, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
	cam.End3D2D()

end )

------------------------- Start Funcs 