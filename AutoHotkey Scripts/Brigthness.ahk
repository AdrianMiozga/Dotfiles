#Requires AutoHotkey v2.0
#SingleInstance Force

; Increase/decrease monitor brightness under current mouse point.

; Left Win + Left Shift + WheelUp
<#<+WheelUp::BrightnessUp()

; Left Win + Left Shift + K
<#<+k::BrightnessUp()

BrightnessUp() {
    hMonitor := GetMonitorHandle()
    currentBrightness := GetMonitorBrightness(hMonitor)

    if (currentBrightness == 100) {
        DestroyMonitorHandle(hMonitor)
        return
    }

    SetMonitorBrightness(hMonitor, currentBrightness + 5)
    DestroyMonitorHandle(hMonitor)
}

; Left Win + Left Shift + WheelDown
<#<+WheelDown::BrightnessDown()

; Left Win + Left Shift + K
<#<+j::BrightnessDown()

BrightnessDown() {
    hMonitor := GetMonitorHandle()
    currentBrightness := GetMonitorBrightness(hMonitor)

    if (currentBrightness == 0) {
        DestroyMonitorHandle(hMonitor)
        return
    }

    SetMonitorBrightness(hMonitor, currentBrightness - 5)
    DestroyMonitorHandle(hMonitor)
}

GetMonitorHandle() {
    MouseGetPos(&xpos, &ypos)

    ; Convert to POINT structure
    pt := Buffer(8)
    NumPut("Int", xpos, pt, 0)
    NumPut("Int", ypos, pt, 4)

    static MONITOR_DEFAULTTOPRIMARY := 0x00000001
    hMonitor := DllCall("User32.dll\MonitorFromPoint",
        "Ptr", pt,
        ; If the point is not contained within any display monitor return
        ; a handle to the primary display monitor
        "UInt", MONITOR_DEFAULTTOPRIMARY)

    ; PHYSICAL_MONITOR structure
    ; 8 bytes for monitor HANDLE
    ; 256 bytes for monitor description
    pPhysicalMonitorArray := Buffer(8 + 256)

    DllCall("Dxva2.dll\GetPhysicalMonitorsFromHMONITOR",
        "Int", hMonitor,
        "UInt", 1,
        "Ptr", pPhysicalMonitorArray)

    return NumGet(pPhysicalMonitorArray, "Ptr")
}

DestroyMonitorHandle(hMonitor) {
    DllCall("Dxva2.dll\DestroyPhysicalMonitor",
        "Int", hMonitor)
}

GetMonitorBrightness(hMonitor) {
    pdwMinimumBrightness := 0
    pdwCurrentBrightness := 0
    pdwMaximumBrightness := 0

    DllCall("Dxva2.dll\GetMonitorBrightness",
        "Int", hMonitor,
        "UInt*", &pdwMinimumBrightness,
        "UInt*", &pdwCurrentBrightness,
        "UInt*", &pdwMaximumBrightness)

    return pdwCurrentBrightness
}

SetMonitorBrightness(hMonitor, brightness) {
    DllCall("Dxva2.dll\SetMonitorBrightness",
        "Int", hMonitor,
        "Int", brightness)
}
