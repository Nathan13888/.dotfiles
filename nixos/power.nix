{ config, lib, pkgs, ... }:


{
  services.earlyoom.enable = true;

  # /etc/systemd/logind.conf
  services.logind = {
    killUserProcesses = false; # default is false. determines if user processes should be killed

    # OPTIONS: 
    # "ignore" "poweroff" "reboot" "halt" "kexec" "suspend"
    # "hibernate" "hybrid-sleep" "suspend-then-hibernate" "lock"
    # DOCS: https://www.kernel.org/doc/Documentation/power/states.txt

    powerKey = "ignore";
    powerKeyLongPress = "poweroff";
    rebootKey = "reboot";
    rebootKeyLongPress = "reboot";

    # lidSwitch = "lock";
    lidSwitch = "suspend";
    lidSwitchExternalPower = "lock"; # for laptops.
    lidSwitchDocked = "ignore"; # for laptops. docked or >=1 connected displays
  };

  # DOCS: https://www.freedesktop.org/software/systemd/man/logind.conf.html

  # TODO: systemd-inhibit --what=handle-lid-switch lock-screen-tool
  # ignore lidswitch
  services.logind.extraConfig = ''
    LidSwitchIgnoreInhibited=no

    IdleAction=ignore
  '';

  # /etc/systemd/sleep.conf
  # DOCS: https://www.freedesktop.org/software/systemd/man/systemd-sleep.conf.html
  systemd.sleep.extraConfig = lib.mkDefault ''
    AllowSuspend=yes
    AllowHibernation=yes
    AllowSuspendThenHibernate=yes
    AllowHybridSleep=no
    SuspendState=mem standby
  '';
    #SuspendMode=
    #SuspendState=mem freeze standby
    #HibernateMode=platform shutdown
    #HibernateState=disk
    #HybridSleepMode=suspend platform shutdown
    #HybridSleepState=disk
    #HibernateDelaySec=
    #SuspendEstimationSec=60min

  ## TLP
  services.tlp = {
    enable = lib.mkDefault false;
    settings = lib.mkDefault {
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      CPU_BOOST_ON_AC = "1";
      CPU_BOOST_ON_BAT = "0";

      SCHED_POWERSAVE_ON_AC = "0";
      SCHED_POWERSAVE_ON_BAT = "1";

      NMI_WATCHDOG = "0";

      PCIE_ASPM_ON_AC = "default";
      PCIE_ASPM_ON_BAT = "powersupersave";

      WOL_DISABLE = lib.mkDefault "Y";

      START_CHARGE_THRESH_BAT0 = "0";
      STOP_CHARGE_THRESH_BAT0 = "80";

      PLATFORM_PROFILE_ON_AC = "balanced";
      PLATFORM_PROFILE_ON_BAT = "quiet";
    };
  };
  services.power-profiles-daemon.enable = lib.mkDefault false;

  powerManagement.resumeCommands = ''
    echo "This should show up in the journal after resuming."
  '';

}
