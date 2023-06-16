{
  config,
  ...
}: {
  users.users.root = {
    passwordFile = config.sops.secrets.root-password.path;
  };

  sops.secrets.root-password = {
    sopsFile = ../../secrets.yaml;
    neededForUsers = true;
  };
}
