function _FireUI:initialize( eventCode, addOnName )
    
    if ( addOnName ~= self.name ) then return end

    self.savedVariables = ZO_SavedVars:New( "FireUISavedVariables", 1, nil, self.settings)

    for k, v in pairs( self.components ) do
        if ( v ) then self[ k ]:initialize() end
    end

    ZO_PlayerAttributeMagicka:SetHidden( true )
    ZO_PlayerAttributeHealth:SetHidden( true )
    ZO_PlayerAttributeStamina:SetHidden( true )

    self.initialized = true

end

-- Register Events

EVENT_MANAGER:RegisterForEvent( '_FireUI_EVENT_EXPERIENCE_UPDATE', EVENT_EXPERIENCE_UPDATE, function( ... ) _FireUI.points:insertIntoQueue( 'XP', ... ) end )
EVENT_MANAGER:RegisterForEvent( '_FireUI_EVENT_VETERAN_POINTS_UPDATE', EVENT_VETERAN_POINTS_UPDATE, function( ... ) _FireUI.points:insertIntoQueue( 'VP', ... ) end )
EVENT_MANAGER:RegisterForEvent( '_FireUI_EVENT_ALLIANCE_POINT_UPDATE', EVENT_ALLIANCE_POINT_UPDATE, function( ... ) _FireUI.points:insertIntoQueue( 'AP', ... ) end )

EVENT_MANAGER:RegisterForEvent( '_FireUI_EVENT_RETICLE_HIDDEN_UPDATE', EVENT_RETICLE_HIDDEN_UPDATE, function( eventCode, hidden ) _FireUI:toggleVisibility( hidden ) end )

EVENT_MANAGER:RegisterForEvent( '_FireUI_EVENT_POWER_UPDATE', EVENT_POWER_UPDATE, function( ... ) _FireUI.resources:update( ... ) end )

-- Initialize

EVENT_MANAGER:RegisterForEvent( '_FireUI_Initialize', EVENT_ADD_ON_LOADED, function( ... ) _FireUI:initialize( ... ) end )