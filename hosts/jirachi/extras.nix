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

  # TODO: move to general
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  hardware.openrazer.enable = true;
  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

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

  ### TLP
  services.thermald.enable = true;

  powerManagement = {
    enable = true;
    powertop.enable = true;
    cpuFreqGovernor = lib.mkDefault "ondemand";
  };

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  boot.initrd.luks.devices."luks-257293d5-1268-4412-a6b6-3b2813ea132b".keyFile = "/crypto_keyfile.bin";

  # TODO: sort
  boot.kernelParams = [ "mem_sleep_default=deep" ];
  #boot.kernelParams = [ "nohibernate" "nvme_core.default_ps_max_latency_us=0" "zfs_import_dir=/dev/disk/by-id" "zfs.zfs_arc_max=8589934592" "resume=/dev/vg0/lvswap" "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];

  #boot.initrd.availableKernelModules = [
  #  "aesni_intel" "cryptd"
  #];
  #boot.extraModprobeConfig = "options kvm_amd nested=1";
  #hardware.enableAllFirmware = true;
}
