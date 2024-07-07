{ lib, pkgs, ... }:
let
  volume = "~/scripts/volume.sh";
  backlight = "~/scripts/backlight.sh";
  grimblast = "~/scripts/grimblast";
  scripts = "~/scripts";

  # TODO: fix
  big_mon = "DP-1";
  smol_mon = "eDP-1";

  #TERMINAL = "kitty";
  TERMINAL = "rio";
in
''
  # TODO: make device specific settings
  # See https://wiki.hyprland.org/Configuring/Monitors/
  # See https://wiki.hyprland.org/Configuring/Keywords/ for more

  #monitor=${big_mon},5120x1440@60,0x0,1
  #monitor=${big_mon},5120x1440@60,0x0,auto,bitdepth,10
  #monitor=${big_mon},5120x1440@120,auto,auto,bitdepth,10
  #monitor=${smol_mon},preferred,1600x1440,auto # lennar
  #monitor=${smol_mon},preferred,640x1440,auto # jirachi
  #monitor=,preferred,auto,auto,bitdepth,10
  monitor=,preferred,auto,auto
  monitor=,addreserved,64,10,10,10

  exec-once=${scripts}/handle_monitor_connect.sh # TODO


  exec-once = dunst
  exec-once = aw-server # Activity Watch Server

  # Auto Lock. Lid Switch.
  exec-once = xidlehook --detect-sleep --not-when-audio --not-when-fullscreen --timer 300 \'xset dpms force standby\' \'\' --timer 300 \'${scripts}/lock.sh\' \'\' --timer 300 \'systemctl suspend\' \'\'
  bindl=,switch:Lid Switch, exec, ${scripts}/lock.sh

  exec-once=wl-clipboard-history -t
  exec-once=batsignal -w 25 -c 7 -d 5 -f 95 -D "touch /tmp/reached_danger_level"
  exec-once=export KP_ROOT="$HOME/KeepassXC" && cat "$KP_ROOT/pass.txt" | keepassxc --keyfile "$KP_ROOT/unlock.key" --pw-stdin "$KP_ROOT/default.kdbx"

  # TODO: https://wiki.hyprland.org/Useful-Utilities/Clipboard-Managers/


  # Source a file (multi-file configs)
  # TODO: implement
  # source = ~/.config/hypr/myColors.conf

  # sets xwayland scale
  exec-once=xprop -root -f _XWAYLAND_GLOBAL_OUTPUT_SCALE 32c -set _XWAYLAND_GLOBAL_OUTPUT_SCALE 1

  # Some default env vars.
  env = XCURSOR_SIZE,24
  #env = GDK_SCALE,2
  #env = XCURSOR_SIZE,48


  # For all categories, see https://wiki.hyprland.org/Configuring/Variables/
  input {
      kb_layout = us
      kb_variant =
      kb_model =
      kb_options =
      kb_rules =

      follow_mouse = 1

      touchpad {
          natural_scroll = yes
          disable_while_typing=true
          scroll_factor=2
      }

      sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
  }

  misc {
    disable_hyprland_logo=true
    animate_mouse_windowdragging=true # this fixes the laggy window movement (source: https://github.com/hyprwm/Hyprland/issues/1753)
    animate_manual_resizes=false # fixes slow resizes
    vfr = true # variable frame rate, for laptop power savings
  }

  exec-once = eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
  #export SSH_AUTH_SOCK
  exec-once = numlockx

  general {
    gaps_in = 5
    gaps_out = 7
    border_size = 3
    col.active_border=0xfff5c2e7
    col.inactive_border=0xff45475a
    #col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
    #col.inactive_border = rgba(595959aa)
    apply_sens_to_raw=0 # whether to apply the sensitivity to raw input (e.g. used by games where you aim using your mouse)
    layout = dwindle
  }

  dwindle {
    pseudotile = true
    # TODO:
    #col.group_border=0xff89dceb
    #col.group_border_active=0xfff9e2af
    #preserve_split = true # TODO: re-enable and have vertical split bindings
    #no_gaps_when_only = true
  }

  decoration {
    blur {
      # TODO: no for laptop
      #enabled = yes
      enabled = no
    }

    rounding = 15

    inactive_opacity = 0.95
    drop_shadow = yes # TODO: no for laptop
    shadow_range = 4
    shadow_render_power = 3
    col.shadow= 0x33000000
    col.shadow_inactive=0x22000000
    #col.shadow = rgba(1a1a1aee)
  }


  # https://wiki.hyprland.org/Configuring/Animations/
  animations {
    enabled = yes
    bezier=overshot,0.13,0.99,0.29,1.1
    animation=windows,1,4,overshot,slide
    animation=border,1,10,default
    animation=fade,1,10,default
    #animation=workspaces,1,6,overshot,slidevert
  }

  # https://wiki.hyprland.org/Configuring/Dwindle-Layout/
  dwindle {
    pseudotile = yes
    preserve_split = yes
    no_gaps_when_only = true
    force_split=0
  }

  # https://wiki.hyprland.org/Configuring/Master-Layout/ 
  master {
    new_is_master = true
  }

  # https://wiki.hyprland.org/Configuring/Master-Layout/ 
  gestures {
    workspace_swipe = on
    workspace_swipe_fingers=3
  }

  # https://wiki.hyprland.org/Configuring/Window-Rules/

  $mod = SUPER
  bind = $mod, Return, exec, ${TERMINAL}
  bind = $mod SHIFT, c, killactive, 
  bind = $mod, space, togglefloating, 
  bind = $mod, f, fullscreen, 
  bind = $mod SHIFT, f, fakefullscreen, 
  bind = $mod, p, pin,
  bind = $mod SHIFT, m, exec, hyprctl dispatch centerwindow active,
  bindr = $mod, TAB, exec, hyprctl dispatch cyclenext,
  bind = $mod SHIFT, TAB, exec, hyprctl dispatch cyclenext prev,

  bind = $mod SHIFT, x, exec, hyprctl dispatch swapactiveworkspaces ${big_mon} ${smol_mon}
  bind = $mod ALT, x, exec, hyprctl dispatch movecurrentworkspacetomonitor ${big_mon}
  # TODO: make binding for, dispatching all workspaces to main monitor, except for the last workspace
  

  # TODO
  bind = $mod, d, exec, bemenu-run -c -l 15 -W 0.3
  # https://github.com/hyprwm/Hyprland/discussions/416
  bind = $mod SHIFT, s, exec, ${grimblast} --notify copy area

  bind = $mod, comma, exec, dunstctl close,
  bind = $mod SHIFT, comma, exec, dunstctl close-all
  bind = $mod, grave, exec, dunstctl history-pop
  bind = $mod, period, exec, dunstify "Dunst Count" "$(dunstctl count)" -u low
  bind = $mod SHIFT, period, exec, dunstctl context
  bind = $mod, slash, exec, dunstify "Dunst Paused" "$(dunstctl is-paused)" -u low
  bind = $mod SHIFT, slash, exec, dunstctl set-paused toggle

  bind=,XF86MonBrightnessUp,exec,light -A 5
  bind=,XF86MonBrightnessDown,exec,light -U 5

  binde=,XF86AudioRaiseVolume, exec, ${volume} up
  binde=,XF86AudioLowerVolume, exec, ${volume} dn
  binde=,XF86AudioMute, exec, ${volume} togm
  binde=,XF86AudioMicMute, exec, ${volume} togmic
  binde=,XF86MonBrightnessUp, exec, ${backlight} inc
  binde=,XF86MonBrightnessDown, exec, ${backlight} dec

  binde=,XF86AudioPlay,exec,playerctl play-pause
  binde=,XF86AudioMedia,exec,playerctl play-pause
  binde=,XF86AudioPause, exec,playerctl pause
  binde=,XF86AudioNext, exec, playerctl next
  binde=,XF86AudioPrev, exec, playerctl previous
  binde=,XF86AudioStop,exec,playerctl stop


  #bind = $mod SHIFT, r, exec, screen-recorder-toggle
  bind = $mod SHIFT, e, exec, power-menu
  bind = $mod, P, pseudo,
  bind = $mod, e, togglesplit
  bind = $mod, w, togglegroup
  bind = $mod, h, movefocus, l
  bind = $mod, l, movefocus, r
  bind = $mod, j, movefocus, d
  bind = $mod, k, movefocus, u
  bind = $mod SHIFT, h, movewindow, l
  bind = $mod SHIFT, l, movewindow, r
  bind = $mod SHIFT, j, movewindow, d
  bind = $mod SHIFT, k, movewindow, u
  
  # Switching Workspaces
  bind = $mod, 1, workspace, 1
  bind = $mod, 2, workspace, 2
  bind = $mod, 3, workspace, 3
  bind = $mod, 4, workspace, 4
  bind = $mod, 5, workspace, 5
  bind = $mod, 6, workspace, 6
  bind = $mod, 7, workspace, 7
  bind = $mod, 8, workspace, 8
  bind = $mod, 9, workspace, 9
  #bind = $mod ALT, 1, workspace, 1
  #bind = $mod ALT, 2, workspace, 2
  #bind = $mod ALT, 3, workspace, 3
  #bind = $mod ALT, 4, workspace, 4
  #bind = $mod ALT, 5, workspace, 5
  #bind = $mod ALT, 6, workspace, 6
  #bind = $mod ALT, 7, workspace, 7
  #bind = $mod ALT, 8, workspace, 8
  #bind = $mod ALT, 9, workspace, 9
  #bind = $mod, 1, exec, ${scripts}/workspace 1
  #bind = $mod, 2, exec, ${scripts}/workspace 2
  #bind = $mod, 3, exec, ${scripts}/workspace 3
  #bind = $mod, 4, exec, ${scripts}/workspace 4
  #bind = $mod, 5, exec, ${scripts}/workspace 5
  #bind = $mod, 6, exec, ${scripts}/workspace 6
  #bind = $mod, 7, exec, ${scripts}/workspace 7
  #bind = $mod, 8, exec, ${scripts}/workspace 8
  #bind = $mod, 9, exec, ${scripts}/workspace 9
  bind = $mod ALT, F, workspace, 10

  bind = $mod CTRL, 1, movetoworkspace, 1
  bind = $mod CTRL, 2, movetoworkspace, 2
  bind = $mod CTRL, 3, movetoworkspace, 3
  bind = $mod CTRL, 4, movetoworkspace, 4
  bind = $mod CTRL, 5, movetoworkspace, 5
  bind = $mod CTRL, 6, movetoworkspace, 6
  bind = $mod CTRL, 7, movetoworkspace, 7
  bind = $mod CTRL, 8, movetoworkspace, 8
  bind = $mod CTRL, 9, movetoworkspace, 9
  bind = $mod CTRL, 0, movetoworkspace, 10
  bind = $mod SHIFT, 1, movetoworkspacesilent, 1
  bind = $mod SHIFT, 2, movetoworkspacesilent, 2
  bind = $mod SHIFT, 3, movetoworkspacesilent, 3
  bind = $mod SHIFT, 4, movetoworkspacesilent, 4
  bind = $mod SHIFT, 5, movetoworkspacesilent, 5
  bind = $mod SHIFT, 6, movetoworkspacesilent, 6
  bind = $mod SHIFT, 7, movetoworkspacesilent, 7
  bind = $mod SHIFT, 8, movetoworkspacesilent, 8
  bind = $mod SHIFT, 9, movetoworkspacesilent, 9
  bind = $mod SHIFT, 0, movetoworkspace, 10

  bind = $mod, mouse_down, workspace, e+1
  bind = $mod, mouse_up, workspace, e-1
  bindm = $mod, mouse:272, movewindow
  bindm = $mod, mouse:273, resizewindow

  binde = $mod CTRL, H, resizeactive, -15 0
  binde = $mod CTRL, L, resizeactive, 15 0
  binde = $mod CTRL, K, resizeactive, 0 -15
  binde = $mod CTRL, J, resizeactive, 0 15

  # TODO

  bind=SUPERSHIFT,B,exec, killall -3 eww & sleep 1 && ${scripts}/launch_eww.sh
  exec-once=eww daemon
  exec-once=${scripts}/launch_eww.sh
  exec=${scripts}/wallpaper.sh


  # example window rules
  # for windows named/classed as abc and xyz
  #windowrule=move 69 420,abc
  windowrule=move center,title:^(fly_is_kitty)$
  windowrule=size 800 500,title:^(fly_is_kitty)$
  windowrule=animation slide,title:^(all_is_kitty)$
  windowrule=float,title:^(all_is_kitty)$
  #windowrule=tile,xy
  windowrule=tile,title:^(kitty)$
  windowrule=float,title:^(fly_is_kitty)$
  windowrule=float,title:^(clock_is_kitty)$
  windowrule=size 418 234,title:^(clock_is_kitty)$
  #windowrule=pseudo,abc
  #windowrule=monitor 0,xyz

  # custom
  windowrule=float,^(nm-connection-editor)$
  windowrule=float,zenity


  # Firefox Sharing Indicator
  windowrulev2 = float,title:^(Firefox — Sharing Indicator)$
  #windowrulev2 = nofullscreenrequest,title:^(Firefox — Sharing Indicator)$
  windowrulev2 = move 0 0,title:^(Firefox — Sharing Indicator)$
  windowrulev2 = maxsize 55 31,title:^(Firefox — Sharing Indicator)$

  # TODO
  #windowrulev2 = opacity 0.97 0.97, class:org.telegram.desktop
  #windowrulev2 = workspace 1, class:firefox
  #windowrulev2 = workspace 4, class:org.telegram.desktop
  layerrule = blur, eww
  #layerrule = blur, notifications

''
