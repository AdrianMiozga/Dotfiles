#SingleInstance force

; Disables dual-key-remap when the active window is from VirtualBox
; as it doesn't work as expected inside of it.
#Persistent
OnWinActiveChange(hWinEventHook, vEvent, hWnd) {
	static _ := DllCall("user32\SetWinEventHook", "UInt", 0x3, "UInt", 0x3, "Ptr", 0, "Ptr", RegisterCallback("OnWinActiveChange"), "UInt", 0, "UInt", 0, "UInt", 0, "Ptr")
	DetectHiddenWindows, On

    WinGetTitle, title, A

    if InStr(title, "VirtualBox") {
        Process, Close, dual-key-remap.exe
    } else {
        Process, Exist, dual-key-remap.exe

        if !ErrorLevel {
            Run, C:/Program Files/Dual Key Remap/dual-key-remap.exe, , hide
        }
    }
}

ToggleCaps() {
    ; Without this, using double shifts to disable CapsLock would also leak ESC.
    SetStoreCapsLockMode, Off

    ; Sending CapsLock directly doesn't do anything with dual-key-remap or caps2esc.
    Send {Esc}
    SetStoreCapsLockMode, On
    return
}

LShift & RShift::ToggleCaps()
RShift & LShift::ToggleCaps()

#IfWinActive ahk_exe VirtualBoxVM.exe
    ; I'm using caps2esc on Linux VM to simulate dual-key-remap.
    ; But without disabling caps on the host machine, the led light of caps lock on keyboard still toggles.
    Capslock::return
