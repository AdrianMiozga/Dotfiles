#Requires AutoHotkey v1.1

#IfWinActive ahk_exe anki.exe
    <^j::Down

#IfWinActive ahk_exe anki.exe
    <^k::Up

; Workaround for Dual Key Remap
#IfWinActive ahk_exe anki.exe
    CapsLock & j::Down

#IfWinActive ahk_exe anki.exe
    CapsLock & k::Up
