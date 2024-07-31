#Requires AutoHotkey v2.0
#SingleInstance Force

; Left Ctrl + Left Shift + Left
<^<+Left:: Send("{Media_Prev}")

; Left Ctrl + Left Shift + Down
<^<+Down:: Send("{Media_Play_Pause}")

; Left Ctrl + Left Shift + Right
<^<+Right:: Send("{Media_Next}")
