#Requires AutoHotkey v2.0
#SingleInstance Force

^!w:: ShowChatGPT()

ShowChatGPT() {
    if WinExist("ChatGPT ahk_exe chrome.exe") {
        WinActivate()
    } else {
        Run(
            A_AppData '\Microsoft\Windows\Start Menu\Programs\Aplikacje Chrome\ChatGPT.lnk'
        )
    }
}
