{ config, pkgs, lib, ... }:

{

  home.pointerCursor =
    let
      getFrom = url: hash: name: {
          gtk.enable = true;
          x11.enable = true;
          name = name;
          size = 48;
          package =
            pkgs.runCommand "moveUp" {} ''
              mkdir -p $out/share/icons
              ln -s ${pkgs.fetchzip {
                url = url;
                hash = hash;
              }} $out/share/icons/${name}
          '';
        };
    in
      getFrom
        "https://github.com/ful1e5/fuchsia-cursor/releases/download/v2.0.0/Fuchsia-Pop.tar.gz"
        "sha256-BvVE9qupMjw7JRqFUj1J0a4ys6kc9fOLBPx2bGaapTk="
        "Fuchsia-Pop";

  gtk = {
    enable = true;
    iconTheme = {
      #name = "Papirus-Dark";
      #package = pkgs.papirus-icon-theme;
      name = "Pop";
      package = pkgs.pop-icon-theme;
    };

    theme = {
      name = "palenight";
      package = pkgs.palenight-theme;
    };

    #cursorTheme = {
    #  name = "Numix-Cursor"; # capitaine-cursors
    #  package = pkgs.numix-cursor-theme;
    #};

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      gtk-cursor-blink = false;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      gtk-cursor-blink = false;
    };
  };
}
