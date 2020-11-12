#SingleInstance force

; A script that toggles the GTune tuner and mutes master track in Reaper,
; so your neighbors don’t need to hear the obnoxious noises when you
; tune. When it hides the tuner, your master track is unmuted so
; they can admire your shred.
; 
; If you don’t care, use Shift + B. It toggles tuner but keeps your
; master track intact.
;
; You need to have B bound inside Reaper to show tuner.
; 'Show Tuner.lua' script does exactly that.
; F6 needs to be bound to 'Track: Toggle mute for master track'
;
; Using AutoHotkey script is required as keybinds in Reaper don’t work if
; the focus isn’t on the main window. Showing the tuner steals the focus,
; so you would have to click somewhere in Reaper before hiding it.
; 
; Setting keybind as global in Reaper still doesn’t make it go through.
; Setting it to global + text fields does work indeed, but you can’t
; type anywhere the letter you’ve bound the key to.

#IfWinActive, ahk_exe reaper.exe
b::ToggleTunerAndMasterMute()
+b::ToggleTuner()

ToggleTunerAndMasterMute() {
    SendInput, {F6}

    if WinActive("VST: GTune") {
        WinKill, VST: GTune
    } else {
        Send b
    }
}

ToggleTuner() { 
    if WinActive("VST: GTune") {
        WinKill, VST: GTune
    } else {
        Send b
    }
}
