{
  ...
}: {
  programs.adb = {
    enable = true;
  };
  users.users.astrumaureus.extraGroups = [ "adbusers" ];
}
