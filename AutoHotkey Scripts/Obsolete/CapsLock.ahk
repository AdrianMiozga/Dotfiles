#Requires AutoHotkey v1.1
#SingleInstance, Force

; Script to make binding CapsLock to Esc/Ctrl work both in host and guest
; machine.
;
; It’s written with this setup in mind:
; - Windows as host machine with dual-key-remap
; - Linux VM on VirtualBox with caps2esc OR Windows VM on VirtualBox with
;   dual-key-remap
;
; Basically, it kills the dual-key-remap process whenever you switch to VM
; and starts it when you switch out.
;
; Additionally, it also fixes the led light toggling on/off whenever using
; CapsLock on a VM. It wouldn’t actually make your letters upper case,
; but it was annoying.
;
; You can still access CapsLock by pressing the left and right shift at the same
; time.
;
; For best results, you might want to run this script and dual-key-remap
; with elevated privileges. That way, they will also have an effect on programs
; with admin rights, like in elevated terminal.
; You can create an elevated shortcut that skips the UAC prompt with the help of
; Task Scheduler.

#Persistent
OnWinActiveChange(hWinEventHook, vEvent, hWnd) {
    static _ := DllCall("User32.dll\SetWinEventHook"
        , "UInt", 0x3
        , "UInt", 0x3
        , "Ptr", 0
        , "Ptr", RegisterCallback("OnWinActiveChange")
        , "UInt", 0
        , "UInt", 0
        , "UInt", 0
        , "Ptr")

    DetectHiddenWindows, On

    WinGetTitle, title, A

    if (InStr(title, "VirtualBox") && InStr(title, "Running")) {
        Process, Close, dual-key-remap.exe
    } else {
        Process, Exist, dual-key-remap.exe

        if !ErrorLevel {
            Run, C:/Program Files/Dual Key Remap/dual-key-remap - Elevated.lnk, , hide
        }
    }
}

ToggleCaps() {
    ; I’m turning off CapsLock on the host machine when using VirtualBox
    ; as the led light behavior is wrong. It always toggles when pressing
    ; CapsLock, be it alone or with other keys.
    ;
    ; But I still want to have an LED indicator when using the double shift
    ; method.
    if (WinActive("ahk_exe VirtualBoxVM.exe")) {
        static capsState := true

        if (capsState) {
            KeyboardLED(4, "on", 0)
        } else {
            KeyboardLED(4, "off", 0)
        }

        capsState := !capsState
    }

    ; Without this, using double shifts to disable CapsLock would also leak ESC.
    SetStoreCapsLockMode, Off

    ; Sending CapsLock directly doesn’t do anything with dual-key-remap or
    ; caps2esc.
    Send {Esc}
    SetStoreCapsLockMode, On
    return
}

LShift & RShift::ToggleCaps()
RShift & LShift::ToggleCaps()

/*

    Keyboard LED control for AutoHotkey_L
        http://www.autohotkey.com/forum/viewtopic.php?p=468000#468000

    KeyboardLED(LEDvalue, "Cmd", Kbd)
        LEDvalue  - ScrollLock=1, NumLock=2, CapsLock=4
        Cmd       - on/off/switch
        Kbd       - index of keyboard (probably 0 or 2)

*/
KeyboardLED(LEDvalue, Cmd, Kbd=0) {
    SetUnicodeStr(fn,"\Device\KeyBoardClass" Kbd)
    h_device := NtCreateFile(fn,0+0x00000100+0x00000080+0x00100000,1,1,0x00000040+0x00000020,0)
    If (Cmd = "switch") ;switches every LED according to LEDvalue
        KeyLED:= LEDvalue
    If (Cmd = "on") ;forces all choosen LED’s to ON (LEDvalue= 0 ->LED’s according to keystate)
        KeyLED:= LEDvalue | (GetKeyState("ScrollLock", "T") + 2*GetKeyState("NumLock", "T") + 4*GetKeyState("CapsLock", "T"))
    If (Cmd = "off") { ;forces all choosen LED’s to OFF (LEDvalue= 0 ->LED’s according to keystate)
        LEDvalue := LEDvalue ^ 7
        KeyLED := LEDvalue & (GetKeyState("ScrollLock", "T") + 2*GetKeyState("NumLock", "T") + 4*GetKeyState("CapsLock", "T"))
    }
    success := DllCall( "DeviceIoControl" , "ptr", h_device , "uint", CTL_CODE( 0x0000000b , 2 , 0 , 0 ) , "int*", KeyLED << 16 , "uint", 4 , "ptr", 0 , "uint", 0 , "ptr*", output_actual , "ptr", 0 )
    NtCloseFile(h_device)
    return success
}

CTL_CODE( p_device_type, p_function, p_method, p_access ) {
    return, ( p_device_type << 16 ) | ( p_access << 14 ) | ( p_function << 2 ) | p_method
}

NtCreateFile(ByRef wfilename,desiredaccess,sharemode,createdist,flags,fattribs) {
    VarSetCapacity(objattrib,6*A_PtrSize,0)
    VarSetCapacity(io,2*A_PtrSize,0)
    VarSetCapacity(pus,2*A_PtrSize)
    DllCall("ntdll\RtlInitUnicodeString","ptr",&pus,"ptr",&wfilename)
    NumPut(6*A_PtrSize,objattrib,0)
    NumPut(&pus,objattrib,2*A_PtrSize)
    status:=DllCall("ntdll\ZwCreateFile","ptr*",fh,"UInt",desiredaccess,"ptr",&objattrib ,"ptr",&io,"ptr",0,"UInt",fattribs,"UInt",sharemode,"UInt",createdist ,"UInt",flags,"ptr",0,"UInt",0, "UInt")
    return % fh
}

NtCloseFile(handle) {
    return DllCall("ntdll\ZwClose","ptr",handle)
}

SetUnicodeStr(ByRef out, str_) {
    VarSetCapacity(out,2*StrPut(str_,"utf-16"))
    StrPut(str_,&out,"utf-16")
}

#IfWinActive ahk_exe VirtualBoxVM.exe
    *CapsLock::return
