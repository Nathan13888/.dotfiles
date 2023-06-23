{ config, pkgs, ... }:


{
  services.earlyoom.enable = true;
  #services.logind.lidSwitch = "suspend";

  powerManagement.resumeCommands = ''
    echo "This should show up in the journal after resuming."
  '';

}
