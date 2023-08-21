{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ../c  # Rust needs `cc` linker
  ];

  nixpkgs = {
    overlays = [
      inputs.rust-overlay.overlays.default
    ];
  };

  environment.systemPackages = with pkgs; [
    rust-bin.stable.latest.default
    cargo-watch
    # bacon
  ];
}
