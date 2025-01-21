
local weathers = {
    "Clear",
    "Extrasunny",
    "Clouds",
    "Overcast",
    "Rain",
    "Clearing",
    "Thunder",
    "Smog",
    "Foggy",
    "Xmas",
    "Snowlight",
    "Blizzard"
}

local times = {
    { "Morning", 8 },
    { "Afternoon", 12 },
    { "Evening", 18 },
    { "Night", 22 },
}

local ECM = exports["ContextMenu"]

ECM:Register(function(screenPosition, hitSomething, worldPosition, hitEntity, normalDirection)

    -- clicked nothing
    if (not hitSomething) then
        local submenuWeather = ECM:AddSubmenu(adminMenu, "Change weather")
        for i = 1, #weathers, 1 do
            local itemWeather = ECM:AddItem(submenuWeather, weathers[i])
            ECM:OnActivate(itemWeather, function()
                SetWeatherTypeOvertimePersist(weathers[i], 5.0)
            end)
        end

        local submenuTime = ECM:AddSubmenu(adminMenu, "Change time")
        for i = 1, #times, 1 do
            local itemTime = ECM:AddItem(submenuTime, times[i][1])
            ECM:OnActivate(itemTime, function()
                NetworkOverrideClockTime(times[i][2], 0, 0)
            end)
        end
    end
end)
