TimerStart( CreateTimer( ), 0.0, false, function( )
    if BlzLoadTOCFile( "UI\\FrameDef\\FrameDef.toc" ) then
    end

    Scoreboard.initialize( 4 )
end )
