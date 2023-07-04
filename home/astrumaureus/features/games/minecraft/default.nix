{
  pkgs,
  ...
}: {
  imports = [
    ./prismlaucher.nix
  ];

  home.packages = with pkgs; [

    # Tools
    packwiz

    # JDKs
    jdk17

  ];
}
