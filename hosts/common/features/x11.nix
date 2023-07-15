# INFO: X.org

{
  pkgs,
  ...
}: {
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
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };
}
