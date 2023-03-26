{ config, pkgs, lib, ... }:

# let
#   pkgs = import nixpkgs {
#     inherit system;
#     config.allowUnfree = true;
#     config.xdg.configHome = configHome;
#     overlays = [ nurpkgs.overlay ];
#   };

#   nur = import nurpkgs {
#     inherit pkgs;
#     nurpkgs = pkgs;
#   };
# in
{
  home.username = "attackercow";
  home.homeDirectory = "/home/attackercow";

  # You can update Home Manager without changing this value
  home.stateVersion = "22.11";

  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;
  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 34560000;
    maxCacheTtl = 34560000;
    enableSshSupport = true;
  };

  services.gnome-keyring = {
    enable = true;
    components = [ "pkcs11" "ssh" ];
    #components = [ "pkcs11" "secrets" "ssh" ];
  };

  services.mpris-proxy.enable = true;

  services.syncthing = {
    enable = true;
    tray = {
      enable = true;
      package = pkgs.syncthingtray-minimal;
    };
  };

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
  ];

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
    patchelf #steam-run
    nixpkgs-fmt
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
    brave firefox-bin ungoogled-chromium # Browsers
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
    sshfs
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
    xss-lock
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
    xclip
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

  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    theme = {
      name = "palenight";
      package = pkgs.palenight-theme;
    };

    cursorTheme = {
      name = "Numix-Cursor"; # capitaine-cursors
      package = pkgs.numix-cursor-theme;
    };

    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };

    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/wm/keybindings" = {
        screenshot = [ "<super><shift>s" ];
        screenshot-window = [];
        panel-run-dialog = [ "<super>space" ]; # run a command

        close = [ "<super><shift>c" "<alt>f4" ];  # close window
        open-application-menu = [];
        toggle-application-view = [ "<super>d" ];
        toggle-overview = [];

        # shift between overview states
        shift-overview-up = [];
        shift-overview-down = [];

        # move window one monitor to the left/right
        move-to-monitor-left = [];
        move-to-monitor-right = [];
        # move to monitor up: disable <super><shift>up
        move-to-monitor-up = [];
        # super + ctrl + direction keys, change workspaces, move focus between monitors
        # move to monitor down: disable <super><shift>down
        move-to-monitor-down = [];
        # super + direction keys, move window left and right monitors, or up and down workspaces

        switch-to-application-1 = [];
        switch-to-application-2 = [];
        switch-to-application-3 = [];
        switch-to-application-4 = [];
        switch-to-application-5 = [];
        switch-to-application-6 = [];
        switch-to-application-7 = [];
        switch-to-application-8 = [];
        switch-to-application-9 = [];

        toggle-message-try = [ "<super>m" ];

        toggle-maximized = [ "<super>f" ]; # toggle maximization state
        toggle-fullscreen = [ "<super><shift>f" ];
        minimize = [ "<super>comma" ];   # hide window: disable <super>h
        maximize = [];                   # maximize window: disable <super>up
        unmaximize = [];                 # restore window: disable <super>down

        # Move window N/E/S/W
        move-to-side-w = [ "<super><shift>h" ];
        move-to-side-e = [ "<super><shift>l" ];
        move-to-side-n = [ "<super><shift>k" ];
        move-to-side-s = [ "<super><shift>j" ];

        # Move to workspace X
        move-to-workspace-1 = [ "<super><shift>1" ];
        move-to-workspace-2 = [ "<super><shift>2" ];
        move-to-workspace-3 = [ "<super><shift>3" ];
        move-to-workspace-4 = [ "<super><shift>4" ];
        move-to-workspace-5 = [ "<super><shift>5" ];
        move-to-workspace-6 = [ "<super><shift>6" ];
        move-to-workspace-7 = [ "<super><shift>7" ];
        move-to-workspace-8 = [ "<super><shift>8" ];
        move-to-workspace-9 = [ "<super><shift>9" ];
        move-to-workspace-10 = [ "<super><shift>0" ];

        move-to-workspace-last = [];
        move-to-workspace-left = [];
        move-to-workspace-right = [];
        move-to-workspace-down = [];
        move-to-workspace-up = [];


        # Switch to workspace X
        switch-to-workspace-1 = [ "<super>1" ];
        switch-to-workspace-2 = [ "<super>2" ];
        switch-to-workspace-3 = [ "<super>3" ];
        switch-to-workspace-4 = [ "<super>4" ];
        switch-to-workspace-5 = [ "<super>5" ];
        switch-to-workspace-6 = [ "<super>6" ];
        switch-to-workspace-7 = [ "<super>7" ];
        switch-to-workspace-8 = [ "<super>8" ];
        switch-to-workspace-9 = [ "<super>9" ];
        switch-to-workspace-10 = [ "<super><alt>f" ];

        switch-to-workspace-left = [];   # switch to workspace left: disable <super>left
        switch-to-workspace-right = [];  # switch to workspace right: disable <super>right
        switch-to-workspace-down = [       # move to workspace below
          "<primary><super>down" "<primary><super>j"
        ];
        switch-to-workspace-up = [     # move to workspace above
          "<primary><super>up" "<primary><super>k"
        ];
        switch-to-workspace-last = [];
      };

      "org/gnome/desktop/wm/preferences" = {
        num-workspaces = 10;
      };

      "org/gnome/settings-daemon/plugins/media-keys" = {
        screensaver = [ "<super>escape" ];  # lock screen
        home = [];                          # home folder:  "<super>f"
        email = [];                         # launch email client: disable  "<super>e" 
        www = [ "<super>b" ];               # launch web browser
        terminal = [ "<super>enter" ];    # launch terminal
        rotate-video-lock-static = [];      # rotate video lock
      };
      "org/gnome/shell" = {
        disable-user-extensions = false;

        # `gnome-extensions list` for a list
        enabled-extensions = [
          "appindicatorsupport@rgcjonas.gmail.com"
          "pop-shell@system76.com"
          "user-theme@gnome-shell-eampax.github.com"
          "trayIconsReloaded@selfmade.pl"
          "Vitals@CoreCoding.com"
          "dash-to-panel@jderose9.github.com"
          "sound-output-device-chooser@kgshank.net"
          "space-bar@luchrioh"
        ];
      };
      # Dash to Panel
      "org/gnome/shell/extensions/dash-to-panel" = {
        panel-element-positions = "{\"0\":[{\"element\":\"showAppsButton\",\"visible\":false,\"position\":\"stackedTL\"},{\"element\":\"activitiesButton\",\"visible\":false,\"position\":\"stackedTL\"},{\"element\":\"leftBox\",\"visible\":true,\"position\":\"stackedTL\"},{\"element\":\"taskbar\",\"visible\":false,\"position\":\"stackedTL\"},{\"element\":\"dateMenu\",\"visible\":true,\"position\":\"centerMonitor\"},{\"element\":\"centerBox\",\"visible\":false,\"position\":\"stackedBR\"},{\"element\":\"rightBox\",\"visible\":true,\"position\":\"stackedBR\"},{\"element\":\"systemMenu\",\"visible\":true,\"position\":\"stackedBR\"},{\"element\":\"desktopButton\",\"visible\":true,\"position\":\"stackedBR\"}]}";
        panel-sizes = "{\"0\":43}";
        window-preview-title-position = "TOP";
      };

      "org/gnome/mutter/wayland/keybindings" = {
        # restore the keyboard shortcuts: disable <super>escape
        restore-shortcuts = [];
      };
      "org/gnome/mutter" = {
        workspaces-only-on-primary = false;
      };
    };
  };
}

