#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

#SingleInstance force

#Persistent
#include AHKInterception\Lib\AutoHotInterception.ahk
#include Lib\BarCheck.ahk

AHI := new AutoHotInterception()

keyboardId := AHI.GetKeyboardId(0x1532, 0x0037)
AHI.SubscribeKeyboard(keyboardId, true, Func("KeyEvent"))

;mouseId := AHI.GetMouseId(0x1532, 0x0037)
;AHI.SubscribeMouseButtons(mouseId, true, Func("MouseButtonEvent"))
return

hpBarSpotX:=0
hpBarSpotY:=0
hpColor:=0xE1EBF2

mpBarSpotX:=0
mpBarSpotY:=0
mpColor:=0xE1EBF3

monsterBarSpotX:=1080
monsterBarSpotY:=46
monsterColor:=0xE1EBF4

mode=False
r_used:=False

;F11 is setup
F10::

    ;Get Game ID
    WinGet, wID, ID, A

    ;Screen Coordinate Mod means dont move the game after iniliaze the bot
    CoordMode, Pixel, Screen

    ToolTip , Firts of all Click hp bar when the hp pot will be used
    KeyWait, LButton, D
    MouseGetPos, hpBarSpotX, hpBarSpotY
    Sleep, 200

    ToolTip , Hp bar setted x: %hpBarSpotX% y: %hpBarSpotY% - Secondly Click mp bar when the mp pot will be used 
    KeyWait, LButton, D
    MouseGetPos, mpBarSpotX, mpBarSpotY
    Sleep, 200

    ToolTip , Mp bar setted x: %mpBarSpotX% y: %mpBarSpotY% Lastly Click the red zone at the middle of the MonsterBar 
    KeyWait, LButton, D
    MouseGetPos, monsterBarSpotX, monsterBarSpotY
    Sleep, 200

    PixelGetColor, hpColor, %hpBarSpotX%, %hpBarSpotY%
    Sleep, 100
    PixelGetColor, mpColor, %mpBarSpotX%, %mpBarSpotY%
    Sleep, 100
    PixelGetColor, monsterColor, %monsterBarSpotX%, %monsterBarSpotY%
    Sleep, 100
    ;;MsgBox, %hpColor% %monsterColor%

    ToolTip , Spots selection completed, press F11 to start farming!
    SetTimer, RemoveToolTip, -2500

return
F11::
    ;Screen Coordinate Mod means dont move the game after iniliaze the bot
    CoordMode, Pixel, Screen
    ;example skill_keys:=["2","3","4","5"]
    skill_keys:=["1","2","3","4"]
    HP_key:="9"
    MP_key:="0"

    mode:=True
    r_used:=False
    loop
    {
        if(mode==False)
        {
            break
        }

        ;;use potions
        isHPLow:=checkHPMP(hpColor,hpBarSpotX,hpBarSpotY,20)
        if(isHPLow)
        {
            controlsend,,{%HP_key% down}, ahk_id %wID%
            Sleep, 100
            controlsend,,{%HP_key% up}, ahk_id %wID%
        }

        Sleep, 200
        isMPLow:=checkHPMP(mpColor,mpBarSpotX,mpBarSpotY,21)
        if(isMPLow)
        {

            controlsend,,{%MP_key% down}, ahk_id %wID%
            Sleep, 100
            controlsend,,{%MP_key% up}, ahk_id %wID%
        }

        ;;use Z

        controlsend,,{z down}, ahk_id %wID%
        Sleep, 100
        controlsend,,{z up}, ahk_id %wID%

        ;;use Skill
        for i,skill in skill_keys
        {
            controlsend,,{%skill% down}, ahk_id %wID%
            Sleep, 100
            controlsend,,{%skill% up}, ahk_id %wID%
            Sleep, 200

        }

    }
return

F12::
    mode:=False

return
;MouseButtonEvent(code, state){
;    ToolTip % "Mouse Button - Code: " code ", State: " state	
;}
RemoveToolTip:
    ToolTip
return

^Esc::
ExitApp