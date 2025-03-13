oh-my-posh init pwsh --config "$HOME\dotfiles\custom_velvet.omp.json" | Invoke-Expression

# Disable venv prompt as velvet theme already has it
$env:VIRTUAL_ENV_DISABLE_PROMPT = 1

# Enable Vi mode
$OnViModeChange = [scriptblock] {
    if ($args[0] -eq 'Command') {
        # Set the cursor to a blinking block.
        Write-Host -NoNewLine "`e[1 q"
    }
    else {
        # Set the cursor to a blinking line.
        Write-Host -NoNewLine "`e[5 q"
    }
}

Set-PsReadLineOption -EditMode Vi
Set-PSReadLineOption -ViModeIndicator Script -ViModeChangeHandler $OnViModeChange

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
Set-PSReadLineKeyHandler -Chord alt+l -Function ForwardWord
Set-PSReadLineKeyHandler -Chord ctrl+w -Function BackwardDeleteWord
Set-PSReadLineKeyHandler -Chord ctrl+h -Function BackwardDeleteChar

function urlencode { param($text) [System.Web.HttpUtility]::UrlEncode($text) }

function urldecode { param($text) [System.Web.HttpUtility]::UrlDecode($text) }
