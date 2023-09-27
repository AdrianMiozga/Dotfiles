#Requires AutoHotkey v1.1
#SingleInstance, Force

; Keybinds that click on BPM and time signature fields in Reaper allowing you
; to change the values without the need for a mouse.
;
; Works both with the menu hidden and shown.
; Also works with transport hidden (shows it for five seconds).
; Requires Reaper in fullscreen.

#IfWinActive, ahk_exe reaper.exe
    z::type(1) ; BPM
    +z::type(2) ; Time signature

    type(action) {
        WinGetText, isTransportShown, ahk_exe reaper.exe, Transport

        if (!isTransportShown) {
            ; Use Reaper action "View: Toggle transport visible"
            ; bound to Ctrl+Alt+T
            Send {Ctrl down}{Alt down}t{Ctrl up}{Alt up}
            Sleep 200
        }

        isMenuShown := (DllCall("GetMenu", "uint", WinExist("A")))

        SetControlDelay -1

        if (isMenuShown) {
            if (action == 1) {
                ControlClick, x1720 y63
            } else {
                ControlClick, x1769 y63
            }
        } else {
            if (action == 1) {
                ControlClick, x1720 y34
            } else {
                ControlClick, x1769 y34
            }
        }

        if (!isTransportShown) {
            ; If the transport was hidden during invocation of the method,
            ; hide it again after 5 seconds.
            KeyWait, Enter, D T5
            Send {Ctrl down}{Alt down}t{Ctrl up}{Alt up}
        }
    }
