{
  description = "A fork of LLDB, for use with the Zig self-hosted backends";

  inputs = {
    nixpkgs.url = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    forSystems = nixpkgs.lib.genAttrs ["aarch64-darwin" "aarch64-linux" "x86_64-darwin" "x86_64-linux"];
  in {
    overlay = final: prev: let
      callPackage = final.lib.callPackageWith final;
    in {
      lldb-zig-full = callPackage ./package.nix {};
      lldb-zig = callPackage ./package-trimmed.nix {};
    };

    packages = forSystems (
      system: let
        pkgs = import nixpkgs {inherit system;};
        packages = self.overlay (pkgs // packages) pkgs;
      in
        {default = self.packages.${system}.lldb-zig;} // packages
    );
  };
}
