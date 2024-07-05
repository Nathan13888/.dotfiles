{ config, pkgs, ... }:


let
  automount_opts = "defaults,_netdev,nofail,uid=1000,gid=1000,dir_mode=0775,file_mode=0664,noauto,x-systemd.automount,x-systemd.mount-timerout=10,x-systemd.idle-timeout=1min,vers=3.0,iocharset=utf8";
in
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
        SUBVOLUME = "/home";
        # TODO:
        #extraConfig = ''
        #  ALLOW_USERS="attackercow"
        #  TIMELINE_CREATE=yes
        #  TIMELINE_CLEANUP=yes
        #  TIMELINE_LIMIT_HOURLY=3
        #  TIMELINE_LIMIT_DAILY=2
        #  TIMELINE_LIMIT_WEEKLY.20
        #  TIMELINE_LIMIT_MONTHLY=4
        #  TIMELINE_LIMIT_YEARLY=0
        #'';
      };
    };
  };

  fileSystems."/nas/personal" = {
    device = "192.168.20.200:/mnt/honshu/vaults/attackercow";
    fsType = "nfs";
    options = [ "x-systemd.automount" "noauto" "nfsvers=4.2" "x-systemd.idle-timeout=600" ];
  };

  fileSystems."/nas/media" = {
    device = "192.168.20.200:/mnt/honshu/media";
    fsType = "nfs";
    options = [ "x-systemd.automount" "noauto" "nfsvers=4.2" "x-systemd.idle-timeout=600" ];
  };

#  fileSystems."/nas/personal" = {
#    device = "//192.168.20.225/vault";
#    fsType = "cifs";
#    options =
#      [ "${automount_opts},credentials=/etc/nixos/.smb" ];
#  };
#
#  fileSystems."/nas/home" = {
#    device = "//192.168.20.225/home";
#    fsType = "cifs";
#    options =
#      [ "${automount_opts},credentials=/etc/nixos/.smb" ];
#  };
#
#  fileSystems."/nas/archive" = {
#    device = "//192.168.20.225/archive";
#    fsType = "cifs";
#    options =
#      [ "${automount_opts},credentials=/etc/nixos/.smb" ];
#  };
#
#  fileSystems."/nas/dumps" = {
#    device = "//192.168.20.225/dumps";
#    fsType = "cifs";
#    options =
#      [ "${automount_opts},credentials=/etc/nixos/.smb" ];
#  };
#
#  fileSystems."/nas/isos" = {
#    device = "//192.168.20.225/isos";
#    fsType = "cifs";
#    options =
#      [ "${automount_opts},credentials=/etc/nixos/.smb" ];
#  };
#
#  fileSystems."/nas/media" = {
#    device = "//192.168.20.225/media";
#    fsType = "cifs";
#    options =
#      [ "${automount_opts},credentials=/etc/nixos/.smb" ];
#  };
#
#  fileSystems."/nas/public" = {
#    device = "//192.168.20.225/public";
#    fsType = "cifs";
#    options =
#      [ "${automount_opts},credentials=/etc/nixos/.smb" ];
#  };
#
#  fileSystems."/nas/torrents" = {
#    device = "//192.168.20.225/torrents";
#    fsType = "cifs";
#    options =
#      [ "${automount_opts},credentials=/etc/nixos/.smb" ];
#  };
#
#  fileSystems."/nas/datasets" = {
#    device = "//192.168.20.225/datasets";
#    fsType = "cifs";
#    options =
#      [ "${automount_opts},credentials=/etc/nixos/.smb" ];
#  };
}
