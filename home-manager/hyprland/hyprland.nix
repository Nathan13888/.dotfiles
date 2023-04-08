{ lib, pkgs, ... }:
let
  waybar = "${lib.getExe pkgs.waybar}";
  volume = "~/scripts/volume.sh";
  backlight = "~/scripts/backlight.sh";
in
''
# See https://wiki.hyprland.org/Configuring/Monitors/
monitor=,preferred,auto,auto
monitor=,addreserved,50,0,0,0
#monitor=,highres,auto,2


# See https://wiki.hyprland.org/Configuring/Keywords/ for more

#exec-once = hyperpaper
exec-once = dunst


exec-once=wl-clipboard-history -t
exec=gnome-keyring-daemon -sd
exec-once=blueman-applet
exec-once=nm-applet


# Source a file (multi-file configs)
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
}

exec-once = fcitx5 -d
exec-once = eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
#export SSH_AUTH_SOCK
exec-once = numlockx
exec-once = nm-applet
# TODO: yofi/wofi
# TODO: wallpapers

general {
  gaps_in = 5
  gaps_out = 7
  border_size = 3
  col.active_border=0xfff5c2e7
  col.inactive_border=0xff45475a
  #col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
  #col.inactive_border = rgba(595959aa)
  apply_sens_to_raw=0 # whether to apply the sensitivity to raw input (e.g. used by games where you aim using your mouse)
  col.group_border=0xff89dceb
  col.group_border_active=0xfff9e2af
  layout = dwindle
}

dwindle {
  pseudotile = true
}

decoration {
  blur_new_optimizations = true
  rounding = 15
  blur = yes
  blur_size = 3
  blur_passes = 1
  blur_new_optimizations = on
  blur_xray=1

  inactive_opacity = 0.95
  drop_shadow = yes
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

device:epic mouse V1 {
  sensitivity = -0.5
}

# https://wiki.hyprland.org/Configuring/Window-Rules/

$mod = SUPER
bind = $mod, Return, exec, kitty # make this wtv $TERMINAL is
bind = $mod SHIFT, c, killactive, 
bind = $mod, space, togglefloating, 
bind = $mod, f, fullscreen, 
bind = $mod SHIFT, f, fakefullscreen, 
# TODO
bind = $mod, d, exec, bemenu-run -c -l 15 -W 0.3
# https://github.com/hyprwm/Hyprland/discussions/416
bind = $mod SHIFT, s, exec, wayshot -s "$(hyprctl clients -j | jq -r ".[] | select(.workspace.id == "$(hyprctl activewindow -j | jq -r '.workspace.id')\)""| jq -r ".at,.size" | jq -s "add" | jq '_nwise(4)' | jq -r '"\(.[0]),\(.[1]) \(.[2])x\(.[3])"'| slurp -f '%x %y %w %h')" --stdout | wl-copy

bind = $mod, comma, exec, dunstctl close,
bind = $mod SHIFT, comma, exec, dunstctl close-all
bind = $mod, grave, exec, dunstctl history-pop
bind = $mod, period, exec, dunstify "Dunst Count" "$(dunstctl count)" -u low
bind = $mod SHIFT, period, exec, dunstctl context
bind = $mod, slash, exec, dunstify "Dunst Paused" "$(dunstctl is-paused)" -u low
bind = $mod SHIFT, slash, exec, dunstctl set-paused toggle

bind=,XF86AudioRaiseVolume,exec,amixer -D pulse set Master 5%+
bind=,XF86AudioLowerVolume,exec,amixer -D pulse set Master 5%-
bind=,XF86AudioMute,exec,amixer -D pulse set Master +1 toggle
bind=,XF86MonBrightnessUp,exec,light -A 5
bind=,XF86MonBrightnessDown,exec,light -U 5

bind=,XF86AudioRaiseVolume, exec, ${volume} up
bind=,XF86AudioLowerVolume, exec, ${volume} dn
bind=,XF86AudioMute, exec, ${volume} togm
bind=,XF86AudioMicMute, exec, pactl set-source-mute @DEFAULT_SOURCE@ toggle
bind=,XF86MonBrightnessUp, exec, ${backlight} inc
bind=,XF86MonBrightnessDown, exec, ${backlight} dec

bind=,XF86AudioPlay,exec,playerctl play-pause
bind=,XF86AudioMedia,exec,playerctl play-pause
bind=,XF86AudioPause, exec,playerctl pause
bind=,XF86AudioNext, exec, playerctl next
bind=,XF86AudioPrev, exec, playerctl previous
bind=,XF86AudioStop,exec,playerctl stop


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
bind = $mod, 1, workspace, 1
bind = $mod, 2, workspace, 2
bind = $mod, 3, workspace, 3
bind = $mod, 4, workspace, 4
bind = $mod, 5, workspace, 5
bind = $mod, 6, workspace, 6
bind = $mod, 7, workspace, 7
bind = $mod, 8, workspace, 8
bind = $mod, 9, workspace, 9
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
}

bind=SUPERSHIFT,B,exec, killall -3 eww & sleep 1 && ~/scripts/launch_eww.sh
exec-once=eww daemon
exec-once=~/scripts/launch_eww.sh
exec=~/scripts/wallpaper.sh


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


windowrulev2 = opacity 0.97 0.97, class:org.telegram.desktop
windowrulev2 = workspace 1, class:firefox
windowrulev2 = workspace 4, class:org.telegram.desktop
layerrule = blur, eww
layerrule = blur, notifications

''
