# INFO: Networking settings

{ lib, ... }: {
  networking = {
    useDHCP = lib.mkDefault true;
    networkmanager.enable = true;

    hosts = {
      # Reserved addresses in home WiFi
      "192.168.68.101" = [ "Wyrm" "wyrm" ];
      "192.168.68.111" = [ "Luna" "luna" ];
    };
  };
}
