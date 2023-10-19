{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # qt5Full
    qtcreator
  ];
}
