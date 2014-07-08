_FireUI.target = {}

function _FireUI.target:initialize()

    self:createControls()

    self:updateControls()

end

function _FireUI.target:createControls()

    local anchor        = _FireUI.savedVariables.target.anchor
    local dimensions    = _FireUI.savedVariables.target.dimensions
    local offset        = _FireUI.savedVariables.target.offset

    if ( not _FireUI.savedVariables.target.offset[ 1 ] ) then _FireUI.savedVariables.target.offset[ 1 ] = ( GuiRoot:GetWidth() * .5 ) + 20 end
    if ( not _FireUI.savedVariables.target.offset[ 2 ] ) then _FireUI.savedVariables.target.offset[ 2 ] = ( GuiRoot:GetHeight() * .5 ) end

    local color        = _FireUI.savedVariables.target.color
    local color2       = _FireUI.savedVariables.target.color2

    self.topLevelWindow = WINDOW_MANAGER:CreateTopLevelWindow( '_FireUI.target.topLevelWindow' )
    self.topLevelWindow:SetMovable( false )
    self.topLevelWindow:SetMouseEnabled( true )
    self.topLevelWindow:SetDimensions( dimensions[ 1 ], dimensions[ 2 ] )
    self.topLevelWindow:SetHidden( false )
    self.topLevelWindow:SetAlpha( 1 )
    self.topLevelWindow:SetAnchor( anchor[ 1 ], GuiRoot, anchor[ 2 ], offset[ 1 ], offset[ 2 ] )
    _FireUI.frames.target.topLevelWindow = self.topLevelWindow

    self.backdrop = WINDOW_MANAGER:CreateControl( '_FireUI.target.backdrop', self.topLevelWindow, CT_BACKDROP )
    self.backdrop:SetCenterColor( 1, 1, 1, 0 )
    self.backdrop:SetEdgeColor( 1, 1, 1, 0 )
    self.backdrop:SetDimensions( dimensions[ 1 ], dimensions[ 2 ] )
    self.backdrop:SetEdgeTexture( "", 8, 1, 1 )
    self.backdrop:SetDrawLayer( -1 )
    self.backdrop:SetAnchor( TOPLEFT, self.topLevelWindow, TOPLEFT, 0, 0 )
    _FireUI.frames.target.backdrop = self.backdrop

    self.label = WINDOW_MANAGER:CreateControl( '_FireUI.target.label', self.topLevelWindow, CT_LABEL )
    self.label:SetColor( 1, 1, 1, 1 )
    self.label:SetText( "TARGET" )
    self.label:SetFont( _FireUI:font( nil, 12 ) )
    self.label:SetAnchor( CENTER, self.topLevelWindow, CENTER, 0, 0 )
    self.label:SetHidden( true )
    _FireUI.frames.target.label = self.label

    self.bar = WINDOW_MANAGER:CreateControl( '_FireUI.target.bar', self.topLevelWindow, CT_STATUSBAR )
    self.bar:SetColor( color[ 1 ], color[ 2 ], color[ 3 ], color[ 4 ] )
    self.bar:SetDimensions( dimensions[ 1 ], dimensions[ 2 ] )
    self.bar:SetAnchor( BOTTOM, self.topLevelWindow, 0, 0, 0 )
    self.bar:SetDrawLayer( 1 )
    _FireUI.frames.target.bar = self.bar

    self.animatedBar = WINDOW_MANAGER:CreateControl( '_FireUI.target.animatedBar', self.topLevelWindow, CT_STATUSBAR )
    self.animatedBar:SetColor( color2[ 1 ], color2[ 2 ], color2[ 3 ], color2[ 4 ] )
    self.animatedBar:SetDimensions( dimensions[ 1 ], dimensions[ 2 ] )
    self.animatedBar:SetAnchor( BOTTOM, self.topLevelWindow, 0, 0, 0 )
    self.animatedBar:SetDrawLayer( -1 )
    _FireUI.frames.target.animatedBar = self.animatedBar

    self.percentageLabel = WINDOW_MANAGER:CreateControl( '_FireUI.target.percentageLabel', self.topLevelWindow, CT_LABEL )
    self.percentageLabel:SetColor( 1, 1, 1, 1 )
    self.percentageLabel:SetFont( _FireUI:font( nil, 12 ) )
    self.percentageLabel:SetAnchor(
        _FireUI.savedVariables.target.percentageLabelPoint,
        _FireUI.savedVariables.target.percentageLabelRelativeTo or self.topLevelWindow,
        _FireUI.savedVariables.target.percentageLabelRelativePoint,
        _FireUI.savedVariables.target.percentageLabelOffsetX,
        _FireUI.savedVariables.target.percentageLabelOffsetY
    )
    _FireUI.frames.target.percentageLabel = self.percentageLabel

    self.currentLabel = WINDOW_MANAGER:CreateControl( '_FireUI.target.currentLabel', self.topLevelWindow, CT_LABEL )
    self.currentLabel:SetColor( 1, 1, 1, 1 )
    self.currentLabel:SetFont( _FireUI:font( nil, 12 ) )
    self.currentLabel:SetAnchor(
        _FireUI.savedVariables.target.currentLabelPoint,
        _FireUI.savedVariables.target.currentLabelRelativeTo or self.topLevelWindow,
        _FireUI.savedVariables.target.currentLabelRelativePoint,
        _FireUI.savedVariables.target.currentLabelOffsetX,
        _FireUI.savedVariables.target.currentLabelOffsetY
    )
    _FireUI.frames.target.currentLabel = self.currentLabel

    self.nameLabel = WINDOW_MANAGER:CreateControl( '_FireUI.target.nameLabel', self.topLevelWindow, CT_LABEL )
    self.nameLabel:SetColor( 1, 1, 1, 1 )
    self.nameLabel:SetFont( _FireUI:font( nil, 12 ) )
    self.nameLabel:SetAnchor(
        _FireUI.savedVariables.target.nameLabelPoint,
        _FireUI.savedVariables.target.nameLabelRelativeTo or self.topLevelWindow,
        _FireUI.savedVariables.target.nameLabelRelativePoint,
        _FireUI.savedVariables.target.nameLabelOffsetX,
        _FireUI.savedVariables.target.nameLabelOffsetY
    )
    _FireUI.frames.target.nameLabel = self.nameLabel

    self.icon = WINDOW_MANAGER:CreateControl( '_FireUI.target.icon', self.topLevelWindow, CT_TEXTURE )
    self.icon:SetColor( 1, 1, 1, 1 )
    self.icon:SetDimensions( 24, 24 )
    self.icon:SetHidden( false )
    self.icon:SetAnchor(
        _FireUI.savedVariables.target.iconPoint,
        _FireUI.savedVariables.target.iconRelativeTo or self.topLevelWindow,
        _FireUI.savedVariables.target.iconRelativePoint,
        _FireUI.savedVariables.target.iconOffsetX,
        _FireUI.savedVariables.target.iconOffsetY
    )
    _FireUI.frames.target.icon = self.icon

    self.levelLabel = WINDOW_MANAGER:CreateControl( '_FireUI.target.levelLabel', self.topLevelWindow, CT_LABEL )
    self.levelLabel:SetColor( 1, 1, 1, 1 )
    self.levelLabel:SetFont( _FireUI:font( nil, 12 ) )
    self.levelLabel:SetAnchor(
        _FireUI.savedVariables.target.levelLabelPoint,
        _FireUI.savedVariables.target.levelLabelRelativeTo or self.topLevelWindow,
        _FireUI.savedVariables.target.levelLabelRelativePoint,
        _FireUI.savedVariables.target.levelLabelOffsetX,
        _FireUI.savedVariables.target.levelLabelOffsetY
    )
    _FireUI.frames.target.levelLabel = self.levelLabel

    self.topLevelWindow:SetHandler( 'OnMoveStop', function()
        self:updateLocation()
    end )

end

function _FireUI.target:updateLocation()

    local offsetX = _FireUI.frames.target.topLevelWindow:GetLeft()
    local offsetY = _FireUI.frames.target.topLevelWindow:GetTop()

    _FireUI.savedVariables.target.offset = { offsetX, offsetY }

end

function _FireUI.target:updateControls( powerValue )

    self.level                      = GetUnitLevel( 'reticleover' )
    self.veteranRank                = GetUnitVeteranRank( 'reticleover' )
    self.alliance                   = GetUnitAlliance( 'reticleover' )
    self.name                       = GetUnitName( 'reticleover' )
    self.class                      = GetUnitClass( 'reticleover' )
    self.race                       = GetUnitRace( 'reticleover' )
    self.health                     = {}
    self.health.current,
    self.health.maximum,
    self.health.effectiveMaximum    = GetUnitPower( 'reticleover', POWERTYPE_HEALTH )
    self.health.percentage          = _FireUI:getPercentage( self.health.current, self.health.effectiveMaximum )
    self.difficulty                 = GetUnitDifficulty( 'reticleover' )

    ZO_TargetUnitFramereticleover:SetHidden( true )

    local ignore = false

    if ( self.name == '' or self.name == nil ) then ignore = true end
    if ( self.level == 1 ) then
        if ( self:isCritter( self.name ) ) then ignore = true end
    end
    if ( _FireUI.savedVariables.target.active == false ) then ignore = true end

    -- Determine whether or not to display the target frame
    self.topLevelWindow:SetAlpha( ( ignore ) and 0 or 1 )

    -- Since we are not displaying the frame, we should stop this function from doing any more work
    if ( ignore ) then return end

    -- Set up target current health
    self.currentLabel:SetText( self.health.current .. "/" .. self.health.effectiveMaximum )

    -- Set up target health percentage
    self.percentageLabel:SetText( self.health.percentage .. "%" )

    -- Set up target name
    self.nameLabel:SetText( self.name )

    -- Set up target icon
    local difficultyIcons = {
        [0] = _FireUI.target:getClassIcon( self.class ),
        [2] = "/esoui/art/guild/guild_rankicon_recruit.dds",
        [3] = "/esoui/art/guild/guild_rankicon_member.dds",
        [4] = "/esoui/art/guild/guild_rankicon_officer.dds",
        [5] = "/esoui/art/guild/guild_rankicon_leader.dds"
    }

    self.icon:SetTexture( difficultyIcons[ self.difficulty ] )

    if ( ( self.class == nil or self.class == '' ) and ( self.difficulty < 2 ) ) then self.icon:SetHidden( true ) else self.icon:SetHidden( false ) end

    -- Set up level / veteran rank
    local level = ( self.veteranRank ) and 'VR' .. self.veteranRank or 'Lv' .. self.level

    local level = ( self.race ~= '' ) and level .. ' ' .. self.race or level

    self.levelLabel:SetText( level )

    -- Update the bar

    local duration = _FireUI.savedVariables.target.animation.duration
    local mode = _FireUI.savedVariables.target.animation.mode
    local width
    local height

    if ( self.anim ~= nil ) then self.anim:Stop() end

    if ( mode == 'Right to Left' or mode == 'Left to Right' or mode == 'Horizontal Centered' ) then
        width = _FireUI.savedVariables.target.dimensions[ 1 ] * ( self.health.percentage / 100 )
        height = _FireUI.savedVariables.target.dimensions[ 2 ]
    elseif ( mode == 'Top to Bottom' or mode == 'Bottom to Top' or mode == 'Vertical Centered' ) then
        width = _FireUI.savedVariables.target.dimensions[ 1 ]
        height = _FireUI.savedVariables.target.dimensions[ 2 ] * ( self.health.percentage / 100 )
    elseif ( mode == 'Radial' ) then
        width = _FireUI.savedVariables.target.dimensions[ 1 ] * ( self.health.percentage / 100 )
        height = _FireUI.savedVariables.target.dimensions[ 2 ] * ( self.health.percentage / 100 )
    end

    if ( powerValue ) then

        local bar = ( powerValue > self.health.current ) and self.animatedBar or self.bar
        local animatedBar = ( powerValue > self.health.current ) and self.bar or self.animatedBar

        self.anim = _FireUI.libAnimation:New( animatedBar )

        bar:SetWidth( width )
        bar:SetHeight( height )

        self.anim:ResizeTo( width, height, duration )
        self.anim:Play()

    else

        self.bar:SetWidth( width )
        self.bar:SetHeight( height )
        self.animatedBar:SetWidth( width )
        self.animatedBar:SetHeight( height )

    end

end

function _FireUI.target:getClassIcon( class )

    return "/esoui/art/contacts/social_classicon_" .. class .. ".dds"

end

function _FireUI.target:isCritter( name )

    local critters = {
        "Butterfly",
        "Lizard",
        "Rat",
        "Snake",
        "Pony Guar",
        "Frog",
        "Squirrel",
        "Rabbit",
        "Deer",
        "Cat",
        "Pig",
        "Sheep",
        "Antelope",
        "Wasp",
        "Monkey",
        "Fleshflies",
        "Centipede",
        "Chicken",
        "Torchbug",
        "Spider",
        "Scorpion",
        "Goat",
        "Scrib",
        "Scuttler",
        "Horse",
    }

    for i = 1, #critters do
        if ( critters[i] == name ) then return true end
    end

    return false

end