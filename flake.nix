{
  description = "A fork of LLDB, for use with the Zig self-hosted backends";

  inputs = {
    nixpkgs.url = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    {
      overlay = final: prev: {
        lldb-zig = final.callPackage ./package.nix {};
      };
    }
    // flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
    in {
      packages =
        {default = self.packages.${system}.lldb-zig;}
        // self.overlay pkgs pkgs;
    });
}
