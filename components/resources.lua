_FireUI.resources = {}

--- This function is used to initialize the resources.
function _FireUI.resources:initialize()

    -- Populate the resources tables with the current player resources.
    self:populate()

    -- Create the user interface.
    self:createControls()

    -- Loop through the list of powers and update the relevant ones.
    for powerType, name in pairs( _FireUI.config.powerList ) do

        -- Ultimate uses a different update method, as it returns different arguments.
        if ( powerType == POWERTYPE_ULTIMATE ) then

            self:updateUltimate( self[ name ].current, self[ name ].maximum, self[ name ].effectiveMaximum )

        -- If the powerType is health, magicka or stamina - update normally.
        elseif ( powerType == POWERTYPE_HEALTH or powerType == POWERTYPE_MAGICKA or powerType == POWERTYPE_STAMINA ) then

            self:updateBar( powerType, self[ name ].current, self[ name ].maximum, self[ name ].effectiveMaximum )

        end
    end

end

function _FireUI.resources:populate()

    for powerType, name in pairs( _FireUI.config.powerList ) do

        self[ name ] = {}
        self[ name ].current, self[ name ].maximum, self[ name ].effectiveMaximum = GetUnitPower( 'player', powerType )

    end

end

function _FireUI.resources:createControls()

    local dimensions    = _FireUI.savedVariables.resources.dimensions
    local offset        = _FireUI.savedVariables.resources.offset
    local anchor        = _FireUI.savedVariables.resources.anchor

    self.topLevelWindow = WINDOW_MANAGER:CreateTopLevelWindow( '_FireUI.resources.topLevelWindow' )
    self.topLevelWindow:SetMovable( false )
    self.topLevelWindow:SetMouseEnabled( true )
    self.topLevelWindow:SetDimensions( dimensions[ 1 ], dimensions[ 2 ] )
    self.topLevelWindow:SetHidden( false )
    self.topLevelWindow:SetAlpha( 1 )
    self.topLevelWindow:SetAnchor( anchor[ 1 ], GuiRoot, anchor[ 2 ], offset[ 1 ], offset[ 2 ] )
    _FireUI.frames.resources.topLevelWindow = self.topLevelWindow

    self.backdrop = WINDOW_MANAGER:CreateControl( '_FireUI.resources.backdrop', self.topLevelWindow, CT_BACKDROP )
    self.backdrop:SetCenterColor( 1, 1, 1, 0 )
    self.backdrop:SetEdgeColor( 1, 1, 1, 0 )
    self.backdrop:SetDimensions( dimensions[ 1 ], dimensions[ 2 ] )
    self.backdrop:SetEdgeTexture( "", 8, 1, 1 )
    self.backdrop:SetDrawLayer( -1 )
    self.backdrop:SetAnchor( BOTTOM, self.topLevelWindow, 0, 0, 0 )
    _FireUI.frames.resources.backdrop = self.backdrop

    self.label = WINDOW_MANAGER:CreateControl( '_FireUI.resources.label', self.topLevelWindow, CT_LABEL )
    self.label:SetColor( 1, 1, 1, 1 )
    self.label:SetText( string.upper( key ) )
    self.label:SetFont( _FireUI:font( nil, 12 ) )
    self.label:SetAnchor( CENTER, self.topLevelWindow, 0, 0, 0 )
    self.label:SetHidden( true )
    _FireUI.frames.resources.label = self.label

    for k, v in pairs( self ) do
        local resource = tostring( k )
        if ( resource == 'health' or resource == 'magicka' or resource == 'stamina' ) then

            local qrt = GuiRoot:GetHeight() * .25
            local tmp = { ['health'] = qrt, ['magicka'] = qrt + 28, ['stamina'] = qrt + 48 }

            color       = _FireUI.savedVariables.resources[ resource ].color
            color2      = _FireUI.savedVariables.resources[ resource ].color2
            dimensions  = _FireUI.savedVariables.resources[ resource ].dimensions

            if ( not _FireUI.savedVariables.resources[ resource ].offset[ 1 ] ) then _FireUI.savedVariables.resources[ resource ].offset[ 1 ] = ( GuiRoot:GetWidth() * .5 ) - ( dimensions[ 1 ] * .5 ) end
            if ( not _FireUI.savedVariables.resources[ resource ].offset[ 2 ] ) then _FireUI.savedVariables.resources[ resource ].offset[ 2 ] = ( GuiRoot:GetHeight() * .5 ) + ( tmp[ resource ] ) end

            offset      = _FireUI.savedVariables.resources[ resource ].offset
            anchor      = _FireUI.savedVariables.resources[ resource ].anchor

            self[ resource ].topLevelWindow = WINDOW_MANAGER:CreateTopLevelWindow( '_FireUI.resources.' .. resource .. '.topLevelWindow' )
            self[ resource ].topLevelWindow:SetMovable( false )
            self[ resource ].topLevelWindow:SetMouseEnabled( true )
            self[ resource ].topLevelWindow:SetDimensions( dimensions[ 1 ], dimensions[ 2 ] )
            self[ resource ].topLevelWindow:SetHidden( false )
            self[ resource ].topLevelWindow:SetAlpha( 1 )
            self[ resource ].topLevelWindow:SetAnchor( anchor[ 1 ], GuiRoot, anchor[ 2 ], offset[ 1 ], offset[ 2 ] )
            _FireUI.frames.resources[ resource ].topLevelWindow = self[ resource ].topLevelWindow

            self[ resource ].backdrop = WINDOW_MANAGER:CreateControl( '_FireUI.resources.' .. resource .. '.backdrop', self[ resource ].topLevelWindow, CT_BACKDROP )
            self[ resource ].backdrop:SetCenterColor( 1, 1, 1, 0 )
            self[ resource ].backdrop:SetEdgeColor( 1, 1, 1, 0 )
            self[ resource ].backdrop:SetDimensions( dimensions[ 1 ], dimensions[ 2 ] )
            self[ resource ].backdrop:SetEdgeTexture( "", 8, 1, 1 )
            self[ resource ].backdrop:SetDrawLayer( 2 )
            self[ resource ].backdrop:SetHidden( true )
            self[ resource ].backdrop:SetAnchor( BOTTOM, self[ resource ].topLevelWindow, 0, 0, 0 )
            _FireUI.frames.resources[ resource ].backdrop = self[ resource ].backdrop

            self[ resource ].label = WINDOW_MANAGER:CreateControl( '_FireUI.resources.' .. resource .. '.label', self[ resource ].topLevelWindow, CT_LABEL )
            self[ resource ].label:SetColor( 1, 1, 1, 1 )
            self[ resource ].label:SetText( string.upper( resource ) )
            self[ resource ].label:SetFont( _FireUI:font( nil, 12 ) )
            self[ resource ].label:SetAnchor( CENTER, self[ resource ].topLevelWindow, 0, 0, 0 )
            self[ resource ].backdrop:SetDrawLayer( 3 )
            self[ resource ].label:SetHidden( true )
            _FireUI.frames.resources[ resource ].label = self[ resource ].label

            self[ resource ].bar = WINDOW_MANAGER:CreateControl( '_FireUI.resources.' .. resource .. '.bar', self[ resource ].topLevelWindow, CT_STATUSBAR )
            self[ resource ].bar:SetColor( color[ 1 ], color[ 2 ], color[ 3 ], color[ 4 ] )
            self[ resource ].bar:SetDimensions( dimensions[ 1 ], dimensions[ 2 ] )
            self[ resource ].bar:SetAnchor( BOTTOM, self[ resource ].topLevelWindow, 0, 0, 0 )
            self[ resource ].bar:SetDrawLayer( 1 )
            _FireUI.frames.resources[ resource ].bar = self[ resource ].bar

            self[ resource ].animatedBar = WINDOW_MANAGER:CreateControl( '_FireUI.resources.' .. resource .. '.animatedBar', self[ resource ].topLevelWindow, CT_STATUSBAR )
            self[ resource ].animatedBar:SetColor( color2[ 1 ], color2[ 2 ], color2[ 3 ], color2[ 4 ] )
            self[ resource ].animatedBar:SetDimensions( dimensions[ 1 ], dimensions[ 2 ] )
            self[ resource ].animatedBar:SetAnchor( BOTTOM, self[ resource ].topLevelWindow, 0, 0, 0 )
            self[ resource ].animatedBar:SetDrawLayer( -1 )
            _FireUI.frames.resources[ resource ].animatedBar = self[ resource ].animatedBar

            self[ resource ].percentageLabel = WINDOW_MANAGER:CreateControl( '_FireUI.resources.' .. resource .. '.percentageLabel', self[ resource ].topLevelWindow, CT_LABEL )
            self[ resource ].percentageLabel:SetColor( 1, 1, 1, 1 )
            self[ resource ].percentageLabel:SetFont( _FireUI:font( nil, 12 ) )
            self[ resource ].percentageLabel:SetAnchor(
                _FireUI.savedVariables.resources[ resource ].percentageLabelPoint,
                _FireUI.savedVariables.resources[ resource ].percentageLabelRelativeTo or self[ resource ].topLevelWindow,
                _FireUI.savedVariables.resources[ resource ].percentageLabelRelativePoint,
                _FireUI.savedVariables.resources[ resource ].percentageLabelOffsetX,
                _FireUI.savedVariables.resources[ resource ].percentageLabelOffsetY
            )
            _FireUI.frames.resources[ resource ].percentageLabel = self[ resource ].percentageLabel

            self[ resource ].currentLabel = WINDOW_MANAGER:CreateControl( '_FireUI.resources.' .. resource .. '.currentLabel', self[ resource ].topLevelWindow, CT_LABEL )
            self[ resource ].currentLabel:SetColor( 1, 1, 1, 1 )
            self[ resource ].currentLabel:SetFont( _FireUI:font( nil, 12 ) )
            self[ resource ].currentLabel:SetAnchor(
                _FireUI.savedVariables.resources[ resource ].currentLabelPoint,
                _FireUI.savedVariables.resources[ resource ].currentLabelRelativeTo or self[ resource ].topLevelWindow,
                _FireUI.savedVariables.resources[ resource ].currentLabelRelativePoint,
                _FireUI.savedVariables.resources[ resource ].currentLabelOffsetX,
                _FireUI.savedVariables.resources[ resource ].currentLabelOffsetY
            )
            _FireUI.frames.resources[ resource ].currentLabel = self[ resource ].currentLabel

            self[ resource ].topLevelWindow:SetHandler( 'OnMoveStop', function()
                self:updateLocation( resource )
            end )

        elseif ( resource == 'ultimate' ) then

            self.ultimate.totalLabel = WINDOW_MANAGER:CreateControl( '_FireUI.resources.ultimate.totalLabel', ActionButton8, CT_LABEL )
            self.ultimate.totalLabel:SetColor( .5, .5, .5, 1 )
            self.ultimate.totalLabel:SetFont( _FireUI:font( nil, 10 ) )
            self.ultimate.totalLabel:SetAnchor( CENTER, ActionButton8, CENTER, 0, -38 )
            self.ultimate.totalLabel:SetText( "0/1000" )
            
            self.ultimate.percentageLabel = WINDOW_MANAGER:CreateControl( '_FireUI.resources.ultimate.percentageLabel', ActionButton8, CT_LABEL )
            self.ultimate.percentageLabel:SetColor( 1, 1, 1, 1 )
            self.ultimate.percentageLabel:SetFont( _FireUI:font( nil, 10 ) )
            self.ultimate.percentageLabel:SetAnchor( CENTER, ActionButton8, CENTER, 0, 14 )
            self.ultimate.percentageLabel:SetText( "0%" )

        end

    end

end

function _FireUI.resources:updateLocation( resource )

    local offsetX = _FireUI.frames.resources[ resource ].topLevelWindow:GetLeft()
    local offsetY = _FireUI.frames.resources[ resource ].topLevelWindow:GetTop()

    _FireUI.savedVariables.resources[ resource ].offset = { offsetX, offsetY }

end

-- To DO: Add handler for ultimate and shield
function _FireUI.resources:update( eventCode, unitTag, powerIndex, powerType, powerValue, powerMax, powerEffectiveMax )
    
    if ( self.health == nil ) then return end
    if ( self.health.currentLabel == nil ) then return end

    local context = unitTag

    if ( context == 'player' ) then

        if ( powerType == POWERTYPE_HEALTH or powerType == POWERTYPE_MAGICKA or powerType == POWERTYPE_STAMINA or powerType == POWERTYPE_MOUNT_STAMINA or powerType == POWERTYPE_WEREWOLF ) then

            self:updateBar( powerType, powerValue, powerMax, powerEffectiveMax )

        elseif ( powerType == POWERTYPE_ULTIMATE ) then

            self:updateUltimate( powerValue, powerMax, powerEffectiveMax )

        else

        end

    elseif ( context == 'reticleover' ) then

        if ( powerType == POWERTYPE_HEALTH ) then

            _FireUI.target:updateControls( powerValue )

        end

    else
    end

end

function _FireUI.resources:updateUltimate( powerValue, powerMax, powerEffectiveMax )

    if ( UnitInfo_PlayerUltimate ~= nil ) then UnitInfo_PlayerUltimate:SetHidden( true ) end

    local cost, _ = GetSlotAbilityCost(8)

    self.ultimate.totalLabel:SetText( powerValue .. ' / ' .. powerMax )
    self.ultimate.percentageLabel:SetText( _FireUI:getPercentage( powerValue, cost ) .. '%' )

end

function _FireUI.resources:updateBar( powerType, powerValue, powerMax, powerEffectiveMax )

    if ( powerType ~= POWERTYPE_HEALTH and powerType ~= POWERTYPE_MAGICKA and powerType ~= POWERTYPE_STAMINA and powerType ~= POWERTYPE_MOUNT_STAMINA ) then return end

    -- Temporary fix until WEREWOLF_STATE_CHANGE works correctly
    -- if ( self.werewolf and powerValue == 0 ) then
    --     self.werewolf = false
    --     self:updateWerewolf( self.werewolf )
    -- end

    -- Mount bar replaces stamina bar
    if ( powerType == POWERTYPE_STAMINA and self.mounted ) then return end
    if ( powerType == POWERTYPE_MOUNT_STAMINA and self.mounted ) then powerType = POWERTYPE_STAMINA end
    if ( powerType == POWERTYPE_MOUNT_STAMINA and not self.mounted ) then return end

    -- Werewolf bar replaces magicka bar
    -- if ( powerType == POWERTYPE_MAGICKA and self.werewolf ) then return end
    -- if ( powerType == POWERTYPE_WEREWOLF and self.werewolf ) then powerType = POWERTYPE_MAGICKA end
    -- if ( powerType == POWERTYPE_WEREWOLF and not self.werewolf ) then return end

    local anim
    local animatedBar
    local bar
    local width
    local height
    local resource = _FireUI.config.powerList[ powerType ]
    local percentage = _FireUI:getPercentage( powerValue, powerEffectiveMax )
    local duration = _FireUI.savedVariables.resources[ resource ].animation.duration
    local libAnimation = _FireUI.libAnimation
    local current = self[ resource ].current
    local currentLabel = self[ resource ].currentLabel
    local percentageLabel = self[ resource ].percentageLabel
    local mode = _FireUI.savedVariables.resources[ resource ].animation.mode

    if ( self[ resource ].anim ~= nil ) then self[ resource ].anim:Stop() end

    if ( mode == 'Right to Left' or mode == 'Left to Right' or mode == 'Horizontal Centered' ) then
        width = _FireUI.savedVariables.resources[ resource ].dimensions[ 1 ] * ( percentage / 100 )
        height = _FireUI.savedVariables.resources[ resource ].dimensions[ 2 ]
    elseif ( mode == 'Top to Bottom' or mode == 'Bottom to Top' or mode == 'Vertical Centered' ) then
        width = _FireUI.savedVariables.resources[ resource ].dimensions[ 1 ]
        height = _FireUI.savedVariables.resources[ resource ].dimensions[ 2 ] * ( percentage / 100 )
    elseif ( mode == 'Radial' ) then
        width = _FireUI.savedVariables.resources[ resource ].dimensions[ 1 ] * ( percentage / 100 )
        height = _FireUI.savedVariables.resources[ resource ].dimensions[ 2 ] * ( percentage / 100 )
    end

    bar = ( powerValue > current ) and self[ resource ].animatedBar or self[ resource ].bar
    animatedBar = ( powerValue > current ) and self[ resource ].bar or self[ resource ].animatedBar

    self[ resource ].anim = libAnimation:New( animatedBar )

    currentLabel:SetText( powerValue .. ' / ' .. powerEffectiveMax )
    percentageLabel:SetText( percentage .. '%' )
    bar:SetWidth( width )
    bar:SetHeight( height )

    self[ resource ].anim:ResizeTo( width, height, duration )
    self[ resource ].anim:Play()

    self[ resource ].current = powerValue
    self[ resource ].percentage = percentage

end

function _FireUI.resources:updateMount( mounted )

    self.mounted = mounted

    if ( self.mounted ) then

        _FireUI.resources:updateBar( POWERTYPE_MOUNT_STAMINA, GetUnitPower( 'player', POWERTYPE_MOUNT_STAMINA ) )

    else

        _FireUI.resources:updateBar( POWERTYPE_STAMINA, GetUnitPower( 'player', POWERTYPE_STAMINA ) )

    end

end

function _FireUI.resources:updateWerewolf( werewolf )

    self.werewolf = werewolf

    if ( self.werewolf ) then

        _FireUI.resources:updateBar( POWERTYPE_WEREWOLF, GetUnitPower( 'player', POWERTYPE_WEREWOLF ) )

    else

        _FireUI.resources:updateBar( POWERTYPE_MAGICKA, GetUnitPower( 'player', POWERTYPE_MAGICKA ) )

    end        

end