#!/bin/bash

# Check .deb packages as some don't pull latest version

# Use this to show current apt installs:
# sudo apt-mark showmanual

#-------------------------
# Variables
#-------------------------

COLOR_RED=$(tput setaf 1)
COLOR_GREEN=$(tput setaf 2)
COLOR_BLUE=$(tput setaf 4)
COLOR_RESET=$(tput sgr0)

# Short circuit if not sudo
if [ "$(id -u)" != "0" ]; then
    echo "${COLOR_RED}"
    echo "This script must be run as root!" 2>&1
    echo "${COLOR_RESET}"
    exit 1
fi

# Flow control function
function FLOW_CONTROL {
    echo "Do you want to continue? [y/n]"
    read -r input
    if [ "$input" == "y" ]; then
        echo "Continue..."
    else echo "Terminated" && exit
    fi
}

function LOGO {
    echo "${COLOR_BLUE}"
    echo "  ________________________________________-.-________-___-___________________ "
    echo " (_  |_| /_\ |_/ | |_)   / \ |_) |_) (_    | |\ | (_   |  /_\ |   |   |_  |_) "
    echo " ,_) | | | | | \ | | \   |~| |   |   ,_)   | | \| ,_)  |  | | |_, |_, |_, | \ "
    echo " ____________________________________________________________________________ "
    echo "                                                                              "
    echo "${COLOR_GREEN}"
    echo "Ubuntu Apps Installer - Version 1.1 - Oct 22 2020"
    echo "${COLOR_RESET}"
}

LOGO

FLOW_CONTROL

# read -n 1 -r -s -p $'\nPress enter to start...\n'

# Default APT installs
# ##########################################################################################################################
# Flatpack Note: the Software app (in Ubuntu) is distributed as a Snap since Ubuntu 20.04 and does not support graphical
# installation of Flatpak apps. Installing the Flatpak plugin will also install a deb version of Software and result in two 
# Software apps being installed at the same time.
############################################################################################################################

echo -e "\n** UPDATE & INSTALL APT PACKAGES **"
sleep 3
apt update && apt upgrade -y
apt install -y konsole python3-pip python3-venv gnome-sushi \
wget synaptic git flameshot bleachbit gparted copyq \
okular vim htop curl software-properties-common \
apt-transport-https ca-certificates \
virtualbox virtualbox—ext–pack \
flatpak gnome-software-plugin-flatpak neofetch shellcheck

# Pip installs
pip3 install ipython
pip3 install virtualenv

echo -e "\n** ADD REQUIRED REPOSITORIES **"
sleep 3

# Apts that require adding PPAs
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
curl -sS https://download.spotify.com/debian/pubkey.gpg | apt-key add - 
curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | apt-key add - 
echo "deb http://repository.spotify.com stable non-free" |  tee /etc/apt/sources.list.d/spotify.list


wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | apt-key add -
add-apt-repository -y "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" >/dev/null 2>&1 &
PID=$!
echo "ADD 'VS-Code' PPA..."
printf "["
while kill -0 $PID 2> /dev/null; do
    printf  "▓"
    sleep 1
done
printf "] Done!"

curl -fsSL https://download.sublimetext.com/sublimehq-pub.gpg | apt-key add -
add-apt-repository -y "deb https://download.sublimetext.com/ apt/stable/" >/dev/null 2>&1 &
PID=$!
echo -e "\nADD 'Sublime-Text' PPA..."
printf "["
while kill -0 $PID 2> /dev/null; do
    printf  "▓"
    sleep 1
done
printf "] Done!"

apt-add-repository -y ppa:teejee2008/ppa >/dev/null 2>&1 &
PID=$!
echo -e "\nADD 'Timeshift' PPA..."
printf "["
while kill -0 $PID 2> /dev/null; do
    printf  "▓"
    sleep 1
done
printf "] Done!"

add-apt-repository ppa:me-davidsansome/clementine -y >/dev/null 2>&1 &
PID=$!
echo -e "\nADD 'Clementine' PPA..."
printf "["
while kill -0 $PID 2> /dev/null; do
    printf  "▓"
    sleep 1
done
printf "] Done!
add-apt-repository ppa:otto-kesselgulasch/gimp -y >/dev/null 2>&1 &
PID=$!
echo -e "\nADD 'Gimp' PPA..."
printf "["
while kill -0 $PID 2> /dev/null; do
    printf  "▓"
    sleep 1
done
printf "] Done!

echo -e "\nPPAs added successfully, now installing packages..." && sleep 3

apt update
timeshift flatpak gnome-software-plugin-flatpak gimp \
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "Done!"

# DEB Packages installs
echo -e "\n ** DOWNLOAD & INSTALL '.deb' PACKAGES **"
FLOW_CONTROL

temp="/home/${USER}/temp"

if [ ! -d "$temp" ] ; then
    mkdir "$temp" && cd "$temp" || return
else
    echo "Directory $temp exists..." && cd "$temp"
fi

echo "Moved to $PDW"
echo -e "\nDownloading Debian packages...\n" && sleep 3

wget -O mailspring.deb https://updates.getmailspring.com/download?platform=linuxDeb
apt install -y ./mailspring.deb

wget -O chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt install -y ./chrome.deb
              
wget -O  simplenote.deb https://github.com/Automattic/simplenote-electron/releases/download/v1.21.1/Simplenote-linux-1.21.1-amd64.deb
apt install -y ./simplenote.deb

wget -O dropbox.deb https://www.dropbox.com/download?dl=packages/ubuntu/dropbox_2020.03.04_amd64.deb
apt install -y ./dropbox.deb

wget -O ulancher.deb https://github.com/Ulauncher/Ulauncher/releases/download/5.8.0/ulauncher_5.8.0_all.deb
apt install -y ./ulancher.deb

echo -e "\n** INSTALLING SNAPS **" && sleep 3

# Snap Installs
snap install bitwarden
snap install authy --beta

# Cleanup & reboot
rm -rf ./*

echo -e "\n** CLEAN UP APT **"
apt autoclean -y
apt autoremove -y

# Joplin require non-sudo user
sudo -u shakir bash <<EOF
    wget -O - https://raw.githubusercontent.com/laurent22/joplin/master/Joplin_install_and_update.sh | bash
EOF

echo "${COLOR_GREEN}"
echo -e "\n*******************************************"
echo "**************** FINISHED! ****************"
echo -e "\n*******************************************"
echo "${COLOR_RESET}"
count=8
while [ $count -ne 0 ] ; do
        echo -ne "Rebooting in $count seconds - Press Ctrl+C to cancel"\\r
        sleep 1
        ((count=count-1))
done

reboot
