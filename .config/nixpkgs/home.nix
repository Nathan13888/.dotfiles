{ config, pkgs, ... }:

#let
#  # Rolling updates, not deterministic.
#  pkgs = import (fetchTarball("channel:nixpkgs-unstable")) {};
#in pkgs.mkShell {
#  buildInputs = [ pkgs.cargo pkgs.rustc ];
#}

let
    _pkgs = import /home/attackercow/.dotfiles/nixpkgs/default.nix {
        config.allowUnfree = true;
        #config.permittedInsecurePackages = [
    };
in
{

  home.username = "attackercow";
  home.homeDirectory = "/home/attackercow";

  # You can update Home Manager without changing this value
  home.stateVersion = "22.05";

  programs.home-manager.enable = true;
  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 34560000;
    maxCacheTtl = 34560000;
    enableSshSupport = true;
  };

  services.gnome-keyring = {
    enable = true;
    components = [ "pkcs11" "secrets" "ssh" ];
  };

  services.mpris-proxy.enable = true;

  services.syncthing = {
    enable = true;
    tray = {
      enable = true;
      package = pkgs.syncthingtray-minimal;
    };
  };

  # Fcitx5
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5 = {
        addons = [
            pkgs.fcitx5-rime
            pkgs.rime-data
            pkgs.librime
            #pkgs.fcitx-engines.cloudpinyin
            #pkgs.fcitx-engines.libpinyin
            #pkgs.fcitx5.chewing
            pkgs.fcitx5-chinese-addons
            pkgs.fcitx5-table-extra
            pkgs.fcitx5-gtk
            pkgs.libsForQt5.fcitx5-qt
            pkgs.fcitx5-configtool
            #_pkgs.libime-jyutping
            #(let
            #    _pkgs = import /home/attackercow/nixpkgs {
            #        config.allowUnfree = true;
            #    };
            #    sogoupinyin = _pkgs.fcitx-engines.sogoupinyin;
            #in sogoupinyin)
        ];
        #enableRimeData = true; # unavailable in home manager
    };
  };

  #nixpkgs.overlays = [
  #  (self: super:
  #  {
  #    goosemod-openasar = self.callPackage ./openasar { };
  #    goosemod-discord = super.discord.overrideAttrs (old: {
  #      postInstall = ''
  #        cp ${self.goosemod-openasar}/app.asar $out/opt/Discord/resources/app.asar
  #      '';
  #    });
  #  })
  #];

  nixpkgs.overlays =
    let
      openasar = self: super: {
        discord = super.discord.override { withOpenASAR = true; };
      };
    in
    [ openasar ];

  # https://github.com/cryinkfly/Autodesk-Fusion-360-for-Linux
  home.packages = with pkgs; [
    ## Applications/Clients
    firejail
    #discord
    #goosemod-discord
    betterdiscordctl betterdiscord-installer discordchatexporter-cli
    slack
    element-desktop nheko
    whatsapp-for-linux
    signal-desktop
    teams zoom-us
    spotify spotify-qt
    spicetify-cli
    vifm w3m xfce.thunar gnome.file-roller # File Explorer
    calibre
    filezilla
    dbeaver
    #thunderbird-bin protonmail-bridge # Email
    openrgb liquidctl openrazer-daemon razergenie
    keepassxc bitwarden-cli
    virt-manager qemu libguestfs
    easyeffects

    ## Utilities
    zinit starship fzf ripgrep # Prompt
    neovim neovide
    vscode-fhs
    onlyoffice-bin
    libreoffice
    texlive.combined.scheme-full
    xournalpp okular
    arduino
    kubectl lens kubie
    insomnia
    mpv audacious deadbeef cozy guvcview kodi
    #archivebox
    syncthing
    obs-studio #obs-studio-plugins.obs-gstreamer
    asciinema
    gimp krita inkscape
    #darktable # TODO
    tenacity #mixxx spek
    libsForQt5.kdenlive libsForQt5.kio-extras
    #handbrake
    #kicad
    #freecad openscad blender
    super-slicer
    android-file-transfer go-mtpfs
    rclone
    yt-dlp transmission-gtk qbittorrent
    ffmpeg
    img2pdf pdftk ocrmypdf poppler
    exiftool mat2
    libheif
    icoutils

    ## Dev Tools
    kitty thefuck
    hub gh git-lfs git-extras # Git
    killall
    wakatime time hyperfine tokei exa # Measurement
    ripgrep jq jo # Text Manipulation
    gnumake ccache gdb valgrind
    patchelf steam-run
    conda
    gcc
    go
    jdk
    lua
    nodejs
    racket
    #python39Full
    (let
    custom-python-packages = python-packages: with python-packages; [
      pip
      setuptools #poetry
      pytest
      wheel
      requests
      pyyaml
      pyserial
      #deemix
    ];
      python3Custom = python3.withPackages custom-python-packages;
    in python3Custom)
    ruby
    rustup
    podman-compose docker-compose
    drone-cli
    heroku netlify-cli
    #plover.dev
    qmk emote
    avrdude #pkgsCross.avr.buildPackages.gcc
    dfu-programmer stlink dfu-util #esphome # TODO
    esptool-ck #openocd

    #wineWowPackages.full
    gnome.zenity
    #arch-install-scripts nixos-install-tools
    #nix-index

    ## Monitoring
    htop iftop btop bottom powertop pciutils usbutils
    #hardinfo
    lm_sensors ipmitool lshw
    pavucontrol
    lsb-release

    ## Networking
    brave firefox-bin ungoogled-chromium # Browsers
    google-chrome chromedriver
    profile-cleaner
    #tor-browser-bundle-bin
    #socat nyx
    cloudflare-warp
    protonvpn-gui protonvpn-cli
    #proxychains stunnel sslh
    dnscrypt-proxy2
    macchanger
    mitmproxy
    wavemon
    iperf3 hping
    nmap dig traceroute ldns # Information
    protonvpn-cli # VPNs

    ### File
    ntfs3g dosfstools exfatprogs xfsprogs btrfs-progs zfs cifs-utils lockfileProgs # File Systems
    sshfs
    nmon sysstat memtest86plus iotop ioping
    fio kdiskmark phoronix-test-suite sysbench # Benchmark
    unar p7zip zip unzip #rar unrar
    gnutar pigz lz4 zstd xz lzip gzip
    smartmontools
    hdparm sdparm nvme-cli sedutil
    idle3tools
    gocryptfs
    snapper-gui

    pv ncdu baobab # Analysis

    ### Servers
    apacheHttpd

    ## System/WM Utilities
    gnupg pinentry-gnome gnome.gnome-keyring gnome.seahorse
    networkmanager
    bluez bluez-tools blueman
    flameshot
    bitwarden bitwarden-cli
    screenkey
    arandr
    #pamixer helvum
    notify-desktop
    xclip
    lxqt.lxqt-policykit
    nvtop
  ];
}
