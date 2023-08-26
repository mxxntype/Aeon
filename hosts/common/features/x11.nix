# INFO: X.org

{
  pkgs,
  ...
}: {
  imports = [
    ./services/xdg-portal.nix
  ];
  services.xserver = {
    enable = true;

    # TODO: Move to userspace
    layout = "us,ru";
    xkbOptions = "grp:win_space_toggle";
    autoRepeatDelay = 200;
    autoRepeatInterval = 30;

    displayManager = {
      startx.enable = true;
    };

    libinput = {
      enable = true;

      mouse = {
        accelProfile = "flat";
      };

      touchpad = {
        accelProfile = "flat";
      };
    };
  };
}
