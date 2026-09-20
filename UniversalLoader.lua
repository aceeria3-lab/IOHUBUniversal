local placeId = game.PlaceId

if placeId == 107778070777162 then
    -- Unsupported game
    game.Players.LocalPlayer:Kick("Game is Not Supported Ask Iyong Official")
else
    -- Supported (lahat ng ibang game)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/aceeria3-lab/IOHUBUniversal/refs/heads/main/RideAPet.lua"))()
end
