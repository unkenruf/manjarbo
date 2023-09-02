!#/bin/bash

if ! [ $(id -u) = 0 ]; then
	echo "The script needs to be run as root." >&2
	exit 1
fi

if [ $SUDO_USER ]; then
	real_user=$SUDO_USER
else
	real_user=$(whoami)
fi

# Initial Setup
# pacman -Syu -noconfirm

# Install themes, icons, cursors, and fonts
pacman -S gtk-engine-murrine sassc --noconfirm
git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git
(cd WhiteSur-gtk-theme && ./install.sh -c Dark -c Light)
git clone https://github.com/vinceliuice/WhiteSur-icon-theme.git
(cd WhiteSur-icon-theme && ./install.sh)
git clone https://github.com/vinceliuice/WhiteSur-cursors.git
(cd WhiteSur-cursors && ./install.sh)
sudo -u $real_user mkdir /home/$real_user/.fonts
sudo -u $real_user cp -r fonts/* /home/$real_user/.fonts

#^^^^^ REGARDING SECTION ABOVE ^^^^^#
###### NEED TO MAKE ADJUSTMENT TO XFCE-DESKTOP.XML, XFCEWM4.XML, AND PROBABLY OTHERS #####

# Installing Global Menu
pamac build vala-panel-appmenu-common-git vala-panel-appmenu-registrar-git --no-confirm
pamac build vala-panel-appmenu-xfce-git --no-confirm
pamac build appmenu-gtk-module-git --no-confirm
xfconf-query -c xsettings -p /Gtk/ShellShowsMenubar -n -t bool -s true
xfconf-query -c xsettings -p /Gtk/ShellShowsAppmenu -n -t bool -s true

# Configuring xfce panel
sudo -u $real_user cp -r applications /home/$real_user/.local/share/
sudo -u $real_user mkdir /home/$real_user/.local/share/menu
sudo -u $real_user cp xpple.menu /home/$real_user/.local/share/menu/

# Installing and Configuring Plank Dock
# --> NEED TO MOVE 'APPLICATIONS' TO OPT <--- #
pacman -S plank --noconfirm
sudo -u $real_user cp applications/Launchpad.desktop /home/$real_user/.local/share/applications
sudo -u $real_user mkdir -p /home/$real_user/.local/share/plank/themes/
cp -r WhiteSur-gtk-theme/src/other/plank/* /home/$real_user/.local/share/plank/themes/
cp icons/launchpad.svg /home/$real_user/.local/share/icons/

# Installing and configuring rofi launcher
pacman -S rofi --noconfirm
sudo -u $real_user cp -r rofi /home/$real_user/.config

# Installing and Configuring Ulauncher
git clone https://aur.archlinux.org/ulauncher.git
(cd ulauncher && makepkg -is)
#sudo -u $real_user mkdir -p "/home/$real_user/.config/ulauncher theme/user-themes"
#sudo -u $real_user cp -r 'ulauncher theme/user-themes' "/home/$real_user/.config/ulauncher theme/"

# Installing and configuring LightDM-Webkit2-Greeter
pacman -S lightdm-webkit2-greeter --noconfirm
git clone https://github.com/manilarome/lightdm-webkit2-theme-glorious.git
cp -r lightdm-webkit2-theme-glorious /usr/share/lightdm-webkit/themes/glorious
sed -i 's/greeter-session=lightdm-gtk-greeter/greeter-session=lightdm-webkit2-greeter/g' /etc/lightdm/lightdm.conf

while true; do
	read -p "A reboot is required. Would you like to reboot now? [Y/n] " yn
	case $yn in
 		[Yy]* ) reboot now; exit;;
	  	[Nn]* ) exit;;
		* ) echo "Please answer yes or no.";;
	esac
done






