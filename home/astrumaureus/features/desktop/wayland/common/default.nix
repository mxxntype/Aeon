# INFO: Wayland commons

{ pkgs, ... }: {
  home.packages = with pkgs; [
    wl-clipboard
    wlr-randr
    wlsunset
    swww
    grim
    slurp
    gtklock
  ];

  services.avizo = {
    enable = true;
    settings = {
      default = {
        time = 1.0;
        fade-in = 0.2;
        fade-out = 0.2;
        padding = 24;
      };
    };
  };
}
