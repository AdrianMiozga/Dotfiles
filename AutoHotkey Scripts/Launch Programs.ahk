#SingleInstance, Force
#NoEnv
SendMode, Input

^!d::ShowTerminal()
^!w::ShowEmacs()

ShowTerminal() {
    WinMatcher := "ahk_class CASCADIA_HOSTING_WINDOW_CLASS"

    if WinExist(WinMatcher) {
        WinShow ahk_class CASCADIA_HOSTING_WINDOW_CLASS
        WinActivate ahk_class CASCADIA_HOSTING_WINDOW_CLASS
    } else {
        Run, wt.exe
    }
}

ShowEmacs() {
    WinMatcher := "ahk_class Emacs"

    if WinExist(WinMatcher) {
        WinShow ahk_class Emacs
        WinActivate ahk_class Emacs
    } else {
        Run, emacs.exe, , hide
    }
}
