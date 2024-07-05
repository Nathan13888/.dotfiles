{ config, pkgs, lib, ... }:

{
  networking.hostName = "LENNAR";
  networking.hostId = "2d5d9c67"; # head -c 8 /etc/machine-id
  system.stateVersion = "21.11";

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  hardware.openrazer.enable = true;

  ### Video, Hardware Accel
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
  hardware.video.hidpi.enable = false;

  ### Fingerprint
  services.fprintd.enable = true;
  services.fprintd.tod.enable = true;
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-vfs0090;

  ### TLP
  services.thermald.enable = true; # INTEL ONLY
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      # TODO: adjust frequencies
      CPU_SCALING_MIN_FREQ_ON_AC = "400000";
      CPU_SCALING_MAX_FREQ_ON_AC = "4935000";
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
      STOP_CHARGE_THRESH_BAT0 = "60";

      PLATFORM_PROFILE_ON_AC = "balanced";
      PLATFORM_PROFILE_ON_BAT = "quiet";
    };
  };
  services.power-profiles-daemon.enable = false;

  powerManagement = {
    enable = true;
    powertop.enable = true;
    #cpuFreqGovernor = lib.mkDefault "ondemand";
  };

  fileSystems."/tmp" = {
    device = "none";
    fsType = "tmpfs";
    options = [ "defaults" "size=14G" "mode=755" ];
    #options = [ "defaults" "size=24G" "mode=755" ];
  };

  boot.kernelParams = [
    "mem_sleep_default=deep"
  ];
  #boot.kernelParams = [ "nohibernate" "nvme_core.default_ps_max_latency_us=0" "zfs_import_dir=/dev/disk/by-id" "zfs.zfs_arc_max=8589934592" "resume=/dev/vg0/lvswap" "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];

  #boot.initrd.availableKernelModules = [
  #  "aesni_intel" "cryptd"
  #];
  #boot.extraModprobeConfig = "options kvm_amd nested=1";
  #hardware.enableAllFirmware = true;
}
