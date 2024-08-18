{ config, pkgs, lib, ... }:

#let unstable = pkgs.nixos-unstable; in
{
  home.file."jdks/openjdk8".source = pkgs.adoptopenjdk-openj9-bin-8;
  home.file."jdks/openjdk11".source = pkgs.adoptopenjdk-openj9-bin-11;
  home.file."jdks/openjdk17".source = pkgs.jetbrains.jdk;
  home.file."jdks/graal21".source = pkgs.graalvm-ce;
  home.file."jdks/scala".source = pkgs.scala;


  nixpkgs.overlays =
    let
      openasar = self: super: {
        discord = super.discord.override { withOpenASAR = true; };
      };
    in
    [ openasar ];

  home.packages = with pkgs; [
    ## Applications/Clients
    vesktop
    #discord-ptb betterdiscordctl
    discordchatexporter-cli
    element-desktop
    thunderbird
    #whatsapp-for-linux
    #signal-desktop
    #slack
    #teams #zoom-us
    spotify
    spicetify-cli
    vifm ranger w3m xfce.thunar file-roller # File Explorer
    calibre
    filezilla
    dbeaver-bin
    #thunderbird-bin protonmail-bridge # Email
    #openrgb liquidctl razergenie #openrazer-daemon 
    keepassxc bitwarden-cli
    virt-manager qemu libguestfs
    easyeffects

    ## Utilities
    zinit starship fzf ripgrep # Prompt
    zoxide # `cd` alternative
    neovim #neovide
    vscode zed-editor

    tree-sitter
    #rust-analyzer

    #tree-sitter-grammars.tree-sitter-c
    #tree-sitter-grammars.tree-sitter-cpp
    #tree-sitter-grammars.tree-sitter-go
    #tree-sitter-grammars.tree-sitter-gomod
    #tree-sitter-grammars.tree-sitter-python
    #tree-sitter-grammars.tree-sitter-rst
    #tree-sitter-grammars.tree-sitter-rust
    #tree-sitter-grammars.tree-sitter-zig

    #tree-sitter-grammars.tree-sitter-tsx
    #tree-sitter-grammars.tree-sitter-html
    #tree-sitter-grammars.tree-sitter-css
    #tree-sitter-grammars.tree-sitter-typescript
    #tree-sitter-grammars.tree-sitter-javascript

    #tree-sitter-grammars.tree-sitter-bash
    #tree-sitter-grammars.tree-sitter-make
    #tree-sitter-grammars.tree-sitter-cmake
    #tree-sitter-grammars.tree-sitter-dockerfile
    #tree-sitter-grammars.tree-sitter-comment

    #tree-sitter-grammars.tree-sitter-latex
    #tree-sitter-grammars.tree-sitter-sql

    #tree-sitter-grammars.tree-sitter-json
    #tree-sitter-grammars.tree-sitter-json5
    #tree-sitter-grammars.tree-sitter-proto
    #tree-sitter-grammars.tree-sitter-markdown
    #tree-sitter-grammars.tree-sitter-nix
    #tree-sitter-grammars.tree-sitter-vim
    #tree-sitter-grammars.tree-sitter-yaml

    jetbrains.idea-community
    onlyoffice-bin
    libreoffice
    texlive.combined.scheme-full
    xournalpp okular
    arduino
    kubectl kubie # lens
    insomnia
    #protege-distribution
    mpv vlc audacious deadbeef guvcview
    #archivebox
    syncthing
    asciinema
    gimp krita inkscape
    darktable
    tenacity #mixxx spek
    libsForQt5.kdenlive libsForQt5.kio-extras
    #handbrake # TODO
    #kicad #TODO
    #freecad openscad qcad
    blender
    orca-slicer
    #super-slicer
    android-file-transfer go-mtpfs
    rclone
    yt-dlp transmission_4-gtk qbittorrent deluge-gtk
    ffmpeg mediainfo
    img2pdf pdftk ocrmypdf poppler
    exiftool mat2
    libheif
    icoutils

    ## Dev Tools
    rio kitty thefuck
    hub lazygit gh git-lfs git-extras # Git
    killall
    wakatime time hyperfine tokei eza # Measurement
    ripgrep jq jo # Text Manipulation
    gnumake gdb valgrind
    patchelf steam-run
    nixpkgs-fmt
    openssl
    conda
    gcc valgrind
    go
    temurin-jre-bin maven #jdk
    lua
    nodejs fnm
    racket
    (let
    custom-python-packages = python-packages: with python-packages; [
      pip
      requests
    ];
      python3Custom = python3.withPackages custom-python-packages;
    in python3Custom)
    conda micromamba
    ruby
    nixd nil
    rustup
    distrobox
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
    zenity
    #arch-install-scripts nixos-install-tools
    #nix-index

    ## Monitoring
    htop iftop btop bottom powertop pciutils usbutils
    #hardinfo
    lm_sensors ipmitool lshw
    pavucontrol pamixer playerctl
    bc
    lsb-release

    ## Networking
    brave firefox-wayland ungoogled-chromium # Browsers
    wireguard-tools # TODO FIXX
    iproute2
    google-chrome chromedriver
    profile-cleaner
    #tor-browser-bundle-bin
    #socat nyx
    #cloudflare-warp
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
    ntfs3g dosfstools exfatprogs xfsprogs btrfs-progs #zfs
    cifs-utils lockfileProgs # File Systems
    sshfs f3
    usbimager
    gparted
    nmon sysstat memtest86plus iotop ioping
    fio kdiskmark phoronix-test-suite sysbench # Benchmark
    unar p7zip zip unzip #rar unrar
    gnutar pigz lz4 zstd lzip gzip # TODO: fuck you xz vulnerability
    smartmontools
    hdparm sdparm nvme-cli sedutil
    idle3tools
    gocryptfs
    snapper-gui

    pv ncdu baobab # Analysis

    ### Servers
    apacheHttpd

    ## System/WM Utilities
    eww swww socat acpi
    bemenu
    dunst libnotify
    batsignal
    wlr-randr
    v4l-utils
    grim slurp wayshot
    feh
    hyprlock xidlehook
    hyprpaper
    mpd mpc-cli
    lxappearance
    networkmanagerapplet

    gnupg gnome-keyring seahorse libsecret
    networkmanager
    #gnome.gnome-screenshot # TODO:
    gnome-firmware gnome.gnome-control-center gnome-system-monitor
    dconf-editor
    #gnome.gnome-shell
    gnome.gnome-power-manager
    bluez bluez-tools blueman
    flameshot
    bitwarden bitwarden-cli
    screenkey
    arandr
    notify-desktop
    wl-clipboard xclip
    lxqt.lxqt-policykit
    nvtopPackages.full clinfo vulkan-tools libva-utils rocmPackages.rocminfo rocmPackages.rocm-smi
    bleachbit

    gnome-tweaks
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

  programs.neovim.plugins = [
    pkgs.vimPlugins.nvim-treesitter.withAllGrammars
  ];

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
    "steam-run" "steam-original"
  ];

}
