#Requires AutoHotkey v2.0
#SingleInstance Force

; Left Ctrl + Left Win + Scroll switch desktop

<#<^WheelUp::Send("{Blind}{Right}")
<#<^WheelDown::Send("{Blind}{Left}")

; Left Ctrl + Left Win + h/l switch desktop

<#<^l::Send("{Blind}{Right}")
<#<^h::Send("{Blind}{Left}")
