{ config, pkgs, lib, ... }:

{
  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    theme = {
      name = "palenight";
      package = pkgs.palenight-theme;
    };

    cursorTheme = {
      name = "Numix-Cursor"; # capitaine-cursors
      package = pkgs.numix-cursor-theme;
    };

    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };

    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };

  dconf = {
    settings = {
      "org/gnome/desktop/wm/keybindings" = {
        screenshot = [ "<super><shift>s" ];
        screenshot-window = [ ];
        panel-run-dialog = [ "<super>space" ]; # run a command

        close = [ "<super><shift>c" "<alt>f4" ]; # close window
        open-application-menu = [ ];
        toggle-application-view = [ "<super>d" ];
        toggle-overview = [ ];

        # shift between overview states
        shift-overview-up = [ ];
        shift-overview-down = [ ];

        # move window one monitor to the left/right
        move-to-monitor-left = [ ];
        move-to-monitor-right = [ ];
        # move to monitor up: disable <super><shift>up
        move-to-monitor-up = [ ];
        # super + ctrl + direction keys, change workspaces, move focus between monitors
        # move to monitor down: disable <super><shift>down
        move-to-monitor-down = [ ];
        # super + direction keys, move window left and right monitors, or up and down workspaces

        switch-to-application-1 = [ ];
        switch-to-application-2 = [ ];
        switch-to-application-3 = [ ];
        switch-to-application-4 = [ ];
        switch-to-application-5 = [ ];
        switch-to-application-6 = [ ];
        switch-to-application-7 = [ ];
        switch-to-application-8 = [ ];
        switch-to-application-9 = [ ];

        toggle-message-try = [ "<super>m" ];

        toggle-maximized = [ "<super>f" ]; # toggle maximization state
        toggle-fullscreen = [ "<super><shift>f" ];
        minimize = [ "<super>comma" ]; # hide window: disable <super>h
        maximize = [ ]; # maximize window: disable <super>up
        unmaximize = [ ]; # restore window: disable <super>down

        # Move window N/E/S/W
        move-to-side-w = [ "<super><shift>h" ];
        move-to-side-e = [ "<super><shift>l" ];
        move-to-side-n = [ "<super><shift>k" ];
        move-to-side-s = [ "<super><shift>j" ];

        # Move to workspace X
        move-to-workspace-1 = [ "<super><shift>1" ];
        move-to-workspace-2 = [ "<super><shift>2" ];
        move-to-workspace-3 = [ "<super><shift>3" ];
        move-to-workspace-4 = [ "<super><shift>4" ];
        move-to-workspace-5 = [ "<super><shift>5" ];
        move-to-workspace-6 = [ "<super><shift>6" ];
        move-to-workspace-7 = [ "<super><shift>7" ];
        move-to-workspace-8 = [ "<super><shift>8" ];
        move-to-workspace-9 = [ "<super><shift>9" ];
        move-to-workspace-10 = [ "<super><shift>0" ];

        move-to-workspace-last = [ ];
        move-to-workspace-left = [ ];
        move-to-workspace-right = [ ];
        move-to-workspace-down = [ ];
        move-to-workspace-up = [ ];


        # Switch to workspace X
        switch-to-workspace-1 = [ "<super>1" ];
        switch-to-workspace-2 = [ "<super>2" ];
        switch-to-workspace-3 = [ "<super>3" ];
        switch-to-workspace-4 = [ "<super>4" ];
        switch-to-workspace-5 = [ "<super>5" ];
        switch-to-workspace-6 = [ "<super>6" ];
        switch-to-workspace-7 = [ "<super>7" ];
        switch-to-workspace-8 = [ "<super>8" ];
        switch-to-workspace-9 = [ "<super>9" ];
        switch-to-workspace-10 = [ "<super><alt>f" ];

        switch-to-workspace-left = [ ]; # switch to workspace left: disable <super>left
        switch-to-workspace-right = [ ]; # switch to workspace right: disable <super>right
        switch-to-workspace-down = [
          # move to workspace below
          "<primary><super>down"
          "<primary><super>j"
        ];
        switch-to-workspace-up = [
          # move to workspace above
          "<primary><super>up"
          "<primary><super>k"
        ];
        switch-to-workspace-last = [ ];
      };

      "org/gnome/desktop/wm/preferences" = {
        num-workspaces = 10;
      };

      "org/gnome/settings-daemon/plugins/media-keys" = {
        screensaver = [ "<super>escape" ]; # lock screen
        home = [ ]; # home folder:  "<super>f"
        email = [ ]; # launch email client: disable  "<super>e" 
        www = [ "<super>b" ]; # launch web browser
        terminal = [ "<super>enter" ]; # launch terminal
        rotate-video-lock-static = [ ]; # rotate video lock
      };
      "org/gnome/shell" = {
        disable-user-extensions = false;

        # `gnome-extensions list` for a list
        enabled-extensions = [
          "appindicatorsupport@rgcjonas.gmail.com"
          "pop-shell@system76.com"
          "user-theme@gnome-shell-eampax.github.com"
          "trayIconsReloaded@selfmade.pl"
          "Vitals@CoreCoding.com"
          "dash-to-panel@jderose9.github.com"
          "sound-output-device-chooser@kgshank.net"
          "space-bar@luchrioh"
        ];
      };
      # Dash to Panel
      "org/gnome/shell/extensions/dash-to-panel" = {
        panel-element-positions = "{\"0\":[{\"element\":\"showAppsButton\",\"visible\":false,\"position\":\"stackedTL\"},{\"element\":\"activitiesButton\",\"visible\":false,\"position\":\"stackedTL\"},{\"element\":\"leftBox\",\"visible\":true,\"position\":\"stackedTL\"},{\"element\":\"taskbar\",\"visible\":false,\"position\":\"stackedTL\"},{\"element\":\"dateMenu\",\"visible\":true,\"position\":\"centerMonitor\"},{\"element\":\"centerBox\",\"visible\":false,\"position\":\"stackedBR\"},{\"element\":\"rightBox\",\"visible\":true,\"position\":\"stackedBR\"},{\"element\":\"systemMenu\",\"visible\":true,\"position\":\"stackedBR\"},{\"element\":\"desktopButton\",\"visible\":true,\"position\":\"stackedBR\"}]}";
        panel-sizes = "{\"0\":43}";
        window-preview-title-position = "TOP";
      };

      "org/gnome/mutter/wayland/keybindings" = {
        # restore the keyboard shortcuts: disable <super>escape
        restore-shortcuts = [ ];
      };
      "org/gnome/mutter" = {
        workspaces-only-on-primary = false;
      };
    };
  };
}
