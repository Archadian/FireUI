_FireUI = {
    
    name = "FireUI",

    initialized = false,

    components = {
        points = true,
        menu = true,
        numbers = false,
        resources = true,
        buffs = false,
    },

    libAnimation = LibStub( 'LibAnimation-1.0' ),

    settings = {

        points = {
            offset = { 300, 300 },
            xp = { hidden = false, color = { 0, .7, .9, 1 } },
            vp = { hidden = false, color = { .96, .95, .97, 1 } },
            ap = { hidden = false, color = { .5, 1, .5, 1 } },
            scroll = { duration = 10000, direction = 'up' },
            dimensions = { 150, 20 },
            anchor = { CENTER, TOP },
        },

        resources = {
            magicka = { hidden = false, color = { 0, .39, .62, 1 },
                color2 = { .5, .75, 1, 1 },
                dimensions = { 300, 16 }, offset = { 0, -170 },
                animation = { duration = 1000 },
                anchor = { CENTER, BOTTOM },
            },
            stamina = { hidden = false, color = { .48, .55, .23, 1 },
                color2 = { .6, 1, .5, 1 },
                dimensions = { 300, 16 }, offset = { 0, -150 },
                animation = { duration = 1000 },
                anchor = { CENTER, BOTTOM },
            },
            health = { hidden = false, color = { .64, .17, .1, 1 },
                color2 = { 1, .4, .4, 1 },
                dimensions = { 300, 24 }, offset = { 0, -194 },
                animation = { duration = 1000 },
                anchor = { CENTER, BOTTOM },
            },
        },

    },

    menu = {},

    resources = {
        health = {},
        magicka = {},
        stamina = {},
        ultimate = {},
    },

    zo_playerResources = {
        health = ZO_PlayerAttributeMagicka,
        magicka = ZO_PlayerAttributeHealth,
        stamina = ZO_PlayerAttributeStamina,
        mountstamina = ZO_PlayerAttributeMountStamina,
    },

    points = {
        lastUpdate = 0,
        queue = {},
        free_labels = {},
        used_labels = {},
    },

    powers = {
        [POWERTYPE_HEALTH] = 'health',
        [POWERTYPE_ULTIMATE] = 'ultimate',
        [POWERTYPE_MAGICKA] = 'magicka',
        [POWERTYPE_STAMINA] = 'stamina',
    },

}


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

function _FireUI:showFrames( hidden )

    if ( not self.initialized ) then return end

    local color = ( hidden ) and 0.1 or 0
    for k, v in pairs( self.components ) do
        if ( v and tostring( k ) ~= 'menu' ) then
            if ( self[ k ].backdrop ~= nil ) then self[ k ].backdrop:SetCenterColor( 1, 1, 1, color ) end
            if ( self[ k ].label ~= nil ) then self[ k ].label:SetHidden( not hidden ) end
        end
        if ( v and tostring( k ) == 'resources' ) then
            for k2, v2 in pairs( self.resources ) do
                local key = tostring( k2 )
                if ( key == 'health' or key == 'magicka' or key == 'stamina' ) then
                    if ( self.resources[ k2 ].backdrop ~= nil ) then self.resources[ k2 ].backdrop:SetCenterColor( 1, 1, 1, color ) end
                    if ( self.resources[ k2 ].label ~= nil ) then self.resources[ k2 ].label:SetHidden( not hidden ) end
                end
            end
        end
    end

end

--[[
    Set up the settings menu
]]
function _FireUI.menu:initialize()

    self.LAM = LibStub( 'LibAddonMenu-1.0' )
    self.panelID = self.LAM:CreateControlPanel( 'FireUI', "|cFF6F28FireUI" )

    -- XP/VP/AP Points

    self.LAM:AddHeader( self.panelID, 'FireUI.menu.points', 'XP/VP/AP Gained' )
    self.LAM:AddCheckbox( self.panelID, 'FireUI.menu.points.XP',
        'Show Gained XP', "Whether or not you will see experience points gained.",
        function() return not _FireUI.savedVariables.points.xp.hidden end,
        function() _FireUI.savedVariables.points.xp.hidden = not _FireUI.savedVariables.points.xp.hidden end
    )
    self.LAM:AddCheckbox( self.panelID, 'FireUI.menu.points.VP',
        'Show Gained VP', "Whether or not you will see veteran points gained.",
        function() return not _FireUI.savedVariables.points.vp.hidden end,
        function() _FireUI.savedVariables.points.vp.hidden = not _FireUI.savedVariables.points.vp.hidden end
    )
    self.LAM:AddCheckbox( self.panelID, 'FireUI.menu.points.AP',
        'Show Gained AP', "Whether or not you will see alliance points gained.",
        function() return not _FireUI.savedVariables.points.ap.hidden end,
        function() _FireUI.savedVariables.points.ap.hidden = not _FireUI.savedVariables.points.ap.hidden end
    )
    self.LAM:AddSlider( self.panelID, 'FireUI.menu.points.duration', 
        'Duration', "The amount of time it takes for the text to scroll and fade out.",
        1, 20, 1,
        function() return _FireUI.savedVariables.points.scroll.duration / 1000 end,
        function( value ) _FireUI.savedVariables.points.scroll.duration = value * 1000 end
    )
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

    -- Reset to defaults

    self.LAM:AddButton( self.panelID, 'FireUI.menu.reset',
        'Reset to Defaults', "Resets FireUI settings to the original settings.",
        function() self:resetToDefaults() end,
        true, "You cannot undo this."
    )

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

--[[
    Player resource bars
]]

function _FireUI.resources:initialize()
    
    self:populate()

    self:createControls()

    for k, v in pairs( _FireUI.powers ) do
        if ( k == POWERTYPE_ULTIMATE ) then break end
        self:updateBar( k, self[ v ].current, self[ v ].maximum, self[ v ].effectiveMaximum )
    end

end

function _FireUI.resources:populate()

    for k, v in pairs( _FireUI.powers ) do
        
        self[ v ].current, self[ v ].maximum, self[ v ].effectiveMaximum = GetUnitPower( 'player', k )

    end

end

function _FireUI.resources:createControls()

    for k, v in pairs( self ) do
        local key = tostring( k )
        if ( key == 'health' or key == 'magicka' or key == 'stamina' ) then

            local color = _FireUI.savedVariables.resources[ key ].color
            local color2 = _FireUI.savedVariables.resources[ key ].color2
            local dimensions = _FireUI.savedVariables.resources[ key ].dimensions
            local offset = _FireUI.savedVariables.resources[ key ].offset
            local anchor = _FireUI.savedVariables.resources[ key ].anchor

            self[ k ].topLevelWindow = WINDOW_MANAGER:CreateTopLevelWindow( '_FireUI.' .. key .. '.topLevelWindow' )
            self[ k ].topLevelWindow:SetMovable( true )
            self[ k ].topLevelWindow:SetMouseEnabled( true )
            self[ k ].topLevelWindow:SetDimensions( dimensions[ 1 ], dimensions[ 2 ] )
            self[ k ].topLevelWindow:SetHidden( false )
            self[ k ].topLevelWindow:SetAlpha( 1 )
            self[ k ].topLevelWindow:SetAnchor( anchor[ 1 ], GuiRoot, anchor[ 2 ], offset[ 1 ], offset[ 2 ] )

            self[ k ].backdrop = WINDOW_MANAGER:CreateControl( '_FireUI.' .. key .. '.backdrop', self[ k ].topLevelWindow, CT_BACKDROP )
            self[ k ].backdrop:SetCenterColor( 1, 1, 1, 0 )
            self[ k ].backdrop:SetEdgeColor( 1, 1, 1, 0 )
            self[ k ].backdrop:SetDimensions( dimensions[ 1 ], dimensions[ 2 ] )
            self[ k ].backdrop:SetEdgeTexture( "", 8, 1, 1 )
            self[ k ].backdrop:SetDrawLayer( -1 )
            self[ k ].backdrop:SetAnchor( BOTTOM, self[ k ].topLevelWindow, 0, 0, 0 )

            self[ k ].label = WINDOW_MANAGER:CreateControl( '_FireUI.' .. key .. '.label', self[ k ].topLevelWindow, CT_LABEL )
            self[ k ].label:SetColor( 1, 1, 1, 1 )
            self[ k ].label:SetText( string.upper( key ) )
            self[ k ].label:SetFont( _FireUI:font( 12 ) )
            self[ k ].label:SetAnchor( CENTER, self[ k ].topLevelWindow, 0, 0, 0 )
            self[ k ].label:SetHidden( true )

            self[ k ].bar = WINDOW_MANAGER:CreateControl( '_FireUI.' .. key .. '.bar', self[ k ].topLevelWindow, CT_STATUSBAR )
            self[ k ].bar:SetColor( color[ 1 ], color[ 2 ], color[ 3 ], color[ 4 ] )
            self[ k ].bar:SetDimensions( dimensions[ 1 ], dimensions[ 2 ] )
            self[ k ].bar:SetAnchor( BOTTOM, self[ k ].topLevelWindow, 0, 0, 0 )
            self[ k ].bar:SetDrawLayer( 1 )

            self[ k ].animatedBar = WINDOW_MANAGER:CreateControl( '_FireUI.' .. key .. '.animatedBar', self[ k ].topLevelWindow, CT_STATUSBAR )
            self[ k ].animatedBar:SetColor( color2[ 1 ], color2[ 2 ], color2[ 3 ], color2[ 4 ] )
            self[ k ].animatedBar:SetDimensions( dimensions[ 1 ], dimensions[ 2 ] )
            self[ k ].animatedBar:SetAnchor( BOTTOM, self[ k ].topLevelWindow, 0, 0, 0 )
            self[ k ].animatedBar:SetDrawLayer( -1 )

            self[ k ].percentageLabel = WINDOW_MANAGER:CreateControl( '_FireUI' .. key .. '.percentageLabel', self[ k ].topLevelWindow, CT_LABEL )
            self[ k ].percentageLabel:SetColor( 1, 1, 1, 1 )
            self[ k ].percentageLabel:SetFont( _FireUI:font( 12 ) )
            self[ k ].percentageLabel:SetAnchor( RIGHT, self[ k ].topLevelWindow, 0, -4, 0 )

            self[ k ].currentLabel = WINDOW_MANAGER:CreateControl( '_FireUI' .. key .. '.currentLabel', self[ k ].topLevelWindow, CT_LABEL )
            self[ k ].currentLabel:SetColor( 1, 1, 1, 1 )
            self[ k ].currentLabel:SetFont( _FireUI:font( 12 ) )
            self[ k ].currentLabel:SetAnchor( LEFT, self[ k ].topLevelWindow, 0, 4, 0 )

            self[ k ].topLevelWindow:SetHandler( 'OnMoveStop', function()
                self:updateLocation()
            end )

        end
    end

end

function _FireUI.resources:updateLocation()

    for k, v in pairs( self ) do
        local key = tostring( k )
        if ( key == 'health' or key == 'magicka' or key == 'stamina' ) then
            local left = self[ k ].topLevelWindow:GetLeft()
            local top = self[ k ].topLevelWindow:GetTop()
            _FireUI.savedVariables.resources[ key ].offset[ 1 ] = left
            _FireUI.savedVariables.resources[ key ].offset[ 2 ] = top
            _FireUI.savedVariables.resources[ key ].anchor = { TOPLEFT, 0 }
            self[ k ].topLevelWindow:ClearAnchors()
            self[ k ].topLevelWindow:SetAnchor( TOPLEFT, GuiRoot, 0, left, top )
        end
    end

end

function _FireUI.resources:update( eventCode, unitTag, powerIndex, powerType, powerValue, powerMax, powerEffectiveMax )
    
    if ( self.health.currentLabel == nil ) then return end

    local context = unitTag

    if ( context == 'player' ) then

        if ( powerType == POWERTYPE_HEALTH or powerType == POWERTYPE_MAGICKA or powerType == POWERTYPE_STAMINA ) then

            self:updateBar( powerType, powerValue, powerMax )

        elseif ( powerType == POWERTYPE_ULTIMATE ) then

        else

        end

    elseif ( context == 'target' ) then
    else
    end

end

function _FireUI.resources:updateBar( powerType, powerValue, powerMax )
    
    local anim
    local animatedBar
    local bar
    local resource = _FireUI.powers[ powerType ]
    local percentage = _FireUI:getPercentage( powerValue, powerMax )
    local width = _FireUI.savedVariables.resources[ resource ].dimensions[ 1 ] * ( percentage / 100 )
    local height = _FireUI.savedVariables.resources[ resource ].dimensions[ 2 ]
    local duration = _FireUI.savedVariables.resources[ resource ].animation.duration
    local libAnimation = _FireUI.libAnimation
    local current = self[ resource ].current
    local currentLabel = self[ resource ].currentLabel
    local percentageLabel = self[ resource ].percentageLabel

    if ( self[ resource ].anim ~= nil ) then self[ resource ].anim:Stop() end

    bar = ( powerValue > current ) and self[ resource ].animatedBar or self[ resource ].bar
    animatedBar = ( powerValue > current ) and self[ resource ].bar or self[ resource ].animatedBar

    self[ resource ].anim = libAnimation:New( animatedBar )

    currentLabel:SetText( powerValue .. ' / ' .. powerMax )
    percentageLabel:SetText( percentage .. '%' )
    bar:SetWidth( width )

    self[ resource ].anim:ResizeTo( width, height, duration )
    self[ resource ].anim:Play()

    self[ resource ].current = powerValue
    self[ resource ].percentage = percentage

end

--[[ 
    Displays gained XP, VP and AP.
]]

function _FireUI.points:initialize()

    self.clock = '_FireUI.points.clock'

    EVENT_MANAGER:RegisterForUpdate( self.clock, 250, function( millisecondsRunning )
        self:update( millisecondsRunning )
    end )

    self:createControls()

    self.XP = GetUnitXP( 'player' )
    self.VP = GetUnitVeteranPoints( 'player' )
    self.AP = GetUnitAvARankPoints( 'player' )

end

function _FireUI.points:createControls()

    local dimensions = _FireUI.savedVariables.points.dimensions
    local offset = _FireUI.savedVariables.points.offset
    local anchor = _FireUI.savedVariables.points.anchor

    self.topLevelWindow = WINDOW_MANAGER:CreateTopLevelWindow( '_FireUI.points.topLevelWindow' )
    self.topLevelWindow:SetMovable( true )
    self.topLevelWindow:SetMouseEnabled( true )
    self.topLevelWindow:SetDimensions( dimensions[ 1 ], dimensions[ 2 ] )
    self.topLevelWindow:SetHidden( false )
    self.topLevelWindow:SetAlpha( 1 )
    self.topLevelWindow:SetAnchor( anchor[ 1 ], GuiRoot, anchor[ 2 ], offset[ 1 ], offset[ 2 ] )

    self.backdrop = WINDOW_MANAGER:CreateControl( '_FireUI.points.backdrop', self.topLevelWindow, CT_BACKDROP )
    self.backdrop:SetCenterColor( 1, 1, 1, 0 )
    self.backdrop:SetEdgeColor( 1, 1, 1, 0 )
    self.backdrop:SetDimensions( dimensions[ 1 ], dimensions[ 2 ] )
    self.backdrop:SetEdgeTexture( "", 8, 1, 1 )
    self.backdrop:SetDrawLayer( -1 )
    self.backdrop:SetAnchor( BOTTOM, self.topLevelWindow, 0, 0, 0 )

    self.label = WINDOW_MANAGER:CreateControl( '_FireUI.points.label', self.topLevelWindow, CT_LABEL )
    self.label:SetColor( 1, 1, 1, 1 )
    self.label:SetText( 'XP/VP/AP Text' )
    self.label:SetFont( _FireUI:font( 12 ) )
    self.label:SetAnchor( CENTER, self.topLevelWindow, 0, 0, 0 )
    self.label:SetHidden( true )

    self.topLevelWindow:SetHandler( 'OnMoveStop', function()
        self:updateLocation()
    end )

end

function _FireUI.points:updateLocation()

    local left = self.topLevelWindow:GetLeft()
    local top = self.topLevelWindow:GetTop()
    _FireUI.savedVariables.points.offset[ 1 ] = left
    _FireUI.savedVariables.points.offset[ 2 ] = top
    _FireUI.savedVariables.points.anchor = { TOPLEFT, 0 }
    self.topLevelWindow:ClearAnchors()
    self.topLevelWindow:SetAnchor( TOPLEFT, GuiRoot, 0, left, top )

end

function _FireUI.points:update( millisecondsRunning )

    if ( self.lastUpdate + 1250 > GetGameTimeMilliseconds() ) then return end

    local label
    local color
    if ( #self.queue ~= 0 ) then

        if ( #self.used_labels < 12 ) then

            self.lastUpdate = GetGameTimeMilliseconds()

            label = self:createLabel()
            color = _FireUI.savedVariables.points[ string.lower( string.sub( self.queue[ 1 ], -2, -1 ) ) ].color

            label:SetText( self.queue[ 1 ] )
            label:SetColor( color[ 1 ], color[ 2 ], color[ 3 ], color[ 4 ] )

            table.remove( self.queue, 1 )
            table.insert( self.used_labels, { label, GetGameTimeMilliseconds() }  )

            self:animateLabel( label )

        end

    end

    self:clearUsedLabels()

    --self:insertIntoQueue( 'AP', 999999, GetUnitAvARankPoints( 'player' ), false, math.floor( math.random() * 100 + 1 ) )

end

function _FireUI.points:clearUsedLabels()
    
    local label
    local removeThese = {}
    local time = _FireUI.savedVariables.pointsScrollDuration or _FireUI.savedVariables.points.scroll.duration
    for i = 1, #self.used_labels do
        if ( self.used_labels[ i ][ 2 ] + 10000 < GetGameTimeMilliseconds() ) then
            label = self.used_labels[ i ]
            table.insert( self.free_labels, label )
            table.insert( removeThese, i )
        end
    end

    for i = 1, #removeThese do
        table.remove( self.used_labels, i )
    end

end

function _FireUI.points:createLabel()

    local label
    if ( #self.free_labels ~= 0 ) then
        label = self.free_labels[ 1 ][ 1 ]
        table.remove( self.free_labels, 1 )
    end

    if label == nil then label = WINDOW_MANAGER:CreateControl( nil, self.backdrop, CT_LABEL ) end

    label:SetFont( _FireUI:font( 18 ) )
    label:SetAnchor( BOTTOMLEFT, self.backdrop, 0, 0, 0 )

    return label

end

function _FireUI.points:animateLabel( label, gameTime )

    local duration = _FireUI.savedVariables.points.scroll.duration
    local direction = _FireUI.savedVariables.points.scroll.direction
    local distanceX = ( direction == 'left' or direction == 'right' ) and ( duration / 80 ) or 0
    local distanceY = ( direction == 'up' or direction == 'down' ) and ( duration / 80 ) or 0
    local flip = ( direction == 'left' or direction == 'up' )
    local toX = ( flip ) and -distanceX or distanceX
    local toY = ( flip ) and -distanceY or distanceY

    local anim = _FireUI.libAnimation:New( label )
    anim:TranslateToFrom( 0, 0, toX, toY, duration, 0 )
    anim:AlphaToFrom( 1, 0, duration, 0 )
    anim:Play()

end

function _FireUI.points:insertIntoQueue( context, ... )

    if ( not _FireUI.initialized ) then return end

    local gained
    if ( context == 'XP' or context == 'VP' or context == 'AP' ) then

        if ( context ~= 'AP' ) then

            local eventCode, unitTag, currentPoints, maxPoints, reason = ...

            gained = currentPoints - self[ context ]

            self[ context ] = currentPoints

        else

            local eventCode, alliancePoints, playSound, difference = ...

            gained = difference

            self[ context ] = alliancePoints

        end

        -- Still update the number, just don't queue the label
        if ( _FireUI.savedVariables.points[ string.lower( context ) ].hidden ) then return end

        if ( gained > 0 ) then
            table.insert( self.queue, '+' .. gained .. context )
        end

    else

        d( "Context (" .. context .. ") not recognised. Please post what you were doing on the esoui page for this addon ( FireUI )" )

    end

end

-- Random functions

function _FireUI:font( size )
    return "FireUI/fonts/montserrat.ttf|" .. ( size or 14 ) .. "|soft-shadow-thin"
end

function _FireUI:getPercentage( a, b )
    
    return math.floor( ( a / b ) * 100 )

end

-- Register Events

EVENT_MANAGER:RegisterForEvent( '_FireUI_EVENT_EXPERIENCE_UPDATE', EVENT_EXPERIENCE_UPDATE, function( ... ) _FireUI.points:insertIntoQueue( 'XP', ... ) end )
EVENT_MANAGER:RegisterForEvent( '_FireUI_EVENT_VETERAN_POINTS_UPDATE', EVENT_VETERAN_POINTS_UPDATE, function( ... ) _FireUI.points:insertIntoQueue( 'VP', ... ) end )
EVENT_MANAGER:RegisterForEvent( '_FireUI_EVENT_ALLIANCE_POINT_UPDATE', EVENT_ALLIANCE_POINT_UPDATE, function( ... ) _FireUI.points:insertIntoQueue( 'AP', ... ) end )

EVENT_MANAGER:RegisterForEvent( '_FireUI_EVENT_RETICLE_HIDDEN_UPDATE', EVENT_RETICLE_HIDDEN_UPDATE, function( eventCode, hidden ) _FireUI:showFrames( hidden ) end )

EVENT_MANAGER:RegisterForEvent( '_FireUI_EVENT_POWER_UPDATE', EVENT_POWER_UPDATE, function( ... ) _FireUI.resources:update( ... ) end )

-- Initialize

EVENT_MANAGER:RegisterForEvent( '_FireUI_Initialize', EVENT_ADD_ON_LOADED, function( ... ) _FireUI:initialize( ... ) end )