# INFO: Enables automatic system upgrades
# TODO: Figure out if I need this and how to use it then

{ config, ... }:
let
  inherit (config.networking) hostName;
in
{
  system.autoUpgrade = {
    enable = true;
    dates = "daily";
    flags = [
      "--refresh"
    ];
    flake = null;
  };
}
