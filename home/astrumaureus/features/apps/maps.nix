# INFO: Maps

{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    pkgs.organicmaps
  ];
}
