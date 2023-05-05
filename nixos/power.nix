{ config, pkgs, ... }:


{
  services.earlyoom.enable = true;
  
  #services.tlp.enable = true;
  #services.tlp.settings = {
  #  CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
  #  CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

  #  CPU_SCALING_GOVERNOR_ON_AC = "performance";
  #  CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

  #  CPU_BOOST_ON_AC = 1;
  #  CPU_BOOST_ON_BAT = 0;

  #  CPU_MIN_PERF_ON_AC = 0;
  #  CPU_MIN_PERF_ON_BAT = 0;
  #  CPU_MAX_PERF_ON_AC = 100;
  #  CPU_MAX_PERF_ON_BAT = 30;
  #};
  #services.logind.lidSwitch = "suspend";

  powerManagement.resumeCommands = ''
    echo "This should show up in the journal after resuming."
  '';

}