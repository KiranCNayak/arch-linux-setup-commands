########################     NETWORKING     #######################
# If there is no ethernet available (Do this only if this the case)
wifi-menu
#  ->>  This will give you the list of wifi devices near you. Select
#       one of them and give the details (Password of the Network).
#
# ----- ----- ----- ----- To list IP addresses ----- ----- ----- -----
ip addr show
#   or
ip a
#  ->>  This should show the IP address if connection was successful
#       If not try this command again till it connects and an IP addr
#       is assigned. Test with a ping to some network.
#
# ----- SSH into Arch Linux Machine after successful connection  -----
ssh root@<IPADDR_OF_THE_MACHINE_IN_THE_NETWORK>
#Enter the password
#  ->>  This should give the access to that machine.
#----------------------------------------------------------------------
#
#
########################     DISK UTILITY     ######################
# First check the devices that are recognised by the system.
fdisk -l
#  ->>  Result should have devices like sda, sdb, etc.
#
# To select a particular disk and do changes to it
fdisk /dev/sda
#  ->>  This will get you inside the fdisk utility to edit / make 
#       partition table / partitions on the selected disk.
# 
# Here, note that the terminal will be in fdisk utility so the shell
# PS1 would become: `Command (m for help):`. Here type `g`
g
#  ->>  This will let the Utility know that the Partition table
#       required is GPT.
#
# Now before making any change to the drive we can view the current
# partition by typing `p` to preview the changes so far.
p
# To create a new Partition type `n`
n
#  ->>  This will ask for additional details.
#   1.  Partition number -> Just Hit Enter (Let s/m assign it for you)
#   2.  First sector     -> Just Hit Enter (Let s/m assign it for you)
#   3.  Last sector      -> Set a number like +1G to allocate 1GB size
#   4.  Accept changes   -> Type `Y` to remove Signature
#
# After the confirmation, we have successfully created the first
# partition for EFI. Choose about 500MB to 1GB for this space.
#
# Again do the same to have the space for root File System, follow the
# same steps as mentioned before.
n
# Enter
# Enter
# Allocate ~30GB (by typing +30G)
# `Y`
#
#
# After the confirmation, we have successfully created the second
# partition for Root FS. Choose about 30GB to 40GB for this space.
#
# Again do the same to have the space for root File System, follow the
# same steps as mentioned before.
n
# Enter
# Enter
# Allocate ~30GB (by typing +30G)
# `Y`
#
#
# After the confirmation, we have successfully created the first
# partition for EFI. Choose about 500MB to 1GB for this space.
#
# Again do the same to have the space for home File System, follow the
# same steps as mentioned before.
n
# Enter
# Enter
# Enter (This is important!! What we are doing here is allocating all
#        of the remaining space to home directory.)
# `Y`
#
# Now the partitions are all finalised. Go ahead and write these changes
# to the system by typing `w`
w
#  ->>  This will WRITE to the disk (All partitions will be written)
#
# Verify your changes with fdisk -l
fdisk -l
#
# The partition making alone is not going to allocate File Systems. We
# need to allocate specific FS to these newly allocated Partitions.
# 
# To create a FAT FS (EFI must be in FAT32 File System)
mkfs.fat -F32 /dev/sda1
#
# For other two partitions create EXT4 File System.
mkfs.ext4 /dev/sda2
mkfs.ext4 /dev/sda3
#
# After this all the partitions are now having a File System!!
#
# Now we need to mount the partitions so that the system boots
mount /dev/sda2 /mnt
#  ->>  This will mount the second partition to the root of the s/m
#
# Next we will need to mount the home directories inside this newly
# created root directory. So first, create a new directory for home.
mkdir /mnt/home
# Now mount the third partition (Home directory partition) to this
# newly created directory.
mount /dev/sda3 /mnt/home
#
# To see the changes for the disk made till now
mount | grep sda
#
#
###################     INSTALLING ARCH LINUX     ##################
# Very IMPORTANT : DON'T REBOOT AT ANY POINT NOW, UNTILL SPECIFIED.
#
pacstrap -i /mnt base
#
# It will ask to install certain required tools / packages, hit Enter
#
# Again for the Core Repos, select the default one (Press Enter)
#
# Type 'Y' to proceed with the installation
#
#
# Now we will be generating the fstab file, which tells the system
# which partitions to mount at boot time
genfstab -U -p /mnt >> /mnt/etc/fstab
#
# To see what is generated there
cat /mnt/etc/fstab
#
# Now we want to go inside as root to the inprogress Arch Linux, that
# can be done by chroot command
arch-chroot /mnt
#
# Verify that you are online by pinging a server.
#
# Install some packages
pacman -S base-devel grub efibootmgr dosfstools openssh os-prober mtools linux-headers linux-lts linux-lts-headers network-manager-applet networkmanager wireless_tools wpa_supplicant dialog
# Press Enter now to accept defaults
# Press Enter again
#
# Now we need to edit the locale to our specific region. Do it from
# /etc/locale.gen
nano /etc/locale.gen
#
# Uncomment the one that is needed. Ex. en_US.UTF-8 UTF-8
# In nano Ctrl + O to write, press Enter. Crtl + X to exit
#
# Now generate the locale.
locale-gen
#
#Enable openssh to open at login
systemctl enable sshd
#
#
# SETUP EFI
mkdir /boot/EFI
#
# Now mount the first partition to this directory
mount /dev/sda1 /boot/EFI
#
# Now install GRUB to actually boot
grub-install --target=x86_64-efi --bootloader-id=grub-efi --recheck
#
# Copy this file
cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo
#
# Build the GRUB Configuration
grub-mkconfig -o /boot/grub/grub.cfg
#
#
# CREATING Swap File
# Instead of using a dedicated partition to swap, we can just make use of
# swap file. This is helpful over the partition couterpart, because here 
# we can delete this file & assign a new file with bigger / smaller size.
#
# Here the space can be measured in terms of RAM. Suggested is 1:1 of RAM
# For a system with 8GB RAM, assign 8GB to swap file.
fallocate -l 8G /swapfile
#
# Change the permission to 600 ( == Root with Read / Write)
chmod 600 /swapfile
#
# Make the file into a `swap file`
mkswap /swapfile
#
# Now add this entry to fstab (-a to add it at the end: append)
echo '/swapfile none swap sw 0 0' | tee -a /etc/fstab
#
# Now the installation is complete. Exit out of the inprogress Arch Linux
exit
#
# Unmount everything. No issues, even though some might saw target is busy
umount -a
#
# Final moment of truth!!!
reboot
