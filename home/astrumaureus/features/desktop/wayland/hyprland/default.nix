# INFO: Hyprland, the smooth wayland compositor

{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (config.colorscheme) colors;
in {
  imports = [
    inputs.hyprland.homeManagerModules.default
    ./config.nix
    ../common
    ../../common/gtk
  ];

  home.packages = with pkgs; [
    swww
    eww-wayland
    wlsunset
  ];

  xdg.configFile."eww/variables.scss" = {
    text = ''
      // --[[ background colors ]]--
      $CRUST:     #${colors.base00};
      $MANTLE:    #${colors.base00};
      $BASE:      #${colors.base00};
      $SURFACE0:  #${colors.base01};
      $SURFACE1:  #${colors.base02};

      // --[[ foreground colors ]]--
      $TEXT:      #${colors.base05};

      // --[[   accent colors   ]]--
      $RED:       #${colors.base0E};
      $MAROON:    #${colors.base0C};
      $PEACH:     #${colors.base0A};
      $YELLOW:    #${colors.base0A};
      $FLAMINGO:  #${colors.base0A};
      $ROSEWATER: #${colors.base09};
      $GREEN:     #${colors.base0D};
      $TEAL:      #${colors.base0B};
      $SKY:       #${colors.base0B};
      $SAPPHIRE:  #${colors.base08};
      $BLUE:      #${colors.base08};
      $LAVENDER:  #${colors.base0F};
      $MAUVE:     #${colors.base09};
      $PINK:      #${colors.base09};


      // --[[ fonts ]]--
      $JETBRAINS:       "JetBrains Mono Nerd Font";
      $JETBRAINS_MONO:  "JetBrains Mono Nerd Font Mono";

      // --[[ sizes ]]--
      $ICON_SIZE: 16;
    '';
  };
  
  wayland.windowManager.hyprland = {
    enable = true;
    nvidiaPatches = true;
    xwayland = {
      enable = true;
    };
  };
}
