{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    esp-rs-nix.url = "github:leighleighleigh/esp-rs-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      esp-rs-nix,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        esp-rs = esp-rs-nix.packages.${system}.esp-rs;
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            esp-rs
            espflash
            ldproxy
            pkg-config
            openssl
            libusb1
          ];

          shellHook = ''
            export RUSTUP_TOOLCHAIN="${esp-rs}"
            exec fish
          '';
        };
      }
    );
}
