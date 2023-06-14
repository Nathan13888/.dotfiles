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

    libinput.enable = true;


    #displayManager.gdm.enable = true;
    #displayManager.gdm.wayland = true;
    #desktopManager.gnome = {
    #  enable = true;
    #  #extraPackages = with pkgs; [
    #  #  pop-desktop-widget
    #  #  pop-control-center
    #  #  pop-launcher
    #  #  pop-shell-shortcuts
    #  #];
    #};

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
  };

  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "${pkgs.hyprland}/bin/Hyprland";
        user = "attackercow";
      };
      default_session = initial_session;
    };
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-wlr
    xdg-desktop-portal-gtk
    xdg-desktop-portal-kde
  ];

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
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      noto-fonts-extra
      source-code-pro
      nerdfonts
      fira
      fira-code
      fira-mono
    ];
  };

}
