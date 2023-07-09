{
  pkgs,
  ...
}: {
  imports = [
    ../../common  # X11 & Wayland commons
    ../common     # X11 commons

    ./sxhkd.nix
  ];

  xsession.windowManager.bspwm = {
    enable = true;
    startupPrograms = [
      "xrandr --output eDP-1 --gamma 0.7"
      "nvidia-offload picom --experimental-backends"
      "bspc monitor -d 1 2 3 4 5 6 7 8 9"
    ];
  };

  home.packages = with pkgs; [
    dmenu
  ];

  home.file.".xinitrc" = {
    text = ''
      #!/bin/sh

      export SXHKD_SHELL="/bin/sh"

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

      sxhkd &
      exec bspwm
    '';
    executable = true;
  };
}
