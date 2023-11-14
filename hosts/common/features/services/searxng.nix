# SearXNG container, a self-hosted metasearch engine
{ config, ... }: {
  virtualisation.oci-containers.containers = {
    "searxng" = let
      port = 8080;
    in {
      image = "searxng/searxng";
      ports = [ "${toString port}:${toString port}" ];
      environment = {
        INSTANCE_NAME = "SearXNG@${toString config.networking.hostName}";
        BASE_URL = "http://localhost:${toString port}";
      };
    };
  };
}
