AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

surface.CreateFont("HUDFont", {
	font = "Segoe UI Bold",
	size = 24,
	antialias = true,
	outline = true,
})

surface.CreateFont("HUDFontObjectives", {
	font = "Segoe UI Bold",
	size = 13,
	antialias = true,
})

surface.CreateFont("HUDFontWeapon", {
	font = "Segoe UI Bold",
	size = 34,
	antialias = true,
	outline = true,
})

local hide = {
	["CHudHealth"] = true,
	["CHudBattery"] = true,
	["CHudAmmo"] = true,
}

hook.Add( "HUDShouldDraw", "HideHUD", function( name )
	if ( hide[ name ] ) then
		return false
	end
end )

hook.Add("HUDPaint", "HUDHOOK", function()

	if (LocalPlayer():Alive()) then
		draw.RoundedBox(4, 10, surface.ScreenHeight() * 0.80, surface.ScreenWidth() * 0.155, surface.ScreenHeight() * 0.19, Color(222,16,50))
		draw.RoundedBox(4 + 4, 10 + 2.5, surface.ScreenHeight() * 0.802, surface.ScreenWidth() * 0.155 - 6, surface.ScreenHeight() * 0.19 - 5, Color(45,45,45))

		draw.SimpleText(LocalPlayer():GetName(), "HUDFont", 15, surface.ScreenHeight() * 0.805, color_white )
		draw.SimpleText("Rank: " .. LocalPlayer():GetNWInt("PlayerRank"), "HUDFont", 15, surface.ScreenHeight() * 0.825, color_white )
		draw.SimpleText("Prestige: " .. LocalPlayer():GetNWInt("PlayerPrestige"), "HUDFont", 15, surface.ScreenHeight() * 0.843, color_white )
		draw.SimpleText("Money: $" .. LocalPlayer():GetNWInt("MoneyAmount"), "HUDFont", 15, surface.ScreenHeight() * 0.864, color_white )

		draw.RoundedBox(8, 15, surface.ScreenHeight() * 0.89, surface.ScreenWidth() * 0.148, surface.ScreenHeight() * 0.03, Color(222,16,50))
		draw.RoundedBox(8, 15 + 2, surface.ScreenHeight() * 0.8923, surface.ScreenWidth() * 0.148 * (LocalPlayer():Health() / LocalPlayer():GetMaxHealth()) - 5, surface.ScreenHeight() * 0.03 - 5, Color(167, 15,75))
		draw.SimpleText(LocalPlayer():Health(), "HUDFont", surface.ScreenWidth() * 0.0855, surface.ScreenHeight() * 0.892, color_white, TEXT_ALIGN_CENTER )

		draw.RoundedBox(8, 15, surface.ScreenHeight() * 0.93, surface.ScreenWidth() * 0.148, surface.ScreenHeight() * 0.03, Color(222,16,50))
		draw.RoundedBox(8, 15 + 2, surface.ScreenHeight() * 0.9325, surface.ScreenWidth() * 0.148 * (LocalPlayer():Armor() / 100) - 5, surface.ScreenHeight() * 0.03 - 5, Color(15, 75,167))
		draw.SimpleText(LocalPlayer():Armor(), "HUDFont", surface.ScreenWidth() * 0.085, surface.ScreenHeight() * 0.932, color_white, TEXT_ALIGN_CENTER )


		-- Main Hud

		draw.RoundedBox(4, 0, 0, 200, 250, Color(222,16,50))
		draw.RoundedBox(4 + 3, 0 + 2.5, 2, 200 - 4, 250 - 4, Color(45,45,45))
		draw.RoundedBox(4, 0, surface.ScreenHeight() * 0.04, 200, 5, Color(222,16,50))
		draw.SimpleText("Round: " .. tostring(LocalPlayer():GetNWInt("RoundNumberVar")), "HUDFont", 10, 10, color_white )
		draw.SimpleText("Objectives", "HUDFont", 10, surface.ScreenHeight() * 0.06, color_white )
		draw.SimpleText("• Find Intel From Zombines (0 / 5)", "HUDFontObjectives", 10, surface.ScreenHeight() * 0.09, color_white )
		draw.SimpleText("• Collect Money ($" .. LocalPlayer():GetNWInt("MoneyAmount") .. " / $500000)", "HUDFontObjectives", 10, surface.ScreenHeight() * 0.11, color_white )
		draw.SimpleText("• Survive Rounds (" .. LocalPlayer():GetNWInt("RoundNumberVar") .. " / 50)", "HUDFontObjectives", 10, surface.ScreenHeight() * 0.13, color_white )

		draw.RoundedBox(4, 200, 0, surface.ScreenWidth() - 200, 50, Color(222,16,50))
		draw.RoundedBox(4 + 3, 200 + 2.5, 2, surface.ScreenWidth() * (LocalPlayer():GetNWInt("PlayerRankProgress") / LocalPlayer():GetNWInt("MaxPlayerRankProgress")) , 50 - 4, Color(45,45,45, 177))

		if (LocalPlayer():GetNWInt("PlayerRank") >= 100) then 
			draw.SimpleText("Prestige Ready [E]", "HUDFont", surface.ScreenWidth() *  0.54, 10, color_white, TEXT_ALIGN_CENTER )
		else
			draw.SimpleText(LocalPlayer():GetNWInt("PlayerRankProgress").. " / " .. LocalPlayer():GetNWInt("MaxPlayerRankProgress"), "HUDFont", surface.ScreenWidth() *  0.55, 10, color_white, TEXT_ALIGN_CENTER )
		end

		-- XP and Round

		if (IsValid(LocalPlayer():GetActiveWeapon())) then
			draw.RoundedBox(4, surface.ScreenWidth() * 0.815, surface.ScreenHeight() * 0.84, surface.ScreenWidth() * 0.175, surface.ScreenHeight() * 0.15, Color(222,16,50))
			draw.RoundedBox(4 + 4, surface.ScreenWidth() * 0.815 + 2.5, surface.ScreenHeight() * 0.8424, surface.ScreenWidth() * 0.175 - 5, surface.ScreenHeight() * 0.15 - 5, Color(45,45,45))

			draw.SimpleText(LocalPlayer():GetActiveWeapon():GetPrintName(), "HUDFontWeapon", surface.ScreenWidth() * 0.9, surface.ScreenHeight() * 0.88, color_white, TEXT_ALIGN_CENTER )
			draw.DrawText( LocalPlayer():GetActiveWeapon():Clip1() .. " / " .. LocalPlayer():GetAmmoCount(LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType()), "HUDFontWeapon", surface.ScreenWidth() * 0.9, surface.ScreenHeight() * 0.91, Color(255,255,255,255), TEXT_ALIGN_CENTER)
		end

		-- Weapon
	end

end)

net.Receive("RoundChange", function()
	local RoundNumber = net.ReadInt(32)
	surface.PlaySound"ambient/alarms/apc_alarm_pass1.wav"
	hook.Add("HUDPaint", "DrawRoundText", function()
		draw.DrawText("Round " .. tostring(RoundNumber) .. "!", "HUDFont", ScrW() * 0.5, ScrH() * 0.5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
	end)
	timer.Simple(2, function() hook.Remove("HUDPaint", "DrawRoundText") end)
end)
