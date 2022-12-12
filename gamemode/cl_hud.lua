AddCSLuaFile"cl_init.lua"
AddCSLuaFile"shared.lua"
include"shared.lua"

surface.CreateFont("HUDFont", {
	font = "Segoe UI Bold",
	size = 28,
	antialias = true,
	outline = true,
})

surface.CreateFont("HUDFontWeapon", {
	font = "Segoe UI Bold",
	size = 38,
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

local CamPos = Vector( 15, 4, 60 )
local LookAt = Vector( 0, 0, 60 )
local function PlayerModel()

	--> Create
	PlayerModel = vgui.Create( "DModelPanel" )
	function PlayerModel:LayoutEntity( Entity ) return end
	PlayerModel:SetModel( LocalPlayer():GetModel() )
	PlayerModel:SetPos( 245,  695)
	PlayerModel:SetSize( 130, 200 )
	PlayerModel:ParentToHUD()
	PlayerModel.Entity:SetPos( PlayerModel.Entity:GetPos() - Vector( 0, 0, 4 ) )
	PlayerModel:SetCamPos( CamPos )
	PlayerModel:SetLookAt( LookAt )

	timer.Create( "PlayerModelUpdate", 1, 0, function()
		if LocalPlayer():GetModel() != PlayerModel.Entity:GetModel() && LocalPlayer():Alive() then
			
			--> Remove Panel
			PlayerModel:Remove()

			--> Create Panel
			PlayerModel = vgui.Create( "DModelPanel" )
			function PlayerModel:LayoutEntity( Entity ) return end
			PlayerModel:SetModel( LocalPlayer():GetModel() )
			PlayerModel:SetPos( 275,  695)
			PlayerModel:SetSize( 180, 80 )
			PlayerModel:ParentToHUD()
			PlayerModel.Entity:SetPos( PlayerModel.Entity:GetPos() - Vector( 0, 0, 4 ) )
			PlayerModel:SetCamPos( CamPos )
			PlayerModel:SetLookAt( LookAt )

		end
	end )

end
hook.Add( "InitPostEntity", "PlayerModel", PlayerModel )

hook.Add("HUDPaint", "HUDHOOK", function()

	local RoundNumberVar = net.ReadInt(32)

	if (LocalPlayer():Alive()) then
		draw.RoundedBox(4, 0, surface.ScreenHeight() / 1.334, 400, 225, Color(222,16,50))
	draw.RoundedBox(4 + 4, 0 + 2.5, surface.ScreenHeight() / 1.34 + 6, 400 - 5, 225 - 5, Color(45,45,45))

	draw.SimpleText(LocalPlayer():GetName(), "HUDFont", 10, surface.ScreenHeight() / 1.31, color_white )
	draw.SimpleText("Rank: " .. LocalPlayer():GetNWInt("PlayerRank"), "HUDFont", 10, surface.ScreenHeight() / 1.25, color_white )
	draw.SimpleText("Prestige: " .. LocalPlayer():GetNWInt("PlayerPrestige"), "HUDFont", 10, surface.ScreenHeight() / 1.2, color_white )
	draw.SimpleText("Money: $" .. LocalPlayer():GetNWInt("MoneyAmount"), "HUDFont", 10, surface.ScreenHeight() / 1.155, color_white )

	draw.RoundedBox(0, 10, surface.ScreenHeight() / 1.105, 200, 30, Color(222,16,50))
	draw.RoundedBox(0, 10 + 2.5, surface.ScreenHeight() / 1.11 + 6, 200 * (LocalPlayer():Health() / LocalPlayer():GetMaxHealth()) - 5, 30 - 5, Color(167, 15,75))
	draw.SimpleText(LocalPlayer():Health(), "HUDFont", 115, surface.ScreenHeight() / 1.108, color_white, TEXT_ALIGN_CENTER )

	draw.RoundedBox(0, 10, surface.ScreenHeight() / 1.056, 200, 30, Color(222,16,50))
	draw.RoundedBox(0, 10 + 2.5, surface.ScreenHeight() / 1.06+ 6, 200 * (LocalPlayer():Armor() / 100) - 5, 30 - 5, Color(55,55,222))
	draw.SimpleText(LocalPlayer():Armor(), "HUDFont", 115, surface.ScreenHeight() / 1.056, color_white, TEXT_ALIGN_CENTER )

	-- Main Hud

	draw.RoundedBox(4, 0, 0, 200, 50, Color(222,16,50))
	draw.RoundedBox(4 + 3, 0 + 2.5, 2, 200 - 4, 50 - 4, Color(45,45,45))
	draw.SimpleText("Round: " .. tostring(LocalPlayer():GetNWInt("RoundNumberVar")), "HUDFont", 100, 10, color_white, TEXT_ALIGN_CENTER )

	draw.RoundedBox(4, 200, 0, surface.ScreenWidth() - 200, 50, Color(222,16,50))
	draw.RoundedBox(4 + 3, 200 + 2.5, 2, surface.ScreenWidth() *(LocalPlayer():GetNWInt("PlayerRankProgress") / LocalPlayer():GetNWInt("MaxPlayerRankProgress")) , 50 - 4, Color(45,45,45, 177))
	draw.SimpleText(LocalPlayer():GetNWInt("PlayerRankProgress").. " / " .. LocalPlayer():GetNWInt("MaxPlayerRankProgress"), "HUDFont", 865 + 2.5, 10, color_white, TEXT_ALIGN_CENTER )

	-- XP and Round

	draw.RoundedBox(4, surface.ScreenWidth() / 1.19, surface.ScreenHeight() / 1.2, 300, 150, Color(222,16,50))
	draw.RoundedBox(4 + 4, surface.ScreenWidth() / 1.19 + 2.5, surface.ScreenHeight() / 1.205 + 6, 300 - 5, 150 - 5, Color(45,45,45))

	draw.SimpleText(LocalPlayer():GetActiveWeapon():GetPrintName(), "HUDFontWeapon", surface.ScreenWidth() / 1.085, surface.ScreenHeight() / 1.15, color_white, TEXT_ALIGN_CENTER )
	draw.DrawText( LocalPlayer():GetActiveWeapon():Clip1() .. " / " .. LocalPlayer():GetAmmoCount(LocalPlayer():GetActiveWeapon():GetPrimaryAmmoType()), "HUDFontWeapon", surface.ScreenWidth() / 1.085, surface.ScreenHeight() / 1.1, Color(255,255,255,255), TEXT_ALIGN_CENTER)

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