{ config, pkgs, ... }:

{
  hardware.opengl = {
    enable = true;
    driSupport = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };

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
    media-session.enable = false;
    wireplumber.enable = true;

    config.pipewire = {
      "context.properties" = {
        ##"link.max-buffers" = 16;
        "log.level" = 2; # https://docs.pipewire.org/page_daemon.html
        ##"default.clock.rate" = 48000;
        ##"default.clock.quantum" = 1024;
        #"default.clock.quantum" = 32;
        ##"default.clock.min-quantum" = 32;
        ##"default.clock.max-quantum" = 8192;
        #"default.clock.max-quantum" = 64;
        "core.daemon" = true;
        "core.name" = "pipewire-0";
      };
      #"context.modules" = [
      #  {
      #    name = "libpipewire-module-rtkit";
      #    args = {
      #      "nice.level" = -15;
      #      "rt.prio" = 88;
      #      "rt.time.soft" = 200000;
      #      "rt.time.hard" = 200000;
      #    };
      #    flags = [ "ifexists" "nofail" ];
      #  }
      #  { name = "libpipewire-module-protocol-native"; }
      #  { name = "libpipewire-module-profiler"; }
      #  { name = "libpipewire-module-metadata"; }
      #  { name = "libpipewire-module-spa-device-factory"; }
      #  { name = "libpipewire-module-spa-node-factory"; }
      #  { name = "libpipewire-module-client-node"; }
      #  { name = "libpipewire-module-client-device"; }
      #  {
      #    name = "libpipewire-module-portal";
      #    flags = [ "ifexists" "nofail" ];
      #  }
      #  {
      #    name = "libpipewire-module-access";
      #    args = {};
      #  }
      #  { name = "libpipewire-module-adapter"; }
      #  { name = "libpipewire-module-link-factory"; }
      #  { name = "libpipewire-module-session-manager"; }
      #];
    };
    config.pipewire-pulse = {
      "context.properties" = {
        "log.level" = 2;
      };
      #"context.modules" = [
      #  {
      #    name = "libpipewire-module-rtkit";
      #    args = {
      #      "nice.level" = -15;
      #      "rt.prio" = 88;
      #      "rt.time.soft" = 200000;
      #      "rt.time.hard" = 200000;
      #    };
      #    flags = [ "ifexists" "nofail" ];
      #  }
      #  { name = "libpipewire-module-protocol-native"; }
      #  { name = "libpipewire-module-client-node"; }
      #  { name = "libpipewire-module-adapter"; }
      #  { name = "libpipewire-module-metadata"; }
      #  {
      #    name = "libpipewire-module-protocol-pulse";
      #    args = {
      #      "pulse.min.req" = "32/48000";
      #      "pulse.default.req" = "32/48000";
      #      "pulse.max.req" = "32/48000";
      #      "pulse.min.quantum" = "32/48000";
      #      "pulse.max.quantum" = "32/48000";
      #      "server.address" = [ "unix:native" ];
      #    };
      #  }
      #];
      "stream.properties" = {
        "node.latency" = "32/48000";
        "resample.quality" = 1;
      };
    };
  };
}


