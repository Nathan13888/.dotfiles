{ config, pkgs, ... }:


{
  # https://nixos.wiki/wiki/Btrbk
  # https://github.com/digint/btrbk
  services.btrbk = {
    extraPackages = [ pkgs.lz4 ];
    #instances.remote = {
    #  onCalendar = "weekly";
    #  settings = {
    #    ssh_identity = "/etc/btrbk_key"; # NOTE: must be readable by user/group btrbk
    #    ssh_user = "btrbk";
    #    stream_compress = "lz4";
    #    volume."/btr_pool" = {
    #      target = "ssh://myhost/mnt/mybackups";
    #      subvolume = "nixos";
    #    };
    #  };
    #};
  };

  # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/services/misc/snapper.nix
  services.snapper = {
    snapshotRootOnBoot = false;
    snapshotInterval = "hourly"; # doc: {manpage}`systemd.time(7)
    cleanupInterval = "3h";
    filters = null;
    configs = {
      home = {
        subvolume = "/home";
        extraConfig = ''
          ALLOW_USERS="attackercow"
          TIMELINE_CREATE=yes
          TIMELINE_CLEANUP=yes
          TIMELINE_LIMIT_HOURLY=3
          TIMELINE_LIMIT_DAILY=2
          TIMELINE_LIMIT_WEEKLY=10
          TIMELINE_LIMIT_MONTHLY=4
          TIMELINE_LIMIT_YEARLY=0
        '';
      };
    };
  };

  fileSystems."/nas/personal" = {
    device = "//192.168.10.226/Personal";
    fsType = "cifs";
    options =
      let
        automount_opts = "uid=1000,gid=1000,noauto,vers=3.0,iocharset=utf8";
      in
      [ "${automount_opts},credentials=/etc/nixos/.smb" ];
  };

  fileSystems."/nas/archive" = {
    device = "//192.168.10.226/Archive";
    fsType = "cifs";
    options =
      let
        automount_opts = "uid=1000,gid=1000,noauto,vers=3.0,iocharset=utf8";
      in
      [ "${automount_opts},credentials=/etc/nixos/.smb" ];
  };

  fileSystems."/nas/backup" = {
    device = "//192.168.10.226/Backup";
    fsType = "cifs";
    options =
      let
        automount_opts = "uid=1000,gid=1000,noauto,vers=3.0,iocharset=utf8";
      in
      [ "${automount_opts},credentials=/etc/nixos/.smb" ];
  };

  fileSystems."/nas/media" = {
    device = "//192.168.10.226/Media";
    fsType = "cifs";
    options =
      let
        automount_opts = "uid=1000,gid=1000,noauto,vers=3.0,iocharset=utf8";
      in
      [ "${automount_opts},credentials=/etc/nixos/.smb" ];
  };

  fileSystems."/nas/public" = {
    device = "//192.168.10.226/Public";
    fsType = "cifs";
    options =
      let
        automount_opts = "uid=1000,gid=1000,noauto,vers=3.0,iocharset=utf8";
      in
      [ "${automount_opts},credentials=/etc/nixos/.smb" ];
  };


  #  "compress=zstd" "noatime" "autodefrag"
}
