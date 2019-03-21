function fzfv
    set choice (rg -il $argv | fzf -0 -1 --ansi --preview "cat {} | rg $argv --context 3")
    if [ $choice ]
        nvim $choice
    end
end

# function install -d "Interactive package installer"
#  if [ $argv[1] ]
#    set choice $argv[1]
#  else
#    set choice (brew search | fzf --reverse --preview "brew info {}" --preview-window=right:75%)
#  end
#  if [ $choice ]
#    brew install $choice
#  end
# end
