function _FireUI:initialize( eventCode, addOnName )
    
    if ( addOnName ~= self.name ) then return end

    self.savedVariables = ZO_SavedVars:New( "FireUISavedVariables", 1, nil, self.settings)

    for k, v in pairs( self.components ) do
        if ( v ) then self[ k ]:initialize() end
    end

    ZO_PlayerAttributeMagicka:SetHidden( not _FireUI.savedVariables.resources.magicka.hidden )
    ZO_PlayerAttributeHealth:SetHidden( not _FireUI.savedVariables.resources.health.hidden )
    ZO_PlayerAttributeStamina:SetHidden( not _FireUI.savedVariables.resources.stamina.hidden )
    ZO_PlayerAttributeMountStamina:SetHidden( not _FireUI.savedVariables.resources.mountStamina.hidden )

    self.initialized = true

end

--[[
    Register Events
]]

-- XP
EVENT_MANAGER:RegisterForEvent( '_FireUI_EVENT_EXPERIENCE_UPDATE', EVENT_EXPERIENCE_UPDATE, function( ... ) _FireUI.points:insertIntoQueue( 'XP', ... ) end )

-- VP
EVENT_MANAGER:RegisterForEvent( '_FireUI_EVENT_VETERAN_POINTS_UPDATE', EVENT_VETERAN_POINTS_UPDATE, function( ... ) _FireUI.points:insertIntoQueue( 'VP', ... ) end )

-- AP
EVENT_MANAGER:RegisterForEvent( '_FireUI_EVENT_ALLIANCE_POINT_UPDATE', EVENT_ALLIANCE_POINT_UPDATE, function( ... ) _FireUI.points:insertIntoQueue( 'AP', ... ) end )

-- Resources
EVENT_MANAGER:RegisterForEvent( '_FireUI_EVENT_POWER_UPDATE', EVENT_POWER_UPDATE, function( ... ) _FireUI.resources:update( ... ) end )

-- Mount update
EVENT_MANAGER:RegisterForEvent( '_FireUI_EVENT_MOUNTED_STATE_CHANGED', EVENT_MOUNTED_STATE_CHANGED, function( eventCode, mounted ) _FireUI.resources:updateMount( mounted ) end )

-- Werewolf
EVENT_MANAGER:RegisterForEvent( '_FireUI_EVENT_WEREWOLF_STATE_CHANGED', EVENT_WEREWOLF_STATE_CHANGED, function( eventCode, werewolf ) _FireUI.resources:updateWerewolf( werewolf ) end )

-- General
EVENT_MANAGER:RegisterForEvent( '_FireUI_EVENT_RETICLE_HIDDEN_UPDATE', EVENT_RETICLE_HIDDEN_UPDATE, function( eventCode, hidden ) _FireUI:toggleVisibility( hidden ) end )

-- Initialize
EVENT_MANAGER:RegisterForEvent( '_FireUI_Initialize', EVENT_ADD_ON_LOADED, function( ... ) _FireUI:initialize( ... ) end )