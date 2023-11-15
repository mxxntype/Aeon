{ pkgs, ... }: {
  imports = [
    # ./env.nix
    ./config.nix
  ];
  
  programs.nushell = {
    enable = true;
    package = pkgs.nushellFull;
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
