# INFO: Hyprland's configuration

{ inputs, config, lib, pkgs, ... }: let
    # Colors
    inherit (config) wm-config;
    inherit (config.theme) colors;

    # Monitors
    inherit (config) monitors;
    enabledMonitors = lib.filter (m: m.enable) monitors;

    # Apps & CLI tools
    terminalName = "kitty";
    terminalCommand = "${pkgs.${terminalName}}/bin/${terminalName}";
    # FIXME: Nushell is hardcoded
    zellijWrapper = "${pkgs.nushellFull}/bin/nu --execute ${pkgs.zellij}/bin/zellij";
    zellijTerminalCommand = "${terminalCommand} ${zellijWrapper}";
    floatingTerminalClass = "${terminalName}Floating";
    floatingTerminalCommand = "${terminalCommand} --class ${floatingTerminalClass}";
    floatingZellijTerminalCommand = "${floatingTerminalCommand} ${zellijWrapper}";

    # Wrappers & prefixes
    # offloadCommand = "smart-offload"; # TODO: Fix/rework smart-offload
    # gamemodeCommand = "gamemoderun";
    GTKFileDialogEnv = "QT_QPA_PLATFORMTHEME=gtk3";

    # Wallpapers
    wallpaper-base = let
        maxDimensions = builtins.foldl' (acc: monitor: let
                maxWidth = if monitor.width > acc.width then monitor.width else acc.width;
                maxHeight = if monitor.height > acc.height then monitor.height else acc.height;
            in {
                width = maxWidth;
                height = maxHeight;
            }
        ) { width = 0; height = 0; } enabledMonitors;
    in pkgs.stdenv.mkDerivation {
        name = "hyprland-wallpaper-base00";
        buildInputs = [ pkgs.imagemagick ];
        builder = pkgs.writeScript "builder" /* shell */ ''
            source $stdenv/setup
            convert -size ${toString maxDimensions.width}x${toString maxDimensions.height} xc:#${colors.base} png:$out
        '';
    };

    # Smooth exit
    hyprexit = let
        exitDuration = 0.5;
        exitWorkspace = 11; # The '100%-empty' workspace to switch to instead of killing all windows
    in pkgs.writeShellScriptBin "hyprexit.sh" /* bash */ ''
        eww close-all
        hyprctl dispatch workspace ${toString exitWorkspace}
        swww img ${wallpaper-base.outPath} -t center --transition-duration ${toString exitDuration}
        sleep ${toString exitDuration} && hyprctl dispatch exit
    '';

    # Lockscreen
    hyprlock = let
        screenPoweroffDelay = 0.1;
    in pkgs.writeShellScriptBin "hyprlock.sh" /* bash */ ''
        KBD_LED_PATH="/sys/class/leds/asus::kbd_backlight/brightness"
        KBD_LED_PREV="$(cat $KBD_LED_PATH)"

        function lock() {
            if [[ $(pgrep gtklock) != 0 ]]; then
                hyprctl keyword input:kb_layout us,ru & # Switch layout to EN
                ${pkgs.gtklock}/bin/gtklock
                echo $KBD_LED_PREV > $KBD_LED_PATH
                brillo -I
            fi
        }

        function turn_lights_off() {
            ${pkgs.brillo}/bin/brillo -S 10
            echo 0 > $KBD_LED_PATH
            hyprctl dispatch dpms off
        }

        ${pkgs.brillo}/bin/brillo -O
        lock &
        sleep ${toString screenPoweroffDelay} && turn_lights_off
    '';

    hypridle = let
        locksreenTimeout = 120;
    in pkgs.writeShellScriptBin "hypridle.sh" /* bash */ ''
        ${pkgs.swayidle}/bin/swayidle -w \
            timeout ${toString locksreenTimeout} 'hyprlock.sh' \
            resume 'hyprctl dispatch dpms on'
    '';

    hyprsuspend = let
        keyboardBacklightRestorationTimeout = 2;
    in pkgs.writeShellScriptBin "hyprsuspend.sh" /* bash */ ''
        hyprlock.sh
        systemctl suspend && sleep ${toString keyboardBacklightRestorationTimeout}
    '';
in {
    imports = [
        ../../../apps/kitty.nix
    ];    

    home.packages = [
        hyprexit
        hyprlock
        hypridle
        hyprsuspend
    ];

    wayland.windowManager.hyprland = {
        # INFO: See modules/home-manager/hyprland.nix
        extraConfig = lib.concatStringsSep "\n" config.wayland.windowManager.hyprland.configParts;
        configParts = [
            /* shell */ ''
                # Envvars
                # env = LIBVA_DRIVER_NAME,nvidia
                # env = XDG_SESSION_TYPE,wayland
                # env = GBM_BACKEND,nvidia-drm
                # env = __GLX_VENDOR_LIBRARY_NAME,nvidia
                # env = WLR_NO_HARDWARE_CURSORS,1
                env = SWWW_TRANSITION_DURATION, 2
                env = SWWW_TRANSITION_FPS, 120
                env = SWWW_TRANSITION, left 
                ${  # INFO: Monitors
                    lib.concatStringsSep "\n" (lib.forEach enabledMonitors (m: ''
                        monitor=${m.name}, ${toString m.width}x${toString m.height}@${toString m.refreshRate}, ${toString m.x}x${toString m.y}, ${toString m.scale}
                        ${lib.optionalString (m.workspace != null)"workspace=${m.name},${m.workspace}"}
                    ''))
                }

                # Autostart
                ${ # INFO: Gamma setup
                    lib.concatStringsSep "\n" (lib.forEach enabledMonitors (m: ''
                        # exec-once = ${pkgs.wlsunset}/bin/wlsunset -t 6500 -T 6501 -g ${toString m.gamma}
                    ''))
                }
                exec-once = ${pkgs.swww}/bin/swww init
                exec-once = ${pkgs.eww-wayland}/bin/eww daemon --restart --force-wayland && eww open statusbar
                exec-once = ${hypridle}/bin/hypridle.sh
                exec-once = hyprprofile # FIXME: Package this
                exec-once = ${inputs.ndrs.packages.${pkgs.system}.default}/bin/ndrs > /tmp/ndrs.log # Custom notification daemon
                exec-once = ${pkgs.avizo}/bin/avizo-service
                exec = sleep 0.5 && ${pkgs.swww}/bin/swww img ~/.wallpaper

                # Slight randomness in border position to protect OLED screens
                # exec = hyprctl keyword general:gaps_in  $((${toString wm-config.gaps.inner} + ($RANDOM % 8)))
                # exec = hyprctl keyword general:gaps_out $((${toString wm-config.gaps.outer} + ($RANDOM % 8)))

                # Kill window | Exit or reload hyprland | Lock screen
                bind =      SUPER SHIFT, Q, killactive,
                bind = CTRL SUPER SHIFT, Q, exec, kill -9 $(hyprctl activewindow -j | jq '.pid')
                bind = CTRL SUPER SHIFT, E, exec, ${hyprexit}/bin/hyprexit.sh
                bind = CTRL SUPER SHIFT, L, exec, ${hyprlock}/bin/hyprlock.sh
                bind =      SUPER SHIFT, R, exec, hyprctl reload && eww reload

                # Screenshots | Color picker
                bind = , PRINT,        exec, ${pkgs.grimblast}/bin/grimblast copysave output
                bind = SUPER SHIFT, S, exec, ${pkgs.grimblast}/bin/grimblast copysave area
                bind = SUPER SHIFT, P, exec, ${pkgs.hyprpicker}/bin/hyprpicker --no-fancy --autocopy

                # Shift focus
                bind = SUPER, H, hy3:movefocus, l
                bind = SUPER, J, hy3:movefocus, d
                bind = SUPER, K, hy3:movefocus, u
                bind = SUPER, L, hy3:movefocus, r
                # bind = SUPER, J, layoutmsg, cyclenext
                # bind = SUPER, K, layoutmsg, cycleprev

                # Move windows within layout
                bind = SUPER SHIFT, H, hy3:movewindow, l
                bind = SUPER SHIFT, J, hy3:movewindow, d
                bind = SUPER SHIFT, K, hy3:movewindow, u
                bind = SUPER SHIFT, L, hy3:movewindow, r
                # bind = SUPER SHIFT, J, layoutmsg, swapnext
                # bind = SUPER SHIFT, K, layoutmsg, swapprev

                # Layout control
                bind = SUPER, V, exec, hyprctl dispatch hy3:makegroup v
                bind = SUPER, N, exec, hyprctl dispatch hy3:makegroup h

                # Float | fullscreen
                bind = SUPER, T, togglefloating,
                bind = SUPER, F, fullscreen,

                # Main apps
                bind = SUPER,       RETURN, exec, ${zellijTerminalCommand}
                bind = SUPER SHIFT, RETURN, exec, ${floatingZellijTerminalCommand}
                bind = SUPER,            P, exec, ${floatingTerminalCommand} ${pkgs.bottom}/bin/btm --battery
                bind = SUPER,            M, exec, ${floatingTerminalCommand} ${pkgs.alsa-utils}/bin/alsamixer
                bind = SUPER,            E, exec, ${floatingTerminalCommand} ${pkgs.yazi}/bin/yazi
                bind = SUPER SHIFT,      N, exec, ${pkgs.obsidian}/bin/obsidian --ozone-platform=wayland

                # Make the 'floating' terminal actually float
                windowrule = float, ^(${floatingTerminalClass})$
                windowrule = size 50% 70%, ^(${floatingTerminalClass})$
                windowrule = move 25% 15%, ^(${floatingTerminalClass})$

                # Workspace switching
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

                # Move focused window to workspace
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

                # Workspace-assigned apps
                bind = CTRL SHIFT, 1, exec, ${terminalCommand}
                bind = CTRL SHIFT, 2, exec, ${pkgs.inkscape}/bin/inkscape
                bind = CTRL SHIFT, 3, exec, ${pkgs.librewolf}/bin/librewolf
                bind = CTRL SHIFT, 4, exec, ${GTKFileDialogEnv} ${pkgs.telegram-desktop}/bin/telegram-desktop
                bind = CTRL SHIFT, 5, exec, ${pkgs.libreoffice}/bin/libreoffice
                bind = CTRL SHIFT, 6, exec, ${pkgs.virt-manager}/bin/virt-manager
                bind = CTRL SHIFT, 7, exec, ${pkgs.prismlauncher}/bin/prismlauncher
                bind = CTRL SHIFT, 8, exec, ${GTKFileDialogEnv} ${pkgs.keepassxc}/bin/keepassxc
                bind = CTRL SHIFT, 9, exec, ${pkgs.freetube}/bin/freetube --ozone-platform=wayland
                bind = CTRL SHIFT, o, exec, ${floatingTerminalCommand} ncmpcpp

                # Brightness
                bind = , XF86MonBrightnessUp,   exec, ${pkgs.brillo}/bin/brillo -q -A 10 -u 100000
                bind = , XF86MonBrightnessDown, exec, ${pkgs.brillo}/bin/brillo -q -U 10 -u 100000

                # Volume
                bind = SUPER SHIFT, M,         exec, ${pkgs.avizo}/bin/volumectl toggle-mute
                bind = , XF86AudioMute,        exec, ${pkgs.avizo}/bin/volumectl toggle-mute
                bind = , XF86AudioMicMute,     exec, ${pkgs.avizo}/bin/volumectl -m toggle-mute
                bind = , XF86AudioRaiseVolume, exec, ${pkgs.avizo}/bin/volumectl -u up
                bind = , XF86AudioLowerVolume, exec, ${pkgs.avizo}/bin/volumectl -u down

                # Power button
                bind = , XF86PowerOff, exec, ${hyprlock}/bin/hyprlock.sh

                # Laptop lid
                bindl = , switch:on:Lid Switch,  exec, ${hyprlock}/bin/hyprlock.sh
                bindl = , switch:off:Lid Switch, dpms, on

                # Passtrough mode
                bind = SUPER SHIFT, I, exec, hyprctl notify -1 1500 "rgb(${colors.maroon})" "Entering passthrough!"
                bind = SUPER SHIFT, I, submap, passthrough
                submap = passthrough
                bind = SUPER SHIFT, I, exec, hyprctl notify -1 1500 "rgb(${colors.mauve})" "Leaving passthrough!"
                bind = SUPER SHIFT, I, submap, reset
                submap = reset

                # Move & resize floating windows
                bindm = SUPER, mouse:272, movewindow
                bindm = SUPER, mouse:273, resizewindow
                input {
                    # Mouse
                    follow_mouse = 1
                    sensitivity = 0.4
                    touchpad {
                        natural_scroll = no
                        # disable_while_typing = false
                    }

                    # Keyboard
                    kb_layout = us, ru
                    kb_options = grp:win_space_toggle
                }

                # Per-device configuration
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

                # Custom bezier curves
                bezier = cubic, 0.65, 0, 0.35, 1
                bezier = sine, 0.37, 0, 0.63, 1
                bezier = quad, 0.45, 0, 0.55, 1
                bezier = expo, 0.22, 1, 0.36, 1

                animations {
                    enabled = 1
                    # --        <name>       <on/off> <time> <bezier> <style>
                    animation = windowsIn,   1,       3,     expo,    slide
                    animation = windowsOut,  1,       3,     expo,    slide
                    animation = windowsMove, 1,       3,     expo
                    animation = fade,        1,       3,     expo
                    animation = fadeOut,     1,       3,     expo
                    animation = workspaces,  1,       4,     expo,    slide
                    animation = border,      1,       8,     default
                }

                decoration {
                    rounding = ${toString wm-config.rounding}
                    drop_shadow = true
                    shadow_range = 16
                    col.shadow = rgb(${colors.base})

                    dim_inactive = false
                    dim_strength = 0.3

                    blur {
                        size = 4
                        passes = 3
                        brightness = 1
                        contrast = 1
                    }
                }

                general {
                    # Layout
                    layout = hy3
                    gaps_in = ${toString wm-config.gaps.inner}
                    gaps_out = ${toString wm-config.gaps.outer}
                    border_size = ${toString wm-config.border.thickness}

                    col.active_border = rgb(${colors.surface2}) rgb(${colors.subtext0}) 45deg
                    col.inactive_border = rgb(${colors.surface0})

                    # Mouse & cursor
                    apply_sens_to_raw = 1
                    cursor_inactive_timeout = 5
                    no_cursor_warps = true
                }

                # Master layout
                master {
                    special_scale_factor =  0.8
                    new_is_master =         false
                    new_on_top =            false
                    no_gaps_when_only =     false
                }

                # Dwindle layout
                dwindle {
                    force_split = 2
                }

                misc {
                    disable_hyprland_logo = true
                    disable_splash_rendering = true
                    vfr = true # Variable framerate
                    mouse_move_enables_dpms = true
                    key_press_enables_dpms = true
                    background_color = rgb(${colors.crust})
                }

                # Fix HiDPI XWayland
                xwayland {
                    force_zero_scaling = true
                }
                env = GDK_SCALE, 2
                # env = GDK_DPI_SCALE, 2

                # Blur EWW
                blurls = gtk-layer-shell

                plugin {
                    # Additional borders
                    borders-plus-plus {
                        add_borders = 2
                        # BUG: Border #1 draws weirdly for some reason, but
                        # others are OK, so `size` is set to 0 as a workaround
                        col.border_1 = rgb(${colors.base})
                        border_size_1 = 0

                        # This is the visible second border
                        col.border_2 = rgb(${colors.base})
                        border_size_2 = ${toString (wm-config.border.thickness * 2)}
                    }

                    # i3-like manual tiling for Hyprland
                    hy3 {
                        tabs = {
                            height = 16
                            padding = 8
                            rounding = ${toString wm-config.rounding}
                            render_text = true
                            text_height = 10
                            text_padding = 4

                            col.active =        rgb(${colors.mauve})
                            col.urgent =        rgb(${colors.red})
                            col.inactive =      rgb(${colors.text})
                            col.text.active =   rgb(${colors.mauve})
                            col.text.urgent =   rgb(${colors.red})
                            col.text.inactive = rgb(${colors.text})
                        }
                    }
                }

                # GTK file dialogs
                windowrulev2 = float, title:^(Open.*)$

                # Gimp
                windowrulev2 = workspace 2, class:^(.*Gimp.*)$

                # Obs studio
                windowrulev2 = workspace 2, class:^(.*obsproject.*)$

                # Librewolf
                windowrulev2 = workspace 3,                     class:^(.*librewolf.*)$
                windowrulev2 = bordercolor rgb(${colors.blue}), class:^(.*librewolf.*)$

                # Telegram
                windowrulev2 = workspace 4,                     title:^(.*Telegram.*)$
                windowrulev2 = bordercolor rgb(${colors.blue}), title:^(.*Telegram.*)$

                # Element
                windowrulev2 = workspace 4,                      title:^(.*Element.*)$
                windowrulev2 = bordercolor rgb(${colors.green}), title:^(.*Element.*)$

                # Session
                windowrulev2 = workspace 4,                      title:^(.*Session.*)$
                windowrulev2 = bordercolor rgb(${colors.green}), title:^(.*Session.*)$

                # Thunderbird
                windowrulev2 = workspace 4,                     class:^(.*thunderbird.*)$
                windowrulev2 = bordercolor rgb(${colors.blue}), class:^(.*thunderbird.*)$

                # Revolt
                windowrulev2 = workspace 4,                    class:^(.*Revolt.*)$
                windowrulev2 = bordercolor rgb(${colors.red}), class:^(.*Revolt.*)$

                # Libreoffice
                windowrulev2 = workspace 5, title:^(.*LibreOffice.*)$

                # Virt-manager
                windowrulev2 = workspace 6, class:^(.*virt-manager.*)$

                # Prismlauncher
                windowrulev2 = workspace 7,                      class:^(.*prismlauncher.*)$
                windowrulev2 = bordercolor rgb(${colors.green}), class:^(.*prismlauncher.*)$

                # KeePassXC
                windowrulev2 = workspace 8,                      class:^(.*keepassxc.*)$
                windowrulev2 = bordercolor rgb(${colors.green}), class:^(.*keepassxc.*)$

                # Freetube
                windowrulev2 = workspace 9,                         class:^(.*FreeTube.*)$
                windowrulev2 = idleinhibit fullscreen,              class:^(.*FreeTube.*)$
                windowrulev2 = bordercolor rgb(${colors.lavender}), class:^(.*FreeTube.*)$
            ''
        ];
    };
}
