'SpaceBlast v1.0a
'By: Mallot1
'(C) 2013

  NOMAINWIN

    WindowWidth = DisplayWidth
    WindowHeight = DisplayHeight

    [MainMenu]
        'buttons and things
        button #main.play, "Play Game", [Game], UL, DisplayWidth/2-100, 200, 200, 50
        button #main.about, "About", [About], UL, DisplayWidth/2-100, 250, 200, 50
        'create window
        open "Main Menu" for graphics_nsb_nf as #main
        print #main, "trapclose [quit]"
        'setup window
       gosub [menuBackground]
       wait

 [menuBackground]
        if ( backgroundLoaded$ = "") then
            loadbmp "menuBG", "media\menuBG.bmp"
            print #main, "background menuBG"
        end if

        print #main, "drawsprites"
        backgroundLoaded$ = "true"
        wait

 [quit]
    close #main
    end

 [Game]
    close #main
    'buttons and things
    menu #game, "Options", "Change Background", [changeBackground],  "About", [About]
    open "SpaceBlast v1.0a" for graphics_nsb_nf as #game
    print #game, "trapclose [gameQuit]"
 1 'this is labeled as line "1". Gives the program somewhere to jump to so it can continue the game.
    gosub [playGame]
    wait

[playGame]
    gosub [gameBackground]  ' load the background
    gosub [makeAsteroids]
    gosub [LoadAsteroids]
    wait

[makeAsteroids]
    loadbmp "asteroid", "sprites\asteroid.bmp"
    print #game, "addsprite asteroid asteroid"
    return
    wait

[LoadAsteroids]
    print #game, "spriteimage asteroid asteroid"
    print #game, "spritexy asteroid 250 250"
    print #game, "drawsprites"
    return
    wait

[gameQuit]
    confirm "Do you really want to quit?";quit$
    if ( quit$ = "yes" ) then
            close #game
            end
    end if
        if ( quit$ = "no" ) then
                     goto  1 ' goto line labeled "1"
        end if
wait

[gameBackground]
    if (backgroundChanged$ = "true") then goto 2                'now game will always show the user chosen background
    loadbmp "bg", "media\space.bmp"
    print #game, "background bg"
    print #game, "drawsprites"
    return
    wait

[changeBackground]
    filedialog "Open Bitmap Image", "*.bmp", UserBGimage$
 2 loadbmp "UserBG",  UserBGimage$
    print #game, "background UserBG"
    print #game, "drawsprites"
    backgroundChanged$ = "true"
    return
    wait

[About]
    notice "About" + chr$(13) + "SpaceBlast (C)' 2013"
    wait
