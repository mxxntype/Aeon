{ config, ... }: {
    users = {
        mutableUsers = false;
        users.root = {
            hashedPasswordFile = config.sops.secrets.root-password.path;
        };
    };

    sops.secrets.root-password = {
        sopsFile = ../../common/secrets.yaml;
        neededForUsers = true;
    };
}
