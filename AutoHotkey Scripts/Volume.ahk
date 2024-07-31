#Requires AutoHotkey v2.0
#SingleInstance Force

; Script to change system volume to either 10% or 100%. On my sound system,
; it’s hard to precisely choose a comfortable low volume through hardware
; when outputting at 100%. 10% gives much more control.

; Left Shift + Left Ctrl + F9
<+<^F9:: SoundSetVolume(10)

; Left Shift + Left Ctrl + F10
<+<^F10:: SoundSetVolume(100)
