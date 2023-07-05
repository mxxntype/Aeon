# INFO: Xmonad, dynamic X11 tiling window manager

{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (config.colorscheme) colors;
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
    text = ''
      #!/bin/sh

      userresources=$HOME/.Xresources
      usermodmap=$HOME/.Xmodmap
      sysresources=/nix/store/i6fwdq3wf24ad5f0hd841nss1qfmh8il-xinit-1.4.1/etc/X11/xinit/.Xresources
      sysmodmap=/nix/store/i6fwdq3wf24ad5f0hd841nss1qfmh8il-xinit-1.4.1/etc/X11/xinit/.Xmodmap

      # merge in defaults and keymaps

      if [ -f $sysresources ]; then
          xrdb -merge $sysresources
      fi

      if [ -f $sysmodmap ]; then
          xmodmap $sysmodmap
      fi

      if [ -f "$userresources" ]; then
          xrdb -merge "$userresources"
      fi

      if [ -f "$usermodmap" ]; then
          xmodmap "$usermodmap"
      fi

      # start some nice programs

      if [ -d /nix/store/i6fwdq3wf24ad5f0hd841nss1qfmh8il-xinit-1.4.1/etc/X11/xinit/xinitrc.d ] ; then
       for f in /nix/store/i6fwdq3wf24ad5f0hd841nss1qfmh8il-xinit-1.4.1/etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f"
       done
       unset f
      fi

      trayer  --edge top \
              --align right \
              --expand true \
              --SetDockType true \
              --SetPartialStrut true \
              --transparent true \
              --alpha 0 \
              --tint 0x00${colors.base00} \
              --width 5 \
              --height 18 &
      exec xmonad
    '';
    executable = true;
  };
}
