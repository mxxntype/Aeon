{
  outputs,
  pkgs,
  ...
}: {
  imports = [
    ./bat.nix
    ./fish.nix
    ./git.nix
    ./starship.nix
  ];

  home.packages = with pkgs; [

    htop    # Process monitor
    bottom  # Process monitor
    nvtop   # Process monitor [GPU]

    exa     # Better `ls`
    erdtree
    ripgrep # Better `grep`
    fd      # Better `find`
    procs   # Better `ps`

    neofetch
    nitch

    jq      # JSON processor
    killall # Friendlier `kill`
    timg    # Terminal image viewer

    gnumake # Build system

    unzip   # .zip tool

    # outputs.packages."x86_64-linux".repalette

  ];
}
