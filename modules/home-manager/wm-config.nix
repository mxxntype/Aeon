{
  lib,
  ...
}: let
  inherit (lib) mkOption types;
in
{
  options.wm-config = mkOption {
    type = types.submodule {
      options = {
        # Gaps
        gaps = mkOption {
          type = types.submodule {
            options = {
              inner = mkOption {
                type = types.int;
                default = 8;
              };
              outer = mkOption {
                type = types.int;
                default = 8;
              };
            };
          };
        };
        # Borders
        border = mkOption {
          type = types.submodule {
            options = {
              thickness = mkOption {
                type = types.int;
                default = 2;
              };
            };
          };
        };

        rounding = mkOption {
          type = types.int;
          default = 0;
        };
      };
    };
  };
}
