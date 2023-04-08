{ config, pkgs, options, ... }:

{
  imports = [
    ./input.nix
    ./networking.nix
    ./packages.nix
    ./power.nix
    ./storage.nix
    ./virtualization.nix
    ./wm.nix
  ];

  boot = {
    blacklistedKernelModules = [ "snd_pcsp" ];
    kernelPackages = pkgs.linuxPackages_xanmod; #pkgs.linuxPackages_latest;
    extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ]; # zfs rtl88xxau-aircrack #wireguard
    #zfs.enableUnstable = true;

    crashDump.enable = false;
    cleanTmpDir = false;

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
  #boot.initrd.availableKernelModules = [
  #  "aesni_intel" "cryptd"
  #];
  #boot.kernelParams = [ "nohibernate" "nvme_core.default_ps_max_latency_us=0" "zfs_import_dir=/dev/disk/by-id" "zfs.zfs_arc_max=8589934592" "resume=/dev/vg0/lvswap" "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
  #boot.extraModprobeConfig = "options kvm_amd nested=1";
  #hardware.enableAllFirmware = true;

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
      # FIXX
      #settings = {
      #  passwordAuthentication = false;
      #	permitRootLogin = "no";
      #  kbdInteractiveAuthentication = false;
      #  #challengeResponseAuthentication = false;
      #};
    };
    autorandr.enable = true;
  };

  time.timeZone = "America/New_York";
  time.hardwareClockInLocalTime = false;
  
  users = {
    defaultUserShell = pkgs.zsh;
    users.attackercow = {
      isNormalUser = true;
      home = "/home/attackercow";
      description = "Nathan";
      hashedPassword = "$6$aXA3wSjO6ZqZwUhx$23ygPhj.yF7gbpTaj0oB3DueQjqhAR3eLRyS1MKWR.ZqHi1pDr0vHN3bfLLUvOEbdfZH5eBPWiqwqm.Pz/Mwa.";
      useDefaultShell = true;
      createHome = true;
      homeMode = "700";
      extraGroups = [ "wheel" "video" "input" "plugdev" "audio" "networkmanager" "libvirtd" "wireshark" "adbusers" "adbusers" "uucp" "dialout" "vboxusers" "realtime" "docker" ];
      uid = 1000;
      openssh.authorizedKeys.keyFiles = [
        #/etc/nixos/ssh/authorized_keys
        # REMOVE, FIXX
      ];
    };
  };
  environment.homeBinInPath = true;

  i18n = {
    defaultLocale = "en_CA.UTF-8";
  };

  console = {
    font = "Lat2-Terminus16";
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
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
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

  system.stateVersion = "21.11";

}

