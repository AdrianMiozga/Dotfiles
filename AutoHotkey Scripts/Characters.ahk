#Requires AutoHotkey v2.0
#SingleInstance Force

; Single quotes
![::Send("‘")
!]::Send("’")

; Double quotes
!^+[::Send("„")
!+[::Send("“")
!+]::Send("”")

; Ellipsis
!.::Send("…")

; En dash
!-::Send("–")

; Em dash
!+-::Send("—")
