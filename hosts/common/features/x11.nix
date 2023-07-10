# INFO: X.org

{
  ...
}: {
  services.xserver = {
    enable = true;

    # TODO: Move to userspace
    layout = "us";
    xkbOptions = "eurosign:e";
    autoRepeatDelay = 200;
    autoRepeatInterval = 30;

    displayManager = {
      startx.enable = true;
    };
  };
}
