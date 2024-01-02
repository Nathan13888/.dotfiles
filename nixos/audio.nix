{ config, pkgs, ... }:

{
  ### AUDIO

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  environment.etc =
    let
      json = pkgs.formats.json { };
    in
    {
      "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
        bluez_monitor.properties = {
          ["bluez5.enable-sbc-xq"] = true,
          ["bluez5.enable-msbc"] = true,
          ["bluez5.enable-hw-volume"] = true,
          ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
        }
      '';
      "wireplumber/main.lua.d/90-suspend-timeout.lua".text = ''
        	apply_properties = {
                  ["session.suspend-timeout-seconds"] = 0;
                };
      '';
      "pipewire/pipewire.d/92-low-latency.conf".source = json.generate "92-low-latency.conf" {
        context.properties = {
          default.clock.rate = 48000;
          default.clock.quantum = 32;
          default.clock.min-quantum = 32;
          default.clock.max-quantum = 32;
        };
      };
    };


  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = false;
    wireplumber.enable = true;
    # TODO: realtime?? /etc/pipewire/pipewire.conf.d/
  };
}


