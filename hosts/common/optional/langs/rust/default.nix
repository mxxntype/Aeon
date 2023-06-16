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

  environment.systemPackages = [
    pkgs.rust-bin.stable.latest.default
  ];
}
