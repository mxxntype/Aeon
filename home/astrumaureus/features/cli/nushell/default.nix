{ pkgs, ... }: {
  programs.nushell = {
    enable = true;
    package = pkgs.nushellFull;
    envFile.source = ./env.nu;
    configFile.source = ./config.nu;
    shellAliases = {
      lsa = "ls -a";
      cat = "bat";
      btm = "btm --battery";
    };
  };

  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };

  # Ensure with have vivid
  home.packages = with pkgs; [ vivid ];
}
