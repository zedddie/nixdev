{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      runtimeLibs = with pkgs; [
        stdenv.cc.cc.lib
        zlib
        openssl
      ];
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        nativeBuildInputs =
          with pkgs;
          [
            python3
            git
            pkg-config
            openssl
            stdenv.cc.cc.lib
          ]
          ++ pkgs.rustc.src.nativeBuildInputs;
        shellHook = ''
          export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath runtimeLibs}:$LD_LIBRARY_PATH"
        '';
      };
    };
}
