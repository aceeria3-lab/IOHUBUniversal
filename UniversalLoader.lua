local placeId = game.PlaceId

if placeId == 124216119978534 then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/aceeria3-lab/IOHUBUniversal/refs/heads/main/RideAPet.lua"))()
else
    -- Force official Roblox error/kick screen with Leave button
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    
    pcall(function()
        LocalPlayer:Kick("Game is Not Supported")
    end)
    
    -- Backup method (kung hindi pa rin lumabas yung Kick)
    task.wait(0.5)
    game:GetService("GuiService"):SetError("Game is Not Supported Ask Iyong Official")
end
