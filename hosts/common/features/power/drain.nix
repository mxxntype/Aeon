{ pkgs, ... }: {
    environment.systemPackages = with pkgs; [
        (writeShellScriptBin "powerdrain" ''
            echo - | awk "{printf \"%3d\", \
            $(( \
                $(cat /sys/class/power_supply/BAT0/current_now) * \
                $(cat /sys/class/power_supply/BAT0/voltage_now) \
            )) / 1000000000000 }"
         '')
    ];
}
