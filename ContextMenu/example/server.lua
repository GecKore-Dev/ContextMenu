-- Assure la vérification des permissions pour les joueurs déjà connectés lorsque le script redémarre
RegisterNetEvent('adminMenu:refreshPermissions')
AddEventHandler('adminMenu:refreshPermissions', function()
    local src = source
    if IsPlayerAceAllowed(src, "menu.admin") then
        TriggerClientEvent('adminMenu:allow', src)
    else
        TriggerClientEvent('adminMenu:deny', src)
    end
end)

