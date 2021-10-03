New-Item -Force -Path $HOME\Documents\Powershell\Microsoft.Powershell_profile.ps1 -ItemType SymbolicLink -Value $HOME\dotfiles\Microsoft.Powershell_profile.ps1

New-Item -Force -Path $HOME\.doom.d\ -ItemType SymbolicLink -Value $HOME\dotfiles\.doom.d\
New-Item -Force -Path "$HOME\AutoHotkey Scripts\" -ItemType SymbolicLink -Value "$HOME\dotfiles\AutoHotkey Scripts\"
New-Item -Force -Path "$HOME\Reaper Scripts\" -ItemType SymbolicLink -Value "$HOME\dotfiles\Reaper Scripts\"

New-Item -Force -Path $HOME\.gitconfig -ItemType SymbolicLink -Value $HOME\dotfiles\.gitconfig
New-Item -Force -Path $HOME\.ideavimrc -ItemType SymbolicLink -Value $HOME\dotfiles\.ideavimrc
New-Item -Force -Path $HOME\.vimrc -ItemType SymbolicLink -Value $HOME\dotfiles\.vimrc
New-Item -Force -Path $HOME\.zshrc -ItemType SymbolicLink -Value $HOME\dotfiles\.zshrc
New-Item -Force -Path "C:\Program Files\Dual Key Remap\config.txt" -ItemType SymbolicLink -Value $HOME\dotfiles\dual-key-remap-settings.txt
New-Item -Force -Path $HOME\windows-terminal-settings.json -ItemType SymbolicLink -Value $HOME\dotfiles\windows-terminal-settings.json
