{ config, pkgs, ... }:

{
  services.chrony.enable = true;
  time.timeZone = "America/Toronto";
  time.hardwareClockInLocalTime = false;

  i18n.defaultLocale = "en_CA.UTF-8";

  console = {
    font = "${pkgs.terminus_font}/share/consolefonts/ter-v32n.psf.gz";
    earlySetup = true;
    keyMap = "us";
  };

}
