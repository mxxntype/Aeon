# INFO: Xmonad, dynamic X11 tiling window manager

{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (config.theme) colors;
in {
  imports = [
    ../../common  # X11 & Wayland commons
    ../common     # X11 commons

    ./xmonad.nix  # XMonad config
    ./xmobar.nix  # XMobar config
  ];

  xsession.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
  };

  home.packages = with pkgs; [
    dmenu
    ghc   # Glasgow Haskell Compiler
  ];

  home.file.".xinitrc" = {
    text = /* sh */ ''
      #!/bin/sh
      trayer  --edge top \
              --align right \
              --expand true \
              --SetDockType true \
              --SetPartialStrut true \
              --transparent true \
              --alpha 0 \
              --tint 0x00${colors.base} \
              --width 5 \
              --height 18 &
      exec xmonad
    '';
    executable = true;
  };
}
