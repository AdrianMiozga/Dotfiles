#Requires AutoHotkey v2.0
#SingleInstance Force

#HotIf WinActive("ahk_exe reaper.exe")
    `::ToggleMenu()

#HotIf WinActive("ahk_exe reaper.exe")
    F9::ToggleDevice()

ToggleMenu() {
    static MenuArray := Map()

    hWin := WinExist("REAPER v")

    if (MenuArray.Has(hWin)) {
        DllCall("User32.dll\SetMenu", "UInt", hWin, "UInt", MenuArray[hWin])
        MenuArray.Delete(hWin)
    } else {
        hMenu := DllCall("User32.dll\GetMenu", "UInt", hWin)
        MenuArray[hWin] := hMenu

        DllCall("User32.dll\SetMenu", "UInt", hWin, "UInt", 0)
    }
}

ToggleDevice() {
    hWnd := WinExist("REAPER v")
    MenuVisible := DllCall("User32.dll\GetMenu", "UInt", hWnd)

    if (!MenuVisible) {
        ToggleMenu()
    }

    ControlSend("{Ctrl Down}{Shift Down}{F1}{Ctrl Up}{Shift Up}", , "ahk_exe reaper.exe")

    if (WinWait("REAPER Preferences", , 2)) {
        Index := ControlGetIndex("ComboBox1")
        
        if (Index = 2) {
            ControlChooseIndex(3, "ComboBox1")
        } else {
            ControlChooseIndex(2, "ComboBox1")
        }

        SetControlDelay(-1)
        ControlClick("Button2", "REAPER Preferences")

    }

    if (!MenuVisible) {
        Sleep(2000)

        ToggleMenu()
    }
}

; Hide menu when starting Reaper
MyGui := Gui("+LastFound")
hWin := WinExist()
DllCall("User32.dll\RegisterShellHookWindow", "UInt", hWin)
MsgNum := DllCall("User32.dll\RegisterWindowMessage", "Str", "SHELLHOOK")
OnMessage(MsgNum, ShellEvent)

HSHELL_WINDOWCREATED := 1

ShellEvent(wParam, lParam, msg, hwnd) {
    if (wParam = HSHELL_WINDOWCREATED) {
        Title := WinGetTitle(lParam)

        if (InStr(Title, "REAPER v")) {
            Sleep(500)
            ToggleMenu()
        }
    }
}
