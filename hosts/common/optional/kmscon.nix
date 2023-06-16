# INFO: A replacement for the default Linux console

{
  pkgs,
  ...
}: {
  # WARN: KMSCon is really cool, but its development has been
  # stopped for several years now. Needa find some alternative...
  services.kmscon = {
    enable = true;

    fonts = [
      {
        name = "JetBrains Mono Nerd Font";
        package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
      }
    ];

    extraConfig = "\n
      xkb-repeat-delay=200\n
      xkb-repeat-rate=30\n
    ";
  };
}
