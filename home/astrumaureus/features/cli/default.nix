# INFO: Common CLI utilities
{ pkgs, ... }: {
  imports = [
    ./bat.nix
    ./fish.nix
    ./fzf.nix
    ./git.nix
    ./starship.nix
    ./wiki-tui.nix
    ./yazi.nix
    ./zellij.nix
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
    comma

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
