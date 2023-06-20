# INFO: Hyprland's configuration

{
  config,
  pkgs,
  ...
}: let
  inherit (config.colorscheme) colors;
in {
  wayland.windowManager.hyprland = {
    # TODO: Per-host monitors
    extraConfig = ''
      # --[[ Monitors ]]--
      monitor = eDP-1, 1920x1080@60, auto, 1
      workspace = eDP-1, 1

      # --[[ Autostart ]]--
      exec-once = wlsunset -t 5000 -T 7000 -g 0.7
      exec-once = eww daemon && eww open statusbar
      exec      = swww init; sleep 0.5 && swww clear ${colors.base01}

      # --[[ kill window | exit & reload hyprland | lock screen ]]--
      bind =      SUPER SHIFT, Q, killactive,
      bind = CTRL SUPER SHIFT, E, exec, kill "$(pidof wlsunset)"; hyprctl dispatch exit yes
      bind =      SUPER SHIFT, R, exec, hyprctl reload && eww reload

      # --[[ shift focus ]]--
      bind = SUPER, H, movefocus, l
      bind = SUPER, J, movefocus, d
      bind = SUPER, K, movefocus, u
      bind = SUPER, L, movefocus, r
      # bind = SUPER, J, layoutmsg, cyclenext
      # bind = SUPER, K, layoutmsg, cycleprev

      # --[[ move windows within layout ]]--
      bind = SUPER SHIFT, H, movewindow, l
      bind = SUPER SHIFT, J, movewindow, d
      bind = SUPER SHIFT, K, movewindow, u
      bind = SUPER SHIFT, L, movewindow, r
      # bind = SUPER SHIFT, J, layoutmsg, swapnext
      # bind = SUPER SHIFT, K, layoutmsg, swapprev

      # --[[ float | fullscreen ]]--
      bind = SUPER, V, togglefloating,
      bind = SUPER, F, fullscreen,

      # --[[ main apps ]]--
      bind = SUPER, RETURN, exec, wezterm start --always-new-process
      bind = SUPER, P,      exec, wezterm start --always-new-process btm --battery

      # --[[ switch to ws ]]--
      bind = SUPER, 1, workspace, 1
      bind = SUPER, 2, workspace, 2
      bind = SUPER, 3, workspace, 3
      bind = SUPER, 4, workspace, 4
      bind = SUPER, 5, workspace, 5
      bind = SUPER, 6, workspace, 6
      bind = SUPER, 7, workspace, 7
      bind = SUPER, 8, workspace, 8
      bind = SUPER, 9, workspace, 9
      bind = SUPER, 0, workspace, 10

      # --[[ move focused window to ws ]]--
      bind = SUPER SHIFT, 1, movetoworkspace, 1
      bind = SUPER SHIFT, 2, movetoworkspace, 2
      bind = SUPER SHIFT, 3, movetoworkspace, 3
      bind = SUPER SHIFT, 4, movetoworkspace, 4
      bind = SUPER SHIFT, 5, movetoworkspace, 5
      bind = SUPER SHIFT, 6, movetoworkspace, 6
      bind = SUPER SHIFT, 7, movetoworkspace, 7
      bind = SUPER SHIFT, 8, movetoworkspace, 8
      bind = SUPER SHIFT, 9, movetoworkspace, 9
      bind = SUPER SHIFT, 0, movetoworkspace, 10

      # --[[ brightness ]]--
      bind = , XF86MonBrightnessUp,   exec, brillo -A 10 -u 100000
      bind = , XF86MonBrightnessDown, exec, brillo -U 10 -u 100000

      # --[[ move & resize floating windows ]]--
      bindm = SUPER, mouse:272, movewindow
      bindm = SUPER, mouse:273, resizewindow
      input {
        # --[[ mouse ]]--
        follow_mouse = 1
        sensitivity = -0.8
        touchpad {
          natural_scroll = no
        }

        # --[[ keyboard ]]--
        kb_layout = us, ru
        kb_options = grp:win_space_toggle
      }

      # --[[ per-device configuration ]]--
      device:Cooler Master Technology Inc. Gaming MECH KB {
        repeat_rate = 50
        repeat_delay = 250
      }
      device:AT Translated Set 2 keyboard {
        repeat_rate = 50
        repeat_delay = 250
      }
      device:ELAN1010:00 04F3:3012 Touchpad {
        sensitivity = -0.4
      }

      # --[[ custom bezier curves ]]--
      bezier = cubic, 0.65, 0, 0.35, 1
      bezier = sine, 0.37, 0, 0.63, 1
      bezier = quad, 0.45, 0, 0.55, 1
      bezier = expo, 0.22, 1, 0.36, 1

      animations {
          enabled = 1
          # --        <name>        <on/off>  <time>  <bezier>  <style>
          animation = windowsIn,    1,        3,      expo,     slide
          animation = windowsOut,   1,        3,      expo,     slide
          animation = windowsMove,  1,        3,      expo
          animation = fade,         1,        3,      expo
          animation = fadeOut,      1,        3,      expo
          animation = workspaces,   1,        4,      expo,     slide
          animation = border,       1,        8,     default
      }

      general {
          # --[[ layout ]]--
          layout = dwindle
          gaps_in = 8
          gaps_out = 32
          border_size = 2

          col.active_border = rgb(${colors.base0E})
          col.inactive_border = rgb(${colors.base02})

          # --[[ mouse & cursor ]]--
          apply_sens_to_raw = 1
          cursor_inactive_timeout = 0
          no_cursor_warps = true
      }

      master {
        special_scale_factor =  0.8
        new_is_master =         false
        new_on_top =            false
        no_gaps_when_only =     false
      }

      dwindle {
        force_split = 2
      }

      misc {
        # --[[ wallpaper rendering ]]
        disable_hyprland_logo = true
        disable_splash_rendering = true

        # -- variable framerate
        vfr = false
      }
    '';
  };
}
