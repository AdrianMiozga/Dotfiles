#Requires AutoHotkey v2.0
#SingleInstance Force

; Left Ctrl + Left Win + Left/Right arrows switch desktop

<#<^WheelUp::Send "{Blind}{Right}"
<#<^WheelDown::Send "{Blind}{Left}"
