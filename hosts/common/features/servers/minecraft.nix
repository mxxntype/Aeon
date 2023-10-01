# INFO: Self-hosted Minecraft!

{ inputs, pkgs, ... }: {
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];
  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

  services.minecraft-servers.servers = {
    vanilla-sample = {
      enable = true;
      package = pkgs.quiltServes.quilt-1_20_1;
    };
  };
}