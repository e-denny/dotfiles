. ~/.config/fish/aliases.fish

set -g theme_powerline_fonts yes
set -g theme_display_git yes
set -g theme_display_git_dirty yes
set -g theme_display_git_untracked yes
set -g theme_display_git_ahead_verbose yes
set -g theme_display_git_dirty_verbose yes
set -g theme_display_git_master_branch yes
set -g theme_title_display_user yes
set -g theme_title_use_abbreviated_path yes
set -g theme_display_hostname yes
set -g theme_color_scheme base16
set -g theme_nerd_fonts yes
set -g theme_powerline_fonts yes
set -g theme_display_user yes

set -gx FZF_DEFAULT_COMMAND 'ag --hidden --ignore .git -g ""'
set -gx FZF_DEFAULT_OPTS '--height 40% --border --inline-info'

