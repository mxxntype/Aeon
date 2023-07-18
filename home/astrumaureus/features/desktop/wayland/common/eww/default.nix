# INFO: Elkowar's wacky widgets

{
  pkgs,
  ...
}: {
  # TODO: Eww via home-managers options
  # programs.eww = {
  #   enable = true;
  #   package = pkgs.eww-wayland;
  #   configDir = ${};
  # };

  home.packages = with pkgs; [
    eww-wayland
  ];

  imports = [
    ./config.nix
  ];
}
