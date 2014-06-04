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
            self[ k ].topLevelWindow:SetMovable( false )
            self[ k ].topLevelWindow:SetMouseEnabled( true )
            self[ k ].topLevelWindow:SetDimensions( dimensions[ 1 ], dimensions[ 2 ] )
            self[ k ].topLevelWindow:SetHidden( false )
            self[ k ].topLevelWindow:SetAlpha( 1 )
            self[ k ].topLevelWindow:SetAnchor( anchor[ 1 ], GuiRoot, anchor[ 2 ], offset[ 1 ], offset[ 2 ] )
            table.insert( _FireUI.topLevelWindows, self[ k ].topLevelWindow )

            self[ k ].backdrop = WINDOW_MANAGER:CreateControl( '_FireUI.' .. key .. '.backdrop', self[ k ].topLevelWindow, CT_BACKDROP )
            self[ k ].backdrop:SetCenterColor( 1, 1, 1, 0 )
            self[ k ].backdrop:SetEdgeColor( 1, 1, 1, 0 )
            self[ k ].backdrop:SetDimensions( dimensions[ 1 ], dimensions[ 2 ] )
            self[ k ].backdrop:SetEdgeTexture( "", 8, 1, 1 )
            self[ k ].backdrop:SetDrawLayer( -1 )
            self[ k ].backdrop:SetAnchor( BOTTOM, self[ k ].topLevelWindow, 0, 0, 0 )
            table.insert( _FireUI.backdrops, self[ k ].backdrop )

            self[ k ].label = WINDOW_MANAGER:CreateControl( '_FireUI.' .. key .. '.label', self[ k ].topLevelWindow, CT_LABEL )
            self[ k ].label:SetColor( 1, 1, 1, 1 )
            self[ k ].label:SetText( string.upper( key ) )
            self[ k ].label:SetFont( _FireUI:font( 12 ) )
            self[ k ].label:SetAnchor( CENTER, self[ k ].topLevelWindow, 0, 0, 0 )
            self[ k ].label:SetHidden( true )
            table.insert( _FireUI.labels, self[ k ].label )

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