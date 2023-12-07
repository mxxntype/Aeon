{ pkgs, ... }: {
    environment.systemPackages = with pkgs; [
        gcc
        gdb
        clang
        clang-tools
        cppcheck
        valgrind
    ];
}
