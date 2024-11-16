{ config, pkgs, ... }:

{
  programs.dconf.enable = true;
  services.gvfs.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    xkb.options = "eurosign:e";
    dpi = 96;
    desktopManager = {
      xterm.enable = false;
    };

    #displayManager.gdm.enable = true;
    #displayManager.gdm.wayland = true;


  };
  services.greetd = {
    enable = true;
    settings = rec {
      default_session = {
      #initial_session = {
        command = "${pkgs.hyprland}/bin/Hyprland";
        user = "Nathan";
      };
      #default_session = initial_session;
    };
  };


  # TODO: refactor to laptops
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

  # https://wiki.hyprland.org/Nix/
  programs.hyprland.enable = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1"; # hint electron apps to use wayland
  services.displayManager.defaultSession = "hyprland";

  xdg.portal.config.common.default = "*";
  xdg.portal.enable = true;
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
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji
      noto-fonts-extra
      last-resort
    ];
  };

}
