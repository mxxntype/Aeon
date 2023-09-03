{
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    nodePackages.pyright
    python3Full
  ];
}
