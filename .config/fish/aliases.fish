alias la 'ls -latr'
alias cd.. 'cd ..'
alias .. 'cd ..'
alias ... 'cd ../..'
alias .... 'cd ../../..'
alias ..... 'cd ../../../..'
alias cx 'chmod +x'
alias 'c-x' 'chmod -x'

# fuzzy find to open in vi
alias vif 'nvim (find ~ -type f -not -path "/*.mozilla/*" -not -path "*/.git/*" -not -path "*/.local/*" -not -path "*/.cache/*" -print | fzf)'
