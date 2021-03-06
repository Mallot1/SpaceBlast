'SpaceBlast v1.6.7a
'By: Mallot1
'(C)2013 - 2014

'Verison 1: Finished 12/15/13 1:05 AM
'Version 1.2: Finished 12/?/13 ??????
'Version 1.3.5: Start 1/3/2014 1:45 PM Finished 1/3/2014 3:55 PM
'Version 1.4.7: Start 1/6/2014 about 6:48 PM finished 1/7/2014 1:11 AM
'Version 1.5.0: Start 1/8/2014 6:52 PM to 1/9/2014 4:16 AM finished: 1/11/2014 6:54 PM
'Version 1.6.7: Start 2/4/2014 5:29 PM finished: 11:07 PM
    '*Added spritepack compaibility(just make sure theres a sprite for ebvery image with your spritename on it!"also a _

NOMAINWIN

global score
global cursor$
global cursordir$
global width
global height
global shipSpeed
global musicState$
global SFX$
global packname$

savingMode$ = "Off"
codenum = 1
musicState$ = "On"
SFX$ = "On"
upKey$="w"
downKey$="s"
leftKey$="a"
rightKey$="d"
powerupMode = 1

WindowWidth = DisplayWidth
WindowHeight = DisplayHeight

 [MainMenu]
    gameIsOpen$ = "false"
    if running$ = "true" then
        if fromSettings = 1 then
            fromSettings = 0
            WindowWidth=DisplayWidth
            WindowHeight=DisplayHeight
        else
            stopmidi
        end if
        moving$ = ""
        close #game
    end if
    MouseMotion$ = "On"
   'buttons and things
    bmpbutton #main.play, "media\playbutton.bmp", [Game], UL, DisplayWidth/3+90, 100
    bmpbutton #main.about, "media\aboutbutton.bmp", [About], UL, DisplayWidth/3+90, 200
    bmpbutton #main.background, "media\changebackgroundbutton.bmp", [changeMenuBackground], UL, DisplayWidth/3+90, 300
    bmpbutton #main.cheatcode, "media\cheatsbutton.bmp", [startCheatCodeValidator], UL, DisplayWidth/3+90, 400
    bmpbutton #main.settings, "media\settingsbutton.bmp", [Settings], UL, DisplayWidth/3+90, 500 'used to be #main.options
    bmpbutton #main.quit, "media\quitbutton.bmp", [Quit], LL, WindowWidth-265, 10
    bmpbutton #main.reset, "media\resetbutton.bmp", [resetMainMenu], LL, 0, 10
    loadbmp "cursor", "sprites\proxi_cursor.bmp"
    open "Main Menu" for graphics_nsb_nf as #main
8   print #main, "addsprite cursor cursor"
    print #main, "when mouseMove [mouseMotion]"
    print #main, "down"
    print #main, "trapclose [Quit]"
    'setup window
6   print #main, "flush"

    if ( MenuBackgroundLoaded$ = "") then
        loadbmp "menuBG", "backgrounds\menuBG.bmp"
        print #main, "background menuBG"
        print #main, "drawsprites"
        MenuBackgroundLoaded$ = "true"
    end if

    print #main, "background menuBG"
    print #main, "drawsprites"

    wait

    [Quit]
        fromMenu = 0
        playwave ""
        if musicStatus$ = "On" then
            stopmidi
        end if
        timer 0
        close #main : end
        if fromMenu = 1 then close #main
        if fromSettings = 1 then close #set

    [resetMainMenu]
        shipX = MouseX
        shipY = MouseY
        goto 8
        wait

 [Game]
    close #main
    loadbmp "loading12", "backgrounds\loading12.bmp"
    gameIsOpen$ = "true"
    MouseMotion$ = "Off"
    useGameLabel = 1
    WindowWidth=DisplayWidth
    WindowHeight=DisplayHeight
    if musicState$ = "On" then
        if music$ <> "" then
            if musicStarted = 0 then
                playwave music$', loop
                musicStarted = 1
            end if
        end if
        if firstTimeStart = 0 then
            playmidi "SFX\music.mid", length
            firstTimeStart = 1
        end if
    end if
    'sprites
    goto [chooseTexturePack]

10  bulletname$ = "bullet";bulletnumber
    bulletnumber = 1

    menu #game, "&Options", "Change Background", [changeBackground],  "About", [About], "Menu", [mainMenuButtonClicked], "Change Music", [Music], "Enter Cheats", [startCheatCodeValidator], "Settings", [Settings]
    menu #game, "&Change Background", "Change Background", [changeBackground]
    menu #game, "&About", "About", [About]
    menu #game, "&Menu", "Menu", [quitToMenu] 'mainMenuButtonClicked
    menu #game, "&Change Music", "Change Music", [Music]
    menu #game, "&Cheats", "Validate Cheat Code", [startCheatCodeValidator]
    menu #game, "&Settings", "Settings", [Settings]
    textbox #game.scorebox, 0, 0, 100, 50
    fromMenu = 0
    fromGame = 1
    statictext #game.score, "Score: ", 1, 0, 100, 50

    open "SpaceBlast v1.6.7a" for graphics_nsb_nf as #game
    print #game, "down"
    print #game, "font times_new_roman 12"
    gosub [Score]
    print #game, "trapclose [gameQuit]"
    running$ = "true"

    print #game, "addsprite ship ship_up ship_damage ship_up_damage_1 ship_up_damage_2 ship_up_damage_3 ship_up_damage_4 ship_up_on ship_up_on_damage_1 ship_up_on_damage_2 ship_up_on_damage_3 ship_up_on_damage_4 ship_left ship_left_damage_1 ship_left_damage_2 ship_left_damage_3 ship_left_damage_4 ship_left_on ship_left_on_damage_1 ship_left_on_damage_2 ship_left_on_damage_3 ship_left_on_damage_4 ship_right ship_right_damage_1 ship_right_damage_2 ship_right_damage_3 ship_right_damage_4 ship_right_on ship_right_on_damage_1 ship_right_on_damage_2 ship_right_on_damage_3 ship_right_on_damage_4 ship_down ship_down_on ship_down_on_damage_1 ship_down_on_damage_2 ship_down_on_damage_3 ship_down_on_damage_4 ship_boost_left ship_boost_left_damage_1 ship_boost_left_damage_2 ship_boost_left_damage_3 ship_boost_left_damage_4 ship_boost_right ship_boost_right_damage_1 ship_boost_right_damage_2 ship_boost_right_damage_3 ship_boost_right_damage_4 ship_boost_down ship_boost_up ship_destroyed"
    print #game, "spritescale ship 250"
    print #game, "addsprite asteroid asteroid"
    print #game, "spritescale asteroid 250"
    print #game, "addsprite health health(0) health(1) health(2) health(3) health(4) health(5)"
    print #game, "addsprite boostbar boost25+ boost25 boost24 boost23 boost22 boost21 boost20 boost19 boost18 boost17 boost16 boost15 boost14 boost13 boost12 boost11 boost10 boost09 boost08 boost07 boost06 boost05 boost04 boost03 boost02 boost01 boost00"

    print newsprite$("bullet1", "bulletoneup")
    print newsprite$("bullet2", "bullettwoup")
    print newsprite$("bullet3", "bulletthreeup")
    print newsprite$("bullet4", "bulletfourup")
    print newsprite$("bullet5", "bulletfiveup")
    print newsprite$("bullet6", "bulletsixup")
    print newsprite$("bullet7", "bulletsevenup")
    print newsprite$("bullet8", "bulleteightup")
    print newsprite$("bullet9", "bulletnineup")
    print newsprite$("bullet10", "bullettenup")

    print newsprite$("bullet1left", "bulletoneleft")
    print newsprite$("bullet2left", "bullettwoleft")
    print newsprite$("bullet3left", "bulletthreeleft")
    print newsprite$("bullet4left", "bulletfourleft")
    print newsprite$("bullet5left", "bulletfiveleft")
    print newsprite$("bullet6left", "bulletsixleft")
    print newsprite$("bullet7left", "bulletsevenleft")
    print newsprite$("bullet8left", "bulleteightleft")
    print newsprite$("bullet9left", "bulletnineleft")
    print newsprite$("bullet10left", "bullettenleft")

    print #game, "spritescale health 500"
    print #game, "spritexy health "; DisplayWidth-150 ;" -40"
    print #game, "when characterInput [userInput]"
    print #game, "when leftButtonDown [shoot]"
    print #game, "when rightButtonDown [rapidFire]"

    'load Background
    if (backgroundChanged$ = "true") then goto 3                'now game will always show the user chosen background
    loadbmp "bg", "backgrounds\proxi_space.bmp"
    print #game, "background bg"
    print #game, "drawsprites"

   'Variables:
    sprite$ = "bulletone"
    nextsprite = 1
    start = 1
    shipX = WindowWidth/2 - 100 ' ship x-pos
    shipY = WindowHeight - 120  ' ship y-pos
    shipSpeed = 50 'The ships speed
1   paused = 0
    velx = 0 ' asteroid X-Axis speed was 15.5 then was 7.5
    vely = 0 ' asteroid Y-Axis speed was 15.5 then was 7.5
    x = 100 ' asteroid x-pos was 1
    y = 40 ' asteroid y-pos was 1
    dim BulletBMP$(10)
    BulletBMP$(1) = "sprites\bullet1up.bmp"
    BulletBMP$(2) = "sprites\bullet2up.bmp"
    BulletBMP$(3) = "sprites\bullet3up.bmp"
    BulletBMP$(4) = "sprites\bullet4up.bmp"
    BulletBMP$(5) = "sprites\bullet5up.bmp"
    BulletBMP$(6) = "sprites\bullet6up.bmp"
    BulletBMP$(7) = "sprites\bullet7up.bmp"
    BulletBMP$(8) = "sprites\bullet8up.bmp"
    BulletBMP$(9) = "sprites\bullet9up.bmp"
    BulletBMP$(10) = "sprites\bullet10up.bmp"
    currentBulletNum = 1
    health = 5
    score = 0
    fromGame = 0

    print #game, "spritexy ship "; shipX; " "; shipY
    print #game, "drawsprites"
    scan
    gosub [loadShip]
    if resized = 1 then
        WindowWidth = width
        WindowHeight = height
    end if
    timer 100,  [timeTicked] 'was at 56
    wait

    [gameQuit]

        timer 0
        confirm "Do you really want to quit?";quit$
        if quit$ = "yes" then
            start = 0
            fromGame = 0
            notice "Game Over!" + Chr$(13) + " Your final score is: ";score
            playwave ""
            stopmidi
            if fromMenu = 1 then close #main
            if fromSettings = 1 then close #set
4           playwave ""
            if fromHealth = 1 then
                stopmidi
            end if
            close #game : end  'if your out of health you come here and the game ends

        end if
        if quit$ = "no" then
            goto  1 ' goto line labeled "1"
        end if
        wait

    [quitToMenu]
    if paused = 1 then
        if savingMode$ = "On" then
            confirm "Are you sure you want to leave? Y/N?";GTMenu$
            if GTMenu$ = "yes" then
                start = 0
                fromGame = 0
                confirm "Would you like to save your game?( you can currently only resume while the game is open ) Y/N?";asksave$
                if asksave$ = "yes" then
                    goto [Save]
                end if
            end if

            if asksave$ = "no" then
                notice "Leaving to menu..."
                goto [MainMenu]
            end if

            if GTMenu$ = "no" then
                goto 1
            end if

        else
            notice "Leaving to menu..."
            goto [MainMenu]
        end if
    else
        BEEP
        notice "Pause the game first!"
    end if

     wait

    [loadShip]
        print #game, "spritexy ship "; shipX; " "; shipY
        print #game, "drawsprites"
        return
        wait

    [loadHealth]
        healthposX = DisplayWidth - 150
        health = 5
        if useGameLabel = 1 then
            print #game, "spriteimage health health("; health; ")"
            print #game, "spritescale health 500"
            print #game, "spritexy health ";healthposX; " -40"
            print #game, "drawsprites"
            gotHealth = 1
            firstAddedHealth = 1
        end if
        goto [Health]

        [Health]
            fromHealth = 1
            if useGameLabel = 1 then
                print #game, "spriteimage health health("; health; ")"
                print #game, "spritescale health 500"
                print #game, "spritexy health ";healthposX; " -40"
                print #game, "drawsprites"
            end if

           if health <= 0 then
                health = 0
                if useGameLabel = 1 then
                    playwave, "SFX\explode.wav", async
                    print #game, "spriteimage ship ship_destroyed"
                    print #game, "background gameover"
                    print #game, "drawsprites"
                    notice "Game Over!" + Chr$(13) + "Better Luck next time! Your final score is: ";score
                    print #game, "drawsprites"
                    goto 4
                end if
           end if

            if firstAddedHealth = 1 then
                firstAddedHealth = 0
                goto [timeTicked]
            else
                return
            end if

    [timeTicked]
        if WindowWidth = 0 then WindowWidth = width
        if WindowHeight = 0 then WindowHeight = height

        if WindowWidth = 0 then WindowWidth = DisplayWidth
        if WindowHeight = 0 then WindowHeight = DisplayHeight

        if paused = 0 then
            bulletX = shipX
            bulletY = shipY
            if gotHealth = 0 then
                gosub [loadHealth]
            end if
            if useGameLabel = 1 then
                print #game, "when characterInput [userInput]"
                print #game, "when leftButtonDown [shoot]"
                gosub [Health] 'Refresh health bar
                gosub [Score] 'Refresh score bar
                gosub [loadAsteroids] 'Refresh asteroids
                gosub [loadBullet] 'Refresh and render bullets
                gosub [loadPowerups] 'load new powerups
9               gosub [CollisionDetection] 'check for collision detection
                gosub [updateGame]'Update game/check for setting changes
            else
                useGameLabel = 1
                goto [Game]
            end if

           char$ = ""
        end if
    wait

    [userInput]
        print #game, "when characterInput [userInput]"
        print #game, "when leftButtonDown [shoot]"
        char$ = Inkey$
        'if paused = 0 then
        'if rapidfire is on toggle it
            'if coderapidfire$ = "used" then
                'if rapidfire$ = "on" then
               '     if char$ = "z" then
              '          rapidfire$ = ""
             '       end if
            '        if char$ = "Z" then
           '             rapidfire$ = ""
          '          end if
         '       end if
        '        'if rapidfire$ = "" then
                '    if char$ = "z" then
               '         rapidfire$ = "on"
              '      end if
             '       if char$ = "Z" then
            '            rapidfire$ = "on"
           '         end if
          '      end if
         '   end if
        'end if

        'un-pause the game
        if char$ = "r" then
            if paused = 1 then
                goto [endPause]
            end if
        end if

        if char$ = "R" then
            if paused = 1 then
                goto [endPause]
            end if
        end if


    if paused = 0 then
        if char$ = "b" then
            gosub [Boost]
        end if

        if char$ = "B" then
            gosub [Boost]
        end if
        if frozen < 50 then
            if frozen > 0 then
                frozen = frozen - 1
            else
                if char$ = upKey$ or char$ = upper$(upKey$) then
                    shipY = shipY - shipSpeed
                    moving$ = "up"
                    char$ = ""
                    print #game, "spriteimage ship ship_up_on"
                    print #game, "drawsprites"
                end if


                if char$ = leftKey$ or char$ = upper$(leftKey$) then
                    shipX = shipX - shipSpeed
                    moving$ = "left"
                    char$ = ""
                    print #game, "spriteimage ship ship_left_on"
                    print #game, "drawsprites"
                end if


                if char$ = downKey$ or char$ = upper$(downKey$) then
                    shipY = shipY + shipSpeed
                    moving$ = "down"
                    char$ = ""
                    print #game, "spriteimage ship ship_down_on"
                    print #game, "drawsprites"
                end if



                if char$ = rightKey$ or char$ = upper$(rightKey$) then
                    shipX = shipX + shipSpeed
                    moving$ = "right"
                    char$ = ""
                    print #game, "spriteimage ship ship_right_on"
                    print #game, "drawsprites"
                end if
            end if
        end if

        if char$ = "p" then
            goto [Pause]
        end if

        if char$ = "P" then
            goto [Pause]
        end if

        if char$ = "m" then
            goto [toggleMusic]
        end if

        if char$ = "M" then
            goto [toggleMusic]
        end if

        print "X: ";shipX ;"   Y: ";shipY
        print #game, "spritexy ship "; shipX; " ";shipY
        print #game, "drawsprites"

        if shipX >= 1293 then
           shipX = 1291
        end if

        if shipX <= 0 then
           shipX = 2
        end if

        if shipY >= 632 then
           shipY = 630
        end if

        if shipY <= 0 then
           shipY = 2
        end if

        'if char$ = "" then
            if moving$ = "up" then
                print #game, "spriteimage ship ship_up"
                print #game, "drawsprites"
            end if

            if moving$ = "left" then
                print #game, "spriteimage ship ship_left"
                print #game, "drawsprites"
            end if

            if moving$ = "down" then
                print #game, "spriteimage ship ship_down"
                print #game, "drawsprites"
            end if

            if moving$ = "right" then
                print #game, "spriteimage ship ship_right"
                print #game, "drawsprites"
            end if
        'end if

        if shot = 1 then
            gosub [loadBullet]
        end if
    end if ' pause = 0 end if

        wait

    [Boost]
        if boostLoaded = 0 then
            print #game, "spritexy boostbar 1000 0"
            print #game, "spritescale boostbar 500 0"
            print #game, "drawsprites"
            boost = boost + 10 ' 10 boost 25 max is the most with a personal sprite

            boostLoaded = 1
        end if

        if boost <> 0 then

            if boost > 25 then
                print #game, "spriteimage boostbar boost25+"
                print #game, "drawsprites"
                boost = boost - 1
                goto 7
            end if

            if boost = 25 then
                print #game, "spriteimage boostbar boost25"
                print #game, "drawsprites"
                boost = boost - 1
                goto 7
            end if

            if boost = 24 then
                print #game, "spriteimage boostbar boost24"
                print #game, "drawsprites"
                boost = boost - 1
                goto 7
            end if

            if boost = 23 then
                print #game, "spriteimage boostbar boost23"
                print #game, "drawsprites"
                boost = boost - 1
                goto 7
            end if

            if boost = 22 then
                print #game, "spriteimage boostbar boost22"
                print #game, "drawsprites"
                boost = boost - 1
                goto 7
            end if

            if boost = 21 then
                print #game, "spriteimage boostbar boost21"
                print #game, "drawsprites"
                boost = boost - 1
                goto 7
            end if

            if boost = 20 then
                print #game, "spriteimage boostbar boost20"
                print #game, "drawsprites"
                boost = boost - 1
                goto 7
            end if

            if boost = 19 then
                print #game, "spriteimage boostbar boost19"
                print #game, "drawsprites"
                boost = boost - 1
                goto 7
            end if
            if boost = 18 then
                print #game, "spriteimage boostbar boost18"
                print #game, "drawsprites"
                boost = boost - 1
                goto 7
            end if

            if boost = 17 then
                print #game, "spriteimage boostbar boost17"
                print #game, "drawsprites"
                boost = boost - 1
                goto 7
            end if

            if boost = 16 then
                print #game, "spriteimage boostbar boost16"
                print #game, "drawsprites"
                boost = boost - 1
                goto 7
            end if

            if boost = 15 then
                print #game, "spriteimage boostbar boost15"
                print #game, "drawsprites"
                boost = boost - 1
                goto 7
            end if

            if boost = 14 then
                print #game, "spriteimage boostbar boost14"
                print #game, "drawsprites"
                boost = boost - 1
                goto 7
            end if

            if boost = 13 then
                print #game, "spriteimage boostbar boost13"
                print #game, "drawsprites"
                boost = boost - 1
                goto 7
            end if

            if boost = 12 then
                print #game, "spriteimage boostbar boost12"
                print #game, "drawsprites"
                boost = boost - 1
                goto 7
            end if

            if boost = 11 then
                print #game, "spriteimage boostbar boost11"
                print #game, "drawsprites"
                boost = boost - 1
                goto 7
            end if


            if boost = 10 then
                print #game, "spriteimage boostbar boost10"
                print #game, "drawsprites"
                boost = boost - 1
                goto 7
            end if

            if boost = 9 then
                print #game, "spriteimage boostbar boost09"
                print #game, "drawsprites"
                boost = boost - 1
                goto 7
            end if

            if boost = 8 then
                print #game, "spriteimage boostbar boost08"
                print #game, "drawsprites"
                boost = boost - 1
                goto 7
            end if

            if boost = 7 then
                print #game, "spriteimage boostbar boost07"
                print #game, "drawsprites"
                boost = boost - 1
                goto 7
            end if

            if boost = 6 then
                print #game, "spriteimage boostbar boost06"
                print #game, "drawsprites"
                boost = boost - 1
                goto 7
            end if

            if boost = 5 then
                print #game, "spriteimage boostbar boost05"
                print #game, "drawsprites"
                boost = boost - 1
                goto 7
            end if

            if boost = 4 then
                print #game, "spriteimage boostbar boost04"
                print #game, "drawsprites"
                boost = boost - 1
                goto 7
           end if

            if boost = 3 then
                print #game, "spriteimage boostbar boost03"
                print #game, "drawsprites"
                boost = boost - 1
                goto 7
            end if

            if boost = 2 then
                print #game, "spriteimage boostbar boost02"
                print #game, "drawsprites"
                boost = boost - 1
                goto 7
            end if

            if boost = 1 then

                print #game, "spriteimage boostbar boost01"
                print #game, "drawsprites"
                boostIsAtOne$ = "true"
                boost = boost - 2 ' to get less than 0 to be reset to 0
                goto 7
            end if

        if boost < 0 then
            print #game, "spriteimage boostbar boost00"
            print #game, "drawsprites"
            boost = 0
            goto 7
        end if

7           if boost > -1 then
                if moving$ = "left" then
                    select health
                        case 5
                            print #game, "spriteimage ship ship_boost_left"
                            print #game, "drawsprites"
                        case 4
                            print #game, "spriteimage ship ship_boost_left_damage_1"
                            print #game, "drawsprites"
                        case 3
                            print #game, "spriteimage ship ship_boost_left_damage_2"
                            print #game, "drawsprites"
                        case 2
                            print #game, "spriteimage ship ship_boost_left_damage_3"
                            print #game, "drawsprites"
                        case 1
                            print #game, "spriteimage ship ship_boost_left_damage_4"
                            print #game, "drawsprites"
                    end select
                  shipX = shipX - 100
                end if

                if moving$ = "right" then
                    select health
                        case 5
                            print #game, "spriteimage ship ship_boost_right"
                            print #game, "drawsprites"
                        case 4
                            print #game, "spriteimage ship ship_boost_right_damage_1"
                            print #game, "drawsprites"
                        case 3
                            print #game, "spriteimage ship ship_boost_right_damage_2"
                            print #game, "drawsprites"
                        case 2
                            print #game, "spriteimage ship ship_boost_right_damage_3"
                            print #game, "drawsprites"
                        case 1
                            print #game, "spriteimage ship ship_boost_right_damage_4"
                            print #game, "drawsprites"
                    end select
                    shipX = shipX + 100
                end if

                if moving$ = "up" then
                    print #game, "spriteimage ship ship_boost_up"
                    print #game, "drawsprites"
                    shipY = shipY - 100
                end if

                if moving$ = "down" then
                    print #game, "spriteimage ship ship_boost_down"
                    print #game, "drawsprites"
                    shipY = shipY + 100
                end if
            end if
        end if
        return

    [loadAsteroids]
        x = int(rnd(1)* DisplayWidth-70)
        y = int(rnd(1)* DisplayHeight-70)
        if loadedAsteroid$<>"true" then
            print #game, "spritevisible asteroid on"
            print #game, "spriteimage asteroid asteroid"
            print #game, "spritexy asteroid ";x;" ";y
            print #game, "drawsprites"
            loadedAsteroid$ = "true"
            direction = int(rnd(1) * 4) ' 1=up 2=left 3=right 4=down
        end if
        if loadedAsteroid$ = "true" then
            if direction = 1 then
                print #game, "spriteimage asteroid asteroid"
                print #game, "spritemovexy asteroid 0 -5"  'was"; x+velx; " "; y+vely
                print #game, "drawsprites"
                print "direction: up"
            end if

            if direction = 2 then
                print #game, "spriteimage asteroid asteroid"
                print #game, "spritemovexy asteroid -5 0"
                print #game, "drawsprites"
                print "direction: left"
            end if

            if direction = 3 then
                print #game, "spriteimage asteroid asteroid"
                print #game, "spritemovexy asteroid 0 5"
                print #game, "drawsprites"
                print "direction: down"
            end if

            if direction = 4 then
                print #game, "spriteimage asteroid asteroid"
                print #game, "spritemovexy asteroid 5 0"
                print #game, "drawsprites"
                print "direction: right"
            end if

        end if

        print "AsteroidX: ";x ;" AsteroidY: ";y
        print "ShipX: ";shipX ;" ShipY: ";shipY
        print ""

        print #game, "spritexy? asteroid asteroidx asteroidy"
        if asteroidx > DisplayWidth then
            loadedAsteroid$ = "false"
        end if

        if asteroidx < 0 then
            loadedAsteroid$ = "false"
        end if

        if asteroidy > DisplayHeight then
            loadedAsteroid$ = "false"
        end if

        if asteroidy < 0 then
            loadedAsteroid$ = "false"
        end if
        print #game, "drawsprites"
        return

    [changeMenuBackground]
        filedialog "Open Bitmap Image", "backgrounds/*.bmp", UserMenuBGimage$
        if (UserMenuBGimage$ = "") then
            notice "Background change aborted by user."
            goto 6
        end if
        MenuBackgroundLoaded$ = UserMenuBGimage$
        MenuBackgroundChanged$ = "true"
        loadbmp "menuBG",  UserMenuBGimage$
        print #main, "background menuBG"
        print #main, "drawsprites"
        MenuBackgroundChanged$ = "true"
        wait

    [changeBackground]
        filedialog "Open Bitmap Image", "backgrounds/*.bmp", UserBGimage$
        if (UserBGimage$ = "") then
            notice "Background change aborted by user."
            goto 1
        end if

        backgroundChanged$ = "true"
3       loadbmp "UserBG",  UserBGimage$
        print #game, "background UserBG"
        print #game, "drawsprites"
        wait


    [loadBullet]
    if moving$ = "up" then
        if B1$="loaded" then
                print #game, "spriteimage bullet1 bulletone"
                print #game, "spritemovexy bullet1 0 -5"

                print #game, "drawsprites"
                B1$ = ""
                B2$ = ""
                B3$ = ""
                B4$ = ""
                B5$ = ""
                B6$ = ""
                B7$ = ""
                B8$ = ""
                B9$ = ""
                B10$ = ""
        end if

        if B2$="loaded" then
                print #game, "spriteimage bullet2 bullettwo"
                print #game, "spritemovexy bullet2 0 -5"
                print #game, "drawsprites"
                B1$ = ""
                B2$ = ""
                B3$ = ""
                B4$ = ""
                B5$ = ""
                B6$ = ""
                B7$ = ""
                B8$ = ""
                B9$ = ""
                B10$ = ""
        end if


        if B3$="loaded" then
                print #game, "spriteimage bullet3 bulletthree"
                print #game, "spritemovexy bullet3 0 -5"
                print #game, "drawsprites"
                B1$ = ""
                B2$ = ""
                B3$ = ""
                B4$ = ""
                B5$ = ""
                B6$ = ""
                B7$ = ""
                B8$ = ""
                B9$ = ""
                B10$ = ""
        end if


        if B4$="loaded" then
                print #game, "spriteimage bullet4 bulletfour"
                print #game, "spritemovexy bullet4 0 -5"
                print #game, "drawsprites"
                B1$ = ""
                B2$ = ""
                B3$ = ""
                B4$ = ""
                B5$ = ""
                B6$ = ""
                B7$ = ""
                B8$ = ""
                B9$ = ""
                B10$ = ""
        end if


        if B5$="loaded" then
                print #game, "spriteimage bullet5 bulletfive"
                print #game, "spritemovexy bullet5 0 -5"
                print #game, "drawsprites"
                B1$ = ""
                B2$ = ""
                B3$ = ""
                B4$ = ""
                B5$ = ""
                B6$ = ""
                B7$ = ""
                B8$ = ""
                B9$ = ""
                B10$ = ""
        end if


        if B6$="loaded" then
                print #game, "spriteimage bullet6 bulletsix"
                print #game, "spritemovexy bullet6 0 -5"
                print #game, "drawsprites"
                B1$ = ""
                B2$ = ""
                B3$ = ""
                B4$ = ""
                B5$ = ""
                B6$ = ""
                B7$ = ""
                B8$ = ""
                B9$ = ""
                B10$ = ""
        end if


        if B7$="loaded" then
                print #game, "spriteimage bullet7 bulletseven"
                print #game, "spritemovexy bullet7 0 -5"
                print #game, "drawsprites"
                B1$ = ""
                B2$ = ""
                B3$ = ""
                B4$ = ""
                B5$ = ""
                B6$ = ""
                B7$ = ""
                B8$ = ""
                B9$ = ""
                B10$ = ""
        end if


        if B8$="loaded" then
                print #game, "spriteimage bullet8 bulleteight"
                print #game, "spritemovexy bullet8 0 -5"
                print #game, "drawsprites"
                B1$ = ""
                B2$ = ""
                B3$ = ""
                B4$ = ""
                B5$ = ""
                B6$ = ""
                B7$ = ""
                B8$ = ""
                B9$ = ""
                B10$ = ""
        end if


        if B9$="loaded" then
                print #game, "spriteimage bullet9 bulletnine"
                print #game, "spritemovexy bullet9 0 -5"
                print #game, "drawsprites"
                B1$ = ""
                B2$ = ""
                B3$ = ""
                B4$ = ""
                B5$ = ""
                B6$ = ""
                B7$ = ""
                B8$ = ""
                B9$ = ""
                B10$ = ""
        end if


        if B10$="loaded" then
                print #game, "spriteimage bullet10 bulletten"
                print #game, "spritemovexy bullet10 0 -5"
                print #game, "drawsprites"
                B1$ = ""
                B2$ = ""
                B3$ = ""
                B4$ = ""
                B5$ = ""
                B6$ = ""
                B7$ = ""
                B8$ = ""
                B9$ = ""
                B10$ = ""
        end if
    end if

    if moving$ = "left" then
        if B1$="loaded" then
                'print #game, "spriteimage bullet1 bulletone"
                print #game, "spritemovexy bullet1left -5 0"
                print #game, "spriteorient bullet1left normal"
                print #game, "drawsprites"
                B1$ = ""
                B2$ = ""
                B3$ = ""
                B4$ = ""
                B5$ = ""
                B6$ = ""
                B7$ = ""
                B8$ = ""
                B9$ = ""
                B10$ = ""
        end if

        if B2$="loaded" then
                'print #game, "spriteimage bullet2 bullettwo"
                print #game, "spritemovexy bullet2left -5 0"
                print #game, "spriteorient bullet2left normal"
                print #game, "drawsprites"
                B1$ = ""
                B2$ = ""
                B3$ = ""
                B4$ = ""
                B5$ = ""
                B6$ = ""
                B7$ = ""
                B8$ = ""
                B9$ = ""
                B10$ = ""
        end if


        if B3$="loaded" then
                'print #game, "spriteimage bullet3 bulletthree"
                print #game, "spritemovexy bullet3left -5 0"
                print #game, "spriteorient bullet3left normal"
                print #game, "drawsprites"
                B1$ = ""
                B2$ = ""
                B3$ = ""
                B4$ = ""
                B5$ = ""
                B6$ = ""
                B7$ = ""
                B8$ = ""
                B9$ = ""
                B10$ = ""
        end if


        if B4$="loaded" then
                'print #game, "spriteimage bullet4 bulletfour"
                print #game, "spritemovexy bullet4left -5 0"
                print #game, "spriteorient bullet4left normal"
                print #game, "drawsprites"
                B1$ = ""
                B2$ = ""
                B3$ = ""
                B4$ = ""
                B5$ = ""
                B6$ = ""
                B7$ = ""
                B8$ = ""
                B9$ = ""
                B10$ = ""
        end if


        if B5$="loaded" then
                'print #game, "spriteimage bullet5 bulletfive"
                print #game, "spritemovexy bullet5left -5 0"
                print #game, "spriteorient bullet5left normal"
                print #game, "drawsprites"
                B1$ = ""
                B2$ = ""
                B3$ = ""
                B4$ = ""
                B5$ = ""
                B6$ = ""
                B7$ = ""
                B8$ = ""
                B9$ = ""
                B10$ = ""
        end if


        if B6$="loaded" then
                'print #game, "spriteimage bullet6 bulletsix"
                print #game, "spritemovexy bullet6left -5 0"
                print #game, "spriteorient bullet6left normal"
                print #game, "drawsprites"
                B1$ = ""
                B2$ = ""
                B3$ = ""
                B4$ = ""
                B5$ = ""
                B6$ = ""
                B7$ = ""
                B8$ = ""
                B9$ = ""
                B10$ = ""
        end if


        if B7$="loaded" then
                'print #game, "spriteimage bullet7 bulletseven"
                print #game, "spritemovexy bullet7left -5 0"
                print #game, "spriteorient bullet7left normal"
                print #game, "drawsprites"
                B1$ = ""
                B2$ = ""
                B3$ = ""
                B4$ = ""
                B5$ = ""
                B6$ = ""
                B7$ = ""
                B8$ = ""
                B9$ = ""
                B10$ = ""
        end if


        if B8$="loaded" then
                'print #game, "spriteimage bullet8 bulleteight"
                print #game, "spritemovexy bullet8left -5 0"
                print #game, "spriteorient bullet8left normal"
                print #game, "drawsprites"
                B1$ = ""
                B2$ = ""
                B3$ = ""
                B4$ = ""
                B5$ = ""
                B6$ = ""
                B7$ = ""
                B8$ = ""
                B9$ = ""
                B10$ = ""
        end if


        if B9$="loaded" then
                'print #game, "spriteimage bullet9 bulletnine"
                print #game, "spritemovexy bullet9left -5 0"
                print #game, "spriteorient bullet9left normal"
                print #game, "drawsprites"
                B1$ = ""
                B2$ = ""
                B3$ = ""
                B4$ = ""
                B5$ = ""
                B6$ = ""
                B7$ = ""
                B8$ = ""
                B9$ = ""
                B10$ = ""
        end if


        if B10$="loaded" then
                'print #game, "spriteimage bullet10 bulletten"
                print #game, "spritemovexy bullet10left -5 0"
                print #game, "spriteorient bullet10left normal"
                print #game, "drawsprites"
                B1$ = ""
                B2$ = ""
                B3$ = ""
                B4$ = ""
                B5$ = ""
                B6$ = ""
                B7$ = ""
                B8$ = ""
                B9$ = ""
                B10$ = ""
        end if
    end if

    if moving$ = "down" then
        if B1$="loaded" then
                print #game, "spriteimage bullet1 bulletone"
                print #game, "spritemovexy bullet1 0 5"
                print #game, "drawsprites"
                B1$ = ""
                B2$ = ""
                B3$ = ""
                B4$ = ""
                B5$ = ""
                B6$ = ""
                B7$ = ""
                B8$ = ""
                B9$ = ""
                B10$ = ""
        end if

        if B2$="loaded" then
                print #game, "spriteimage bullet2 bullettwo"
                print #game, "spritemovexy bullet2 0 5"
                print #game, "drawsprites"
                B1$ = ""
                B2$ = ""
                B3$ = ""
                B4$ = ""
                B5$ = ""
                B6$ = ""
                B7$ = ""
                B8$ = ""
                B9$ = ""
                B10$ = ""
        end if


        if B3$="loaded" then
                print #game, "spriteimage bullet3 bulletthree"
                print #game, "spritemovexy bullet3 0 5"
                print #game, "drawsprites"
                B1$ = ""
                B2$ = ""
                B3$ = ""
                B4$ = ""
                B5$ = ""
                B6$ = ""
                B7$ = ""
                B8$ = ""
                B9$ = ""
                B10$ = ""
        end if


        if B4$="loaded" then
                print #game, "spriteimage bullet4 bulletfour"
                print #game, "spritemovexy bullet4 0 5"
                print #game, "drawsprites"
                B1$ = ""
                B2$ = ""
                B3$ = ""
                B4$ = ""
                B5$ = ""
                B6$ = ""
                B7$ = ""
                B8$ = ""
                B9$ = ""
                B10$ = ""
        end if


        if B5$="loaded" then
                print #game, "spriteimage bullet5 bulletfive"
                print #game, "spritemovexy bullet5 0 5"
                print #game, "drawsprites"
                B1$ = ""
                B2$ = ""
                B3$ = ""
                B4$ = ""
                B5$ = ""
                B6$ = ""
                B7$ = ""
                B8$ = ""
                B9$ = ""
                B10$ = ""
        end if


        if B6$="loaded" then
                print #game, "spriteimage bullet6 bulletsix"
                print #game, "spritemovexy bullet6 0 5"
                print #game, "drawsprites"
                B1$ = ""
                B2$ = ""
                B3$ = ""
                B4$ = ""
                B5$ = ""
                B6$ = ""
                B7$ = ""
                B8$ = ""
                B9$ = ""
                B10$ = ""
        end if


        if B7$="loaded" then
                print #game, "spriteimage bullet7 bulletseven"
                print #game, "spritemovexy bullet7 0 5"
                print #game, "drawsprites"
                B1$ = ""
                B2$ = ""
                B3$ = ""
                B4$ = ""
                B5$ = ""
                B6$ = ""
                B7$ = ""
                B8$ = ""
                B9$ = ""
                B10$ = ""
        end if


        if B8$="loaded" then
                print #game, "spriteimage bullet8 bulleteight"
                print #game, "spritemovexy bullet8 0 5"
                print #game, "drawsprites"
                B1$ = ""
                B2$ = ""
                B3$ = ""
                B4$ = ""
                B5$ = ""
                B6$ = ""
                B7$ = ""
                B8$ = ""
                B9$ = ""
                B10$ = ""
        end if


        if B9$="loaded" then
                print #game, "spriteimage bullet9 bulletnine"
                print #game, "spritemovexy bullet9 0 5"
                print #game, "drawsprites"
                B1$ = ""
                B2$ = ""
                B3$ = ""
                B4$ = ""
                B5$ = ""
                B6$ = ""
                B7$ = ""
                B8$ = ""
                B9$ = ""
                B10$ = ""
        end if


        if B10$="loaded" then
                print #game, "spriteimage bullet10 bulletten"
                print #game, "spritemovexy bullet10 0 5"
                print #game, "drawsprites"
                B1$ = ""
                B2$ = ""
                B3$ = ""
                B4$ = ""
                B5$ = ""
                B6$ = ""
                B7$ = ""
                B8$ = ""
                B9$ = ""
                B10$ = ""
        end if
    end if

    if moving$ = "right" then
        if B1$="loaded" then
                'print #game, "spriteimage bullet1 bulletone"
                print #game, "spritemovexy bullet1left 5 0"
                print #game, "spriteorient bullet1left mirror"
                print #game, "drawsprites"
                B1$ = ""
                B2$ = ""
                B3$ = ""
                B4$ = ""
                B5$ = ""
                B6$ = ""
                B7$ = ""
                B8$ = ""
                B9$ = ""
                B10$ = ""
        end if

        if B2$="loaded" then
                'print #game, "spriteimage bullet2 bullettwo"
                print #game, "spritemovexy bullet2left 5 0"
                print #game, "spriteorient bullet2left mirror"
                print #game, "drawsprites"
                B1$ = ""
                B2$ = ""
                B3$ = ""
                B4$ = ""
                B5$ = ""
                B6$ = ""
                B7$ = ""
                B8$ = ""
                B9$ = ""
                B10$ = ""
        end if


        if B3$="loaded" then
                'print #game, "spriteimage bullet3 bulletthree"
                print #game, "spritemovexy bullet3left 5 0"
                print #game, "spriteorient bullet3left mirror"
                print #game, "drawsprites"
                B1$ = ""
                B2$ = ""
                B3$ = ""
                B4$ = ""
                B5$ = ""
                B6$ = ""
                B7$ = ""
                B8$ = ""
                B9$ = ""
                B10$ = ""
        end if


        if B4$="loaded" then
                'print #game, "spriteimage bullet4 bulletfour"
                print #game, "spritemovexy bullet4left 5 0"
                print #game, "spriteorient bullet4left mirror"
                print #game, "drawsprites"
                B1$ = ""
                B2$ = ""
                B3$ = ""
                B4$ = ""
                B5$ = ""
                B6$ = ""
                B7$ = ""
                B8$ = ""
                B9$ = ""
                B10$ = ""
        end if


        if B5$="loaded" then
                'print #game, "spriteimage bullet5 bulletfive"
                print #game, "spritemovexy bullet5left 5 0"
                print #game, "spriteorient bullet5left mirror"
                print #game, "drawsprites"
                B1$ = ""
                B2$ = ""
                B3$ = ""
                B4$ = ""
                B5$ = ""
                B6$ = ""
                B7$ = ""
                B8$ = ""
                B9$ = ""
                B10$ = ""
        end if


        if B6$="loaded" then
                'print #game, "spriteimage bullet6 bulletsix"
                print #game, "spritemovexy bullet6left 5 0"
                print #game, "spriteorient bullet6left mirror"
                print #game, "drawsprites"
                B1$ = ""
                B2$ = ""
                B3$ = ""
                B4$ = ""
                B5$ = ""
                B6$ = ""
                B7$ = ""
                B8$ = ""
                B9$ = ""
                B10$ = ""
        end if


        if B7$="loaded" then
                'print #game, "spriteimage bullet7 bulletseven"
                print #game, "spritemovexy bullet7left 5 0"
                print #game, "spriteorient bullet7left mirror"
                print #game, "drawsprites"
                B1$ = ""
                B2$ = ""
                B3$ = ""
                B4$ = ""
                B5$ = ""
                B6$ = ""
                B7$ = ""
                B8$ = ""
                B9$ = ""
                B10$ = ""
        end if


        if B8$="loaded" then
                'print #game, "spriteimage bullet8 bulleteight"
                print #game, "spritemovexy bullet8left 5 0"
                print #game, "spriteorient bullet8left mirror"
                print #game, "drawsprites"
                B1$ = ""
                B2$ = ""
                B3$ = ""
                B4$ = ""
                B5$ = ""
                B6$ = ""
                B7$ = ""
                B8$ = ""
                B9$ = ""
                B10$ = ""
        end if


        if B9$="loaded" then
                'print #game, "spriteimage bullet9 bulletnine"
                print #game, "spritemovexy bullet9left 5 0"
                print #game, "spriteorient bullet9left mirror"
                print #game, "drawsprites"
                B1$ = ""
                B2$ = ""
                B3$ = ""
                B4$ = ""
                B5$ = ""
                B6$ = ""
                B7$ = ""
                B8$ = ""
                B9$ = ""
                B10$ = ""
        end if


        if B10$="loaded" then
                'print #game, "spriteimage bullet10 bulletten"
                print #game, "spritemovexy bullet10left 5 0"
                print #game, "spriteorient bullet10left mirror"
                print #game, "drawsprites"
                B1$ = ""
                B2$ = ""
                B3$ = ""
                B4$ = ""
                B5$ = ""
                B6$ = ""
                B7$ = ""
                B8$ = ""
                B9$ = ""
                B10$ = ""
        end if
    end if
    if rapidfire$ = "on" then
        rapidfiretime = rapidfiretime + 1
        for i = 1 to 10
        print #game, "spritecollides bullet";i
        input #game, bulletcollides$
        if bulletcollides$ = "asteroid" then
            print #game, "spritevisible asteroid off"
            playwave "SFX\score.wav", async
            print "Good shot! +1 point!"
            score = score + 1
            loadedAsteroid$ = "false"
            bulletcollides$ = ""
        end if
        next
        if rapidfiretime >= 70 then
            return
        end if
    else
        return
    end if

    [shoot]
    if SFX$ = "On" then
        playwave "SFX\shoot.wav", async
    end if
    if moving$ = "up" then
        if sprite$ = "bulletten" then'
            if B10$<>"loaded" then    '
                print #game, "spriteimage bullet10 bulletten"
                print #game, "spritexy bullet10 ";bulletX+24; " ";bulletY-10
                print #game, "spriteorient bullet10 normal"
                print #game, "drawsprites"
                B10$ = "loaded"        '
            end if
            sprite$ = "bulletone"       '
            gosub [loadBullet]
        end if

        if sprite$ = "bulletnine" then
            if B9$<>"loaded" then
                print #game, "spriteimage bullet9 bulletnine"
                print #game, "spritexy bullet9 ";bulletX+24; " ";bulletY-10
                print #game, "spriteorient bullet9 normal"
                print #game, "drawsprites"
                B9$ = "loaded"
            end if
            sprite$ = "bulletten"
        end if

        if sprite$ = "bulleteight" then
            if B8$<>"loaded" then
                print #game, "spriteimage bullet8 bulleteight"
                print #game, "spritexy bullet8 ";bulletX+24; " ";bulletY-10
                print #game, "spriteorient bullet8 normal"
                print #game, "drawsprites"
                B8$ = "loaded"
            end if
            sprite$ = "bulletnine"
        end if

        if sprite$ = "bulletseven" then
            if B7$<>"loaded" then
                print #game, "spriteimage bullet7 bulletseven"
                print #game, "spritexy bullet7 ";bulletX+24; " ";bulletY-10
                print #game, "spriteorient bullet7 normal"
                print #game, "drawsprites"
                B7$ = "loaded"
            end if
            sprite$ = "bulleteight"
        end if

        if sprite$ = "bulletsix" then
            if B6$<>"loaded" then
                print #game, "spriteimage bullet6 bulletsix"
                print #game, "spritexy bullet6 ";bulletX+24; " ";bulletY-10
                print #game, "spriteorient bullet6 normal"
                print #game, "drawsprites"
                B6$ = "loaded"
            end if
            sprite$ = "bulletseven"
        end if

        if sprite$ = "bulletfive" then
            if B5$<>"loaded" then
                print #game, "spriteimage bullet5 bulletfive"
                print #game, "spritexy bullet5 ";bulletX+24; " ";bulletY-10
                print #game, "spriteorient bullet5 normal"
                print #game, "drawsprites"
                B5$ = "loaded"
            end if
            sprite$ = "bulletsix"
        end if

        if sprite$ = "bulletfour" then
            if B4$<>"loaded" then
                print #game, "spriteimage bullet4 bulletfour"
                print #game, "spritexy bullet4 ";bulletX+24; " ";bulletY-10
                print #game, "spriteorient bullet4 normal"
                print #game, "drawsprites"
                B4$ = "loaded"
            end if
            sprite$ = "bulletfive"
        end if

        if sprite$ = "bulletthree" then
            if B3$<>"loaded" then
                print #game, "spriteimage bullet3 bulletthree"
                print #game, "spritexy bullet3 ";bulletX+24; " ";bulletY-10
                print #game, "spriteorient bullet3 normal"
                print #game, "drawsprites"
                B3$ = "loaded"
            end if
            sprite$ = "bulletfour"
        end if

        if sprite$ = "bullettwo" then
            if B2$<>"loaded" then
                print #game, "spriteimage bullet2 bullettwo"
                print #game, "spritexy bullet2 ";bulletX+24; " ";bulletY-10
                print #game, "spriteorient bullet2 normal"
                print #game, "drawsprites"
                B2$ = "loaded"
            end if
            sprite$ = "bulletthree"
        end if

        if sprite$ = "bulletone" then
            if B1$<>"loaded" then
                print #game, "spriteimage bullet1 bulletone"
                print #game, "spritexy bullet1 ";bulletX+24; " ";bulletY-10
                print #game, "spriteorient bullet1 normal"
                print #game, "drawsprites"
                B1$ = "loaded"
            end if
            sprite$ = "bullettwo"
        end if
    end if

    if moving$ = "left" then
        if sprite$ = "bulletten" then'
            if B10$<>"loaded" then    '
                'print #game, "spriteimage bullet10 bulletten"
                print #game, "spritexy bullet10left ";bulletX-5; " ";bulletY+18
                print #game, "spriteorient bullet10left normal"
                print #game, "drawsprites"
                B10$ = "loaded"
            end if
            sprite$ = "bulletone"
            goto [loadBullet]
        end if

        if sprite$ = "bulletnine" then
            if B9$<>"loaded" then
                'print #game, "spriteimage bullet9 bulletnine"
                print #game, "spritexy bullet9left ";bulletX-5; " ";bulletY+18
                print #game, "spriteorient bullet9left normal"
                print #game, "drawsprites"
                B9$ = "loaded"
            end if
            sprite$ = "bulletten"
        end if

        if sprite$ = "bulleteight" then
            if B8$<>"loaded" then
                'print #game, "spriteimage bullet8 bulleteight"
                print #game, "spritexy bullet8left ";bulletX-5; " ";bulletY+18
                print #game, "spriteorient bullet8left normal"
                print #game, "drawsprites"
                B8$ = "loaded"
            end if
            sprite$ = "bulletnine"
        end if

        if sprite$ = "bulletseven" then
            if B7$<>"loaded" then
                'print #game, "spriteimage bullet7 bulletseven"
                print #game, "spritexy bullet7left ";bulletX-5; " ";bulletY+18
                print #game, "spriteorient bullet7left normal"
                print #game, "drawsprites"
                B7$ = "loaded"
            end if
            sprite$ = "bulleteight"
        end if

        if sprite$ = "bulletsix" then
            if B6$<>"loaded" then
                'print #game, "spriteimage bullet6 bulletsix"
                print #game, "spritexy bullet6left ";bulletX-5; " ";bulletY+18
                print #game, "spriteorient bullet6left normal"
                print #game, "drawsprites"
                B6$ = "loaded"
            end if
            sprite$ = "bulletseven"
        end if

        if sprite$ = "bulletfive" then
            if B5$<>"loaded" then
                'print #game, "spriteimage bullet5 bulletfive"
                print #game, "spritexy bullet5left ";bulletX-5; " ";bulletY+18
                print #game, "spriteorient bullet5left normal"
                print #game, "drawsprites"
                B5$ = "loaded"
            end if
            sprite$ = "bulletsix"
        end if

        if sprite$ = "bulletfour" then
            if B4$<>"loaded" then
                'print #game, "spriteimage bullet4 bulletfour"
                print #game, "spritexy bullet4left ";bulletX-5; " ";bulletY+18
                print #game, "spriteorient bullet4left normal"
                print #game, "drawsprites"
                B4$ = "loaded"
            end if
            sprite$ = "bulletfive"
        end if

        if sprite$ = "bulletthree" then
            if B3$<>"loaded" then
                'print #game, "spriteimage bullet3 bulletthree"
                print #game, "spritexy bullet3left ";bulletX-5; " ";bulletY+18
                print #game, "spriteorient bullet3left normal"
                print #game, "drawsprites"
                B3$ = "loaded"
            end if
            sprite$ = "bulletfour"
        end if

        if sprite$ = "bullettwo" then
            if B2$<>"loaded" then
                'print #game, "spriteimage bullet2 bullettwo"
                print #game, "spritexy bullet2left ";bulletX-5; " ";bulletY+18
                print #game, "spriteorient bullet2left normal"
                print #game, "drawsprites"
                B2$ = "loaded"
            end if
            sprite$ = "bulletthree"
        end if

        if sprite$ = "bulletone" then
            if B1$<>"loaded" then
                'print #game, "spriteimage bullet1 bulletone"
                print #game, "spritexy bullet1left ";bulletX-5; " ";bulletY+18
                print #game, "spriteorient bullet1left normal"
                print #game, "drawsprites"
                B1$ = "loaded"
            end if
            sprite$ = "bullettwo"
        end if
    end if

    if moving$ = "down" then
        if sprite$ = "bulletten" then'
            if B10$<>"loaded" then    '
                print #game, "spriteimage bullet10 bulletten"
                print #game, "spritexy bullet10 ";bulletX+22; " ";bulletY+50
                print #game, "spriteorient bullet10 flip"
                print #game, "drawsprites"
                B10$ = "loaded"
            end if
            sprite$ = "bulletone"
            goto [loadBullet]
        end if

        if sprite$ = "bulletnine" then
            if B9$<>"loaded" then
                print #game, "spriteimage bullet9 bulletnine"
                print #game, "spritexy bullet9 ";bulletX+22; " ";bulletY+50
                print #game, "spriteorient bullet9 flip"
                print #game, "drawsprites"
                B9$ = "loaded"
            end if
            sprite$ = "bulletten"
        end if

        if sprite$ = "bulleteight" then
            if B8$<>"loaded" then
                print #game, "spriteimage bullet8 bulleteight"
                print #game, "spritexy bullet8 ";bulletX+22; " ";bulletY+50
                print #game, "spriteorient bullet8 flip"
                print #game, "drawsprites"
                B8$ = "loaded"
            end if
            sprite$ = "bulletnine"
        end if

        if sprite$ = "bulletseven" then
            if B7$<>"loaded" then
                print #game, "spriteimage bullet7 bulletseven"
                print #game, "spritexy bullet7 ";bulletX+22; " ";bulletY+50
                print #game, "spriteorient bullet7 flip"
                print #game, "drawsprites"
                B7$ = "loaded"
            end if
            sprite$ = "bulleteight"
        end if

        if sprite$ = "bulletsix" then
            if B6$<>"loaded" then
                print #game, "spriteimage bullet6 bulletsix"
                print #game, "spritexy bullet6 ";bulletX+22; " ";bulletY+50
                print #game, "spriteorient bullet6 flip"
                print #game, "drawsprites"
                B6$ = "loaded"
            end if
            sprite$ = "bulletseven"
        end if

        if sprite$ = "bulletfive" then
            if B5$<>"loaded" then
                print #game, "spriteimage bullet5 bulletfive"
                print #game, "spritexy bullet5 ";bulletX+22; " ";bulletY+50
                print #game, "spriteorient bullet5 flip"
                print #game, "drawsprites"
                B5$ = "loaded"
            end if
            sprite$ = "bulletsix"
        end if

        if sprite$ = "bulletfour" then
            if B4$<>"loaded" then
                print #game, "spriteimage bullet4 bulletfour"
                print #game, "spritexy bullet4 ";bulletX+22; " ";bulletY+50
                print #game, "spriteorient bullet4 flip"
                print #game, "drawsprites"
                B4$ = "loaded"
            end if
            sprite$ = "bulletfive"
        end if

        if sprite$ = "bulletthree" then
            if B3$<>"loaded" then
                print #game, "spriteimage bullet3 bulletthree"
                print #game, "spritexy bullet3 ";bulletX+22; " ";bulletY+50
                print #game, "spriteorient bullet3 flip"
                print #game, "drawsprites"
                B3$ = "loaded"
            end if
            sprite$ = "bulletfour"
        end if

        if sprite$ = "bullettwo" then
            if B2$<>"loaded" then
                print #game, "spriteimage bullet2 bullettwo"
                print #game, "spritexy bullet2 ";bulletX+22; " ";bulletY+50
                print #game, "spriteorient bullet2 flip"
                print #game, "drawsprites"
                B2$ = "loaded"
            end if
            sprite$ = "bulletthree"
        end if

        if sprite$ = "bulletone" then
            if B1$<>"loaded" then
                print #game, "spriteimage bullet1 bulletone"
                print #game, "spritexy bullet1 ";bulletX+22; " ";bulletY+50
                print #game, "spriteorient bullet1 flip"
                print #game, "drawsprites"
                B1$ = "loaded"
            end if
            sprite$ = "bullettwo"
        end if
    end if

    if moving$ = "right" then
        if sprite$ = "bulletten" then'
            if B10$<>"loaded" then    '
                'print #game, "spriteimage bullet10 bulletten"
                print #game, "spritexy bullet10left ";bulletX+53; " ";bulletY+22
                print #game, "spriteorient bullet10left mirror"
                print #game, "drawsprites"
                B10$ = "loaded"
            end if
            sprite$ = "bulletone"
            goto [loadBullet]
        end if

        if sprite$ = "bulletnine" then
            if B9$<>"loaded" then
                'print #game, "spriteimage bullet9 bulletnine"
                print #game, "spritexy bullet9left ";bulletX+53; " ";bulletY+22
                print #game, "spriteorient bullet9left mirror"
                print #game, "drawsprites"
                B9$ = "loaded"
            end if
            sprite$ = "bulletten"
        end if

        if sprite$ = "bulleteight" then
            if B8$<>"loaded" then
                'print #game, "spriteimage bullet8 bulleteight"
                print #game, "spritexy bullet8left ";bulletX+53; " ";bulletY+22
                print #game, "spriteorient bullet8left mirror"
                print #game, "drawsprites"
                B8$ = "loaded"
            end if
            sprite$ = "bulletnine"
        end if

        if sprite$ = "bulletseven" then
            if B7$<>"loaded" then
                'print #game, "spriteimage bullet7 bulletseven"
                print #game, "spritexy bullet7left ";bulletX+53; " ";bulletY+22
                print #game, "spriteorient bullet7left mirror"
                print #game, "drawsprites"
                B7$ = "loaded"
            end if
            sprite$ = "bulleteight"
        end if

        if sprite$ = "bulletsix" then
            if B6$<>"loaded" then
                'print #game, "spriteimage bullet6 bulletsix"
                print #game, "spritexy bullet6left ";bulletX+53; " ";bulletY+22
                print #game, "spriteorient bullet6left mirror"
                print #game, "drawsprites"
                B6$ = "loaded"
            end if
            sprite$ = "bulletseven"
        end if

        if sprite$ = "bulletfive" then
            if B5$<>"loaded" then
                'print #game, "spriteimage bullet5 bulletfive"
                print #game, "spritexy bullet5left ";bulletX+53; " ";bulletY+22
                print #game, "spriteorient bullet5left mirror"
                print #game, "drawsprites"
                B5$ = "loaded"
            end if
            sprite$ = "bulletsix"
        end if

        if sprite$ = "bulletfour" then
            if B4$<>"loaded" then
                'print #game, "spriteimage bullet4 bulletfour"
                print #game, "spritexy bullet4left ";bulletX+53; " ";bulletY+22
                print #game, "spriteorient bullet4left mirror"
                print #game, "drawsprites"
                B4$ = "loaded"
            end if
            sprite$ = "bulletfive"
        end if

        if sprite$ = "bulletthree" then
            if B3$<>"loaded" then
                'print #game, "spriteimage bullet3 bulletthree"
                print #game, "spritexy bullet3left ";bulletX+53; " ";bulletY+22
                print #game, "spriteorient bullet3left mirror"
                print #game, "drawsprites"
                B3$ = "loaded"
            end if
            sprite$ = "bulletfour"
        end if

        if sprite$ = "bullettwo" then
            if B2$<>"loaded" then
                'print #game, "spriteimage bullet2 bullettwo"
                print #game, "spritexy bullet2left ";bulletX+53; " ";bulletY+22
                print #game, "spriteorient bullet2left mirror"
                print #game, "drawsprites"
                B2$ = "loaded"
            end if
            sprite$ = "bulletthree"
        end if

        if sprite$ = "bulletone" then
            if B1$<>"loaded" then
                'print #game, "spriteimage bullet1 bulletone"
                print #game, "spritexy bullet1left ";bulletX+53; " ";bulletY+22
                print #game, "spriteorient bullet1left mirror"
                print #game, "drawsprites"
                B1$ = "loaded"
            end if
            sprite$ = "bullettwo"
        end if
    end if
    wait

    [mainMenuButtonClicked]

        mainMenuButtonClicked = 1
        goto [quitToMenu]
        wait


[Pause]
    paused = 1

    print #game, "background paused"
    print #game, "drawsprites"

    if mainMenuButtonClicked = 1 then
        mainMenuButtonClicked = 0
    end if
    if noticeGiven = 0 then
        notice "Game paused, press "+ "r" + " to resume the game."
    end if

    'Store data in temporary variables
    TempshipX = shipX
    TempshipY = shipY
    TempbulletX = bulletX
    TempbulletY = bulletY
    Tempvelx = velx
    Tempvely = vely
    Tempx = x
    Tempy = y

    'Stop motion
    shipX = shipX
    shipY = shipY
    bulletX = bulletX
    bulletY = bulletY
    velx = velx
    vely = vely
    x = x
    y = y


    'preserve the location of all sprites and everything going on in the game
    wait

[endPause]

    'reload the variables
    shipX = TempshipX
    shipY = TempshipY
    bulletX = TempbulletX
    bulletY = TempbulletY
    velx = Tempvelx
    vely = Tempvely
    x = Tempx
    y = Tempy

    'reset temporary variables
    TempshipX = 0
    TempshipY = 0
    TempbulletX = 0
    TempbulletY = 0
    Tempvelx = 0
    Tempvely = 0
    Tempx = 0
    Tempy = 0
    paused = 0

    print #game, "background bg"
    print #game, "drawsprites"

    wait


[About]

    notice "About" + chr$(13) + "SpaceBlast (C)' 2013 - 2014"
    wait

[Save]
    TempshipX = shipX
    TempshipY = shipY
    TempbulletX = bulletX
    TempbulletY = bulletY
    Tempvelx = velx
    Tempvely = vely
    Tempx = x
    Tempy = y
    SavedGame = 1
    open "SaveFiles/save.save" for output as #save
    print #save, "shipX: ";shipX
    print #save, "shipY: ";shipY
    print #save, "bulletX: ";bulletX
    print #save, "bulletY: ";bulletY
    print #save, "velx: ";velx
    print #save, "vely: ";vely
    print #save, "x: ";x
    print #save, "y: ";y
    close #save
    notice "Save successful!"
    notice "Leaving to menu..."
    goto [MainMenu]

[Load]
    if paused = 0 then 'i changed the 1 to a zero on 11/27/13
        filedialog "choose a .save to load", "SaveFiles\*.save",savefile$
            if savefile$ <> "" then
                open savefile$ for random as #load LEN=76


            else
                notice "Load Aborted!"
                BEEP
            end if
    end if
    SavedGame = 0

[mouseMotion]
    if MouseMotion$ = "On" then
        shipX = MouseX
        shipY = MouseY
        print #main, "spritexy cursor ";shipX; " ";shipY
        print #main, "drawsprites"
        goto 6 'continue
    else
        useGameLabel = 1
        goto [timeTicked]
    end if


[Score]
    print #game.score, "!enable"
    print #game.score, "Score: ";score
    print #game, "drawsprites"
    return

[changeWindowSize]
    'back up the previous values early in case of error
    TempWidth = WindowWidth
    TempHeight = WindowHeight
    if resize = 0 then
        newwidth = 500
        newheight = 500
    end if
    WindowWidth = 500
    WindowHeight = 500

    confirm "You want to change the window/display size";anwser$
    if anwser$ = "yes" then

        WindowWidth = 500
        WindowHeight = 250

        statictext #window, "X-Position", 135, 38, 100, 30
        textbox #window.xpos, 150, 80, 30, 55
        statictext #window, "Y-Position", 255, 38, 100, 30
        textbox #window.ypos, 270, 80, 30, 55
        loadbmp "WindowResizeBackground", "backgrounds\window_resize_background.bmp"
        button #window, "RESIZE", [windowResize], UL, 195, 100, 50, 150

        open "Window Resize" for graphics_nsb_nf AS #window
        print #window, "down"
        print #window, "font times_new_roman 14 bold"
        print #window, "flush"
        print #window, "trapclose [windowQuit]"
    end if
    wait


[windowQuit]
    fromMenu = 0
    fromGame = 0
    close #window
    wait

[windowResize]
    print #window.xpos, "!contents? ";newwidthr$
    print #window.ypos, "!contents? ";newheightr$

    width = val(newwidthr$)
    height = val(newheightr$)

    WindowWidth = width
    WindowHeight = height

    notice "Window Resize Complete!"
    resized = 1

    'if there was an error
    if WindowWidth = 0 then
        if WindowHeight = 0 then
           WindowHeight = TempHeight
           WindowWidth = TempWidth
        end if
    end if

    if WindowHeight = 0 then
        if WindowWidth = 0 then
            WindowWidth = TempWidth
            WindowHeight = TempHeight
        end if
    end if

    goto [windowQuit]
    wait

[updateGame]
    if fromSettings = 1 then
        if musicState$ = "On" then
            if music$ <> "" then
                playwave music$, loop
            else
                if musicState$ <> "On" then
                    playmidi "SFX\music.mid", async
                end if
            end if
        else
            playmidi "SFX\music.mid", async
            musicState$ = "On"
        end if
        fromSettings = 0
    end if
    wait

[changeCursor]
    if cursorChanged = 1 then
        print ChangeCursor(cursor$)
        print ChangeCursor(cursor$)
    end if
    wait

[startCheatCodeValidator]
    WindowWidth=DisplayWidth
    WindowHeight=DisplayHeight
    if cheatCodeValidator$ <> "Closed" then
        if cheatCodeValidator$ <> "" then
            close #cheat
        end if
    end if
    if gameIsOpen$ = "true" then
        WindowWidth = 500
        WindowHeight = 600
    end if
    textbox #cheat.code, 0, 0, WindowWidth, 300
    button #cheat.validate, "Validate", [cheatCodeValidator], LL, 0, 400, WindowWidth, 600
    open "Cheat Code Validator" for graphics_nsb_nf as #cheat
    print #cheat, "trapclose [closeCheatCodeWindow]"
    cheatCodeValidator$ = "Open"
    wait

[clearCode]
    print #cheat.code, "!enable"
    print #cheat.code, "!selectall"
    print #cheat.code, "!Cls"
    wait

[cheatCodeValidator]
    print #cheat.code, "!contents? code$"

    select case code$
        case "XYZ"
            gosub [checkCode]
            if codeValid$ = "true" then
                if codeXYZ$ <> "used" then
                    boost = boost + 10
                    print boost
                    print #cheat.code, " -- Code Valid! -- , plus 10 boost!"
                end if
            codeXYZ$ = "used"
            end if

        case "1x349B"
            gosub [checkCode]
            if codeValid$ = "true" then
                if code1x349B$ <> "used" then
                    lives = lives + 1
                    print lives
                    print #cheat.code, " -- Code Valid! -- , +1 health"
                end if
            code1x349B$ = "used"
            end if

        case "4949258"
            gosub [checkCode]
            if codeValid$ = "true" then
                if code4949258$ <> "used" then
                    score = score + 10
                    print score
                    print #cheat.code, " -- Code Valid! -- , extra 10 points *dont tell anyone B)*"
                end if
            code4949258$ = "used"
            end if

       case "rapidfire"
            gosub [checkCode]
            if codeValid$ = "true" then
                if coderapidfire$ <> "used" then
                    rapidfire$ = "on"
                    print rapidfire$
                    print #cheat.code, " -- Code Valid! -- , Shooting set to rapid fire! right click to activate it."
                end if
            coderapidfire$ = "used"
            end if

       case "regularfire"
            gosub [checkCode]
            if codeValid$ = "true" then
                if coderegularfire$ <> "used" then
                    rapidfire$ = "off"
                    regularfire$ = "on"
                    print rapidfire$
                    print regularfire$
                    print #cheat.code, " -- Code Valid! -- , Shooting set to normal fire"
                end if
            coderegularfire$ = "used"
            end if

        'add new codes here

        case else
            print #cheat.code," -- Code Invalid! -- "
    end select
    codeValid$ = ""
    wait

[checkCode]
    codeIdentity$ = "code"; "";code$; "$"
    open "codeslog.txt" for APPEND as #getcodes
    if codenum > 1 then
        if instr(entries, " --*") <> 0 then
            print #getcodes, ""
        end if
    else
        if codenum <= 1 then
            print #getcodes, ""
            print #getcodes, "---------- ";date$() ;": "; time$(); "----------"
        end if
    end if


    print #getcodes, codenum; ". -- ";code$ ;" --*"
    close #getcodes

        if codeIdentity$ = "used" then
            codeValid$ = "false"
        else
            codeValid$ = "true"
            codenum = codenum + 1
        end if
    return

[closeCheatCodeWindow]
    close #cheat
    cheatCodeValidator$ = "Closed"
    WindowWidth=DisplayWidth
    WindowHeight=DisplayHeight
    wait

[CollisionDetection]
    'Ship to Asteroids
    if invincible <= 50 then
        if invincible >= 1 then
            invincible = invincible - 1
        else
            print #game, "spritecollides ship ";
            input #game, shipcollides$
            if shipcollides$ = "asteroid" then
                if SFX$ = "On" then
                    playwave "SFX\damage.wav", async
                end if
                print "Hit! -1 health"
                health = health - 1
                print #game, "spriteimage ship ship_damage"
                print #game, "spritevisible asteroid off"
                print #game, "drawsprites"
                shipcollides$ = ""
             end if
        end if
    end if


    'Bullet to Asteroids
        rapidfiretime = rapidfiretime + 1
        for i = 1 to 10
        print #game, "spritecollides bullet";i
        input #game, bulletcollides$
        if bulletcollides$ = "asteroid" then
            print #game, "spritevisible asteroid off"
            playwave "SFX\score.wav", async
            print "Good shot! +1 point!"
            score = score + 1
            loadedAsteroid$ = "false"
            bulletcollides$ = ""
        end if
        next
    return

[Music]
    if music$ <> "" then
        confirm "would you like to change the music back to the default track?";musicbacktodefault$
        if musicbacktodefault$ = "yes" then
            music$ = ""
            playwave "SFX\music.wav"
            musicState$ = "On"
        else
            goto 5
        end if
    else
5       filedialog "Open a .wav file to play", "music\*.wav", music$
        if music$ = "" then
            notice "music change aborted!"
        else
            playwave music$, loop
        end if
    musicState$ = "On"
    if fromSettings = 1 then
        print #set.music, "reset"
    end if
    wait

[toggleMusic]
    print #set.music, "reset"
    if musicState$ = "" then
        musicState$ = "Off"
    end if

    if musicState$ = "Off" then
        musicState$ = "On"
        if music$ <> "" then
            playwave music$, loop
        end if
        if musicStarted = 0 then
            playwave "SFX\music.wav", loop
            musicStarted = 1
        end if

    if musicState$ = "On" then
        musicState$ = "Off"
        playwave ""
        if fromGame = 1 then goto [timeTicked]
    end if

    end if
    if fromSettings = 1 then
        print #set.music, "set"
        end if
    end if

    wait

[musicOFF]
    print #set.music, "set"
    playwave ""
    if gameIsOpen = 1 then stopmidi
    noMusic = 1


[rapidFire]
    if fromSettings = 1 then
        print #set.rapidfire,"reset"
    end if
    if rapidfire$ = "off" then
        if fromSettings = 1 then
            rapidfiretime = 0
            fromSettings = 0
            rapidfire$ = "on"
        end if
    end if
    if rapidfire$ ="on" then
        rapidfiretime = 0
    end if
    if rapidfire$ =""then
        rapidfiretime = 0
    end if
    wait

[rapidFireOFF]
    rapidfire$ = "off"
    print #set.rapidfire, "set"
    wait

[SFXOFF]
    SFX$ = "Off"
    print #set.SFX, "set"
    wait

[SFXON]
    SFX$ = "On"
    print #set.SFX, "reset"
    wait

[powerupsOFF]
    powerupsMode = 0
    wait

[powerups]
    powerupsMode = 1
    wait

[Settings]
    if Settings$ <> "Closed" then
        if Settings$ <> "" then
            close #set
        end if
    end if
    musicState$ = "On"
    WindowWidth=100
    WindowHeight=300
    UpperLeftX=300
    UpperLeftY=100
    checkbox #set.music, "Music OFF", [musicOFF], [toggleMusic], 5, 5, 100, 50
    checkbox #set.SFX, "SFX OFF", [SFXOFF], [SFXON], 5, 45, 100, 50
    checkbox #set.rapidfire, "RapidFire OFF", [rapidFireOFF], [rapidFire], 5, 95, 110, 50
    button #set.keys, "Change game keys", [changeKeys], UL, 5, 145, 120, 20
    checkbox #set.powerups, "Powerups OFF", [powerupsOFF], [powerups], 5, 145, 160, 50
    open "Settings" for graphics_nsb_nf as #set
    print #set, "trapclose [closeSettings]"
    if coderapidfire$ <> "used" then
        print #set.rapidfire, "disable"
    end if
    if gameIsOpen <> 1 then
        print #set.music, "disable"
    end if
    fromSettings = 1
    Settings$ = "Open"
    wait

[closeSettings]
    Settings$ = "Closed"
    close #set
    WindowWidth=DisplayWidth
    WindowHeight=DisplayHeight
    wait

[chooseTexturePack]
    loadbmp "texbg", "backgrounds\menuBG.bmp"
    bmpbutton #tex.classic, "media\texpack_classic_image.bmp", [classicPack], UL, 150, 50
    bmpbutton #tex.proxi, "media\texpack_proxi_image.bmp", [proxiPack], UL, DisplayWidth-620, 50
    textbox #tex.packname, 550, 600, 300, 50
    button #tex.usepack, "Use this pack!", [UDPack], UL, 550, 650, 300, 50
    open "Choose a Texture Pack" for graphics_nsb_nf as #tex
    print #tex, "background texbg"
    print #tex, "drawsprites"
    print #tex, "setfocus"
    wait

    [classicPack]
        close #tex
        print packname$("")
        gosub [setTexPack]
        goto 10

    [proxiPack]
        close #tex
        print packname$("proxi")
        gosub [setTexPack]
        goto 10

    [UDPack]
        print packname$("UD")'userdefined
        gosub [setTexPack]
        goto 10

    [setTexPack]
    if packname$ <> "" then packname$ = packname$;"_"
    if packname$ = "UD_" then
        print #tex.packname, "!contents? pack$"
        if pack$ <> "" then
            packname$ = pack$;"_"
            close #tex
        else
            BEEP
            notice "No pack defined!"
        end if
    end if
    print setsprites$()
    goto 10
    wait

    [loadPowerups]
    'shrink
    '10 boost
    'invincible
    'full health
    'cheat code or + 20 points!
        if powerupMode = 1 then
            'choose a random powerup to render
            poweruptype = int(rnd(1)*75)-1
            'choose a random position
            powerupX = int(rnd(1)*WindowWidth)-1
            powerupY = int(rnd(1)*WindowHeight)-1
            'render the powerup
            print renderPowerup(poweruptype, powerupX, powerupY)
            print "AT LOADPUWERUP!!!!"
            print #game, "spritecollides ship shippowerupcollides$";
            print shippowerupcollides$
            if shippowerupcollides$ = "shrink" then
                print #game, "spritescale ship 50 50"
                print #game, "drawsprites"
                print #game, "spritevisible shrink off"
                print #game, "drawsprites"
            end if

            if shippowerupcollides$ = "10boost" then
                boost = boost + 10
                print #game, "spritevisible 10boost off"
                print #game, "drawsprites"
            end if

            if shippowerupcollides$ = "invincible" then
                if invincible = 0 then
                    invincible = 50
                end if
                print #game, "spritevisible invincible off"
                print #game, "drawsprites"
            end if

            if shippowerupcollides$ = "fullhealth" then
                health = 5
                print #game, "spritevisible fullhealth off"
                print #game, "drawsprites"
            end if

            if shippowerupcollides$ = "frozen" then
                frozen = 50
                print #game, "spritevisible frozen off"
                print #game, "drawsprites"
            end if
        end if
        return

[changeKeys]
    upKeyResponce$ = upKey$
    prompt "Change Keys" + chr$(13) + "Choose a key for up..."; upKeyResponce$
    upKey$ = upKeyResponce$
    downKeyResponce$ = downKey$
    prompt "Change Keys" + chr$(13) + "Choose a key for down..."; downKeyResponce$
    downKey$ = downKeyResponce$
    leftKeyResponce$ = leftKey$
    prompt "Change Keys" + chr$(13) + "Choose a key for left..."; leftKeyResponce$
    leftKey$ = leftKeyResponce$
    rightKeyResponce$ = rightKey$
    prompt "Change Keys" + chr$(13) + "Choose a key for right..."; rightKeyResponce$
    rightKey$ = rightKeyResponce$
    notice "The keys have been changed!"
    if fromGame = 1 then goto [timeTicked]
    wait

'functions
'-----------------------

function score(addpoints, subtractpoints)
    score = score + addpoints
    score = score - subtractpoints
end function

function window(width, height)
    WindowWidth = width
    WindowHeight = height
end function

function ChangeCursor(cursor$)
    filedialog "Open new cursor", "cursors/*.bmp",cursordir$
    if (cursordir$ = "") then
        notice "cursor change aborted by user."
    end if
    loadbmp cursor$, cursordir$
    print #main, "drawsprites"
end function

function newsprite$(spritename$, spritebmp$)
    print #game, "addsprite ";spritename$;" ";spritebmp$
end function

function packname$(packnamenew$)
    packname$ = packnamenew$
end function

function setsprites$()'maybe they should onlybe requireto have a ship on and offforall four directions, an asteroid, and possibly some boost sprites for theirpck towork in the game?
    open "" for graphics_nsb_nf as #loading

    loadbmp "loading1", "backgrounds\loading1.bmp"
    print #loading, "background loading1"
    print #loading, "drawsprites"
    'sprites
    loadbmp "ship_up", "sprites\";packname$;"ship_up.bmp"
    loadbmp "ship_up_damage_1", "sprites\ship_up_damage_1.bmp"
    loadbmp "ship_up_damage_2", "sprites\ship_up_damage_2.bmp"
    loadbmp "ship_up_damage_3", "sprites\ship_up_damage_3.bmp"
    loadbmp "ship_up_damage_4", "sprites\ship_up_damage_4.bmp"
    loadbmp "ship_up_on", "sprites\";packname$;"ship_up_on.bmp"
    loadbmp "ship_up_on_damage_1", "sprites\ship_up_on_damage_1.bmp"
    loadbmp "ship_up_on_damage_2", "sprites\ship_up_on_damage_2.bmp"
    loadbmp "ship_up_on_damage_3", "sprites\ship_up_on_damage_3.bmp"
    loadbmp "ship_up_on_damage_4", "sprites\ship_up_on_damage_4.bmp"

    loadbmp "loading2", "backgrounds\loading2.bmp"
    print #loading, "background loading2"
    print #loading, "drawsprites"
    loadbmp "ship_left", "sprites\";packname$;"ship_left.bmp"
    loadbmp "ship_left_damage_1", "sprites\ship_left_damage_1.bmp"
    loadbmp "ship_left_damage_2", "sprites\ship_left_damage_2.bmp"
    loadbmp "ship_left_damage_3", "sprites\ship_left_damage_3.bmp"
    loadbmp "ship_left_damage_4", "sprites\ship_left_damage_4.bmp"
    loadbmp "ship_left_on", "sprites\";packname$;"ship_left_on.bmp"
    loadbmp "ship_left_on_damage_1", "sprites\ship_left_on_damage_1.bmp"
    loadbmp "ship_left_on_damage_2", "sprites\ship_left_on_damage_2.bmp"
    loadbmp "ship_left_on_damage_3", "sprites\ship_left_on_damage_3.bmp"
    loadbmp "ship_left_on_damage_4", "sprites\ship_left_on_damage_4.bmp"

    loadbmp "loading3", "backgrounds\loading3.bmp"
    print #loading, "background loading3"
    print #loading, "drawsprites"
    loadbmp "ship_right",  "sprites\";packname$;"ship_right.bmp"
    loadbmp "ship_right_damage_1", "sprites\ship_right_damage_1.bmp"
    loadbmp "ship_right_damage_2", "sprites\ship_right_damage_2.bmp"
    loadbmp "ship_right_damage_3", "sprites\ship_right_damage_3.bmp"
    loadbmp "ship_right_damage_4", "sprites\ship_right_damage_4.bmp"
    loadbmp "ship_right_on", "sprites\";packname$;"ship_right_on.bmp"
    loadbmp "ship_right_on_damage_1", "sprites\ship_right_on_damage_1.bmp"
    loadbmp "ship_right_on_damage_2", "sprites\ship_right_on_damage_2.bmp"
    loadbmp "ship_right_on_damage_3", "sprites\ship_right_on_damage_3.bmp"
    loadbmp "ship_right_on_damage_4", "sprites\ship_right_on_damage_4.bmp"

    loadbmp "loading4", "backgrounds\loading4.bmp"
    print #loading, "background loading4"
    print #loading, "drawsprites"
    loadbmp "ship_down", "sprites\";packname$;"ship_down.bmp"
    loadbmp "ship_down_damage_1", "sprites\ship_down_damage_1.bmp"
    loadbmp "ship_down_damage_2", "sprites\ship_down_damage_2.bmp"
    loadbmp "ship_down_damage_3", "sprites\ship_down_damage_3.bmp"
    loadbmp "ship_down_damage_4", "sprites\ship_down_damage_4.bmp"
    loadbmp "ship_down_on", "sprites\";packname$;"ship_down_on.bmp"
    loadbmp "ship_down_on_damage_1", "sprites\ship_down_on_damage_1.bmp"
    loadbmp "ship_down_on_damage_2", "sprites\ship_down_on_damage_2.bmp"
    loadbmp "ship_down_on_damage_3", "sprites\ship_down_on_damage_3.bmp"
    loadbmp "ship_down_on_damage_4", "sprites\ship_down_on_damage_4.bmp"

    loadbmp "loading5", "backgrounds\loading5.bmp"
    print #loading, "background loading5"
    print #loading, "drawsprites"
    loadbmp "asteroid", "sprites\";packname$;"asteroid.bmp"

    loadbmp "loading6", "backgrounds\loading6.bmp"
    print #loading, "background loading6"
    print #loading, "drawsprites"
    loadbmp "health(0)", "sprites\lives00.bmp"
    loadbmp "health(1)", "sprites\lives01.bmp"
    loadbmp "health(2)", "sprites\lives02.bmp"
    loadbmp "health(3)", "sprites\lives03.bmp"
    loadbmp "health(4)", "sprites\lives04.bmp"
    loadbmp "health(5)", "sprites\lives05.bmp"

    loadbmp "loading7", "backgrounds\loading7.bmp"
    print #loading, "background loading7"
    print #loading, "drawsprites"
    loadbmp "paused", "screens\pausescreen.bmp"
    loadbmp "start", "screens\startscreen.bmp"

    loadbmp "loading9", "backgrounds\loading9.bmp"
    print #loading, "background loading9"
    print #loading, "drawsprites"
    loadbmp "countdown1", "screens\startcountdown1.bmp"
    loadbmp "countdown2", "screens\startcountdown2.bmp"
    loadbmp "countdown3", "screens\startcountdown3.bmp"
    loadbmp "countdown4", "screens\startcountdown4.bmp"
    loadbmp "countdown5", "screens\startcountdown5.bmp"
    loadbmp "countdown6", "screens\startcountdown6.bmp"
    loadbmp "countdown7", "screens\startcountdown7.bmp"
    loadbmp "countdown8", "screens\startcountdown8.bmp"
    loadbmp "countdown9", "screens\startcountdown9.bmp"
    loadbmp "countdown10", "screens\startcountdown10.bmp"

    loadbmp "loading10", "backgrounds\loading10.bmp"
    print #loading, "background loading10"
    print #loading, "drawsprites"
    loadbmp "countdowntrans1", "screens\startcountdowntrans1.bmp"
    loadbmp "countdowntrans2", "screens\startcountdowntrans2.bmp"
    loadbmp "countdowntrans3", "screens\startcountdowntrans3.bmp"
    loadbmp "gameover", "screens\gameoverscreen.bmp"

    loadbmp "loading11", "backgrounds\loading11.bmp"
    print #loading, "background loading11"
    print #loading, "drawsprites"
    loadbmp "ship_boost_left", "sprites\";packname$;"ship_boost_left.bmp"
    loadbmp "ship_boost_left_damage_1", "sprites\ship_boost_left_damage_1.bmp"
    loadbmp "ship_boost_left_damage_2", "sprites\ship_boost_left_damage_2.bmp"
    loadbmp "ship_boost_left_damage_3", "sprites\ship_boost_left_damage_3.bmp"
    loadbmp "ship_boost_left_damage_4", "sprites\ship_boost_left_damage_4.bmp"

    loadbmp "ship_boost_right", "sprites\";packname$;"ship_boost_right.bmp"
    loadbmp "ship_boost_right_damage_1", "sprites\ship_boost_right_damage_1.bmp"
    loadbmp "ship_boost_right_damage_2", "sprites\ship_boost_right_damage_2.bmp"
    loadbmp "ship_boost_right_damage_3", "sprites\ship_boost_right_damage_3.bmp"
    loadbmp "ship_boost_right_damage_4", "sprites\ship_boost_right_damage_4.bmp"

    loadbmp "ship_boost_down", "sprites\";packname$;"ship_boost_down.bmp"
    loadbmp "ship_boost_up", "sprites\";packname$;"ship_boost_up.bmp"

    loadbmp "loading12", "backgrounds\loading12.bmp"
    print #loading, "background loading12"
    print #loading, "drawsprites"
    loadbmp "ship_destroyed", "sprites\ship_destroyed.bmp"

    loadbmp "boost25+", "sprites\boost_25+.bmp"
    loadbmp "boost25", "sprites\boost_25.bmp"
    loadbmp "boost24", "sprites\boost_24.bmp"
    loadbmp "boost23", "sprites\boost_23.bmp"
    loadbmp "boost22", "sprites\boost_22.bmp"
    loadbmp "boost21", "sprites\boost_21.bmp"
    loadbmp "boost20", "sprites\boost_20.bmp"
    loadbmp "boost19", "sprites\boost_19.bmp"
    loadbmp "boost18", "sprites\boost_18.bmp"
    loadbmp "boost17", "sprites\boost_17.bmp"
    loadbmp "boost16", "sprites\boost_16.bmp"
    loadbmp "boost15", "sprites\boost_15.bmp"
    loadbmp "boost14", "sprites\boost_14.bmp"
    loadbmp "boost13", "sprites\boost_13.bmp"
    loadbmp "boost12", "sprites\boost_12.bmp"
    loadbmp "boost11", "sprites\boost_11.bmp"
    loadbmp "boost10", "sprites\boost_10.bmp"
    loadbmp "boost09", "sprites\boost_09.bmp"
    loadbmp "boost08", "sprites\boost_08.bmp"
    loadbmp "boost07", "sprites\boost_07.bmp"
    loadbmp "boost06", "sprites\boost_06.bmp"
    loadbmp "boost05", "sprites\boost_05.bmp"
    loadbmp "boost04", "sprites\boost_04.bmp"
    loadbmp "boost03", "sprites\boost_03.bmp"
    loadbmp "boost02", "sprites\boost_02.bmp"
    loadbmp "boost01", "sprites\boost_01.bmp"
    loadbmp "boost00", "sprites\boost_00.bmp"

    loadbmp "bulletoneup", "sprites\";packname$;"bullet1up.bmp"
    loadbmp "bullettwoup", "sprites\";packname$;"bullet2up.bmp"
    loadbmp "bulletthreeup", "sprites\";packname$;"bullet3up.bmp"
    loadbmp "bulletfourup", "sprites\";packname$;"bullet4up.bmp"
    loadbmp "bulletfiveup", "sprites\";packname$;"bullet5up.bmp"
    loadbmp "bulletsixup", "sprites\";packname$;"bullet6up.bmp"
    loadbmp "bulletsevenup", "sprites\";packname$;"bullet7up.bmp"
    loadbmp "bulleteightup", "sprites\";packname$;"bullet8up.bmp"
    loadbmp "bulletnineup", "sprites\";packname$;"bullet9up.bmp"
    loadbmp "bullettenup","sprites\";packname$;"bullet10up.bmp"

    loadbmp "bulletoneleft", "sprites\";packname$;"bullet1left.bmp"
    loadbmp "bullettwoleft", "sprites\";packname$;"bullet2left.bmp"
    loadbmp "bulletthreeleft", "sprites\";packname$;"bullet3left.bmp"
    loadbmp "bulletfourleft", "sprites\";packname$;"bullet4left.bmp"
    loadbmp "bulletfiveleft", "sprites\";packname$;"bullet5left.bmp"
    loadbmp "bulletsixleft", "sprites\";packname$;"bullet6left.bmp"
    loadbmp "bulletsevenleft", "sprites\";packname$;"bullet7left.bmp"
    loadbmp "bulleteightleft", "sprites\";packname$;"bullet8left.bmp"
    loadbmp "bulletnineleft", "sprites\";packname$;"bullet9left.bmp"
    loadbmp "bullettenleft","sprites\";packname$;"bullet10left.bmp"
    loadbmp "ship_damage", "sprites\";packname$;"ship_damage.bmp"
    close #loading
end function

function renderPowerup(powerup, X, Y)
'shrink
'10 boost
'invincible
'full health
'cheat code or + 20 points!

    if powerup = 1 then
        loadbmp "shrink", "powerups\shrink.bmp"
        print "powerupX: ";X;" powerupY: ";Y
        print #game, "addsprite shrink shrink"
        print #game, "spriteimage shrink shrink"
        print #game, "spritescale shrink 500 500"
        print #game, "spritexy shrink ";X;" ";Y
        print #game, "drawsprites"
        'print #game, "removesprite shrink"
    end if
    if powerup = 2 then
        loadbmp "10boost", "powerups\10boost.bmp"
        print #game, "addsprite 10boost 10boost"
        print #game, "spriteimage 10boost 10boost"
        print #game, "spritescale 10boost 500 500"
        print #game, "spritexy 10boost ";X;" ";Y
        print #game, "drawsprites"
    end if
    if powerup = 3 then
        loadbmp "invincible", "powerups\invincible.bmp"
        print #game, "addsprite invincible invincible"
        print #game, "spriteimage invincible invincible"
        print #game, "spritescale invincible 500 500"
        print #game, "spritexy invincible ";X;" ";Y
        print #game, "drawsprites"
    end if
    if powerup = 4 then
        loadbmp "fullhealth", "powerups\fullhealth.bmp"
        print #game, "addsprite fullhealth fullhealth"
        print #game, "spriteimage fullhealth fullhealth"
        print #game, "spritescale fullhealth 500 500"
        print #game, "spritexy fullhealth ";X;" ";Y
        print #game, "drawsprites"
    end if
    if powerup = 5 then
        loadbmp "frozen", "powerdowns\frozen.bmp"
        print #game, "addsprite frozen frozen"
        print #game, "spriteimage frozen frozen"
        print #game, "spritescale frozen 500 500"
        print #game, "spritexy frozen ";X;" ";Y
        print #game, "drawsprites"
    end if

end function
