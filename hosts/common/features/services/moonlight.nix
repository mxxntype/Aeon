{ pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    moonlight-qt
    sunshine
  ];

  services.udev.extraRules = ''
    KERNEL=="uinput", SUBSYSTEM=="misc", OPTIONS+="static_node=uinput", TAG+="uaccess"
  '';

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 48010 ];
    allowedTCPPortRanges = [
      {
        from = 47984;
        to = 47990;
      }
    ];
    allowedUDPPorts = [ 48010 ];
    allowedUDPPortRanges = [
      {
        from = 47998;
        to = 47999;
      }
    ];
  };
}