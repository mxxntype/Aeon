{ pkgs, ... }: {
  imports = [
    ./env.nix
    ./config.nix
  ];
  
  programs.nushell = {
    enable = true;
    package = pkgs.nushellFull;
    shellAliases = {
      lsa = "ls -a";
      cat = "bat";
      btm = "btm --battery";
      ip = "ip --color=always";
      tree = "erd --config tree";
      sz = "erd --config sz";
      duf = "duf -theme ansi";
    };
  };

  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };
}
