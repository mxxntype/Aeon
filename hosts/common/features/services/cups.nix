{ pkgs, ... }: {
    lib.printing = {
        enable = true;
        drivers = with pkgs; [ hplipWithPlugin ];
    };
}
