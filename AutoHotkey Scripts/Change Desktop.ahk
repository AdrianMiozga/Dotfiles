#Requires AutoHotkey v2.0
#SingleInstance Force

; Left Win + Left Ctrl + Scroll switch desktop
<#<^WheelDown:: Send("{Blind}{Right}")
<#<^WheelUp:: Send("{Blind}{Left}")

; Left Win + Left Ctrl + H/L switch desktop
<#<^l:: Send("{Blind}{Right}")
<#<^h:: Send("{Blind}{Left}")
