# INFO: Elkowar's wacky widgets

{
  config,
  pkgs,
  ...
}: let
  inherit (config.colorscheme) colors;
in {
  # TODO: Eww via home-manager options
  /* programs.eww = {
    enable = true;
    package = pkgs.eww-wayland;
    configDir = ./shit;
  }; */

  home.packages = with pkgs; [
    eww-wayland
  ];
}
