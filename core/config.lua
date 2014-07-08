-- FireUI
_FireUI = {}
_FireUI.name = 'FireUI'
_FireUI.libAnimation = LibStub( 'LibAnimation-1.0' )

-- Table to hold the TLW's, Backdrops and Labels for repositioning
_FireUI.frames = {
    points = {},
    resources = {
        health = {},
        magicka = {},
        stamina = {},
    },
    target = {},
}

-- List of components
_FireUI.components = {
    points      = true,
    resources   = true,
    queue       = true,
    menu        = true,
    target      = true,
    buffs       = false,
}

-- Config not changeable by player.
_FireUI.config = {}

-- Configuration for the queue
_FireUI.config.queue = {}

-- Available contexts for the queue
_FireUI.config.queue.contexts = {}

_FireUI.config.queue.contexts[ 'points' ] = {
    queue           = true,
    maxElements     = 20,
    label           = {
        align       = { BOTTOMLEFT, 0 },
        offset      = { 0, 0 },
        color       = { 1, 1, 1, 1 },
    },
    animation = {}
}

_FireUI.config.powerList = {
    [POWERTYPE_FINESSE]       = 'finesse',
    [POWERTYPE_HEALTH]        = 'health',
    [POWERTYPE_INVALID]       = 'invalid',
    [POWERTYPE_MAGICKA]       = 'magicka',
    [POWERTYPE_MOUNT_STAMINA] = 'mount_stamina',
    [POWERTYPE_STAMINA]       = 'stamina',
    [POWERTYPE_ULTIMATE]      = 'ultimate',
    [POWERTYPE_WEREWOLF]      = 'werewolf',
}

-- Settings used to populate savedVariables, changeable by player.
_FireUI.settings = {}

-- Settings for the resource bars.
_FireUI.settings.resources = {
    active          = true,
    anchor          = { TOPLEFT, TOPLEFT },
    offset          = { nil, nil },
    dimensions      = { 300, 50 },
    linked          = true,
}

_FireUI.settings.resources[ 'health' ] = {
    active          = true,
    anchor          = { TOPLEFT, TOPLEFT },
    color           = { .64, .17, .1, 1 },
    color2          = { 1, .4, .4, 1 },
    dimensions      = { 300, 24 },
    offset          = { nil, nil },
    animation       = {
        duration    = 1000,
        mode        = 'Horizontal Centered',
    },
    percentageLabelPoint = RIGHT,
    percentageLabelRelativePoint = RIGHT,
    percentageLabelOffsetX = 0,
    percentageLabelOffsetY = 0,
    currentLabelPoint = LEFT,
    currentLabelRelativePoint = LEFT,
    currentLabelOffsetX = 0,
    currentLabelOffsetY = 0,
}

_FireUI.settings.resources[ 'magicka' ] = {
    active          = true,
    anchor          = { TOPLEFT, TOPLEFT },
    color           = { 0, .39, .62, 1 },
    color2          = { .5, .75, 1, 1 },
    dimensions      = { 300, 16 },
    offset          = { nil, nil },
    animation       = {
        duration    = 1000,
        mode        = 'Horizontal Centered',
    },
    percentageLabelPoint = RIGHT,
    percentageLabelRelativePoint = RIGHT,
    percentageLabelOffsetX = 0,
    percentageLabelOffsetY = 0,
    currentLabelPoint = LEFT,
    currentLabelRelativePoint = LEFT,
    currentLabelOffsetX = 0,
    currentLabelOffsetY = 0,
}

_FireUI.settings.resources[ 'stamina' ] = {
    active          = true,
    anchor          = { TOPLEFT, TOPLEFT },
    color           = { .76, .6, .12, 1 },
    color2          = { .9, .78, .41, 1 },
    dimensions      = { 300, 16 },
    offset          = { nil, nil },
    animation       = {
        duration    = 1000,
        mode        = 'Horizontal Centered',
    },
    percentageLabelPoint = RIGHT,
    percentageLabelRelativePoint = RIGHT,
    percentageLabelOffsetX = 0,
    percentageLabelOffsetY = 0,
    currentLabelPoint = LEFT,
    currentLabelRelativePoint = LEFT,
    currentLabelOffsetX = 0,
    currentLabelOffsetY = 0,
}

_FireUI.settings.resources[ 'mountStamina' ] = {
    active          = true,
}

-- Settings for the XP/VP/AP points scroller
_FireUI.settings.points = {
    active          = true,
    anchor          = { CENTER, TOP },
    dimensions      = { 150, 20 },
    offset          = { 300, 300 },
    animation       = {
        duration    = 10000,
        direction   = 'Up',
        speed       = 20,
    },
    font            = {
        face        = 'Montserrat',
        size        = 18,
        shadow      = 'soft-shadow-thin',
    },
}

-- Settings for the queue
_FireUI.settings.queue = {}

-- Settings for the queue's active contexts
_FireUI.settings.queue.activeContexts = {
    xp              = true,
    vp              = true,
    ap              = true,
}

_FireUI.settings.queue.colors = {
    xp              = { 0, .7, .9, 1 },
    vp              = { .46, .85, .87, 1 },
    ap              = { .5, 1, .5, 1 },
}

-- Settings for the target frame
_FireUI.settings.target = {
    active          = true,
    anchor          = { TOPLEFT, TOPLEFT },
    color           = { .64, .17, .1, 1 },
    color2          = { 1, .4, .4, 1 },
    dimensions      = { 300, 18 },
    offset          = { nil, nil },
    animation       = {
        duration    = 1000,
        mode        = 'Horizontal Centered',
    },
    percentageLabelPoint = RIGHT,
    percentageLabelRelativePoint = RIGHT,
    percentageLabelOffsetX = 0,
    percentageLabelOffsetY = 0,
    currentLabelPoint = LEFT,
    currentLabelRelativePoint = LEFT,
    currentLabelOffsetX = 0,
    currentLabelOffsetY = 0,
    nameLabelPoint = TOPLEFT,
    nameLabelRelativePoint = TOPLEFT,
    nameLabelOffsetX = 24,
    nameLabelOffsetY = -16,
    levelLabelPoint = TOPRIGHT,
    levelLabelRelativePoint = TOPRIGHT,
    levelLabelOffsetX = 0,
    levelLabelOffsetY = -16,
    iconPoint = TOPLEFT,
    iconRelativePoint = TOPLEFT,
    iconOffsetX = 0,
    iconOffsetY = -24,
}