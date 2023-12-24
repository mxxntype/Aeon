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

    home.packages = with pkgs; [
        # System monitors
        htop
        bottom
        nvtop  # GPU monitor
        duf    # Neat disk monitor

        # Networking
        nmap         # Port scanner
        netdiscover  # Discover hosts in LAN
        speedtest-rs # CLI internet speedtest tool in Rust
        ethtool      # For controlling network drivers and hardware

        # Other TUIs
        porsmo  # Pomodoro timer

        # Alternative implementations of the basic tools
        erdtree # Tree-like `ls` with a load of features
        ripgrep # Oxidized `grep`
        killall # Basically `pkill`
        sd      # A friendlier `sed`
        srm     # Secure `rm`

        # Text & image processors
        jq       # JSON processor
        jaq      # Its clone in Rust
        jc       # Parse output of various commands to JSON
        timg     # CLI image viewer
        toml2nix # Convert TOML to Nix
        exiftool # View EXIF metadata of files
        mpv      # Based video player
        hexyl    # Hex viewer
        heh      # Hex editor
        bc       # Arbitrary precision calculator

        # Build systems & automation
        gnumake # GNU make.
        comma   # Run any binary (with `nix-index` and `nix run`)

        # Archiving tools
        zip
        unzip
        unrar

        # Filesystems
        e2fsprogs  # Tools for creating and checking ext2/ext3/ext4 filesystems
        efibootmgr # Userspace EFI boot manager

        # Fetches and other cool TUI stuff
        neofetch
        nitch
        onefetch
        cbonsai
        cmatrix
        pipes-rs
        lolcat
        vivid    # Rich `LS_COLORS` generator (TODO: Reimplement in nix, see `nushell/env.nix`)

        # Secrets
        sops       # An editor of encrypted files (for `sops-nix`)
        ssh-to-age # Convert ED25519 SSH private keys to age keys

        # Terminal recording
        vhs
        asciinema

        # Benchmarking
        hyperfine

        # Command managers
        mprocs

        # My other flakes
        inputs.reddot.packages.${pkgs.system}.default # Search for stuff in $PATH
    ];

    programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
    };
}
