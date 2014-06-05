
function _FireUI:toggleVisibility( cursorIsVisible )

    if ( not self.initialized ) then return end

    for i = 1, #self.topLevelWindows do
        self.topLevelWindows[ i ]:SetHidden( cursorIsVisible )
    end

end

function _FireUI:font( face, size, shadow )
    return ( "FireUI/fonts/montserrat.ttf" or face ) .. "|" .. ( size or 14 ) .. "|" .. ( "soft-shadow-thin" or shadow )
end

function _FireUI:getPercentage( a, b )
    
    return math.floor( ( a / b ) * 100 )

end

function _FireUI:hex2rgba( hex )

    if ( type( hex ) ~= 'string' ) then return d( "Required type is string. Got " .. type( hex ) .. "." ) end

    local hex = string.gsub( hex, '#', '' )
    local r = tonumber( '0x' .. hex:sub( 1, 2 ) )
    local g = tonumber( '0x' .. hex:sub( 3, 4 ) )
    local b = tonumber( '0x' .. hex:sub( 5, 6 ) )
    local a = tonumber( '0x' .. hex:sub( 7, 8 ) ) or 1
    return r, g, b, a

end