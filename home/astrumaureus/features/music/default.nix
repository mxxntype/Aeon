{
  config,
  pkgs,
  ...
}: {
  services.mpd = {
    enable = true;
    musicDirectory = "${config.home.homeDirectory}/Music";
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "PipeWire Sound Server"
      }
    '';
  };

  programs.ncmpcpp = {
    enable = true;
    bindings = [
      { key = "h"; command = "previous_column"; }
      { key = "j"; command = "scroll_down"; }
      { key = "k"; command = "scroll_up"; }
      { key = "l"; command = "next_column"; }
      { key = "J"; command = [ "select_item" "scroll_down" ]; }
      { key = "K"; command = [ "select_item" "scroll_up" ]; }
    ];
  };

  home.packages = with pkgs; [
    mpc-cli
  ];
}
