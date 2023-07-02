{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    upscayl
  ];
}
