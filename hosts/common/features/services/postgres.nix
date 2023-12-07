{ config, lib, ... }: {
    services = {
        postgresql = {
            enable = true;
            ensureDatabases = [ "test_db" ];
            authentication = lib.mkOverride 10 ''
                # TYPE  DATABASE        USER            ADDRESS                 METHOD
                local   all             all                                     trust
                host    all             all             127.0.0.1/32            trust
            '';
        };
        pgadmin = {
            enable = true;
            port = 5050;
            initialEmail = "pgadmin@something.com";
            initialPasswordFile = config.sops.secrets.pgadmin-password.path;
            settings = {
                MAX_LOGIN_ATTEMPTS = 5;
            };
        };
    };

    sops.secrets.pgadmin-password = {
        sopsFile = ../../secrets.yaml;
        mode = "0440";
        owner = config.users.users.pgadmin.name;
        inherit (config.users.users.pgadmin) group;
        restartUnits = [ "pgadmin.service" ];
    };
}
