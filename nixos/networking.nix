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
      listen_addresses = [ "127.0.0.2:53" ];
      odoh_servers = true;
      timeout = 10000;
      lb_strategy = "p2";
      log_file = "/tmp/dnscrypt-proxy.log";
      use_syslog = false; # will make syslog messy otherwise
      cache_min_ttl = 3600;
      cache_neg_min_ttl = 600;
      cache_neg_max_ttl = 900;
      forwarding_rules = "/etc/private/forwarding-rules.txt";
    };
  };

  environment.etc = {
    "private/forwarding-rules.txt".text = ''
      # SOURCE: https://github.com/DNSCrypt/dnscrypt-proxy/blob/master/dnscrypt-proxy/example-forwarding-rules.txt
      ##################################
      #        Forwarding rules        #
      ##################################

      ## This is used to route specific domain names to specific servers.
      ## The general format is:
      ## <domain> <server address>[:port] [, <server address>[:port]...]
      ## IPv6 addresses can be specified by enclosing the address in square brackets.

      ## In order to enable this feature, the "forwarding_rules" property needs to
      ## be set to this file name inside the main configuration file.

      ## Blocking IPv6 may prevent local devices from being discovered.
      ## If this happens, set `block_ipv6` to `false` in the main config file.

      ## Forward *.lan, *.local, *.home, *.home.arpa, *.internal and *.localdomain to 192.168.1.1
      # lan              192.168.1.1
      # local            192.168.1.1
      # home             192.168.1.1
      # home.arpa        192.168.1.1
      # internal         192.168.1.1
      # localdomain      192.168.1.1
      # 192.in-addr.arpa 192.168.1.1

      ## Forward *.localhost to 127.0.0.1
      localhost 127.0.0.1

      ## Forward queries for example.com and *.example.com to 9.9.9.9 and 8.8.8.8
      # example.com      9.9.9.9,8.8.8.8

      ## Forward queries to a resolver using IPv6
      # ipv6.example.com [2001:DB8::42]:53

      ## Forward queries for .onion names to a local Tor client
      ## Tor must be configured with the following in the torrc file:
      ## DNSPort 9053
      ## AutomapHostsOnResolve 1

      # onion            127.0.0.1:9053
    '';
  };

  # Zerotier
  services.zerotierone.enable = true;
  systemd.services.zerotierone.wantedBy = lib.mkForce [ ]; # disable autostart

  # Don't wait for network online
  systemd.services.network-addresses-eth0.enable = false;
  systemd.services.NetworkManager-wait-online.enable = false;
  systemd.network.wait-online.enable = false;

  # DNS Nameservers
  systemd.services.systemd-resolved.enable = true;
  services.resolved = {
    enable = true;
    llmnr = "true";
    dnssec = "false";
    domains = [ "~." ];
    #domains = [ "~." "lan" "nathanchung.dev" ];
    #fallbackDns = [ "9.9.9.9#dns.quad9.net" "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
    fallbackDns = [ ];
    extraConfig = ''
      ReadEtcHosts=yes
      DNSOverTLS=no
    '';
  };
  networking.nameservers = [ "127.0.0.2" "127.0.0.1" ];

  # use tcp bbr
  boot.kernel.sysctl = {
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr";
  };

  # Spoof MAC for wlan0
  # TODO: customize for laptops only
  systemd.services.macchanger =
    let
      change-mac = pkgs.writeShellScript "change-mac" ''
        card=$1
        tmp=$(mktemp)
        ${pkgs.macchanger}/bin/macchanger "$card" -s | grep -oP "[a-zA-Z0-9]{2}:[a-zA-Z0-9]{2}:[^ ]*" > "$tmp"
        mac1=$(cat "$tmp" | head -n 1)
        mac2=$(cat "$tmp" | tail -n 1)
        FLAGS="-r"
        if [ -f /etc/machine-id ]; then
            # Macbook M1?
            addr=$(cat /etc/machine-id | head -n 1 | md5sum | ${pkgs.gawk}/bin/awk '{print $1}' | cut -c 1-12 | sed -r 's/(..)(..)(..)(..)(..)(..)/bc:d0:74:\1:\2:\3/')
            FLAGS="-m $addr"
            echo "Updated macchanger flags: $FLAGS"
        fi
        # Change only if the MAC address is the same
        if [ "$mac1" = "$mac2" ]; then
          if [ "$(cat /sys/class/net/"$card"/operstate)" = "up" ]; then
            echo "Detected $card is up, bringing down."
            ${pkgs.iproute2}/bin/ip link set "$card" down
            echo "Changing MAC address for $card."
            ${pkgs.macchanger}/bin/macchanger $FLAGS "$card"
            echo "Bringing $card back up."
            ${pkgs.iproute2}/bin/ip link set "$card" up
          else
            echo "Changing MAC address for $card."
            ${pkgs.macchanger}/bin/macchanger $FLAGS "$card"
          fi
        fi
      '';
    in
    {
      enable = true;
      description = "macchanger on wlan0";
      wants = [ "network-pre.target" ];
      before = [ "network-pre.target" ];
      bindsTo = [ "sys-subsystem-net-devices-wlan0.device" ];
      after = [ "sys-subsystem-net-devices-wlan0.device" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${change-mac} wlan0";
      };
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
    dhcpcd.enable = false; # doesn't support ipv6
    dhcpcd.denyInterfaces = [ "br*" "macvtap0@*" ];
    dhcpcd.persistent = true;

    networkmanager = {
      enable = true;
      dhcp = "internal"; # or "dhcpcd"
      logLevel = "INFO"; # default: "WARN"
      #insertNameservers = [];
      #appendNameservers = [];
      # https://developer-old.gnome.org/NetworkManager/stable/NetworkManager.conf.html
      #dns = "default";
      dns = "systemd-resolved";
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
  #services.tor.enable = true;
  #services.tor.client.enable = true;
}
