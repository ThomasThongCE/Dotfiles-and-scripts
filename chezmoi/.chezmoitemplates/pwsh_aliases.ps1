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

function glog { git log --oneline --graph --decorate @args }
