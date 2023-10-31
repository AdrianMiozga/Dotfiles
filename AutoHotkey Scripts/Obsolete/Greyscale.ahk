#Requires AutoHotkey v1.1

Gui +LastFound
hWnd := WinExist()
DllCall("RegisterShellHookWindow", UInt, Hwnd)
MsgNum := DllCall( "RegisterWindowMessage", Str, "SHELLHOOK")
OnMessage(MsgNum, "ShellMessage")
return

ShellMessage(wParam, lParam) {
    If (wParam = 4 || wParam = 6 || wParam = 54) {
        WinGetTitle, title, A

        RegRead, isActive, HKEY_CURRENT_USER\Software\Microsoft\ColorFiltering, Active

        if InStr(title, "Mozilla") {
            if (isActive = 0) {
                Send, ^#c
            }
        } else {
            if (isActive = 1) {
                Send, ^#c
            }
        }
    }
}
