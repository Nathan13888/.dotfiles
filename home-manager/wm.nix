{ config, pkgs, lib, ... }:

{
  imports = [
    ./gnome.nix
    ./gtk.nix
    ./hyprland
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

  dconf.enable = true;

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

  # TODO: keypassxc

  services.mpris-proxy.enable = true;

  services.syncthing = {
    enable = true;
    tray = {
      enable = false;
      package = pkgs.syncthingtray-minimal;
    };
  };
}
