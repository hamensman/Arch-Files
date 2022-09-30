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
pacman -Syu --needed --noconfirm networkmanager grub git
systemctl enable NetworkManager
grub-install /dev/nvme0n1
# Update GRUB
grub mkconfig -o /boot/grub/grub.cfg

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
useradd -m -g wheel video user
# Prompt to create password - actual password not written in script for security purposes
read -p "Enter password: " -s password
$password | passwd user
# Remove no password sudo rights
sed -i 's/^%wheel ALL=(ALL) NOPASSWD: ALL/# %wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
sed -i 's/^%wheel ALL=(ALL:ALL) NOPASSWD: ALL/# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers
# Add sudo rights
sed -i 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

echo -ne "
-------------------------------------------------------------------------
                    Install Paru AUR Helper
-------------------------------------------------------------------------
"
cd $HOME
mkdir .config
cd $HOME/.config
git clone https://aur.archlinux.org/yay-git.git
cd paru
makepkg -si --noconfirm
cd $HOME
yay -S --noconfirm --needed paru
paru -Rns --noconfirm yay
rm -R $HOME/.config/yay*

echo -ne "
-------------------------------------------------------------------------
                    Install packages
-------------------------------------------------------------------------
"

paru -S --needed --noconfirm \
	acpi \
	adwaita-dark \
	alsa-utils \
	android-sdk-platform-tools \
	android-tools \
	arandr \
	arc-gtk-theme \
	arc-icon-theme \
	archlinux-wallpaper \
	awesome \
	birdtray \
	blueman \
	brasero \
	brave-bin \
	breeze \
	brother-dcp1610w \
	calcurse \
	catppuccin-gtk-theme-mocha \
	catppuccin-mocha-grub-theme-git \
	chromium \
	ctags \
	cups \
	devour \
	dolphin-emu \
	dragon-drop \
	ds4drv \
	element-desktop \
	ffmpegthumbnailer \
	figlet \
	firefox \
	freetube-bin \
	fzf \
	gnome-disk-utility \
	gparted \
	groff \
	grub \
	gzip \
	hakuneko-desktop \
	htop \
	i3lock-color \
	ibus-hangul \
	ibus-libpinyin \
	ibus-mozc \
	instaloader \
	jdownloader2 \
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
	librewolf-bin \
	lxappearance \
	mpd \
	mpv \
	ncmpcpp \
	nemo \
	network-manager-applet \
	noto-fonts \
	noto-fonts-cjk \
	noto-fonts-emoji \
	noto-fonts-extra \
	nsxiv \
	ntfs-3g \
	nvim \
	obs-studio \
	odysee-nativefier \
	pamixer \
	papirus-icon-theme \
	patch \
	pavucontrol \
	pfetch \
	picom \
	pkg2zip-fork \
	pkgconf \
	pkhex \
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
	python-uinput \
	python-zstandard \
	ranger \
	rofi \
	schildichat-desktop-bin \
	screenkey \
	scrot \
	sddm \
	sddm-theme-catppuccin-git \
	session-desktop-bin \
	signal-desktop \
	simple-mtpfs \
	system-config-printer \
	thunderbird \
	timeshift \
	torrent7z \
	transmission-cli \
	transmission-gtk \
	ttf-unifont \
	tty-clock-git \
	udiskie \
	ueberzug
	vscodium-bin \
	windscribe-cli \
	xclip \
	xdg-ninja \
	xed \
	xfburn \
	xfce4-notifyd \
	xorg-server \
	acpilight \
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
                    Allow Printing
-------------------------------------------------------------------------
"
systemctl start --now cups
systemctl start --now cups.socket
systemctl start --now cups.path
systemctl enable --now cups
systemctl enable --now cups.socket
systemctl enable --now cups.path

echo -ne "
-------------------------------------------------------------------------
                    Change Default Shell from BASH to ZSH
-------------------------------------------------------------------------
"
chsh -s /usr/bin/zsh

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
