{ config, pkgs, lib, ... }:

{
  networking.hostName = "jirachi";
  networking.hostId = "1b5ad887"; # head -c 8 /etc/machine-id
  # NOTE: man configuration.nix or on https://nixos.org/nixos/options.html
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  system.stateVersion = "23.05";

  environment.variables = {
    #NIX_BUILD_CORES = "15"
    #AMD_VULKAN_ICD = "RADV";

    # ls -l /dev/dri/by-path
    WLR_DRM_DEVICES = "/dev/dri/card1:/dev/dri/card0";
  };

  environment.systemPackages = with pkgs; [
    # TODO:
    #howdy
  ];

  # Build Settings
  # TODO:
  nix.settings.max-jobs = 2;
  nix.settings.cores = 8;

  # Chaotic Nyx
  # --option 'extra-substituters' 'https://nyx.chaotic.cx/' --option extra-trusted-public-keys "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
  chaotic.nyx.cache.enable = true; # enable cache (default)

  # TODO:
  # Kernel and HDR (Sussy)
  #boot.kernelPackages = pkgs.linuxPackages_cachyos;
  chaotic.hdr = {
    enable = false;
    #enable = true;
  };
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;

  # use amdvlk drivers instead mesa radv drivers
  hardware.amdgpu.amdvlk.enable = false;
  # rocm opencl runtime (Install rocm-opencl-icd and rocm-opencl-runtime)
  hardware.amdgpu.opencl.enable = true;

  ## HIP
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];
  # Check with:
  # vainfo rocminfo vulkaninfo clinfo nvtop
  # getfacl /dev/dri/card0

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
      rocm-opencl-icd
      amdvlk
      intel-gmmlib
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      intel-ocl
      vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
    ];
    extraPackages32 = with pkgs; [
      driversi686Linux.amdvlk
    ];
  };

  # Steam
  hardware.graphics.enable32Bit = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };

  # TODO: move to general
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  hardware.openrazer.enable = true;

  # TODO: virtualization options
  virtualisation.waydroid.enable = true;

  # TODO:
  ### Laptops
  services.fwupd.enable = true;
  services.hardware.bolt.enable = true;
  # NOTE: displaylink - prefetch
  # nix-prefetch-url --name displaylink.zip https://www.synaptics.com/sites/default/files/exe_files/2022-08/DisplayLink%20USB%20Graphics%20Software%20for%20Ubuntu5.6.1-EXE.zip
  services.xserver.videoDrivers = [ "modesetting" "amdgpu" ];
  #services.xserver.videoDrivers = [ "displaylink" "modesetting" "amdgpu" ];
  services.xserver.displayManager.sessionCommands = ''
    ${lib.getBin pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource 2 0
  '';

  ### Fingerprint
  services.fprintd.enable = true;

  # Udev rules
  # allow users to change display brightness (oled)
  # disable wakeup for pci devices
  services.udev.enable = true;
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="amdgpu_bl1", MODE="0666", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/%k/brightness"
    ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="amdgpu_bl2", MODE="0666", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/%k/brightness"
    ACTION=="add", SUBSYSTEM=="pci", DRIVER=="pcieport", ATTR{power/wakeup}="disabled"
  '';

  #system.activationScripts.script.text = ''chmod o+rw /dev/ttyACM0'';

  ### UPower
  services.upower = {
    enable = true;
    percentageLow = 10;
    percentageCritical = 7;
    percentageAction = 3;
    # TODO: fix, remove shutdown
    criticalPowerAction = "HybridSleep"; # "PowerOff" "Hibernate" "HybridSleep"
  };
  # TODO: https://gist.github.com/mattdenner/befcf099f5cfcc06ea04dcdd4969a221

  ### TLP
  powerManagement = {
    enable = true;
    powertop.enable = true;
    cpuFreqGovernor = "powersave";
    #cpuFreqGovernor = "ondemand";
  };

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_SCALING_MIN_FREQ_ON_AC = "400000";
      CPU_SCALING_MAX_FREQ_ON_AC = "4785000";
      CPU_SCALING_MIN_FREQ_ON_BAT = "400000";
      CPU_SCALING_MAX_FREQ_ON_BAT = "3200000";

      SOUND_POWER_SAVE_ON_AC = "0";
      SOUND_POWER_SAVE_ON_BAT = "1"; # TODO: check

      TLP_DEFAULT_MODE = "BAT"; # TODO: check
      TLP_PERSISTENT_DEFAULT = 1;

      RADEON_DPM_PERF_LEVEL_ON_AC = "auto";
      RADEON_DPM_PERF_LEVEL_ON_BAT = "low";
      RADEON_DPM_STATE_ON_AC = "performance";
      RADEON_DPM_STATE_ON_BAT = "battery";
    };
  };

  #services.auto-cpufreq.enable = true;

  fileSystems."/tmp" = {
    device = "none";
    fsType = "tmpfs";
    options = [ "defaults" "size=8G" "mode=755" ];
  };

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  boot.initrd.luks.devices."luks-257293d5-1268-4412-a6b6-3b2813ea132b".keyFile = "/crypto_keyfile.bin";

  # TODO: sort
  boot.kernelParams = [
    "amd_iommu=on"
    "mem_sleep_default=deep"
    "nvme_core.default_ps_max_latency_us=0"
    # TODO:
    #"memmap=12M$20M" #https://kb.pmem.io/
  ];

  #boot.initrd.availableKernelModules = [
  #  "aesni_intel" "cryptd"
  #];
  #hardware.enableAllFirmware = true;
}
