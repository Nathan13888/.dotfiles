{ config, pkgs, ... }:

#let
#  # Rolling updates, not deterministic.
#  pkgs = import (fetchTarball("channel:nixpkgs-unstable")) {};
#in pkgs.mkShell {
#  buildInputs = [ pkgs.cargo pkgs.rustc ];
#}

{
  home.username = "attackercow";
  home.homeDirectory = "/home/attackercow";

  # You can update Home Manager without changing this value
  home.stateVersion = "21.05";
  #home.stateVersion = "22.05";

  programs.home-manager.enable = true;
  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 34560000;
    maxCacheTtl = 34560000;
    enableSshSupport = true;
  };

  services.syncthing = {
    enable = true;
    tray = true;
    #tray = {
    #  enable = true;
    #  package = pkgs.syncthingtray-minimal;
    #};
  };

  # https://github.com/cryinkfly/Autodesk-Fusion-360-for-Linux
  home.packages = with pkgs; [
    ## Applications/Clients
    firejail
    discord
    spotify spicetify-cli
    betterdiscordctl betterdiscord-installer discordchatexporter-cli
    element-desktop nheko
    teams
    vifm w3m xfce.thunar gnome.file-roller # File Explorer
    calibre
    filezilla
    dbeaver
    #thunderbird-bin protonmail-bridge # Email
    openrgb liquidctl
    keepassxc bitwarden-cli
    virt-manager qemu libguestfs
    easyeffects

    ## Utilities
    zinit starship fzf ripgrep # Prompt
    neovim neovide
    vscode-fhs
    onlyoffice-bin
    libreoffice
    arduino
    mpv audacious deadbeef cozy guvcview kodi
    okular
    archivebox
    syncthing
    obs-studio obs-studio-plugins.obs-gstreamer
    asciinema
    gimp krita inkscape
    darktable
    tenacity mixxx spek
    libsForQt5.kdenlive libsForQt5.kio-extras
    handbrake
    kicad freecad openscad blender super-slicer
    android-file-transfer go-mtpfs
    rclone
    yt-dlp transmission-gtk qbittorrent
    ffmpeg
    img2pdf pdftk ocrmypdf poppler
    exiftool
    icoutils

    ## Dev Tools
    kitty thefuck
    hub gh git-lfs git-extras # Git
    killall
    wakatime time hyperfine tokei exa # Measurement
    ripgrep jq jo # Text Manipulation
    gnumake ccache gdb
    patchelf steam-run
    conda
    gcc
    go
    jdk
    lua
    musl
    nodejs-16_x#nodejs
    (let
    custom-python-packages = python-packages: with python-packages; [
      pip
      setuptools poetry
      wheel
      requests
      pyyaml
      deemix
    ]; 
      python3Custom = python3.withPackages custom-python-packages;
    in python3Custom)
    ruby
    rustup
    heroku netlify-cli
    stlink dfu-util esphome esptool-ck openocd

    wineWowPackages.full
    gnome.zenity
    arch-install-scripts nixos-install-tools

    ## Monitoring
    htop iftop btop bottom powertop pciutils usbutils
    hardinfo
    lm_sensors ipmitool
    pavucontrol

    ## Networking
    brave ungoogled-chromium firefox-bin # Browsers
    #tor-browser-bundle-bin
    socat nyx
    profile-cleaner
    zerotierone
    proxychains stunnel sslh
    dnscrypt-proxy2
    macchanger
    mitmproxy
    wavemon
    iperf3 hping
    nmap dig traceroute ldns # Information
    protonvpn-cli # VPNs

    ### File
    ntfs3g dosfstools exfatprogs xfsprogs btrfs-progs zfs cifs-utils lockfileProgs # File Systems
    nmon sysstat memtest86plus iotop ioping
    fio phoronix-test-suite sysbench # Benchmark
    unar p7zip zip unzip #rar unrar
    gnutar pigz lz4 zstd xz lzip gzip
    smartmontools
    hdparm sdparm nvme-cli sedutil
    idle3tools
    gocryptfs

    pv ncdu baobab # Analysis

    ### Servers
    apacheHttpd

    ## System/WM Utilities
    gnupg pinentry-gnome gnome.gnome-keyring gnome.seahorse
    networkmanager
    flameshot
    screenkey
    arandr
    pamixer helvum
    notify-desktop
    xclip
    lxqt.lxqt-policykit
    nvtop
  ];
}
