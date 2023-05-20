{ config, pkgs, lib, ... }:

{
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  hardware.openrazer.enable = true;

  ### Fingerprint
  services.fprintd.enable = true;
  services.fprintd.tod.enable = true;
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-vfs0090;

  ### TLP
  services.thermald.enable = true;

  powerManagement = {
    enable = true;
    powertop.enable = true;
    #cpuFreqGovernor = lib.mkDefault "ondemand";
  };

  boot.kernelParams = [ "mem_sleep_default=deep" ];
  #boot.kernelParams = [ "nohibernate" "nvme_core.default_ps_max_latency_us=0" "zfs_import_dir=/dev/disk/by-id" "zfs.zfs_arc_max=8589934592" "resume=/dev/vg0/lvswap" "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];

  #boot.initrd.availableKernelModules = [
  #  "aesni_intel" "cryptd"
  #];
  #boot.extraModprobeConfig = "options kvm_amd nested=1";
  #hardware.enableAllFirmware = true;
}
