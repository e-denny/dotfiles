# xsetroot -solid gray &
# termite &

# Set fallback cursor
xhost +
xsetroot -cursor_name left_ptr

# If Emacs is started in server mode, `emacsclient` is a convenient way to edit
# files in place (used by e.g. `git commit`)
export VISUAL=emacsclient
export EDITOR="$VISUAL"

export _JAVA_AWT_WM_NONREPARENTING=1

# Set capslock as ctrl
setxkbmap -layout us -option ctrl:nocaps
xrandr --output eDP-1 --off --output DP-2 --auto
# export GDK_SCALE=2
# export GDK_DPI_SCALE=0.5
#exec emacs
# exec i3
#emacs --daemon -f exwm-enable
#exec emacsclient -c

exec startxfce4 &
sleep 0.3
# blueman-applet &
# udiskie --tray &
# syncthing -no-browser &
# redshift &
# killall -q compton; compton --config ~/.config/compton/compton.conf &
exec dbus-launch --exit-with-session emacs
