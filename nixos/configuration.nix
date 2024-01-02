{ config, lib, pkgs, options, ... }:

{
  imports = [
    ./networking.nix
    ./storage.nix
    ./security.nix
    ./locale.nix
    ./power.nix
    ./virtualization.nix
    ./packages.nix
    ./wm.nix
    ./audio.nix
  ];

  boot = {
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
    blacklistedKernelModules = [ ];
  };

  # reboot on kernel panic
  boot.kernelParams = [ "panic=1" "boot.panic_on_fail" ];

  # systemd tweaks
  systemd.enableEmergencyMode = false;

  boot = {
    crashDump.enable = false;
    tmp.cleanOnBoot = false;

    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
        memtest86.enable = true;
      };
      efi.canTouchEfiVariables = true;
      grub.enable = false;
    };

    supportedFilesystems = [
      "exfat"
      "vfat"
      "btrfs"
    ];
  };

  programs.ssh.startAgent = true;
  services = {
    openssh = {
      enable = true;

      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
    };
    autorandr.enable = true;
  };

  nix = {
    package = pkgs.nixUnstable;
    settings.trusted-substituters = [
      "http://cache.nixos.org"
    ];

    settings = {
      substituters = [
        "http://cache.nixos.org"
        #"https://hyprland.cachix.org"
      ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };

    settings.auto-optimise-store = true;
    gc.automatic = false;

    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };


  system.autoUpgrade.enable = false;
  system.autoUpgrade.allowReboot = false;

}

