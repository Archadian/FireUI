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
    self.topLevelWindow:SetMovable( false )
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
    table.insert( _FireUI.backdrops, self.backdrop )

    self.label = WINDOW_MANAGER:CreateControl( '_FireUI.points.label', self.topLevelWindow, CT_LABEL )
    self.label:SetColor( 1, 1, 1, 1 )
    self.label:SetText( 'XP/VP/AP Text' )
    self.label:SetFont( _FireUI:font( 12 ) )
    self.label:SetAnchor( CENTER, self.topLevelWindow, 0, 0, 0 )
    self.label:SetHidden( true )
    table.insert( _FireUI.labels, self.label )

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

    -- This is to prevent vertical overlapping... Wonder what to do about the horz problem
    local speed = _FireUI.savedVariables.points.scroll.speed
    local delay = ( 1000 / speed ) * _FireUI.savedVariables.points.font.size

    if ( self.lastUpdate + delay > GetGameTimeMilliseconds() ) then return end

    local label
    local color
    if ( #self.queue ~= 0 ) then

        if ( #self.used_labels < 12 ) then

            self.lastUpdate = GetGameTimeMilliseconds()

            label = self:createLabel()
            color = _FireUI.savedVariables.points[ string.lower( string.sub( self.queue[ 1 ], -2, -1 ) ) ].color

            label:SetText( self.queue[ 1 ] )
            label:SetColor( unpack( color ) )

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
    local fontFace = _FireUI.savedVariables.points.font.face
    local fontSize = _FireUI.savedVariables.points.font.size
    local fontShadow = _FireUI.savedVariables.points.font.shadow
    if ( #self.free_labels ~= 0 ) then
        label = self.free_labels[ 1 ][ 1 ]
        table.remove( self.free_labels, 1 )
    end

    if label == nil then label = WINDOW_MANAGER:CreateControl( nil, self.backdrop, CT_LABEL ) end

    label:SetFont( _FireUI:font( fontFace, fontSize, fontShadow ) )
    label:SetAnchor( BOTTOMLEFT, self.backdrop, 0, 0, 0 )

    return label

end

function _FireUI.points:animateLabel( label, gameTime )

    local duration = _FireUI.savedVariables.points.scroll.duration
    local speed = _FireUI.savedVariables.points.scroll.speed
    local direction = _FireUI.savedVariables.points.scroll.direction
    local distanceX = ( direction == 'left' or direction == 'right' ) and ( ( duration / 1000 ) * speed ) or 0
    local distanceY = ( direction == 'up' or direction == 'down' ) and ( ( duration / 1000 ) * speed ) or 0
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