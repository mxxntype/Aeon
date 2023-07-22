{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    rocketchat-desktop
  ];
}
