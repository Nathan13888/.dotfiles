{ config, lib, pkgs, options, ... }:


{

  networking.extraHosts =
    ''
      #192.168.10.226 st.wocrekcatta.ml
      192.168.10.220 *.crux.nathanchung.dev omada-sdn.nathanchung.dev
    '';

  services.dnscrypt-proxy2 = {
    enable = true;
    settings = {
      ipv6_servers = true;
      require_dnssec = true;
      sources.public-resolvers = {
        urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
          "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
        ];
        cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
      };
      server_names = [ "moulticast-ca-ipv4" "opennic-luggs" "opennic-luggs2" "quad9-doh-ip4-port443-nofilter-pri" "odoh-cloudflare" "cloudflare" "nextdns" "mullvad-doh" ];
      listen_addresses = [ "127.0.0.1:53" "[::1]:53" ];
      odoh_servers = true;
      timeout = 10000;
      lb_strategy = "p2";
      log_file = "/tmp/dnscrypt-proxy.log";
      use_syslog = false;
      cache_min_ttl = 3600;
      cache_neg_min_ttl = 600;
      cache_neg_max_ttl = 900;
    };
  };
  services.chrony.enable = true;
  services.zerotierone.enable = true;

  systemd.services.NetworkManager-wait-online.enable = false;
  systemd.network.wait-online.enable = false;
  systemd.services.systemd-resolved.stopIfChanged = false;

  networking = {
    nftables.enable = true;
    nat = {
      enable = true;
      enableIPv6 = false;
      externalInterface = "eth0";
      internalInterfaces = [ "wg0" ];
    };

    firewall = {
      allowedTCPPorts = [
        #{ from = 29999; to = 29999; }
        4713
        6000 # tor
        22 # SSH
        53 # Wireguard DNS
        #{ from = 5201; to = 5210; } # iperf3
        8888 # Public HTTP
        9993 # Zerotier
        59100 # AudioRelay (TCP for messaging) 
      ];
      allowedUDPPorts = [
        #{ from = 29999; to = 29999; }
        #{ from = 5201; to = 5210; } # iperf3
        53 # Wireguard DNS
        5201
        9993 # Zerotier
        51820 # Wireguard listening
        59100 # AudioRelay (UDP for audio transport)
        59200 # AudioRelay (UDP for server discovery)
      ];
      enable = true;
      allowPing = false;
    };

    timeServers = options.networking.timeServers.default ++ [ "0.north-america.pool.ntp.org" "1.north-america.pool.ntp.org" "2.north-america.pool.ntp.org" "3.north-america.pool.ntp.org" ];
    nameservers = [ "127.0.0.1" "::1" ];
    resolvconf.enable = true;
    
    usePredictableInterfaceNames = true;
    enableIPv6 = true;

    ## DHCP
    interfaces.eth0.useDHCP = true;
    interfaces.wlan0.useDHCP = true;
    useDHCP = lib.mkDefault true;
    dhcpcd.enable = false;
    #dhcpcd.persistent = true;

    networkmanager = {
      enable = true;
      #dhcp = "dhcpcd";
      dhcp = "internal";
      dns = "none";
      wifi.backend = "iwd";
    };

    # TODO: move to individual hosts?
    wireless.iwd.enable = true;
  };

  system.activationScripts = {
    rfkillUnblockWlan = {
      text = ''
      rfkill unblock wlan
      '';
      deps = [];
    };
  };

  # Tor
  #services.tor.enable = true;
  #services.tor.client.enable = true;

  #networking.nat = {
  #  enable = true;
  #  internalInterfaces = ["ve-browser"];
  #  externalInterface = "eth0";
  #};
  #containers.browser = {
  #  autoStart = false;
  #  privateNetwork = true;
  #  hostAddress = "192.168.7.10";
  #  localAddress = "192.168.7.11";
  #  config = {config, pkgs, ... }: {
  #    services.openssh = {
  #      enable = true;
  #      forwardX11 = true;
  #    };

  #    users.extraUsers.browser = {
  #      isNormalUser = true;
  #      home = "/home/browser";
  #      openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO7QUPxTZc3H+lDQ5WFufpJIPopoMI1v+Rj8uWw4hyvi attackercow@ARG0N" ];
  #      extraGroups = ["audio" "video"];
  #    };
  #  };
  #};
}
