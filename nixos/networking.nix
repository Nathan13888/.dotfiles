{ config, lib, pkgs, options, ... }:

{
  # DNSCrypt Proxy
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
      use_syslog = false; # will make syslog messy otherwise
      cache_min_ttl = 3600;
      cache_neg_min_ttl = 600;
      cache_neg_max_ttl = 900;
    };
  };
  services.zerotierone.enable = true;

  systemd.services.network-addresses-eth0.enable = false;
  systemd.services.NetworkManager-wait-online.enable = false;
  systemd.network.wait-online.enable = false;
  systemd.services.systemd-resolved.enable = true;
  services.resolved = {
    enable = true;
    llmnr = "true";
    dnssec = "false";
    domains = [ "~." "lan" "nathanchung.dev" ];
    #fallbackDns = [ "9.9.9.9#dns.quad9.net" "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
    fallbackDns = [ ];
    extraConfig = ''
      ReadEtcHosts=yes
      DNSOverTLS=no
    '';
  };
  networking.nameservers = [ "127.0.0.1" ];

  # use tcp bbr
  boot.kernel.sysctl = {
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr";
  };

  networking = {
    nftables.enable = true;
    nat = {
      enable = true;
      enableIPv6 = true;
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
        #59100 # AudioRelay (TCP for messaging) 
      ];
      allowedUDPPorts = [
        #{ from = 29999; to = 29999; }
        #{ from = 5201; to = 5210; } # iperf3
        53 # Wireguard DNS
        5201
        9993 # Zerotier
        51820 # Wireguard listening
        #59100 # AudioRelay (UDP for audio transport)
        #59200 # AudioRelay (UDP for server discovery)
      ];
      enable = true;
      allowPing = false;
    };

    timeServers = options.networking.timeServers.default ++ [ "0.north-america.pool.ntp.org" "1.north-america.pool.ntp.org" "2.north-america.pool.ntp.org" "3.north-america.pool.ntp.org" ];

    #resolvconf.enable = true;
    #resolvconf.extraConfig = [];
    #resolvconf.extraOptions = [ "ndots:1" "rotate" ];

    bridges = {
      "br0" = {
        interfaces = [ "eth0" ];
        # ipv4.addresses
      };
    };

    usePredictableInterfaceNames = true;
    enableIPv6 = true;

    ## DHCP
    interfaces.eth0.useDHCP = lib.mkDefault true;
    interfaces.wlan0.useDHCP = lib.mkDefault true;
    useDHCP = lib.mkDefault false;
    dhcpcd.enable = true;
    dhcpcd.denyInterfaces = [ "br*" "macvtap0@*" ];
    dhcpcd.persistent = true;

    networkmanager = {
      enable = true;
      #dhcp = "internal"; # or "dhcpcd"
      dhcp = "dhcpcd";
      logLevel = "INFO"; # default: "WARN"
      #insertNameservers = [];
      #appendNameservers = [];
      # https://developer-old.gnome.org/NetworkManager/stable/NetworkManager.conf.html
      #dns = "default";
      # rc-manager is automatically set to resolvconf
    };

    networkmanager.wifi = {
      backend = "iwd";
      powersave = false; # disable wifi power saving
      scanRandMacAddress = true;
    };

    # TODO: move to individual hosts?
    wireless.iwd.enable = true;
  };

  # RFkill
  system.activationScripts = {
    rfkillUnblockWlan = {
      text = ''
        rfkill unblock wlan
      '';
      deps = [ ];
    };
  };

  # Tor
  # TODO:
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
