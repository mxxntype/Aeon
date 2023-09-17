{
  config,
  ...
}: {
  users.mutableUsers = false;

  users.users.root = {
    hashedPasswordFile = config.sops.secrets.root-password.path;
  };

  sops.secrets.root-password = {
    sopsFile = ../../secrets.yaml;
    neededForUsers = true;
  };
}
