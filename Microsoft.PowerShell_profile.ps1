# Remove username@host from prompt
$global:DefaultUser = [System.Environment]::UserName

Import-Module posh-git
Import-Module oh-my-posh

Set-Theme AgnosterModified

# Enable Vi mode
Set-PSReadlineOption -EditMode vi

# Change cursor in different modes
function OnViModeChange {
    if ($args[0] -eq 'Command') {
        # Set the cursor to a blinking block.
        Write-Host -NoNewLine "`e[1 q"
    }
    else {
        # Set the cursor to a blinking line.
        Write-Host -NoNewLine "`e[5 q"
    }
}

Set-PSReadLineOption -ViModeIndicator Script -ViModeChangeHandler $Function:OnViModeChange

# Fish-like completion
Set-PSReadLineOption -PredictionSource History

Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# Disable bell sound
Set-PSReadlineOption -BellStyle None

# History
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineKeyHandler -Chord ctrl+k -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Chord ctrl+j -Function HistorySearchForward

Set-PSReadLineKeyHandler -Chord ctrl+l -Function ViForwardChar
Set-PSReadLineKeyHandler -Chord ctrl+w -Function BackwardDeleteWord
Set-PSReadLineKeyHandler -Chord ctrl+h -Function BackwardDeleteChar
