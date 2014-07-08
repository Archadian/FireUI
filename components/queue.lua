_FireUI.queue = {}
_FireUI.queue.events = {}
_FireUI.queue.elements = {}
_FireUI.queue.next = {}
_FireUI.queue.lastTime = {}

--- Initialize the queues, set up the timer, etc
function _FireUI.queue:initialize()

    -- Set up the update function timer, so as not to run every frame
    self.clock = '_FireUI.queue.clock'
    EVENT_MANAGER:RegisterForUpdate( self.clock, 250, function( millisecondsRunning )
        self:update( millisecondsRunning )
    end )

    -- Set up the tables for the available contexts
    local contexts = _FireUI.config.queue.contexts

    for context, v in pairs( contexts ) do
        self.events[ context ] = {}
        self.elements[ context ] = {}
        self.next[ context ] = true
        self.lastTime[ context ] = 0
    end

    -- Copy the animation settings into config, for contextual use.
    for context, v in pairs( contexts ) do
        _FireUI.config.queue.contexts[ context ].animation = _FireUI.savedVariables[ context ].animation
    end

end

--- This function inserts events passed to it into a queue or fires it immediately depending on context
-- @param context The parameter which determines how this is displayed in the client. EG: 'AP', 'damageGiven', 'damageTaken'
-- @param value The amount, or other string value which should be displayed.
-- @param sourceName The name of the source of the event. On XP/VP/AP events this will always be empty, on damageGiven events, this will be player. On damageTaken events, this will be the name of the enemy which damaged the player.
-- @param sourceType This is the ESO value for whatever the source is. EG: COMBAT_UNIT_TYPE_PLAYER, COMBAT_UNIT_TYPE_OTHER
-- @param targetName Same as sourceName, but for the target.
-- @param targetType Same as sourceType, but for the target.
-- @param abilityName This is the name of the ability which spawned the event. In the case of experience updates, this will be empty.
function _FireUI.queue:insert( context, value, sourceName, sourceType, targetName, targetType, abilityName )
    
    -- Filter any event that shouldn't be here. It really shouldn't end up here in the first place. This is just in case.
    if ( not self:filter( context, value ) ) then return end

    -- Get config for this context
    local config = _FireUI.config.queue.contexts[ context ]

    -- Fire the event straight away or put it into a queue
    if ( config.queue ) then
        local event = {
            context       = context,
            value         = value,
            sourceName    = sourceName,
            sourceType    = sourceType,
            targetName    = targetName,
            targetType    = targetType,
            abilityName   = abilityName,
        }

        -- Insert the event into the end of the queue for it's context
        self.events[ context ][ #self.events[ context ] + 1 ] = event
    else
        -- Fire the event straight away. This may be used for XP/VP but not for AP, in the future.
        self:fire( event )
    end

end

--- This function filters out any events that make it into the queue insertion function. This is useful for creating a settings option to turn off certain events.
-- @param context The context of the event, this is checked against the settings to see if it's turned on.
-- @param value Passed to check specific types of points updates
function _FireUI.queue:filter( context, value )

    -- If the context is points, find out which type
    if ( context == 'points' ) then

        context = string.lower( string.sub( value, -2, -1 ) )

    end

    local enabled = false
    local contexts = _FireUI.savedVariables.queue.activeContexts

    for k, v in pairs( contexts ) do
        if ( k == context ) then
            enabled = v
            break
        end
    end

    return enabled

end

--- This function runs every .25 seconds and is used to start the events at the right time. Saves a lot of resources not using the update function in every frame.
function _FireUI.queue:update()

    -- local random = math.floor( math.random() * 100 + 1 )

    -- if ( random < 34 ) then
    --     self:insert( 'points', math.floor( math.random() * 400 + 1 ) .. 'XP', '', COMBAT_UNIT_TYPE_PLAYER, '', COMBAT_UNIT_TYPE_PLAYER, '' )
    -- elseif( random < 67 ) then
    --     self:insert( 'points', math.floor( math.random() * 400 + 1 ) .. 'VP', '', COMBAT_UNIT_TYPE_PLAYER, '', COMBAT_UNIT_TYPE_PLAYER, '' )
    -- else
    --     self:insert( 'points', math.floor( math.random() * 400 + 1 ) .. 'AP', '', COMBAT_UNIT_TYPE_PLAYER, '', COMBAT_UNIT_TYPE_PLAYER, '' )
    -- end

    -- local elements

    -- -- Go through the event queue for each context and fire the events. Afterward, remove it from the event queue.
    for context, v in pairs( self.events ) do

        -- Check that there are events to fire
        if ( #self.events[ context ] ~= 0 ) then

            -- Delay based on time which this function runs, speed of animation and font size
            local delay = ( 1000 / _FireUI.savedVariables[ context ].animation.speed ) * _FireUI.savedVariables[ context ].font.size

            -- If the correct amount of time has passed
            if ( GetGameTimeMilliseconds() > self.lastTime[ context ] + delay ) then 

                -- If there is space left in the elements list
                if ( #self.elements[ context ] < _FireUI.config.queue.contexts[ context ].maxElements ) then

                    -- We can continue
                    self.next[ context ] = true

                else

                    -- Loop through the elements list and find an expired element
                    for i = 1, #self.elements[ context ] do

                        if ( GetGameTimeMilliseconds() > self.elements[ context ][ i ].time + _FireUI.config.queue.contexts[ context ].animation.duration ) then

                            -- Set the element to unused, for the fire event to appropriate
                            self.elements[ context ][ i ].used = false

                            -- We can continue
                            self.next[ context ] = true

                        end

                    end

                end

            end

            -- We can fire an event.
            if ( self.next[ context ] ) then

                local event = self.events[ context ][ 1 ]

                -- Make sure to wait until we are allowed to fire another event
                self.next[ context ] = false

                -- Fire the event
                self:fire( event.context, event.value, event.sourceName, event.sourceType, event.targetName, event.targetType, event.abilityName )

                -- Remove the fired event from the queue
                table.remove( self.events[ context ], 1 )

                -- Set the time the last event fired.
                self.lastTime[ context ] = GetGameTimeMilliseconds()

            end

        end

    end

    -- do things.

end

--- This is the function which actually fires the event, after it's all been set up to do so.
-- @param context The parameter which determines how this is displayed in the client. EG: 'AP', 'damageGiven', 'damageTaken'
-- @param value The amount, or other string value which should be displayed.
-- @param sourceName The name of the source of the event. On XP/VP/AP events this will always be empty, on damageGiven events, this will be player. On damageTaken events, this will be the name of the enemy which damaged the player.
-- @param sourceType This is the ESO value for whatever the source is. EG: COMBAT_UNIT_TYPE_PLAYER, COMBAT_UNIT_TYPE_OTHER
-- @param targetName Same as sourceName, but for the target.
-- @param targetType Same as sourceType, but for the target.
-- @param abilityName This is the name of the ability which spawned the event. In the case of experience updates, this will be empty.
function _FireUI.queue:fire( context, value, sourceName, sourceType, targetName, targetType, abilityName )

    -- Get me an element to use. Or, create one.
    local element = self:getElement( context )

    local label = element.label
    local icon = element.icon
    local font = { _FireUI.savedVariables[ context ].font.face, _FireUI.savedVariables[ context ].font.size, _FireUI.savedVariables[ context ].font.shadow }

    local config = _FireUI.config.queue.contexts[ context ]

    -- Label settings
    local settings        = {}
    settings.offset       = config.label.offset
    settings.align        = config.label.align
    settings.relativeTo   = element.relativeTo
    settings.color        = self:getColor( context, value )

    label:ClearAnchors()
    label:SetAlpha( 1 )
    label:SetAnchor( settings.align[ 1 ], settings.relativeTo, settings.align[ 2 ], settings.offset[ 1 ], settings.offset[ 2 ] )
    label:SetColor( settings.color[ 1 ], settings.color[ 2 ], settings.color[ 3 ], settings.color[ 4 ] )
    label:SetText( value )
    label:SetFont( _FireUI:font( unpack( font ) ) )

    element.label = label
    element.icon = icon
    element.time = GetGameTimeMilliseconds()
    element.context = context

    self:animate( element )

end

--- This gets an element from the recycled list, or creates a new one.
-- @param context The context or pool from which this is gathered
function _FireUI.queue:getElement( context )   

    -- Locate the element pool for this context
    local elements = self.elements[ context ]
    local element = nil

    -- Get an unused element, set it to in use.
    for i = 1, #elements do
        if ( not elements[ i ].used ) then
            element = elements[ i ]
            break
        end
    end

    -- If the element is empty, it couldn't find a suitable one to use.
    if ( element == nil ) then

        element = {}
        element.label = WINDOW_MANAGER:CreateControl( string.format( '_FireUI.queue.%s.labels.%s', context, #elements + 1 ), _FireUI.frames[ context ].topLevelWindow, CT_LABEL )
        element.icon  = element.label:CreateControl( string.format( '_FireUI.queue.%s.icons.%s', context, #elements + 1 ), CT_TEXTURE )
        element.relativeTo = _FireUI.frames[ context ].topLevelWindow

        elements[ #elements + 1 ] = element

    end

    element.used = true

    return element

end

--- This function animates the element in some way.
-- @param element This is the element to animate.
function _FireUI.queue:animate( element )
    
    local context = element.context
    local label = element.label
    local icon = element.icon
    local time = element.time

    local elements = { label, icon }

    local anim

    local duration      = _FireUI.savedVariables[ context ].animation.duration
    local speed         = _FireUI.savedVariables[ context ].animation.speed
    local direction     = _FireUI.savedVariables[ context ].animation.direction
    local distanceX     = ( direction == 'Left' or direction == 'Right' ) and ( ( duration / 1000 ) * speed ) or 0
    local distanceY     = ( direction == 'Up' or direction == 'Down' ) and ( ( duration / 1000 ) * speed ) or 0
    local flip          = ( direction == 'Left' or direction == 'Up' )
    local toX           = ( flip ) and -distanceX or distanceX
    local toY           = ( flip ) and -distanceY or distanceY

    for i = 1, #elements do
        anim = _FireUI.libAnimation:New( elements[ i ] )
        anim:TranslateTo( toX, toY, duration )
        anim:AlphaTo( 0, duration )
        anim:Play()
    end

end

--- This function gets the colour used for the label.
-- @param context This is the context it's trying to get the colour for.
-- @param value This is included for the case of ap/vp/xp.
function _FireUI.queue:getColor( context, value )
    
    if ( context == 'points' ) then

        context = string.lower( string.sub( value, -2, -1 ) )

    end

    return _FireUI.savedVariables.queue.colors[ context ]

end