{ config, pkgs, ... }:

{
  services.dbus.enable = true;
  programs.dconf.enable = true;
  services.gvfs.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    #enable = false;
    layout = "us";
    xkbOptions = "eurosign:e";
    dpi = 96;
    desktopManager = {
      xterm.enable = false;
    };

    # Enable touchpad support (enabled default in most desktopManager).
    libinput = {
      enable = true;
      # disabling mouse acceleration
      mouse = {
        accelProfile = "adaptive";
        naturalScrolling = false;
        accelSpeed = null;
      };
      # disabling touchpad acceleration
      touchpad = {
        accelProfile = "flat";
        scrollMethod = "twofinger";
        naturalScrolling = true;
        tapping = true;
        accelSpeed = "1"; # float value in [-1,1]
      };
      # ^^^ or "adaptive"
    };


    # TODO: move to GDM
    displayManager.gdm.enable = true;
    displayManager.gdm.wayland = true;


    # TODO: move to i3
    #displayManager.defaultSession = "none+i3";
    #displayManager.startx.enable = true;
    #displayManager.lightdm = {
    #  enable = false;
    #};

    #windowManager.i3 = {
    #  package = pkgs.i3-gaps;
    #  enable = true;
    #  extraPackages = with pkgs; [
    #    polybarFull dunst rofi
    #    feh
    #    i3lock-color
    #  ];
    #};
    # END
  };

  # TODO: move gnome
  #services.xserver.desktopManager.default = "hyprland";
  services.xserver.displayManager.defaultSession = "hyprland";
  #services.xserver.desktopManager.gnome.enable = true;
  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
  ]) ++ (with pkgs.gnome; [
    cheese # webcam tool
    gnome-music
    gnome-terminal
    gedit # text editor
    epiphany # web browser
    geary # email reader
    evince # document viewer
    gnome-characters
    totem # video player
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
  ]);


  # TODO: move to greetd
  #services.greetd = {
  #  enable = true;
  #  settings = rec {
  #    initial_session = {
  #      command = "${pkgs.hyprland}/bin/Hyprland";
  #      user = "attackercow";
  #    };
  #    default_session = initial_session;
  #  };
  #};

  xdg.portal.enable = true;
  # TODO: move wayland
  xdg.portal.extraPortals = with pkgs; [
    #xdg-desktop-portal-wlr
    xdg-desktop-portal-gtk
    #xdg-desktop-portal-kde
  ];


  fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;

    enableDefaultFonts = true;
    fontconfig = {
      enable = true;
      antialias = true;
      useEmbeddedBitmaps = true;

      defaultFonts = {
        serif = [ "Source Serif Pro" "DejaVu Serif" ];
        sansSerif = [ "Source Sans Pro" "DejaVu Sans" ];
        monospace = [ "Fira Code" "Hasklig" ];
      };
    };

    fonts = with pkgs; [
      source-code-pro
      nerdfonts
      fira
      fira-code
      fira-mono
      fira-code-symbols
      mplus-outline-fonts.githubRelease

      noto-fonts
      noto-fonts-cjk
      noto-fonts-cjk-serif
      noto-fonts-emoji
      noto-fonts-extra
      last-resort
    ];
  };

}
