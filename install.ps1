#Requires -RunAsAdministrator

# Install manually:
# - All Cascadia Code fonts
#   https://github.com/microsoft/cascadia-code/releases/
# - CaskaydiaCove Nerd Font
#   https://www.nerdfonts.com/font-downloads

# Setup dual-key-remap:
# 1. Create task in Task Scheduler to run dual-key-remap.exe with highest
#    privileges on startup.
# 2. Export task.
# 3. Set priority to 5 (from 7) in the XML file.
#    https://learn.microsoft.com/en-us/windows/win32/taskschd/tasksettings-priority
# 4. Delete task.
# 5. Import task.

Install-Module -Name z -Force
winget install JanDeDobbeleer.OhMyPosh --source winget

New-Item -Force -Path $HOME\Documents\Powershell\Microsoft.Powershell_profile.ps1 -ItemType SymbolicLink -Value $HOME\dotfiles\Powershell_profile.ps1

New-Item -Force -Path $HOME\.doom.d\ -ItemType SymbolicLink -Value $HOME\dotfiles\.doom.d\
New-Item -Force -Path "$HOME\AutoHotkey Scripts\" -ItemType SymbolicLink -Value "$HOME\dotfiles\AutoHotkey Scripts\"
New-Item -Force -Path "$HOME\Reaper Scripts\" -ItemType SymbolicLink -Value "$HOME\dotfiles\Reaper Scripts\"

New-Item -Force -Path $HOME\.gitconfig -ItemType SymbolicLink -Value $HOME\dotfiles\.gitconfig
New-Item -Force -Path $HOME\.ideavimrc -ItemType SymbolicLink -Value $HOME\dotfiles\.ideavimrc
New-Item -Force -Path $HOME\.vimrc -ItemType SymbolicLink -Value $HOME\dotfiles\.vimrc
New-Item -Force -Path "C:\Program Files\Dual Key Remap\config.txt" -ItemType SymbolicLink -Value $HOME\dotfiles\dual-key-remap-settings.txt
New-Item -Force -Path C:\Users\Adrian\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json -ItemType SymbolicLink -Value $HOME\dotfiles\windows-terminal-settings.json
New-Item -Force -Path $HOME\gallery-dl.conf -ItemType SymbolicLink -Value $HOME\dotfiles\gallery-dl.conf
New-Item -Force -Path $HOME\yt-dlp.conf -ItemType SymbolicLink -Value $HOME\dotfiles\yt-dlp.conf
New-Item -Force -Path $HOME\AppData\Roaming\Code\User\snippets\ -ItemType SymbolicLink -Value "$HOME\dotfiles\VS Code\Snippets"
New-Item -Force -Path $HOME\AppData\Roaming\Code\User\keybindings.json -ItemType SymbolicLink -Value "$HOME\dotfiles\VS Code\keybindings.json"
New-Item -Force -Path $HOME\AppData\Roaming\Code\User\settings.json -ItemType SymbolicLink -Value "$HOME\dotfiles\VS Code\settings.json"
