# xsetroot -solid gray &
# termite &

# Set fallback cursor
xsetroot -cursor_name left_ptr

# If Emacs is started in server mode, `emacsclient` is a convenient way to edit
# files in place (used by e.g. `git commit`)
export VISUAL=emacsclient
export EDITOR="$VISUAL"

export _JAVA_AWT_WM_NONREPARENTING=1

# Set capslock as ctrl
setxkbmap -layout us -option ctrl:nocaps
xrandr --output eDP-1 --off --output DP-2 --auto
export GDK_SCALE=2
# export GDK_DPI_SCALE=0.5
exec emacs
