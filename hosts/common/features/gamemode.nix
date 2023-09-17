# INFO: Gamemode - daemon/lib combo for Linux that allows
# games to request a set of optimisations be temporarily
# applied to the host OS and/or a game process.

{
    ...
}: {
    programs.gamemode = {
        enable = true;
    };
}