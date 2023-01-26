
checkHPMP(targetColor,XPos,YPos,diff){
    PixelGetColor, color, %XPos%, %YPos%, SLOW
    ;split target color into rgb
    tb := format("{:d}","0x" . substr(targetColor,3,2))
    tg := format("{:d}","0x" . substr(targetColor,5,2))
    tr := format("{:d}","0x" . substr(targetColor,7,2))

    ;split pixel into rgb
    pb := format("{:d}","0x" . substr(color,3,2))
    pg := format("{:d}","0x" . substr(color,5,2))
    pr := format("{:d}","0x" . substr(color,7,2))

    ;MsgBox red: %pr% green:%pg% blue %pb%
    ;check distance of colors
    distance := Abs(tr-pr)
    ;ToolTip,diff=%diff% pr = %pr%-%pg%-%pb% tr=%tr%-%tg%-%tb% distance: %distance%

    if(distance<=diff)
    {
        return False
    }
    else
    {
        return True
    }
}

hexColorShow(c) {

    DllCall("user32\SetSysColors", Int,1, IntP, 5, UIntP,c) ;BGR ;color

    msgbox this is the color of %c%

}

