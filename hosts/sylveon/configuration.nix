{ lib, config, pkgs, ... }:

# @see https://daiderd.com/nix-darwin/manual/index.html
{
  # environment.systemPath = [
  #   "/Applications/Nix Apps"
  # ];

  environment.variables = {
    EDITOR = "vim";
    LANG = "en_US.UTF-8";
  };

  # Notable packages not installed with nix...
  # - Kitty
  # - Notesnook
  # - Zen browser
  # - Cursor
  # - Vesktop
  # - Slack
  # - Element Desktop
  # - Deluge
  # - Zerotier
  # - Ueli
  # - Claude/OpenAI
  # - ProtonVPN
  # - https://github.com/SpotX-Official/SpotX-Bash
  environment.systemPackages =
    with pkgs; [
      # desktop
      yabai
      skhd
      unnaturalscrollwheels
      keycastr
      # applications
      #kitty
      #vesktop
      #code-cursor
      rustmission
      mpv
      mysql84
      # utilities
      tmux
      vim
      neovim
      zoxide
      fzf
      pay-respects
      # remote
      ipmitool
      # processing
      ffmpeg
      yt-dlp
      # system
      btop
      smartmontools
      # networking
      wireguard-tools
      nmap
      iperf
      dig
      # system (files)
      rclone
      cryfs
      ncdu
      imagemagick
      pandoc
      graphviz
      pdftk mupdf
      mat2
      exiftool
      intermodal
      # sec
      binwalk
      john hashcat
      inetutils
      # dev tools
      gh git-lfs git-filter-repo
      podman docker-compose
      #git-graph
      gource
      dive skopeo syft grype trivy
      rustup
      bun fnm
      uv
      micromamba
      go
      dotnet-runtime
      #R rPackages.languageserver
      llvm lld
      gnuplot tokei
      cmake
      pkg-config
      nixpkgs-fmt
      wakatime-cli
      curl wget
      kubectl kubernetes-helm kubie
      kubectl-cnpg
      gh gh-dash
      # iot
      proxmark3
    ];
  services.jankyborders.enable = true;
  services.jankyborders.active_color = "gradient(top_right=0x9992B3F5,bottom_left=0x9992B3F5)";
  services.jankyborders.width = 5.0;

  # @see https://github.com/koekeishiya/yabai/wiki/Disabling-System-Integrity-Protection
  # (in recovery)
  # csrutil enable --without fs --without debug --without nvram
  # sudo nvram boot-args=-arm64e_preview_abi
  
  # Networking
  services.dnsmasq.enable = true;
  networking.hostName = "sylveon";
  networking.dns = [
    9.9.9.9
    1.1.1.1
  ];

  # System
  security.pam.services.sudo_local.touchIdAuth = true;

  system.primaryUser = "nathan";
  system.defaults = {
    dock.autohide = false; # don't hide dock
    dock.mru-spaces = false; # don't sort spaces by recently used
    finder.AppleShowAllExtensions = true; # show file extensions
    finder.FXPreferredViewStyle = "clmv"; # use column view
    loginwindow.LoginwindowText = "luv u lindor &lt;3";
    screencapture.location = "~/Pictures/screenshots";
    screensaver.askForPasswordDelay = 10;
  };

  nix.enable = false;
  nix.extraOptions = ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';

  # Use custom location for configuration.nix.
  # environment.darwinConfig = "$HOME/.df/hosts/darkrai/configuration.nix";

  # Use zsh as default shell.
  programs.zsh.enable = true;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;
}
