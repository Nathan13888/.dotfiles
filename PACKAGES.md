# **Packages** #
################
################

## Terminal
- ripgrep
- zsh bash
- hyperfine time
- git hub git-lfs git-extras github-cli
- thefuck (or with PIP)
- neofetch pfetch
- screen tmux sudo

## Editors
- vim neovim
- emacs (doom emacs)
  - git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d ~/.emacs.d/bin/doom install alacritty
- visual-studio-code[-insiders]-bin

## Development
- apache
- tokei exa
- python python-pip anaconda
- go
- rustup
- nodejs npm nvm
- gcc gdb
- openjdk
- jq jo

## Browser
- firefox-nightly firefox-developer-edition
- torbrowser-launcher nyx tor tor-openrc
- ungoogled-chromium brave-bin
- lynx
- proxychains
- profile-cleaner (cleans sqlite databases)

## Clients
- keybase
### Communication
- discord-ptb betterdiscord-installer discord-chat-exporter-cli
- thunderbird protonmail-desktop protonmail-bridge
- signal-desktop
- element-desktop-nightly-bin
- teams

## WM
- X11 stuff --> xorg xorg-server
- xorg-xinit
- xdg-utils
- display manager
- lxappearance dconf-editor
- juno-theme-git (artix-dark theme)
- picom-ibhagwan-git
- polybar dunst rofi
- bluez bluez-utils bluez-openrc
- network-manager-applet cbatticon
- network-manager openresolv
- dnsmasq dnsmasq-openrc dnscrypt-proxy dnscrypt-proxy-openrc dnsutils ldns

## Services
- numlockx xbanish xbindkeys xbacklight
- openntpd openntpd-openrc
- fcitx5

## Utilities
- gnupg gnome-keyring keepassxc bitwarden bitwarden-cli
- libsecret seahorse pinentry
- feh
- flameshot gromit-mpx

### i3
- i3-gaps
- i3lock-color
- xss-lock

### Xmonad
- xmonad xmonad-contrib

## Utilities
- fprintd libfprint (or from git `fprintd-libfprint2` `libprint-git`) fingerprint-gui
- nerd-fonts-complete ttf-ms-fonts noto-fonts-cjk ttf-google-fonts-git
- file-roller
- vifm nnn pcmanfm
- calcurse
- btop bottom-bin iotop powertop htop iftop lm-sensors ipmitool dimidecode?
- fetchcord-git (or from pip)
- speedtest-cli

## Virtualization / Containers
- virt-manager qemu qemu-arch-extra libvirt-openrc edk2-ovmf ovmf-git bridge-utils
- virtualbox-bin virtualbox-host-modules-arch
  - https://www.virtualbox.org/wiki/Linux_Downloads 
  - `modprobe vboxdrv vboxnetfit vboxnetadp vboxpci`
  - https://www.oracle.com/virtualization/technologies/vm/downloads/virtualbox-downloads.html#extpack (or just download from AUR: virtualbox-ext-oracle)
- KVM (https://wiki.archlinux.org/index.php/KVM)
- QEMU (https://wiki.archlinux.org/index.php/QEMU)
- [Docker](https://wiki.archlinux.org/index.php/Docker#Installation)
- podman
- kubernetes
- kubectl lens-bin
- k3s-bin or k3s-git
- helm
- cloudfoundry-cli
- wine

## INFOSEC
- privoxy: https://wiki.archlinux.org/index.php/Privoxy
- stubby: https://wiki.archlinux.org/index.php/Stubby
- nordvpn: https://wiki.archlinux.org/index.php/NordVPN
- nmap zenmap
- wireshark
- macchanger
- clamav
- wireguard
- hashcat
- certbot
- cuda and cudnn
- libinput-gestures https://github.com/bulletmark/libinput-gestures
- aircrack-ng and airegeddon
- hydra
- mitmproxy

## Media
- spotify spotify-adblock(-git) spicetify spicetify-themes-git
- mpv vlc
- kodi-x11
- davinci-resolve
- kdenlive kio-extras opentimelineio
%- krita
%- gimp
- icoutils
%- inkscape
%- DarkTable
%- Kicad
%- freecad
%- Blender
%- Cura
%- super slicer
- rpi-imager
- etcher

## Recording, Video, Audio
- pipewire pipewire-alsa pipewire-pulse pipewire-jack
- wireplumber
- helvum
- pulseaudio pulseaudio-jack
- realtime-privileges (add user to @realtime group after)
- alsa
- patchage
- obs-studio guvcview
- v4l2loopback-dkms
- audacity tenacity-git spek
- ardour
- mixxx
- clementine audacious-gtk3 (audacious-plugins-gtk3) deadbeef cozy-audiobooks
- pavucontrol (gtk gui)
- alsa-utils
- pulseaudio-ctl (shell-based)
- pamixer
- playerctl
- pulseeffects
- jack jack2-dbus
- carla
- cadence
- qjackctl
- cava
- screenkey
- handbrake
- asciinema
- gstreamer

## Clients

- yt-dlp
- rclone
- transmission-gtk (or -qt)
- filezilla
- tigervnc xrdp xorg xrdp-glamor (intel/amd) xordxrdp-nvidia (nvidia)
- KRDC
- cuda and cudnn
- heroku-cli netlify
- cht.sh (cheat.sh)
- megasync
- calibre
- libreoffice-fresh onlyoffice drawio-desktop-bin
- joplin

## Data tools
- tar
- rar
- libzip
- pg...

## Tools and Utilities
- linux-tkg ccache schedtool
- apparmor audit audit-openrc firejail
- hardinfo

### Graphics
- nvidia-dkms
- nvidia-settings
- intel-media-driver libva-utils vdpauinfo libva-vdpau-driver-chromium libva-vdpau-driver-vp9-git
- vulkan-tools
- gwe ("green with envy")

### File Systems and Storage
- ntfs-3g dosfstools exfat-utils (exfatprogs) xfsprogs btrfs-progs zfs-dkms (zfs-linux...)
- ipfs-desktop
- hdparm sdparm nvme-cli intel-mas-cli-tool ncdu
- perl-image-exiftool ffmpeg
- img2pdf pdftk ocrmypdf
- rsync tar gzip pigz lz4 lzma pv
- clonezilla
- zrepl sanoid
- fio iozone ioping nmon sysstat
- smartmontools idle3-tools
- iperf3
- memtest86+
- lockfile-progs
- artools iso-profiles arch-install-scripts
- curl, wget, rpm
- furiusisomount
- jdownloader2
- syncthing syncthing-openrc
- openrgb liquidctl
- poppler
- ufw qemu-guest-agent wol (wake on lan)
- QMK stlink dfu-utils openocd telenet
- arm-none-eabi-newlib arm-none-eabi-binutils
- android-udev android-file-transfer go-mtpfs-git mtpfs
- android-tools
- xcolor
- ddgr
- traceroute
- East Asian Fonts: `https://wiki.archlinux.org/index.php/Fonts#Chinese,_Japanese,_Korean,_Vietnamese`
- trash-cli
- cups: https://wiki.archlinux.org/index.php/CUPS#Installation
  - https://wiki.archlinux.org/index.php/CUPS/Printer-specific_problems#UFRII
- pciutils usbutils
- nut (ups)
- cifs-utils (for Samba)
- wakatime
- zram-config --> setup https://github.com/StuartIanNaylor/zram-config
- lyrebird

## DBs
- mysql
- mongodb
- mongo-compass
- cockroach
- postgres
- dbeaver

## Games
- Steam

## Benchmark
- Phoronix Test Suite
- geekbench
- unigine-superposition unigine-valley unigine-heaven
- traceroute
- hashcat -B
- cinfo
- dmidecode

## Chess
- chess engines --> allie lc0 kommodo stockfish
- syzygy tables

## Fun
- figlet
- fortune
- cmatrix
- cowsay
- lolcat
- dofe
- toilet bullshit
- asciiquarium
- aafire
- tty-clock visudo (default instults)

## KDE
(https://wiki.archlinux.org/index.php/KDE)
- kde-applications-meta
- kwallet
- kwallet-manager
- kwalletcli
- kwallet-pam
- ksshaskpass

