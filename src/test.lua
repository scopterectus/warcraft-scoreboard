do

    Scoreboard = {

        data = { },

        mainframe = nil,

        playerframe = nil,

        heroframe = nil,
        heroname = nil,

        combatframe = nil,

        resourcesframe = nil,

        update = function( )
        end,

        setValue = function( column, type, value, a, r, g, b )
            if DEBUG_MODE and ( column < 0 or column > bj_MAX_PLAYERS ) then
                print( "Scoreboard.initialize: Указано некорректное число игроков. Пожалуйста, введите число в диапазоне от 1 до 6." )
                return
            end

            -- P L A Y E R :

            if type == SCOREBOARD_PLAYER_NAME then
                Scoreboard.data[ "playername" .. column ] = value

                -- H E R O :

            elseif type == SCOREBOARD_HERO_NAME then
                Scoreboard.data[ "heroname" .. column ] = value

            elseif type == SCOREBOARD_HERO_STATUS then
                Scoreboard.data[ "herostatus" .. column ] = value

            elseif type == SCOREBOARD_HERO_LEVEL then
                Scoreboard.data[ "herolevel" .. column ] = value

            elseif type == SCOREBOARD_HERO_ABILITIES_WILLINGNESS then
                Scoreboard.data[ "heroabilitieswillingness" .. column ] = value

                -- C O M B A T :

            elseif type == SCOREBOARD_COMBAT_UNITS_KILLED then
                Scoreboard.data[ "combatunitskilled" .. column ] = value

            elseif type == SCOREBOARD_COMBAT_BUILDINGS_KILLED then
                Scoreboard.data[ "combatbuildingskilled" .. column ] = value

            elseif type == SCOREBOARD_COMBAT_DAMAGE_DEALT then
                Scoreboard.data[ "combatdamagedealt" .. column ] = value

            elseif type == SCOREBOARD_COMBAT_DAMAGE_RECEIVED then
                Scoreboard.data[ "combatdamagereceived" .. column ] = value

            elseif type == SCOREBOARD_COMBAT_LIFE_RESTORED then
                Scoreboard.data[ "combatliferestored" .. column ] = value

            elseif type == SCOREBOARD_COMBAT_MANA_RESTORED then
                Scoreboard.data[ "combatmanarestored" .. column ] = value

                -- R E S O U R C E S :

            elseif type == SCOREBOARD_RESOURCE_CURRENT_GOLD then
                Scoreboard.data[ "resourcecurrentgold" .. column ] = value

            elseif type == SCOREBOARD_RESOURCE_CURRENT_LUMBER then
                Scoreboard.data[ "resourcecurrentlumber" .. column ] = value

            elseif type == SCOREBOARD_RESOURCE_NETWORTH then
                Scoreboard.data[ "resourcenetworth" .. column ] = value
            end
        end,

        initialize = function( playersQuantity )
            if DEBUG_MODE and ( playersQuantity < 1 or playersQuantity > bj_MAX_PLAYERS ) then
                print( "Scoreboard.initialize: Указано некорректное число игроков. Пожалуйста, введите число в диапазоне от 1 до " .. bj_MAX_PLAYERS .. "." )

            else
                Scoreboard.data[ "columnsquantity" ] = playersQuantity

                local mainframe = BlzCreateFrameByType( "BACKDROP", "", BlzGetOriginFrame( ORIGIN_FRAME_GAME_UI, 0 ), "EscMenuBackdrop", 0 )
                BlzFrameSetSize( mainframe, 0.6, 0.272875 )
                BlzFrameSetPoint( mainframe, FRAMEPOINT_CENTER, BlzGetOriginFrame( ORIGIN_FRAME_WORLD_FRAME, 0 ), FRAMEPOINT_CENTER, 0.0, 0.0 )
                --BlzFrameSetVisible( mainframe, false )

                local mainframetitle = BlzCreateFrameByType( "TEXT", "", mainframe, "EscMenuLabelTextTemplate", 0 )
                BlzFrameSetPoint( mainframetitle, FRAMEPOINT_TOP, mainframe, FRAMEPOINT_TOP, 0.0, -0.03 )
                --BlzFrameSetText( mainframetitle, "Map Name: Hero Defense" )
                BlzFrameSetTextColor( mainframetitle, BlzConvertColor( 0xFF, 0xFC, 0xD3, 0x12 ) )

                local mainframesubtitle = BlzCreateFrameByType("TEXT", "", mainframe, "EscMenuTitleTextTemplate", 0 )
                BlzFrameSetPoint( mainframesubtitle, FRAMEPOINT_TOP, mainframetitle, FRAMEPOINT_BOTTOM, 0.0, -0.002 )
                --BlzFrameSetText( mainframesubtitle, "Scoreboard" )
                BlzFrameSetTextColor( mainframesubtitle, BlzConvertColor( 0xFF, 0xFF, 0xFF, 0xFF ) )

                -- M A I N   D I M E N S I O N S :

                -- Отступ от рамки главного backdrop'a:
                local edgeindent        = 0.036

                -- Расстояние между блоками (такими как: герои, бой и ресурсы):
                local blockindent       = 0.01

                -- Расстояние между текстами (такими как: добыто золота, добыто древесены и общая ценность):
                local textindent        = 0.002

                -- Высота текста названий:
                local titletextheight   = 0.011

                -- Высота обычного текста:
                local commontextheight  = 0.009375

                -- Ширина колонн, где отображаются значения каждого игрока:
                local valuecolumnwidth  = 0.075

                -- Отступ между колоннами, где отображаются значения каждого игрока:
                local columnindent      = 0.025

                local sliderheight      = 0.012



                -- Далее вычисляются размеры главного backdrop'a в зависимости от введённых данных:
                local mainframewidth    = edgeindent + 0.2164063 + 5 * columnindent + 5 * valuecolumnwidth + edgeindent
                local mainframeheight   = edgeindent + ( titletextheight ) + blockindent + ( titletextheight + 4 * commontextheight + 4 * textindent ) + blockindent + ( titletextheight + 6 * commontextheight + 6 * textindent ) + blockindent + ( titletextheight + 3 * commontextheight + 3 * textindent ) + blockindent + sliderheight + edgeindent

                BlzFrameSetSize( mainframe, mainframewidth, mainframeheight )

                if DEBUG_MODE and ( mainframewidth > 0.8 or mainframeheight > 0.6 ) then
                    BJDebugMsg( "Превышен максимальный размер frame'а: w = " .. mainframewidth .. ", h = " .. mainframeheight .. "." )
                end

                -- P L A Y E R S   N A M E :

                local playername_0 = BlzCreateFrameByType( "TEXT", "", mainframe, "EscMenuLabelTextTemplate", 0 )
                BlzFrameSetPoint( playername_0, FRAMEPOINT_TOPLEFT, mainframe, FRAMEPOINT_TOPLEFT,  edgeindent + 0.2164063 + columnindent, -0.036 )
                BlzFrameSetText( playername_0, "Player 0" )
                BlzFrameSetTextColor( playername_0, BlzConvertColor( 0xFF, 0xFF, 0xFF, 0xFF ) )

                local heroname = BlzCreateFrameByType( "TEXT", "", mainframe, "QuestListItemComplete", 0 )
                BlzFrameSetPoint( heroname, FRAMEPOINT_TOP, playername_0, FRAMEPOINT_BOTTOM, 0.0, -blockindent - titletextheight - textindent )
                BlzFrameSetText( heroname, "Hero Name" )
                BlzFrameSetTextColor( heroname, BlzConvertColor( 0xFF, 0xFF, 0xFF, 0xFF ) )

                local herostatus = BlzCreateFrameByType( "TEXT", "", mainframe, "QuestListItemComplete", 0 )
                BlzFrameSetPoint( herostatus, FRAMEPOINT_TOP, heroname, FRAMEPOINT_BOTTOM,  0.0, -textindent )
                BlzFrameSetText( herostatus, "|cFFFF0000Мёртв|r |cFF808080(84 сек.)|r" )
                BlzFrameSetTextColor( herostatus, BlzConvertColor( 0xFF, 0xFF, 0xFF, 0xFF ) )

                local herolevel = BlzCreateFrameByType( "TEXT", "", mainframe, "QuestListItemComplete", 0 )
                BlzFrameSetPoint( herolevel, FRAMEPOINT_TOP, herostatus, FRAMEPOINT_BOTTOM,  0.0, -textindent )
                BlzFrameSetText( herolevel, "13/30" )
                BlzFrameSetTextColor( herolevel, BlzConvertColor( 0xFF, 0xFF, 0xFF, 0xFF ) )

                local heroabilitieswillingness = BlzCreateFrameByType( "TEXT", "", mainframe, "QuestListItemComplete", 0 )
                BlzFrameSetPoint( heroabilitieswillingness, FRAMEPOINT_TOP, herolevel, FRAMEPOINT_BOTTOM,  0.0, -textindent )
                BlzFrameSetText( heroabilitieswillingness, "80%" )
                BlzFrameSetTextColor( heroabilitieswillingness, BlzConvertColor( 0xFF, 0xFF, 0xFF, 0xFF ) )


                local playername_1 = BlzCreateFrameByType( "TEXT", "", mainframe, "EscMenuLabelTextTemplate", 0 )
                BlzFrameSetPoint( playername_1, FRAMEPOINT_TOPLEFT, playername_0, FRAMEPOINT_TOPLEFT, valuecolumnwidth + columnindent, 0.0 )
                BlzFrameSetText( playername_1, "Player 1" )
                BlzFrameSetTextColor( playername_1, BlzConvertColor( 0xFF, 0xFF, 0xFF, 0xFF ) )

                local playername_2 = BlzCreateFrameByType( "TEXT", "", mainframe, "EscMenuLabelTextTemplate", 0 )
                BlzFrameSetPoint( playername_2, FRAMEPOINT_TOPLEFT, playername_1, FRAMEPOINT_TOPLEFT, valuecolumnwidth + columnindent, 0.0 )
                BlzFrameSetText( playername_2, "Player 2" )
                BlzFrameSetTextColor( playername_2, BlzConvertColor( 0xFF, 0xFF, 0xFF, 0xFF ) )

                local playername_3 = BlzCreateFrameByType( "TEXT", "", mainframe, "EscMenuLabelTextTemplate", 0 )
                BlzFrameSetPoint( playername_3, FRAMEPOINT_TOPLEFT, playername_2, FRAMEPOINT_TOPLEFT, valuecolumnwidth + columnindent, 0.0 )
                BlzFrameSetText( playername_3, "Player 3" )
                BlzFrameSetTextColor( playername_3, BlzConvertColor( 0xFF, 0xFF, 0xFF, 0xFF ) )

                local playername_4 = BlzCreateFrameByType( "TEXT", "", mainframe, "EscMenuLabelTextTemplate", 0 )
                BlzFrameSetPoint( playername_4, FRAMEPOINT_TOPLEFT, playername_3, FRAMEPOINT_TOPLEFT, valuecolumnwidth + columnindent, 0.0 )
                BlzFrameSetText( playername_4, "Player 3" )
                BlzFrameSetTextColor( playername_4, BlzConvertColor( 0xFF, 0xFF, 0xFF, 0xFF ) )

                -- H E R O E S :

                local hero = BlzCreateFrameByType( "TEXT", "", mainframe, "EscMenuLabelTextTemplate", 0 )
                BlzFrameSetPoint( hero, FRAMEPOINT_TOPLEFT, mainframe, FRAMEPOINT_TOPLEFT,  edgeindent, -edgeindent - titletextheight - blockindent )
                BlzFrameSetText( hero, "Герои:" )
                BlzFrameSetTextColor( hero, BlzConvertColor( 0xFF, 0xFC, 0xD3, 0x12 ) )

                local heroname = BlzCreateFrameByType( "TEXT", "", mainframe, "QuestListItemComplete", 0 )
                BlzFrameSetPoint( heroname, FRAMEPOINT_TOPLEFT, hero, FRAMEPOINT_BOTTOMLEFT,  0.0, -0.002 )
                BlzFrameSetText( heroname, "    Название" )
                BlzFrameSetTextColor( heroname, BlzConvertColor( 0xFF, 0xFF, 0xFF, 0xFF ) )

                local herostatus = BlzCreateFrameByType( "TEXT", "", mainframe, "QuestListItemComplete", 0 )
                BlzFrameSetPoint( herostatus, FRAMEPOINT_TOPLEFT, heroname, FRAMEPOINT_BOTTOMLEFT,  0.0, -0.002 )
                BlzFrameSetText( herostatus, "    Статус" )
                BlzFrameSetTextColor( herostatus, BlzConvertColor( 0xFF, 0xFF, 0xFF, 0xFF ) )

                local herolevel = BlzCreateFrameByType( "TEXT", "", mainframe, "QuestListItemComplete", 0 )
                BlzFrameSetPoint( herolevel, FRAMEPOINT_TOPLEFT, herostatus, FRAMEPOINT_BOTTOMLEFT,  0.0, -0.002 )
                BlzFrameSetText( herolevel, "    Уровень" )
                BlzFrameSetTextColor( herolevel, BlzConvertColor( 0xFF, 0xFF, 0xFF, 0xFF ) )

                local heroabilitieswillingness = BlzCreateFrameByType( "TEXT", "", mainframe, "QuestListItemComplete", 0 )
                BlzFrameSetPoint( heroabilitieswillingness, FRAMEPOINT_TOPLEFT, herolevel, FRAMEPOINT_BOTTOMLEFT,  0.0, -0.002 )
                BlzFrameSetText( heroabilitieswillingness, "    Готовность способностей" )
                BlzFrameSetTextColor( heroabilitieswillingness, BlzConvertColor( 0xFF, 0xFF, 0xFF, 0xFF ) )

                -- C O M B A T :

                local combat = BlzCreateFrameByType( "TEXT", "", mainframe, "EscMenuLabelTextTemplate", 0 )
                BlzFrameSetPoint( combat, FRAMEPOINT_TOPLEFT, heroabilitieswillingness, FRAMEPOINT_BOTTOMLEFT,  0.0, -0.01 )
                BlzFrameSetText( combat, "Бой:" )
                BlzFrameSetTextColor( combat, BlzConvertColor( 0xFF, 0xFC, 0xD3, 0x12 ) )

                local combatunitskilled = BlzCreateFrameByType( "TEXT", "", mainframe, "QuestListItemComplete", 0 )
                BlzFrameSetPoint( combatunitskilled, FRAMEPOINT_TOPLEFT, combat, FRAMEPOINT_BOTTOMLEFT,  0.0, -0.002 )
                BlzFrameSetText( combatunitskilled, "    Убито вражеских юнитов (из них боссов)" )
                BlzFrameSetTextColor( combatunitskilled, BlzConvertColor( 0xFF, 0xFF, 0xFF, 0xFF ) )

                local combatbuildingskilled = BlzCreateFrameByType( "TEXT", "", mainframe, "QuestListItemComplete", 0 )
                BlzFrameSetPoint( combatbuildingskilled, FRAMEPOINT_TOPLEFT, combatunitskilled, FRAMEPOINT_BOTTOMLEFT,  0.0, -0.002 )
                BlzFrameSetText( combatbuildingskilled, "    Разрушено вражеских сооружений" )
                BlzFrameSetTextColor( combatbuildingskilled, BlzConvertColor( 0xFF, 0xFF, 0xFF, 0xFF ) )

                local combatdamagedealt = BlzCreateFrameByType( "TEXT", "", mainframe, "QuestListItemComplete", 0 )
                BlzFrameSetPoint( combatdamagedealt, FRAMEPOINT_TOPLEFT, combatbuildingskilled, FRAMEPOINT_BOTTOMLEFT,  0.0, -0.002 )
                BlzFrameSetText( combatdamagedealt, "    Нанесено урона вражеским юнитам" )
                BlzFrameSetTextColor( combatdamagedealt, BlzConvertColor( 0xFF, 0xFF, 0xFF, 0xFF ) )

                local combatdamagereceived = BlzCreateFrameByType( "TEXT", "", mainframe, "QuestListItemComplete", 0 )
                BlzFrameSetPoint( combatdamagereceived, FRAMEPOINT_TOPLEFT, combatdamagedealt, FRAMEPOINT_BOTTOMLEFT,  0.0, -0.002 )
                BlzFrameSetText( combatdamagereceived, "    Получено урона от вражеских юнитов" )
                BlzFrameSetTextColor( combatdamagereceived, BlzConvertColor( 0xFF, 0xFF, 0xFF, 0xFF ) )

                local combatliferestored = BlzCreateFrameByType( "TEXT", "", mainframe, "QuestListItemComplete", 0 )
                BlzFrameSetPoint( combatliferestored, FRAMEPOINT_TOPLEFT, combatdamagereceived, FRAMEPOINT_BOTTOMLEFT,  0.0, -0.002 )
                BlzFrameSetText( combatliferestored, "    Восстановлено здоровья союзным юнитам" )
                BlzFrameSetTextColor( combatliferestored, BlzConvertColor( 0xFF, 0xFF, 0xFF, 0xFF ) )

                local combatmanarestored = BlzCreateFrameByType( "TEXT", "", mainframe, "QuestListItemComplete", 0 )
                BlzFrameSetPoint( combatmanarestored, FRAMEPOINT_TOPLEFT, combatliferestored, FRAMEPOINT_BOTTOMLEFT,  0.0, -0.002 )
                BlzFrameSetText( combatmanarestored, "    Восстановлено маны союзным юнитам" )
                BlzFrameSetTextColor( combatmanarestored, BlzConvertColor( 0xFF, 0xFF, 0xFF, 0xFF ) )

                -- R E S O U R C E S :

                local resources = BlzCreateFrameByType( "TEXT", "", mainframe, "EscMenuLabelTextTemplate", 0 )
                BlzFrameSetPoint( resources, FRAMEPOINT_TOPLEFT, combatmanarestored, FRAMEPOINT_BOTTOMLEFT,  0.0, -0.01 )
                BlzFrameSetText( resources, "Ресурсы:" )
                BlzFrameSetTextColor( resources, BlzConvertColor( 0xFF, 0xFC, 0xD3, 0x12 ) )

                local resourcecurrentgold = BlzCreateFrameByType( "TEXT", "", mainframe, "QuestListItemComplete", 0 )
                BlzFrameSetPoint( resourcecurrentgold, FRAMEPOINT_TOPLEFT, resources, FRAMEPOINT_BOTTOMLEFT,  0.0, -0.002 )
                BlzFrameSetText( resourcecurrentgold, "    Добыто золота" )
                BlzFrameSetTextColor( resourcecurrentgold, BlzConvertColor( 0xFF, 0xFF, 0xFF, 0xFF ) )

                local resourcecurrentlumber = BlzCreateFrameByType( "TEXT", "", mainframe, "QuestListItemComplete", 0 )
                BlzFrameSetPoint( resourcecurrentlumber, FRAMEPOINT_TOPLEFT, resourcecurrentgold, FRAMEPOINT_BOTTOMLEFT,  0.0, -0.002 )
                BlzFrameSetText( resourcecurrentlumber, "    Добыто древесины" )
                BlzFrameSetTextColor( resourcecurrentlumber, BlzConvertColor( 0xFF, 0xFF, 0xFF, 0xFF ) )

                local resourcenetworth = BlzCreateFrameByType( "TEXT", "", mainframe, "QuestListItemComplete", 0 )
                BlzFrameSetPoint( resourcenetworth, FRAMEPOINT_TOPLEFT, resourcecurrentlumber, FRAMEPOINT_BOTTOMLEFT,  0.0, -0.002 )
                BlzFrameSetText( resourcenetworth, "    Общая ценность" )
                BlzFrameSetTextColor( resourcenetworth, BlzConvertColor( 0xFF, 0xFF, 0xFF, 0xFF ) )

                local slider = BlzCreateFrame( "EscMenuSliderTemplate", mainframe, 0, 0)

                local x = edgeindent + 0.2164063 + columnindent
                local y = edgeindent + sliderheight

                BlzFrameSetPoint( slider, FRAMEPOINT_BOTTOMLEFT, mainframe, FRAMEPOINT_BOTTOMLEFT, x, y )
                BlzFrameSetPoint( slider, FRAMEPOINT_BOTTOMRIGHT, mainframe, FRAMEPOINT_BOTTOMRIGHT, -x, y )

                BlzFrameSetMinMaxValue( slider, 1.0, 10.0 )
                BlzFrameSetValue( slider, 1.0 )
                BlzFrameSetStepSize( slider, 1.0 )

                local trig = CreateTrigger( )
                BlzTriggerRegisterPlayerKeyEvent( trig, Player( 0x00 ), ConvertOsKeyType( 192 ), 0, true )
                BlzTriggerRegisterPlayerKeyEvent( trig, Player( 0x00 ), ConvertOsKeyType( 192 ), 0, false )
                TriggerAddAction( trig, function( )
                    --BlzFrameSetVisible( mainframe, BlzGetTriggerPlayerIsKeyDown( ) )
                end )

            end
        end

    }

end
