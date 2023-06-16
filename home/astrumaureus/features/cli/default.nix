{ pkgs, ... }: {
  imports = [
    ./bat.nix
    ./fish.nix
    ./git.nix
  ];
  home.packages = with pkgs; [

    htop    # Process monitor
    bottom  # Process monitor
    nvtop   # Process monitor [GPU]

    exa     # Better `ls`
    ripgrep # Better `grep`
    fd      # Better `find`
    procs   # Better `ps`

    jq      # JSON processor

  ];
}
