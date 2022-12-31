include( "shared.lua" )
include( "cl_hud.lua" )
include( "cl_weaponbox.lua" )
include( "cl_spectatehud.lua" )
include( "cl_scoreboard.lua" )
include( "cl_hit.lua")
-------------------------- Setup

print("[ " .. util.DateStamp() .. " ] " .. "Zombie Surival Game Started on map " .. game.GetMap())

timer.Create("GameClean", 600, 0, function()
    LocalPlayer():ChatPrint("Game is Wiping/Cleaning to Prevent a Crash")
    RunConsoleCommand("gmod_admin_cleanup")
end)

timer.Create("Annoucments", 200, 1, function()

    print( "Welcome to Zombie Rising" )

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

   if (strText == "!easy") then
        ply:ChatPrint("Difficulty set to easy")
        ply:SetNWInt("Difficulty", 1)
   end

   if (strText == "!medium") then
        ply:ChatPrint("Difficulty set to medium")
        ply:SetNWInt("Difficulty", 2)
   end

   if (strText == "!hard") then
        ply:ChatPrint("Difficulty set to hard")
        ply:SetNWInt("Difficulty", 3)
   end

end )

function PlyLevelRender()
    if (!LocalPlayer():GetEyeTrace().Entity:IsPlayer()) then return end

	local offset = Vector( 0, 0, 85 )
	local ang = LocalPlayer():EyeAngles()
	local pos = LocalPlayer():GetEyeTrace().Entity:GetPos() + offset + ang:Up()
 
	ang:RotateAroundAxis( ang:Forward(), 90 )
	ang:RotateAroundAxis( ang:Right(), 90 )
 
	cam.Start3D2D( pos, Angle( 0, ang.y, 90 ), 0.25 )
        surface.SetDrawColor( 45, 45, 45, 255 )
		surface.DrawRect( -40, 2, 100, 50 )

        surface.SetDrawColor(222,16,50)
		surface.DrawOutlinedRect( -40, 2, 100, 50 )


		draw.DrawText( LocalPlayer():GetEyeTrace().Entity:GetName(), "DermaDefault", 12, 5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
        draw.DrawText( "Rank: " .. LocalPlayer():GetEyeTrace().Entity:GetNWInt("PlayerRank"), "DermaDefault", 12, 20, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
        draw.DrawText( "Prestige: " .. LocalPlayer():GetEyeTrace().Entity:GetNWInt("PlayerPrestige"), "DermaDefault", 12, 35, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
	cam.End3D2D()
end

function ZombieLevelRender()
    if (!IsValid(LocalPlayer():GetEyeTrace().Entity)) then return end

    local name = ""
	local offset = Vector( 0, 0, 85 )
	local ang = LocalPlayer():EyeAngles()
	local pos = LocalPlayer():GetEyeTrace().Entity:GetPos() + offset + ang:Up()
 
    if (LocalPlayer():GetEyeTrace().Entity:GetClass() == "npc_vj_zs_zombie") then
        name = "Zombie"
    elseif (LocalPlayer():GetEyeTrace().Entity:GetClass() == "npc_vj_zs_fastzombie") then
        name = "Fast Zombie"
    elseif (LocalPlayer():GetEyeTrace().Entity:GetClass() == "npc_vj_zs_poisonzombie") then
        name = "Poison Zombie"
    elseif (LocalPlayer():GetEyeTrace().Entity:GetClass() == "npc_vj_zs_zombine") then
        name = "Zombine"
    else
        return 
    end

	ang:RotateAroundAxis( ang:Forward(), 90 )
	ang:RotateAroundAxis( ang:Right(), 90 )
 
	cam.Start3D2D( pos, Angle( 0, ang.y, 90 ), 0.25 )
        surface.SetDrawColor( 45, 45, 45, 255 )
		surface.DrawRect( -40, 2, 100, 50 )

        surface.SetDrawColor(222,16,50)
		surface.DrawOutlinedRect( -40, 2, 100, 50 )

		draw.DrawText(name , "DermaDefault", 12, 4, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
        draw.RoundedBox(0, -35, 25, 90 * (LocalPlayer():GetEyeTrace().Entity:Health() / LocalPlayer():GetEyeTrace().Entity:GetMaxHealth()), 20, Color(167, 15,75))
        draw.SimpleText(LocalPlayer():GetEyeTrace().Entity:Health(), "DermaDefault", 10, 30, color_white, TEXT_ALIGN_CENTER )
    
	cam.End3D2D()
end

hook.Add("PostDrawOpaqueRenderables", "example", function()

    PlyLevelRender()
    ZombieLevelRender()

end )

------------------------- Start Funcs 
