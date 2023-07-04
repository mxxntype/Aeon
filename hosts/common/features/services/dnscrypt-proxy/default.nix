{
  ...
}: {
  services.dnscrypt-proxy2 = {
    enable = true;
    settings = {

      # Server filtering
      ipv4_servers = true;
      ipv6_servers = false;
      dnscrypt_servers = true;
      doh_servers = true;
      require_dnssec = true;
      require_nolog = true;
      require_nofilter = true;

      # No effect if tor is not in use
      force_tcp = false;

      timeout = 5000;
      keepalive = 30;

      # Load-balancing
      lb_strategy = "p2";
      lb_estimator = true;

      # DNS Cache
      cache = true;

      # Captive portals
      captive_portals = {
        map_file = "/etc/dnscrypt-proxy/captive_portals.txt";
      };
    };
  };
}
