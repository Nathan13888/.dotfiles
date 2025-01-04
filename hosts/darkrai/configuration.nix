{ config, pkgs, ... }:

{
  # environment.systemPath = [
  #   "/Applications/Nix Apps"
  # ];

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
  environment.systemPackages =
    with pkgs; [
      # applications
      #kitty
      #vesktop
      #code-cursor
      # utilities
      vim
      neovim
      zoxide
      fzf
      thefuck
      # remote
      ipmitool
      # processing
      ffmpeg
      # system
      btop
      smartmontools
      # networking
      wireguard-tools
      iperf
      dig
      # system (files)
      rclone
      mat2
      exiftool
      # dev tools
      podman docker-compose
      rustup
      bun fnm
      micromamba
      go
      gcc #valgrind
      nixpkgs-fmt
      wakatime-cli
      # iot
      proxmark3
    ];
  
  security.pam.enableSudoTouchIdAuth = true;

  system.defaults = {
    dock.autohide = false; # don't hide dock
    dock.mru-spaces = false; # don't sort spaces by recently used
    finder.AppleShowAllExtensions = true; # show file extensions
    finder.FXPreferredViewStyle = "clmv"; # use column view
    loginwindow.LoginwindowText = "nixcademy.com";
    screencapture.location = "~/Pictures/screenshots";
    screensaver.askForPasswordDelay = 10;
  };

  nix.extraOptions = ''
    extra-platforms = x86_64-darwin aarch64-darwin
  '';

  # Use custom location for configuration.nix.
  # environment.darwinConfig = "$HOME/.df/hosts/darkrai/configuration.nix";

  # Use zsh as default shell.
  programs.zsh.enable = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;
}