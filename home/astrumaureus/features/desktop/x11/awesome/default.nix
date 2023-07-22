# INFO: AwesomeWM

{
  ...
}: {
  imports = [
    ../../common  # X11 & Wayland commons
    ../common     # X11 commons

    ../common/picom/arian8j2.nix

    ./rc.nix
    ./theme.nix
  ];

  xsession.windowManager.awesome = {
    enable = true;
  };

  home.file.".xinitrc" = {
    text = ''
      #!/bin/sh
      picom -b
      exec awesome
    '';
    executable = true;
  };
}
