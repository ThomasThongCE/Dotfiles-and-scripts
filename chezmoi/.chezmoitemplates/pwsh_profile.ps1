function y {
    $tmp = [System.IO.Path]::GetTempFileName()
    try {
        yazi @args --cwd-file="$tmp"
        $cwd = (Get-Content -LiteralPath $tmp -Raw -Encoding UTF8).Trim()
        if ($cwd -and $cwd -ne $PWD.Path -and (Test-Path -LiteralPath $cwd)) {
            Set-Location -LiteralPath $cwd
        }
    }
    finally {
        Remove-Item -LiteralPath $tmp -Force -ErrorAction SilentlyContinue
    }
}
function v { nvim @args }
function c { code @args }
function q { exit }
function m { make @args }

# psmux sets TMUX/TMUX_PANE but serves no tmux socket, so Claude Code detects
# mux=tmux and its `tmux display-message -p '#{pane_id}'` probe fails, killing
# subagent spawn. Vars are restored so other tools in the pane still see them.
function claude {
    $t, $p = $env:TMUX, $env:TMUX_PANE
    try {
        if ($env:TMUX -like '*psmux*') { $env:TMUX = $null; $env:TMUX_PANE = $null }
        & "$env:USERPROFILE\.local\bin\claude.exe" @args
    }
    finally { $env:TMUX, $env:TMUX_PANE = $t, $p }
}

# git aliases (Remove built-in aliases: gc=Get-Content gl=Get-Location gp=Get-ItemProperty outrank functions)
Remove-Alias -Name gc -Force -ErrorAction SilentlyContinue
Remove-Alias -Name gl -Force -ErrorAction SilentlyContinue
Remove-Alias -Name gp -Force -ErrorAction SilentlyContinue
function g   { git @args }
function ga  { git add @args }
function gst { git status @args }
function gc  { git commit --verbose @args }
function gc! { git commit --verbose --amend @args }
function gsu { git submodule update @args }
function gl  { git pull @args }
function gp  { git push @args }
function gf  { git fetch @args }
function gb  { git branch @args }
function lg  { lazygit @args }

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
function glog { git log --oneline --graph --decorate @args }
