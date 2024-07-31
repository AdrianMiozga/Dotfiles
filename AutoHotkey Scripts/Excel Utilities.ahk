#Requires AutoHotkey v2.0
#SingleInstance Force

; Merge Cells

F7:: {
    Send("!hmm")
}

; Unmerge Cells

F5:: {
    Send("!hmu")
}

; Insert Cells > Shift Cells Down

F6:: {
    Send("!hii")
    Sleep(100)
    Send("!d{Enter}")
}
