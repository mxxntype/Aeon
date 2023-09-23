# INFO: Common CLI utilities

{
  pkgs,
  ...
}: {
  imports = [
    ./bat.nix
    ./fish.nix
    ./git.nix
    ./starship.nix
    ./wiki-tui.nix
    ./zellij.nix
    ./yazi.nix
  ];

  home.packages = with pkgs; [

    # System monitors
    htop
    bottom
    nvtop
    duf

    # Other TUIs
    porsmo

    # Alternative implementations of the basic tools
    erdtree
    ripgrep
    fd
    procs
    killall

    # Text & image processors
    jq
    timg
    toml2nix

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

    # Secrets
    sops
    ssh-to-age

    # outputs.packages."x86_64-linux".repalette

  ];
}
