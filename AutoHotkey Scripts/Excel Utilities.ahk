#SingleInstance force

; Merge Cells

F7::
    Send !h
    Send m
    Send m
return

; Unmerge Cells

F5::
    Send !h
    Send m
    Send u
return

; Insert Cells > Shift Cells Down

F6::
    Send !h
    Send i
    Send i
    Sleep 100
    Send !d
    Send {Enter}
return
