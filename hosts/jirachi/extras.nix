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

  # loading `amdgpu` kernelModule at stage 1. (Add `amdgpu` to `boot.initrd.kernelModules`)
  hardware.amdgpu.loadInInitrd = true;
  # use amdvlk drivers instead mesa radv drivers
  hardware.amdgpu.amdvlk = false;
  # rocm opencl runtime (Install rocm-opencl-icd and rocm-opencl-runtime)
  hardware.amdgpu.opencl = true;


  # TODO: fix opengl
  hardware.opengl = {
    enable = true;
    driSupport = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };

  # TODO: move to general
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  hardware.openrazer.enable = true;
  

  # TODO:
  ### Laptops
  services.fwupd.enable = true;
  services.hardware.bolt.enable = true;
  # NOTE: displaylink - prefetch
  # nix-prefetch-url --name displaylink.zip https://www.synaptics.com/sites/default/files/exe_files/2022-08/DisplayLink%20USB%20Graphics%20Software%20for%20Ubuntu5.6.1-EXE.zip
  services.xserver.videoDrivers = [ "displaylink" "modesetting" "amdgpu" ];
  services.xserver.displayManager.sessionCommands = ''
    ${lib.getBin pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource 2 0
  '';

  ### Fingerprint
  services.fprintd.enable = true;
  services.fprintd.tod.enable = true;
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-vfs0090;
  #services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix-550a;

  # Backlight
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="amdgpu_bl1", MODE="0666", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/%k/brightness"
  '';

  ### TLP
  powerManagement = {
    enable = true;
    powertop.enable = true;
    cpuFreqGovernor = "ondemand";
  };

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "ondemand";

      CPU_SCALING_MIN_FREQ_ON_AC = "400000";
      CPU_SCALING_MAX_FREQ_ON_AC = "4700000";
      CPU_SCALING_MIN_FREQ_ON_BAT = "400000";
      CPU_SCALING_MAX_FREQ_ON_BAT = "1800000";

      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      CPU_BOOST_ON_AC = "1";
      CPU_BOOST_ON_BAT = "0";

      SCHED_POWERSAVE_ON_AC = "0";
      SCHED_POWERSAVE_ON_BAT = "1";

      NMI_WATCHDOG = "0";

      PCIE_ASPM_ON_AC = "default";
      PCIE_ASPM_ON_BAT = "powersupersave";

      RADEON_DPM_PERF_LEVEL_ON_AC = "auto";
      RADEON_DPM_PERF_LEVEL_ON_BAT = "low";
      RADEON_DPM_STATE_ON_AC = "performance";
      RADEON_DPM_STATE_ON_BAT = "battery";

      WOL_DISABLE = "Y";

      START_CHARGE_THRESH_BAT0 = "0";
      STOP_CHARGE_THRESH_BAT0 = "80";

      PLATFORM_PROFILE_ON_AC = "balanced";
      PLATFORM_PROFILE_ON_BAT = "quiet";
    };
  };
  services.power-profiles-daemon.enable = false;

  fileSystems."/tmp" = {
    device = "none";
    fsType = "tmpfs";
    options = [ "defaults" "size=14G" "mode=755" ];
    #options = [ "defaults" "size=24G" "mode=755" ];
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
    "memmap=12M$20M"
  ];
  # "nohibernate"

  #boot.initrd.availableKernelModules = [
  #  "aesni_intel" "cryptd"
  #];
  #hardware.enableAllFirmware = true;
}
