#SingleInstance, Force
#NoEnv
SendMode, Input

; Increase/decrease monitor brightness under current mouse point.

<#<+WheelUp::BrightnessUp()
<#<+k::BrightnessUp()

BrightnessUp() {
    hMonitor := getMonitorHandle()
    currentBrightness := getMonitorBrightness(hMonitor)

    if (currentBrightness == 100) {
        destroyMonitorHandle(hMonitor)
        return
    }

    setMonitorBrightness(hMonitor, currentBrightness + 5)
    destroyMonitorHandle(hMonitor)
}

<#<+WheelDown::BrightnessDown()
<#<+j::BrightnessDown()

BrightnessDown() {
    hMonitor := getMonitorHandle()
    currentBrightness := getMonitorBrightness(hMonitor)

    if (currentBrightness == 0) {
        destroyMonitorHandle(hMonitor)
        return
    }

    setMonitorBrightness(hMonitor, currentBrightness - 5)
    destroyMonitorHandle(hMonitor)
}

getMonitorHandle() {
    MouseGetPos, xpos, ypos

    ; Convert to POINT structure
    VarSetCapacity(pt, 8)
    NumPut(xpos, pt, 0, "Int")
    NumPut(ypos, pt, 4, "Int")

    static MONITOR_DEFAULTTOPRIMARY := 0x00000001
    hMonitor := DllCall("User32.dll\MonitorFromPoint"
        , "Int", pt
        ; If the point is not contained within any display monitor return
        ; a handle to the primary display monitor
        , "UInt", MONITOR_DEFAULTTOPRIMARY)

    ; PHYSICAL_MONITOR structure
    ; 8 bytes for monitor HANDLE
    ; 256 bytes for monitor description
    VarSetCapacity(pPhysicalMonitorArray, 8 + 256, 0)

    DllCall("Dxva2.dll\GetPhysicalMonitorsFromHMONITOR"
        , "Int", hMonitor
        , "UInt", 1
        , "Ptr", &pPhysicalMonitorArray)

    return hPhysicalMonitor := NumGet(pPhysicalMonitorArray)
}

destroyMonitorHandle(hMonitor) {
    DllCall("Dxva2.dll\DestroyPhysicalMonitor"
        , "Int", hMonitor)
}

getMonitorBrightness(hMonitor) {
    DllCall("Dxva2.dll\GetMonitorBrightness"
        , "Int", hMonitor
        , "UInt*", pdwMinimumBrightness
        , "UInt*", pdwCurrentBrightness
        , "UInt*", pdwMaximumBrightness)

    return pdwCurrentBrightness
}

setMonitorBrightness(hMonitor, brightness)
{
    DllCall("Dxva2.dll\SetMonitorBrightness"
        , "Int", hMonitor
        , "Int", brightness)
}
