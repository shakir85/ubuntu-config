## Nvidia doesn't detect second monitor (HDMI usually)
# Note that new laptops with Nvidia drivers will not run external monitors
# on the intergrated graphics driver mode or the hyprid mode. It has to be via nvidia.
# This sucks because it makes the battery drains so fast.
# -----------------------------------------------------------
sudo prime-select nvidia
# removed blacklisting:
sudo rm /etc/modprobe.d/blacklist-nvidia.conf /lib/modprobe.d/blacklist-nvidia.conf
# Update kernel's initd
sudo update-initramfs -u
# Then reboot.
# Source: https://forums.developer.nvidia.com/t/ubuntu-doesnt-detect-my-second-hdmi-display/75076/3
# Are you running Wayland?! Wayland has issues with Nvidia. check your session here:
echo $XDG_SESSION_TYPE

## Deep Sleep & Wake up issues 
# ---------------------------------------------------
## ThinkPad UEFI switch from Windows sleep-shit to Linux deep-sleep system
# Thanks Lenovo, not all vendors do such BIOS update for Linux users
fwupdmgr refresh
fwupdmgr update
# Go to BIOS > Config > Select "Linux" in sleep mode
# source: https://jonfriesen.ca/blog/lenovo-x1-carbon-and-ubuntu-18.04/

# If Ubuntu doesn't wake up after a hibernate/suspend, do this:
# Add this line to /edt/default/grub
GRUB_CMDLINE_LINUX="nouveau.modeset=0"

# If you use gdm3, install gnomoe-screensaver
sudo apt install gnome-screensaver

# If that didn't work, switch to lightdm (although outdated but sometimes it fix the problem)
sudo dpkg-reconfigure gdm3
