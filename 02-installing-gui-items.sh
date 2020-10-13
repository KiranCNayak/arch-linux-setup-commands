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
# Now make the service available
systemctl status NetworkManager
#
# Now start this service
systemctl start NetworkManager
#
#  
# If you are using wifi, don't run the next command now. If you are
# using ethernet, then go ahead and run this command.
systemctl enable NetworkManager
# 
# Run these to have the Repo index to the most recent data
pacman -Syyy
# 
# Get the xorgserver
pacman -S xorg-server
# Press Enter
# 
# To install the Video Card Driver we need to know which video card
# we have, to do that type this command.
lspci
# 
# For normal laptops it will be Intel with Integrated Graphics.
pacman -S xf86-video-intel libgl mesa 
# Press Enter
# 
# For any other manufacturer like NVidia
pacman -S nvidia nvidia-lts nvidia-libgl mesa
# 
# For Virtual Box environment install these tools
pacman -S virtualbox-guest-utils virtualbox-guest-modules-arch mesa mesa-libgl 
# 
# 
#######################     CREATE USER     ######################
# Add a user with home directory (specified by -m) with group users,
# along with supplementary groups (specified by -G). `wheel` is used
# to run administrative commands. `dale` is the actual name of user.
useradd -m -g users -G wheel dale
# 
# Set the password to this user
passwd dale
# 
# 
###################     DESKTOP ENVIRONMENT     ##################
# 
# Install a Desktop Manager
# For gnome use gdm
pacman -S gdm
# 
# For KDE
pacman -S sddm
# 
# For XFCE4
pacman -S xfce4
# 
# NOTE: only one of them can be run at a time so better to install
#       ONLY ONE. Although others can be installed and switched.
# After the installation, based on which one you selected run,
systemctl enable gdm
#       OR
systemctl enable sddm
#       OR
systemctl enable xfce4
# 
#-----------------------------------------------------------------
##### OPTIONAL - CHOOSE THESE BASED ON WHAT YOU CHOSE EARLIER #### 
#-----------------------------------------------------------------

# 1. If you chose gdm then go ahead with these
pacman -S gnome gnome-terminal nautilus gnome-tweaks gnome-control-center firefox gnome-backgrounds adwaita-icon-theme arc-gtk-theme
#       OR
# 2. If you chose sddm (KDE Plasma) then go ahead with these
pacman -S plasma konsole dolphin
#       OR
# 3. If you chose xfce4 then go ahead with these
pacman -S xfce4-goodies xfce4-terminal
# 
# 
# If you had used Wifi and didn't run the enable command for
#  NetworkManager, do it here.
systemctl enable NetworkManager
# 
# 
# Final, moment of Truth!!
reboot
