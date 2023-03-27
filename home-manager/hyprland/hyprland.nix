{ lib, pkgs, ... }:
let
  swww = "${lib.getExe pkgs.swww}";
  swww-daemon = "${pkgs.swww}/bin/swww-daemon";
in
''
# See https://wiki.hyprland.org/Configuring/Monitors/
monitor=,preferred,auto,auto

# See https://wiki.hyprland.org/Configuring/Keywords/ for more

# Execute your favorite apps at launch
# exec-once = waybar & hyprpaper & firefox


# Source a file (multi-file configs)
# source = ~/.config/hypr/myColors.conf

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
        natural_scroll = no
    }

    sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
}

exec-once = fcitx5 -d
#exec-once = ${swww-daemon} & sleep 3; ${swww} img -o DP-1 /home//Pictures/Wallpapers/rurudo.jpg && ${swww} img -o HDMI-A-1 /home/Pictures/Wallpapers/cloud.gif
exec-once = eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
#export SSH_AUTH_SOCK

exec-once = dunst
exec-once = numlockx
#exec-once = flameshot
exec-once = nm-applet
# TODO: warbar
# TODO: yofi/wofi
# TODO: wallpapers
exec-once = hyprpaper
 
input {
}

general {
  gaps_in = 2
  gaps_out = 2
  border_size = 1
  col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
  col.inactive_border = rgba(595959aa)
  layout = dwindle
}

decoration {
  # rounding = 10
  blur = yes
  blur_size = 3
  blur_passes = 1
  blur_new_optimizations = on
  inactive_opacity = 0.95
  drop_shadow = yes
  shadow_range = 4
  shadow_render_power = 3
  col.shadow = rgba(1a1a1aee)
}


# https://wiki.hyprland.org/Configuring/Animations/
animations {
  enabled = yes
  bezier = myBezier, 0.05, 0.9, 0.1, 1.05
  animation = windows, 1, 7, myBezier
  animation = windowsOut, 1, 7, default, popin 80%
  animation = border, 1, 10, default
  animation = fade, 1, 7, default
  animation = workspaces, 1, 6, default
}

# https://wiki.hyprland.org/Configuring/Dwindle-Layout/
dwindle {
  pseudotile = yes
  preserve_split = yes
  no_gaps_when_only = true
}

# https://wiki.hyprland.org/Configuring/Master-Layout/ 
master {
  new_is_master = true
}

# https://wiki.hyprland.org/Configuring/Master-Layout/ 
gestures {
  workspace_swipe = on
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
#bind = $mod SHIFT, s, exec, ${pkgs.sway-contrib.grimshot}/bin/grimshot copy area
#bind = $mod SHIFT, u, exec, ${pkgs.pamixer}/bin/pamixer -i 10
#bind = $mod SHIFT, d, exec, ${pkgs.pamixer}/bin/pamixer -d 10
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
bind = $mod, 0, workspace, 10
bind = $mod SHIFT, 1, movetoworkspace, 1
bind = $mod SHIFT, 2, movetoworkspace, 2
bind = $mod SHIFT, 3, movetoworkspace, 3
bind = $mod SHIFT, 4, movetoworkspace, 4
bind = $mod SHIFT, 5, movetoworkspace, 5
bind = $mod SHIFT, 6, movetoworkspace, 6
bind = $mod SHIFT, 7, movetoworkspace, 7
bind = $mod SHIFT, 8, movetoworkspace, 8
bind = $mod SHIFT, 9, movetoworkspace, 9
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
windowrulev2 = opacity 0.97 0.97, class:org.telegram.desktop
windowrulev2 = workspace 1, class:firefox
windowrulev2 = workspace 4, class:org.telegram.desktop
layerrule = blur, waybar
layerrule = blur, notifications

''
