# INFO: KMSCon, an alternative console

{ pkgs, ... }: {
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

    # HACK: For some reason, my usual 250/50 are way too slow inside KMSCon
    extraConfig = "\n
      xkb-repeat-delay=200\n
      xkb-repeat-rate=30\n
    ";
  };
}
