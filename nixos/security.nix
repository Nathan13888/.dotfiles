{ config, pkgs, ... }:

{

  services.dbus.enable = true;
  # Polkit
  security.polkit.enable = true;
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (
        subject.isInGroup("users")
          && (
            action.id == "org.freedesktop.login1.reboot" ||
            action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
            action.id == "org.freedesktop.login1.power-off" ||
            action.id == "org.freedesktop.login1.power-off-multiple-sessions"
          )
        )
      {
        return polkit.Result.YES;
      }
    })

    polkit.addRule(function(action, subject) {
      if (action.id.indexOf("org.freedesktop.NetworkManager.") == 0 && subject.isInGroup("network")) {
        return polkit.Result.YES;
      }
    });
  '';

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = true;
    execWheelOnly = true;
    extraConfig = "Defaults insults"; # TODO: fix
  };

  users = {
    defaultUserShell = pkgs.zsh;
    users.attackercow = {
      isNormalUser = true;
      home = "/home/attackercow";
      description = "";
      #hashedPassword = "$6$aEvS0ul31VsE9FcA$h9rWnpnYfxWD62cJl.On8IJecr41Hr5L18QOe7phPrVKY5hLG6yozwRZM5y1wxJBX8ahCutwFoWLbuzzGYMTB0";
      useDefaultShell = true;
      createHome = true;
      homeMode = "700";
      extraGroups = [ "wheel" "video" "input" "plugdev" "audio" "networkmanager" "libvirtd" "wireshark" "adbusers" "adbusers" "uucp" "dialout" "vboxusers" "realtime" "docker" ];
      uid = 1000;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGNJSdtQ4Rus1zXs2RV1yn8fO3yIQiVW6sq9VegtRNWd jirachi"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL7TcOidULMhrBPFGKxiWkJtYcp63S44AjaX++vrccw1 l3nnar"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILqswlpb5l8do56aqxnAWGdQFbG62FUyOPW+VJnVjhvv charry"
      ];
      openssh.authorizedKeys.keyFiles = [ ];
    };
  };
  #users.mutableUsers = false;
}
