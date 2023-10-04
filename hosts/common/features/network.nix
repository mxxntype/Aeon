# INFO: Networking settings

{ lib, pkgs, ... }: {
  networking = {
    useDHCP = lib.mkDefault true;
    networkmanager.enable = true;

    hosts = {
      # NOTE: Replaced by Tailscale's MagicDNS
      # Reserved addresses in home WiFi
      # "192.168.68.101" = [ "Wyrm" "wyrm" ];
      # "192.168.68.111" = [ "Luna" "luna" ];
    };

    firewall = let
      alwaysOpenPorts = [
        9 # WakeOnLAN
      ];
    in {
      enable = true;
      allowedTCPPorts = alwaysOpenPorts;
      allowedUDPPorts = alwaysOpenPorts;
    };
  };

  environment.systemPackages = with pkgs; [
    wakeonlan
  ];
}
