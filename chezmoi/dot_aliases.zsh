# Aliases — sourced by ~/.zshrc (mirrors pwsh aliases.ps1)
# Existing zsh aliases
alias v='nvim'
alias vi3c='vim ~/.config/i3/config'
alias vzc='vim ~/.zshrc'
alias vc='vim ~/.vimrc'
alias m=make
alias mj='make -j$(nproc)'

# WSL: redirect build tools to Windows-side wrappers
if [[ $(grep -i Microsoft /proc/version) ]]; then
    alias git=~/bin/git.sh
    alias clang-tidy=~/bin/clang-tidy.sh
    alias make=~/bin/make.sh
    alias check='mkdir -p cppcheckBuild && cppcheck.exe --addon=misra --enable=all --inconclusive --platform=unspecified --cppcheck-build-dir=cppcheckBuild --output-file=cppcheck.log --project=Build/compile_commands.json --suppress=missingInclude'
fi

# ESP-IDF
alias get_idf='. $HOME/esp/esp-idf/export.sh'

# ── Migrated from pwsh (aliases.ps1) ──
# y: yazi quit-to-directory integration (zsh equivalent of pwsh function y)
function y() {
    local tmp=$(mktemp -t "yazi-cwd.XXXXXX")
    yazi "$@" --cwd-file="$tmp"
    if cwd=$(command cat "$tmp"); then
        if [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
            builtin cd -- "$cwd"
        fi
    fi
    rm -f "$tmp"
}

# c: VS Code
alias c='code'
# q: exit shell
alias q='exit'

# Git shortcuts (mirror pwsh g/gc/gl/...)
alias g='git'
alias ga='git add'
alias gst='git status'
alias gc='git commit --verbose'
alias gc!='git commit --verbose --amend'
alias gsu='git submodule update'
alias gl='git pull'
alias gp='git push'
alias gf='git fetch'
alias gb='git branch'
alias lg='lazygit'
alias glog='git log --oneline --graph --decorate'
