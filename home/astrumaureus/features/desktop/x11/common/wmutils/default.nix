{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    wmutils-core
    wmutils-opt
  ];
}
