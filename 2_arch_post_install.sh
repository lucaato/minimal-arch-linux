#!/bin/bash

echo "Setting netctl profile"
sudo netctl enable wireless

echo "Installing common packages"
yes | sudo pacman -S linux-headers dkms xdg-user-dirs xorg-server-xwayland

echo "Installing and configuring UFW"
yes | sudo pacman -S ufw
sudo systemctl enable ufw
sudo systemctl start ufw
sudo ufw enable
sudo ufw default deny incoming
sudo ufw default allow outgoing

echo "Installing and enabling TLP"
yes | sudo pacman -S tlp
sudo systemctl enable tlp.service
sudo systemctl enable tlp-sleep.service
sudo systemctl start tlp.service
sudo systemctl start tlp-sleep.service

echo "Installing common applications"
echo -en "1\nyes" | sudo pacman -S chromium git openssh links alacritty upower htop powertop

echo "Enabling powertop auto-tune at startup"
touch /etc/systemd/system/powertop.service
tee -a /etc/systemd/system/powertop.service << END
[Unit]
Description=Powertop tunings

[Service]
Type=oneshot
ExecStart=/usr/bin/powertop --auto-tune
RemainAfterExit=true

[Install]
WantedBy=multi-user.target
END

sudo systemctl daemon-reload
sudo systemctl enable powertop.service

echo "Installing fonts"
yes | sudo pacman -S ttf-droid ttf-opensans ttf-dejavu ttf-liberation ttf-hack ttf-fira-code noto-fonts gsfonts powerline-fonts

echo "Installing and setting zsh"
yes | sudo pacman -S zsh zsh-theme-powerlevel9k
chsh -s /bin/zsh
wget -P ~/ https://raw.githubusercontent.com/luca-a/minimal-arch-linux/master/configs/zsh/.zshrc
wget -P ~/ https://raw.githubusercontent.com/luca-a/minimal-arch-linux/master/configs/zsh/.zprofile
mkdir -p ~/.zshrc.d
wget -P ~/.zshrc.d https://raw.githubusercontent.com/luca-a/minimal-arch-linux/master/configs/zsh/.zshrc.d/environ.zsh
wget -P ~/.zshrc.d https://raw.githubusercontent.com/luca-a/minimal-arch-linux/master/configs/zsh/.zshrc.d/wayland.zsh

echo "Setting up GTK theme and installing dependencies"
yes | sudo pacman -S gtk-engine-murrine gtk-engines
git clone https://github.com/vinceliuice/Qogir-theme.git
cd Qogir-themep
sudo mkdir -p /usr/share/themes
sudo ./install.sh -d /usr/share/themes
cd ..
rm -rf Qogir-theme

echo "Setting up icon theme"
git clone https://github.com/vinceliuice/Qogir-icon-theme.git
cd Qogir-icon-theme
sudo mkdir -p /usr/share/icons
sudo ./install.sh -d /usr/share/icons
cd ..
rm -rf Qogir-icon-theme

echo "Installing cursor theme"
yes | sudo pacman -S capitaine-cursors

echo "Installing Material Design icons"
sudo mkdir -p /usr/share/fonts/TTF/
sudo wget -P /usr/share/fonts/TTF/ https://raw.githubusercontent.com/Templarian/MaterialDesign-Webfont/master/fonts/materialdesignicons-webfont.ttf

echo "Installing sway and additional packages"
yes | sudo pacman -S sway swaylock swayidle waybar wl-clipboard pulseaudio pavucontrol rofi slurp grim thunar mousepad nnn light feh qalculate-gtk
mkdir -p ~/.config/sway
wget -P ~/.config/sway/ https://raw.githubusercontent.com/luca-a/minimal-arch-linux/master/configs/sway/config
mkdir -p ~/Pictures/screenshots

echo "Setting wallpaper"
wget -P ~/Pictures/ https://raw.githubusercontent.com/luca-a/minimal-arch-linux/master/wallpaper/6303-mauritania.jpg

echo "Ricing waybar"
mkdir -p ~/.config/waybar
wget -P ~/.config/waybar https://raw.githubusercontent.com/luca-a/minimal-arch-linux/master/configs/waybar/config
wget -P ~/.config/waybar https://raw.githubusercontent.com/luca-a/minimal-arch-linux/master/configs/waybar/style.css

echo "Ricing Alacritty"
mkdir -p ~/.config/alacritty
wget -P ~/.config/alacritty https://raw.githubusercontent.com/luca-a/minimal-arch-linux/master/configs/alacritty/alacritty.yml

echo "Ricing rofi"
mkdir -p ~/.config/rofi
wget -P ~/.config/rofi https://raw.githubusercontent.com/luca-a/minimal-arch-linux/master/configs/rofi/base16-material-darker.rasi
wget -P ~/.config/rofi https://raw.githubusercontent.com/luca-a/minimal-arch-linux/master/configs/rofi/config

echo "Increasing the amount of inotify watchers"
echo fs.inotify.max_user_watches=524288 | sudo tee /etc/sysctl.d/40-max-user-watches.conf && sudo sysctl --system

echo "Your setup is ready. You can reboot now!"
