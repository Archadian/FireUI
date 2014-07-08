_FireUI.points = {}

function _FireUI.points:initialize()

    -- self.clock = '_FireUI.points.clock'

    -- EVENT_MANAGER:RegisterForUpdate( self.clock, 250, function( millisecondsRunning )
    --     self:update( millisecondsRunning )
    -- end )

    self:createControls()

    self.xp = GetUnitXP( 'player' )
    self.vp = GetUnitVeteranPoints( 'player' )
    self.ap = GetUnitAvARankPoints( 'player' )

end

function _FireUI.points:createControls()

    local dimensions = _FireUI.savedVariables.points.dimensions
    local offset = _FireUI.savedVariables.points.offset
    local anchor = _FireUI.savedVariables.points.anchor

    self.topLevelWindow = WINDOW_MANAGER:CreateTopLevelWindow( '_FireUI.points.topLevelWindow' )
    self.topLevelWindow:SetMovable( false )
    self.topLevelWindow:SetMouseEnabled( true )
    self.topLevelWindow:SetDimensions( dimensions[ 1 ], dimensions[ 2 ] )
    self.topLevelWindow:SetHidden( false )
    self.topLevelWindow:SetAlpha( 1 )
    self.topLevelWindow:SetAnchor( anchor[ 1 ], GuiRoot, anchor[ 2 ], offset[ 1 ], offset[ 2 ] )
    _FireUI.frames.points.topLevelWindow = self.topLevelWindow

    self.backdrop = WINDOW_MANAGER:CreateControl( '_FireUI.points.backdrop', self.topLevelWindow, CT_BACKDROP )
    self.backdrop:SetCenterColor( 1, 1, 1, 0.1 )
    self.backdrop:SetEdgeColor( 1, 1, 1, 0 )
    self.backdrop:SetDimensions( dimensions[ 1 ], dimensions[ 2 ] )
    self.backdrop:SetEdgeTexture( "", 8, 1, 1 )
    self.backdrop:SetDrawLayer( -1 )
    self.backdrop:SetAnchor( BOTTOM, self.topLevelWindow, 0, 0, 0 )
    self.backdrop:SetHidden( true )
    _FireUI.frames.points.backdrop = self.backdrop

    self.label = WINDOW_MANAGER:CreateControl( '_FireUI.points.label', self.topLevelWindow, CT_LABEL )
    self.label:SetColor( 1, 1, 1, 1 )
    self.label:SetText( 'XP/VP/AP Text' )
    self.label:SetFont( _FireUI:font( 12 ) )
    self.label:SetAnchor( CENTER, self.topLevelWindow, 0, 0, 0 )
    self.label:SetHidden( true )
    _FireUI.frames.points.label = self.label

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

function _FireUI.points:update( context, ... )

    if ( self[ context ] == nil ) then return end

    if ( context ~= 'ap' and context ~= 'xp' and context ~= 'vp' ) then return end

    local value
    if ( context == 'ap' ) then

        local eventCode, alliancePoints, playSound, difference = ...
        value = difference
        self[ context ] = alliancePoints

    else

        local eventCode, unitTag, currentPoints, maxPoints, reason = ...
        value = currentPoints - self[ context ]
        self[ context ] = currentPoints

    end

    if ( value == 0 ) then return end

    _FireUI.queue:insert( 'points', value .. string.upper( context ), '', COMBAT_UNIT_TYPE_PLAYER, '', COMBAT_UNIT_TYPE_PLAYER, '' )

end

EVENT_MANAGER:RegisterForEvent( '_FireUI_EVENT_EXPERIENCE_UPDATE', EVENT_EXPERIENCE_UPDATE, function( ... ) _FireUI.points:update( 'xp', ... ) end )
EVENT_MANAGER:RegisterForEvent( '_FireUI_EVENT_VETERAN_POINTS_UPDATE', EVENT_VETERAN_POINTS_UPDATE, function( ... ) _FireUI.points:update( 'vp', ... ) end )
EVENT_MANAGER:RegisterForEvent( '_FireUI_EVENT_ALLIANCE_POINT_UPDATE', EVENT_ALLIANCE_POINT_UPDATE, function( ... ) _FireUI.points:update( 'ap', ... ) end )