{ config, lib, pkgs, options, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in
{
  imports = [
    ./audio.nix
    ./networking.nix
    ./packages.nix
    ./power.nix
    ./storage.nix
    ./virtualization.nix
    ./wm.nix
    # (import "$(home-manager)/nixos")
  ];

  boot = {
    blacklistedKernelModules = [ "snd_pcsp" ]; # TODO: what's this?
    # TODO: use lib.mkDefault
    kernelPackages = lib.mkDefault pkgs.linuxPackages_xanmod_stable;
    #kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_xanmod_latest.override {
    #  structuredExtraConfig = with lib.kernel; {
    #    X86_AMD_PSTATE = lib.mkForce yes;
    #  };
    #});

    extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ]; # zfs rtl88xxau-aircrack #wireguard
    #zfs.enableUnstable = true;
  };

  # reboot on kernel panic
  boot.kernelParams = ["panic=1" "boot.panic_on_fail"];

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

  services.udev.packages = with pkgs; [
    android-udev-rules
    gnome.gnome-settings-daemon
  ];


  security.sudo = {
    enable = true;
    wheelNeedsPassword = true;
    execWheelOnly = true;
    extraConfig = "Defaults insults";
  };


  programs.zsh.enable = true;

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

  #time.timeZone = "America/New_York";
  time.hardwareClockInLocalTime = false;

  # TODO: move to users.nix
  users = {
    defaultUserShell = pkgs.zsh;
    users.attackercow = {
      isNormalUser = true;
      home = "/home/attackercow";
      description = "Nathan";
      # TODO:
      #hashedPassword = "$6$aEvS0ul31VsE9FcA$h9rWnpnYfxWD62cJl.On8IJecr41Hr5L18QOe7phPrVKY5hLG6yozwRZM5y1wxJBX8ahCutwFoWLbuzzGYMTB0";
      useDefaultShell = true;
      createHome = true;
      homeMode = "700";
      extraGroups = [ "wheel" "video" "input" "plugdev" "audio" "networkmanager" "libvirtd" "wireshark" "adbusers" "adbusers" "uucp" "dialout" "vboxusers" "realtime" "docker" ];
      uid = 1000;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGNJSdtQ4Rus1zXs2RV1yn8fO3yIQiVW6sq9VegtRNWd attackercow@jirachi"
      ];
      openssh.authorizedKeys.keyFiles = [
        #/etc/nixos/ssh/authorized_keys
        # REMOVE, FIXX
      ];
    };
  };
  #users.mutableUsers = false; #TODO:
  environment.homeBinInPath = true;

  # TODO: move to locales.nix
  i18n.defaultLocale = "en_CA.UTF-8";
  time.timeZone = "America/Toronto";

  console = {
    font = "${pkgs.terminus_font}/share/consolefonts/ter-v32n.psf.gz";
    earlySetup = true;
    keyMap = "us";
  };

  nixpkgs.config = {
    allowUnfree = true;
    # system = "x86_64-linux";
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

    #maxJobs = pkgs.stdenv.lib.mkForce 6;
  };


  system.autoUpgrade.enable = false;
  system.autoUpgrade.allowReboot = false;

}

