# Nu shell, a new type of shell
{ pkgs, ... }: {
    programs.nushell = {
        enable = true;
        package = pkgs.nushellFull;
    };
}
