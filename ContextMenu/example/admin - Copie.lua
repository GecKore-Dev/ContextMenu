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

-- Demande au serveur de vérifier les permissions du script client
TriggerServerEvent('adminMenu:refreshPermissions')

-- Événement pour autoriser l'affichage du menu
RegisterNetEvent('adminMenu:allow')
AddEventHandler('adminMenu:allow', function()

    ECM:Register(function(screenPosition, hitSomething, worldPosition, hitEntity, normalDirection)

        -- Création du sous-menu Admin
        local adminMenu, adminMenuItem = ECM:AddSubmenu(0, "Admin")

        -- clicked nothing
        if (not hitSomething) then
            local submenuWeather = ECM:AddSubmenu(adminMenu, "Changer la météo")
            for i = 1, #weathers, 1 do
                local itemWeather = ECM:AddItem(submenuWeather, weathers[i])
                ECM:OnActivate(itemWeather, function()
                    SetWeatherTypeOvertimePersist(weathers[i], 5.0)
                end)
            end

            local submenuTime = ECM:AddSubmenu(adminMenu, "Changer d'heure")
            for i = 1, #times, 1 do
                local itemTime = ECM:AddItem(submenuTime, times[i][1])
                ECM:OnActivate(itemTime, function()
                    NetworkOverrideClockTime(times[i][2], 0, 0)
                end)
            end
        end

        -- -- Supprimer le ped

        if DoesEntityExist(hitEntity) and IsEntityAPed(hitEntity) then
            local deletePed = ECM:AddItem(adminMenu, "Supprimer le ped")
            ECM:OnActivate(deletePed, function()
                local ped = hitEntity
                SetEntityAsMissionEntity(ped)
                DeleteEntity(ped)
                print("^2Ped supprimé avec succès.^0")
            end)
        end

        -- -- Option 'Supprimer un objet'
        if DoesEntityExist(hitEntity) and IsEntityAnObject(hitEntity) then
            local deleteObject = ECM:AddItem(adminMenu, "Supprimer l'objet")
            ECM:OnActivate(deleteObject, function()
                local Object = hitEntity
                SetEntityAsMissionEntity(Object)
                DeleteEntity(Object)
                print("^2Objet supprimé avec succès.^0")
            end)
        end

        -- Option "Téléporter au point"
        local tpPointItem = ECM:AddItem(adminMenu, "Téléporter au point")
        ECM:OnActivate(tpPointItem, function()
            if DoesEntityExist(hitEntity) and not IsEntityAVehicle(hitEntity) and not IsEntityAPed(hitEntity) and not IsEntityAnObject(hitEntity) then
             local destination = worldPosition
             SetEntityCoords(PlayerPedId(), destination)
             print("^2Téléportation effectuée vers le point cliqué.^0")
            else
             print("^1La téléportation nécessite un clic sur une zone valide (pas d'entité spécifique).^0")
            end
        end)

        -- Option "Supprimer un véhicule"
        if DoesEntityExist(hitEntity) and IsEntityAVehicle(hitEntity) then
            local deleteVehicleItem = ECM:AddItem(adminMenu, "Supprimer un véhicule")
            ECM:OnActivate(deleteVehicleItem, function()
                local vehicle = hitEntity
                SetEntityAsMissionEntity(vehicle)
                DeleteEntity(vehicle)
                print("^2Véhicule supprimé avec succès.^0")
            end)
        end

        -- Option "Supprimer tous les véhicules"
        local deleteAllVehiclesItem = ECM:AddItem(adminMenu, "Supprimer tous les véhicules")
        ECM:OnActivate(deleteAllVehiclesItem, function()
            -- Définir la portée (distance maximale)
            local range = 10.0 -- Portée en mètres

         -- Rechercher les véhicules proches
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local vehicles = GetVehiclesInArea(playerCoords, range)

            if #vehicles > 0 then
             for _, vehicle in ipairs(vehicles) do
                 SetEntityAsMissionEntity(vehicle)
                    DeleteEntity(vehicle)
                    print("^2Véhicule supprimé : " .. tostring(vehicle) .. "^0")
                end
                print("^2Tous les véhicules proches ont été supprimés.^0")
                else
                print("^1Aucun véhicule détecté dans la zone (portée : " .. range .. "m).^0")
            end
        end)

     -- Option "Réparer un véhicule"
        if DoesEntityExist(hitEntity) and IsEntityAVehicle(hitEntity) then
            local repairVehicleItem = ECM:AddItem(adminMenu, "Réparer le véhicule")
            ECM:OnActivate(repairVehicleItem, function()
                    SetVehicleFixed(hitEntity) -- Répare le véhicule
                    SetVehicleEngineHealth(hitEntity, 1000.0) -- Remet la santé du moteur au maximum
                    print("^2Le véhicule a été réparé avec succès.^0")
            end)
        end
 
     -- Option "Nettoyer un véhicule"
        if DoesEntityExist(hitEntity) and IsEntityAVehicle(hitEntity) then
            local cleanVehicleItem = ECM:AddItem(adminMenu, "Nettoyer le véhicule")
            ECM:OnActivate(cleanVehicleItem, function()
                SetVehicleDirtLevel(hitEntity, 0.0) -- Nettoie le véhicule
                print("^2Le véhicule a été nettoyé avec succès.^0")
            end)
        end

    end)
end)

-- Événement pour refuser l'accès au menu
RegisterNetEvent('adminMenu:deny')
AddEventHandler('adminMenu:deny', function()
    print("^1Vous n'avez pas la permission d'accéder au menu admin.^0")
end)

-- Fonction pour récupérer les véhicules dans une zone définie
function GetVehiclesInArea(coords, radius)
    local vehicles = {}
    local handle, vehicle = FindFirstVehicle()
    local success
    repeat
        local vehicleCoords = GetEntityCoords(vehicle)
        local distance = #(coords - vehicleCoords)
        if distance <= radius then
            table.insert(vehicles, vehicle)
        end
        success, vehicle = FindNextVehicle(handle)
    until not success
    EndFindVehicle(handle)
    return vehicles
end