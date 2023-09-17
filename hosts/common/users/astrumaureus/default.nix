# INFO: System-level astrumaureus config

{
  pkgs,
  config,
  ...
}: let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  #T TODO: Get rid of this
  programs.fish.enable = true;

  users.users.astrumaureus = {
    isNormalUser = true;

    name = "astrumaureus";
    description = "The Almighty";
    uid = 1000;
    # gid = 100;

    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "video"
      "audio"
      "input"
    ] ++ ifTheyExist [
      "networkmanager"
      "docker"
      "git"
      "libvirtd"
    ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOvBw3klXzVq5oTXtS061cfcGEjHWflPZNRBRg48N3w/ astrumaureus@Nox"
    ];
    hashedPasswordFile = config.sops.secrets.astrumaureus-password.path;
    packages = [ pkgs.home-manager ];
  };

  sops.secrets.astrumaureus-password = {
    sopsFile = ../../secrets.yaml;
    neededForUsers = true;
  };

  home-manager.users.astrumaureus = import ../../../../home/astrumaureus/${config.networking.hostName}.nix;
}
