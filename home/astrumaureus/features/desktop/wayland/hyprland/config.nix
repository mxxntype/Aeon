# INFO: Hyprland's configuration

{
  config,
  lib,
  ...
}: let
  # Monitors
  inherit (config) monitors;
  enabledMonitors = lib.filter (m: m.enable) monitors;

  # Colors
  inherit (config.colorscheme) colors;

  # Commands
  offloadCommand = "smart-offload";
  terminalName = "kitty";
  terminalCommand = "${offloadCommand} ${terminalName}";
  disposableTerminalClass = "${terminalName}Disposable";
  disposableTerminalCommand = "${terminalCommand} --class ${disposableTerminalClass}";
in {
  imports = [
    ../../../apps/kitty.nix
  ];  

  wayland.windowManager.hyprland = {
    # TODO: Per-host monitors
    extraConfig = ''
      # --[[ Envvars ]]--
      env = LIBVA_DRIVER_NAME,nvidia
      env = XDG_SESSION_TYPE,wayland
      env = GBM_BACKEND,nvidia-drm
      env = __GLX_VENDOR_LIBRARY_NAME,nvidia
      env = WLR_NO_HARDWARE_CURSORS,1

      ${  # INFO: Monitors
        lib.concatStringsSep "\n" (lib.forEach enabledMonitors (m: ''
          monitor=${m.name}, ${toString m.width}x${toString m.height}@${toString m.refreshRate}, ${toString m.x}x${toString m.y}, 1
          ${lib.optionalString (m.workspace != null)"workspace=${m.name},${m.workspace}"}
        ''))
      }

      # --[[ Autostart ]]--
      exec-once = wlsunset -t 5000 -T 7000 -g 0.7
      exec-once = eww daemon && eww open statusbar
      exec      = swww init; sleep 0.5 && swww clear ${colors.base01}

      # --[[ Kill window | Exit / reload hyprland | Lock screen ]]--
      bind =      SUPER SHIFT,      Q, killactive,
      bind =      SUPER CTRL SHIFT, Q, exec, kill -9 $(hyprctl activewindow -j | jq '.pid')
      bind = CTRL SUPER SHIFT, E, exec, pkill wlsunset; hyprctl dispatch exit yes
      bind =      SUPER SHIFT, R, exec, hyprctl reload && eww reload

      # --[[ Shift focus ]]--
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
      bind = SUPER,       RETURN, exec, ${terminalCommand}
      bind = SUPER SHIFT, RETURN, exec, ${disposableTerminalCommand}
      bind = SUPER,       P,      exec, ${disposableTerminalCommand} btm --battery
      bind = SUPER,       M,      exec, ${disposableTerminalCommand} alsamixer
      bind = SUPER SHIFT, N,      exec, ${offloadCommand} obsidian --ozone-platform=wayland

      windowrule = float, ^(${disposableTerminalClass})$
      windowrule = size 50% 70%, ^(${disposableTerminalClass})$
      windowrule = move 25% 15%, ^(${disposableTerminalClass})$

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

      # --[[ Workspace-assigned apps ]]--
      bind = CTRL SHIFT, 1, exec, ${terminalCommand}
      bind = CTRL SHIFT, 2, exec, ${offloadCommand} gimp
      bind = CTRL SHIFT, 3, exec, ${offloadCommand} librewolf
      bind = CTRL SHIFT, 4, exec, ${offloadCommand} kotatogram-desktop
      bind = CTRL SHIFT, 5, exec, ${offloadCommand} libreoffice
      bind = CTRL SHIFT, 6, exec, ${offloadCommand} virt-manager
      bind = CTRL SHIFT, 7, exec, ${offloadCommand} prismlauncher
      bind = CTRL SHIFT, 8, exec, ${offloadCommand} keepassxc
      bind = CTRL SHIFT, 9, exec, ${offloadCommand} freetube
      bind = CTRL SHIFT, o, exec, ${disposableTerminalCommand} ncmpcpp

      # --[[ brightness ]]--
      bind = , XF86MonBrightnessUp,   exec, brillo -A 10 -u 100000
      bind = , XF86MonBrightnessDown, exec, brillo -U 10 -u 100000

      bind = SUPER SHIFT,         M,  exec, amixer -q set Master toggle
      bind = , XF86AudioMute,         exec, amixer -q set Master toggle
      bind = , XF86AudioRaiseVolume,  exec, amixer -q set Master 10%+ unmute
      bind = , XF86AudioLowerVolume,  exec, amixer -q set Master 10%- unmute

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
          # --[[ Layout ]]--
          layout = dwindle
          gaps_in = 4
          gaps_out = 16
          border_size = 2

          col.active_border = rgb(${colors.base0E})
          col.inactive_border = rgb(${colors.base02})

          # --[[ Mouse & cursor ]]--
          apply_sens_to_raw = 1
          cursor_inactive_timeout = 0
          no_cursor_warps = true
      }

      # --[[ Master layout ]]--
      master {
        special_scale_factor =  0.8
        new_is_master =         false
        new_on_top =            false
        no_gaps_when_only =     false
      }

      # --[[ Dwindle layout ]]--
      dwindle {
        force_split = 2
      }

      misc {
        # Built-in wallpaper things
        disable_hyprland_logo = true
        disable_splash_rendering = true

        # Variable framerate
        vfr = true
      }
    '';
  };
}
