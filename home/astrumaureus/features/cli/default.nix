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

    # System monitors
    htop
    bottom
    nvtop
    duf

    # Productivity
    porsmo

    # Alternative implementations of the basic tools
    exa
    erdtree
    ripgrep
    fd
    procs
    killall

    # Text & image processors
    jq
    timg

    # Build systems & automation
    gnumake

    # Archiving tools
    unzip
    unrar

    # Filesystems
    e2fsprogs
    efibootmgr

    # Fetches and other cool TUI stuff
    neofetch
    nitch
    onefetch
    cbonsai
    cmatrix
    pipes-rs

    # outputs.packages."x86_64-linux".repalette

  ];
}
