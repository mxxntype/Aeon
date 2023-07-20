# INFO: AwesomeWM

{
  ...
}: {
  imports = [
    ../../common  # X11 & Wayland commons
    ../common     # X11 commons

    ../common/picom/pijulius.nix
  ];

  xsession.windowManager.awesome = {
    enable = true;
  };

  xdg.configFile."awesome/rc.lua" = {
    text = builtins.readFile ./rc.lua;
    executable = false;
  };

  home.file.".xinitrc" = {
    text = ''
      #!/bin/sh
      exec awesome
    '';
    executable = true;
  };
}
