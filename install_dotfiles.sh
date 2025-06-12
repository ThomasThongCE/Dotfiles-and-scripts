backup_if_exists() {
    checks=$(stow -t $HOME -d $1 -nv . 2>&1 | \
        egrep '\* existing target is ' | \
        sed 's/  \* existing target is neither a link nor a directory: //'); \
    for file in $checks; do \
        filepath=$HOME/$file; \
        backup_suffix="backup-$(date -u +%Y%m%d%H%M%S)"; \
        echo "Creating backup $filepath.$backup_suffix"; \
        mv "$filepath" "$filepath.$backup_suffix"; \
    done
}

for f in ./dotfiles/*; do
   backup_if_exists ${f}
   stow -t $HOME -d $f .
done

