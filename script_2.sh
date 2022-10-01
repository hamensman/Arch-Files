#!/bin/sh
echo -ne "
-------------------------------------------------------------------------
                      █████╗ ██████╗  ██████╗██╗  ██╗
                     ██╔══██╗██╔══██╗██╔════╝██║  ██║
                     ███████║██████╔╝██║     ███████║
                     ██╔══██║██╔══██╗██║     ██╔══██║
                     ██║  ██║██║  ██║╚██████╗██║  ██║
                     ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝
-------------------------------------------------------------------------
                    Automated Arch Linux Installer Part 2
-------------------------------------------------------------------------
"

echo -ne "
-------------------------------------------------------------------------
                    GRUB BIOS Bootloader Install
-------------------------------------------------------------------------
"
# Install GRUB on drive
pacman -Syu --noconfirm --needed networkmanager grub
systemctl enable NetworkManager
grub-install /dev/nvme0n1
# Update GRUB
grub-mkconfig -o /boot/grub/grub.cfg

echo -ne "
-------------------------------------------------------------------------
                    Setup Language to GB and set locale
-------------------------------------------------------------------------
"
# British English locale
sed -i 's/^#en_GB.UTF-8 UTF-8/en_GB.UTF-8 UTF-8/' /etc/locale.gen
sed -i 's/^#en_GB ISO-8859-1/en_GB ISO-8859-1/' /etc/locale.gen
locale-gen
echo "LANG=en_GB.UTF-8" > /etc/locale.conf
# Setup London as timezone
ln -s /usr/share/zoneinfo/Europe/London /etc/localtime

echo -ne "
-------------------------------------------------------------------------
                    Create Hostname
-------------------------------------------------------------------------
"
# Create hostname called "Computer"
echo "Computer" > /etc/hostname
echo "Hostname:"
cat /etc/hostname

echo -ne "
-------------------------------------------------------------------------
                    Setup User Account
-------------------------------------------------------------------------
"
# Create user called "user"
useradd -m -G wheel user
usermod -a -G video user
# Create password
passwd user
# Remove no password sudo rights
sed -i 's/^%wheel ALL=(ALL) NOPASSWD: ALL/# %wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
sed -i 's/^%wheel ALL=(ALL:ALL) NOPASSWD: ALL/# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers
# Add sudo rights
sed -i 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

echo -ne "
-------------------------------------------------------------------------
                    Install packages
-------------------------------------------------------------------------
"

pacman -S --noconfirm --needed \
	acpi \
	alsa-utils \
	arandr \
	arc-gtk-theme \
	arc-icon-theme \
	awesome \
	blueman \
	brasero \
	breeze \
	calcurse \
	chromium \
	ctags \
	cups \
	dolphin-emu \
	element-desktop \
	ffmpegthumbnailer \
	figlet \
	firefox \
	fzf \
	git \
	gnome-disk-utility \
	gparted \
	groff \
	grub \
	htop \
	ibus-hangul \
	ibus-libpinyin \
	jq \
	keepassxc \
	kitty \
	kolourpaint \
	libreoffice-still \
	libreoffice-still-en-gb \
	libreoffice-still-ja \
	libreoffice-still-ko \
	libreoffice-still-zh-cn \
	libreoffice-still-zh-tw \
	libtool \
	linux \
	linux-firmware \
	linux-headers \
	lxappearance \
	mesa-utils \
	mktorrent \
	mpd \
	mpv \
	ncmpcpp \
	nemo \
	neovim \
	network-manager-applet \
	networkmanager \
	noto-fonts \
	noto-fonts-cjk \
	noto-fonts-emoji \
	noto-fonts-extra \
	ntfs-3g \
	ntp \
	nvidia \
	obs-studio \
	pamixer \
	papirus-icon-theme \
	pavucontrol \
	picom \
	polkit-gnome \
	ppsspp \
	pulseaudio-alsa \
	pulseaudio-bluetooth \
	python-dbus-next \
	python-pip \
	python-pycryptodome \
	python-pydbus \
	python-pyinotify \
	python-pynvim \
	python-pyusb \
	python-tqdm \
	python-zstandard \
	ranger \
	rofi \
	screenkey \
	scrot \
	sddm \
	signal-desktop \
	system-config-printer \
	thunderbird \
	transmission-cli \
	transmission-gtk \
	udiskie \
	ueberzug \
	virtualbox \
	xclip \
	xed \
	xfburn \
	xfce4-notifyd \
	xorg-server \
	xorg-xbacklight \
	xorg-xinit \
	xorg-xmodmap \
	xorg-xrandr \
	xorg-xrdb \
	xwallpaper \
	zathura \
	zathura-pdf-poppler \
	zsh \
	zsh-completions \
	zsh-syntax-highlighting

echo -ne "
-------------------------------------------------------------------------
                    Create .xprofile
-------------------------------------------------------------------------
"
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

echo -ne "
-------------------------------------------------------------------------
                    Finished!
-------------------------------------------------------------------------
"
exit
umount -R /mnt
reboot
