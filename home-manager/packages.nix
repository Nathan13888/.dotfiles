{ config, pkgs, lib, ... }:

{
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
    #firejail
    discord-ptb
    #goosemod-discord betterdiscordctl betterdiscord-installer 
    discordchatexporter-cli
    slack
    element-desktop nheko
    whatsapp-for-linux
    signal-desktop
    teams zoom-us
    spotify #spotify-qt
    spicetify-cli
    vifm w3m xfce.thunar gnome.file-roller # File Explorer
    calibre
    filezilla
    dbeaver
    #thunderbird-bin protonmail-bridge # Email
    openrgb liquidctl razergenie #openrazer-daemon 
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
    nixpkgs-fmt
    openssl
    conda
    gcc valgrind
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
    proxmark3-rrg
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
    brave firefox-wayland ungoogled-chromium # Browsers
    wireguard-tools # TODO FIXX
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
    sshfs f3
    usbimager
    gparted
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
    waybar eww-wayland swww socat
    bemenu hyprpaper dunst
    wlr-randr
    grim slurp wayshot
    feh
    xss-lock
    mpd mpc-cli
    lxappearance
    networkmanagerapplet cbatticon
    gnome.dconf-editor
    fwupd

    gnupg pinentry-gnome gnome.gnome-keyring gnome.seahorse libsecret
    networkmanager
    bluez bluez-tools blueman
    flameshot
    bitwarden bitwarden-cli
    screenkey
    arandr
    #pamixer helvum
    notify-desktop
    wl-clipboard xclip
    lxqt.lxqt-policykit
    nvtop


    gnome.gnome-tweaks
    gnomeExtensions.appindicator
    gnomeExtensions.pop-shell
    gnomeExtensions.user-themes
    gnomeExtensions.tray-icons-reloaded
    gnomeExtensions.vitals
    gnomeExtensions.dash-to-panel
    gnomeExtensions.sound-output-device-chooser
    gnomeExtensions.space-bar
  ];

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs; [ obs-studio-plugins.wlrobs ];
  };

  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "discord-ptb"
    "slack"
    "teams"
    "zoom"
    "spotify"
    "code" "vscode"
    "google-chrome"
    "cloudflare-warp"
    "cudatoolkit"
    "steam-run" "steam-original"
  ];

}
