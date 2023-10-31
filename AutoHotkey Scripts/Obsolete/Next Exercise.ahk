#Requires AutoHotkey v1.1
#SingleInstance Force

#IfWinActive, ahk_exe reaper.exe
    ,::Method()

    Method() {
        Send {,}

        Random, Output, 1, 3

        Gui, 1: Default
        Gui, 1: Color, 444444
        GUI, 1: +AlwaysOnTop -caption

        GUI, 1: Font, s72 cFFFFFF

        if (Output == 1) {
            Gui, 1: Add, Text, , Sitting
        } else if (Output == 2) {
            Gui, 1: Add, Text, , Classical
        } else {
            Gui, 1: Add, Text, , Standing
        }

        Gui, 1: Show, xCenter yCenter NA, Msgbox

        sleep 2000
        Gui, 1: Destroy
        return
    }
