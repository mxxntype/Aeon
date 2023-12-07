{ config, lib, ... }: let
    inherit (config.theme) colors;
in {
    console = {
        earlySetup = lib.mkForce true;
        colors = [
            # Normal
            "${colors.base}"
            "${colors.red}"
            "${colors.green}"
            "${colors.yellow}"
            "${colors.blue}"
            "${colors.mauve}"
            "${colors.teal}"
            "${colors.text}"
            # Bright
            "${colors.surface0}"
            "${colors.red}"
            "${colors.green}"
            "${colors.yellow}"
            "${colors.blue}"
            "${colors.mauve}"
            "${colors.teal}"
            "${colors.text}"
        ];
    };
}
