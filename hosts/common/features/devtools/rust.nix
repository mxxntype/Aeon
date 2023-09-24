{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./c.nix  # Rust needs `cc` linker
  ];

  nixpkgs = {
    overlays = [
      inputs.rust-overlay.overlays.default
    ];
  };

  environment.systemPackages = with pkgs; [
    (rust-bin.stable.latest.default.override {
      extensions = [ "rust-src" "llvm-tools-preview" ];
    })
    cargo-watch
    cargo-info
    cargo-deps
    cargo-generate
    cargo-tauri
    cargo-binutils  # LLVM tools shipped with the Rust toolchain
    bacon           # Background Rust code checker
  ];
}
