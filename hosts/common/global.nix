{ inputs, outputs, pkgs, ... }: {
    imports = [
        ../common/features/boot
        ../common/features/environment.nix
        ../common/features/locale.nix
        ../common/features/network.nix
        ../common/features/nix.nix
        ../common/features/sops.nix
        ../common/features/ssh.nix
        ../common/features/console.nix
        ../common/features/zen-kernel.nix
        ../common/features/services/dnscrypt-proxy
        ../common/features/services/xdg-portal.nix
        inputs.home-manager.nixosModules.home-manager
    ] ++ (builtins.attrValues outputs.nixosModules);

    home-manager.extraSpecialArgs = { 
        inherit inputs outputs;
    };

    nixpkgs = {
        overlays = [ inputs.nuenv.overlays.nuenv ];
        config.allowUnfree = true;
    };

    environment = {
        enableAllTerminfo = true;
        systemPackages = with pkgs; [
            file
            pciutils
            usbutils
            wget
            jmtpfs
            libnotify
            (pkgs.nuenv.writeScriptBin {
                name = "aeon";
                script = /* nu */ ''
                    # Garbage-collect the system
                    def "main gc" [] {
                        print $"(ansi cyan)\n\tGarbage-collecting the system...\n(ansi reset)"
                        home-manager expire-generations 0
                        sudo nix-collect-garbage -d
                        nix store optimise
                    }

                    # Rebuild & switch to new Home-manager configuration
                    def "main rebuild home" [] {
                        print $"(ansi cyan)\n\tRebuilding Home-manager config...\n(ansi reset)"
                        do -ps {home-manager switch --flake ~/Aeon}
                    }

                    # Rebuild & switch to new Home-manager configuration
                    def "main rebuild host" [] {
                        print $"(ansi magenta)\n\tRebuilding NixOS config...\n(ansi reset)"
                        sudo nixos-rebuild switch --flake ~/Aeon
                    }

                    # Rebuild & switch to new Home-manager and NixOS configurations
                    def "main rebuild full" [] {
                        main rebuild home
                        main rebuild host
                    }

                    def main [] {}
                '';
            })
        ];
    };

    fonts.packages = with pkgs; [
        (nerdfonts.override {
            fonts = [
                "JetBrainsMono"
                "BigBlueTerminal"
                "IosevkaTerm"
            ];
        })
        corefonts
    ];

    programs = {
        traceroute.enable = true;
        dconf.enable = true;
    };

    services = {
        gvfs.enable = true;
        logind = {
            killUserProcesses = true;
            powerKey = "suspend";
        };
    };

    hardware.enableRedistributableFirmware = true;
    security.pam.services.gtklock = {};
}
