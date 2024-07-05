{ config, pkgs, ... }:

{
  programs.dconf.enable = true;
  services.gvfs.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    #enable = false;
    xkb.layout = "us";
    xkb.options = "eurosign:e";
    dpi = 96;
    desktopManager = {
      xterm.enable = false;
    };



    # TODO: move to GDM
    displayManager.gdm.enable = true;
    displayManager.gdm.wayland = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput = {
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
      tapping = false;
      tappingButtonMap = "lrm";
      accelSpeed = "1"; # float value in [-1,1]
    };
    # ^^^ or "adaptive"
  };

  # TODO: move gnome
  services.displayManager.defaultSession = "hyprland";
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

  xdg.portal.config.common.default = "*";
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

    enableDefaultPackages = true;
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

    packages = with pkgs; [
      source-code-pro
      #nerdfonts
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
