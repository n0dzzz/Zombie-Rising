AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

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

	draw.DrawText("Prestige: " .. LocalPlayer():GetNWInt("PlayerPrestige"), "DermaDefaultBold", surface.ScreenWidth() / 1.5, surface.ScreenHeight() / 80, Color(255,255,255,255), TEXT_ALIGN_LEFT) 
    draw.DrawText("Progress: " .. LocalPlayer():GetNWInt("PlayerRankProgress") .. " / "  .. LocalPlayer():GetNWInt("MaxPlayerRankProgress"), "DermaDefaultBold", surface.ScreenWidth() / 2.2, surface.ScreenHeight() / 80, Color(255,255,255,255), TEXT_ALIGN_LEFT)
	draw.DrawText("Rank: " .. LocalPlayer():GetNWInt("PlayerRank"), "DermaDefaultBold", surface.ScreenWidth() / 3, surface.ScreenHeight() / 80, Color(255,255,255,255), TEXT_ALIGN_LEFT)

	if (LocalPlayer():GetNWInt("PlayerRank") >= 100) then
		draw.DrawText("Press X to Prestige", "DermaDefaultBold", surface.ScreenWidth() / 2.2, surface.ScreenHeight() / 20, Color(255,255,255,255), TEXT_ALIGN_LEFT)

		if(input.IsKeyDown(34)) then -- x key
			LocalPlayer():SetNWInt("PlayerPrestige", LocalPlayer():GetNWInt("PlayerPrestige") + 1)

			LocalPlayer():SetNWInt("PlayerRank", 1)
			LocalPlayer():SetNWInt("PlayerRankProgress", 0)
		end
	end

	if (IsValid(LocalPlayer())) then
		if (LocalPlayer():Alive()) then
			
			draw.DrawText("HP: " .. LocalPlayer():Health(), "BIGAMMO", 10, surface.ScreenHeight() / 1.25, Color(255,255,255,255), TEXT_ALIGN_LEFT)
			draw.DrawText("ARMOR: " .. LocalPlayer():Armor(), "BIGAMMO", 10, surface.ScreenHeight() / 1.15, Color(255,255,255,255), TEXT_ALIGN_LEFT)
            draw.DrawText( "Money: $" .. LocalPlayer():GetNWInt("MoneyAmount"), "Trebuchet24", 10, surface.ScreenHeight() / 2, Color(44,255,44,255), TEXT_ALIGN_LEFT)
			draw.DrawText( "Round: " .. tostring(LocalPlayer():GetNWInt("RoundNumberVar")), "Trebuchet24", 10, surface.ScreenHeight() / 1.9, Color(255,80,80,255), TEXT_ALIGN_LEFT)

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
net.Receive("RoundChange", function()
	local RoundNumber = net.ReadInt(32)
	surface.PlaySound("ambient/alarms/apc_alarm_pass1.wav")

	hook.Add("HUDPaint", "DrawRoundText", function()
		draw.DrawText("Round ".. tostring(RoundNumber).. "!", "HUDFont", ScrW() * 0.5, ScrH() * 0.5, Color(255, 44, 44, 255), TEXT_ALIGN_CENTER)
	end)
	
	timer.Simple(2, function()
		hook.Remove("HUDPaint", "DrawRoundText")
	end)
end)
