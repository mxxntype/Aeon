# INFO: Common CLI utilities
{ pkgs, inputs, ... }: {
  imports = [
    ./bat.nix
    ./fd.nix
    ./fish.nix
    ./fzf.nix
    ./git.nix
    ./starship.nix
    ./wiki-tui.nix
    ./yazi.nix
    ./zellij
    ./nushell.nix
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.packages = with pkgs; [

    # System monitors
    htop
    bottom
    nvtop
    duf

    # Networking
    nmap
    netdiscover
    speedtest-rs
    ethtool

    # Other TUIs
    porsmo

    # Alternative implementations of the basic tools
    erdtree
    ripgrep
    killall
    sd
    tree

    # Text & image processors
    jq
    jaq
    timg
    toml2nix
    exiftool
    mpv
    hexyl # Hex viewer
    heh   # Hex editor

    # Build systems & automation
    gnumake
    comma

    # Archiving tools
    zip
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
    cava
    lolcat
    vivid

    # Secrets
    sops
    ssh-to-age

    # Terminal recording
    vhs
    asciinema

    # outputs.packages."x86_64-linux".repalette
    inputs.reddot.packages.${pkgs.system}.default
  ];
}
