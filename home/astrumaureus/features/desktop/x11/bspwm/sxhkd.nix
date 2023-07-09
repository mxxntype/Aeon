{
  ...
}: {
  services.sxhkd = {
    enable = true;

    keybindings = {
      "super + shift + q" = "bspc node -c";
      "super + ctrl + shift + q" = "bspc node -k";
      "super + ctrl + shift + e" = "bspc quit";

      "super + Return" = "nvidia-offload wezterm start --always-new-process";

      "super + {h,j,k,l}" = "bspc node -f {west,south,north,east}";
      "super + shift + {h,j,k,l}" = "bspc node -s {west,south,north,east}";

      "super + {1-9,0}" = "bspc desktop -f {1-9,10}";
      "super + shift + {1-9,0}" = "bspc node -d {1-9,10}";

      "super + t" = "bspc node -t ~floating";
      "super + f" = "bspc node -t ~fullscreen";
    };
  };
}
