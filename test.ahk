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
wID:=0x00000
;;KEY CODES
;1 = 2
;2 = 3
;3 = 4
;4 = 5
;5 = 6
;6 = 7
;7 = 8
;8 = 9
;9 = 10
;0 = 11

;F11 is setup
F10::

    ;Get Game ID
    WinGet, wID, ID, A

    CoordMode, Pixel, Screen

    ;ToolTip , Click hp bar when the hp pot will be used
    KeyWait, LButton, D
    MouseGetPos, hpBarSpotX, hpBarSpotY
    Sleep, 200

    ;ToolTip , Hp bar setted x: %hpBarSpotX% y: %hpBarSpotY% and color is %hpColor% Click mp bar when the mp pot will be used 
    KeyWait, LButton, D
    MouseGetPos, mpBarSpotX, mpBarSpotY
    Sleep, 200

    ;ToolTip , Mp bar setted x: %mpBarSpotX% y: %mpBarSpotY% Click the MonsterBar 
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
    ;example skill_keys:=[2,3,4,5]
    skill_keys:=[3]
    HP_key:=9
    MP_key:=0
    target:="ahk_exe RiseOnline-Win64-Shipping.exe"

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
            controlsend,,%HP_key%, % "ahk_exe RiseOnline-Win64-Shipping.exe"
            Sleep, 100
        }

        Sleep, 100
        isMPLow:=checkHPMP(mpColor,mpBarSpotX,mpBarSpotY,21)
        ToolTip, %isMPLow%
        if(isMPLow)
        {

            controlsend,,%MP_key%, % "ahk_exe RiseOnline-Win64-Shipping.exe"
            Sleep, 100
        }

        ;;use Z

        controlsend,,{z}, % "ahk_exe RiseOnline-Win64-Shipping.exe"
        Sleep, 100

        ;;use R 

        isMonsterBarGray:=checkHPMP(monsterColor,monsterBarSpotX,monsterBarSpotY,15)

        if(!isMonsterBarGray)
        {
            if(!r_used)
            {
                r_used:=True
                controlsend,,{R}, % "ahk_exe RiseOnline-Win64-Shipping.exe"
                Sleep, 100

            }

        }
        else
        {
            r_used:=False
        }

        ;;use Skill
        for i,skill in skill_keys
        {
            controlsend,,%skill%, % "ahk_exe RiseOnline-Win64-Shipping.exe"
            Sleep, 200
        }

    }
return

F12::
    b:="0x" . substr(color,3,2)
    g:="0x" . substr(color,5,2)
    r:="0x" . substr(color,7,2)
    ;split pixel into rgb
    pb := format("{:d}","0x" . substr(color,3,2))
    pg := format("{:d}","0x" . substr(color,5,2))
    pr := format("{:d}","0x" . substr(color,7,2))

    MsgBox %r% %g% %b% red: %pr% green:%pg% blue %pb%
    ;check distance of colors
    distance := Abs(tr-pr)
    ;ToolTip,diff=%diff% pr = %pr%-%pg%-%pb% tr=%tr%-%tg%-%tb% distance: %distance%

return

;MouseButtonEvent(code, state){
;    ToolTip % "Mouse Button - Code: " code ", State: " state	
;}
RemoveToolTip:
    ToolTip
return

^Esc::
ExitApp