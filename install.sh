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
# pacman -Syu -y

# Install themes, icons, cursors, and fonts
pacman -S gtk-engine-murrine sassc -y
git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git
(cd WhiteSur-gtk-theme && ./install.sh -c Dark -c Light)
git clone https://github.com/vinceliuice/WhiteSur-icon-theme.git
(cd WhiteSur-icon-theme && ./install.sh)
git clone https://github.com/vinceliuice/WhiteSur-cursors.git
(cd WhiteSur-cursors && ./install.sh)
sudo -u $real_user mkdir /home/$real_user/.fonts
cp -r fonts/* /home/$real_user/.fonts

#^^^^^ REGARDING SECTION ABOVE ^^^^^#
###### NEED TO MAKE ADJUSTMENT TO XFCE-DESKTOP.XML, XFCEWM4.XML, AND PROBABLY OTHERS #####

# Installing Global Menu
pamac build vala-panel-appmenu-common-git vala-panel-appmenu-registrar-git --no-confirm
pamac build vala-panel-appmenu-xfce-git --no-confirm
pamac build appmenu-gtk-module-git --no-confirm
xfconf-query -c xsettings -p /Gtk/ShellShowsMenubar -n -t bool -s true
xfconf-query -c xsettings -p /Gtk/ShellShowsAppmenu -n -t bool -s true

# Configuring xfce panel
cp -r applications /home/$real_user/.local/share/
sudo -u $real_user mkdir /home/$real_user/.local/share/menu
cp xpple.menu /home/$real_user/.local/share/menu/

# Installing and Configuring Plank Dock
# --> NEED TO MOVE 'APPLICATIONS' TO OPT <--- #
pacman -S plank -y
cp applications/Launchpad.desktop /home/$real_user/.local/share/applications
sudo -u $real_user mkdir -p /home/$real_user/.local/share/plank/themes/
cp -r WhiteSur-gtk-theme/src/other/plank/* /home/$real_user/.local/share/plank/themes/
cp icons/launchpad.svg /home/$real_user/.local/share/icons/

while true; do
	read -p "A reboot is required. Would you like to reboot now? [Y/n] " yn
	case $yn in
 		[Yy]* ) reboot now; exit;;
	  	[Nn]* ) exit;;
		* ) echo "Please answer yes or no.";;
	esac
done






