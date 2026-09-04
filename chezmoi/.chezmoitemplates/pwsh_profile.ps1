# Dot-source pwsh aliases from the adjacent aliases.ps1.
$aliasesFile = Join-Path $PSScriptRoot 'aliases.ps1'
if (Test-Path -LiteralPath $aliasesFile) {
    . $aliasesFile
}

# Vi editing. MUST come before the key handlers below: switching EditMode
# resets bindings to that mode's defaults, so anything bound earlier is lost.
Set-PSReadLineOption -EditMode Vi
Set-PSReadLineOption -ViModeIndicator Cursor
# Vi mode binds Ctrl+d to ViAcceptLineOrExit: on an empty line it exits the
# shell, which closes the psmux pane. DeleteChar never exits.
Set-PSReadLineKeyHandler -Chord Ctrl+d -ViMode Insert  -Function DeleteChar
Set-PSReadLineKeyHandler -Chord Ctrl+d -ViMode Command -Function DeleteChar

# Editor for PSReadLine's ViEditVisually (`v` in vi command mode) -> pops the
# current command line into nvim; save+quit sends it back to the prompt.
$env:EDITOR = 'nvim'
$env:VISUAL = 'nvim'

# zsh menu completion (AUTO_MENU): Tab lists candidates and cycles the
# highlighted one. ViTabCompleteNext cycles without showing the list.
Set-PSReadLineKeyHandler -Key Tab -ViMode Insert -Function MenuComplete

# Predictive IntelliSense ghost text. Vi mode binds no AcceptSuggestion key,
# and Tab completion never accepts a prediction, so an explicit chord is needed.
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineKeyHandler -Chord Ctrl+f -ViMode Insert -Function AcceptSuggestion
Set-PSReadLineKeyHandler -Chord Alt+f  -ViMode Insert -Function AcceptNextSuggestionWord

# zsh-like prefix history search (history-beginning-search-*-end)
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineKeyHandler -Key Ctrl+p    -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key Ctrl+n    -Function HistorySearchForward
Set-PSReadLineKeyHandler -Key UpArrow   -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
