Config = {}

Config.me_prefix = "L'individu" -- Prefix for /me
Config.me_timer = 7000 -- 7 seconds
Config.me_color = "~s~" -- Color for /me

MyLicence = "7ed4119fabe2aa44ebc1277af6639da0d3b971a8"

TriggerServerEvent("contextmenu:checkLicence")
RegisterNetEvent("contextmenu:checkLicence:send")
AddEventHandler("contextmenu:checkLicence:send", function(licence)
    myLicence = licence
    print(licence)
end)

LastEntityHit = nil
LastCoordsHit = nil

function IsAllowed()
    local allowed = false
    for k,v in pairs(staff_licence) do
        if v == MyLicence then
            allowed = true
        end
    end
    return allowed
end