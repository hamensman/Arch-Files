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
                    Automated Arch Linux Installer Part 1
-------------------------------------------------------------------------
"

echo -ne "
-------------------------------------------------------------------------
                    Update System Clock
-------------------------------------------------------------------------
"
timedatectl set-ntp true
timedatectl status

echo -ne "
-------------------------------------------------------------------------
                    Setup Partitions
-------------------------------------------------------------------------
"
# Automate fdisk prompts - creates a 128M boot partition as nvme0n1p1 and the remaining space as a linux filesystem partition as nvme0n1p2
printf "o\nn\n\n1\n\n+128M\nn\n\n2\n\n\na\n1\nw\n" | fdisk /dev/nvme0n1

echo -ne "
-------------------------------------------------------------------------
                    Format Partitions
-------------------------------------------------------------------------
"
mkfs.ext4 /dev/nvme0n1p1
mkfs.ext4 /dev/nvme0n1p2
mount /dev/nvme0n1p2 /mnt
mkdir /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot

echo -ne "
-------------------------------------------------------------------------
                    Arch Linux Base Install on Main Drive
-------------------------------------------------------------------------
"
# Enable parallel downloads
sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
# Update keyrings to latest to prevent packages failing to install
# Install base package to main drive
pacstrap /mnt base base-devel linux linux-firmware
# Generate fstab
genfstab -U /mnt >> /mnt/etc/fstab
echo "
  Generated /etc/fstab:
"
cat /mnt/etc/fstab

echo -ne "
-------------------------------------------------------------------------
                    Move from USB to Main Drive - Moving to Part 2!
-------------------------------------------------------------------------
"
# Mount to main drive
cp script_2.sh /mnt/script_2.sh
echo "
  Run this command: arch-chroot /mnt /bin/bash
"
echo "
  Then this command: sh script_2.sh
"
