--[[ DO NOT TOUCH ]]--
if SERVER then AddCSLuaFile() end
GBlocker = GBlocker or {}
GBlocker.Config = GBlocker.Config or {}
GBlocker.Version = "0.1"

--[[ Configuration Section ]]--
GBlocker.Config.BlockContextMenu = true -- Should we block the context (c) menu?
GBlocker.Config.BlockSpawnMenu = true -- Should we block the spawn (q) menu?
GBlocker.Config.BlockSuicide = true -- Should we block players from killing themself?
GBlocker.Config.BlockProperties = true -- Should we block players from using the properties (c > right click)?

-- What groups/steamids should be allowed to bypass the blocks?
GBlocker.Config.BypassBlocker = {
    ["owner"] = true,
    ["superadmin"] = true,
    ["STEAM_0:0:52522849"] = true,
}

--[[ Coding Section ]]--
function GBlocker:CanBypass(ply)
    if not IsValid(ply) or not ply:IsPlayer() then return false end
    return GBlocker.Config.BypassBlocker[ply:GetUserGroup()] or GBlocker.Config.BypassBlocker[ply:SteamID()] or GBlocker.Config.BypassBlocker[ply:SteamID64()]
end

if CLIENT then
    hook.Add("ContextMenuOpen", "GBlocker.Hooks.ContextMenu", function()
        if not GBlocker.Config.BlockContextMenu then return end
        if not GBlocker:CanBypass(LocalPlayer()) then return false end
    end)
    hook.Add("SpawnMenuOpen", "GBlocker.Hooks.SpawnMenu", function()
        if not GBlocker.Config.BlockSpawnMenu then return end
        if not GBlocker:CanBypass(LocalPlayer()) then return false end
    end)
else
    hook.Add("CanPlayerSuicide", "GBlocker.Hooks.Suicide", function(ply)
        if not GBlocker.Config.BlockSuicide then return end
        if not GBlocker:CanBypass(ply) then return false end
    end)
    hook.Add("CanProperty", "GBlocker.Hooks.Properties", function(ply, property, ent)
        if not GBlocker.Config.BlockProperties then return end
        if not GBlocker:CanBypass(ply) then return false end
    end)
end

print("[gBlocker] Loaded gBlocker v" .. GBlocker.Version .. " on server (" .. game.GetIPAddress() .. ")")