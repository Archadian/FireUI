_FireUI.menu = {}

function _FireUI.menu:initialize()

    -- This is an alternative to a bunch of if else statements.
    self.animationStyleAnchors = {
        ['Left to Right'] = { TOPRIGHT, TOPRIGHT },
        ['Right to Left'] = { TOPLEFT, TOPLEFT },
        ['Horizontal Centered'] = { CENTER, CENTER },
        ['Top to Bottom'] = { TOPLEFT, TOPLEFT },
        ['Bottom to Top'] = { BOTTOMLEFT, BOTTOMLEFT },
        ['Vertical Centered'] = { CENTER, CENTER },
        ['Radial'] = { CENTER, CENTER }
    }

    -- Is the UI currently locked?
    self.locked = true

    -- Create the LAM2 Panel
    local panelData = {
        type = 'panel',
        name = "FireUI",
    }

    -- Etc.
    local optionsData = {
        [1] = {
            type = 'button',
            name = "Unlock",
            tooltip = "Unlocks or locks the user interface frames.",
            func = function( control ) self:toggleLock( control ) end,
            width = "half",
        },
        [2] = {
            type = 'button',
            name = "Reset",
            tooltip = "Resets to FireUI default settings.",
            func = function() self:resetToDefaults() end,
            width = "half",
            warning = "This will reload your user interface",
        },
        [3] = {
            type = 'submenu',
            name = "XP/VP/AP Ticker",
            tooltip = "Options for the XP/VP/AP Ticker.",
            controls = {
                {
                    type = 'header',
                    name = "XP Ticker"
                },
                {
                    type = "checkbox",
                    name = "Enabled",
                    tooltip = "Whether the experience gained is shown.",
                    getFunc = function() return _FireUI.savedVariables.queue.activeContexts.xp end,
                    setFunc = function() _FireUI.savedVariables.queue.activeContexts.xp = not _FireUI.savedVariables.queue.activeContexts.xp end,
                },
                {
                    type = 'header',
                    name = "VP Ticker"
                },
                {
                    type = "checkbox",
                    name = "Enabled",
                    tooltip = "Whether the veteran points gained is shown.",
                    getFunc = function() return _FireUI.savedVariables.queue.activeContexts.vp end,
                    setFunc = function() _FireUI.savedVariables.queue.activeContexts.vp = not _FireUI.savedVariables.queue.activeContexts.vp end,
                },
                {
                    type = 'header',
                    name = "AP Ticker"
                },
                {
                    type = "checkbox",
                    name = "Enabled",
                    tooltip = "Whether the alliance points gained is shown.",
                    getFunc = function() return _FireUI.savedVariables.queue.activeContexts.ap end,
                    setFunc = function() _FireUI.savedVariables.queue.activeContexts.ap = not _FireUI.savedVariables.queue.activeContexts.ap end,
                },
                {
                    type = 'header',
                    name = "Animation"
                },
                {
                    type = 'slider',
                    name = "Font Size",
                    tooltip = "Size of the text.",
                    min = 8,
                    max = 100,
                    step = 2,
                    getFunc = function() return _FireUI.savedVariables.points.font.size end,
                    setFunc = function( value ) _FireUI.savedVariables.points.font.size = value end
                },
                {
                    type = 'slider',
                    name = "Speed",
                    tooltip = "Speed at which the text travels. (pixels per second)",
                    min = 0,
                    max = 100,
                    step = 1,
                    getFunc = function() return _FireUI.savedVariables.points.animation.speed end,
                    setFunc = function( value ) _FireUI.savedVariables.points.animation.speed = value end,
                },
                {
                    type = 'slider',
                    name = "Duration",
                    tooltip = "Duration of the animation.",
                    min = 0,
                    max = 100,
                    step = 1,
                    getFunc = function() return _FireUI.savedVariables.points.animation.duration / 1000 end,
                    setFunc = function( value ) _FireUI.savedVariables.points.animation.duration = 1000 * value end
                },
                {
                    type = 'dropdown',
                    name = "Direction",
                    tooltip = "Direction in which the text travels.",
                    choices = { 'Up', 'Down', 'Left', 'Right' },
                    getFunc = function() return _FireUI.savedVariables.points.animation.direction end,
                    setFunc = function( value ) _FireUI.savedVariables.points.animation.direction = value end
                },
            },
        },
        [4] = {
            type = 'submenu',
            name = "Resource Bars",
            tooltip = "Options for the HP/MP/SP Bars.",
            controls = {
            },
        },
        [5] = {
            type = 'submenu',
            name = "Target Frame",
            tooltip = "Options for the target frame.",
            controls = {
                {
                    type = 'checkbox',
                    name = "Enabled",
                    getFunc = function() return _FireUI.savedVariables.target.active end,
                    setFunc = function() _FireUI.savedVariables.target.active = not _FireUI.savedVariables.target.active end,
                },
                {
                    type = 'slider',
                    name = "Width",
                    min = 0,
                    max = 2560,
                    step = 4,
                    getFunc = function() return _FireUI.savedVariables.target.dimensions[ 1 ] end,
                    setFunc = function( value ) self:adjustTargetBarSize( value ) end,
                },
                {
                    type = 'slider',
                    name = "Height",
                    min = 0,
                    max = 2560,
                    step = 4,
                    getFunc = function() return _FireUI.savedVariables.target.dimensions[ 2 ] end,
                    setFunc = function( value ) self:adjustTargetBarSize( nil, value ) end,
                },
                {
                    type = "colorpicker",
                    name = "Colour",
                    tooltip = "The colour of the target bar.",
                    getFunc = function() return unpack( _FireUI.savedVariables.target.color ) end,
                    setFunc = function( r, g, b, a ) self:adjustTargetBarColor( r, g, b, a ) end,
                },
                {
                    type = "colorpicker",
                    name = "Highlight Colour",
                    tooltip = "The highlight colour of the target bar.",
                    getFunc = function() return unpack( _FireUI.savedVariables.target.color2 ) end,
                    setFunc = function( r, g, b, a ) self:adjustTargetBarColor( r, g, b, a, true ) end,
                },
                {
                    type = 'dropdown',
                    name = "Animation Style",
                    tooltip = "Direction in which the text travels.",
                    choices = { 'Left to Right', 'Right to Left', 'Horizontal Centered', 'Top to Bottom', 'Bottom to Top', 'Vertical Centered', 'Radial' },
                    getFunc = function() return _FireUI.savedVariables.target.animation.mode end,
                    setFunc = function( value ) self:adjustTargetBarAnimation( resource, value ) end,
                },
                {
                    type = 'slider',
                    name = "Duration",
                    min = 1,
                    max = 20,
                    step = 1,
                    getFunc = function() return _FireUI.savedVariables.target.animation.duration / 1000 end,
                    setFunc = function( value ) _FireUI.savedVariables.target.animation.duration = value * 1000 end,
                },
                {
                    type = 'slider',
                    name = 'Percentage Label Offset - Horizontal',
                    min = -100,
                    max = 100,
                    step = 2,
                    getFunc = function() return _FireUI.savedVariables.target.percentageLabelOffsetX end,
                    setFunc = function( value ) self:adjustControlOffset( _FireUI.target.percentageLabel, _FireUI.savedVariables.target.percentageLabelOffsetX, value, nil ) end
                },
                {
                    type = 'slider',
                    name = 'Percentage Label Offset - Vertical',
                    min = -100,
                    max = 100,
                    step = 2,
                    getFunc = function() return _FireUI.savedVariables.target.percentageLabelOffsetY end,
                    setFunc = function( value ) self:adjustControlOffset( _FireUI.target.percentageLabel, _FireUI.savedVariables.target.percentageLabelOffsetX, nil, value ) end
                },
                {
                    type = 'slider',
                    name = 'Current Label Offset - Horizontal',
                    min = -100,
                    max = 100,
                    step = 2,
                    getFunc = function() return _FireUI.savedVariables.target.currentLabelOffsetX end,
                    setFunc = function( value ) self:adjustControlOffset( _FireUI.target.currentLabel, _FireUI.savedVariables.target.currentLabelOffsetX, value, nil ) end
                },
                {
                    type = 'slider',
                    name = 'Current Label Offset - Vertical',
                    min = -100,
                    max = 100,
                    step = 2,
                    getFunc = function() return _FireUI.savedVariables.target.currentLabelOffsetY end,
                    setFunc = function( value ) self:adjustControlOffset( _FireUI.target.currentLabel, _FireUI.savedVariables.target.currentLabelOffsetY, nil, value ) end
                },
                {
                    type = 'slider',
                    name = 'Name Offset - Horizontal',
                    tooltip = "Horizontal offset of the name label",
                    min = -200,
                    max = 200,
                    step = 2,
                    getFunc = function() return _FireUI.savedVariables.target.nameLabelOffsetX end,
                    setFunc = function( value ) self:adjustControlOffset( _FireUI.target.nameLabel, _FireUI.savedVariables.target.nameLabelOffsetX, value, nil ) end
                },
                {
                    type = 'slider',
                    name = 'Name Offset - Vertical',
                    tooltip = "Vertical offset of the name label",
                    min = -200,
                    max = 200,
                    step = 2,
                    getFunc = function() return _FireUI.savedVariables.target.nameLabelOffsetY end,
                    setFunc = function( value ) self:adjustControlOffset( _FireUI.target.nameLabel, _FireUI.savedVariables.target.nameLabelOffsetY, nil, value ) end
                },
                {
                    type = 'slider',
                    name = 'Level Offset - Horizontal',
                    tooltip = "Horizontal offset of the name label",
                    min = -200,
                    max = 200,
                    step = 2,
                    getFunc = function() return _FireUI.savedVariables.target.levelLabelOffsetX end,
                    setFunc = function( value ) self:adjustControlOffset( _FireUI.target.levelLabel, _FireUI.savedVariables.target.levelLabelOffsetX, value, nil ) end
                },
                {
                    type = 'slider',
                    name = 'Level Offset - Vertical',
                    tooltip = "Vertical offset of the name label",
                    min = -200,
                    max = 200,
                    step = 2,
                    getFunc = function() return _FireUI.savedVariables.target.levelLabelOffsetY end,
                    setFunc = function( value ) self:adjustControlOffset( _FireUI.target.levelLabel, _FireUI.savedVariables.target.levelLabelOffsetY, nil, value ) end
                },
                {
                    type = 'slider',
                    name = 'Icon Offset - Horizontal',
                    tooltip = "Horizontal offset of the name label",
                    min = -200,
                    max = 200,
                    step = 2,
                    getFunc = function() return _FireUI.savedVariables.target.iconOffsetX end,
                    setFunc = function( value ) self:adjustControlOffset( _FireUI.target.icon, _FireUI.savedVariables.target.iconOffsetX, value, nil ) end
                },
                {
                    type = 'slider',
                    name = 'Icon Offset - Vertical',
                    tooltip = "Vertical offset of the name label",
                    min = -200,
                    max = 200,
                    step = 2,
                    getFunc = function() return _FireUI.savedVariables.target.iconOffsetY end,
                    setFunc = function( value ) self:adjustControlOffset( _FireUI.target.icon, _FireUI.savedVariables.target.iconOffsetY, nil, value ) end
                },
            }
        }
    }

    local tmp = { 'health', 'magicka', 'stamina' }

    for i = 1, #tmp do
        local resource = tmp[ i ]
        local theNext = #optionsData[4].controls + 1 or 1
        optionsData[4].controls[ theNext ] = {
            type = 'header',
            name = resource,
        }
        optionsData[4].controls[ theNext + 1 ] = {
            type = 'checkbox',
            name = "Enabled",
            getFunc = function() return _FireUI.savedVariables.resources[ resource ].active end,
            setFunc = function() self:toggleBar( resource ) end,
        }
        optionsData[4].controls[ theNext + 2 ] = {
            type = 'slider',
            name = "Width",
            min = 0,
            max = 2560,
            step = 4,
            getFunc = function() return _FireUI.savedVariables.resources[ resource ].dimensions[ 1 ] end,
            setFunc = function( value ) self:adjustBarSize( resource, value ) end,
        }
        optionsData[4].controls[ theNext + 3 ] = {
            type = 'slider',
            name = "Height",
            min = 0,
            max = 2560,
            step = 4,
            getFunc = function() return _FireUI.savedVariables.resources[ resource ].dimensions[ 2 ] end,
            setFunc = function( value ) self:adjustBarSize( resource, nil, value ) end,
        }
        optionsData[4].controls[ theNext + 4 ] = {
            type = "colorpicker",
            name = "Colour",
            tooltip = "The colour of the " .. resource .. " bar.",
            getFunc = function() return unpack( _FireUI.savedVariables.resources[ resource ].color ) end,
            setFunc = function( r, g, b, a ) self:adjustBarColor( resource, r, g, b, a ) end,
        }
        optionsData[4].controls[ theNext + 5 ] = {
            type = "colorpicker",
            name = "Highlight Colour",
            tooltip = "The highlight colour of the " .. resource .. " bar.",
            getFunc = function() return unpack( _FireUI.savedVariables.resources[ resource ].color2 ) end,
            setFunc = function( r, g, b, a ) self:adjustBarColor( resource, r, g, b, a, true ) end,
        }
        optionsData[4].controls[ theNext + 6 ] = {
            type = 'dropdown',
            name = "Animation Style",
            tooltip = "Direction in which the text travels.",
            choices = { 'Left to Right', 'Right to Left', 'Horizontal Centered', 'Top to Bottom', 'Bottom to Top', 'Vertical Centered', 'Radial' },
            getFunc = function() return _FireUI.savedVariables.resources[ resource ].animation.mode end,
            setFunc = function( value ) self:adjustBarAnimation( resource, value ) end,
        }
        optionsData[4].controls[ theNext + 7 ] = {
            type = 'slider',
            name = "Duration",
            min = 1,
            max = 20,
            step = 1,
            getFunc = function() return _FireUI.savedVariables.resources[ resource ].animation.duration / 1000 end,
            setFunc = function( value ) _FireUI.savedVariables.resources[ resource ].animation.duration = value * 1000 end,
        }
        optionsData[4].controls[ theNext + 8 ] = {
            type = 'slider',
            name = 'Percentage Label Offset - Horizontal',
            min = -100,
            max = 100,
            step = 2,
            getFunc = function() return _FireUI.savedVariables.resources[ resource ].percentageLabelOffsetX end,
            setFunc = function( value ) self:adjustLabelOffset( 'percentage', 'X', resource, value ) end
        }
        optionsData[4].controls[ theNext + 9 ] = {
            type = 'slider',
            name = 'Percentage Label Offset - Vertical',
            min = -100,
            max = 100,
            step = 2,
            getFunc = function() return _FireUI.savedVariables.resources[ resource ].percentageLabelOffsetY end,
            setFunc = function( value ) self:adjustLabelOffset( 'percentage', 'Y', resource, value ) end
        }
        optionsData[4].controls[ theNext + 10 ] = {
            type = 'slider',
            name = 'Current Label Offset - Horizontal',
            min = -100,
            max = 100,
            step = 2,
            getFunc = function() return _FireUI.savedVariables.resources[ resource ].currentLabelOffsetX end,
            setFunc = function( value ) self:adjustLabelOffset( 'current', 'X', resource, value ) end
        }
        optionsData[4].controls[ theNext + 11 ] = {
            type = 'slider',
            name = 'Current Label Offset - Vertical',
            min = -100,
            max = 100,
            step = 2,
            getFunc = function() return _FireUI.savedVariables.resources[ resource ].currentLabelOffsetY end,
            setFunc = function( value ) self:adjustLabelOffset( 'current', 'Y', resource, value ) end
        }

    end

    local LAM2 = LibStub( 'LibAddonMenu-2.0' )
    LAM2:RegisterAddonPanel( "FireUIOptions", panelData )
    LAM2:RegisterOptionControls( "FireUIOptions", optionsData )
    
end

--- This function toggles the frames to a locked or unlocked state.
-- @param control This is the button used to do the toggling.
function _FireUI.menu:toggleLock( control )

    -- Set the new lock state on the control.
    if ( self.locked ) then
        control:SetText( 'Lock' )
    else
        control:SetText( 'Unlock' )
    end

    -- Select all the frames, make them movable, highlight them and name them for easy reference.
    for k, v in pairs( _FireUI.frames ) do

        -- Unlock the top level windows.
        v.topLevelWindow:SetMovable( self.locked )

        -- Set the backdrops to visible.
        v.backdrop:SetHidden( not self.locked )

        -- Set the labels to visible.
        v.label:SetHidden( not self.locked )

    end

    local resources = { 'health', 'magicka', 'stamina' }

    for i = 1, #resources do

        _FireUI.resources[ resources[ i ] ].topLevelWindow:SetMovable( self.locked )
        _FireUI.resources[ resources[ i ] ].backdrop:SetHidden( not self.locked )
        _FireUI.resources[ resources[ i ] ].label:SetHidden( not self.locked )

    end

    _FireUI.target.topLevelWindow:SetMovable( self.locked )
    _FireUI.target.topLevelWindow:SetAlpha( ( self.locked ) and 1 or 0 )
    _FireUI.target.backdrop:SetHidden( not self.locked )
    _FireUI.target.label:SetHidden( not self.locked )

    -- Set the lock state to the opposite of what it was before the control was activated.
    self.locked = not self.locked

end

--- This function resets all the settings to defaults and reloads the UI.
function _FireUI.menu:resetToDefaults()

    -- Get each setting table and replace the current savedVariables version with the original.
    for k, v in pairs( _FireUI.settings ) do

        _FireUI.savedVariables[ k ] = v

    end

    ReloadUI()

end

--- This function adjusts the size of resource bars.
-- @param resource This is the resource bar to resize.
-- @param width This is the new width.
-- @param height This is the new height.
function _FireUI.menu:adjustBarSize( resource, width, height )

    -- Since the slider only works for one dimension at a time, fill the other with the current dimension.
    local dimensions = { width or _FireUI.savedVariables.resources[ resource ].dimensions[ 1 ], height or _FireUI.savedVariables.resources[ resource ].dimensions[ 2 ] }

    -- Set the dimensions in the settings.
    _FireUI.savedVariables.resources[ resource ].dimensions = dimensions

    -- Set the dimensions on the top level window.
    _FireUI.frames.resources[ resource ].topLevelWindow:SetDimensions( dimensions[ 1 ], dimensions[ 2 ] )

    -- Set the dimensions on the backdrop.
    _FireUI.frames.resources[ resource ].backdrop:SetDimensions( dimensions[ 1 ], dimensions[ 2 ] )

    -- Set the dimensinos on the bar itself.
    _FireUI.frames.resources[ resource ].bar:SetDimensions( dimensions[ 1 ], dimensions[ 2 ] )
    _FireUI.frames.resources[ resource ].animatedBar:SetDimensions( dimensions[ 1 ], dimensions[ 2 ] )

    local width, height = _FireUI.frames.resources[ resource ].bar:GetDimensions()

    _,
    _FireUI.savedVariables.resources[ resource ].percentageLabelPoint,
    _FireUI.savedVariables.resources[ resource ].percentageLabelRelativeTo,
    _FireUI.savedVariables.resources[ resource ].percentageLabelRelativePoint,
    _FireUI.savedVariables.resources[ resource ].percentageLabelOffsetX,
    _FireUI.savedVariables.resources[ resource ].percentageLabelOffsetY = _FireUI.frames.resources[ resource ].percentageLabel:GetAnchor()

    _,
    _FireUI.savedVariables.resources[ resource ].currentLabelPoint,
    _FireUI.savedVariables.resources[ resource ].currentLabelRelativeTo,
    _FireUI.savedVariables.resources[ resource ].currentLabelRelativePoint,
    _FireUI.savedVariables.resources[ resource ].currentLabelOffsetX,
    _FireUI.savedVariables.resources[ resource ].currentLabelOffsetY = _FireUI.frames.resources[ resource ].currentLabel:GetAnchor()

    -- We need to make sure that the labels are still visible and not all screwed up.
    if ( height > width ) then

        _FireUI.frames.resources[ resource ].percentageLabel:ClearAnchors()
        _FireUI.frames.resources[ resource ].percentageLabel:SetAnchor(
            TOPLEFT,
            _FireUI.savedVariables.resources[ resource ].percentageLabelRelativeTo,
            TOPRIGHT,
            _FireUI.savedVariables.resources[ resource ].percentageLabelOffsetX,
            _FireUI.savedVariables.resources[ resource ].percentageLabelOffsetY
        )
        
        _FireUI.frames.resources[ resource ].currentLabel:ClearAnchors()
        _FireUI.frames.resources[ resource ].currentLabel:SetAnchor(
            BOTTOMLEFT,
            _FireUI.savedVariables.resources[ resource ].currentLabelRelativeTo,
            BOTTOMRIGHT,
            _FireUI.savedVariables.resources[ resource ].currentLabelOffsetX,
            _FireUI.savedVariables.resources[ resource ].currentLabelOffsetY
        )

    else

        _FireUI.frames.resources[ resource ].percentageLabel:ClearAnchors()
        _FireUI.frames.resources[ resource ].percentageLabel:SetAnchor(
            LEFT,
            _FireUI.savedVariables.resources[ resource ].percentageLabelRelativeTo,
            LEFT,
            _FireUI.savedVariables.resources[ resource ].percentageLabelOffsetX,
            _FireUI.savedVariables.resources[ resource ].percentageLabelOffsetY
        )
        
        _FireUI.frames.resources[ resource ].currentLabel:ClearAnchors()
        _FireUI.frames.resources[ resource ].currentLabel:SetAnchor(
            RIGHT,
            _FireUI.savedVariables.resources[ resource ].currentLabelRelativeTo,
            RIGHT,
            _FireUI.savedVariables.resources[ resource ].currentLabelOffsetX,
            _FireUI.savedVariables.resources[ resource ].currentLabelOffsetY
        )

    end

end

--- This function toggles a resource bar on or off.
-- @param resource This is the resource bar to toggle.
function _FireUI.menu:toggleBar( resource )

    -- Get the current state of the bar.
    local active = _FireUI.savedVariables.resources[ resource ].active

    -- Change the state in the settings.
    _FireUI.savedVariables.resources[ resource ].active = not active

    -- Hide or show the bar depending on the active state.
    _FireUI.frames.resources[ resource ].topLevelWindow:SetHidden( active )

    ZO_PlayerAttributeMagicka:SetHidden( _FireUI.savedVariables.resources.magicka.active )
    ZO_PlayerAttributeHealth:SetHidden( _FireUI.savedVariables.resources.health.active )
    ZO_PlayerAttributeStamina:SetHidden( _FireUI.savedVariables.resources.stamina.active )
    ZO_PlayerAttributeMountStamina:SetHidden( _FireUI.savedVariables.resources.mountStamina.active )

end

--- This function changes the colour of a resource bar.
-- @param resource This is the resource bar to change.
-- @param r Red     ( 0.00-1.00 )
-- @param g Green   ( 0.00-1.00 )
-- @param b Blue    ( 0.00-1.00 )
-- @param a Aplha   ( 0.00-1.00 )
-- @param second Boolean to determine whether setting main bar colour or secondary bar.
function _FireUI.menu:adjustBarColor( resource, r, g, b, a, second )
    
    -- Determine the context.
    local setting = ( second ) and { 'color2', 'animatedBar' } or { 'color', 'bar' }

    -- Set the colour in settings.
    _FireUI.savedVariables.resources[ resource ][ setting[ 1 ] ] = { r, g, b, a }

    -- Set the colour on the bar.
    _FireUI.frames.resources[ resource ][ setting[ 2 ] ]:SetColor( r, g, b, a )

end

--- This function changes the anchor of the bar to suit the animation choice
-- @param resource The resourcce bar to change.
-- @param value The new value, selected from the dropdown.
function _FireUI.menu:adjustBarAnimation( resource, value )

    -- Set the option in savedVariables.
    _FireUI.savedVariables.resources[ resource ].animation.mode = value;

    -- Get the anchor of the bar being changed, so that we can override the points.
    local _, point, relativeTo, relativePoint, offsetX, offsetY = _FireUI.frames.resources[ resource ].bar:GetAnchor()

    -- Grab the animatino style anchors object for local use.
    local obj = self.animationStyleAnchors

    -- Clear the current anchors as we cannot have more than 2 sets of anchors set on a control.
    _FireUI.frames.resources[ resource ].bar:ClearAnchors()
    _FireUI.frames.resources[ resource ].animatedBar:ClearAnchors()

    -- Set the anchors for the bars.
    _FireUI.frames.resources[ resource ].bar:SetAnchor( obj[ value ][1], relativeTo, obj[ value ][2], offsetX, offsetY )
    _FireUI.frames.resources[ resource ].animatedBar:SetAnchor( obj[ value ][1], relativeTo, obj[ value ][2], offsetX, offsetY )

end

function _FireUI.menu:adjustLabelOffset( label, axis, resource, value )

    -- Set the value in savedVariables.
    _FireUI.savedVariables.resources[ resource ][ label .. 'LabelOffset' .. axis ] = value

    -- Set the local variable for easy use.
    local label = _FireUI.frames.resources[ resource ][ label .. 'Label' ]

    -- Get the current anchor, so we can adjust.
    local _, point, relativeTo, relativePoint, offsetX, offsetY = label:GetAnchor()

    -- Clear the anchors as we ccannot have more than 2 ssets of anchors on a control.
    label:ClearAnchors()

    -- Set the old anchors with the new offset.
    label:SetAnchor( point, relativeTo, relativePoint, ( axis == 'X' ) and value or offsetX, ( axis == 'Y' ) and value or offsetY )

end

-- Need to merge the target and resource bar functions...

function _FireUI.menu:adjustControlOffset( control, setting, offsetX, offsetY )

    local _, point, relativeTo, relativePoint, prevOffsetX, prevOffsetY = control:GetAnchor()

    control:SetAnchor( point, relativeTo, relativePoint, offsetX or prevOffsetX, offsetY or prevOffsetY )

    setting = { offsetX or prevOffsetX, offsetY or prevOffsetY }

end

function _FireUI.menu:adjustTargetBarSize( width, height )

    local width = width or _FireUI.savedVariables.target.dimensions[ 1 ]
    local height = height or _FireUI.savedVariables.target.dimensions[ 2 ]

    _FireUI.savedVariables.target.dimensions[ 1 ] = width
    _FireUI.savedVariables.target.dimensions[ 2 ] = height

    _FireUI.target.topLevelWindow:SetDimensions( width, height )
    _FireUI.target.backdrop:SetDimensions( width, height )
    _FireUI.target.label:SetDimensions( width, height )
    _FireUI.target.bar:SetDimensions( width, height )
    _FireUI.target.animatedBar:SetDimensions( width, height )

end