#!/bin/sh
echo \
"#!/bin/sh

# sourced at boot by ~/.xinitrc and most display managers

if xrandr | grep -Eq "HDMI-2 connected" && xrandr | grep -Eq "DP-1-1 connected";
then
    xrandr --output eDP-1 --primary --mode 1920x1080 --pos 0x1080 --rotate normal --output DP-1 --off --output HDMI-1 --off --output HDMI-2 --mode 1920x1080 --pos 0x1080 --rotate normal --output DP-1-1 --mode 1920x1080 --pos 0x0 --rotate inverted --output DP-1-2 --off --output DP-1-3 --off
elif xrandr | grep -Eq "HDMI-2 connected" && xrandr | grep -Eq "DP-1-1 disconnected";
then
    xrandr --output eDP-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DP-1 --off --output HDMI-1 --off --output HDMI-2 --mode 1920x1080 --pos 0x0 --rotate normal --output DP-1-1 --off --output DP-1-2 --off --output DP-1-3 --off
else
    xrandr --output eDP1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DP1 --off --output DP-1-1 --off --output DP-1-2 --off --output DP-1-3 --off --output DP2 --off --output HDMI-1 --off --output HDMI-2 --off --output VIRTUAL1 --off
fi

export XDG_CONFIG_HOME=/home/user/.config
export PATH=/home/user/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl
export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus

ibus-daemon -drx
nm-applet &
blueman-applet &
udiskie &
#simple-mtpfs --device 1 /run/media/user/android_device_1 &
#simple-mtpfs --device 2 /run/media/user/android_device_2 &
picom -b &
mpd &
setbg ~/Pictures/Wallpapers &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
/usr/lib/xfce4/notifyd/xfce4-notifyd &
setxkbmap -option caps:swapescape &
birdtray &
xrdb -merge $XDG_CONFIG_HOME/X11/xresources &
#sxhkd &
#/home/user/.config/polybar/launch.sh &" > $HOME/.xprofile
