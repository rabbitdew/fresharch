#!/bin/bash
timedatectl set-ntp true 
gdisk /dev/sda <<EOF
r
x
l
34
m
n
1
34
2047
ef02
r
x
l
2048
m
n


+1024

n




w
y
EOF

mkswap /dev/sda2
swapon /dev/sda2
mkfs.ext4 -q /dev/sda3
mount /dev/sda3 /mnt
mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.orig
egrep -A1 '(United|Canada)' /etc/pacman.d/mirrorlist.orig | tr -d '-' > /etc/pacman.d/mirrorlist
pacstrap /mnt base openssh git grub lsof tcpdump tmux zsh
genfstab -U /mnt >> /mnt/etc/fstab
cat <<EOF > /mnt/root/.bashrc
ln -sf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen
locale-gen
echo 'LANG=en_US.UTF-8' > /etc/locale.conf
hwclock --systohc
printf 'rabbitdewarch' > /etc/hostname
printf "127.0.0.1\tlocalhost\n::1\tlocalhost\n127.0.1.1\trabbitdewarch" >> /etc/hosts
echo "root:newpass" | chpasswd
systemctl enable dhcpcd sshd
grub-install /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg
exit 
EOF
arch-chroot /mnt
umount -R /mnt
reboot
