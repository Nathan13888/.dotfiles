{ config, pkgs, ... }:

{
  programs.adb.enable = true;
  programs.firejail.enable = true;
  services.flatpak.enable = true;
  programs.mtr.enable = true;

  environment = {
    #variables.LANGUAGE = "en_CA";
    #variables.LC_ALL = "";
    #variables.LANG = "en_CA.UTF-8";
    #variables.LC_CTYPE = "en_CA.UTF-8";
    variables.TMPDIR = "/tmp";
    variables.EDITOR = "nvim";
    variables.TERMINAL = "kitty";
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

    #export OCL_ICD_VENDORS=`nix-build '<nixpkgs>' --no-out-link -A rocm-opencl-icd`/etc/OpenCL/vendors/
    #export VK_ICD_FILENAMES=`nix-build '<nixpkgs>' --no-out-link -A amdvlk`/share/vulkan/icd.d/amd_icd64.json


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

  nixpkgs.config.allowUnfree = true;
}

