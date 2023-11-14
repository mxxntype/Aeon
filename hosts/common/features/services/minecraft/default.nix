# INFO: Self-hosted Minecraft!

_: let
  serverPort = 25565;
in {
  # NOTE: Decided to use Docker to manage the server;
  # So all this file does - just opens up the server port.
  
  # imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];
  # # nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

  # services.minecraft-servers.servers = {
  #   vanilla-sample = {
  #     enable = true;
  #     # enableReload = true;
  #     package = inputs.nix-minecraft.legacyPackages.vanillaServers.vanilla-1_20_1;
  #     jvmOpts = (import ./aikar-flags.nix) "10G";
  #     serverProperties = {
  #       server-port = serverPort;
  #       online-mode = false; # Cracked server
  #       gamemode = "survival";
  #       difficulty = "easy";
  #     };
  #     openPorts = true;
  #   };
  # };

  networking.firewall = {
    allowedTCPPorts = [ serverPort ];
    allowedUDPPorts = [ serverPort ];
  };
}
