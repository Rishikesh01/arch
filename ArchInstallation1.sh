
echo"Installing reflector"
pacman -Sy 
pacman -S reflector
echo"running reflector"
reflector --verbose --latest 5 --sort rate --save /etc/pacman.d/mirrorlist
echo"cfdisk"
cfdisk

echo -n"Enter ext4 partion id"
read ext4Var
echo -n"Enter swap partion id"
read swapPartion

mkfs.ext4 /dev/${ext4Var}
mkswap /dev/${swapPartion}
swapon /dev/${swapPartion}

echo"mounting /mnt"

mount /dev/${ext4Var} /mnt

echo"pacstraping"
pacstrap /mnt base linux base-devel linux-firmware base-devel gnome i3 nvidia bbswitch codeblocks rofi thunar networkmanager ntfs-3g lightdm lightdm-webkit2-greeter firefox chromium telegram-desktop git sudo network-manager-applet cpupower lib32-mesa xf86-video-intel acpi wpa_supplicant  dialog  xorg xorg-server-utils  xorg-xinit gnome-tweaks  jre11-openjdk jdk11-openjdk openjdk11-doc gparted lxappearance feh neofetch polkit-gnome weechat picom discord linux-lts dosfstools grub efibootmgr intel-ucode

echo"genfstab -U /mnt >> /mnt/etc/fstab"
genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt ln -sf /usr/share/zoneinfo/India/Kolkata /etc/localtime
echo "en_US.UTF-8 UTF-8 " >> /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 >> /etc/locale.conf
export LANG=en_US.UTF-8
echo arch > /etc/hostname
echo -e "127.0.0.1\tlocalhost\n::1\t\tlocalhost\n127.0.1.1\tarchlinux.localdomain\tarchlinux" > /mnt/etc/hosts

echo "enter root password"
arch-chroot /mnt passwd
echo "enter username"
read userName
arch-chroot /mnt useradd -m -G wheel -s /bin/bash ${userName}
echo"add password to root and user"
arch-chroot /mnt chpasswd

arch-chroot /mnt mkdir /boot/efi
arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=grub --recheck

arch-chroot /mnt grub-mkconfig -o boot/grub/grub.cfg

umount -R /mnt
reboot
