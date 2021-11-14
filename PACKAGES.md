################
# **Packages** #
################

## Dev
- zsh bash
- hyperfine
- git hub
- vim neovim
- emacs (ripgrep doom emacs)
- doom emacs
  - git clone --depth 1 https://github.com/hlissner/doom-emacs ~/.emacs.d ~/.emacs.d/bin/doom install alacritty
- firefox-nightly firefox-developer-edition ungoogled-chromium brave-bin
- keepassxc
- thunderbird protonmail-desktop protonmail-bridge
- keybase
- neofetch pfetch
- thefuck (or with PIP)
- screen tmux sudo
- visual-studio-code[-insiders]-bin
- cuda and cudnn
- time
- python python-pip anaconda
- go rustup
- nodejs npm nvm
- gcc gdb
- openjdk
- tokei
- exa

## Communication
- discord-ptb betterdiscord-installer
- signal-desktop
- element-desktop-nightly-bin
- teams

# xmonad
- xmonad xmonad-contrib

# i3
- i3-gaps
- i3lock-color
- xss-lock
- *(xorg)*
- X11 stuff --> xorg xorg-server
- xorg-xinit
- xdg-utils
- display manager
<!--- lsdesktopf
- lxappearance
- dconf-editor-->
- *(input)*
- numlockx
- xbanish
- *(services)*
- fcitx5
- picom-ibhagwan-git
- polybar
- rofi
- network-manager-applet
- bluez bluez-utils bluez-openrc
- openntpd openntpd-openrc
- fprintd libfprint (or from git `fprintd-libfprint2` `libprint-git`)
- fingerprint-gui
- xbindkeys
- xbacklight
- dunst
- feh
- flameshot
- nerd-fonts-complete ttf-ms-fonts noto-fonts-cjk ttf-google-fonts-git
#- font-config
- *(secrets)*
- gnome-keyring
- libsecret
- seahorse
- pinentry
- gnupg
- *(misc)*
- pcmanfm
- file-roller
- vifm nnn
- calcurse
- lynx
- bottom-bin iotop powertop htop iftop lm-sensors ipmitool dimidecode?
- fetchcord-git (or from pip)
- speedtest-cli
- *(battery)*
- cbatticon

## Virtualization / Containers
- virt-manager
- virtualbox-bin virtualbox-host-modules-arch
  - https://www.virtualbox.org/wiki/Linux_Downloads 
  - `modprobe vboxdrv vboxnetfit vboxnetadp vboxpci`
  - https://www.oracle.com/virtualization/technologies/vm/downloads/virtualbox-downloads.html#extpack (or just download from AUR: virtualbox-ext-oracle)
- KVM (https://wiki.archlinux.org/index.php/KVM)
- QEMU (https://wiki.archlinux.org/index.php/QEMU)
- [Docker](https://wiki.archlinux.org/index.php/Docker#Installation)
- podman
- kubernetes
- kubectl
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
- torbrowser-launcher nyx tor tor-openrc
- proxychains

- yt-dlp
- rclone
- transmission-gtk (or -qt)
- filezilla
- tigervnc
- xrdp xorg xrdp-glamor (intel/amd) xordxrdp-nvidia (nvidia)
- KRDC
- heroku-cli
- netlify
- cht.sh (cheat.sh)
- calibre

- lastpass
- megasync
- libreoffice-fresh
- joplin
- Spectacle (KDE for screenshots)
- yakuake or guake (if gnome)

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
- gwe ("green with envy")

### File Systems and Storage
- ntfs-3g dosfstools exfat-utils (exfatprogs) xfsprogs btrfs-progs zfs-dkms (zfs-linux...)
- ipfs-desktop
- hdparm nvme-cli intel-mas-cli-tool
- perl-image-exiftool ffmpeg
- rsync tar gzip pigz lz4 lzma pv
- clonezilla
- zrepl sanoid
- fio iozone ioping nmon
- smartmontools idle3-tools
- iperf3
- memtest86+
- lockfile-progs
- artools iso-profiles arch-install-scripts
- curl, wget, rpm
- furiusisomount
- jdownloader2
- syncthing syncthing-openrc
- openrgb
- poppler
- ufw qemu-guest-agent wol (wake on lan)
- QMK
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

