#Requires AutoHotkey v2.0
#SingleInstance Force

; Single quotes
; Alt + [
![::Send("‘")
; Alt + ]
!]::Send("’")

; Double quotes
; Alt + Ctrl + Shift + [
!^+[::Send("„")
; Alt + Shift + [
!+[::Send("“")
; Alt + Shift + ]
!+]::Send("”")

; Ellipsis
; Alt + .
!.::Send("…")

; En dash
; Alt + -
!-::Send("–")

; Em dash
; Alt + Shift + -
!+-::Send("—")
