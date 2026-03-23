{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs =
    {
      self,
      nixpkgs,
      # rust-overlay,
    }:
    let
      system = "x86_64-linux";
      # overlays = [ (import rust-overlay) ];
      pkgs = import nixpkgs { inherit system; }; # overlays

      # rustVersion = pkgs.rust-bin.nightly."2026-01-21".default;

      runtimeLibs = with pkgs; [
        stdenv.cc.cc.lib
        zlib
        openssl
      ];
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          cargo
          python3
          git
          pkg-config
          openssl
        ];
        shellHook = ''
          export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath runtimeLibs}:$LD_LIBRARY_PATH";
          exec fish
        '';
      };
    };
}
