AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
AddCSLuaFile("sv_money.lua")
AddCSLuaFile("sv_zombiespawner.lua")

include( "shared.lua" )
include("sv_money.lua")

surface.CreateFont("HUDFont", {
	font = "Trebuchet24",
	outline = true,
	size = 40
})

surface.CreateFont("BIGAMMO", {
	font = "Trebuchet24",
	outline = false,
	size = 50
})

local hide = {
	["CHudHealth"] = true,
	["CHudBattery"] = true,
	["CHudAmmo"] = true
}

hook.Add( "HUDShouldDraw", "HideHUD", function( name )
	if ( hide[ name ] ) then
		return false
	end
end )

hook.Add("HUDPaint", "HUDHOOK", function()

	if (IsValid(LocalPlayer())) then

		if (LocalPlayer():Alive()) then

			draw.DrawText("HP: " .. LocalPlayer():Health(), "BIGAMMO", 10, surface.ScreenHeight() / 1.25, Color(255,255,255,255), TEXT_ALIGN_LEFT)
			draw.DrawText("ARMOR: " .. LocalPlayer():Armor(), "BIGAMMO", 10, surface.ScreenHeight() / 1.15, Color(255,255,255,255), TEXT_ALIGN_LEFT)
            draw.DrawText( "Money: $" .. LocalPlayer():GetMoney(), "Trebuchet24", 10, surface.ScreenHeight() / 2, Color(44,255,44,255), TEXT_ALIGN_LEFT)
			
			if(IsValid(GetConVar("RoundNumber"))) then
				draw.DrawText( "Round: " .. tostring(GetConVar("RoundNumber"):GetInt()), "Trebuchet24", 10, surface.ScreenHeight() / 1.9, Color(255,80,80,255), TEXT_ALIGN_LEFT)
			end
            if(!IsValid(GetConVar("RoundNumber"))) then
				draw.DrawText( "Round: 1", "Trebuchet24", 10, surface.ScreenHeight() / 1.9, Color(255,80,80,255), TEXT_ALIGN_LEFT)
			end

			if (IsValid(LocalPlayer():GetActiveWeapon())) then

				if (LocalPlayer():GetActiveWeapon():Clip1() > -1) then

					draw.DrawText( LocalPlayer():GetActiveWeapon():Clip1() .. " / " .. LocalPlayer():GetAmmoCount(LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType()), "BIGAMMO", surface.ScreenWidth() - 150, surface.ScreenHeight() / 1.23, Color(255,255,255,255), TEXT_ALIGN_LEFT)

					draw.DrawText( LocalPlayer():GetActiveWeapon():GetPrintName(), "Trebuchet24", surface.ScreenWidth() - 150, surface.ScreenHeight() / 1.15, Color(255,255,255,255), TEXT_ALIGN_LEFT)

                    


				end

			end

		end

	end
	-- Main Display
end)