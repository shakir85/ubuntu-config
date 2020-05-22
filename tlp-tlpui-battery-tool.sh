# TLP tool help manage battery drainage in Ubuntu-Like distros
# TLP should be ready in apt without adding this repo, but just in case...
sudo add-apt-repository ppa:linrunner/tlp
sudo apt-get update
sudo apt-get install tlp tlp-rdw

# Add this too for ThinkPad
# To enable/manage ThinkPad charge thresholds faeture
sudo apt-get install tp-smapi-dkms acpi-call-dkms

# TLPUI a GUI TLP
sudo add-apt-repository ppa:linuxuprising/apps
sudo apt-get update    
sudo apt-get install tlpui
