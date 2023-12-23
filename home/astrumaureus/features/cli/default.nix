# INFO: Common CLI utilities

{ inputs, pkgs, ... }: {
    imports = [
        ./bat.nix
        ./cava.nix
        ./erd.nix
        ./fd.nix
        ./fish.nix
        ./fzf.nix
        ./git.nix
        ./starship.nix
        ./wiki-tui.nix
        ./yazi.nix
        ./nushell
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
        srm

        # Text & image processors
        jq
        jaq
        jc
        timg
        toml2nix
        exiftool
        mpv
        hexyl # Hex viewer
        heh     # Hex editor

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
        lolcat
        vivid

        # Secrets
        sops
        ssh-to-age

        # Terminal recording
        vhs
        asciinema

        # Benchmarking
        hyperfine

        # Command managers
        mprocs

        # outputs.packages."x86_64-linux".repalette
        inputs.reddot.packages.${pkgs.system}.default
    ];
}
