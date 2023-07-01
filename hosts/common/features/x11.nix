# INFO: X.org

{
  ...
}: {
  services.xserver = {
    enable = true;

    # TODO: Move to userspace
    layout = "us";
    xkbOptions = "eurosign:e";
    autoRepeatDelay = 250;
    autoRepeatInterval = 50;

    displayManager = {
      startx.enable = true;
    };
  };
}
