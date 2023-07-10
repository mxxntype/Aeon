{
  config,
  pkgs,
  ...
}: {
  services.mpd = {
    enable = true;
    musicDirectory = "${config.home.homeDirectory}/Music";
  };

  programs.ncmpcpp = {
    enable = true;
  };

  home.packages = with pkgs; [
    mpc-cli
  ];
}
