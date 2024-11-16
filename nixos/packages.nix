{
  config,
  lib,
  pkgs,
  system,
  nixpkgs-staging-next,
  ...
}:

{
  programs.adb.enable = true;
  programs.firejail.enable = true;
  services.flatpak.enable = true;
  programs.mtr.enable = true;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
    fuse3
    icu
    zlib
    nss
    openssl
    curl
    expat
    # ...
  ];

  # https://github.com/Mic92/envfs
  #services.envfs.enable = true;

  programs.corectrl.enable = true;

  # TODO: workaround for https://github.com/NixOS/nixpkgs/pull/300028
  # SOURCE: https://github.com/DarkKirb/nixos-config/pull/381/
  system.replaceDependencies.replacements = [
    {
      original = pkgs.xz;
      replacement = nixpkgs-staging-next.legacyPackages.${system}.xz;
    }
  ];

  environment = {
    #variables.LANGUAGE = "en_CA";
    #variables.LC_ALL = "";
    #variables.LANG = "en_CA.UTF-8";
    #variables.LC_CTYPE = "en_CA.UTF-8";
    variables.TMPDIR = "/tmp";
    variables.EDITOR = "nvim";
    variables.TERMINAL = "rio";
    variables.TERM = "xterm-256color";
    variables.BROWSER = "firefox";
    #variables.XDG_DATA_DIRS = "/var/lib/flatpak/exports/share:/home/attackercow/.local/share/flatpak/exports/share";
    variables.INPUT_METHOD = "fcitx";
    variables.GTK_IM_MODULE = "fcitx";
    variables.QT_IM_MODULE = "fcitx";
    variables.QT_QPA_PLATFORM = "wayland;xcb";
    variables.XMODIFIERS = "@im=fcitx";
    variables.NIXPKGS_ALLOW_UNFREE = "1";
    variables.GDK_BACKEND = "wayland";
    variables.XDG_SESSION_TYPE = "wayland";
    variables.NIXOS_OZONE_WL = "1";
    variables.GLFW_IM_MODULE = "ibus";

    variables.XDG_CURRENT_DESKTOP = "GNOME";
    variables.XDG_SESSION_DESKTOP = "gnome";


    # $ nix search wget
    systemPackages = with pkgs; [
      linuxHeaders
      vim
      tmux
      neofetch
      git
      wget
      curl
    ];
  };
  environment.homeBinInPath = true;

  programs.zsh.enable = true;
  services.udev.packages = with pkgs; [
    android-udev-rules
    gnome-settings-daemon
  ];

  nix = {
    package = lib.mkDefault pkgs.nixVersions.latest;
    # TODO:
    #settings.trusted-substituters = [
    #  "http://cache.nixos.org"
    #];

    #settings = {
    #  substituters = [
    #    "http://cache.nixos.org"
    #    "https://hyprland.cachix.org"
    #  ];
    #  trusted-public-keys = [
    #    "https://nix-community.cachix.org"
    #    "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    #  ];
    #};
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;
}

