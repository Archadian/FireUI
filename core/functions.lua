
function _FireUI:toggleVisibility( cursorIsVisible )

    if ( not self.initialized ) then return end

    for i = 1, #self.topLevelWindows do
        self.topLevelWindows[ i ]:SetHidden( cursorIsVisible )
    end

end

function _FireUI:font( size )
    return "FireUI/fonts/montserrat.ttf|" .. ( size or 14 ) .. "|soft-shadow-thin"
end

function _FireUI:getPercentage( a, b )
    
    return math.floor( ( a / b ) * 100 )

end