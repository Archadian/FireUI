--[[
    Set up the settings menu
]]
function _FireUI.menu:initialize()

    self.isLocked = true

    self.LAM = LibStub( 'LibAddonMenu-1.0' )
    self.panelID = self.LAM:CreateControlPanel( 'FireUI', "|cFF6F28FireUI" )

    -- General

    self.LAM:AddHeader( self.panelID, 'FireUI.menu.general', 'General' )

    -- Move the frames
    self.LAM:AddButton( self.panelID, 'FireUI.menu.move',
        'Unlock', "Unlocks FireUI elements so they can be moved.",
        function( control ) self:toggleLock( control ) end,
        false, ""
    )

    -- Reset to defaults
    self.LAM:AddButton( self.panelID, 'FireUI.menu.reset',
        'Reset to Defaults', "Resets FireUI settings to the original settings.",
        function() self:resetToDefaults() end,
        true, "This requires a /reloadui. You cannot undo this action."
    )

    -- XP/VP/AP Points

    self.LAM:AddHeader( self.panelID, 'FireUI.menu.points', 'XP/VP/AP Gained' )

    for k, v in pairs( _FireUI.points.loop ) do

        self.LAM:AddCheckbox( self.panelID, 'FireUI.menu.points.' .. k,
            'Show Gained ' .. string.upper( k ), "Whether or not you will see " .. v .. " points gained.",
            function() return not _FireUI.savedVariables.points[ k ].hidden end,
            function() _FireUI.savedVariables.points[ k ].hidden = not _FireUI.savedVariables.points[ k ].hidden end
        )

    end

    -- Set the duration
    self.LAM:AddSlider( self.panelID, 'FireUI.menu.points.duration', 
        'Duration', "The amount of time it takes for the text to scroll and fade out.",
        1, 20, 1,
        function() return _FireUI.savedVariables.points.scroll.duration / 1000 end,
        function( value ) _FireUI.savedVariables.points.scroll.duration = value * 1000 end
    )

    -- Set the direction
    self.LAM:AddDropdown( self.panelID, 'FireUI.menu.point.direction',
        'Direction', "The direction in which the text will travel.",
        { 'Up', 'Down', 'Left', 'Right' },
        function() return ( _FireUI.savedVariables.points.scroll.direction:gsub( "%a", string.upper, 1 ) ) end,
        function( value ) _FireUI.savedVariables.points.scroll.direction = string.lower( value ) end
    )

    -- Health/Stamina/Magicka Bars

    self.LAM:AddHeader( self.panelID, 'FireUI.menu.resources', 'Character Resource Bars' )

    for k, v in pairs( _FireUI.settings.resources ) do

        local resource = tostring( k )

        self.LAM:AddCheckbox( self.panelID, 'FireUI.menu.resources.' .. resource,
            resource:gsub( "%a", string.upper, 1 ) .. ' Bar', 
            "Whether or not to display the FireUI " .. resource .." bar.",
            function() return not _FireUI.savedVariables.resources[ resource ].hidden end,
            function() self:toggleBar( resource ) end
        )
        self.LAM:AddSlider( self.panelID, 'FireUI.menu.resources.' .. resource ..'.dimensions[ 1 ]',
            '    Width', "The width of the FireUI " .. resource .." bar in pixels.",
            0, 2560, 10,
            function() return _FireUI.savedVariables.resources[ resource ].dimensions[ 1 ] end,
            function( value ) self:adjustBarSize( resource, value ) end
        )
        self.LAM:AddSlider( self.panelID, 'FireUI.menu.resources.' .. resource ..'.dimensions[ 2 ]',
            '    Height', "The height of the FireUI " .. resource .." bar in pixels.",
            0, 100, 1,
            function() return _FireUI.savedVariables.resources[ resource ].dimensions[ 2 ] end,
            function( value ) self:adjustBarSize( resource, nil, value ) end
        )
        self.LAM:AddColorPicker( self.panelID, 'FireUI.menu.resources.' .. resource ..'.color',
            '    Colour', "The colour of the FireUI " .. resource .." bar.",
            function() return unpack( _FireUI.savedVariables.resources[ resource ].color ) end,
            function( r, g, b, a ) self:adjustBarColor( resource, r, g, b, a ) end
        )
        self.LAM:AddColorPicker( self.panelID, 'FireUI.menu.resources.' .. resource ..'.color2',
            '    Secondary Colour', "The colour of the FireUI " .. resource .." bar's animation.",
            function() return unpack( _FireUI.savedVariables.resources[ resource ].color2 ) end,
            function( r, g, b, a ) self:adjustBarColor( resource, r, g, b, a, true ) end
        )

    end

end

-- Function to unlock/lock the frames
function _FireUI.menu:toggleLock( control )

    if ( self.isLocked ) then
        control:SetText( 'Lock' )
        self.isLocked = false
    else
        control:SetText( 'Unlock' )
        self.isLocked = true
    end

    local locked = self.isLocked
    local alpha = ( locked ) and 0 or 0.1

    for i = 1, #_FireUI.topLevelWindows do

        _FireUI.topLevelWindows[ i ]:SetHidden( locked )
        _FireUI.topLevelWindows[ i ]:SetMovable( not locked )

    end

    for i = 1, #_FireUI.backdrops do

        _FireUI.backdrops[ i ]:SetCenterColor( 1, 1, 1, alpha )

    end

    for i = 1, #_FireUI.labels do

        _FireUI.labels[ i ]:SetHidden( locked )

    end

end

-- Function to adjust bar size
function _FireUI.menu:adjustBarSize( resource, width, height )

    local dimensions = { width or _FireUI.savedVariables.resources[ resource ].dimensions[ 1 ], height or _FireUI.savedVariables.resources[ resource ].dimensions[ 2 ] }

    _FireUI.savedVariables.resources[ resource ].dimensions = dimensions
    _FireUI.resources[ resource ].topLevelWindow:SetDimensions( dimensions[ 1 ], dimensions[ 2 ] )
    _FireUI.resources[ resource ].backdrop:SetDimensions( dimensions[ 1 ], dimensions[ 2 ] )
    _FireUI.resources[ resource ].bar:SetDimensions( dimensions[ 1 ], dimensions[ 2 ] )

end

-- Function to hide bars
function _FireUI.menu:toggleBar( resource )

    local hidden = not _FireUI.savedVariables.resources[ resource ].hidden
    _FireUI.savedVariables.resources[ resource ].hidden = hidden
    _FireUI.resources[ resource ].topLevelWindow:SetHidden( hidden )

end

-- Function to change the colour of bars
function _FireUI.menu:adjustBarColor( resource, r, g, b, a, second )
    
    local setting = ( second ) and { 'color2', 'animatedBar' } or { 'color', 'bar' }

    _FireUI.savedVariables.resources[ resource ][ setting[ 1 ] ] = { r, g, b, a }
    _FireUI.resources[ resource ][ setting[ 2 ] ]:SetColor( r, g, b, a )

end

function _FireUI.menu:resetToDefaults()
    for k, v in pairs( _FireUI.settings ) do
        _FireUI.savedVariables[ k ] = v
    end
end