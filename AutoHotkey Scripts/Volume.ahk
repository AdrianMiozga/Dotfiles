#SingleInstance, Force

; Script to change system volume to either 10% or 100%. On my sound system,
; it’s hard to precisely choose a comfortable low volume through hardware
; when outputting at 100%. 10% gives much more control.

<+<^F9::setVolume(10)
<+<^F10::setVolume(100)

setVolume(number) {
    SoundSet, number, SPEAKERS, VOLUME
}
