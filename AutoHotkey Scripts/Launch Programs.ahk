#Requires AutoHotkey v2.0
#SingleInstance Force

; Ctrl + Alt + D
^!d:: ShowTerminal()

; Ctrl + Alt + W
; ^!w:: ShowEmacs()

ShowTerminal() {
    WindowsTerminal := "ahk_class CASCADIA_HOSTING_WINDOW_CLASS"

    if WinExist(WindowsTerminal) {
        if WinActive(WindowsTerminal) {
            WinMinimize(WindowsTerminal)
        } else {
            WinShow(WindowsTerminal)
            WinActivate(WindowsTerminal)
        }
    } else {
        Run("wt.exe")
    }
}

ShowEmacs() {
    Emacs := "ahk_class Emacs"

    if WinExist(Emacs) {
        WinShow(Emacs)
        WinActivate(Emacs)
    } else {
        Run("emacs.exe", , "Hide")
    }
}
