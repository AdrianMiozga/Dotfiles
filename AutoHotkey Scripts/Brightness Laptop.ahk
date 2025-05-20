#Requires AutoHotkey v2.0
#SingleInstance Force

; Left Win + Left Shift + WheelUp
<#<+WheelUp:: AdjustScreenBrightness(5)

; Left Win + Left Shift + K
<#<+k:: AdjustScreenBrightness(5)

; Left Win + Left Shift + WheelDown
<#<+WheelDown:: AdjustScreenBrightness(-5)

; Left Win + Left Shift + K
<#<+j:: AdjustScreenBrightness(-5)

AdjustScreenBrightness(step) {
    service := "winmgmts:{impersonationLevel=impersonate}!\\.\root\WMI"

    brightness := ComObjGet(service).ExecQuery(
        "SELECT * FROM WmiMonitorBrightness WHERE Active = TRUE")._NewEnum()

    brightnessMethods := ComObjGet(service).ExecQuery(
        "SELECT * FROM WmiMonitorBrightnessMethods WHERE Active = TRUE")._NewEnum()

    if (brightness(&value)) {
        currentBrightness := value.CurrentBrightness
    }

    newBrightness := currentBrightness + step

    if (newBrightness > 100) {
        newBrightness := 100
    }

    if (newBrightness < 0) {
        newBrightness := 0
    }

    if (brightnessMethods(&method)) {
        method.WmiSetBrightness(1, newBrightness)
    }
}
