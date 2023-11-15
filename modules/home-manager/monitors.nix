# INFO: Monitor configuration module

{ lib, ... }: let
  inherit (lib) mkOption types;
in {
  options.monitors = mkOption {
    type = types.listOf (types.submodule {
      options = {
        enable = mkOption {
          type = types.bool;
          default = true;
        };
        name = mkOption {
          type = types.str;
          example = "eDP-1";
        };
        width = mkOption {
          type = types.int;
          example = 1920;
        };
        height = mkOption {
          type = types.int;
          example = 1080;
        };
        refreshRate = mkOption {
          type = types.int;
          default = 60;
        };
        gamma = mkOption {
          type = types.float;
          default = 1.0;
        };
        scale = mkOption {
          type = types.float;
          default = 1.0;
        };
        x = mkOption {
          type = types.int;
          default = 0;
        };
        y = mkOption {
          type = types.int;
          default = 0;
        };
        workspace = mkOption {
          type = types.nullOr types.str;
          default = null;
        };
        showBar = mkOption {
          type = types.bool;
          default = true;
        };
      };
    });
  };
}
